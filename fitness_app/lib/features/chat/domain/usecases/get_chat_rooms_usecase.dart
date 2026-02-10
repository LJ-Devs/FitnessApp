import '../entities/chat_room_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatRoomsUseCase {
  final ChatRepository repository;

  GetChatRoomsUseCase(this.repository);

  Stream<List<ChatRoomEntity>> call(String currentUserId) {
    return repository.getChatRooms(currentUserId);
  }
}