import '../types/types.dart';

abstract class ICoursesRepository {
  Future<EitherCourses> getCourses({bool cached = true});

  Future<EitherCourse> getCourseById(int id);

  Future<EitherUnit> clearData();
}
