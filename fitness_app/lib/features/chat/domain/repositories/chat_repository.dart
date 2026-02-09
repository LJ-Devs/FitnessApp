import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_room_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // Send returns success or failure only
  Future<Either<Failure, void>> sendMessage(MessageEntity message);

  // Read -> returns a message list Stream
  Stream<List<MessageEntity>> getMessages(String currentUserId, String otherUserId);

  // Read -> returns a list of rooms
  Stream<List<ChatRoomEntity>> getChatRooms(String currentUserId);
}