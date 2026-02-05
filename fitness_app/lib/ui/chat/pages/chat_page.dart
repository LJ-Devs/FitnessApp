import 'package:flutter/material.dart';
import '../../core/themes/tenant.dart';
import '../widgets/chat_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heade
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                "Mensagens",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                  fontFamily: tenant.fontFamily,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Search Bar TODO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: isDark 
                      ? colors.surfaceContainerHighest.withValues(alpha: 0.5) // Dark mode
                      : Colors.grey.withValues(alpha: 0.1), // Light mode
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: colors.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Text(
                      "Procurar conversa...",
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Unread message
                  ChatTile(
                    name: "Ricardo Silva (PT)",
                    message: "Não te esqueças de trazer a toalha!",
                    time: "10:30",
                    isUnread: true,
                    avatarColor: tenant.mainColor,
                    icon: Icons.person,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Example 2
                  ChatTile(
                    name: "Dra. Ana Nutrição",
                    message: "O plano alimentar já está disponível.",
                    time: "Ontem",
                    isUnread: false,
                    avatarColor: Colors.greenAccent.shade700,
                    icon: Icons.apple_rounded,
                  ),

                  const SizedBox(height: 12),

                  // Example 3
                  ChatTile(
                    name: "Estúdio Central",
                    message: "A tua mensalidade foi renovada.",
                    time: "Seg",
                    isUnread: false,
                    avatarColor: Colors.orangeAccent,
                    icon: Icons.business_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}