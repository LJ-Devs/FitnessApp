import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatViewModel extends ChangeNotifier {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;

  // UseCase injection into the constructor
  ChatViewModel({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
  });

  // --- UI State ---
  List<MessageEntity> _messages = [];
  List<MessageEntity> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- Controllers ---
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // --- Stream Management ---
  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  bool _isDisposed = false;

  // Initializes the chat listener
  void initChat(String currentUserId, String receiverId) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Cancel previous subscription if it exists to avoid memory leaks
    _messagesSubscription?.cancel();

    // Listen to the UseCase Stream
    _messagesSubscription = getMessagesUseCase(currentUserId, receiverId).listen(
      (newMessages) {
        if (_isDisposed) return;

        _messages = newMessages;
        _isLoading = false;
        notifyListeners();

        // Scroll to the bottom when new messages arrive
        _scrollToBottom();
      },
      onError: (error) {
        _errorMessage = "Error loading messages: $error";
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Logic to send a message
  Future<void> sendMessage(String currentUserId, String receiverId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Clear the input field immediately for better UX
    messageController.clear();

    final message = MessageEntity(
      senderId: currentUserId,
      receiverId: receiverId,
      content: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Call the Domain Layer
    final result = await sendMessageUseCase(message);

    if (_isDisposed) return;

    result.fold(
      (failure) {
        // Handle failure: Restore text and show error
        _errorMessage = failure.message;
        messageController.text = text;
        notifyListeners();
      },
      (success) {
        // Handle success: The Stream will automatically update the list
        _errorMessage = null;
        _scrollToBottom();
      },
    );
  }

  // Helper method to scroll to the bottom of the list
  void _scrollToBottom() {
    if (!scrollController.hasClients || _isDisposed) return;
      // Small delay to ensure the list has rendered the new item
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isDisposed || !scrollController.hasClients) return;
      
      try {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch(e) {
        debugPrint("Erro ao fazer scroll: $e");
      }
      });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _messagesSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}