import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for resending OTP
class ResendOtpUseCase implements UseCase<Unit, String> {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await _repository.resendOtp(email: email);
  }
}
