import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../view_models/dashboard_view_model.dart';
import '../../../../core/widgets/my_action_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/tenant.dart'; 

import '../../../exercises/presentation/pages/muscle_group_grid_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<DashboardViewModel>(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              _buildHeader(context, viewModel),
              
              const SizedBox(height: 24),
              
              // Next workout
              Text(
                "Próximo treino",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface, 
                ),
              ),
              const SizedBox(height: 12),
              _buildNextClassCard(isDark),
              
              const SizedBox(height: 32),
              
              // Quick actions
              Text(
                "Acesso Rápido",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface, 
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MyActionCard(
                      title: "Marcar\naulas",
                      icon: Icons.calendar_month_rounded,
                      color: tenant.mainColor,
                      onTap: () {
                        debugPrint("Clicou em Marcar Aula"); //////// TODO
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MyActionCard(
                      title: "Biblioteca\nExercícios",
                      icon: Icons.fitness_center_rounded,
                      color: Colors.orangeAccent, 
                      onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MuscleGroupGridPage(),
                          ),
                      );
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DashboardViewModel viewModel) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Olá, ${viewModel.greetingName} 👋", 
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colors.onSurface, 
                fontFamily: tenant.fontFamily,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Vamos treinar hoje?", // TODO - change to month streak
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurfaceVariant, 
              ),
            ),
          ],
        ),
        // Avatar
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest, 
            shape: BoxShape.circle,
            border: Border.all(
                // Border
                color: colors.outline.withValues(alpha: 0.2), 
                width: 2
            ),
          ),
          child: ClipOval(
            child: viewModel.avatarUrl != null
            ? CachedNetworkImage(
                imageUrl: viewModel.avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary),
                ),
                errorWidget: (context, url, error) => Icon(Icons.person, color: colors.onSurfaceVariant),
              )
            : Icon(Icons.person, color: colors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildNextClassCard(bool isDark) {    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tenant.mainColor,
            tenant.mainColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        // Shadow only in light mode
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: tenant.mainColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Amanhã, 10:00", // TODO - firebase
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Treino Funcional", // TODO - Fill dynamic card
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          /*const SizedBox(height: 4),
            const Row(
            children: [
              Icon(Icons.location_on, color: Colors.white70, size: 14),
              SizedBox(width: 4),
              Text(
                "Estúdio Principal", // Location if more than 1 room
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ), */
        ],
      ),
    );
  }
}