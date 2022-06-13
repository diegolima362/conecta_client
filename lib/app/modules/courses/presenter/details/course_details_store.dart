import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

typedef PodcastStoreType
    = NotifierStore<AppContentFailure, CoursetDetailsState>;

class CourseDetailsStore extends PodcastStoreType {
  final IGetCourseById getCourse;

  CourseDetailsStore(this.getCourse)
      : super(
          CoursetDetailsState.empty(),
        );

  Unit init(int podcastId) {
    update(CoursetDetailsState.empty());
    getData(podcastId);

    return unit;
  }

  Future<Unit> getData(int podcastId) async {
    setLoading(true);

    final podcast = await getCourse(podcastId);

    podcast.match(
      setError,
      (r) {
        update(state.copyWith(course: r));
      },
    );

    return unit;
  }
}

class CoursetDetailsState {
  final Option<CourseEntity> course;

  CoursetDetailsState({
    required this.course,
  });

  factory CoursetDetailsState.empty() => CoursetDetailsState(
        course: none(),
      );

  CoursetDetailsState copyWith({
    Option<CourseEntity>? course,
  }) {
    return CoursetDetailsState(
      course: course ?? this.course,
    );
  }
}
