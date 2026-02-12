import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(String muscleGroup);
  Future<List<ExerciseModel>> getAllExercises();
  Future<void> createExercise(ExerciseModel exercise);
  Future<void> updateExercise(ExerciseModel exercise);
  Future<void> deleteExercise(String exerciseId);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExerciseRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(String muscleGroup) async {
    try {
      final snapshot = await firestore
          .collection('exercises')
          .where('muscleGroup', isEqualTo: muscleGroup)
          .orderBy('name') // Sort alphabetically
          .get();

      return snapshot.docs
          .map((doc) => ExerciseModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final snapshot = await firestore
          .collection('exercises')
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => ExerciseModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> createExercise(ExerciseModel exercise) async {
    try {
      // Use logic to generate ID if not provided or let Firestore generate it
      final docRef = firestore.collection('exercises').doc();
      
      // Create a copy of the model with the new ID
      final newModel = ExerciseModel(
        id: docRef.id,
        name: exercise.name,
        description: exercise.description,
        muscleGroup: exercise.muscleGroup,
        equipment: exercise.equipment,
        videoUrl: exercise.videoUrl,
        coverUrl: exercise.coverUrl,
      );

      await docRef.set(newModel.toJson());
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateExercise(ExerciseModel exercise) async {
    try {
      await firestore
          .collection('exercises')
          .doc(exercise.id)
          .update(exercise.toJson());
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteExercise(String exerciseId) async {
    try {
      await firestore.collection('exercises').doc(exerciseId).delete();
    } catch (e) {
      throw ServerException();
    }
  }
}