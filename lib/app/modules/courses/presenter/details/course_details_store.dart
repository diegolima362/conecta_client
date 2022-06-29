// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';

typedef CourseDetailStoreType
    = NotifierStore<AppContentFailure, CoursetDetailsState>;

class CourseDetailsStore extends CourseDetailStoreType {
  final IGetCourseById getCourse;
  final IDeleteCourse deleteCourse;
  final IGetLoggedUser getLoggedUser;
  final IGetCourseRegistrations getRegistrations;
  final IGetCourseFeed getFeed;

  final IGetCourseAssignments getAssignments;

  CourseDetailsStore({
    required this.getCourse,
    required this.deleteCourse,
    required this.getLoggedUser,
    required this.getAssignments,
    required this.getRegistrations,
    required this.getFeed,
  }) : super(
          CoursetDetailsState.empty(),
        );

  bool get isOwner =>
      state.course.toNullable()?.professorId == state.user.toNullable()?.id;

  Unit init(int courseId) {
    update(CoursetDetailsState.empty());
    getData(courseId);

    return unit;
  }

  Future<Unit> getData(int courseId) async {
    setLoading(true);

    final user = getLoggedUser();
    final course = getCourse(courseId);
    final assignments = getAssignments(courseId);
    final registrations = getRegistrations(courseId);
    final feed = getFeed(courseId);

    await Future.wait([user, course, assignments, registrations, feed]);

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
    registrations.then(
      (value) => value.match(
          setError, (r) => update(state.copyWith(registrations: r))),
    );
    feed.then(
      (value) => value.match(setError, (r) => update(state.copyWith(feed: r))),
    );

    return unit;
  }

  Future<Unit> delete() async {
    if (state.course.isSome()) {
      final result = await deleteCourse(state.course.toNullable()!.id);

      result.match(
        setError,
        (r) {
          update(state.copyWith(course: none()));
        },
      );
    }
    return unit;
  }

  Unit jumpToPage(int index) {
    update(state.copyWith(page: index));
    return unit;
  }
}

class CoursetDetailsState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;

  final List<AssignmentEntity> assignments;
  final List<RegistrationEntity> registrations;
  final List<PostEntity> feed;

  final int page;

  CoursetDetailsState({
    required this.course,
    required this.user,
    required this.assignments,
    required this.registrations,
    required this.feed,
    this.page = 0,
  });

  factory CoursetDetailsState.empty() => CoursetDetailsState(
        course: none(),
        user: none(),
        feed: [],
        assignments: [],
        registrations: [],
      );

  CoursetDetailsState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
    List<AssignmentEntity>? assignments,
    List<RegistrationEntity>? registrations,
    List<PostEntity>? feed,
    int? page,
  }) {
    return CoursetDetailsState(
      course: course ?? this.course,
      user: user ?? this.user,
      feed: feed ?? this.feed,
      assignments: assignments ?? this.assignments,
      registrations: registrations ?? this.registrations,
      page: page ?? this.page,
    );
  }
}
