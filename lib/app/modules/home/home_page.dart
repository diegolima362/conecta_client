import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../courses/presenter/widgets/course_card.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore store;

  @override
  void initState() {
    super.initState();

    store = Modular.get<HomeStore>();

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cursos'),
            actions: [
              IconButton(
                onPressed: () {
                  Modular.to.pushNamed('/app/profile/');
                },
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () async {
                  await store.getData(cached: false);
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          floatingActionButton: AnimatedBuilder(
            animation: store.selectState,
            builder: (context, _) {
              final user = store.state.user.toNullable();
              final admin = user?.admin ?? false;
              return Visibility(
                visible: user != null,
                child: FloatingActionButton(
                  tooltip: admin ? 'Criar um Curso' : 'Entrar em um Curso',
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    if (admin) {
                      await Modular.to.pushNamed('/app/courses/edit/new/');
                    } else {
                      await Modular.to.pushNamed('/app/courses/join/');
                    }
                    await Future.delayed(const Duration(milliseconds: 300));
                    await store.getData(cached: false);
                  },
                ),
              );
            },
          ),
          body: ScopedBuilder<HomeStore, AppContentFailure, HomeState>(
            store: store,
            onLoading: (_) => const LoadingIndicator(),
            onError: (_, error) => EmptyCollection.error(
              message: error?.message,
            ),
            onState: (context, state) {
              if (state.courses.isEmpty) {
                return const EmptyCollection(
                  text: 'Sem Cursos Registrados',
                  icon: Icons.error_outline_sharp,
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.isMobile) {
                    return ListView.builder(
                      itemCount: state.courses.length,
                      itemBuilder: (context, index) {
                        final course = state.courses[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          height: 200,
                          child: CourseCard(
                            index: index,
                            course: course,
                            onTap: () async {
                              await Modular.to
                                  .pushNamed('/app/courses/${course.id}/');

                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              await store.getData(cached: false);
                            },
                          ),
                        );
                      },
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (constraints.maxWidth ~/ 300).toInt(),
                      childAspectRatio: 16 / 9,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];

                      return CourseCard(
                        index: index,
                        course: course,
                        onTap: () async {
                          await Modular.to
                              .pushNamed('/app/courses/${course.id}/');

                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          await store.getData(cached: false);
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
