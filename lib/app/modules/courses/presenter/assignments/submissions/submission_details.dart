import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'submissions_store.dart';

class SubmissionDetailsPage extends HookWidget {
  final AssignmentEntity assignment;
  final AssignmentSubmissionEntity submission;

  final bool embedPage;
  final bool isOwner;

  const SubmissionDetailsPage({
    Key? key,
    required this.submission,
    required this.assignment,
    this.embedPage = false,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<SubmissionsStore>();

    final textTheme = Theme.of(context).textTheme;

    final gradeController =
        useTextEditingController(text: (submission.grade ?? '').toString());
    final filled = useState(false);

    return Scaffold(
      appBar: !embedPage ? AppBar() : null,
      floatingActionButton: Visibility(
        visible: !isOwner,
        child: FloatingActionButton(
          tooltip: 'Editar',
          child: const Icon(Icons.edit),
          onPressed: () async {
            await Modular.to.pushNamed(
              '/app/courses/${assignment.courseId}/assignments/submissions/submit/',
              forRoot: true,
              arguments: [assignment, submission],
            );

            store.getSubmission(assignment.id);
          },
        ),
      ),
      body: ArticleContent(
        child: AnimatedBuilder(
          animation: store.selectState,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isOwner) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
                    child: Text(
                      submission.studentName,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Entrega: ${submission.finishDate?.fullDate ?? '-'}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
                    child: Text(
                      assignment.title,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Data de entrega: ${assignment.dueDate.fullDate}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    submission.status.format().toUpperCase(),
                    style: textTheme.labelLarge,
                  ),
                ),
                if (isOwner)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 48,
                            maxWidth: 100,
                          ),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Pontuação'),
                            keyboardType: TextInputType.number,
                            controller: gradeController,
                            onChanged: (_) {
                              final grade = int.tryParse(gradeController.text);
                              filled.value = grade != null &&
                                  grade >= 0 &&
                                  grade <= assignment.grade;
                            },
                            validator: (text) {
                              final grade = int.tryParse(gradeController.text);

                              return (text?.isEmpty ?? true) &&
                                      grade != null &&
                                      grade >= 0 &&
                                      grade <= assignment.grade
                                  ? 'Informe uma pontuação válida'
                                  : null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedBuilder(
                          animation: filled,
                          builder: (context, _) {
                            return FilledButton(
                              context,
                              onPressed: filled.value
                                  ? () async {
                                      store.returnSubmission(
                                        submission.id,
                                        int.tryParse(gradeController.text) ?? 0,
                                      );
                                    }
                                  : null,
                              child: const Text('Devolver'),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      '${submission.grade ?? 'Sem Nota'}',
                      style: textTheme.titleLarge,
                    ),
                  ),
                const SizedBox(height: 16),
                const Divider(height: 0),
                Expanded(
                  child: Markdown(
                    selectable: true,
                    onTapLink: (a, b, c) {
                      if (b != null) launchUrl(Uri.parse(b));
                    },
                    data: submission.content,
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      [
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
