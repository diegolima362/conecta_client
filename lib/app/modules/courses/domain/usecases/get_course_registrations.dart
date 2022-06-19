import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetCourseRegistrations {
  Future<EitherRegistrations> call(int courseId);
}

class GetCourseRegistrations implements IGetCourseRegistrations {
  final ICoursesRepository repository;

  GetCourseRegistrations(this.repository);

  @override
  Future<EitherRegistrations> call(int courseId) async {
    return await repository.getCourseRegistrations(courseId);
  }
}
