import 'dart:async';

import 'package:conecta/app/modules/preferences/infra/models/preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infra/drivers/shared_prefs.dart';

class SharedPrefs implements IPrefsStorage {
  final SharedPreferences storage;

  SharedPrefs(this.storage);

  @override
  Future<void> clearDatabase() async {
    await storage.clear();
  }

  @override
  FutureOr<bool> getAllowBackgroundUpdate() {
    return storage.getBool('allowBackgroundUpdate') ?? false;
  }

  @override
  FutureOr<bool> getAllowNotifications() {
    return storage.getBool('allowNotifications') ?? false;
  }

  @override
  Future<PreferencesModel> getAllPreferences() async {
    return PreferencesModel(
      themeIndex: await getThemeMode(),
      allowNotifications: await getAllowNotifications(),
      allowBackgroundUpdate: await getAllowBackgroundUpdate(),
      seedColor: await getSeedColor(),
      themeMode: ThemeMode.values.elementAt(await getThemeMode()),
    );
  }

  @override
  FutureOr<DateTime> getLastCoursesUpdate() {
    final time = storage.getInt('coursesUpdate') ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  FutureOr<DateTime> getLastHistoryUpdate() {
    final time = storage.getInt('historyUpdate') ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  FutureOr<DateTime> getLastProfileUpdate() {
    final time = storage.getInt('profileUpdate') ?? 0;

    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  FutureOr<int> getSeedColor() {
    return storage.getInt('seedColor') ?? 0xff0B2847;
  }

  @override
  FutureOr<int> getThemeMode() {
    return storage.getInt('themeMode') ?? ThemeMode.system.index;
  }

  @override
  Future<void> setAllowBackgroundUpdates(bool value) async {
    await storage.setBool('allowBackgroundUpdate', value);
  }

  @override
  Future<void> setAllowNotifications(bool value) async {
    await storage.setBool('allowNotifications', value);
  }

  @override
  Future<void> setLastCoursesUpdate(DateTime time) async {
    await storage.setInt('coursesUpdate', time.millisecondsSinceEpoch);
  }

  @override
  Future<void> setLastHistoryUpdate(DateTime time) async {
    await storage.setInt('historyUpdate', time.millisecondsSinceEpoch);
  }

  @override
  Future<void> setLastProfileUpdate(DateTime time) async {
    await storage.setInt('profileUpdate', time.millisecondsSinceEpoch);
  }

  @override
  Future<void> setSeedColor(int value) async {
    await storage.setInt('seedColor', value);
  }

  @override
  Future<void> setThemeMode(int value) async {
    await storage.setInt('themeMode', value);
  }
}
