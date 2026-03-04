/// OTP Verification Page
///
/// Page for verifying the one-time password sent to the user.
/// Includes a 4-digit numeric input and a resend timer.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_wrapper.dart';
import '../widgets/auth_header.dart';

/// OTP Verification page
class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
      } else {
        setState(() => _resendTimer--);
      }
    });
  }

  void _onVerify() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 4-digit code')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthVerifyOtpRequested(email: widget.email, otp: otp),
    );
  }

  void _onResend() {
    if (_resendTimer > 0) return;

    context.read<AuthBloc>().add(AuthResendOtpRequested(email: widget.email));
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      // Token + user were saved by the repository from the API response.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification successful!')));

      // Navigate based on role
      if (state.user.isAdmin) {
        context.go('/admin/home');
      } else {
        context.go('/home');
      }
    } else if (state is AuthResendOtpSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP code resent!')));
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        // Fire when transitioning from an OTP operation to any result state,
        // including AuthAuthenticated (the happy path after verifyOtp).
        final wasOtpOperation =
            previous is AuthOperationInProgress &&
            (previous.operation == AuthOperation.verifyOtp ||
                previous.operation == AuthOperation.resendOtp);
        return wasOtpOperation ||
            current is AuthOtpVerificationSuccess ||
            current is AuthResendOtpSuccess;
        // Note: AuthAuthenticated is covered by wasOtpOperation above —
        // if previous was verifyOtp in-progress and current is AuthAuthenticated,
        // wasOtpOperation is true and the listener fires correctly.
      },
      listener: _handleAuthState,
      builder: (context, state) {
        final isVerifying =
            state is AuthOperationInProgress &&
            state.operation == AuthOperation.verifyOtp;

        final isResending =
            state is AuthOperationInProgress &&
            state.operation == AuthOperation.resendOtp;

        return AuthScaffold(
          showBackButton: true,
          body: AuthFormWrapper(
            isLoading: isVerifying || isResending,
            loadingMessage: isVerifying
                ? 'Verifying code...'
                : 'Resending code...',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: 'Verify OTP',
                  subtitle: 'We have sent a verification code to your email',
                  logo: Icon(
                    Icons.mark_email_read_rounded,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error Banner
                if (state is AuthError) ...[
                  InlineErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<AuthBloc>().add(const AuthErrorCleared()),
                  ),
                  const SizedBox(height: 16),
                ],

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) =>
                        _buildOtpField(index, isVerifying || isResending),
                  ),
                ),

                const SizedBox(height: 48),

                // Verify Button
                AppButton(
                  text: 'Verify',
                  onPressed: isVerifying || isResending ? null : _onVerify,
                  isLoading: isVerifying,
                ),

                const SizedBox(height: 24),

                // Resend Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: TextStyle(color: AppColors.grey600),
                    ),
                    TextButton(
                      onPressed: _resendTimer == 0 && !isResending
                          ? _onResend
                          : null,
                      child: Text(
                        _resendTimer > 0
                            ? 'Resend in ${_resendTimer}s'
                            : 'Resend Code',
                        style: TextStyle(
                          color: _resendTimer == 0 && !isResending
                              ? AppColors.primary
                              : AppColors.grey400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpField(int index, bool disabled) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: !disabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: AppTextStyles.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.grey300),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.grey200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (_controllers.every((c) => c.text.isNotEmpty)) {
            _onVerify();
          }
        },
      ),
    );
  }
}
