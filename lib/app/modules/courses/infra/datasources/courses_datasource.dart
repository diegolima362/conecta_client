import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class ICoursesDatasource {
  Future<List<CourseModel>> getCourses();

  Future<CourseModel> getCourse(int courseId);
}

abstract class ICoursesLocalDatasource extends ICoursesDatasource {
  Future<Unit> saveCourses(List<CourseModel> courses);

  Future<Unit> clearData();
}

abstract class ICoursesRemoteDatasource extends ICoursesDatasource {
  Future<Unit> createCourse(CourseModel course);

  Future<Unit> removeStudent(int courseId, int registerId);

  Future<Unit> registerStudent(int courseId, int studentId);

  Future<Unit> joinCourse(String code);

  Future<Unit> leaveCourse(int courseId);

  Future<Unit> removePerson(int courseId, int registrationId);

  Future<List<RegistrationModel>> getCourseRegistrations(int courseId);

  Future<Unit> editCourse(int id, String name);

  Future<Unit> deleteCourse(int courseId);
}
