import '../types/types.dart';

abstract class IAssignmentsRepository {
  Future<EitherAssignments> getCourseAssignments(int courseId);

  Future<EitherUnit> createAssignment({
    required String title,
    required String content,
    required int courseId,
    required int authorId,
    required int grade,
    required DateTime dueDate,
  });

  Future<EitherAssignment> getAssignment(int assignmentId);

  Future<EitherUnit> editAssignment({
    required int assignmentId,
    required String title,
    required String content,
    required int grade,
    required DateTime dueDate,
  });

  Future<EitherUnit> deleteAssignment(int assignmentId);

  Future<EitherUnit> markAsDone(int courseId);

  Future<EitherUnit> submit(int assignmentId, String content);

  Future<EitherSubmission> getUserSubmission(int assignmentId);

  Future<EitherSubmissions> getAssignmentSubmissions(int assignmentId);

  Future<EitherUnit> returnSubmission(int submissionId, int grade);

  Future<EitherUnit> cancelSubmission(int submissionId);
}
