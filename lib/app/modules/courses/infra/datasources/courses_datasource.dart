import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class ICoursesDatasource {
  Future<List<CourseModel>> getCourses({String? id});
}

abstract class ICoursesLocalDatasource extends ICoursesDatasource {
  Future<Unit> saveCourses(List<CourseModel> courses);

  Future<Unit> clearData();
}

abstract class ICoursesRemoteDatasource extends ICoursesDatasource {}
