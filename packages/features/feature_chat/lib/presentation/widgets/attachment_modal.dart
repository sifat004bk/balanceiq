import 'package:flutter/material.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';

class AttachmentModal extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onFilesTap;
  final VoidCallback onDriveTap;

  const AttachmentModal({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onFilesTap,
    required this.onDriveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Drag Handle
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            // Options Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context,
                  icon: Icons.camera_alt_outlined,
                  label: GetIt.I<ChatStrings>().camera,
                  onTap: onCameraTap,
                ),
                _buildOption(
                  context,
                  icon: Icons.photo_library_outlined,
                  label: GetIt.I<ChatStrings>().gallery,
                  onTap: onGalleryTap,
                ),
                _buildOption(
                  context,
                  icon: Icons.insert_drive_file_outlined,
                  label: GetIt.I<ChatStrings>().files,
                  onTap: onFilesTap,
                ),
                _buildOption(
                  context,
                  icon: Icons.add_to_drive_outlined,
                  label: GetIt.I<ChatStrings>().drive,
                  onTap: onDriveTap,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
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
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.onSurface, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
