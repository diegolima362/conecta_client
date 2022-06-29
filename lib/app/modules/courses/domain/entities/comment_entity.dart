// ignore_for_file: public_member_api_docs, sort_constructors_first

class CommentEntity {
  final int id;
  final int authorId;
  final String authorName;
  final String authorUsername;
  final int postId;
  final int postCourseId;
  final String postCourseName;
  final int? replyTo;
  final List<CommentEntity> replies;
  final String content;
  final DateTime creationDate;
  final DateTime? editDate;

  CommentEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.postId,
    required this.postCourseId,
    required this.postCourseName,
    required this.replyTo,
    required this.replies,
    required this.content,
    required this.creationDate,
    this.editDate,
  });
}
