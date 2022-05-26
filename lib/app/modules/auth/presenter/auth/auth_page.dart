import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/article_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'sign_in_page.dart';
import 'sign_up_page.dart';

class AuthPage extends HookWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 2);
    const physics = NeverScrollableScrollPhysics();

    return Scaffold(
      appBar: AppBar(title: const Text('Conecta')),
      body: LayoutBuilder(
        builder: (context, constraints) => TabBarView(
          controller: controller,
          physics: physics,
          children: [
            ArticleContent(
              maxWidth: constraints.isMobile ? constraints.maxWidth : 600,
              child: constraints.isMobile
                  ? SignInPage(
                      onPageChanged: () => controller.animateTo(1),
                    )
                  : Card(
                      color: context.colors.surfaceVariant.withAlpha(75),
                      margin: const EdgeInsets.all(24),
                      child: SignInPage(
                        onPageChanged: () => controller.animateTo(1),
                      ),
                    ),
            ),
            ArticleContent(
              maxWidth: constraints.isMobile ? constraints.maxWidth : 600,
              child: constraints.isMobile
                  ? SignUpPage(
                      onPageChanged: () => controller.animateTo(0),
                    )
                  : Card(
                      margin: const EdgeInsets.all(24),
                      color: context.colors.surfaceVariant.withAlpha(75),
                      child: SignUpPage(
                        onPageChanged: () => controller.animateTo(0),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
