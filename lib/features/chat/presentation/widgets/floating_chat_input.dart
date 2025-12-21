import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../chat_config.dart';

import 'floating_chat_input_widgets/chat_attachment_button.dart';
import 'floating_chat_input_widgets/chat_mic_button.dart';
import 'floating_chat_input_widgets/chat_text_field.dart';
import 'floating_chat_input_widgets/chat_send_button.dart';
import 'floating_chat_input_widgets/chat_input_container.dart';

class FloatingChatInput extends StatefulWidget {
  final String botId;
  final Color? botColor;
  final double width;
  final Function(double)? onWidthChanged;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;
  final ValueChanged<bool>? onFocusChanged;

  const FloatingChatInput({
    super.key,
    required this.botId,
    this.botColor,
    this.width = 350.0,
    this.onWidthChanged,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.onFocusChanged,
  });

  @override
  State<FloatingChatInput> createState() => _FloatingChatInputState();
}

class _FloatingChatInputState extends State<FloatingChatInput> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  // State for attachment
  XFile? _selectedImage;
  String? _recordedAudioPath;
  bool _isRecording = false;
  bool _hasContent = false;

  // Focus node
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged!(_focusNode.hasFocus);
    }
    setState(() {
      // Rebuild to update UI based on focus
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _audioRecorder.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleCollapse() {
    widget.onToggleCollapse?.call();
  }

  void _onTextChanged() {
    final newHasContent = _textController.text.trim().isNotEmpty ||
        _selectedImage != null ||
        _recordedAudioPath != null;
    if (newHasContent != _hasContent) {
      setState(() {
        _hasContent = newHasContent;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _hasContent = true;
        });
      }
    } catch (e) {
      _showError(AppStrings.chat.imagePickFailed(e.toString()));
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _hasContent = true;
        });
      }
    } catch (e) {
      _showError(AppStrings.chat.photoFailed(e.toString()));
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          _recordedAudioPath = path;
          _isRecording = false;
          _hasContent = true;
        });
      }
    } else {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(),
          path: path,
        );

        setState(() {
          _isRecording = true;
        });
      } else {
        _showError(AppStrings.chat.micPermissionDenied);
      }
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();

    if (text.isEmpty && _selectedImage == null && _recordedAudioPath == null) {
      return;
    }

    context.read<ChatCubit>().sendNewMessage(
          botId: widget.botId,
          content: text.isEmpty ? AppStrings.chat.sentMedia : text,
          imagePath: _selectedImage?.path,
          audioPath: _recordedAudioPath,
        );

    _textController.clear();
    setState(() {
      _selectedImage = null;
      _recordedAudioPath = null;
      _hasContent = false;
    });
  }

  void _showError(String message) {
    SnackbarUtils.showError(context, message);
  }

  void _showAttachmentOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).hintColor.withOpacity(0.6)
                      : Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt_outlined,
                    label: AppStrings.chat.camera,
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.photo_library_outlined,
                    label: AppStrings.chat.gallery,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedFAB() {
    return GestureDetector(
      onTap: _toggleCollapse,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.chat_bubble_outline,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCollapsed) {
      return _buildCollapsedFAB();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        bool isLimitReached = false;
        bool isNearLimit = false;
        int remainingTokens = 0;

        if (state is ChatLoaded) {
          isLimitReached = state.isMessageLimitReached;
          isNearLimit =
              state.messagesUsedToday > (state.dailyMessageLimit * 0.8);
          remainingTokens = state.dailyMessageLimit - state.messagesUsedToday;
        }

        return Container(
          // Use provided width
          width: widget.width,
          constraints: const BoxConstraints(
              maxWidth: double.infinity), // Allow full width
          // No decoration here
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Collapse Button (Tiny) - Optional, maybe just tap outside?
              // Let's add a small handle or minimize button
              // Centered Drag Handle
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _toggleCollapse,
                  onPanUpdate: (details) {
                    if (widget.onWidthChanged != null) {
                      widget.onWidthChanged!(details.delta.dx);
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 300) {
                      _toggleCollapse();
                    }
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 8), // Removed bottom margin
                    padding: const EdgeInsets.only(
                        top: 8,
                        left: 8,
                        right: 8,
                        bottom: 2), // Reduced bottom padding
                    width: 60,
                    alignment: Alignment.center,
                    child: Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Theme.of(context).hintColor.withOpacity(0.6)
                            : Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

              // Content Wrapper
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Token Warning Banner
                    if (isLimitReached)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(
                                  0.9), // Higher opacity for legibility
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Theme.of(context).colorScheme.onError,
                                size: 18),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.chat.messageLimitReached,
                              style: AppTypography.captionError.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isNearLimit)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.chat.nearMessageLimit(remainingTokens),
                              style: AppTypography.captionWarning.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Selected image preview
                    if (_selectedImage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Theme.of(context).cardColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? primaryColor.withOpacity(0.2)
                                : primaryColor.withOpacity(0.15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedImage!.path),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Image selected',
                                style: TextStyle(
                                  color: isDark
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).hintColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: isDark
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).hintColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                    // Main Input Container (Using extracted widget)
                    ChatInputContainer(
                      hasFocus: _focusNode.hasFocus,
                      hasContent: _hasContent,
                      isDark: isDark,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Attachment button
                          if (ChatConfig.showAttachments)
                            ChatAttachmentButton(
                              onTap: isLimitReached
                                  ? null
                                  : _showAttachmentOptions,
                              isEnabled: !isLimitReached,
                            ),

                          if (ChatConfig.showAttachments)
                            const SizedBox(width: 12),

                          // Text field
                          ChatTextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            isLimitReached: isLimitReached,
                            isDark: isDark,
                          ),

                          const SizedBox(width: 12),

                          // Voice recording button
                          if (ChatConfig.showAudioRecording)
                            ChatMicButton(
                              isRecording: _isRecording,
                              onTap: isLimitReached ? () {} : _toggleRecording,
                              isEnabled: !isLimitReached,
                            ),

                          if (ChatConfig.showAudioRecording)
                            const SizedBox(width: 8),

                          // Send button
                          ChatSendButton(
                            onTap: _sendMessage,
                            isEnabled: (_hasContent && !isLimitReached),
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
