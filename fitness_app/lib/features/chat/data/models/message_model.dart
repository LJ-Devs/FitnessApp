import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.id,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.timestamp,
    super.isRead,
  });

  // Map to Model
  factory MessageModel.fromSnapshot(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(), 
      isRead: map['isRead'] ?? false,
    );
  }

  // Model to JSON
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}