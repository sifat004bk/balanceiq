import 'dart:io';

import 'package:balance_iq/core/constants/gemini_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../cubit/chat_cubit.dart';

/// Gemini-style chat input with pill-shaped design
class ChatInput extends StatefulWidget {
  final String botId;
  final Color botColor;

  const ChatInput({
    super.key,
    required this.botId,
    required this.botColor,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
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
      // Stop recording
      final path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          _recordedAudioPath = path;
          _isRecording = false;
          _hasContent = true;
        });
      }
    } else {
      // Request permission
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        // Start recording
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

    // Clear input
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: GeminiColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.photo_library,
                      color: GeminiColors.primary),
                ),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: GeminiColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.camera_alt,
                      color: GeminiColors.primary),
                ),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: GeminiColors.primary.withValues(alpha: 0.1),
                  child:
                      const Icon(Icons.mic, color: GeminiColors.primary),
                ),
                title: Text(_isRecording ? 'Stop recording' : 'Record audio'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleRecording();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GeminiColors.background(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview attachments
          if (_selectedImagePath != null || _recordedAudioPath != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  if (_selectedImagePath != null)
                    Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(_selectedImagePath!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImagePath = null;
                                _hasContent =
                                    _textController.text.trim().isNotEmpty ||
                                        _recordedAudioPath != null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: GeminiColors.surface(context),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.close,
                                color: GeminiColors.icon(context),
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_selectedImagePath != null && _recordedAudioPath != null)
                    const SizedBox(width: 12),
                  if (_recordedAudioPath != null)
                    Expanded(
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: GeminiColors.chipBackground(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: GeminiColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.mic,
                                  size: 20, color: GeminiColors.primary),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Audio recorded',
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _recordedAudioPath = null;
                                  _hasContent =
                                      _textController.text.trim().isNotEmpty ||
                                          _selectedImagePath != null;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: GeminiColors.icon(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          // Gemini-style pill input with all controls inside
          Container(
            constraints: const BoxConstraints(
              minHeight: 56, // Gemini min height
              maxHeight: 120, // Allow expansion for multiline
            ),
            decoration: BoxDecoration(
              color: GeminiColors.inputBackground(context),
              borderRadius: BorderRadius.circular(28), // Pill shape (56/2)
              border: Border.all(
                color: GeminiColors.inputBorder(context),
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Attachment button (inside pill)
                IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.add,
                    size: 24,
                  ),
                  onPressed: _isRecording ? _toggleRecording : _showAttachmentOptions,
                  color: _isRecording
                      ? Colors.red
                      : GeminiColors.icon(context),
                  padding: const EdgeInsets.all(12),
                ),
                // Text input (expanded)
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _isRecording
                          ? 'Recording...'
                          : 'Ask me anything...',
                      hintStyle: TextStyle(
                        color: GeminiColors.textSecondary(context),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 4,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(fontSize: 15),
                    enabled: !_isRecording,
                  ),
                ),
                // Send button (inside pill)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _hasContent
                        ? GeminiColors.primary // Purple when active
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_upward, size: 20),
                    onPressed: _hasContent ? _sendMessage : null,
                    color: _hasContent
                        ? Colors.white
                        : GeminiColors.icon(context),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
