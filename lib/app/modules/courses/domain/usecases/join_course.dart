import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IJoinCourse {
  Future<EitherUnit> call(String code);
}

class JoinCourse implements IJoinCourse {
  final ICoursesRepository repository;

  JoinCourse(this.repository);

  @override
  Future<EitherUnit> call(String code) async {
    return await repository.joinCourse(code);
  }
}
