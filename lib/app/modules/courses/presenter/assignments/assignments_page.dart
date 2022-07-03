import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'assignments_store.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late final AssignmentsStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get();

    final courseId = int.tryParse(Modular.to.path
            .split('/courses/')
            .last
            .split('/assignments/')
            .first) ??
        0;
    store.getData(courseId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        floatingActionButton: AnimatedBuilder(
          animation: store.selectState,
          builder: (context, _) => Visibility(
            visible: store.isOwner,
            child: FloatingActionButton(
              tooltip: 'Criar Atividade',
              onPressed: () {
                Modular.to.pushNamed(
                  '/app/courses/${store.state.course.toNullable()?.id ?? 0}/assignments/edit/',
                  forRoot: true,
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        body: ScopedBuilder<AssignmentsStore, AppContentFailure,
            AssignmentsStoreState>(
          store: store,
          onLoading: (_) => const LoadingIndicator(),
          onError: (_, error) => EmptyCollection.error(message: ''),
          onState: (context, state) {
            if (state.assignments.isEmpty) {
              return const EmptyCollection(
                text: "Sem Atividades Registradas!",
                icon: Icons.assignment_outlined,
              );
            }

            return ArticleContent(
              child: ListView.builder(
                itemCount: state.assignments.length,
                itemBuilder: (context, index) {
                  final assignment = state.assignments[index];

                  return ListTile(
                    onTap: () {
                      Modular.to.pushNamed(
                        '/app/courses/${assignment.courseId}/assignments/details/',
                        arguments: [assignment, store.isOwner],
                        forRoot: true,
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: context.colors.primary,
                      child: const Icon(Icons.assignment_outlined),
                    ),
                    title: Text(assignment.title),
                    subtitle: Text(
                      'Data de entrega: ${assignment.dueDate.fullDate}',
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }
}
