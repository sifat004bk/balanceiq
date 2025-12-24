import 'package:feature_chat/presentation/cubit/chat_state.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/chat_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() {
    GetIt.instance.reset(); // Ensure GetIt is empty
  });

  testWidgets('ChatErrorWidget should render fallback text when DI is missing',
      (WidgetTester tester) async {
    // Arrange
    const state = ChatError(
      message: 'Currency not set',
      errorType: ChatErrorType.currencyRequired,
    );

    // Act
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ChatErrorWidget(
          state: state,
          botId: 'bot1',
        ),
      ),
    ));

    // Assert
    expect(find.text('Currency Required'), findsOneWidget); // Fallback title
    expect(find.text('Set Currency'), findsOneWidget); // Fallback button
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
