import 'dart:convert';

import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/foundation.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.authorUsername,
    required super.postId,
    required super.postCourseId,
    required super.postCourseName,
    required super.replyTo,
    required super.replies,
    required super.content,
    required super.creationDate,
    super.editDate,
  });

  CommentModel copyWith({
    int? id,
    int? authorId,
    String? authorName,
    String? authorUsername,
    int? postId,
    int? postCourseId,
    String? postCourseName,
    int? replyTo,
    List<CommentModel>? replies,
    String? content,
    DateTime? creationDate,
    DateTime? editDate,
  }) {
    return CommentModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      postId: postId ?? this.postId,
      postCourseId: postCourseId ?? this.postCourseId,
      postCourseName: postCourseName ?? this.postCourseName,
      replyTo: replyTo ?? this.replyTo,
      replies: replies ?? this.replies,
      content: content ?? this.content,
      creationDate: creationDate ?? this.creationDate,
      editDate: editDate ?? this.editDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorUsername': authorUsername,
      'postId': postId,
      'postCourseId': postCourseId,
      'postCourseName': postCourseName,
      'replyTo': replyTo,
      'replies': [],
      'content': content,
      'creationDate': creationDate.toIso8601String(),
      'editDate': editDate?.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int,
      authorId: map['authorId'] as int,
      authorName: map['authorName'] as String,
      authorUsername: map['authorUsername'] as String,
      postId: map['postId'] as int,
      postCourseId: map['postCourseId'] as int,
      postCourseName: map['postCourseName'] as String,
      replyTo: map['replyTo'] != null ? map['replyTo'] as int : null,
      replies: [],
      content: map['content'] as String,
      creationDate: map['editDate'] != null
          ? DateTime.parse(map['creationDate'])
          : DateTime.now(),
      editDate:
          map['editDate'] != null ? DateTime.parse(map['editDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, authorId: $authorId, authorName: $authorName, authorUsername: $authorUsername, postId: $postId, postCourseId: $postCourseId, postCourseName: $postCourseName, replyTo: $replyTo, replies: $replies, content: $content, creationDate: $creationDate, editDate: $editDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.id == id &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.authorUsername == authorUsername &&
        other.postId == postId &&
        other.postCourseId == postCourseId &&
        other.postCourseName == postCourseName &&
        other.replyTo == replyTo &&
        listEquals(other.replies, replies) &&
        other.content == content &&
        other.creationDate == creationDate &&
        other.editDate == editDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        authorId.hashCode ^
        authorName.hashCode ^
        authorUsername.hashCode ^
        postId.hashCode ^
        postCourseId.hashCode ^
        postCourseName.hashCode ^
        replyTo.hashCode ^
        replies.hashCode ^
        content.hashCode ^
        creationDate.hashCode ^
        editDate.hashCode;
  }
}
