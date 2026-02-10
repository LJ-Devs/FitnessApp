import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../injection_container.dart';
import '../../../../core/theme/tenant.dart';
import '../widgets/chat_tile.dart';
import '../view_models/chat_list_view_model.dart';
import '../../../../core/widgets/my_text_field.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? ''; 

    return ChangeNotifierProvider(
      create: (_) => sl<ChatListViewModel>()..loadChatRooms(currentUserId),
      child: Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                child: Consumer<ChatListViewModel>(builder: (context, viewModel, _) {
                  return MyTextField(
                    controller: viewModel.searchController, label: "Procurar conversa...",
                    prefixIcon: Icons.search,
                  );
                },
              )
            ),

            const SizedBox(height: 24),

            // List
            Expanded(
                child: Consumer<ChatListViewModel>(
                  builder: (context, viewModel, child) {
                    // Loading State
                    if (viewModel.isLoading && viewModel.rooms.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Empty State
                    if (viewModel.rooms.isEmpty) {
                      return Center(
                        child: Text(
                          "Ainda não tens mensagens",
                          style: TextStyle(color: colors.onSurface.withValues(alpha: 0.5)),
                        ),
                      );
                    }
                    // Data State
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: viewModel.rooms.length,
                      itemBuilder: (context, index) {
                        final room = viewModel.rooms[index];
                        final otherUserId = room.getOtherUserId(currentUserId);
                        final userProfile = viewModel.getProfile(otherUserId);
                        final displayName = userProfile?.name ?? "A carregar...";
                        // userProfile?.photoUrl here to display avatar
                        
                        // Simple time formatting
                        final time = "${room.lastMessageTime.hour}:${room.lastMessageTime.minute.toString().padLeft(2, '0')}";

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailPage(
                                  name: displayName, 
                                  icon: Icons.person,
                                  avatarColor: tenant.mainColor,
                                  receiverId: otherUserId,
                                  currentUserId: currentUserId,
                                ),
                              ),
                            );
                          },
                          child: ChatTile(
                            name: displayName,
                            message: room.lastMessage,
                            time: time,
                            isUnread: false, // TODO: Implement unread logic
                            avatarColor: tenant.mainColor,
                            icon: Icons.person,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}