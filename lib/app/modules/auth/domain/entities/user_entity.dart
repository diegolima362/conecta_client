class UserEntity {
  final int id;
  final String name;
  final String username;
  final String email;
  final bool admin;

  UserEntity({
    this.id = 0,
    required this.name,
    required this.username,
    required this.email,
    required this.admin,
  });
}
