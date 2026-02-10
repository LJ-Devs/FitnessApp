import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/chat_room_entity.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage(MessageEntity message);
  Stream<List<MessageEntity>> getMessages(String currentUserId, String otherUserId);
  Stream<List<ChatRoomEntity>> getChatRooms(String currentUserId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> sendMessage(MessageEntity message) async {
    // Unique room ID between 2 users
    String chatRoomId = _getChatRoomId(message.senderId, message.receiverId);

    // Add message to sub collection
    final messageModel = MessageModel(
      senderId: message.senderId,
      receiverId: message.receiverId,
      content: message.content,
      timestamp: message.timestamp,
      isRead: false,
    );

    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageModel.toMap());
    
    await firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participants': [message.senderId, message.receiverId], // Important to queries
      'lastMessage': message.content,
      'lastMessageTime': Timestamp.fromDate(message.timestamp),
      'lastSenderId': message.senderId,
      // TODO: Add unread counter here
    }, SetOptions(merge: true));
  }

  @override
  Stream<List<MessageEntity>> getMessages(String currentUserId, String otherUserId) {
    String chatRoomId = _getChatRoomId(currentUserId, otherUserId);

    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromSnapshot(doc)).toList();
    });
  }

  // List of rooms where am I am
  @override
  Stream<List<ChatRoomEntity>> getChatRooms(String currentUserId) {
    return firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatRoomModel.fromSnapshot(doc)).toList();
    });
  }

  // Helper => userA + userB its equal to userB + userA
  String _getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // Order
    return ids.join("_");
  }
}