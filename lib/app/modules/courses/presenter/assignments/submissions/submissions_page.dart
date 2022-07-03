import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/assignment_entity.dart';
import 'package:conecta/app/modules/courses/domain/entities/assignment_submission_entity.dart';
import 'package:conecta/app/modules/courses/presenter/assignments/submissions/submission_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'submissions_store.dart';

class SubmissionsPage extends StatefulWidget {
  final AssignmentEntity assignment;

  const SubmissionsPage({super.key, required this.assignment});

  @override
  State<SubmissionsPage> createState() => _SubmissionsPageState();
}

class _SubmissionsPageState extends State<SubmissionsPage> {
  late final SubmissionsStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get();

    store.getData(widget.assignment.courseId, widget.assignment.id);
  }

  final selected = ValueNotifier<AssignmentSubmissionEntity?>(null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(title: const Text('Envios')),
        body: ScopedBuilder<SubmissionsStore, AppContentFailure,
            SubmissionsStoreState>(
          store: store,
          onLoading: (_) => const LoadingIndicator(),
          onError: (_, error) => EmptyCollection.error(message: ''),
          onState: (context, state) {
            if (state.submissions.isEmpty) {
              return const EmptyCollection(
                text: "Sem Envios Registrados!",
                icon: Icons.assignment_outlined,
              );
            }

            if (constraints.isMobile) {
              return ListView.builder(
                itemCount: state.submissions.length,
                itemBuilder: (context, index) {
                  final submission = state.submissions[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(submission.studentName),
                      subtitle: Text(
                        'Entrega: ${submission.finishDate?.fullDate ?? '-'}',
                      ),
                      onTap: () {
                        final url =
                            '/app/courses/${submission.courseId}/assignments/submissions/details/';

                        Modular.to.pushNamed(
                          url,
                          arguments: [submission, widget.assignment, true],
                          forRoot: true,
                        );
                      },
                    ),
                  );
                },
              );
            }

            return Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Alunos',
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.submissions.length,
                          itemBuilder: (context, index) {
                            final submission = state.submissions[index];

                            return ListTile(
                              title: Text(
                                submission.studentName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(submission.status.format()),
                              onTap: () => selected.value = submission,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: AnimatedBuilder(
                    animation: selected,
                    builder: (context, _) {
                      final submission = selected.value;

                      if (submission == null) {
                        return const EmptyCollection(
                          text: 'Selecione uma atividade',
                          icon: Icons.assignment_outlined,
                        );
                      }

                      return SubmissionDetailsPage(
                        key: Key(submission.hashCode.toString()),
                        submission: submission,
                        embedPage: true,
                        assignment: widget.assignment,
                        isOwner: true,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
