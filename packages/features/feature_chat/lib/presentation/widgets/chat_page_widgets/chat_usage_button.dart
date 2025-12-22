import 'package:flutter/material.dart';

import '../message_usage_button.dart';

class ChatUsageButton extends StatelessWidget {
  const ChatUsageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 16,
      child: const MessageUsageButton(),
    );
  }
}
