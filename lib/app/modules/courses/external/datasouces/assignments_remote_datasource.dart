import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../infra/datasources/assignments_datasource.dart';
import '../../infra/models/models.dart';
import 'utils/api_paths.dart' as api;

class AssignmentsRemoteDatasource implements IAssignmentsRemoteDatasource {
  final Dio client;

  AssignmentsRemoteDatasource(this.client);

  @override
  Future<Unit> createAssignment({
    required String title,
    required String content,
    required int courseId,
    required int authorId,
    required int grade,
    required DateTime dueDate,
  }) async {
    try {
      final data = {
        "title": title,
        "content": content,
        "professorId": authorId,
        "courseId": courseId,
        "grade": 100,
        "dueDate": dueDate.toIso8601String(),
      };

      const url = '${api.urlAssignments}/create';

      await client.post(url, data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<Unit> editAssignment({
    required int assignmentId,
    required String title,
    required String content,
    required int grade,
    required DateTime dueDate,
  }) async {
    try {
      final data = {
        "title": title,
        "content": content,
        "grade": grade,
        "dueDate": dueDate.toIso8601String(),
      };

      final url = '${api.urlAssignments}/$assignmentId';

      await client.put(url, data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<Unit> deleteAssignment(int assignmentId) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId';

      await client.delete(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
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
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<AssignmentSubmissionModel> getUserSubmission(int assignmentId) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId/submission';

      final response = await client.get(url);

      return AssignmentSubmissionModel.fromMap(response.data);
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<Unit> submitAssignment(int assignmentId, String content) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId/submit';
      await client.post(url, data: content);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<Unit> markAsDone(int assignmentId) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId/complete';
      await client.post(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<Unit> cancelSubmission(int assignmentId) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId/cancel';
      await client.delete(url);

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<AssignmentModel> getAssignment(int assignmentId) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId';
      final response = await client.get(url);

      return AssignmentModel.fromMap(response.data);
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<List<AssignmentSubmissionModel>> getAssignmentSubmissions(
      int assignmentId) async {
    try {
      final url = '${api.urlAssignments}/$assignmentId/submissions';

      final result = await client.get(url);

      final data = result.data as List;

      return data.map((e) => AssignmentSubmissionModel.fromMap(e)).toList();
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<List<AssignmentModel>> getUserAssignments() async {
    try {
      final result = await client.get(api.urlMyAssignments);

      final data = result.data as List;

      return data.map((e) => AssignmentModel.fromMap(e)).toList();
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }

  @override
  Future<Unit> returnSubmission(int submissionId, int grade) async {
    try {
      final url = '${api.urlSubmissions}/$submissionId/return';

      final data = {"grade": grade};

      await client.put(url, data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteAssignmentsError(message: message);
    }
  }
}
