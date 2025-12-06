class ChatConfig {
  /// Whether to show the attachment (image/file) button in the chat input
  static const bool showAttachments = false;

  /// Whether to show the audio recording button in the chat input
  static const bool showAudioRecording = false;

  /// Whether to show like/dislike buttons on AI messages
  static const bool showFeedbackButtons = true;

  /// Whether to show the select text button on messages
  static const bool showSelectTextButton = false;

  /// Whether to show the copy button on me
  /// Whether to show the regenerate button on AI messages
  static const bool showRegenerateButton = false;

  /// Text to display at the bottom of the chat (disclaimer)
  /// Set to null to hide
  static const String? bottomDisclaimerText = "BalanceIQ may display inaccurate info, including about people, so double-check its responses.";
}
