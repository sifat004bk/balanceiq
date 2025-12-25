import 'dart:convert';
import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:dolfin_ui_kit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class MockAppPalette implements AppPalette {
  @override
  Color get primaryLight => Colors.blue;

  @override
  Color get primaryDark => Colors.blueAccent;

  @override
  Color get secondaryLight => Colors.green;

  @override
  Color get secondaryDark => Colors.greenAccent;

  @override
  Color get backgroundLight => Colors.white;

  @override
  Color get backgroundDark => Colors.black;

  @override
  Color get surfaceLight => Colors.grey[200]!;

  @override
  Color get surfaceDark => Colors.grey[800]!;

  @override
  Color get textPrimaryLight => Colors.black87;

  @override
  Color get textPrimaryDark => Colors.white70;

  @override
  Color get textSecondaryLight => Colors.black54;

  @override
  Color get textSecondaryDark => Colors.white54;

  @override
  Color get error => Colors.red;

  @override
  Color get warning => Colors.orange;

  @override
  Color get success => Colors.green;

  @override
  Color get info => Colors.blue;

  @override
  Color get white => Colors.white;

  @override
  Color get black => Colors.black;

  @override
  Color get expense => Colors.red;

  @override
  Color get income => Colors.green;

  @override
  Color get surfaceContainerDark => Colors.grey[900]!;

  @override
  Color get transparent => Colors.transparent;

  @override
  List<List<Color>> get chartBarColors => [
        [Colors.blue, Colors.lightBlue]
      ];

  @override
  List<Color> get chartLineGradient => [Colors.blue, Colors.lightBlue];

  @override
  Color getTooltipColor(bool isDark) =>
      isDark ? Colors.grey[800]! : Colors.grey[200]!;

  @override
  List<Color> get categoryColors => [Colors.red, Colors.green, Colors.blue];

  @override
  Color getCategoryColor(String category) => Colors.blue;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    GetIt.instance.registerSingleton<AppPalette>(MockAppPalette());

    // Raw String Protocol Handler for flutter/assets
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        // Decode raw string key from bytes
        final String key = utf8.decode(message!.buffer.asUint8List());

        if (key == 'AssetManifest.bin') {
          // Return the content of AssetManifest.bin (StandardMessageCodec encoded Map)
          // Return it encoded as SuccessEnvelope?
          // If request was raw string, response format likely depends on what caller expects.
          // PlatformAssetBundle logic:
          // If it uses MethodChannel, it expects Envelope.
          // But if it sent raw string, it is NOT using MethodChannel logic (or using it with raw codec?).
          // Let's try returning raw content first. If that fails (corrupted envelope), we try envelope.
          // BUT, the debug log showed request was raw string. MethodChannel usually wraps request in envelope.
          // So caller is likely using BasicMessageChannel or send directly.
          // In that case, return raw bytes.
          return const StandardMessageCodec()
              .encodeMessage(<String, List<Object>>{
            'google_fonts/Manrope-Regular.ttf': [
              <String, Object>{'asset': 'google_fonts/Manrope-Regular.ttf'}
            ],
            'packages/dolfin_ui_kit/google_fonts/Manrope-Regular.ttf': [
              <String, Object>{
                'asset':
                    'packages/dolfin_ui_kit/google_fonts/Manrope-Regular.ttf'
              }
            ],
          });
        }
        if (key == 'AssetManifest.json') {
          return ByteData.view(Uint8List.fromList('{}'.codeUnits).buffer);
        }

        // For fonts, return non-empty valid ByteData? Or just 0-length.
        // GoogleFonts might be ok with 0-length.
        return ByteData(0);
      },
    );
  });

  tearDown(() {
    GetIt.instance.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('AppTheme', () {
    test('lightTheme returns valid ThemeData', () {
      final theme = AppTheme.lightTheme();

      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, Colors.blue); // From MockAppPalette
      expect(theme.scaffoldBackgroundColor, Colors.white);
      expect(theme.useMaterial3, true);
      expect(theme.textTheme.bodyLarge?.fontFamily, contains('Manrope'));
    });

    test('darkTheme returns valid ThemeData', () {
      final theme = AppTheme.darkTheme();

      expect(theme.brightness, Brightness.dark);
      expect(theme.primaryColor, Colors.blueAccent);
      expect(theme.scaffoldBackgroundColor, Colors.black);
      expect(theme.useMaterial3, true);
    });
  });
}
