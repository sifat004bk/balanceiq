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
      backgroundColor: const Color(0xFF1e1f20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Drag Handle
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            // Options Row
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
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file_outlined,
                  label: 'Files',
                  onTap: () {
                    Navigator.pop(context);
                    // Placeholder for Files
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Files feature coming soon')),
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.add_to_drive_outlined,
                  label: 'Drive',
                  onTap: () {
                    Navigator.pop(context);
                    // Placeholder for Drive
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Drive feature coming soon')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2e), // Slightly lighter than bg
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFc4c7c5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1e1f20), // Dark grey background
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), // Large rounded top corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), // Padding inside the modal
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Field Row (Top)
            Container(
              constraints: const BoxConstraints(
                minHeight: 24,
                maxHeight: 120,
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'What do you want to write?',
                  hintStyle: TextStyle(
                    color: GeminiColors.textSecondary(context),
                    fontSize: 18, // Larger font
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  filled: false, // Ensure no background
                  fillColor: Colors.transparent,
                ),
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  fontSize: 18,
                  color: GeminiColors.icon(context),
                ),
                onChanged: (text) {
                  setState(() {
                    _hasContent = text.trim().isNotEmpty ||
                        _selectedImagePath != null;
                  });
                },
              ),
            ),
            
          const SizedBox(height: 20), // Spacing between text and actions
            
            // Bottom Actions Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Plus Icon (Left)
                GestureDetector(
                  onTap: _showAttachmentOptions,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.add,
                      color: GeminiColors.icon(context),
                      size: 28,
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),

                // Attachment Pill (if image selected)
                if (_selectedImagePath != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2e406c), // Dark blue
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image, size: 16, color: Color(0xFFa8c7fa)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImagePath = null;
                            });
                          },
                          child: const Icon(Icons.close, size: 16, color: Color(0xFFa8c7fa)),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),
                
                // Mic Icon
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2a2a2e),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: _isRecording ? Colors.red : const Color(0xFFc4c7c5),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Send Icon
                GestureDetector(
                  onTap: _hasContent ? _sendMessage : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _hasContent ? GeminiColors.primaryColor(context) : const Color(0xFF2a2a2e),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send, 
                      color: _hasContent ? Colors.white : const Color(0xFFc4c7c5), 
                      size: 24
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
