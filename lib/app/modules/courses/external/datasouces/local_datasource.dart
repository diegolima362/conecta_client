import 'package:fpdart/fpdart.dart';

import '../../infra/datasources/courses_datasource.dart';
import '../../infra/models/models.dart';

class CoursesLocalDatasource implements ICoursesLocalDatasource {
  CoursesLocalDatasource();

  final _courses = <CourseModel>[];

  @override
  Future<List<CourseModel>> getCourses({String? id}) async {
    return _courses;
  }

  @override
  Future<CourseModel> getCourse(int courseId) async {
    return _courses.firstWhere((c) => c.id == courseId);
  }

  @override
  Future<Unit> saveCourses(List<CourseModel> courses) async {
    _courses.clear();
    _courses.addAll(courses);

    return unit;
  }

  @override
  Future<Unit> clearData() async {
    _courses.clear();

    return unit;
  }
}
