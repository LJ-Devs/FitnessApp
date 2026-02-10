import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  // Read
  Future<Either<Failure, UserEntity>> getUserProfile(String uid);

  // Update
  Future<Either<Failure, Unit>> updateProfile({
    required String uid,
    required String name,
    File? imageFile,
  });
}