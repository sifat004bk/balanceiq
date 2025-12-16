import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';

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
        color: AppPalette.surfaceModalDark,
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
                color: AppPalette.neutralGrey.withOpacity(0.6),
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
                  label: AppStrings.chat.camera,
                  onTap: onCameraTap,
                ),
                _buildOption(
                  context,
                  icon: Icons.photo_library_outlined,
                  label: AppStrings.chat.gallery,
                  onTap: onGalleryTap,
                ),
                _buildOption(
                  context,
                  icon: Icons.insert_drive_file_outlined,
                  label: AppStrings.chat.files,
                  onTap: onFilesTap,
                ),
                _buildOption(
                  context,
                  icon: Icons.add_to_drive_outlined,
                  label: AppStrings.chat.drive,
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
              color: AppPalette.surfaceCardVariantDark, // Slightly lighter than bg
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.captionMedium.copyWith(
              color: AppPalette.textSubtleLight,
            ),
          ),
        ],
      ),
    );
  }
}
