import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IDeleteCourse {
  Future<EitherUnit> call(int courseId);
}

class DeleteCourse implements IDeleteCourse {
  final ICoursesRepository repository;

  DeleteCourse(this.repository);

  @override
  Future<EitherUnit> call(int courseId) async {
    return await repository.deleteCourse(courseId);
  }
}
