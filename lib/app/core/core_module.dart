import 'package:conecta/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:workmanager/workmanager.dart';

import 'external/drivers/drivers.dart';
import 'presenter/pages/landing/landing_page.dart';
import 'presenter/pages/wildcard/not_found_page.dart';
import 'presenter/stores/auth_store.dart';
import 'presenter/stores/prefs_store.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    // databases
    Bind.singleton<SharedPreferences>((i) => prefs, export: true),

    Bind.singleton((i) => SharedPrefs(i()), export: true),

    // tools
    Bind.lazySingleton((i) => Dio(), export: true),

    // stores
    Bind.singleton((i) => AuthStore(i(), i()), export: true),
    TripleBind.singleton(
      export: true,
      (i) => PreferencesStore(
        getPreferences: i(),
        setThemeMode: i(),
        setSeedColor: i(),
        setAllowBackgroundUpdates: i(),
        setAllowNotifications: i(),
        authStore: i(),
        clearDatabase: i(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (context, args) => LandingPage()),
    WildcardRoute(child: (context, args) => const NotFoundPage()),
  ];
}
