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

class SimpleChatInput extends StatefulWidget {
  final String botId;
  final Color? botColor;
  final double width;
  final Function(double)? onWidthChanged;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;
  final ValueChanged<bool>? onFocusChanged;

  const SimpleChatInput({
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
  State<SimpleChatInput> createState() => _SimpleChatInputState();
}

class _SimpleChatInputState extends State<SimpleChatInput> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  XFile? _selectedImage;
  String? _recordedAudioPath;
  bool _isRecording = false;
  bool _hasContent = false;

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
    setState(() {});
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

  Widget _buildRecordingAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing outer ring
            Container(
              width: 30 + (value * 4),
              height: 30 + (value * 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6 * (1 - value)),
                  width: 2,
                ),
              ),
            ),
            // Stop icon
            Icon(
              Icons.stop_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ],
        );
      },
      onEnd: () {
        // Restart animation if still recording
        if (_isRecording && mounted) {
          setState(() {});
        }
      },
    );
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
        int remainingMessages = 0;

        if (state is ChatLoaded) {
          isLimitReached = state.isMessageLimitReached;
          isNearLimit =
              state.messagesUsedToday >= (state.dailyMessageLimit * 0.8);
          remainingMessages = state.messagesRemaining;
        }

        return Container(
          // Use provided width
          width: widget.width,
          constraints: const BoxConstraints(
              maxWidth: double.infinity), // Allow full width
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                              AppStrings.chat
                                  .nearMessageLimit(remainingMessages),
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

                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _focusNode.hasFocus
                                  ? primaryColor.withOpacity(0.5)
                                  : (isDark
                                      ? primaryColor.withOpacity(0.15)
                                      : primaryColor.withOpacity(0.1)),
                              width: _focusNode.hasFocus ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Attachment button
                              if (ChatConfig.showAttachments)
                                GestureDetector(
                                  onTap: isLimitReached
                                      ? null
                                      : _showAttachmentOptions,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: isLimitReached
                                          ? Colors.grey
                                          : primaryColor,
                                      size: 22,
                                    ),
                                  ),
                                ),

                              if (ChatConfig.showAttachments)
                                const SizedBox(width: 12),

                              // Text field
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  focusNode: _focusNode,
                                  enabled: !isLimitReached,
                                  maxLines: 4,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    hintText: isLimitReached
                                        ? AppStrings.chat.limitReached
                                        : AppStrings
                                            .chat.inputPlaceholderGeneral,
                                    hintStyle:
                                        AppTypography.inputLarge.copyWith(
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
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Voice recording button with visual feedback (2025)
                              if (ChatConfig.showAudioRecording)
                                AnimatedScale(
                                  scale: _isRecording ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: GestureDetector(
                                    onTap: isLimitReached
                                        ? null
                                        : _toggleRecording,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: _isRecording
                                            ? LinearGradient(
                                                colors: [
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : null,
                                        color: _isRecording
                                            ? null
                                            : (isDark
                                                ? Theme.of(context).canvasColor
                                                : Theme.of(context)
                                                    .dividerColor),
                                        shape: BoxShape.circle,
                                        boxShadow: _isRecording
                                            ? [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                      .withOpacity(0.4),
                                                  blurRadius: 16,
                                                  offset: const Offset(0, 4),
                                                ),
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                      .withOpacity(0.2),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: _isRecording
                                          ? _buildRecordingAnimation()
                                          : Icon(
                                              Icons.mic_none,
                                              color: isLimitReached
                                                  ? Colors.grey
                                                  : primaryColor,
                                              size: 22,
                                            ),
                                    ),
                                  ),
                                ),

                              if (ChatConfig.showAudioRecording)
                                const SizedBox(width: 8),

                              // Send button (Enhanced with animation - 2025)
                              AnimatedScale(
                                scale: (_hasContent && !isLimitReached)
                                    ? 1.0
                                    : 0.9,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                child: GestureDetector(
                                  onTap: (_hasContent && !isLimitReached)
                                      ? _sendMessage
                                      : null,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: (_hasContent && !isLimitReached)
                                          ? LinearGradient(
                                              colors: [
                                                primaryColor,
                                                primaryColor.withOpacity(0.85),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: (_hasContent && !isLimitReached)
                                          ? null
                                          : (isDark
                                              ? Theme.of(context).canvasColor
                                              : Theme.of(context).dividerColor),
                                      shape: BoxShape.circle,
                                      boxShadow:
                                          (_hasContent && !isLimitReached)
                                              ? [
                                                  BoxShadow(
                                                    color: primaryColor
                                                        .withOpacity(0.4),
                                                    blurRadius: 16,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                  BoxShadow(
                                                    color: primaryColor
                                                        .withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                    ),
                                    child: Icon(
                                      Icons.arrow_upward_rounded,
                                      color: (_hasContent && !isLimitReached)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : Theme.of(context).hintColor,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
