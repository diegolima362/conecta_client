import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin ISetAllowNotifications {
  Future<EitherUnit> call(bool value);
}

class SetAllowNotifications implements ISetAllowNotifications {
  final IPreferencesRepository respository;

  SetAllowNotifications(this.respository);

  @override
  Future<EitherUnit> call(bool value) async {
    return await respository.setAllowNotifications(value);
  }
}
