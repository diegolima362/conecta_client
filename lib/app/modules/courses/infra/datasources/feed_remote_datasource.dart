import 'package:fpdart/fpdart.dart';

import '../models/models.dart';

abstract class IFeedRemoteDatasource {
  Future<List<PostModel>> getCourseFeed(int courseId);

  Future<Unit> createPost(
    int courseId,
    int authorId,
    String title,
    String content,
  );

  Future<Unit> editPost(int postId, String title, String content);

  Future<Unit> deletePost(int postId);
}
