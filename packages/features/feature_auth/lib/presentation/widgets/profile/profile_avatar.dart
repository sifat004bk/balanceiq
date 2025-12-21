import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final dynamic user;

  const ProfileAvatar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary,
                width: 3,
              ),
              gradient: user.photoUrl == null || user.photoUrl!.isEmpty
                  ? LinearGradient(
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? colorScheme.surface
                  : null,
            ),
            child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.photoUrl!,
                      width: 114,
                      height: 114,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildInitials(context);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  )
                : _buildInitials(context),
          ),
        ),
        if (user.isEmailVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_rounded,
                color: Colors.green,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
