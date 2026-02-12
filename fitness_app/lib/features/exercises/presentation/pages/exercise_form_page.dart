import 'package:fitness_app/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/my_app_bar.dart'; 
import '../../../../core/widgets/my_main_button.dart';
import '../../../../core/widgets/my_text_field.dart'; 
import '../../../../core/widgets/my_dropdown.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/exercise_enums.dart';
import '../view_models/exercise_view_model.dart';

class ExerciseFormPage extends StatelessWidget {
  final ExerciseEntity? exerciseToEdit; // Null = Create New
  final MuscleGroup? initialGroup;

  const ExerciseFormPage({
    super.key,
    this.exerciseToEdit,
    this.initialGroup,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ExerciseViewModel>(),
      child: _ExerciseFormBody(
        exerciseToEdit: exerciseToEdit,
        initialGroup: initialGroup,
      ),
    );
  }
}

class _ExerciseFormBody extends StatefulWidget {
  final ExerciseEntity? exerciseToEdit;
  final MuscleGroup? initialGroup;

  const _ExerciseFormBody({
    this.exerciseToEdit,
    this.initialGroup,
  });

  @override
  State<_ExerciseFormBody> createState() => _ExerciseFormBodyState();
}

class _ExerciseFormBodyState extends State<_ExerciseFormBody> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _videoUrlController;

  // State Variables
  late MuscleGroup _selectedMuscleGroup;
  late Equipment _selectedEquipment;

  @override
  void initState() {
    super.initState();
    final e = widget.exerciseToEdit;

    // Initialize controllers
    _nameController = TextEditingController(text: e?.name ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _videoUrlController = TextEditingController(text: e?.videoUrl ?? '');

    // Initialize Dropdowns
    _selectedMuscleGroup = e?.muscleGroup ?? widget.initialGroup ?? MuscleGroup.chest;
    _selectedEquipment = e?.equipment ?? Equipment.barbell;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(ExerciseViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) return;

    // Create Entity
    final exercise = ExerciseEntity(
      id: widget.exerciseToEdit?.id ?? '', 
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      muscleGroup: _selectedMuscleGroup,
      equipment: _selectedEquipment,
      videoUrl: _videoUrlController.text.trim(),
      coverUrl: widget.exerciseToEdit?.coverUrl, 
    );

    final bool success;
    if (widget.exerciseToEdit != null) {
      success = await viewModel.editExercise(exercise);
    } else {
      success = await viewModel.addExercise(exercise);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.exerciseToEdit != null 
              ? 'Exercício atualizado' 
              : 'Exercise criado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExerciseViewModel>();
    final isEditing = widget.exerciseToEdit != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(isEditing ? 'Editar exercício' : 'Novo exercício'),
          showBackButton: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // === NAME ===
                  MyTextField(
                    controller: _nameController,
                    label: 'Nome',
                    prefixIcon: Icons.fitness_center,
                    textInputAction: TextInputAction.next,
                    validator: (val) => val == null || val.isEmpty 
                      ? 'Por favor insere um nome' 
                      : null,
                  ),
                  const SizedBox(height: 20),

                  // === MUSCLE GROUP ===
                  MyDropdown<MuscleGroup>(
                    value: _selectedMuscleGroup,
                    label: 'Grupo muscular',
                    prefixIcon: Icons.accessibility_new,
                    items: MuscleGroup.values.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(group.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMuscleGroup = val);
                    },
                  ),
                  const SizedBox(height: 20),

                  MyDropdown<Equipment>(
                    value: _selectedEquipment,
                    label: 'Equipamento',
                    prefixIcon: Icons.fitness_center_outlined,
                    items: Equipment.values.map((equip) {
                      return DropdownMenuItem(
                        value: equip,
                        child: Text(equip.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedEquipment = val);
                    },
                  ),
                  const SizedBox(height: 20),

                  // === DESCRIPTION ===
                  MyTextField(
                    controller: _descController,
                    label: 'Instruções ou descrição',
                    prefixIcon: Icons.description,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    validator: (val) => val == null || val.isEmpty 
                      ? 'Por favor insere uma descrição' 
                      : null,
                  ),
                  const SizedBox(height: 20),

                  // === VIDEO URL ===
                  MyTextField(
                    controller: _videoUrlController,
                    label: 'Link do vídeo (Opcional)',
                    prefixIcon: Icons.video_library,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    validator: Validators.validateUrl,
                  ),

                  const SizedBox(height: 40),

                  // === SAVE BUTTON ===
                  MyMainButton(
                    text: "Guardar",
                    isLoading: viewModel.isLoading,
                    onPressed: () => _submitForm(viewModel),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}