import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'login_store.dart';

class SignInPage extends HookWidget {
  final VoidCallback onPageChanged;

  const SignInPage({Key? key, required this.onPageChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userFocus = useFocusNode();
    final pwdFocus = useFocusNode();
    final userController = useTextEditingController();
    final pwdController = useTextEditingController();

    final showPwd = useState(false);

    final filled = useState(false);

    final store = Modular.get<LoginStore>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Entrar',
                style: context.textTheme.headlineSmall,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Usuário'),
              focusNode: userFocus,
              controller: userController,
              textInputAction: TextInputAction.next,
              onChanged: (_) => filled.value = userController.text.isNotEmpty &&
                  pwdController.text.isNotEmpty,
              onEditingComplete: () => FocusScope.of(context).requestFocus(
                pwdFocus,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: Visibility(
                  visible: pwdController.text.isNotEmpty,
                  child: IconButton(
                    onPressed: () => showPwd.value = !showPwd.value,
                    icon: Icon(
                      !showPwd.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              obscureText: !showPwd.value,
              controller: pwdController,
              focusNode: pwdFocus,
              textInputAction: TextInputAction.done,
              onChanged: (_) => filled.value = userController.text.isNotEmpty &&
                  pwdController.text.isNotEmpty,
              onEditingComplete: () async {
                FocusScope.of(context).unfocus();

                if (pwdController.text.isNotEmpty) {
                  await store.signInWithUserAndPassword(
                    userController.text,
                    pwdController.text,
                  );
                }
              },
              validator: (text) => (text?.isEmpty ?? true)
                  ? 'Senha deve possuir 8 caracteres'
                  : null,
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
                          await store.signInWithUserAndPassword(
                            userController.text,
                            pwdController.text,
                          );
                        }
                      : null,
                  child: const Text('Entrar'),
                );
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta?'),
                    TextButton(
                      onPressed: onPageChanged,
                      child: const Text('Cadastre-se'),
                    ),
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
