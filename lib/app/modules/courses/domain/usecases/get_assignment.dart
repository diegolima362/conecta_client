import '../repositories/repositories.dart';
import '../types/types.dart';

abstract class IGetAssignment {
  Future<EitherAssignment> call(int id);
}

class GetAssignment implements IGetAssignment {
  final IAssignmentsRepository repository;

  GetAssignment(this.repository);

  @override
  Future<EitherAssignment> call(int id) async {
    return await repository.getAssignment(id);
  }
}
