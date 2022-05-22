import 'package:conecta/app/core/domain/extensions/extensions.dart';
import 'package:conecta/app/core/presenter/stores/prefs_store.dart';
import 'package:conecta/app/core/presenter/widgets/widgets.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/errors/errors.dart';
import 'package:conecta/app/modules/auth/domain/usecases/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart' as fpdart;

import 'profile_body.dart';
import 'profile_header.dart';
import 'profile_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final store = Modular.get<ProfileStore>();

  @override
  void initState() {
    super.initState();

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(),
        body:
            ScopedBuilder<ProfileStore, AuthFailure, fpdart.Option<UserEntity>>(
          store: store,
          onError: (_, error) => EmptyCollection.error(message: error?.message),
          onLoading: (context) => const LoadingIndicator(),
          onState: (context, state) {
            final profile = state.toNullable();

            if (profile == null) {
              return EmptyCollection.error();
            } else {
              return ArticleContent(
                maxWidth: constraints.isMobile ? constraints.maxWidth : 600,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Center(
                              child: Hero(
                                tag: 'ProfileAvatar',
                                child: ProfileHeader(profile: profile),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ProfileBody(profile: profile),
                          ],
                        ),
                      ),
                      const Divider(height: 8),
                      ListTile(
                        title: const Text('Sair'),
                        trailing: const Icon(Icons.logout_outlined),
                        onTap: () async => await signOut(context),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
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
            onPressed: _signOut,
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    Navigator.pop(context);

    await Modular.get<PreferencesStore>().setTheme(ThemeMode.system);

    await Modular.get<ILogout>().call();

    Modular.to.navigate('/');
  }
}
