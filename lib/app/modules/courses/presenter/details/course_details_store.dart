import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

typedef CourseDetailStoreType
    = NotifierStore<AppContentFailure, CoursetDetailsState>;

class CourseDetailsStore extends CourseDetailStoreType {
  final IGetCourseById getCourse;
  final IDeleteCourse deleteCourse;
  final IGetLoggedUser getLoggedUser;

  CourseDetailsStore(this.getCourse, this.deleteCourse, this.getLoggedUser)
      : super(
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

    final course = await getCourse(courseId);
    final user = await getLoggedUser();

    user.match(
      setError,
      (r) {
        update(state.copyWith(user: r));
      },
    );

    course.match(
      setError,
      (r) {
        update(state.copyWith(course: r));
      },
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
}

class CoursetDetailsState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;

  CoursetDetailsState({
    required this.course,
    required this.user,
  });

  factory CoursetDetailsState.empty() => CoursetDetailsState(
        course: none(),
        user: none(),
      );

  CoursetDetailsState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
  }) {
    return CoursetDetailsState(
      course: course ?? this.course,
      user: user ?? this.user,
    );
  }
}
