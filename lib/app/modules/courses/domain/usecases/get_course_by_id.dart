import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetCourseById {
  Future<EitherCourse> call(int id);
}

class GetCourseById implements IGetCourseById {
  final ICoursesRepository repository;

  GetCourseById(this.repository);

  @override
  Future<EitherCourse> call(int id) async {
    return await repository.getCourseById(id);
  }
}
