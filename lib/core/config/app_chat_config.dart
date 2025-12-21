import 'package:feature_chat/presentation/chat_config.dart';

class AppChatConfig implements ChatConfig {
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
  String? get bottomDisclaimerText => "Donfin AI can make mistake.";
}
