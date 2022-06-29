import 'dart:convert';

import 'package:conecta/app/modules/courses/domain/entities/entities.dart';

class RegistrationModel extends RegistrationEntity {
  RegistrationModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.studentUsername,
    required super.studentEmail,
    required super.courseId,
    required super.courseName,
    required super.registeredAt,
  });

  RegistrationModel copyWith({
    int? id,
    int? studentId,
    String? studentName,
    String? studentUsername,
    String? studentEmail,
    int? courseId,
    String? courseName,
    DateTime? registeredAt,
  }) {
    return RegistrationModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentUsername: studentUsername ?? this.studentUsername,
      studentEmail: studentEmail ?? this.studentEmail,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentUsername': studentUsername,
      'studentEmail': studentEmail,
      'courseId': courseId,
      'courseName': courseName,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      id: map['id']?.toInt() ?? 0,
      studentId: map['studentId']?.toInt() ?? 0,
      studentName: map['studentName'] ?? '',
      studentUsername: map['studentUsername'] ?? '',
      studentEmail: map['studentEmail'] ?? '',
      courseId: map['courseId']?.toInt() ?? 0,
      courseName: map['courseName'] ?? '',
      registeredAt: map['registeredAt'] != null
          ? DateTime.parse(map['registeredAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationModel.fromJson(String source) =>
      RegistrationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RegistrationModel(id: $id, studentId: $studentId, studentName: $studentName, studentUsername: $studentUsername, studentEmail: $studentEmail, courseId: $courseId, courseName: $courseName, registeredAt: $registeredAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegistrationModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.studentName == studentName &&
        other.studentUsername == studentUsername &&
        other.studentEmail == studentEmail &&
        other.courseId == courseId &&
        other.courseName == courseName &&
        other.registeredAt == registeredAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        studentName.hashCode ^
        studentUsername.hashCode ^
        studentEmail.hashCode ^
        courseId.hashCode ^
        courseName.hashCode ^
        registeredAt.hashCode;
  }
}
