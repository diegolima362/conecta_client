class RegistrationEntity {
  final int id;
  final int studentId;
  final String studentName;
  final String studentUsername;
  final String studentEmail;
  final int courseId;
  final String courseName;
  final DateTime registeredAt;

  RegistrationEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentUsername,
    required this.studentEmail,
    required this.courseId,
    required this.courseName,
    required this.registeredAt,
  });
}
