import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';

import '../types/types.dart';

abstract class ICoursesRepository {
  Future<EitherCourses> getCourses({bool cached = true});

  Future<EitherCourse> getCourseById(int id);

  Future<EitherRegistrations> getCourseRegistrations(int courseId);

  Future<EitherUnit> clearData();

  Future<EitherUnit> createCourse(CourseEntity course);

  Future<EitherUnit> editCourse(CourseEntity courseEntity);

  Future<EitherUnit> deleteCourse(int courseId);

  Future<EitherUnit> joinCourse(String code);

  Future<EitherUnit> registerStudent(int courseId, int studentId);

  Future<EitherUnit> removeStudent(int courseId, int registerId);

  Future<EitherUnit> removePerson(int courseId, int registrationId);

  Future<EitherUnit> leaveCourse(int courseId);
}
