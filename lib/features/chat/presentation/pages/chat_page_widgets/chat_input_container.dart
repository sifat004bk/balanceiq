import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../widgets/simple_chat_input.dart';

class ChatInputContainer extends StatelessWidget {
  final GlobalKey chatInputKey;
  final double keyboardHeight;
  final String botId;

  const ChatInputContainer({
    super.key,
    required this.chatInputKey,
    required this.keyboardHeight,
    required this.botId,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        key: chatInputKey,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: keyboardHeight > 0 ? 8 : 16,
        ),
        child: SimpleChatInput(
          botId: botId,
          botColor: AppTheme.getBotColor(botId),
          width: MediaQuery.of(context).size.width - 32,
          isCollapsed: false,
        ),
      ),
    );
  }
}
