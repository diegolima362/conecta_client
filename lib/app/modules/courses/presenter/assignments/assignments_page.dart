import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'assignments_store.dart';

class AssignmentsPage extends StatefulWidget {
  final int courseId;

  const AssignmentsPage({super.key, required this.courseId});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late final AssignmentsStore store;
  @override
  void initState() {
    super.initState();
    store = Modular.get();

    store.getData(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        floatingActionButton: Visibility(
          visible: true,
          child: FloatingActionButton(
            tooltip: 'Adicionar Atividade',
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
        body: ScopedBuilder<AssignmentsStore, AppContentFailure,
            List<AssignmentEntity>>(
          store: store,
          onLoading: (_) => const LoadingIndicator(),
          onError: (_, error) => EmptyCollection.error(message: ''),
          onState: (context, state) {
            if (state.isEmpty) {
              return const EmptyCollection(
                text: "Sem Atividades Registradas!",
                icon: Icons.assignment_outlined,
              );
            }

            return ArticleContent(
              child: ListView.separated(
                itemCount: state.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final assignment = state[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedCard(
                      child: ListTile(
                        title: Text(assignment.title),
                        subtitle:
                            Text('Entrega: ${assignment.dueDate.fullDate}'),
                      ),
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
