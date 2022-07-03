import 'package:fpdart/fpdart.dart';

import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/datasources.dart';

class FeedRepository implements IFeedRepository {
  final IFeedRemoteDatasource remoteData;

  final coursesCache = <CourseEntity>[];
  final assignmentsCache = <AssignmentEntity>[];
  final registrationsCache = <RegistrationEntity>[];

  FeedRepository(this.remoteData);

  @override
  Future<EitherFeed> getCourseFeed(int courseId) async {
    try {
      final result = await remoteData.getCourseFeed(courseId);

      return Right(result);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> createPost({
    required int courseId,
    required int authorId,
    required String title,
    required String content,
  }) async {
    try {
      await remoteData.createPost(courseId, authorId, title, content);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> editPost({
    required int postId,
    required String title,
    required String content,
  }) async {
    try {
      await remoteData.editPost(postId, title, content);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherUnit> deletePost(int postId) async {
    try {
      await remoteData.deletePost(postId);

      return const Right(unit);
    } on CoursesFailure catch (e) {
      return Left(e);
    }
  }
}
