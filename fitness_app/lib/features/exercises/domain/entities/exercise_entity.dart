import 'package:equatable/equatable.dart';
import 'exercise_enums.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final String? videoUrl;
  final String? coverUrl;

  const ExerciseEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipment,
    this.videoUrl,
    this.coverUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    muscleGroup,
    equipment,
    videoUrl,
    coverUrl,
  ];
}