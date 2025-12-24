import 'package:flutter/widgets.dart';

/// A reusable app logo widget that displays the app icon with customizable size and color.
///
/// This widget centralizes the app icon asset, making it easy to update
/// the logo across the entire app from a single location.
class AppLogo extends StatelessWidget {
  /// The size of the logo (both width and height).
  final double size;

  /// Optional color tint for the logo.
  final Color? color;

  /// Optional box fit for the image.
  final BoxFit? fit;

  const AppLogo({
    super.key,
    this.size = 48,
    this.color,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/icons/app_icon.png',
        width: size,
        height: size,
        color: color,
        fit: fit ?? BoxFit.contain,
      ),
    );
  }
}
