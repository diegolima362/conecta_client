import 'package:conecta/app/core/core_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/adapters/secure_storage.dart';
import 'external/datasources/auth_datasource.dart';
import 'infra/repositories/auth_repository.dart';
import 'presenter/auth/auth_page.dart';
import 'presenter/auth/login_store.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => const FlutterSecureStorage(), export: true),
    Bind.lazySingleton((i) => SecureStorage(i()), export: true),

    // datasources
    Bind.singleton((i) => AuthDatasource(i(), i()), export: true),

    // repositories
    Bind.singleton((i) => AuthRepository(i()), export: true),

    // usecases
    Bind.singleton((i) => GetLoggedUser(i()), export: true),

    Bind.singleton((i) => SignInWithUserAndPassword(i())),
    Bind.singleton((i) => SignUp(i())),

    Bind.singleton((i) => Logout(i()), export: true),

    //stores
    TripleBind.singleton((i) => LoginStore(
          authStore: i(),
          signInUsecase: i(),
          signUpUsecase: i(),
        )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const AuthPage()),
  ];
}
