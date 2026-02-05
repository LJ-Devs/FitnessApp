import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';
import '../../core/themes/tenant.dart';
import '../view_models/login_view_model.dart';
import '../../../domain/auth/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the ViewModel
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
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
                  TextField(
                    controller: viewModel.emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
          
                  const SizedBox(height: 16),
          
                  // Password TextField
                  TextField(
                    controller: viewModel.passwordController,
                    decoration: InputDecoration(
                      labelText: "Palavra-passe",
                      prefixIcon: const Icon(Icons.lock_outline),
                      // Toggle Password Visibility Icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: viewModel.togglePasswordVisibility,
                      ),
                    ),
                    obscureText: viewModel.obscurePassword,
                  ),
          
                  const SizedBox(height: 16),
          
                  // "Remember Me" & "Forgot Password"
                  Row(
                    children: [
                      const Text("Lembrar-me"),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: viewModel.rememberMe,
                          onChanged: (value) => viewModel.toggleRememberMe(value)
                        ),
                      ),
                      const Spacer(),
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
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          // 1. Fechar o teclado
                          FocusScope.of(context).unfocus();
                          
                          // 2. Chamar a lógica de Login
                          final authProvider = context.read<AuthProvider>();
                          final success = await viewModel.login(authProvider);
                          
                          // 3. VERIFICAR O RESULTADO
                          if (context.mounted) {
                            if (success) {
                              // === ESTA É A PARTE QUE FALTA ===
                              // Se o login foi um sucesso, navega para a Home
                              Navigator.pushReplacementNamed(context, AppRoutes.home);
                            } else if (viewModel.errorMessage != null) {
                              // Se falhou, mostra o erro
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
                          : const Text("Iniciar sessão"),
                    ),
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