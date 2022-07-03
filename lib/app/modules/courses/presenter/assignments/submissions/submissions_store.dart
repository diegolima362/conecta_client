import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/repositories/repositories.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class SubmissionsStore
    extends NotifierStore<AppContentFailure, SubmissionsStoreState> {
  final IGetLoggedUser getLoggedUser;
  final IGetCourseById getCourseById;
  final IAssignmentsRepository repository;

  SubmissionsStore({
    required this.getLoggedUser,
    required this.getCourseById,
    required this.repository,
  }) : super(SubmissionsStoreState.empty());

  bool get isOwner =>
      state.course.toNullable()?.professorId == state.user.toNullable()?.id;

  Unit init(int courseId, int assignmentId) {
    update(SubmissionsStoreState.empty());
    getData(courseId, assignmentId);

    return unit;
  }

  Future<Unit> getData(int courseId, int assignmentId) async {
    setLoading(true);

    final user = getLoggedUser();
    final course = getCourseById(courseId);
    final assignment = repository.getAssignment(assignmentId);
    final submissions = repository.getAssignmentSubmissions(assignmentId);

    await Future.wait([user, course, assignment, submissions]);

    user.then(
      (value) => value.match(setError, (r) => update(state.copyWith(user: r))),
    );
    course.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(course: r))),
    );
    assignment.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(assignment: r))),
    );
    submissions.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(submissions: r))),
    );

    return unit;
  }

  Unit clear() {
    update(SubmissionsStoreState.empty());
    return unit;
  }

  Future<Unit> submitAssignment(
      AssignmentEntity assignment, String content) async {
    await repository.submit(assignment.id, content);

    await getSubmission(assignment.id);
    return unit;
  }

  Future<Unit> markAsDone(int assignmentId) async {
    await repository.markAsDone(assignmentId);

    await getSubmission(assignmentId);

    return unit;
  }

  Future<Unit> getSubmission(int assignmentId) async {
    final result = await repository.getUserSubmission(assignmentId);

    result.fold(
      (l) => none(),
      (r) => update(state.copyWith(userSubmission: Option.of(r))),
    );

    return unit;
  }

  Future<Unit> returnSubmission(int submissionId, int grade) async {
    await repository.returnSubmission(submissionId, grade);

    getData(
      state.course.toNullable()!.id,
      state.assignment.toNullable()!.id,
    );

    return unit;
  }

  Future<Unit> cancelSubmission(int assignmentId) async {
    await repository.cancelSubmission(assignmentId);

    getSubmission(assignmentId);

    return unit;
  }
}

class SubmissionsStoreState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;
  final Option<AssignmentEntity> assignment;
  final Option<AssignmentSubmissionEntity> userSubmission;

  final List<AssignmentSubmissionEntity> submissions;

  SubmissionsStoreState({
    required this.course,
    required this.user,
    required this.assignment,
    required this.submissions,
    required this.userSubmission,
  });

  factory SubmissionsStoreState.empty() => SubmissionsStoreState(
        course: none(),
        user: none(),
        assignment: none(),
        userSubmission: none(),
        submissions: [],
      );

  SubmissionsStoreState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
    Option<AssignmentEntity>? assignment,
    Option<AssignmentSubmissionEntity>? userSubmission,
    List<AssignmentSubmissionEntity>? submissions,
  }) {
    return SubmissionsStoreState(
      course: course ?? this.course,
      user: user ?? this.user,
      assignment: assignment ?? this.assignment,
      userSubmission: userSubmission ?? this.userSubmission,
      submissions: submissions ?? this.submissions,
    );
  }
}
