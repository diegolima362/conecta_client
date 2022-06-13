import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../infra/datasources/courses_datasource.dart';
import '../../infra/models/models.dart';

class CoursesLocalDatasource implements ICoursesLocalDatasource {
  final Box db;

  CoursesLocalDatasource(this.db);

  @override
  Future<List<CourseModel>> getCourses({String? id}) async {
    final data =
        await db.get('courses', defaultValue: <String>[]) as List<String>;

    return data.map((e) => CourseModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> saveCourses(List<CourseModel> courses) async {
    await db.put('courses', courses.map((e) => e.toJson()).toList());
    return unit;
  }

  @override
  Future<Unit> clearData() async {
    await db.clear();

    return unit;
  }
}
