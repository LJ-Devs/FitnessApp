import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../view_models/home_view_model.dart';
import '../../widgets/home_nav_bar.dart';

// Features
import '../../../dashboard/presentation/pages/dashboard_page.dart';
// import '../../../chat/presentation/pages/chat_page.dart';
// import '../../../profile/presentation/pages/profile_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<HomeViewModel>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    // Content Pages
    final List<Widget> pages = [
      const DashboardPage(),
      const ChatPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // Preserve the dashboard status
      body: IndexedStack(
        index: viewModel.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: HomeNavBar(
        selectedIndex: viewModel.currentIndex,
        onTabChange: (index) => viewModel.setIndex(index),
      ),
    );
  }
}