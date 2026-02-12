import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entity.dart';
import '../entities/exercise_enums.dart';
import '../repositories/exercise_repository.dart';

class GetExercisesByMuscleGroup {
  final ExerciseRepository repository;

  GetExercisesByMuscleGroup(this.repository);

  Future<Either<Failure, List<ExerciseEntity>>> call(MuscleGroup group) async {
    return await repository.getExercisesByMuscleGroup(group);
  }
}