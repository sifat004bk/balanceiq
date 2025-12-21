abstract class ChatConfig {
  /// Whether to show the attachment (image/file) button in the chat input
  bool get showAttachments;

  /// Whether to show the audio recording button in the chat input
  bool get showAudioRecording;

  /// Whether to show like/dislike buttons on AI messages
  bool get showFeedbackButtons;

  /// Whether to show the select text button on messages
  bool get showSelectTextButton;

  /// Whether to show the copy button on messages
  bool get showCopyButton;

  /// Whether to show the regenerate button on AI messages
  bool get showRegenerateButton;

  /// Text to display at the bottom of the chat (disclaimer)
  /// Set to null to hide
  String? get bottomDisclaimerText;
}
