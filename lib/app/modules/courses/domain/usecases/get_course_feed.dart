import '../repositories/repositories.dart';
import '../types/types.dart';

abstract class IGetCourseFeed {
  Future<EitherFeed> call(int courseId);
}

class GetCourseFeed implements IGetCourseFeed {
  final IFeedRepository repository;

  GetCourseFeed(this.repository);

  @override
  Future<EitherFeed> call(int courseId) async {
    return await repository.getCourseFeed(courseId);
  }
}
