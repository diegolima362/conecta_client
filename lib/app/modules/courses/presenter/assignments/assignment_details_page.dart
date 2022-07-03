import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:conecta/app/core/presenter/widgets/filled_button.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'assignments_store.dart';
import 'submissions/submissions_store.dart';

class AssignmentDetailsPage extends StatefulWidget {
  final AssignmentEntity assignment;
  final bool isOwner;

  const AssignmentDetailsPage({
    Key? key,
    required this.assignment,
    required this.isOwner,
  }) : super(key: key);

  @override
  State<AssignmentDetailsPage> createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage> {
  late final AssignmentsStore assignmentsStore;
  late final SubmissionsStore submissionsStore;
  @override
  void initState() {
    super.initState();

    assignmentsStore = Modular.get();
    submissionsStore = Modular.get();

    if (!widget.isOwner) {
      submissionsStore.getSubmission(widget.assignment.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.isOwner) ...[
            IconButton(
              tooltip: 'Ver Submissões',
              icon: const Icon(Icons.assignment_ind_outlined),
              onPressed: () {
                Modular.to.pop();
                Modular.to.pushNamed(
                  '/app/courses/${widget.assignment.courseId}/assignments/submissions/',
                  arguments: widget.assignment,
                  forRoot: true,
                );
              },
            ),
            IconButton(
              tooltip: 'Editar atividade',
              icon: const Icon(Icons.edit),
              onPressed: () {
                Modular.to.pop();
                Modular.to.pushNamed(
                  '/app/courses/${widget.assignment.courseId}/assignments/edit/',
                  arguments: widget.assignment,
                  forRoot: true,
                );
              },
            ),
            IconButton(
              tooltip: 'Apagar atividade',
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remover atividade'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Remover'),
                        onPressed: () {
                          assignmentsStore.deleteAssignment(widget.assignment);
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                );

                if (result ?? false) {
                  // await store.removeReminder(assignment.id);
                  // await store.getData(null);
                  Modular.to.pop();
                }
              },
            ),
          ],
        ],
      ),
      body: ArticleContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Data de entrega: ${widget.assignment.dueDate.fullDate}',
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.assignment.title,
                  style: textTheme.headlineMedium,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${widget.assignment.grade} pontos',
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: Markdown(
                selectable: true,
                onTapLink: (a, b, c) {
                  if (b != null) launchUrl(Uri.parse(b));
                },
                data: widget.assignment.content,
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
              ),
            ),
            if (!widget.isOwner) ...[
              const Divider(height: 0),
              AnimatedBuilder(
                animation: submissionsStore.selectState,
                builder: (context, _) {
                  final submission =
                      submissionsStore.state.userSubmission.toNullable();

                  if (submission == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  submission.status.format(),
                                  style: context.textTheme.titleMedium,
                                ),
                                if (submission.grade != null)
                                  Text(
                                    'Nota: ${submission.grade}',
                                    style: context.textTheme.bodyMedium,
                                  ),
                              ],
                            ),
                            if (submission.status != SubmissionStatus.pending)
                              TextButton.icon(
                                onPressed: () async {
                                  await submissionsStore
                                      .cancelSubmission(widget.assignment.id);
                                },
                                icon: const Icon(
                                    Icons.cancel_schedule_send_outlined),
                                label: const Text('Cancelar Envio'),
                              )
                            else
                              TextButton.icon(
                                onPressed: () async {
                                  await submissionsStore
                                      .markAsDone(widget.assignment.id);
                                },
                                icon: const Icon(Icons.done_all),
                                label: const Text('Marcar como Feita'),
                              ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: FilledButton(
                            context,
                            onPressed: () {
                              Modular.to.pushNamed(
                                '/app/courses/${submission.courseId}/assignments/submissions/details/',
                                arguments: [
                                  submission,
                                  widget.assignment,
                                  false
                                ],
                                forRoot: true,
                              );
                            },
                            child: const Text('Seu trabalho'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
