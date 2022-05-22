import 'package:flutter/material.dart';

import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin ISetThemeMode {
  Future<EitherUnit> call(ThemeMode value);
}

class SetThemeMode implements ISetThemeMode {
  final IPreferencesRepository respository;

  SetThemeMode(this.respository);

  @override
  Future<EitherUnit> call(ThemeMode value) async {
    return await respository.setThemeMode(value.index);
  }
}
