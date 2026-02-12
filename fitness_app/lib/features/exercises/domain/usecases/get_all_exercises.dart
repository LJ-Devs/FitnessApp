import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

class GetAllExercises {
  final ExerciseRepository repository;

  GetAllExercises(this.repository);

  Future<Either<Failure, List<ExerciseEntity>>> call() async {
    return await repository.getAllExercises();
  }
}