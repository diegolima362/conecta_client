import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin ISetSeedColor {
  Future<EitherUnit> call(int value);
}

class SetSeedColor implements ISetSeedColor {
  final IPreferencesRepository respository;

  SetSeedColor(this.respository);

  @override
  Future<EitherUnit> call(int value) async {
    return await respository.setSeedColor(value);
  }
}
