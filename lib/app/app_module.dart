import 'package:conecta/app/core/presenter/pages/wildcard/not_found_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';

import 'core/core_module.dart';
import 'core/presenter/stores/auth_store.dart';
import 'modules/auth/auth_module.dart';
import 'modules/courses/courses_module.dart';
import 'modules/home/home_page.dart';
import 'modules/home/home_store.dart';
import 'modules/preferences/preferences_module.dart';
import 'modules/profile/profile_page.dart';
import 'modules/profile/profile_store.dart';
import 'modules/root/root_page.dart';
import 'modules/root/root_store.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
        PreferencesModule(),
        CoursesModule(),
        AuthModule(),
      ];

  @override
  List<Bind> get binds => [
        TripleBind.singleton((i) => RootStore()),
        TripleBind.singleton((i) => ProfileStore(i())),
        TripleBind.singleton((i) => HomeStore(i(), i())),
      ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: CoreModule()),
    ModuleRoute('/auth/', module: AuthModule()),
    ChildRoute(
      '/app/',
      child: (context, args) => const RootPage(),
      children: [
        ChildRoute(
          '/home/',
          child: (context, args) => const HomePage(),
        ),
        ModuleRoute('/courses/', module: CoursesModule()),
        ChildRoute(
          '/profile/',
          child: (context, args) => const ProfilePage(),
        ),
        WildcardRoute(child: (context, args) => const NotFoundPage()),
      ],
      guards: [AuthGuard()],
    ),
  ];
}

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return Modular.get<AuthStore>().isLogged;
  }
}
