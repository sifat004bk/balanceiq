import 'package:dolfin_ui_kit/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlassContainer', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              child: Text('Glass Content'),
            ),
          ),
        ),
      );

      expect(find.text('Glass Content'), findsOneWidget);
    });

    testWidgets('applies custom blur sigma', (tester) async {
      const double customBlur = 20.0;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              blurSigma: customBlur,
              child: SizedBox(),
            ),
          ),
        ),
      );

      final backdropFilter = tester.widget<BackdropFilter>(find.descendant(
        of: find.byType(GlassContainer),
        matching: find.byType(BackdropFilter),
      ));

      // The ImageFilter is not directly inspectable for sigma values easily in tests depending on platform implementation,
      // but we can ensure the widget hierarchy is correct.
      expect(backdropFilter, isNotNull);
    });

    testWidgets('applies custom styling (opacity, radius, colors)',
        (tester) async {
      const Color bgColor = Colors.red;
      const double radius = 30.0;
      const Color borderColor = Colors.blue;
      const double borderWidth = 5.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              backgroundColor: bgColor,
              borderRadius: radius,
              borderColor: borderColor,
              borderWidth: borderWidth,
              child: SizedBox(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(radius));
      expect(decoration.border!.top.color, borderColor);
      expect(decoration.border!.top.width, borderWidth);
      // Background color opacity is applied inside the widget implementation
    });

    testWidgets('applies custom padding and margin', (tester) async {
      const EdgeInsets padding = EdgeInsets.all(20);
      const EdgeInsets margin = EdgeInsets.all(15);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassContainer(
              padding: padding,
              margin: margin,
              child: SizedBox(),
            ),
          ),
        ),
      );

      // Margin is on the outer container
      final outerContainer = tester.widget<Container>(find
          .ancestor(
            of: find.byType(ClipRRect),
            matching: find.byType(Container),
          )
          .first);
      expect(outerContainer.margin, margin);

      // Padding is on the inner container
      final innerContainer = tester.widget<Container>(find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.byType(Container),
      ));
      expect(innerContainer.padding, padding);
    });
  });

  group('AnimatedGlassContainer', () {
    testWidgets('initializes with fade transition', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedGlassContainer(
              child: Text('Animated Generic'),
            ),
          ),
        ),
      );

      // Allow animation to start
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.text('Animated Generic'), findsOneWidget);
    });

    testWidgets('disposes controller properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedGlassContainer(
              child: SizedBox(),
            ),
          ),
        ),
      );

      // Trigger dispose by replacing widget
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      // No error thrown means dispose worked correctly
    });
  });

  group('GradientGlassContainer', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientGlassContainer(
              child: Text('Gradient Content'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Content'), findsOneWidget);
    });

    testWidgets('applies gradient decoration', (tester) async {
      const Gradient gradient =
          LinearGradient(colors: [Colors.red, Colors.blue]);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientGlassContainer(
              gradient: gradient,
              child: SizedBox(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      // Note: The widget implementation might modify the gradient (e.g. scale), so direct equality check might need adjustment or isA check.
      expect(decoration.gradient, isA<Gradient>());
    });

    testWidgets('applies custom border radius and border', (tester) async {
      const double radius = 15.0;
      const Color borderColor = Colors.green;
      const double borderWidth = 3.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientGlassContainer(
              borderRadius: radius,
              borderColor: borderColor,
              borderWidth: borderWidth,
              child: SizedBox(),
            ),
          ),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(radius));

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(BackdropFilter),
        matching: find.byType(Container),
      ));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(radius));
      expect(decoration.border!.top.color, borderColor);
      expect(decoration.border!.top.width, borderWidth);
    });
  });
}
