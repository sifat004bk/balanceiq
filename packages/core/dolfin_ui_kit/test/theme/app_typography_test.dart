import 'dart:convert';
import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

// MockAppPalette needed because AppTypography getters access GetIt<AppPalette>
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
        [Colors.blue]
      ];
  @override
  List<Color> get chartLineGradient => [Colors.blue];
  @override
  Color getTooltipColor(bool isDark) => Colors.grey;
  @override
  List<Color> get categoryColors => [Colors.blue];
  @override
  Color getCategoryColor(String category) => Colors.blue;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    GetIt.instance.registerSingleton<AppPalette>(MockAppPalette());

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        final String key = utf8.decode(message!.buffer.asUint8List());

        if (key == 'AssetManifest.bin') {
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
        return ByteData(0);
      },
    );
  });

  tearDown(() {
    GetIt.instance.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('AppTypography', () {
    test('typography styles are valid TextStyles', () {
      expect(AppTypography.hero, isA<TextStyle>());
      expect(AppTypography.heading, isA<TextStyle>());
      expect(AppTypography.body, isA<TextStyle>());
      expect(AppTypography.detail, isA<TextStyle>());
      expect(AppTypography.link, isA<TextStyle>());
    });

    test('display styles are configured correctly', () {
      expect(AppTypography.displayLarge.fontSize, 40);
      expect(AppTypography.displayMedium.fontSize, 28);
    });

    test('headline styles are configured correctly', () {
      expect(AppTypography.headlineMediumBold.fontWeight, FontWeight.bold);
      expect(AppTypography.headlineSmallBold.fontWeight, FontWeight.bold);
    });

    test('title styles are configured correctly', () {
      expect(AppTypography.titleXLargeBold.fontSize, 22);
      expect(AppTypography.titleXLargeSemiBold.fontSize, 20);
      expect(AppTypography.titleLargeBold.fontWeight, FontWeight.bold);
      expect(AppTypography.titleMediumBold.fontSize, 16);
    });

    test('body styles are configured correctly', () {
      expect(AppTypography.bodyLarge.fontSize, 16);
      expect(AppTypography.bodyMedium.fontSize, 14);
      expect(AppTypography.bodyMediumSemiBold.fontWeight, FontWeight.w500);
      expect(AppTypography.bodyMediumBold.fontWeight, FontWeight.bold);
      expect(AppTypography.bodyLargeBold.fontWeight, FontWeight.bold);
    });

    test('button styles are configured correctly', () {
      expect(AppTypography.buttonLarge.fontSize, 16);
      expect(AppTypography.buttonMedium.fontSize, 16);
      expect(AppTypography.buttonMediumSemiBold.fontWeight, FontWeight.w600);
    });

    test('caption styles are configured correctly', () {
      expect(AppTypography.captionSemiBold.fontSize, 12);
      expect(AppTypography.captionBold.fontSize, 13);
      expect(AppTypography.captionXSmallBold.fontSize, 11);
      expect(AppTypography.captionSubtle.fontSize, 12);
      expect(AppTypography.captionMedium.fontSize, 12);
      expect(AppTypography.captionError.color, Colors.red);
      expect(AppTypography.captionWarning.fontSize, 12);
    });

    test('input styles are configured correctly', () {
      expect(AppTypography.inputLarge.fontSize, 18);
    });

    test('AppTypography instantiation (coverage only)', () {
      // Dart static classes
    });
  });
}
