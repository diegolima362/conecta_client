import '../entities/entities.dart';
import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class ICreateCourse {
  Future<EitherUnit> call(CourseEntity course);
}

class CreateCourse implements ICreateCourse {
  final ICoursesRepository repository;

  CreateCourse(this.repository);

  @override
  Future<EitherUnit> call(CourseEntity course) async {
    return await repository.createCourse(course);
  }
}
