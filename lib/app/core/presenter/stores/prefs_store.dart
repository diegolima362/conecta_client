import 'package:asuka/asuka.dart';
import 'package:conecta/app/modules/preferences/domain/entities/preferences_entity.dart';
import 'package:conecta/app/modules/preferences/domain/erros/erros.dart';
import 'package:conecta/app/modules/preferences/domain/usecases/usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'auth_store.dart';

typedef PreferencesStoreType
    = NotifierStore<PreferencesFailure, PreferencesState>;

class PreferencesState {
  final ThemeMode themeMode;
  final bool isOnline;
  final bool allowWorker;
  final bool allowNotifications;
  final int seedColor;

  PreferencesState({
    this.themeMode = ThemeMode.system,
    this.isOnline = true,
    this.allowNotifications = false,
    this.allowWorker = false,
    this.seedColor = 0xFF6750A4,
  });

  PreferencesEntity get asEntity => PreferencesEntity(
        themeMode: themeMode,
        allowBackgroundUpdate: allowWorker,
        allowNotifications: allowNotifications,
        seedColor: seedColor,
      );

  PreferencesState copyWith({
    ThemeMode? themeMode,
    bool? isOnline,
    bool? allowWorker,
    bool? allowNotifications,
    int? pendingNotifications,
    int? seedColor,
  }) {
    return PreferencesState(
      themeMode: themeMode ?? this.themeMode,
      isOnline: isOnline ?? this.isOnline,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      allowWorker: allowWorker ?? this.allowWorker,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  PreferencesState fromEntity(PreferencesEntity r) => copyWith(
        themeMode: r.themeMode,
        allowNotifications: r.allowNotifications,
        allowWorker: r.allowBackgroundUpdate,
        seedColor: r.seedColor,
      );
}

class PreferencesStore extends PreferencesStoreType {
  final IGetPreferences getPreferences;
  final IClearDatabase clearDatabase;

  final ISetThemeMode setThemeMode;
  final ISetSeedColor setSeedColor;
  final ISetAllowBackgroundUpdates setAllowBackgroundUpdates;
  final ISetAllowNotifications setAllowNotifications;

  final IAuthStore authStore;

  PreferencesStore({
    required this.getPreferences,
    required this.setThemeMode,
    required this.setSeedColor,
    required this.setAllowBackgroundUpdates,
    required this.setAllowNotifications,
    required this.authStore,
    required this.clearDatabase,
  }) : super(PreferencesState());

  ThemeMode get currentTheme => state.themeMode;

  Future<void> getData() async {
    setLoading(true);
    final result = await getPreferences();

    result.fold(
      (l) {
        AsukaSnackbar.warning(l.message);
        setError(l);
      },
      (r) => update(state.fromEntity(r)),
    );
  }

  Future<void> setColor(int? value) async {
    if (value == null) return;

    update(state.copyWith(seedColor: value));

    await setSeedColor(value);
  }

  Future<void> setTheme(ThemeMode? val) async {
    if (val == null) return;

    update(state.copyWith(themeMode: val));

    final result = await setThemeMode(state.themeMode);

    result.fold(
      (l) => AsukaSnackbar.warning(l.message),
      (r) => r,
    );
  }

  Future<void> clearData() async {
    await clearDatabase();
  }
}
