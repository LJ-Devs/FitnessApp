import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise_entity.dart';
import '../entities/exercise_enums.dart';

abstract class ExerciseRepository {
  /// Fetches exercises filtered by a specific muscle group
  Future<Either<Failure, List<ExerciseEntity>>> getExercisesByMuscleGroup(MuscleGroup group);

  /// Fetches all exercises
  Future<Either<Failure, List<ExerciseEntity>>> getAllExercises();

  /// Creates a new exercise in the database
  Future<Either<Failure, Unit>> createExercise(ExerciseEntity exercise);

  /// Updates an existing exercise
  Future<Either<Failure, Unit>> updateExercise(ExerciseEntity exercise);

  /// Deletes an exercise by ID
  Future<Either<Failure, Unit>> deleteExercise(String exerciseId);
}