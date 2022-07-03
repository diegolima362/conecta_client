import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/repositories/courses_repository.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class RegistrationsStore
    extends NotifierStore<AppContentFailure, RegistrationsState> {
  final IGetLoggedUser getLoggedUser;

  final ICoursesRepository repository;

  RegistrationsStore({
    required this.getLoggedUser,
    required this.repository,
  }) : super(RegistrationsState.empty());

  bool get isOwner =>
      state.course.toNullable()?.professorId == state.user.toNullable()?.id;

  Unit init(int courseId) {
    update(RegistrationsState.empty());
    getData(courseId);

    return unit;
  }

  Future<Unit> getData(int courseId) async {
    setLoading(true);

    final user = getLoggedUser();
    final course = repository.getCourseById(courseId);
    final registrations = repository.getCourseRegistrations(courseId);

    await Future.wait([user, course, registrations]);

    user.then(
      (value) => value.match(setError, (r) => update(state.copyWith(user: r))),
    );
    course.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(course: r))),
    );

    registrations.then(
      (value) => value.match(
          setError, (r) => update(state.copyWith(registrations: r))),
    );

    return unit;
  }

  Future<Unit> removePerson(int courseId, int registrationId) async {
    await repository.removePerson(courseId, registrationId);
    getData(courseId);
    return unit;
  }

  Future<Unit> joinCourse(String code) async {
    setLoading(true);
    final result = await repository.joinCourse(code.toUpperCase());
    setLoading(false);

    result.fold(setError, (r) {});
    return unit;
  }

  Future<Unit> leaveCourse() async {
    final course = state.course.toNullable();

    if (course == null) return unit;
    await repository.leaveCourse(course.id);

    return unit;
  }

  Unit clear() {
    update(RegistrationsState.empty());
    return unit;
  }
}

class RegistrationsState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;

  final List<RegistrationEntity> registrations;

  RegistrationsState({
    required this.course,
    required this.user,
    required this.registrations,
  });

  factory RegistrationsState.empty() => RegistrationsState(
        course: none(),
        user: none(),
        registrations: [],
      );

  RegistrationsState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
    List<RegistrationEntity>? registrations,
  }) {
    return RegistrationsState(
      course: course ?? this.course,
      user: user ?? this.user,
      registrations: registrations ?? this.registrations,
    );
  }
}
