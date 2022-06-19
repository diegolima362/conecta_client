// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

import '../auth/domain/entities/user_entity.dart';

class HomeStore extends NotifierStore<AppContentFailure, HomeState> {
  final IGetCourses getCourses;
  final IGetLoggedUser getLoggedUser;

  HomeStore(this.getCourses, this.getLoggedUser) : super(HomeState.empty());

  Future<Unit> getData({bool cached = true}) async {
    final result = await getCourses(cached: cached);

    final user = await getLoggedUser();

    result.fold(setError, (r) => update(state.copyWith(courses: r)));
    user.fold(setError, (r) => update(state.copyWith(user: r)));

    return unit;
  }
}

class HomeState {
  final Option<UserEntity> user;
  final List<CourseEntity> courses;

  HomeState({required this.user, required this.courses});

  factory HomeState.empty() => HomeState(user: none(), courses: []);

  HomeState copyWith({
    Option<UserEntity>? user,
    List<CourseEntity>? courses,
  }) {
    return HomeState(
      user: user ?? this.user,
      courses: courses ?? this.courses,
    );
  }
}
