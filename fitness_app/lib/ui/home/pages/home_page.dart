import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import '../widgets/home_nav_bar.dart';
import '../../dashboard/pages/dashboard_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    final List<Widget> pages = [
      const DashboardPage(), 
      
      const Scaffold(body: Center(child: Text("Chat - Em Desenvolvimento"))), //Placeholder para substituir depois
      
      const Scaffold(body: Center(child: Text("Perfil - Em Construção"))), //Placeholder para substituir depois
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