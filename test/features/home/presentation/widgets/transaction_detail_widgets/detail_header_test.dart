import 'package:balance_iq/features/home/presentation/widgets/transaction_detail_widgets/detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('DetailHeader', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        DetailHeader(
          isIncome: true,
          isEditMode: false,
          transactionId: '123',
          onToggleEdit: () {},
        ),
      );
      await tester.pumpAndSettle(); // Wait for animations

      expect(find.byType(DetailHeader), findsOneWidget);
      expect(find.text('Transaction Details'), findsOneWidget);
      expect(find.text('Transaction ID: #123'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('shows correct title in edit mode', (tester) async {
      await tester.pumpApp(
        DetailHeader(
          isIncome: true,
          isEditMode: true,
          transactionId: '123',
          onToggleEdit: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows correct icon and color for expense', (tester) async {
      await tester.pumpApp(
        DetailHeader(
          isIncome: false,
          isEditMode: false,
          transactionId: '123',
          onToggleEdit: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('calls onToggleEdit when button tapped', (tester) async {
      bool tapped = false;
      await tester.pumpApp(
        DetailHeader(
          isIncome: true,
          isEditMode: false,
          transactionId: '123',
          onToggleEdit: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      expect(tapped, true);
    });
  });
}
