import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/features/home/presentation/widgets/transaction_detail_widgets/detail_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('DetailActionButtons', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        DetailActionButtons(
          isEditMode: false,
          onDelete: () {},
          onSaveOrEdit: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DetailActionButtons), findsOneWidget);
    });

    testWidgets('shows correct label and icon in edit mode', (tester) async {
      await tester.pumpApp(
        DetailActionButtons(
          isEditMode: true,
          onDelete: () {},
          onSaveOrEdit: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.common.saveChanges), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('shows correct label and icon in view mode', (tester) async {
      await tester.pumpApp(
        DetailActionButtons(
          isEditMode: false,
          onDelete: () {},
          onSaveOrEdit: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.common.edit), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('calls onDelete when delete button tapped', (tester) async {
      bool deleted = false;
      await tester.pumpApp(
        DetailActionButtons(
          isEditMode: false,
          onDelete: () => deleted = true,
          onSaveOrEdit: () {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.common.delete));
      expect(deleted, true);
    });

    testWidgets('calls onSaveOrEdit when primary button tapped',
        (tester) async {
      bool savedOrEdited = false;
      await tester.pumpApp(
        DetailActionButtons(
          isEditMode: false,
          onDelete: () {},
          onSaveOrEdit: () => savedOrEdited = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      expect(savedOrEdited, true);
    });
  });
}
