class AssignmentSubmissionEntity {
  final int id;
  final int studentId;
  final int assignmentId;
  final String studentName;
  final int courseId;

  final DateTime? finishDate;
  final DateTime? editDate;

  final int? grade;

  final String content;
  final SubmissionStatus status;

  AssignmentSubmissionEntity({
    required this.id,
    required this.studentId,
    required this.assignmentId,
    required this.studentName,
    required this.courseId,
    this.finishDate,
    this.editDate,
    this.grade,
    required this.content,
    required this.status,
  });
}

enum SubmissionStatus {
  pending,
  done,
  donelate,
  returned;

  String format() {
    if (name == 'pending') {
      return 'Pendente';
    } else if (name == 'done') {
      return 'Entregue';
    } else if (name == 'donelate') {
      return 'Entregue com atraso';
    } else if (name == 'returned') {
      return 'Corrigida';
    }

    return 'Não definido';
  }
}
