import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:conecta/app/core/presenter/widgets/filled_button.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import 'feed_store.dart';

class EditPostPage extends HookWidget {
  final PostEntity? post;
  const EditPostPage({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: post?.title ?? '');
    final bodyController = useTextEditingController(text: post?.content ?? '');
    final filled = useState(false);

    final store = Modular.get<FeedStore>();

    return Scaffold(
      appBar: AppBar(),
      body: ArticleContent(
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Título'),
                    controller: titleController,
                    validator: (text) =>
                        (text?.isEmpty ?? true) ? 'Informe um título' : null,
                    onChanged: (value) {
                      filled.value = bodyController.text.isNotEmpty &&
                          titleController.text.isNotEmpty;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8.0),
                    child: Text(
                      'Conteúdo',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  MarkdownTextInput(
                    (value) {
                      bodyController.text = value;
                      filled.value = bodyController.text.isNotEmpty &&
                          titleController.text.isNotEmpty;
                    },
                    bodyController.text,
                    maxLines: null,
                    actions: MarkdownType.values,
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: filled,
                    builder: (context, _) {
                      return FilledButton(
                        context,
                        onPressed: filled.value
                            ? () async {
                                FocusScope.of(context).unfocus();

                                Navigator.of(context).pop();

                                if (post != null) {
                                  await store.editPost(
                                      post!.id,
                                      titleController.text,
                                      bodyController.text);
                                } else {
                                  await store.createPost(titleController.text,
                                      bodyController.text);
                                }
                              }
                            : null,
                        child: const Text('Salvar'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
