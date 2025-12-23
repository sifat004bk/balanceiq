import 'package:dolfin_ui_kit/widgets/animated_dolfin_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/services.dart';
import 'dart:typed_data';

class TestAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      return StandardMessageCodec().encodeMessage(<String, List<Object>>{})!;
    }

    if (key == 'AssetManifest.json') {
      return ByteData.view(Uint8List.fromList('{}'.codeUnits).buffer);
    }

    // Return a valid 1x1 transparent PNG for the logo image
    final Uint8List bytes = Uint8List.fromList([
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82
    ]);
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return ""; // Fallback
  }
}

void main() {
  group('AnimatedDolfinLogo', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: AnimatedDolfinLogo(animate: false),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(Transform),
        matching: find.byType(Container),
      ));

      // Default size is 80
      expect(container.constraints?.minWidth, 80);
      expect(container.constraints?.minHeight, 80);
    });

    testWidgets('renders with custom size', (tester) async {
      const double customSize = 120;
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: AnimatedDolfinLogo(size: customSize, animate: false),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(Transform),
        matching: find.byType(Container),
      ));

      expect(container.constraints?.minWidth, customSize);
      expect(container.constraints?.minHeight, customSize);
    });

    testWidgets('starts animation when animate is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: AnimatedDolfinLogo(animate: true),
            ),
          ),
        ),
      );

      // Verify AnimationController is attached
      // Look for AnimatedBuilder strictly inside AnimatedDolfinLogo
      expect(
          find.descendant(
              of: find.byType(AnimatedDolfinLogo),
              matching: find.byType(AnimatedBuilder)),
          findsOneWidget);

      // Wait for animation frame
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('does not animate when animate is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: AnimatedDolfinLogo(animate: false),
            ),
          ),
        ),
      );

      // Look for Transform inside AnimatedDolfinLogo
      final transformFinder = find.descendant(
          of: find.byType(AnimatedDolfinLogo),
          matching: find.byType(Transform));

      final transform = tester.widget<Transform>(transformFinder);
      final matrix = transform.transform;
      // Identity matrix (scale 1.0)
      expect(matrix.getMaxScaleOnAxis(), 1.0);
    });

    testWidgets('shows glow effect when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: AnimatedDolfinLogo(showGlow: true, animate: false),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(Transform),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('hides glow effect when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: AnimatedDolfinLogo(showGlow: false, animate: false),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(Transform),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNull);
    });
  });

  group('DolfinLogoIcon', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: DolfinLogoIcon(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      // Size 28
      expect(container.constraints?.minWidth, 28);
      expect(container.constraints?.minHeight, 28);
    });

    testWidgets('renders with custom size', (tester) async {
      const double size = 40;
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: DolfinLogoIcon(size: size),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minWidth, size);
      expect(container.constraints?.minHeight, size);
    });

    testWidgets('shows shadow when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: DolfinLogoIcon(showShadow: true),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('hides shadow when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const Scaffold(
              body: DolfinLogoIcon(showShadow: false),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNull);
    });
  });
}
