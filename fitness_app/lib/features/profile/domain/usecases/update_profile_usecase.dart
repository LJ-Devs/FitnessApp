import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

// Params class to encapsulate all data needed for the update
class UpdateProfileParams {
  final String uid;
  final String name;
  final File? imageFile; // Optional: only if user picked a new photo

  UpdateProfileParams({
    required this.uid,
    required this.name,
    this.imageFile,
  });
}

class UpdateProfileUseCase implements UseCase<Unit, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      uid: params.uid,
      name: params.name,
      imageFile: params.imageFile,
    );
  }
}