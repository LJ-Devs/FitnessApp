import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> sendMessage(MessageEntity message) async {
    try {
      await remoteDataSource.sendMessage(message);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("Ocorreu um erro, tente novamente"));
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(String currentUserId, String otherUserId) {
    // The error handling in Stream is done in the listen/bloc
    return remoteDataSource.getMessages(currentUserId, otherUserId);
  }

  @override
  Stream<List<ChatRoomEntity>> getChatRooms(String currentUserId) {
    return remoteDataSource.getChatRooms(currentUserId);
  }
}