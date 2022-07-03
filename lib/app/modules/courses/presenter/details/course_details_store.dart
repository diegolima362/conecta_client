import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/repositories/courses_repository.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

typedef CourseDetailStoreType
    = NotifierStore<AppContentFailure, CoursetDetailsState>;

class CourseDetailsStore extends CourseDetailStoreType {
  final IGetLoggedUser getLoggedUser;

  final ICoursesRepository repository;

  CourseDetailsStore({
    required this.getLoggedUser,
    required this.repository,
  }) : super(CoursetDetailsState.empty());

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
    final course = repository.getCourseById(courseId);

    await Future.wait([user, course]);

    user.then(
      (value) => value.match(setError, (r) => update(state.copyWith(user: r))),
    );
    course.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(course: r))),
    );

    return unit;
  }

  Future<Unit> createCourse(String title, int professorId) async {
    final result = await repository.createCourse(CourseEntity(
      code: '',
      id: 0,
      professorId: professorId,
      professorName: '',
      name: title,
    ));

    result.fold(setError, (r) {});
    return unit;
  }

  Future<Unit> editCourse(String title) async {
    if (state.course.isNone()) {
      return unit;
    }

    final old = state.course.toNullable()!;

    final course = CourseEntity(
      id: old.id,
      name: title,
      professorName: old.professorName,
      professorId: old.professorId,
      code: old.code,
    );

    final result = await repository.editCourse(course);

    result.fold(
      setError,
      (r) => update(state.copyWith(course: Option.of(course))),
    );

    return unit;
  }

  Future<Unit> deleteCourse() async {
    if (state.course.isSome()) {
      final result =
          await repository.deleteCourse(state.course.toNullable()!.id);

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

  Unit clear() {
    update(CoursetDetailsState.empty());
    return unit;
  }
}

class CoursetDetailsState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;

  final int page;

  CoursetDetailsState({
    required this.course,
    required this.user,
    this.page = 0,
  });

  factory CoursetDetailsState.empty() => CoursetDetailsState(
        course: none(),
        user: none(),
      );

  CoursetDetailsState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
    int? page,
  }) {
    return CoursetDetailsState(
      course: course ?? this.course,
      user: user ?? this.user,
      page: page ?? this.page,
    );
  }
}
