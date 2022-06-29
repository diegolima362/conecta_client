import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/modules/courses/domain/entities/assignment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class AssignmentDetailsPage extends StatelessWidget {
  final AssignmentEntity assignment;

  const AssignmentDetailsPage({Key? key, required this.assignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Editar lembrete',
            icon: const Icon(Icons.edit),
            onPressed: () {
              Modular.to.pop();
              Modular.to.pushNamed(
                '/root/alerts/reminder/edit/',
                arguments: {
                  'reminder': assignment,
                  'course': assignment.courseName
                },
                forRoot: true,
              );
            },
          ),
          IconButton(
            tooltip: 'Apagar lembrete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remover lembrete'),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text('Remover'),
                      onPressed: () => Navigator.of(context).pop(true),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
              child: Text(
                assignment.courseName,
                style: textTheme.bodySmall,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              assignment.title,
              style: textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                Text(assignment.dueDate.fullDate, style: textTheme.bodySmall),
          ),
          const Divider(height: 0),
          Expanded(
            child: Markdown(
              selectable: true,
              onTapLink: (a, b, c) {
                if (b != null) launchUrl(Uri.parse(b));
              },
              data: assignment.content,
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
      ),
    );
  }
}
