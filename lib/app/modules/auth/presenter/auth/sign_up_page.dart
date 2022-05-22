import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/user_info.dart';
import 'login_store.dart';

class SignUpPage extends HookWidget {
  final VoidCallback onPageChanged;

  const SignUpPage({Key? key, required this.onPageChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<LoginStore>();

    final emailController = useTextEditingController();
    final emailFocus = useFocusNode();

    final nameController = useTextEditingController();
    final nameFocus = useFocusNode();

    final usernameController = useTextEditingController();
    final usernameFocus = useFocusNode();

    final passwordController = useTextEditingController();
    final passwordFocus = useFocusNode();

    final confirmPasswordController = useTextEditingController();
    final confirmPasswordFocus = useFocusNode();

    final dobController = useState(DateTime.now());

    final filled = useState(false);

    final index = useState(0);

    const lastIndex = 2;

    void updateState() {
      filled.value = nameController.text.isNotEmpty &&
          usernameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          (passwordController.text == confirmPasswordController.text);
    }

    void createUseFromState() {
      final user = UserInfo(
        name: nameController.text,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        dob: dobController.value,
      );

      store.signUp(user);
    }

    return WillPopScope(
      onWillPop: () async {
        if (index.value == 0) {
          return true;
        } else {
          index.value--;
          return false;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Cadastre-se',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Stepper(
              currentStep: index.value,
              controlsBuilder: (_, details) {
                return Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: details.onStepCancel,
                        child: Text(
                            details.stepIndex == 0 ? 'Cancelar' : 'Voltar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: details.stepIndex == lastIndex
                          ? FilledButton(
                              context,
                              onPressed: filled.value
                                  ? () => createUseFromState()
                                  : null,
                              child: const Text('Cadastrar-se'),
                            )
                          : OutlinedButton(
                              onPressed: details.onStepContinue,
                              child: const Text('Próximo'),
                            ),
                    ),
                  ],
                );
              },
              onStepContinue: () async {
                if (index.value == lastIndex) {
                  createUseFromState();
                } else {
                  index.value++;
                }
              },
              onStepCancel: () => index.value == 0
                  ? Navigator.of(context).pop()
                  : index.value--,
              onStepTapped: (i) => index.value = i,
              steps: [
                Step(
                  isActive: index.value >= 0,
                  title: const Text('Informações'),
                  state:
                      index.value > 0 ? StepState.complete : StepState.indexed,
                  content: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Nome'),
                          controller: nameController,
                          focusNode: nameFocus,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => updateState(),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(emailFocus),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 4),
                          child: Text(
                            'Data de nascimento',
                            style: context.textTheme.labelMedium,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              useRootNavigator: false,
                              initialDate: dobController.value,
                              firstDate: DateTime(0),
                              lastDate: DateTime.now(),
                              initialEntryMode: DatePickerEntryMode.calendar,
                            );
                            if (picked != null) {
                              dobController.value = picked;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dobController.value.simpleDate
                                        .toUpperCase(),
                                  ),
                                ),
                                const Icon(Icons.calendar_month),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  isActive: index.value >= 1,
                  title: const Text('Login'),
                  state:
                      index.value > 1 ? StepState.complete : StepState.indexed,
                  content: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nome de usuário',
                          ),
                          controller: usernameController,
                          focusNode: usernameFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          onChanged: (_) => updateState(),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(passwordFocus),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          controller: emailController,
                          focusNode: emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => index.value = index.value++,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  isActive: index.value >= 2,
                  title: const Text('Senha'),
                  state:
                      index.value > 2 ? StepState.complete : StepState.indexed,
                  content: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Senha'),
                          obscureText: true,
                          controller: passwordController,
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => updateState(),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(confirmPasswordFocus),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Confirmar a senha'),
                          obscureText: true,
                          controller: confirmPasswordController,
                          focusNode: confirmPasswordFocus,
                          textInputAction: TextInputAction.done,
                          validator: (text) {
                            return text == passwordController.text
                                ? null
                                : 'Senhas Diferentes!';
                          },
                          onChanged: (_) => updateState(),
                          onEditingComplete: () => createUseFromState(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já possui uma conta?'),
                  TextButton(
                    onPressed: onPageChanged,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
