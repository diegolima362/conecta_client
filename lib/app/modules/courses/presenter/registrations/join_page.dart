import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'registrations_store.dart';

class JointCoursePage extends HookWidget {
  const JointCoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFocus = useFocusNode();
    final textController = useTextEditingController();

    final filled = useState(false);

    final store = Modular.get<RegistrationsStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar com Código'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ArticleContent(
          maxWidth: constraints.isMobile ? constraints.maxWidth : 600,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Código'),
                    focusNode: textFocus,
                    controller: textController,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) =>
                        filled.value = textController.text.isNotEmpty,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();

                      if (textController.text.isNotEmpty) {
                        store.joinCourse(textController.text);

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: filled,
                    builder: (context, _) {
                      return FilledButton(
                        context,
                        onPressed: filled.value
                            ? () {
                                FocusScope.of(context).unfocus();
                                store.joinCourse(textController.text);
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: const Text('Participar'),
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
