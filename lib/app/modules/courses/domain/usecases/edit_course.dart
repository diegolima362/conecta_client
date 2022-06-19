import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';

import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IEditCourse {
  Future<EitherUnit> call(CourseEntity courseEntity);
}

class EditCourse implements IEditCourse {
  final ICoursesRepository repository;

  EditCourse(this.repository);

  @override
  Future<EitherUnit> call(CourseEntity courseEntity) async {
    return await repository.editCourse(courseEntity);
  }
}
