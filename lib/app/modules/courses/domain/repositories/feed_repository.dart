import '../types/types.dart';

abstract class IFeedRepository {
  Future<EitherFeed> getCourseFeed(int courseId);

  Future<EitherUnit> createPost({
    required int courseId,
    required int authorId,
    required String title,
    required String content,
  });

  Future<EitherUnit> editPost({
    required int postId,
    required String title,
    required String content,
  });

  Future<EitherUnit> deletePost(int postId);
}
