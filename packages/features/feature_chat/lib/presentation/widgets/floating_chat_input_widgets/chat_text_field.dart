import 'package:flutter/material.dart';
import 'package:dolfin_core/constants/app_strings.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLimitReached;
  final bool isDark;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLimitReached,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: !isLimitReached,
        maxLines: 4,
        minLines: 1,
        decoration: InputDecoration(
          hintText: isLimitReached
              ? AppStrings.chat.limitReached
              : AppStrings.chat.inputPlaceholderGeneral,
          hintStyle: AppTypography.inputLarge.copyWith(
            color: isLimitReached
                ? Theme.of(context).hintColor
                : (isDark
                    ? Theme.of(context).hintColor
                    : Theme.of(context).hintColor),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          isDense: true,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
        ),
        style: TextStyle(
          fontSize: 15,
          color: isLimitReached
              ? Colors.grey
              : (isDark
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
