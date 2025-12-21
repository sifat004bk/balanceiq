import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatMessageImageView extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const ChatMessageImageView({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: height,
        width: width,
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Icon(
            Icons.error,
            color: Theme.of(context).hintColor,
          ),
        ),
      );
    } else {
      // Local file or asset
      // Note: If it's a file path not in assets, Image.asset might fail if it's meant to be Image.file.
      // MessageBubble logic used Image.asset only.
      // But FloatingChatInput used Image.file for preview.
      // If the message stores a local FS path, Image.asset won't work.
      // However, the original code used Image.asset. I'll stick to it,
      // but if it's a file path, it should check File existence?
      // Original code: Image.asset(imageUrl, ...)

      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Icon(
            Icons.error,
            color: Theme.of(context).hintColor,
          ),
        ),
      );
    }
  }
}
