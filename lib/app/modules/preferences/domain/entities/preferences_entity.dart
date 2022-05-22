import 'package:flutter/material.dart';

class PreferencesEntity {
  final ThemeMode themeMode;
  final bool allowBackgroundUpdate;
  final bool allowNotifications;
  final int seedColor;

  PreferencesEntity({
    this.themeMode = ThemeMode.system,
    this.allowBackgroundUpdate = false,
    this.allowNotifications = false,
    this.seedColor = 0xff34c759,
  });
}
