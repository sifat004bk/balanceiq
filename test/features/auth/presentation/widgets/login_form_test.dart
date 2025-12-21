import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:balance_iq/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../mocks/mock_cubits.dart';

void main() {
  late MockLoginCubit mockLoginCubit;

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    when(() => mockLoginCubit.state).thenReturn(LoginInitial());
  });

  Future<void> pumpLoginForm(WidgetTester tester) async {
    await tester.pumpApp(
      BlocProvider<LoginCubit>.value(
        value: mockLoginCubit,
        child: const Scaffold(
          body: SingleChildScrollView(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }

  group('LoginForm', () {
    testWidgets('renders all fields and buttons', (tester) async {
      await pumpLoginForm(tester);

      expect(find.text(AppStrings.auth.loginTitle), findsOneWidget);
      expect(find.text(AppStrings.auth.emailLabel), findsOneWidget);
      expect(find.text(AppStrings.auth.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.auth.loginButton), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text(AppStrings.auth.forgotPassword), findsOneWidget);
      expect(find.text(AppStrings.auth.noAccount), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty',
        (tester) async {
      await pumpLoginForm(tester);

      await tester.tap(find.text(AppStrings.auth.loginButton));
      await tester.pump();

      expect(find.text(AppStrings.auth.emailRequired), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      verifyNever(() => mockLoginCubit.loginWithEmail(
          username: any(named: 'username'), password: any(named: 'password')));
    });

    testWidgets('toggles password visibility', (tester) async {
      await pumpLoginForm(tester);

      final passwordFieldFinder = find.ancestor(
        of: find.text(AppStrings.auth.passwordHint),
        matching: find.byType(TextField),
      );

      // Initially obscured
      TextField passwordField = tester.widget(passwordFieldFinder);
      expect(passwordField.obscureText, isTrue);

      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Now visible
      passwordField = tester.widget(passwordFieldFinder);
      expect(passwordField.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('calls loginWithEmail when form is valid', (tester) async {
      await pumpLoginForm(tester);

      when(() => mockLoginCubit.loginWithEmail(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async {});

      await tester.enterText(
          find.widgetWithText(TextFormField, AppStrings.auth.emailHint),
          'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, AppStrings.auth.passwordHint),
          'password123');

      await tester.tap(find.text(AppStrings.auth.loginButton));
      await tester.pump();

      verify(() => mockLoginCubit.loginWithEmail(
            username: 'test',
            password: 'password123',
          )).called(1);
    });

    testWidgets('calls signInGoogle when google button is tapped', skip: true,
        (tester) async {
      await pumpLoginForm(tester);
      await tester.pumpAndSettle();

      when(() => mockLoginCubit.signInGoogle()).thenAnswer((_) async {});

      // Find the Google button by OutlinedButton type
      final googleButton = find.ancestor(
        of: find.text('Google'),
        matching: find.byType(OutlinedButton),
      );

      await tester.tap(googleButton);
      await tester.pump();

      verify(() => mockLoginCubit.signInGoogle()).called(1);
    });

    testWidgets('shows loading indicator when state is LoginLoading',
        (tester) async {
      when(() => mockLoginCubit.state).thenReturn(LoginLoading());

      await pumpLoginForm(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(AppStrings.auth.loginButton), findsNothing);
    });
  });
}
