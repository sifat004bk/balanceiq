import 'package:flutter/material.dart';

class AttachmentOptionsSheet extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onTakePhoto;

  const AttachmentOptionsSheet({
    super.key,
    required this.onPickImage,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAttachmentOption(
            context,
            icon: Icons.image,
            label: 'Gallery',
            onTap: () {
              Navigator.pop(context);
              onPickImage();
            },
          ),
          _buildAttachmentOption(
            context,
            icon: Icons.camera_alt,
            label: 'Camera',
            onTap: () {
              Navigator.pop(context);
              onTakePhoto();
            },
          ),
          _buildAttachmentOption(
            context,
            icon: Icons.attach_file,
            label: 'Document',
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement document picking
            },
          ),
          _buildAttachmentOption(
            context,
            icon: Icons.location_on,
            label: 'Location',
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement location sharing
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
