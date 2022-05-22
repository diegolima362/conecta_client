import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin ISetAllowBackgroundUpdates {
  Future<EitherUnit> call(bool value);
}

class SetAllowBackgroundUpdates implements ISetAllowBackgroundUpdates {
  final IPreferencesRepository respository;

  SetAllowBackgroundUpdates(this.respository);

  @override
  Future<EitherUnit> call(bool value) async {
    return await respository.setAllowBackgroundUpdates(value);
  }
}
