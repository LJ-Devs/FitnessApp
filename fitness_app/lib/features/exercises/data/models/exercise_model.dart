import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/exercise_enums.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.muscleGroup,
    required super.equipment,
    super.videoUrl,
    super.coverUrl,
  });

  // Convert a JSON map (from Firestore) into Model
  factory ExerciseModel.fromJson(Map<String, dynamic> json, String id) {
    return ExerciseModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // Safety check if the DB string doesnt match any Enum, default to 'other'
      muscleGroup: _stringToMuscleGroup(json['muscleGroup']),
      equipment: _stringToEquipment(json['equipment']),
      videoUrl: json['videoUrl'],
      coverUrl: json['coverUrl'],
    );
  }

  // Create Model directly from a Firestore DocumentSnapshot
  factory ExerciseModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      // Surface an error if the document data is null instead of returning a synthetic model
      throw StateError('Exercise document ${doc.id} has null data.');
    }
    
    return ExerciseModel.fromJson(data, doc.id);
  }

  // Converts Model to JSON (to send to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'muscleGroup': muscleGroup.name,
      'equipment': equipment.name,
      'videoUrl': videoUrl,
      'coverUrl': coverUrl,
      'updatedAt': FieldValue.serverTimestamp(), // Useful for sorting
    };
  }

  // Private Helpers to safely convert String <-> Enum

  static MuscleGroup _stringToMuscleGroup(String? value) {
    return MuscleGroup.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MuscleGroup.other, // Fallback if not found
    );
  }

  static Equipment _stringToEquipment(String? value) {
    return Equipment.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Equipment.other, // Fallback if not found
    );
  }
}