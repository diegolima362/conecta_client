import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../infra/datasources/datasources.dart';
import '../../infra/models/models.dart';
import 'utils/api_paths.dart' as api;

class FeedRemoteDatasource implements IFeedRemoteDatasource {
  final Dio client;

  FeedRemoteDatasource(this.client);

  @override
  Future<List<PostModel>> getCourseFeed(int courseId) async {
    try {
      final url = '${api.urlCourses}/$courseId/feed';

      final result = await client.get(url);

      final response = result.data as List;

      final data = response.map((e) => PostModel.fromMap(e)).toList();

      final feed = <PostModel>[];

      for (final p in data) {
        final replies = <int, List<CommentModel>>{};
        final comments = <CommentModel>[];

        for (final c in p.comments) {
          final replyTo = c.replyTo;
          if (replyTo != null) {
            if (!replies.containsKey(replyTo)) {
              replies[replyTo] = <CommentModel>[];
            }
            replies[replyTo]!.add(c as CommentModel);
          } else {
            comments.add(c as CommentModel);
          }
        }
        final postComments = <CommentModel>[];
        for (final c in comments) {
          if (replies.containsKey(c.id)) {
            postComments.add(c.copyWith(replies: replies[c.id] ?? []));
          } else {
            postComments.add(c);
          }
        }

        feed.add(p.copyWith(comments: postComments));
      }

      return feed;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteFeedError(message: message);
    }
  }

  @override
  Future<Unit> createPost(
      int courseId, int authorId, String title, String content) async {
    try {
      final data = {
        "courseId": courseId,
        "authorId": authorId,
        "title": title,
        "content": content,
      };

      await client.post(api.urlFeed, data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteFeedError(message: message);
    }
  }

  @override
  Future<Unit> editPost(int postId, String title, String content) async {
    try {
      final data = {
        "title": title,
        "content": content,
      };

      await client.put('${api.urlFeed}/$postId', data: json.encode(data));

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteFeedError(message: message);
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    try {
      await client.delete('${api.urlFeed}/$postId');

      return unit;
    } on DioError catch (e) {
      String message = 'Erro de conexão!';

      if (e.response?.statusCode == 403) {
        message = 'Operação Não Autorizada!';
      }
      throw RemoteFeedError(message: message);
    }
  }
}
