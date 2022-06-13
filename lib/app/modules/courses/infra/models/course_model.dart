import 'dart:convert';

import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.name,
    required super.professor,
    required super.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'professor': professor,
      'code': code,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      name: map['name'],
      professor: map['professor'],
      code: map['code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source));

  CourseModel copyWith({
    int? id,
    String? name,
    String? professor,
    String? code,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      professor: professor ?? this.professor,
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
        other.professor == professor;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ professor.hashCode ^ code.hashCode;
  }
}
