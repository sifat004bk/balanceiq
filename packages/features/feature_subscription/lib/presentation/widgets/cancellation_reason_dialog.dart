import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/constants/core_strings.dart';
import '../../constants/subscription_strings.dart';

/// A dialog widget that collects cancellation reason from the user
/// with 5 preset options plus an "Other" option with text input.
class CancellationReasonDialog extends StatefulWidget {
  const CancellationReasonDialog({super.key});

  /// Shows the dialog and returns the selected reason, or null if cancelled
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const CancellationReasonDialog(),
    );
  }

  @override
  State<CancellationReasonDialog> createState() =>
      _CancellationReasonDialogState();
}

class _CancellationReasonDialogState extends State<CancellationReasonDialog> {
  String? _selectedReason;
  bool _isOtherSelected = false;
  final TextEditingController _otherController = TextEditingController();
  String? _errorMessage;

  List<String> get _presetReasons => [
        GetIt.I<SubscriptionStrings>().cancelReasonTooExpensive,
        GetIt.I<SubscriptionStrings>().cancelReasonNotUsing,
        GetIt.I<SubscriptionStrings>().cancelReasonMissingFeatures,
        GetIt.I<SubscriptionStrings>().cancelReasonFoundAlternative,
        GetIt.I<SubscriptionStrings>().cancelReasonTechnicalIssues,
      ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onReasonSelected(String reason) {
    setState(() {
      _selectedReason = reason;
      _isOtherSelected = false;
      _errorMessage = null;
    });
  }

  void _onOtherSelected() {
    setState(() {
      _selectedReason = null;
      _isOtherSelected = true;
      _errorMessage = null;
    });
  }

  void _submit() {
    String? finalReason;

    if (_isOtherSelected) {
      final otherText = _otherController.text.trim();
      if (otherText.isEmpty) {
        setState(() {
          _errorMessage = GetIt.I<SubscriptionStrings>().reasonRequired;
        });
        return;
      }
      finalReason = otherText;
    } else if (_selectedReason != null) {
      finalReason = _selectedReason;
    } else {
      setState(() {
        _errorMessage = GetIt.I<SubscriptionStrings>().reasonRequired;
      });
      return;
    }

    Navigator.of(context).pop(finalReason);
  }

  @override
  Widget build(BuildContext context) {
    final strings = GetIt.I<SubscriptionStrings>();
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(strings.whyCancelling),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preset reasons
            ..._presetReasons.map((reason) => _buildReasonTile(reason)),

            // Other option
            _buildOtherTile(),

            // Text field for "Other"
            if (_isOtherSelected) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otherController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: strings.pleaseSpecifyReason,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
            ],

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(GetIt.I<CoreStrings>().common.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
          ),
          child: Text(strings.submitCancellation),
        ),
      ],
    );
  }

  Widget _buildReasonTile(String reason) {
    final isSelected = _selectedReason == reason;
    final colorScheme = Theme.of(context).colorScheme;

    return RadioListTile<String>(
      value: reason,
      groupValue: _selectedReason,
      onChanged: (value) => _onReasonSelected(value!),
      title: Text(
        reason,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: colorScheme.primary,
    );
  }

  Widget _buildOtherTile() {
    final colorScheme = Theme.of(context).colorScheme;

    return RadioListTile<bool>(
      value: true,
      groupValue: _isOtherSelected ? true : null,
      onChanged: (_) => _onOtherSelected(),
      title: Text(
        GetIt.I<SubscriptionStrings>().cancelReasonOther,
        style: TextStyle(
          fontSize: 14,
          color: _isOtherSelected ? colorScheme.primary : null,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: colorScheme.primary,
    );
  }
}
