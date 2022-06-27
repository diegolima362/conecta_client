import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetCourseAssignments {
  Future<EitherAssignments> call(int courseId);
}

class GetCourseAssignments implements IGetCourseAssignments {
  final ICoursesRepository repository;

  GetCourseAssignments(this.repository);

  @override
  Future<EitherAssignments> call(int courseId) async {
    return await repository.getCourseAssignments(courseId);
  }
}
