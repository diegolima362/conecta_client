import '../types/types.dart';

abstract class IPreferencesRepository {
  Future<EitherUnit> clearDatabase();

  Future<EitherPreferences> getPreferences();

  Future<EitherUnit> setAllowBackgroundUpdates(bool value);

  Future<EitherUnit> setAllowNotifications(bool value);

  Future<EitherUnit> setSeedColor(int value);

  Future<EitherUnit> setThemeMode(int value);
}
