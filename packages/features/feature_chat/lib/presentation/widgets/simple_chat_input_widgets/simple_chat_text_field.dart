import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_typography.dart';

class SimpleChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDisabled;

  const SimpleChatTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: !isDisabled,
      maxLines: 4,
      minLines: 1,
      decoration: InputDecoration(
        hintText: isDisabled
            ? AppStrings.chat.limitReached
            : AppStrings.chat.inputPlaceholderGeneral,
        hintStyle: AppTypography.inputLarge.copyWith(
          color: Theme.of(context).hintColor,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      style: TextStyle(
        fontSize: 15,
        color:
            isDisabled ? Colors.grey : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
