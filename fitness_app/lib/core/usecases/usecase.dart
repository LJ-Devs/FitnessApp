import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

// This is the parent interface for all actions
// Type = What is returned on success
// Params = What you need to perform the action

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Helper class for when the UseCase doesn't require parameters
class NoParams {}