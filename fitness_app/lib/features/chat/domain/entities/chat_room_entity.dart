import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final String id;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<String> participants;
  final int unreadCount;

  const ChatRoomEntity({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.participants,
    this.unreadCount = 0,
  });

  // Helper to get the 'other' user
  String getOtherUserId(String myUserId) {
    return participants.firstWhere(
      (id) => id != myUserId,
      orElse: () => "Unknown",
    );
  }

  @override
  List<Object?> get props => [id, lastMessage, lastMessageTime, participants, unreadCount];
}