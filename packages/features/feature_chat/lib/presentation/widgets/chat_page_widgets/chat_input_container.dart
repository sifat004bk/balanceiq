import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:feature_chat/presentation/cubit/chat_cubit.dart';
import 'package:feature_chat/presentation/cubit/chat_state.dart';

import 'package:dolfin_ui_kit/theme/app_theme.dart';
import '../simple_chat_input.dart';

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
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            String? placeholder;
            if (state is ChatError) {
              switch (state.errorType) {
                case ChatErrorType.emailNotVerified:
                  placeholder =
                      GetIt.I<ChatStrings>().inputPlaceholderEmailVerification;
                  break;
                case ChatErrorType.subscriptionRequired:
                case ChatErrorType.subscriptionExpired:
                  placeholder = GetIt.I<ChatStrings>()
                      .inputPlaceholderSubscriptionRequired;
                  break;
                case ChatErrorType.currencyRequired:
                  placeholder =
                      GetIt.I<ChatStrings>().inputPlaceholderCurrencyRequired;
                  break;
                default:
                  break;
              }
            }

            return SimpleChatInput(
              botId: botId,
              botColor: Theme.of(context).colorScheme.primary,
              width: MediaQuery.of(context).size.width,
              isCollapsed: false,
              placeholder: placeholder,
            );
          },
        ),
      ),
    );
  }
}
