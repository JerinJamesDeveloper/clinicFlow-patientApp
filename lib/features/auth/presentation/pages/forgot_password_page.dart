/// Forgot Password Page
/// 
/// Page for initiating password reset.
/// Sends reset link to user's email.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/auth_header.dart';

/// Forgot password page
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  
  bool _autoValidate = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() => _autoValidate = true);
    
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthForgotPasswordRequested(
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  void _onResend() {
    context.read<AuthBloc>().add(
      AuthForgotPasswordRequested(
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleAuthState,
        builder: (context, state) {
          final isLoading = state is AuthOperationInProgress &&
              state.operation == AuthOperation.forgotPassword;

          if (_emailSent || state is AuthPasswordResetSent) {
            return _buildSuccessView(context, state);
          }

          return _buildFormView(context, state, isLoading);
        },
      ),
    );
  }

  Widget _buildFormView(BuildContext context, AuthState state, bool isLoading) {
    String? emailError;
    if (state is AuthError && state.hasFieldErrors) {
      emailError = state.getFieldError('email');
    }

    return AuthFormWrapper(
      isLoading: isLoading,
      loadingMessage: 'Sending reset link...',
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate 
            ? AutovalidateMode.onUserInteraction 
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            
            // Header
            const ForgotPasswordHeader(),
            
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
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSubmit(),
              validator: Validators.email,
              enabled: !isLoading,
            ),
            
            const SizedBox(height: 24),
            
            // Submit Button
            AppButton(
              text: 'Send Reset Link',
              onPressed: isLoading ? null : _onSubmit,
              isLoading: isLoading,
            ),
            
            const SizedBox(height: 16),
            
            // Back to Login
            Center(
              child: TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back to Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, AuthState state) {
    final email = state is AuthPasswordResetSent 
        ? state.email 
        : _emailController.text;

    return AuthFormWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 40,
              color: AppColors.success,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Check Your Email',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            'We have sent a password reset link to',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Email
          Text(
            email,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Open Email App Button
          AppButton(
            text: 'Open Email App',
            onPressed: () {
              // TODO: Open email app
              AppSnackBar.showInfo(context, 'Opening email app...');
            },
          ),
          
          const SizedBox(height: 16),
          
          // Resend Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the email? ",
                style: TextStyle(color: AppColors.grey600),
              ),
              TextButton(
                onPressed: _onResend,
                child: const Text('Resend'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Back to Login
          TextButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthPasswordResetSent) {
      setState(() => _emailSent = true);
    } else if (state is AuthError) {
      // Keep on form view to show error
      setState(() => _emailSent = false);
    }
  }
}