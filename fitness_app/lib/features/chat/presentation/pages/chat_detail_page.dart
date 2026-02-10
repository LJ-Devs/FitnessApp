import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/my_app_bar.dart';
import '../view_models/chat_view_model.dart';
import '../widgets/message_bubble.dart';

class ChatDetailPage extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color avatarColor;
  final String receiverId;
  final String currentUserId;

  const ChatDetailPage({
    super.key,
    required this.name,
    required this.icon,
    required this.avatarColor,
    required this.receiverId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    // ViewModel injection and chat initialization
    return ChangeNotifierProvider(
      create: (_) => sl<ChatViewModel>()..initChat(currentUserId, receiverId),
      child: Scaffold(
        appBar: MyAppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor.withValues(alpha: 0.2),
                child: Icon(icon, color: avatarColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Consumer listen ViewModel changes
        body: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                // List of messages
                Expanded(
                  child: viewModel.isLoading && viewModel.messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.messages.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              controller: viewModel.scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              itemCount: viewModel.messages.length,
                              itemBuilder: (context, index) {
                                final msg = viewModel.messages[index];
                                final isMe = msg.senderId == currentUserId;

                                final time = "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}";

                                return MessageBubble(
                                  text: msg.content,
                                  time: time,
                                  isMe: isMe,
                                );
                              },
                            ),
                ),
                _buildInputBar(context, viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "Diz olá!",
        style: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, ChatViewModel viewModel) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.messageController,
              onSubmitted: (_) => viewModel.sendMessage(currentUserId, receiverId),
              decoration: InputDecoration(
                hintText: "Escreve aqui...",
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () {
                viewModel.sendMessage(currentUserId, receiverId);
              },
            ),
          ),
        ],
      ),
    );
  }
}