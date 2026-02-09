import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? id; // Null before go to Firebase
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  const MessageEntity({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, senderId, receiverId, content, timestamp, isRead];
}