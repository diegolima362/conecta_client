import 'package:conecta/app/core/external/drivers/shared_prefs.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/assignments_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/assignments_datasource.dart';
import '../datasources/courses_datasource.dart';

class AssignmentsRepository implements IAssignmentsRepository {
  final ICoursesLocalDatasource localData;
  final IAssignmentsRemoteDatasource remoteData;
  final SharedPrefs prefsStorage;

  final coursesCache = <CourseEntity>[];
  final assignmentsCache = <AssignmentEntity>[];
  final registrationsCache = <RegistrationEntity>[];

  AssignmentsRepository(this.localData, this.remoteData, this.prefsStorage);

  Future<bool> get updated async {
    final lastUpdate = await prefsStorage.getLastCoursesUpdate();

    final expireTime = lastUpdate.add(const Duration(hours: 1));

    return DateTime.now().isBefore(expireTime);
  }

  @override
  Future<EitherAssignments> getCourseAssignments(int courseId) async {
    try {
      final result = await remoteData.getCourseAssignments(courseId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherAssignment> getAssignment(int assignmentId) async {
    try {
      final result = await remoteData.getAssignment(assignmentId);

      return Right(Option.of(result));
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> createAssignment({
    required String title,
    required String content,
    required int courseId,
    required int authorId,
    required int grade,
    required DateTime dueDate,
  }) async {
    try {
      await remoteData.createAssignment(
        title: title,
        content: content,
        courseId: courseId,
        authorId: authorId,
        grade: grade,
        dueDate: dueDate,
      );

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> editAssignment({
    required int assignmentId,
    required String title,
    required String content,
    required int grade,
    required DateTime dueDate,
  }) async {
    try {
      await remoteData.editAssignment(
        assignmentId: assignmentId,
        title: title,
        content: content,
        grade: grade,
        dueDate: dueDate,
      );

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> deleteAssignment(int assignmentId) async {
    try {
      await remoteData.deleteAssignment(assignmentId);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> markAsDone(int courseId) async {
    try {
      await remoteData.markAsDone(courseId);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> submit(int assignmentId, String content) async {
    try {
      await remoteData.submitAssignment(assignmentId, content);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherSubmissions> getAssignmentSubmissions(int assignmentId) async {
    try {
      final result = await remoteData.getAssignmentSubmissions(assignmentId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherSubmission> getUserSubmission(int assignmentId) async {
    try {
      final result = await remoteData.getUserSubmission(assignmentId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> returnSubmission(int submissionId, int grade) async {
    try {
      final result = await remoteData.returnSubmission(submissionId, grade);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> cancelSubmission(int submissionId) async {
    try {
      final result = await remoteData.cancelSubmission(submissionId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }
}
