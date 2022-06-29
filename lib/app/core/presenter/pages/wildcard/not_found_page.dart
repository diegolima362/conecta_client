import 'package:conecta/app/core/domain/extensions/build_context_extensions.dart';
import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ArticleContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '404',
                style: context.textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pagina Não Encontrada!',
                style: context.textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: () {
                Modular.to.navigate('/');
              },
              child: const Text('Voltar à Civilização!'),
            ),
          ],
        ),
      ),
    );
  }
}
