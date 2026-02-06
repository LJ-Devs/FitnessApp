import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/edit_profile_view_model.dart';
import '../../../domain/auth/auth_provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel injection with Provider
    return ChangeNotifierProvider(
      create: (_) => EditProfileViewModel(),
      child: const _EditProfileForm(),
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Close keyboard
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dados Pessoais"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 32),

              // Email field disabled, but visible
              TextField(
                controller: viewModel.emailController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),

              // Name field editable
              TextField(
                controller: viewModel.nameController,
                decoration: const InputDecoration(
                  labelText: "Nome Completo",
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 48),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          
                          // Call logic to save
                          final authProvider = context.read<AuthProvider>();
                          final success = await viewModel.saveChanges(authProvider);

                          // Verify if widget is still mounted
                          if (context.mounted) {
                            if (success) {
                              Navigator.pop(context); // Back to previous screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Dados atualizados com sucesso!")),
                              );
                            } else if (viewModel.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.errorMessage!),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          height: 24, width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text("Guardar Alterações"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}