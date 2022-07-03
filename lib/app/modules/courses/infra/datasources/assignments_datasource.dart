import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class IAssignmentsRemoteDatasource {
  Future<List<AssignmentModel>> getCourseAssignments(int courseId);

  Future<AssignmentModel> getAssignment(int assignmentId);

  Future<Unit> createAssignment({
    required String title,
    required String content,
    required int courseId,
    required int authorId,
    required int grade,
    required DateTime dueDate,
  });

  Future<Unit> editAssignment({
    required int assignmentId,
    required String title,
    required String content,
    required int grade,
    required DateTime dueDate,
  });

  Future<Unit> deleteAssignment(int assignmentId);

  Future<List<AssignmentModel>> getUserAssignments();

  Future<List<AssignmentSubmissionModel>> getAssignmentSubmissions(
      int assignmentId);

  Future<Unit> submitAssignment(int assignmentId, String content);

  Future<Unit> markAsDone(int assignmentId);

  Future<Unit> returnSubmission(int submissionId, int grade);

  Future<AssignmentSubmissionModel> getUserSubmission(int assignmentId);

  Future<Unit> cancelSubmission(int assignmentId);
}
