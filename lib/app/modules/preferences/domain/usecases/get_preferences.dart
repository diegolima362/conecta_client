import '../repositories/preferences_repository.dart';
import '../types/types.dart';

mixin IGetPreferences {
  Future<EitherPreferences> call();
}

class GetPreferences implements IGetPreferences {
  final IPreferencesRepository respository;

  GetPreferences(this.respository);

  @override
  Future<EitherPreferences> call() async {
    return await respository.getPreferences();
  }
}
