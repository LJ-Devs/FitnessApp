import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

class CreateExercise {
  final ExerciseRepository repository;

  CreateExercise(this.repository);

  Future<Either<Failure, Unit>> call(ExerciseEntity exercise) async {
    return await repository.createExercise(exercise);
  }
}