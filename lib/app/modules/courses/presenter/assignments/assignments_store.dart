import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/repositories/assignments_repository.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class AssignmentsStore
    extends NotifierStore<AppContentFailure, AssignmentsStoreState> {
  final IGetLoggedUser getLoggedUser;
  final IGetCourseById getCourseById;
  final IAssignmentsRepository repository;

  AssignmentsStore({
    required this.getLoggedUser,
    required this.getCourseById,
    required this.repository,
  }) : super(AssignmentsStoreState.empty());

  bool get isOwner =>
      state.course.toNullable()?.professorId == state.user.toNullable()?.id;

  Unit init(int courseId) {
    update(AssignmentsStoreState.empty());
    getData(courseId);

    return unit;
  }

  Future<Unit> getData(int courseId) async {
    setLoading(true);

    final user = getLoggedUser();
    final course = getCourseById(courseId);
    final assignments = repository.getCourseAssignments(courseId);

    await Future.wait([user, course, assignments]);

    user.then(
      (value) => value.match(setError, (r) => update(state.copyWith(user: r))),
    );
    course.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(course: r))),
    );
    assignments.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(assignments: r))),
    );

    return unit;
  }

  Future<Unit> createAssignment({
    required String title,
    required String content,
    required int grade,
    required DateTime dueDate,
  }) async {
    final course = state.course.toNullable();
    final author = state.user.toNullable();

    if (course == null || author == null) return unit;

    await repository.createAssignment(
      title: title,
      content: content,
      courseId: course.id,
      authorId: author.id,
      grade: grade,
      dueDate: dueDate,
    );

    await getData(course.id);
    return unit;
  }

  Future<Unit> editAssignemnt({
    required int assignmentId,
    required String title,
    required String content,
    required int grade,
    required DateTime dueDate,
  }) async {
    final course = state.course.toNullable();
    final author = state.user.toNullable();

    if (course == null || author == null) return unit;

    await repository.editAssignment(
      assignmentId: assignmentId,
      title: title,
      content: content,
      grade: grade,
      dueDate: dueDate,
    );

    await getData(course.id);
    return unit;
  }

  Unit clear() {
    update(AssignmentsStoreState.empty());
    return unit;
  }

  Future<Unit> deleteAssignment(AssignmentEntity assignment) async {
    await repository.deleteAssignment(assignment.id);
    getData(assignment.courseId);
    return unit;
  }
}

class AssignmentsStoreState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;

  final List<AssignmentEntity> assignments;

  AssignmentsStoreState({
    required this.course,
    required this.user,
    required this.assignments,
  });

  factory AssignmentsStoreState.empty() => AssignmentsStoreState(
        course: none(),
        user: none(),
        assignments: [],
      );

  AssignmentsStoreState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
    List<AssignmentEntity>? assignments,
  }) {
    return AssignmentsStoreState(
      course: course ?? this.course,
      user: user ?? this.user,
      assignments: assignments ?? this.assignments,
    );
  }
}
