import '../models/preferences_model.dart';

abstract class IPreferencesDatasource {
  Future<PreferencesModel> get preferences;

  Future<int> get themeMode;

  Future<void> clearDatabase();

  Future<void> setAllowBackgroundUpdates(bool value);

  Future<void> setAllowNotifications(bool value);

  Future<void> setSeedColor(int value);

  Future<void> storeTheme(int value);
}
