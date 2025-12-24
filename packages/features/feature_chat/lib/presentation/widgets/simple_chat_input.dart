import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:get_it/get_it.dart';

import 'package:feature_chat/constants/chat_strings.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../chat_config.dart';
import 'simple_chat_input_widgets/simple_chat_input_widgets.dart';

class SimpleChatInput extends StatefulWidget {
  final String botId;
  final Color? botColor;
  final double width;
  final Function(double)? onWidthChanged;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;
  final ValueChanged<bool>? onFocusChanged;
  final String? placeholder;

  const SimpleChatInput({
    super.key,
    required this.botId,
    this.botColor,
    this.width = 350.0,
    this.onWidthChanged,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.onFocusChanged,
    this.placeholder,
  });

  @override
  State<SimpleChatInput> createState() => _SimpleChatInputState();
}

class _SimpleChatInputState extends State<SimpleChatInput> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final FocusNode _focusNode = FocusNode();

  XFile? _selectedImage;
  String? _recordedAudioPath;
  bool _isRecording = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Currency check is now handled by ChatPage/ChatCubit initial load
    });
  }

  void _onFocusChanged() {
    widget.onFocusChanged?.call(_focusNode.hasFocus);
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

  void _toggleCollapse() => widget.onToggleCollapse?.call();

  void _onTextChanged() {
    final newHasContent = _textController.text.trim().isNotEmpty ||
        _selectedImage != null ||
        _recordedAudioPath != null;
    if (newHasContent != _hasContent) {
      setState(() => _hasContent = newHasContent);
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
      _showError(GetIt.I<ChatStrings>().imagePickFailed(e.toString()));
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
      _showError(GetIt.I<ChatStrings>().photoFailed(e.toString()));
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
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() => _isRecording = true);
      } else {
        _showError(GetIt.I<ChatStrings>().micPermissionDenied);
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
          content: text.isEmpty ? GetIt.I<ChatStrings>().sentMedia : text,
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

  void _showError(String message) => SnackbarUtils.showError(context, message);

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
                      ? Theme.of(context).hintColor.withValues(alpha: 0.6)
                      : Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto();
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

  // Currency dialog removed as part of UI refactor

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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
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
          gradient: LinearGradient(
            colors: [
              widget.botColor ?? Theme.of(context).colorScheme.primary,
              (widget.botColor ?? Theme.of(context).colorScheme.primary)
                  .withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (widget.botColor ?? Theme.of(context).colorScheme.primary)
                  .withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCollapsed) return _buildCollapsedFAB();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, currencyState) {
        final isCurrencySet = currencyState.isCurrencySet;

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

            // Check for blocking errors
            bool isBlockingError = false;
            if (state is ChatError) {
              final type = state.errorType;
              if (type == ChatErrorType.emailNotVerified ||
                  type == ChatErrorType.subscriptionRequired ||
                  type == ChatErrorType.subscriptionExpired ||
                  type == ChatErrorType.currencyRequired) {
                isBlockingError = true;
              }
            }

            final isDisabled =
                isLimitReached || !isCurrencySet || isBlockingError;

            return Container(
              width: widget.width,
              constraints: const BoxConstraints(maxWidth: double.infinity),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 4, right: 4, bottom: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LimitWarningBanner(
                          isLimitReached: isLimitReached,
                          isNearLimit: isNearLimit,
                          remainingMessages: remainingMessages,
                        ),
                        if (_selectedImage != null)
                          ImagePreviewCard(
                            imagePath: _selectedImage!.path,
                            onRemove: () =>
                                setState(() => _selectedImage = null),
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
                                color: Theme.of(context)
                                    .cardColor
                                    .withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _focusNode.hasFocus
                                      ? primaryColor.withValues(alpha: 0.5)
                                      : primaryColor.withValues(
                                          alpha: isDark ? 0.15 : 0.1),
                                  width: _focusNode.hasFocus ? 1.5 : 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (GetIt.instance<ChatConfig>()
                                          .showAttachments) ...[
                                        ChatAttachmentButton(
                                          primaryColor: primaryColor,
                                          isDisabled: isDisabled,
                                          onTap: _showAttachmentOptions,
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                      Expanded(
                                        child: SimpleChatTextField(
                                          controller: _textController,
                                          focusNode: _focusNode,
                                          isDisabled: isDisabled,
                                          placeholder: widget.placeholder,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      if (GetIt.instance<ChatConfig>()
                                          .showAudioRecording) ...[
                                        ChatMicButton(
                                          isRecording: _isRecording,
                                          isDisabled: isDisabled,
                                          primaryColor: primaryColor,
                                          onTap: _toggleRecording,
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      ChatSendButton(
                                        hasContent: _hasContent,
                                        isDisabled: isDisabled,
                                        primaryColor: primaryColor,
                                        onTap: _sendMessage,
                                      ),
                                    ],
                                  ),
                                  if (!isCurrencySet)
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.transparent,
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
      },
    );
  }
}
