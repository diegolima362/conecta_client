import 'package:fpdart/fpdart.dart';

import '../../domain/erros/erros.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/preferences_datasource.dart';

class PreferencesRepository implements IPreferencesRepository {
  final IPreferencesDatasource datasource;

  PreferencesRepository(this.datasource);

  @override
  Future<EitherPreferences> getPreferences() async {
    try {
      return Right(await datasource.preferences);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> setThemeMode(int val) async {
    try {
      await datasource.storeTheme(val);
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> clearDatabase() async {
    try {
      await datasource.clearDatabase();
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> setAllowBackgroundUpdates(bool value) async {
    try {
      await datasource.setAllowBackgroundUpdates(value);
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> setAllowNotifications(bool value) async {
    try {
      await datasource.setAllowNotifications(value);
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> setSeedColor(int value) async {
    try {
      await datasource.setSeedColor(value);
      return const Right(unit);
    } on PreferencesFailure catch (e) {
      return Left(e);
    }
  }
}
