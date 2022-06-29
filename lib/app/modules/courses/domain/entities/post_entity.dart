// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:conecta/app/modules/courses/domain/entities/entities.dart';

class PostEntity {
  final int id;
  final int authorId;
  final String authorName;
  final String authorUsername;
  final int courseId;
  final String courseTitle;
  final String title;
  final String content;
  final DateTime creationDate;
  final DateTime? editDate;

  final List<CommentEntity> comments;

  PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.courseId,
    required this.courseTitle,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.editDate,
    required this.comments,
  });
}
