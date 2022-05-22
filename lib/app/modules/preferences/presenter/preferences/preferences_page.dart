import 'package:conecta/app/core/presenter/stores/prefs_store.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/auth/domain/usecases/usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/erros/erros.dart';
import '../widgets/widgets.dart';

const themeNames = <ThemeMode, String>{
  ThemeMode.light: 'Claro',
  ThemeMode.dark: 'Escuro',
  ThemeMode.system: 'Pelo sistema',
};

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<PreferencesStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('CONFIGURACÕES')),
      body:
          ScopedBuilder<PreferencesStore, PreferencesFailure, PreferencesState>(
        store: store,
        onLoading: (_) => const LoadingIndicator(),
        onError: (_, __) => EmptyCollection.error(
          message: 'Erro ao obter Configurações',
        ),
        onState: (context, state) {
          return ListView(
            children: [
              const SectionTitle(text: 'Aparência'),
              ListTile(
                title: const Text('Tema'),
                subtitle: Text(themeNames[state.themeMode] ?? ''),
                onTap: () => showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (context) => ThemeSelector(
                    initialValue: state.themeMode,
                    onThemeSelected: store.setTheme,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Cor de destaque'),
                trailing: ColorContainer(colorValue: state.seedColor),
                onTap: () => showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) => ThemeColorSelector(
                    initialValue: state.seedColor,
                    onColorSelected: Modular.get<PreferencesStore>().setColor,
                  ),
                ),
              ),
              const Divider(height: 0),
              const SectionTitle(text: 'Sobre'),
              ListTile(
                title: const Text('Sobre o APP'),
                onTap: () => showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (context) => const CustomAboutDialog(),
                ),
              ),
              ListTile(
                title: const Text('Apoie o projeto'),
                onTap: () {
                  launchUrl(
                    Uri.parse('https://github.com/diegolima362'),
                  );
                },
              ),
              ListTile(
                title: const Text('Veja como fui feito'),
                onTap: () {
                  launchUrl(
                    Uri.parse('https://github.com/diegolima362'),
                  );
                },
              ),
              ListTile(
                title: const Text('Entre em contato'),
                onTap: () {
                  final emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'suporte362devs@gmail.com',
                    query: encodeQueryParameters(
                      {'subject': 'Contato sobre o app 📧'},
                    ),
                  );

                  launchUrl(emailLaunchUri);
                },
              ),
              const Divider(height: 0),
              const SectionTitle(text: 'Conta'),
              ListTile(
                title: const Text('Sair'),
                trailing: const Icon(Icons.logout_outlined),
                onTap: () async => await signOut(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> signOut(BuildContext context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que quer sair?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Sair'),
            onPressed: () async {
              await Future.wait([
                Modular.get<PreferencesStore>().clearData(),
                Modular.get<ILogout>().call(),
              ]);

              Modular.to.pop();
              Modular.to.navigate('/');
            },
          ),
        ],
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
