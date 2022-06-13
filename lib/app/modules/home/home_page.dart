import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
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
            ],
          ),
          body: ScopedBuilder<HomeStore, AppContentFailure, List<CourseEntity>>(
            store: store,
            onLoading: (_) => const LoadingIndicator(),
            onError: (_, error) => EmptyCollection.error(
              message: error?.message,
            ),
            onState: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.isMobile) {
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final course = state[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          height: 200,
                          child: CourseCard(
                            course: course,
                            onTap: () => Modular.to
                                .pushNamed('/app/courses/${course.id}/'),
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
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final course = state[index];

                      return CourseCard(
                        course: course,
                        onTap: () =>
                            Modular.to.pushNamed('/app/courses/${course.id}/'),
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
