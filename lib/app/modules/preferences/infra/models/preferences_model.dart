import 'package:flutter/material.dart';

import '../../domain/entities/preferences_entity.dart';

class PreferencesModel extends PreferencesEntity {
  final int themeIndex;

  PreferencesModel({
    required this.themeIndex,
    required super.themeMode,
    required super.allowBackgroundUpdate,
    required super.allowNotifications,
    required super.seedColor,
  });

  PreferencesModel copyWith({
    int? themeIndex,
    bool? allowNotifications,
    bool? allowBackgroundUpdate,
    int? seedColor,
    ThemeMode? themeMode,
  }) {
    return PreferencesModel(
      themeIndex: themeIndex ?? this.themeIndex,
      seedColor: seedColor ?? this.seedColor,
      allowBackgroundUpdate:
          allowBackgroundUpdate ?? this.allowBackgroundUpdate,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreferencesModel &&
        other.themeMode == themeMode &&
        other.allowBackgroundUpdate == allowBackgroundUpdate &&
        other.allowNotifications == allowNotifications &&
        other.seedColor == seedColor;
  }

  @override
  int get hashCode {
    return themeMode.hashCode ^
        allowBackgroundUpdate.hashCode ^
        allowNotifications.hashCode ^
        seedColor.hashCode;
  }
}
