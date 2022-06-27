import 'dart:convert';

import '../../domain/entities/entities.dart';

class AssignmentModel extends AssignmentEntity {
  AssignmentModel({
    required super.id,
    required super.professorId,
    required super.professorName,
    required super.courseId,
    required super.courseName,
    required super.title,
    required super.subtitle,
    required super.content,
    required super.grade,
    required super.creationDate,
    required super.editDate,
    required super.dueDate,
  });

  factory AssignmentModel.fromEntity(AssignmentEntity assignment) {
    return AssignmentModel(
      id: assignment.id,
      professorId: assignment.professorId,
      professorName: assignment.professorName,
      courseId: assignment.courseId,
      courseName: assignment.courseName,
      title: assignment.title,
      subtitle: assignment.subtitle,
      content: assignment.content,
      grade: assignment.grade,
      creationDate: assignment.creationDate,
      editDate: assignment.editDate,
      dueDate: assignment.dueDate,
    );
  }

  AssignmentModel copyWith({
    int? id,
    int? professorId,
    String? professorName,
    int? courseId,
    String? courseName,
    String? title,
    String? subtitle,
    String? content,
    int? grade,
    DateTime? creationDate,
    DateTime? editDate,
    DateTime? dueDate,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      professorId: professorId ?? this.professorId,
      professorName: professorName ?? this.professorName,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      grade: grade ?? this.grade,
      creationDate: creationDate ?? this.creationDate,
      editDate: editDate ?? this.editDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'professorId': professorId,
      'professorName': professorName,
      'courseId': courseId,
      'courseName': courseName,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'grade': grade,
      'creationDate': creationDate,
      'editDate': editDate,
      'dueDate': dueDate,
    };
  }

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id']?.toInt() ?? 0,
      professorId: map['professorId']?.toInt() ?? 0,
      professorName: map['professorName'] ?? '',
      courseId: map['courseId']?.toInt() ?? 0,
      courseName: map['courseName'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      content: map['content'] ?? '',
      grade: map['grade']?.toInt() ?? 0,
      creationDate: DateTime.parse(
        map['creationDate'] ?? DateTime.now().toIso8601String(),
      ),
      editDate:
          map['editDate'] != null ? DateTime.parse(map['editDate']) : null,
      dueDate: DateTime.parse(map['dueDate'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignmentModel.fromJson(String source) =>
      AssignmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssignmentModel(id: $id, professorId: $professorId, professorName: $professorName, courseId: $courseId, courseName: $courseName, title: $title, subtitle: $subtitle, content: $content, grade: $grade, creationDate: $creationDate, editDate: $editDate, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssignmentModel &&
        other.id == id &&
        other.professorId == professorId &&
        other.professorName == professorName &&
        other.courseId == courseId &&
        other.courseName == courseName &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.content == content &&
        other.grade == grade &&
        other.creationDate == creationDate &&
        other.editDate == editDate &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        professorId.hashCode ^
        professorName.hashCode ^
        courseId.hashCode ^
        courseName.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        content.hashCode ^
        grade.hashCode ^
        creationDate.hashCode ^
        editDate.hashCode ^
        dueDate.hashCode;
  }
}
