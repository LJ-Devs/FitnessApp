import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/my_search_bar.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/my_app_bar.dart'; 
import '../../../../core/widgets/my_fab.dart';
import '../../domain/entities/exercise_enums.dart';
import '../widgets/photo_category_card.dart'; 
import '../view_models/exercise_view_model.dart';
import 'exercise_list_page.dart';
import 'exercise_form_page.dart';

class MuscleGroupGridPage extends StatelessWidget {
  const MuscleGroupGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ExerciseViewModel injection
    return ChangeNotifierProvider(
      create: (_) => sl<ExerciseViewModel>(),
      child: const _MuscleGroupListView(),
    );
  }
}

class _MuscleGroupListView extends StatefulWidget {
  const _MuscleGroupListView();

  @override
  State<_MuscleGroupListView> createState() => _MuscleGroupListViewState();
}

class _MuscleGroupListViewState extends State<_MuscleGroupListView> {
  // Controller to handle search input text TODO
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch all available muscle groups from the Enum.
    final groups = MuscleGroup.values;

    return Scaffold(
      appBar: const MyAppBar(
        title: Text("Exercícios"), 
        showBackButton: true,
      ),
      
      // Button to navigate to the Create Exercise form
      floatingActionButton: MyFAB(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => const ExerciseFormPage()),
          );
        },
      ),
      
      body: SafeArea(
        // Using CustomScrollView with Slivers for better performance
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: MySearchBar(
                controller: _searchController,
                hintText: "Procurar exercício...",
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
              ),
            ),
        
            // Category list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final group = groups[index];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: PhotoCategoryCard(
                        title: group.displayName,
                        // Accessing the image path
                        imagePath: group.imagePath, 
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseListPage(muscleGroup: group),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: groups.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}