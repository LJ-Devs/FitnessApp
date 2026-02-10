import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/theme/tenant.dart';
import '../../../../injection_container.dart';
import '../widgets/profile_option.dart';
import '../view_models/profile_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the ViewModel using the Service Locator
    return ChangeNotifierProvider(
      create: (_) => sl<ProfileViewModel>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Access the ViewModel to get the state and actions
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Loading state
              if (viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
              // Content state
                Center(
                  child: Column(
                    children: [
                      // Header name and photo
                      // Avatar with tenant color
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: tenant.mainColor.withValues(alpha: 0.5),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: colors.surfaceContainerHighest,
                          // Dynamic avatar -> avatarURL or default icon
                          backgroundImage: viewModel.avatarUrl != null 
                              ? CachedNetworkImageProvider(viewModel.avatarUrl!)
                              : null,
                          child: viewModel.avatarUrl == null
                              ? Icon(Icons.person, size: 50, color: colors.onSurfaceVariant)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.userName, // User name
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: tenant.fontFamily,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        viewModel.joinDate, // Register date
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Menu options
              // Group: account
              _buildSectionTitle("Conta", colors),
              const SizedBox(height: 12),

              ProfileOption(
                title: "Dados Pessoais",
                icon: Icons.person,
                onTap: () async {
                  // Change to EditProfilePage and wait for result
                  await Navigator.pushNamed(context, AppRoutes.editProfile);
                    // After return, reload profile
                  if (context.mounted) {
                    context.read<ProfileViewModel>().loadUserProfile();
                  }
                },
              ),
              const SizedBox(height: 12),
              ProfileOption(
                title: "Histórico de Pagamentos",
                icon: Icons.receipt_long_rounded,
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Group: APP
              _buildSectionTitle("Aplicação", colors),
              const SizedBox(height: 12),

              ProfileOption(
                title: "Notificações",
                icon: Icons.notifications_none_rounded,
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // Group: Exit
              ProfileOption(
                title: "Terminar Sessão",
                icon: Icons.logout_rounded,
                isDestructive: true,
                onTap: () {
                  viewModel.logout();
                },
              ),

              const SizedBox(height: 20),

              // App version
              Consumer<ProfileViewModel>(
              builder: (context, viewModel, _) {
                return Text(
                  "Versão ${viewModel.appVersion}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                );
              },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper
  Widget _buildSectionTitle(String title, ColorScheme colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colors.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}