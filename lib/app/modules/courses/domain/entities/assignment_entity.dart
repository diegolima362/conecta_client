class AssignmentEntity {
  final int id;
  final int professorId;
  final String professorName;
  final int courseId;
  final String courseName;
  final String title;
  final String subtitle;
  final String content;
  final int grade;
  final DateTime creationDate;
  final DateTime? editDate;
  final DateTime dueDate;

  AssignmentEntity({
    required this.id,
    required this.professorId,
    required this.professorName,
    required this.courseId,
    required this.courseName,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.grade,
    required this.creationDate,
    required this.editDate,
    required this.dueDate,
  });
}
