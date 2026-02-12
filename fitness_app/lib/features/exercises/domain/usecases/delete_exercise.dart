import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/exercise_repository.dart';

class DeleteExercise {
  final ExerciseRepository repository;

  DeleteExercise(this.repository);

  Future<Either<Failure, Unit>> call(String exerciseId) async {
    return await repository.deleteExercise(exerciseId);
  }
}