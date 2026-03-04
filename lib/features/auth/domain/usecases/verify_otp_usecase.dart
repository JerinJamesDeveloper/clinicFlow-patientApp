import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Parameters for OTP verification
class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});
}

/// Use case for verifying OTP \u2014 returns the authenticated session on success
class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Either<Failure, AuthSessionEntity>> call(
    VerifyOtpParams params,
  ) async {
    return await _repository.verifyOtp(email: params.email, otp: params.otp);
  }
}
