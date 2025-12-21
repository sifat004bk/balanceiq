part of 'interactive_onboarding_cubit.dart';

/// A single message in the simulated chat
class SimulatedMessage {
  final String id;
  final String content;
  final bool isUser;
  final bool isTyping;
  final DateTime timestamp;

  const SimulatedMessage({
    required this.id,
    required this.content,
    required this.isUser,
    this.isTyping = false,
    required this.timestamp,
  });

  SimulatedMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    bool? isTyping,
    DateTime? timestamp,
  }) {
    return SimulatedMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      isTyping: isTyping ?? this.isTyping,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// State for the interactive onboarding flow
class InteractiveOnboardingState {
  final int currentScreen; // 0: Welcome, 1: Story, 2: Practice
  final List<SimulatedMessage> messages;
  final bool storyCompleted;
  final bool storyPlaying;
  final bool userPracticed;
  final String? userInput;
  final bool showCelebration;

  const InteractiveOnboardingState({
    this.currentScreen = 0,
    this.messages = const [],
    this.storyCompleted = false,
    this.storyPlaying = false,
    this.userPracticed = false,
    this.userInput,
    this.showCelebration = false,
  });

  InteractiveOnboardingState copyWith({
    int? currentScreen,
    List<SimulatedMessage>? messages,
    bool? storyCompleted,
    bool? storyPlaying,
    bool? userPracticed,
    String? userInput,
    bool? showCelebration,
  }) {
    return InteractiveOnboardingState(
      currentScreen: currentScreen ?? this.currentScreen,
      messages: messages ?? this.messages,
      storyCompleted: storyCompleted ?? this.storyCompleted,
      storyPlaying: storyPlaying ?? this.storyPlaying,
      userPracticed: userPracticed ?? this.userPracticed,
      userInput: userInput ?? this.userInput,
      showCelebration: showCelebration ?? this.showCelebration,
    );
  }

  bool get isWelcomeScreen => currentScreen == 0;
  bool get isStoryScreen => currentScreen == 1;
  bool get isPracticeScreen => currentScreen == 2;
}
