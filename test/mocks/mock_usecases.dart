import 'package:balance_iq/features/auth/domain/usecases/login.dart';
import 'package:balance_iq/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:balance_iq/features/auth/domain/usecases/signup.dart';
import 'package:balance_iq/features/auth/domain/usecases/send_verification_email.dart';
import 'package:balance_iq/features/auth/domain/usecases/resend_verification_email.dart';
import 'package:balance_iq/features/auth/domain/usecases/get_current_user.dart';
import 'package:balance_iq/features/auth/domain/usecases/sign_out.dart';
import 'package:balance_iq/features/auth/domain/usecases/get_profile.dart';
import 'package:balance_iq/features/chat/domain/usecases/get_chat_history.dart';
import 'package:balance_iq/features/chat/domain/usecases/get_message_usage.dart';
import 'package:balance_iq/features/chat/domain/usecases/get_messages.dart';
import 'package:balance_iq/features/chat/domain/usecases/send_message.dart';
import 'package:balance_iq/features/chat/domain/usecases/submit_feedback.dart';
import 'package:balance_iq/features/chat/domain/usecases/update_message.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignup extends Mock implements Signup {}

class MockSendVerificationEmail extends Mock implements SendVerificationEmail {}

class MockResendVerificationEmail extends Mock
    implements ResendVerificationEmail {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignOut extends Mock implements SignOut {}

class MockGetProfile extends Mock implements GetProfile {}

class MockGetChatHistory extends Mock implements GetChatHistory {}

class MockGetMessageUsage extends Mock implements GetMessageUsage {}

class MockGetMessages extends Mock implements GetMessages {}

class MockSendMessage extends Mock implements SendMessage {}

class MockSubmitFeedback extends Mock implements SubmitFeedback {}

class MockUpdateMessage extends Mock implements UpdateMessage {}
