import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:conecta/app/modules/courses/domain/entities/entities.dart';

class AssignmentSubmissionModel extends AssignmentSubmissionEntity {
  AssignmentSubmissionModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.assignmentId,
    required super.courseId,
    super.finishDate,
    super.editDate,
    super.grade,
    required super.content,
    required super.status,
  });

  AssignmentSubmissionModel copyWith({
    int? id,
    int? studentId,
    String? studentName,
    int? assignmentId,
    int? courseId,
    DateTime? finishDate,
    DateTime? editDate,
    int? grade,
    String? content,
    SubmissionStatus? status,
  }) {
    return AssignmentSubmissionModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      assignmentId: assignmentId ?? this.assignmentId,
      courseId: courseId ?? this.courseId,
      finishDate: finishDate ?? this.finishDate,
      editDate: editDate ?? this.editDate,
      grade: grade ?? this.grade,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'assignmentId': assignmentId,
      'courseId': courseId,
      'finishDate': finishDate?.toIso8601String(),
      'editDate': editDate?.toIso8601String(),
      'grade': grade,
      'content': content,
      'status': status.name,
    };
  }

  factory AssignmentSubmissionModel.fromMap(Map<String, dynamic> map) {
    return AssignmentSubmissionModel(
      id: map['id']?.toInt() ?? 0,
      studentId: map['studentId']?.toInt() ?? 0,
      studentName: map['studentName'] ?? '',
      assignmentId: map['assignmentId']?.toInt() ?? 0,
      courseId: map['courseId']?.toInt() ?? 0,
      finishDate:
          map['finishDate'] != null ? DateTime.parse(map['finishDate']) : null,
      editDate:
          map['editDate'] != null ? DateTime.parse(map['editDate']) : null,
      grade: map['grade']?.toInt(),
      content: map['content'] ?? '',
      status: SubmissionStatus.values.firstWhereOrNull(
            (e) =>
                e.name ==
                (map['status'].toString().toLowerCase().replaceAll('_', '')),
          ) ??
          SubmissionStatus.pending,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignmentSubmissionModel.fromJson(String source) =>
      AssignmentSubmissionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssignmentSubmissionModel(id: $id, studentName: $studentName, studentId: $studentId, assignmentId: $assignmentId, courseId: $courseId, finishDate: $finishDate, editDate: $editDate, grade: $grade, content: $content, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssignmentSubmissionModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.studentName == studentName &&
        other.assignmentId == assignmentId &&
        other.courseId == courseId &&
        other.finishDate == finishDate &&
        other.editDate == editDate &&
        other.grade == grade &&
        other.content == content &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        studentName.hashCode ^
        assignmentId.hashCode ^
        courseId.hashCode ^
        finishDate.hashCode ^
        editDate.hashCode ^
        grade.hashCode ^
        content.hashCode ^
        status.hashCode;
  }
}
