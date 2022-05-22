import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/preferences_datasource.dart';
import 'infra/repositories/preferences_repository.dart';
import 'presenter/preferences/preferences_page.dart';

class PreferencesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => PreferencesDatasource(i()), export: true),
    Bind.lazySingleton((i) => PreferencesRepository(i()), export: true),
    Bind.lazySingleton((i) => GetPreferences(i()), export: true),
    Bind.lazySingleton((i) => ClearDatabase(i()), export: true),
    Bind.lazySingleton((i) => SetThemeMode(i()), export: true),
    Bind.lazySingleton((i) => SetSeedColor(i()), export: true),
    Bind.lazySingleton((i) => SetAllowBackgroundUpdates(i()), export: true),
    Bind.lazySingleton((i) => SetAllowNotifications(i()), export: true),
    Bind.lazySingleton((i) => ClearDatabase(i()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const PreferencesPage()),
  ];
}
