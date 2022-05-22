import 'package:conecta/app/core/infra/drivers/shared_prefs.dart';

import '../../infra/datasources/preferences_datasource.dart';
import '../../infra/models/preferences_model.dart';

const defaultColor = 0xff0a84ff;

class PreferencesDatasource implements IPreferencesDatasource {
  final IPrefsStorage prefs;

  PreferencesDatasource(this.prefs);

  @override
  Future<PreferencesModel> get preferences async =>
      await prefs.getAllPreferences();

  @override
  Future<int> get themeMode async => await prefs.getThemeMode();

  @override
  Future<void> clearDatabase() async {
    await prefs.clearDatabase();
  }

  @override
  Future<void> setAllowBackgroundUpdates(bool value) async {
    await prefs.setAllowBackgroundUpdates(value);
  }

  @override
  Future<void> setAllowNotifications(bool value) async {
    await prefs.setAllowNotifications(value);
  }

  @override
  Future<void> setSeedColor(int value) async {
    await prefs.setSeedColor(value);
  }

  @override
  Future<void> storeTheme(int value) async {
    await prefs.setThemeMode(value);
  }
}
