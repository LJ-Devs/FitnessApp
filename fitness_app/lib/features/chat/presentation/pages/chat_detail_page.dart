import 'package:flutter/material.dart';
import '../../../../core/widgets/my_app_bar.dart';
import '../widgets/message_bubble.dart';

class ChatDetailPage extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color avatarColor;

  const ChatDetailPage({
    super.key,
    required this.name,
    required this.icon,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Reutilize MyAppBar to consistently style
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const MessageBubble(text: "Olá!", time: "10:30", isMe: false),
                const MessageBubble(text: "Tudo bem?", time: "10:31", isMe: true),
              ],
            ),
          ),
          _buildInputBar(context), // TODO Extract input bar for cleaner code (Think about make it separated widget and use it in LoginPage/RegisterPage too)
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}