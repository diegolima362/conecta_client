import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import 'feed_store.dart';

class PostDetailsPage extends StatelessWidget {
  final PostEntity post;

  const PostDetailsPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<FeedStore>();

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (store.isOwner) ...[
            IconButton(
              tooltip: 'Editar post',
              icon: const Icon(Icons.edit),
              onPressed: () {
                Modular.to.pop();
                Modular.to.pushNamed(
                  '/app/courses/${post.courseId}/feed/edit/',
                  arguments: post,
                  forRoot: true,
                );
              },
            ),
            IconButton(
              tooltip: 'Apagar post',
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remover post'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Remover'),
                        onPressed: () {
                          store.deletePost(post);
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
                padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
                child: Text(
                  post.courseTitle,
                  style: textTheme.bodySmall,
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                post.title,
                style: textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:
                  Text(post.creationDate.fullDate, style: textTheme.bodySmall),
            ),
            const Divider(height: 0),
            Expanded(
              child: Markdown(
                selectable: true,
                onTapLink: (a, b, c) {
                  if (b != null) launchUrl(Uri.parse(b));
                },
                data: post.content,
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
      ),
    );
  }
}
