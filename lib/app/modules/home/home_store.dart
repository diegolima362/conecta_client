import 'package:conecta/app/core/domain/errors/erros.dart';
import 'package:conecta/app/modules/courses/domain/entities/course_entity.dart';
import 'package:conecta/app/modules/courses/domain/usecases/usecases.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class HomeStore extends NotifierStore<AppContentFailure, List<CourseEntity>> {
  final IGetCourses usecase;

  HomeStore(this.usecase) : super([]);

  Future<Unit> getData() async {
    final result = await usecase();

    result.fold(setError, update);

    return unit;
  }
}
