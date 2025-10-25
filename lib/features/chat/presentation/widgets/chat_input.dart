import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../cubit/chat_cubit.dart';

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

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    super.dispose();
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

    if (text.isEmpty && _selectedImagePath == null && _recordedAudioPath == null) {
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

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview selected image
          if (_selectedImagePath != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(_selectedImagePath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImagePath = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Preview audio recording
          if (_recordedAudioPath != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Audio recorded')),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      setState(() {
                        _recordedAudioPath = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
          // Input row - Gemini style
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F4F9),
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                // Add button (image)
                IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: _showImageSourceDialog,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  splashRadius: 24,
                ),
                // Text input
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ask ${widget.botId.replaceAll('_', ' ')}',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // Mic button
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic, size: 24),
                  onPressed: _toggleRecording,
                  color: _isRecording ? Colors.red : (isDark ? Colors.grey[400] : Colors.grey[700]),
                  splashRadius: 24,
                ),
                // Send button
                if (_textController.text.isNotEmpty || _selectedImagePath != null || _recordedAudioPath != null)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: widget.botColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, size: 20),
                      onPressed: _sendMessage,
                      color: Colors.white,
                      splashRadius: 20,
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
