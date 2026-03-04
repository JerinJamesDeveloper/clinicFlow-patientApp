/// Login Page
/// 
/// Page for user authentication with email and password.
/// Includes social login options and navigation to register/forgot password.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_auth_section.dart';

/// Login page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _rememberMe = false;
  bool _autoValidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLogin() {
    setState(() => _autoValidate = true);
    
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }

  void _onGoogleSignIn() {
    // TODO: Implement Google Sign In (Standard Kit)
    AppSnackBar.showInfo(context, 'Google Sign In - Available in Standard Kit');
  }

  void _onAppleSignIn() {
    // TODO: Implement Apple Sign In (Standard Kit)
    AppSnackBar.showInfo(context, 'Apple Sign In - Available in Standard Kit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleAuthState,
        builder: (context, state) {
          final isLoading = state is AuthOperationInProgress &&
              state.operation == AuthOperation.login;
          
          // Get field errors if any
          String? emailError;
          String? passwordError;
          
          if (state is AuthError && state.hasFieldErrors) {
            emailError = state.getFieldError('email');
            passwordError = state.getFieldError('password');
          }

          return AuthFormWrapper(
            isLoading: isLoading,
            loadingMessage: 'Signing in...',
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate 
                  ? AutovalidateMode.onUserInteraction 
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  
                  // Header
                  const WelcomeHeader(),
                  
                  const SizedBox(height: 40),
                  
                  // Error Banner
                  if (state is AuthError && !state.hasFieldErrors) ...[
                    InlineErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<AuthBloc>().add(
                        const AuthErrorCleared(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Email Field
                  EmailTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    errorText: emailError,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    validator: Validators.email,
                    enabled: !isLoading,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password Field
                  PasswordTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    errorText: passwordError,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onLogin(),
                    validator: Validators.password,
                    enabled: !isLoading,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Remember Me & Forgot Password
                  RememberMeCheckbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                    onForgotPassword: () => context.push('/forgot-password'),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login Button
                  AppButton(
                    text: 'Sign In',
                    // please change to activate login 
                    onPressed: isLoading ? null :  _onLogin, //() => context.go('/home'),
                    isLoading: isLoading,
                  ),
                  
                  // Divider
                  const AuthDivider(text: 'or continue with'),
                  
                  // Social Login
                  SocialAuthSection(
                    onGoogleSignIn: _onGoogleSignIn,
                    onAppleSignIn: _onAppleSignIn,
                    showApple: Theme.of(context).platform == TargetPlatform.iOS,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Register Link
                  AuthFooter(
                    text: "Don't have an account? ",
                    linkText: 'Sign Up',
                    onLinkTap: () => context.push('/register'),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // Navigate based on role
      if (state.user.isAdmin) {
        context.go('/admin/home');
      } else {
        context.go('/home');
      }
    }
  }
}