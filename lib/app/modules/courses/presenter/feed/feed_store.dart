import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/auth/domain/entities/user_entity.dart';
import 'package:conecta/app/modules/auth/domain/usecases/get_logged_user.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/domain/repositories/repositories.dart';
import 'package:conecta/app/modules/courses/domain/usecases/get_course_by_id.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class FeedStore extends NotifierStore<AppContentFailure, FeedState> {
  final IGetLoggedUser getLoggedUser;
  final IGetCourseById getCourseById;
  final IFeedRepository feedRepository;

  FeedStore({
    required this.getLoggedUser,
    required this.getCourseById,
    required this.feedRepository,
  }) : super(FeedState.empty());

  bool get isOwner =>
      state.course.toNullable()?.professorId == state.user.toNullable()?.id;

  Unit init(int courseId) {
    update(FeedState.empty());
    getData(courseId);

    return unit;
  }

  Future<Unit> getData(int courseId) async {
    setLoading(true);

    final user = getLoggedUser();
    final course = getCourseById(courseId);
    final feed = feedRepository.getCourseFeed(courseId);

    await Future.wait([user, course, feed]);

    user.then(
      (value) => value.match(setError, (r) => update(state.copyWith(user: r))),
    );
    course.then(
      (value) =>
          value.match(setError, (r) => update(state.copyWith(course: r))),
    );
    feed.then(
      (value) => value.match(setError, (r) => update(state.copyWith(feed: r))),
    );

    return unit;
  }

  Future<Unit> editPost(int postId, String title, String content) async {
    final course = state.course.toNullable();
    final author = state.user.toNullable();

    if (course == null || author == null) return unit;

    await feedRepository.editPost(
      postId: postId,
      title: title,
      content: content,
    );
    await getData(course.id);
    return unit;
  }

  Future<Unit> createPost(String title, String content) async {
    final course = state.course.toNullable();
    final author = state.user.toNullable();

    if (course == null || author == null) return unit;

    await feedRepository.createPost(
      courseId: course.id,
      authorId: author.id,
      title: title,
      content: content,
    );

    await getData(course.id);
    return unit;
  }

  Future<Unit> deletePost(PostEntity post) async {
    await feedRepository.deletePost(post.id);
    getData(post.courseId);
    return unit;
  }

  Unit clear() {
    update(FeedState.empty());
    return unit;
  }
}

class FeedState {
  final Option<CourseEntity> course;
  final Option<UserEntity> user;
  final List<PostEntity> feed;

  FeedState({
    required this.course,
    required this.user,
    required this.feed,
  });

  factory FeedState.empty() => FeedState(
        course: none(),
        user: none(),
        feed: [],
      );

  FeedState copyWith({
    Option<CourseEntity>? course,
    Option<UserEntity>? user,
    List<PostEntity>? feed,
  }) {
    return FeedState(
      course: course ?? this.course,
      user: user ?? this.user,
      feed: feed ?? this.feed,
    );
  }
}
