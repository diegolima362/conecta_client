import 'dart:convert';

class UserInfo {
  final String name;
  final String username;
  final DateTime dob;
  final String email;
  final String password;

  UserInfo({
    required this.name,
    required this.username,
    required this.dob,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'dob': dob.millisecondsSinceEpoch,
      'email': email,
      'password': password,
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      'name': name,
      'username': username,
      'dob': dob.toIso8601String(),
      'email': email,
      'password': password,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      dob: DateTime.fromMillisecondsSinceEpoch(map['dob']),
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source));

  UserInfo copyWith({
    String? name,
    String? username,
    DateTime? dob,
    String? email,
    String? password,
  }) {
    return UserInfo(
      name: name ?? this.name,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'UserInfo(name: $name, username: $username, dob: $dob, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfo &&
        other.name == name &&
        other.username == username &&
        other.dob == dob &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        dob.hashCode ^
        email.hashCode ^
        password.hashCode;
  }
}
