import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String uid) async {
    try {
      final userModel = await remoteDataSource.getUserProfile(uid);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile({
    required String uid,
    required String name,
    File? imageFile,
  }) async {
    try {
      String? photoUrl;

      // Upload if the user choose a new photo
      if (imageFile != null) {
        photoUrl = await remoteDataSource.uploadProfileImage(imageFile, uid);
      }

      // Update text data
      await remoteDataSource.updateUserData(
        uid: uid,
        name: name,
        photoUrl: photoUrl,
      );

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("Erro ao atualizar perfil: $e"));
    }
  }
}