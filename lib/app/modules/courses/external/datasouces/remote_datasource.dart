import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

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
      final result = await client.get(api.urlMyCourses);

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

  @override
  Future<Unit> createCourse(CourseModel course) async {
    try {
      final data = {
        "name": course.name,
        "professorId": course.professorId,
      };

      await client.post(api.urlRegisterCourse, data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<Unit> deleteCourse(int courseId) async {
    try {
      final url = '${api.urlDeleteCourse}/$courseId';

      await client.delete(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<Unit> editCourse(int id, String name) async {
    try {
      final data = {"name": name};

      final url = '${api.urlCourses}/$id';

      await client.put(url, data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<List<PostModel>> getCourseFeed(int courseId) async {
    try {
      final url = '${api.urlCourses}/$courseId/feed';

      final result = await client.get(url);

      final response = result.data as List;

      final data = response.map((e) => PostModel.fromMap(e)).toList();

      final feed = <PostModel>[];

      for (final p in data) {
        final replies = <int, List<CommentModel>>{};
        final comments = <CommentModel>[];

        for (final c in p.comments) {
          final replyTo = c.replyTo;
          if (replyTo != null) {
            if (!replies.containsKey(replyTo)) {
              replies[replyTo] = <CommentModel>[];
            }
            replies[replyTo]!.add(c as CommentModel);
          } else {
            comments.add(c as CommentModel);
          }
        }
        final postComments = <CommentModel>[];
        for (final c in comments) {
          if (replies.containsKey(c.id)) {
            postComments.add(c.copyWith(replies: replies[c.id] ?? []));
          } else {
            postComments.add(c);
          }
        }

        feed.add(p.copyWith(comments: postComments));
      }

      return feed;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<List<RegistrationModel>> getCourseRegistrations(int courseId) async {
    try {
      final url = '${api.urlCourses}/$courseId/registrations';

      final result = await client.get(url);

      final data = result.data as List;

      return data.map((e) => RegistrationModel.fromMap(e)).toList();
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<List<AssignmentModel>> getCourseAssignments(int courseId) async {
    try {
      final url = '${api.urlCourses}/$courseId/assignments';

      final result = await client.get(url);

      final data = result.data as List;

      return data.map((e) => AssignmentModel.fromMap(e)).toList();
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<Unit> joinCourse(String code) async {
    try {
      final url = '${api.urlCourses}/$code/join';

      await client.post(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<Unit> registerStudent(int courseId, int studentId) async {
    try {
      final url = '${api.urlCourses}/$courseId/registrations/$studentId';

      await client.post(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }

  @override
  Future<Unit> removeStudent(int courseId, int registerId) async {
    try {
      final url = '${api.urlCourses}/$courseId/registrations/$registerId';

      await client.delete(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw GetCoursesError(message: message);
    }
  }
}
