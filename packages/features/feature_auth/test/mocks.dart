import 'package:feature_auth/data/datasources/auth_local_datasource.dart';
import 'package:feature_auth/data/datasources/auth_remote_datasource.dart';
import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:feature_auth/domain/usecases/change_password.dart';
import 'package:feature_auth/domain/usecases/forgot_password.dart';
import 'package:feature_auth/domain/usecases/get_current_user.dart';
import 'package:feature_auth/domain/usecases/get_profile.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:feature_auth/domain/usecases/resend_verification_email.dart';
import 'package:feature_auth/domain/usecases/reset_password.dart';
import 'package:feature_auth/domain/usecases/send_verification_email.dart';
import 'package:feature_auth/domain/usecases/sign_in_with_google.dart';
import 'package:feature_auth/domain/usecases/sign_out.dart';
import 'package:feature_auth/domain/usecases/signup.dart';
import 'package:feature_auth/domain/usecases/save_user.dart';
import 'package:feature_auth/domain/usecases/update_profile.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:dolfin_core/analytics/analytics_service.dart';
import 'package:mocktail/mocktail.dart';

// Data Sources
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

// Repositories
class MockAuthRepository extends Mock implements AuthRepository {}

// Use Cases
class MockLogin extends Mock implements Login {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignup extends Mock implements Signup {}

class MockSendVerificationEmail extends Mock implements SendVerificationEmail {}

class MockResendVerificationEmail extends Mock
    implements ResendVerificationEmail {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignOut extends Mock implements SignOut {}

class MockGetProfile extends Mock implements GetProfile {}

class MockChangePassword extends Mock implements ChangePassword {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockResetPassword extends Mock implements ResetPassword {}

class MockSaveUser extends Mock implements SaveUser {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

/// A fake CurrencyCubit for testing.
/// We use Fake because CurrencyCubit extends Cubit which is not mockable directly.
class FakeCurrencyCubit extends Fake implements CurrencyCubit {
  @override
  Future<void> setCurrencyByCode(String code) async {}

  @override
  Future<void> reset() async {}
}

class MockAnalyticsService extends Mock implements AnalyticsService {}
