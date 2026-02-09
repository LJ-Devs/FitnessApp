import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../injection_container.dart';
import '../view_models/edit_profile_view_model.dart';
import '../widgets/profile_avatar_selector.dart';
import '../../../../core/widgets/my_app_bar.dart'; 
import '../../../../core/widgets/my_text_field.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel injection using Service Locator
    return ChangeNotifierProvider(
      create: (_) => sl<EditProfileViewModel>(),
      child: const _EditProfileForm(),
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();
    final currentUser = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Close keyboard
      child: Scaffold(
        appBar: const MyAppBar(
          title: Text("Dados pessoais"), 
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar
              ProfileAvatarSelector(
                selectedImage: viewModel.selectedImage,
                photoUrl: currentUser?.photoURL,
                onTap: viewModel.pickImage,
                isLoading: viewModel.isLoading,
              ),
              
              const SizedBox(height: 32),

              // Email field disabled, but visible
              MyTextField(
                controller: viewModel.emailController,
                label: "Email",
                prefixIcon: Icons.email_outlined,
                enabled: false, // Non-editable, just for display
              ),

              const SizedBox(height: 24),

              // Name field editable
              MyTextField(
                controller: viewModel.nameController,
                label: "Nome",
                prefixIcon: Icons.person_outline,
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
                          final success = await viewModel.saveChanges();

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