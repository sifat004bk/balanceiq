import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../chat_config.dart';

/// Modern floating chat input widget
/// Matches the homepage button design but with full chat functionality
class FloatingChatInput extends StatefulWidget {
  final String botId;
  final Color? botColor;

  const FloatingChatInput({
    super.key,
    required this.botId,
    this.botColor,
  });

  @override
  State<FloatingChatInput> createState() => _FloatingChatInputState();
}

class _FloatingChatInputState extends State<FloatingChatInput> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  String? _selectedImagePath;
  String? _recordedAudioPath;
  bool _isRecording = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newHasContent = _textController.text.trim().isNotEmpty ||
        _selectedImagePath != null ||
        _recordedAudioPath != null;
    if (newHasContent != _hasContent) {
      setState(() {
        _hasContent = newHasContent;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
          _hasContent = true;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
          _hasContent = true;
        });
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
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
        _showError('Microphone permission denied');
      }
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();

    if (text.isEmpty &&
        _selectedImagePath == null &&
        _recordedAudioPath == null) {
      return;
    }

    context.read<ChatCubit>().sendNewMessage(
          botId: widget.botId,
          content: text.isEmpty ? 'Sent media' : text,
          imagePath: _selectedImagePath,
          audioPath: _recordedAudioPath,
        );

    _textController.clear();
    setState(() {
      _selectedImagePath = null;
      _recordedAudioPath = null;
      _hasContent = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAttachmentOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1e1f20) : Colors.white,
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
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
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
              color: isDark ? const Color(0xFF2a2a2e) : const Color(0xFFF0F2F5),
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
            style: TextStyle(
              color: isDark ? const Color(0xFFB0B3B8) : const Color(0xFF65676B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Daily limit reached',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
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
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Near limit ($remainingTokens remaining)',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Selected image preview
                if (_selectedImagePath != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1e1f20)
                          : const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? primaryColor.withOpacity(0.2)
                            : primaryColor.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImagePath!),
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
                                  ? const Color(0xFFB0B3B8)
                                  : const Color(0xFF65676B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedImagePath = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                // Main Input Container (Floating Pill)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1e1f20) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDark
                          ? primaryColor.withOpacity(0.2)
                          : primaryColor.withOpacity(0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.08),
                        blurRadius: 16,
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
                          onTap:
                              isLimitReached ? null : _showAttachmentOptions,
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
                          enabled: !isLimitReached,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: isLimitReached
                                ? 'Limit reached'
                                : 'Ask me anything...',
                            hintStyle: TextStyle(
                              color: isLimitReached
                                  ? Colors.grey
                                  : (isDark
                                      ? const Color(0xFFB0B3B8)
                                      : const Color(0xFF65676B)),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: isLimitReached
                                ? Colors.grey
                                : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Voice recording button
                      if (ChatConfig.showAudioRecording)
                        GestureDetector(
                          onTap: isLimitReached ? null : _toggleRecording,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _isRecording
                                  ? Colors.red.withOpacity(0.1)
                                  : (isDark
                                      ? const Color(0xFF2a2a2e)
                                      : const Color(0xFFE8EAED)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic_none,
                              color: _isRecording
                                  ? Colors.red
                                  : (isLimitReached
                                      ? Colors.grey
                                      : primaryColor),
                              size: 20,
                            ),
                          ),
                        ),

                      if (ChatConfig.showAudioRecording)
                        const SizedBox(width: 8),

                      // Send button
                      GestureDetector(
                        onTap:
                            (_hasContent && !isLimitReached) ? _sendMessage : null,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: (_hasContent && !isLimitReached)
                                ? LinearGradient(
                                    colors: [
                                      primaryColor,
                                      primaryColor.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: (_hasContent && !isLimitReached)
                                ? null
                                : (isDark
                                    ? const Color(0xFF2a2a2e)
                                    : const Color(0xFFE8EAED)),
                            shape: BoxShape.circle,
                            boxShadow: (_hasContent && !isLimitReached)
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: (_hasContent && !isLimitReached)
                                ? Colors.white
                                : (isDark
                                    ? const Color(0xFF65676B)
                                    : const Color(0xFF9AA0A6)),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
