import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../chat_config.dart';

/// Modern floating chat input widget
/// Matches the homepage button design but with full chat functionality
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
    // No local collapse state init needed
    // Initialize focus listener
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

  /// Animated recording indicator (2025 design)
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
                  color: AppPalette.neutralWhite.withOpacity(0.6 * (1 - value)),
                  width: 2,
                ),
              ),
            ),
            // Stop icon
            Icon(
              Icons.stop_rounded,
              color: AppPalette.neutralWhite,
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppPalette.expenseRed,
      ),
    );
  }

  void _showAttachmentOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? AppPalette.surfaceModalDark : AppPalette.neutralWhite,
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
                      ? AppPalette.neutralGrey.withOpacity(0.6)
                      : Colors.grey[300],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              color: isDark
                  ? AppPalette.surfaceCardVariantDark
                  : AppPalette.inputBackgroundLight,
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
              color:
                  isDark ? AppPalette.textSubtleLight : AppPalette.neutralGrey,
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
              color: AppPalette.neutralBlack.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.chat_bubble_outline,
          color: AppPalette.neutralWhite,
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
          isLimitReached = state.isTokenLimitReached;
          isNearLimit = state.currentTokenUsage > (state.dailyTokenLimit * 0.9);
          remainingTokens = state.dailyTokenLimit - state.currentTokenUsage;
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
                    // Normalize delta to handle resizing from center or edges
                    // User said "dragging left or right... width should increase or decrease"
                    // If we expand symmetrically, 1px drag = 2px width change?
                    // Or simple: Right drag = increase, Left = Shrink?
                    // Let's assume standard resize behavior: Drag Right = Expand, Left = Shrink?
                    // But it's centered. This is ambiguous.
                    // "dragging left or right ... width should increase or decrease"
                    // Let's implement: Drag Right (+) -> Increase width. Drag Left (-) -> Decrease width.
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
                            ? AppPalette.neutralGrey.withOpacity(0.6)
                            : Colors.grey[400],
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
                          color: AppPalette.expenseRed.withOpacity(
                              0.9), // Higher opacity for legibility
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppPalette.expenseRed),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: AppPalette.neutralWhite, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.chat.messageLimitReached,
                              style: AppTypography.captionError.copyWith(
                                color: AppPalette.neutralWhite,
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
                          color: AppPalette.warningOrange
                              .withOpacity(0.9), // Higher opacity
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppPalette.warningOrange),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppPalette.neutralWhite,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.chat.nearMessageLimit(remainingTokens),
                              style: AppTypography.captionWarning.copyWith(
                                color: AppPalette.neutralWhite,
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
                              ? AppPalette.surfaceModalDark
                              : AppPalette.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? primaryColor.withOpacity(0.2)
                                : primaryColor.withOpacity(0.15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.neutralBlack
                                  .withValues(alpha: 0.1),
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
                                      ? AppPalette.neutralGrey
                                      : AppPalette.neutralGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: isDark
                                    ? AppPalette.neutralWhite
                                    : Colors.black,
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

                    // Main Input Container (Enhanced Floating Pill - 2025)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.identity()
                        ..scale(_focusNode.hasFocus ? 1.1 : 1.0),
                      transformAlignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        // Glassmorphic background
                        color: isDark
                            ? AppPalette.surfaceModalDark
                                .withOpacity(_focusNode.hasFocus ? 1.0 : 0.95)
                            : AppPalette.neutralWhite
                                .withOpacity(_focusNode.hasFocus ? 1.0 : 0.95),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _focusNode.hasFocus
                              ? primaryColor
                                  .withOpacity(0.8) // Stronger glow on focus
                              : (_hasContent
                                  ? primaryColor.withOpacity(0.6)
                                  : (isDark
                                      ? primaryColor.withOpacity(0.2)
                                      : primaryColor.withOpacity(0.15))),
                          width: _focusNode.hasFocus
                              ? 2.5
                              : (_hasContent ? 2.0 : 1.5),
                        ),
                        boxShadow: [
                          // Spotlight Glow
                          if (_focusNode.hasFocus)
                            BoxShadow(
                              color: primaryColor.withOpacity(0.5),
                              blurRadius: 16,
                              spreadRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          // Primary shadow
                          BoxShadow(
                            color: _hasContent
                                ? primaryColor.withOpacity(0.35)
                                : primaryColor.withOpacity(0.15),
                            blurRadius: _hasContent ? 10 : 5,
                            offset: const Offset(0, 4),
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
                                    : AppStrings.chat.inputPlaceholderGeneral,
                                hintStyle: AppTypography.inputLarge.copyWith(
                                  color: isLimitReached
                                      ? AppPalette.neutralGrey
                                      : (isDark
                                          ? AppPalette.textSubtleLight
                                          : AppPalette.neutralGrey),
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
                                        ? AppPalette.neutralWhite
                                        : Colors.black),
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
                                onTap: isLimitReached ? null : _toggleRecording,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: _isRecording
                                        ? LinearGradient(
                                            colors: [
                                              AppPalette.expenseRed,
                                              AppPalette.expenseRed
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: _isRecording
                                        ? null
                                        : (isDark
                                            ? AppPalette.surfaceCardVariantDark
                                            : AppPalette.dividerLight),
                                    shape: BoxShape.circle,
                                    boxShadow: _isRecording
                                        ? [
                                            BoxShadow(
                                              color: AppPalette.expenseRed
                                                  .withOpacity(0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 4),
                                            ),
                                            BoxShadow(
                                              color: AppPalette.expenseRed
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
                            scale: (_hasContent && !isLimitReached) ? 1.0 : 0.9,
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
                                          ? AppPalette.surfaceCardVariantDark
                                          : AppPalette.dividerLight),
                                  shape: BoxShape.circle,
                                  boxShadow: (_hasContent && !isLimitReached)
                                      ? [
                                          BoxShadow(
                                            color:
                                                primaryColor.withOpacity(0.4),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                          BoxShadow(
                                            color:
                                                primaryColor.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: (_hasContent && !isLimitReached)
                                      ? AppPalette.neutralWhite
                                      : (isDark
                                          ? AppPalette.neutralGrey
                                          : AppPalette.neutralGrey),
                                  size: 24,
                                ),
                              ),
                            ),
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
