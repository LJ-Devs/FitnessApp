import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/my_app_bar.dart'; 
import '../../../../core/widgets/my_fab.dart';
import '../widgets/exercise_list_card.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/exercise_enums.dart';
import '../view_models/exercise_view_model.dart';
import 'exercise_form_page.dart';

class ExerciseListPage extends StatelessWidget {
  final MuscleGroup muscleGroup;

  const ExerciseListPage({super.key, required this.muscleGroup});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ExerciseViewModel>(),
      child: _ExerciseListView(muscleGroup: muscleGroup),
    );
  }
}

class _ExerciseListView extends StatefulWidget {
  final MuscleGroup muscleGroup;
  const _ExerciseListView({required this.muscleGroup});

  @override
  State<_ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<_ExerciseListView> {
  
  @override
  void initState() {
    super.initState();
    // Ensures data loading happens after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    context.read<ExerciseViewModel>().loadExercisesByMuscle(widget.muscleGroup);
  }

  Future<void> _navigateToForm([ExerciseEntity? exercise]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseFormPage(
          initialGroup: widget.muscleGroup,
          exerciseToEdit: exercise,
        ),
      ),
    );
    if (mounted) _loadData();
  }

  void _deleteExercise(String id, String name) {
    context.read<ExerciseViewModel>().removeExercise(id);
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars(); // Prevents stacking
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name removido"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExerciseViewModel>();
    final theme = Theme.of(context);

    // Decide the content to display before drawing the structure
    Widget contentSliver;

    if (viewModel.isLoading) {
      contentSliver = SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
      );
    } else if (viewModel.errorMessage != null) {
      contentSliver = _buildErrorView(theme, viewModel.errorMessage!);
    } else if (viewModel.exercises.isEmpty) {
      contentSliver = _buildEmptyView(theme);
    } else {
      contentSliver = _buildListView(viewModel.exercises);
    }

    return Scaffold(
      appBar: MyAppBar(
        title: Text(widget.muscleGroup.displayName),
        showBackButton: true,
      ),
      floatingActionButton: MyFAB(
        onPressed: () => _navigateToForm(),
      ),
      body: SafeArea(
        top: false, 
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            contentSliver, // The content decided above is injected here
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  // Helpers
  Widget _buildListView(List<ExerciseEntity> exercises) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final exercise = exercises[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ExerciseListCard(
                exercise: exercise,
                onTap: () => _navigateToForm(exercise),
                onDelete: () => _deleteExercise(exercise.id, exercise.name),
              ),
            );
          },
          childCount: exercises.length,
        ),
      ),
    );
  }

  Widget _buildErrorView(ThemeData theme, String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadData,
              child: const Text("Tentar Novamente"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(ThemeData theme) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: theme.disabledColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "Sem exercícios ainda",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}