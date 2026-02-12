import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/theme/tenant.dart';
import '../../../../injection_container.dart';
import '../view_models/login_view_model.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/my_main_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the ViewModel using GetIt (sl)
    return ChangeNotifierProvider(
      create: (_) => sl<LoginViewModel>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {

  @override
  Widget build(BuildContext context) {
    // Access the ViewModel and Theme
    final viewModel = context.watch<LoginViewModel>();
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
          
                  const SizedBox(height: 100),
          
                  // ==============================
                  // HEADLINES
                  // ==============================
                  Text(
                    "Entrar",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
          
                  const SizedBox(height: 8),
          
                  Text(
                    "Faz login para continuar",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.bodyMedium,
                  ),
          
                  const SizedBox(height: 48),
          
                  // ==============================
                  // INPUT FIELDS
                  // ==============================
          
                  // Email TextField
                  MyTextField(
                    controller: viewModel.emailController,
                    label: "Email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !viewModel.isLoading,
                  ),
          
                  const SizedBox(height: 16),
          
                  // Password TextField
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

                  // Password Recovery Link
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO: Implement Forgot Password navigation
                        },
                        child: Text(
                          "Recuperar palavra-passe",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
          
                  const SizedBox(height: 24),
          
                  // ==============================
                  // ACTION BUTTONS
                  // ==============================
          
                  // Login Button
                  MyMainButton(
                    text: "Iniciar sessão",
                    isLoading: viewModel.isLoading,
                    onPressed: () async {
                      // Close the keyboard
                      FocusScope.of(context).unfocus();
                      
                      final success = await viewModel.login();
                      
                      // Verify status
                      if (context.mounted) {
                        if (!success && viewModel.errorMessage != null) {
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
                  ),
          
                  const SizedBox(height: 24),
          
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Ainda não tens conta? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          "Criar agora",
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