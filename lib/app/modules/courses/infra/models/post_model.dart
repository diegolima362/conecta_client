import 'dart:convert';

import 'package:conecta/app/modules/courses/domain/entities/entities.dart';
import 'package:conecta/app/modules/courses/infra/models/comment_model.dart';
import 'package:flutter/foundation.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.authorUsername,
    required super.courseId,
    required super.courseTitle,
    required super.title,
    required super.content,
    required super.creationDate,
    required super.editDate,
    required super.comments,
  });
  PostModel copyWith({
    int? id,
    int? authorId,
    String? authorName,
    String? authorUsername,
    int? courseId,
    String? courseTitle,
    String? title,
    String? content,
    DateTime? creationDate,
    DateTime? editDate,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      title: title ?? this.title,
      content: content ?? this.content,
      creationDate: creationDate ?? this.creationDate,
      editDate: editDate ?? this.editDate,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorUsername': authorUsername,
      'courseId': courseId,
      'courseName': courseTitle,
      'title': title,
      'content': content,
      'creationDate': creationDate.toIso8601String(),
      'editDate': editDate?.toIso8601String(),
      'comments':
          (comments as List<CommentModel>).map((x) => x.toMap()).toList(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as int,
      authorId: map['authorId'] as int,
      authorName: map['authorName'] as String,
      authorUsername: map['authorUsername'] as String,
      courseId: map['courseId'] as int,
      courseTitle: map['courseName'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      creationDate: map['creationDate'] != null
          ? DateTime.parse(map['creationDate'])
          : DateTime.now(),
      editDate:
          map['editDate'] != null ? DateTime.parse(map['editDate']) : null,
      comments: List<CommentEntity>.from(
        (map['comments'] as List).map<CommentEntity>(
          (x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, authorName: $authorName, authorUsername: $authorUsername, courseId: $courseId, courseTitle: $courseTitle, title: $title, content: $content, creationDate: $creationDate, editDate: $editDate, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.id == id &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.authorUsername == authorUsername &&
        other.courseId == courseId &&
        other.courseTitle == courseTitle &&
        other.title == title &&
        other.content == content &&
        other.creationDate == creationDate &&
        other.editDate == editDate &&
        listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        authorId.hashCode ^
        authorName.hashCode ^
        authorUsername.hashCode ^
        courseId.hashCode ^
        courseTitle.hashCode ^
        title.hashCode ^
        content.hashCode ^
        creationDate.hashCode ^
        editDate.hashCode ^
        comments.hashCode;
  }
}
