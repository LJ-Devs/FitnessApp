import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/exercise_enums.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../models/exercise_model.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercisesByMuscleGroup(
    MuscleGroup group,
  ) async {
    try {
      // Convert Enum (Domain) to String (Data)
      final groupString = group.name; 
      
      // Call the API/Firebase
      final remoteExercises = await remoteDataSource.getExercisesByMuscleGroup(groupString);
      
      // Return success (Right)
      return Right(remoteExercises);
    } on ServerException {
      // Return failure (Left)
      return Left(ServerFailure());
    } catch (e) {
      // Catch-all for unexpected errors
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getAllExercises() async {
    try {
      final remoteExercises = await remoteDataSource.getAllExercises();
      return Right(remoteExercises);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createExercise(ExerciseEntity exercise) async {
    try {
      // Convert Entity -> Model to send to Data Source
      final exerciseModel = ExerciseModel(
        id: exercise.id,
        name: exercise.name,
        description: exercise.description,
        muscleGroup: exercise.muscleGroup,
        equipment: exercise.equipment,
        videoUrl: exercise.videoUrl,
        coverUrl: exercise.coverUrl,
      );

      await remoteDataSource.createExercise(exerciseModel);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateExercise(ExerciseEntity exercise) async {
    try {
      final exerciseModel = ExerciseModel(
        id: exercise.id,
        name: exercise.name,
        description: exercise.description,
        muscleGroup: exercise.muscleGroup,
        equipment: exercise.equipment,
        videoUrl: exercise.videoUrl,
        coverUrl: exercise.coverUrl,
      );

      await remoteDataSource.updateExercise(exerciseModel);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExercise(String exerciseId) async {
    try {
      await remoteDataSource.deleteExercise(exerciseId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}