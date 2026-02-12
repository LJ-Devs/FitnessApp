import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/exercise_enums.dart';
import '../../domain/usecases/create_exercise.dart';
import '../../domain/usecases/delete_exercise.dart';
import '../../domain/usecases/get_all_exercises.dart';
import '../../domain/usecases/get_exercises_by_muscle_group.dart';
import '../../domain/usecases/update_exercise.dart';

class ExerciseViewModel extends ChangeNotifier {
  // Domain Use Cases
  final CreateExercise _createExercise;
  final DeleteExercise _deleteExercise;
  final GetExercisesByMuscleGroup _getExercisesByMuscleGroup;
  final GetAllExercises _getAllExercises;
  final UpdateExercise _updateExercise;

  // State Variables
  List<ExerciseEntity> _exercises = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Track which filter is currently active
  MuscleGroup? _currentMuscleGroup; 

  // Public Getters
  List<ExerciseEntity> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MuscleGroup? get currentMuscleGroup => _currentMuscleGroup;

  // Constructor
  ExerciseViewModel({
    required CreateExercise createExercise,
    required DeleteExercise deleteExercise,
    required GetExercisesByMuscleGroup getExercisesByMuscleGroup,
    required GetAllExercises getAllExercises,
    required UpdateExercise updateExercise,
  })  : _createExercise = createExercise,
        _deleteExercise = deleteExercise,
        _getExercisesByMuscleGroup = getExercisesByMuscleGroup,
        _getAllExercises = getAllExercises,
        _updateExercise = updateExercise;

  // Loads exercises filtered by a specific Muscle Group
  Future<void> loadExercisesByMuscle(MuscleGroup group) async {
    _currentMuscleGroup = group;
    _setLoading(true);

    final result = await _getExercisesByMuscleGroup(group);

    _handleResult(result);
  }

  // Loads all exercises
  Future<void> loadAllExercises() async {
    _currentMuscleGroup = null; // Null implies all
    _setLoading(true);

    final result = await _getAllExercises();

    _handleResult(result);
  }

  // Returns true if successful false otherwise
  Future<bool> addExercise(ExerciseEntity exercise) async {
    _setLoading(true);

    final result = await _createExercise(exercise);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        if (_currentMuscleGroup != null) {
          loadExercisesByMuscle(_currentMuscleGroup!);
        } else {
          loadAllExercises();
        }
        return true;
      },
    );
  }

  // Updates an existing exercise
  Future<bool> editExercise(ExerciseEntity exercise) async {
    _setLoading(true);

    final result = await _updateExercise(exercise);

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        final index = _exercises.indexWhere((e) => e.id == exercise.id);
        if (index != -1) {
          _exercises[index] = exercise;
        }
        _setLoading(false);
        return true;
      },
    );
  }

  // Deletes an exercise by ID
  Future<void> removeExercise(String exerciseId) async {
    // Remove from UI immediately for better UX
    final backupList = List<ExerciseEntity>.from(_exercises);
    _exercises.removeWhere((e) => e.id == exerciseId);
    notifyListeners();

    // Perform the actual API call
    final result = await _deleteExercise(exerciseId);

    // Rollback if it fails
    result.fold(
      (failure) {
        _exercises = backupList; // Restore list
        _setError(failure.message);
      },
      (_) {
        // Success: Do nothing, list is already updated
      },
    );
  }

  // Private Helpers
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) _errorMessage = null; // Clear errors when starting a new action
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void _handleResult(Either<Failure, List<ExerciseEntity>> result) {
    result.fold(
      (failure) => _setError(failure.message),
      (data) {
        _exercises = data;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}