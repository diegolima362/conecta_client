import 'dart:convert';

import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.name,
    required super.professorName,
    required super.professorId,
    required super.code,
  });
  factory CourseModel.fromEntity(CourseEntity course) {
    return CourseModel(
      id: course.id,
      name: course.name,
      professorName: course.professorName,
      professorId: course.professorId,
      code: course.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'professorName': professorName,
      'professorId': professorId,
      'code': code,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      name: map['name'],
      professorName: map['professorName'],
      professorId: map['professorId'],
      code: map['code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source));

  CourseModel copyWith({
    int? id,
    String? name,
    String? professorName,
    int? professorId,
    String? code,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      professorName: professorName ?? this.professorName,
      professorId: professorId ?? this.professorId,
      code: code ?? this.code,
    );
  }

  @override
  String toString() => toMap().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseModel &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.professorName == professorName &&
        other.professorId == professorId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        professorName.hashCode ^
        professorId.hashCode ^
        code.hashCode;
  }
}
