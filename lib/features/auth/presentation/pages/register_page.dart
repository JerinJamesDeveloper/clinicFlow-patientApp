/// Register Page
///
/// Page for new user registration.
/// Includes form validation and terms acceptance.
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
import '../../../../navigation/route_names.dart';

/// Register page
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _acceptedTerms = false;
  bool _autoValidate = false;
  String? _termsError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onRegister() {
    setState(() {
      _autoValidate = true;
      _termsError = _acceptedTerms
          ? null
          : 'You must accept the terms and conditions';
    });

    if ((_formKey.currentState?.validate() ?? false) && _acceptedTerms) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          acceptedTerms: _acceptedTerms,
        ),
      );
    }
  }

  void _onGoogleSignIn() {
    AppSnackBar.showInfo(context, 'Google Sign In - Available in Standard Kit');
  }

  void _onAppleSignIn() {
    AppSnackBar.showInfo(context, 'Apple Sign In - Available in Standard Kit');
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
          final isLoading =
              state is AuthOperationInProgress &&
              state.operation == AuthOperation.register;

          // Get field errors if any
          Map<String, String> fieldErrors = {};
          if (state is AuthError && state.hasFieldErrors) {
            for (final entry in state.fieldErrors!.entries) {
              fieldErrors[entry.key] = entry.value.first;
            }
          }

          return AuthFormWrapper(
            isLoading: isLoading,
            loadingMessage: 'Creating account...',
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const CreateAccountHeader(),

                  const SizedBox(height: 32),

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

                  // Name Fields Row
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _firstNameController,
                          focusNode: _firstNameFocusNode,
                          label: 'First Name',
                          hint: 'John',
                          errorText: fieldErrors['firstName'],
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: Icons.person_outline_rounded,
                          onSubmitted: (_) => _lastNameFocusNode.requestFocus(),
                          validator: (v) =>
                              Validators.name(v, fieldName: 'First name'),
                          enabled: !isLoading,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          label: 'Last Name',
                          hint: 'Doe',
                          errorText: fieldErrors['lastName'],
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: Icons.person_outline_rounded,
                          onSubmitted: (_) => _emailFocusNode.requestFocus(),
                          validator: (v) =>
                              Validators.name(v, fieldName: 'Last name'),
                          enabled: !isLoading,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  EmailTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    errorText: fieldErrors['email'],
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
                    label: 'Password',
                    hint: 'Create a password',
                    errorText: fieldErrors['password'],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        _confirmPasswordFocusNode.requestFocus(),
                    validator: Validators.password,
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  PasswordTextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    errorText: fieldErrors['confirmPassword'],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onRegister(),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 20),

                  // Terms Checkbox
                  TermsCheckbox(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                        if (_acceptedTerms) _termsError = null;
                      });
                    },
                    errorText: _termsError ?? fieldErrors['acceptedTerms'],
                    onTermsTap: () {
                      // TODO: Open terms of service
                      AppSnackBar.showInfo(context, 'Terms of Service');
                    },
                    onPrivacyTap: () {
                      // TODO: Open privacy policy
                      AppSnackBar.showInfo(context, 'Privacy Policy');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Register Button
                  AppButton(
                    text: 'Create Account',
                    onPressed: isLoading ? null : _onRegister,
                    isLoading: isLoading,
                  ),

                  // Divider
                  const AuthDivider(text: 'or sign up with'),

                  // Social Login Row
                  SocialAuthRow(
                    onGoogleSignIn: _onGoogleSignIn,
                    onAppleSignIn: _onAppleSignIn,
                    showApple: Theme.of(context).platform == TargetPlatform.iOS,
                  ),

                  const SizedBox(height: 24),

                  // Login Link
                  AuthFooter(
                    text: 'Already have an account? ',
                    linkText: 'Sign In',
                    onLinkTap: () => context.pop(),
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
      // Show success and navigate
      AppSnackBar.showSuccess(context, 'Account created successfully!');

      if (state.user.isAdmin) {
        context.go('/admin/home');
      } else {
        // context.go('/home');
        context.goNamed(
          RouteNames.verifyOtp,
          queryParameters: {'email': _emailController.text.trim()},
        );
      }
    }
  }
}
