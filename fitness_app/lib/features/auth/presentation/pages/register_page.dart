import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/tenant.dart';
import '../../../../injection_container.dart';
import '../view_models/register_view_model.dart';
import '../../../../core/widgets/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject with GetIt (sl)
    return ChangeNotifierProvider(
      create: (_) => sl<RegisterViewModel>(),
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();
    final theme = Theme.of(context);
    final String logoAsset = tenant.logoAsset;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  // ==============================
                  // LOGO / BRANDING
                  // ==============================
                  Image.asset(
                    logoAsset,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
          
                  const SizedBox(height: 60),
          
                  // ==============================
                  // HEADLINES
                  // ==============================
                  Text(
                    "Criar conta",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
          
                  const SizedBox(height: 8),
          
                  Text(
                    "Regista-te agora",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.bodyMedium,
                  ),
          
                  const SizedBox(height: 48),
          
                  // ==============================
                  // INPUT FIELDS
                  // ==============================
          
                  MyTextField(
                    controller: viewModel.nameController,
                    label: "Nome",
                    prefixIcon: Icons.person_outline,
                    enabled: !viewModel.isLoading,
                  ),

                  const SizedBox(height: 16),

                  MyTextField(
                    controller: viewModel.emailController,
                    label: "Email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !viewModel.isLoading,
                  ),
          
                  const SizedBox(height: 16),
          
                  MyTextField(
                    controller: viewModel.passwordController,
                    label: "Palavra-passe",
                    prefixIcon: Icons.lock_outline,
                    obscureText: viewModel.obscurePassword,
                    textInputAction: TextInputAction.done,
                    enabled: !viewModel.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        viewModel.obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: viewModel.togglePasswordVisibility,
                    ),
                  ),

                  const SizedBox(height: 32),
          
                  // ==============================
                  // ACTION BUTTONS
                  // ==============================
          
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              final success = await viewModel.register();
                              
                              if (context.mounted) {
                                if (success) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                } else if (viewModel.errorMessage != null) {
                                  // If failed show error message
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
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text("Criar conta"),
                    ),
                  ),
          
                  const SizedBox(height: 24),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Já tens conta? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}