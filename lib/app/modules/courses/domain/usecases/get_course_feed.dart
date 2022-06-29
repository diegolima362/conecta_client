import '../repositories/courses_repository.dart';
import '../types/types.dart';

abstract class IGetCourseFeed {
  Future<EitherFeed> call(int courseId);
}

class GetCourseFeed implements IGetCourseFeed {
  final ICoursesRepository repository;

  GetCourseFeed(this.repository);

  @override
  Future<EitherFeed> call(int courseId) async {
    return await repository.getCourseFeed(courseId);
  }
}
