import 'dart:convert';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String accessToken;
  final String refreshToken;
  final String password;

  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.username,
    required super.admin,
    required this.password,
    required this.accessToken,
    required this.refreshToken,
  });

  UserEntity toLoggedUser() => this;

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? password,
    String? accessToken,
    String? refreshToken,
    bool? admin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      admin: admin ?? this.admin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'admin': admin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      admin: map['admin'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => toJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.password == password &&
        other.accessToken == accessToken &&
        other.admin == admin &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        accessToken.hashCode ^
        admin.hashCode ^
        refreshToken.hashCode;
  }
}
