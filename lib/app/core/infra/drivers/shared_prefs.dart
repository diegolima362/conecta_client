import 'dart:async';

import 'package:conecta/app/modules/preferences/infra/models/preferences_model.dart';

abstract class IPrefsStorage {
  Future<void> clearDatabase();
  FutureOr<bool> getAllowBackgroundUpdate();
  FutureOr<bool> getAllowNotifications();
  Future<PreferencesModel> getAllPreferences();
  FutureOr<DateTime> getLastCoursesUpdate();
  FutureOr<DateTime> getLastHistoryUpdate();
  FutureOr<DateTime> getLastProfileUpdate();
  FutureOr<int> getSeedColor();
  FutureOr<int> getThemeMode();
  Future<void> setAllowBackgroundUpdates(bool value);
  Future<void> setAllowNotifications(bool value);
  Future<void> setLastCoursesUpdate(DateTime time);
  Future<void> setLastHistoryUpdate(DateTime dateTime);
  Future<void> setLastProfileUpdate(DateTime time);
  Future<void> setSeedColor(int value);
  Future<void> setThemeMode(int value);
}
