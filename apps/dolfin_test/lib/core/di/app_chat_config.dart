import 'package:feature_chat/presentation/chat_config.dart';

/// Test App Chat Configuration
class TestChatConfig implements ChatConfig {
  @override
  bool get showAttachments => false;

  @override
  bool get showAudioRecording => false;

  @override
  bool get showFeedbackButtons => true;

  @override
  bool get showSelectTextButton => false;

  @override
  bool get showCopyButton => true;

  @override
  bool get showRegenerateButton => false;

  @override
  String? get bottomDisclaimerText => "Test App - Mock Mode";
}
