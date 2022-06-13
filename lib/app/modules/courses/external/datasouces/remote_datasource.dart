import 'dart:async';

import 'package:dio/dio.dart';

import '../../domain/errors/errors.dart';
import '../../infra/datasources/courses_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/api_paths.dart' as api;

class CoursesRemoteDatasource implements ICoursesRemoteDatasource {
  final Dio client;

  CoursesRemoteDatasource(this.client);

  @override
  Future<List<CourseModel>> getCourses({String? id}) async {
    try {
      final result = await client.get(api.urlCourses);

      final data = result.data as List;

      return data.map((i) => CourseModel.fromMap(i)).toList();
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }
}
