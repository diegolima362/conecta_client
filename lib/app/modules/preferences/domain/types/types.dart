import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/preferences_entity.dart';
import '../erros/erros.dart';

typedef EitherBool = Either<PreferencesFailure, bool>;

typedef EitherColor = Either<PreferencesFailure, Color>;

typedef EitherInt = Either<PreferencesFailure, int>;

typedef EitherPreferences = Either<PreferencesFailure, PreferencesEntity>;

typedef EitherThemeMode = Either<PreferencesFailure, ThemeMode>;

typedef EitherUnit = Either<PreferencesFailure, Unit>;
