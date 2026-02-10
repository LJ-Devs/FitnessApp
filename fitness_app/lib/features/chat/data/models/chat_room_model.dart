import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.participants,
    super.unreadCount,
  });

  factory ChatRoomModel.fromSnapshot(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      participants: List<String>.from(map['participants'] ?? []),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }
}