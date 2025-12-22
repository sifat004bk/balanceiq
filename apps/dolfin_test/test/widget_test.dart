import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:dolfin_test/main.dart';
import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import 'package:dolfin_ui_kit/theme/theme_state.dart';
import 'package:dolfin_core/tour/product_tour_cubit.dart'; // Core tour
import 'package:dolfin_core/tour/product_tour_state.dart';
import 'package:feature_auth/presentation/cubit/session/session_cubit.dart';
import 'package:feature_auth/presentation/pages/splash_page.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:feature_auth/domain/auth_config.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}

class MockSessionCubit extends Mock implements SessionCubit {}

class MockProductTourCubit extends Mock implements ProductTourCubit {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAuthConfig extends Mock implements AuthConfig {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockThemeCubit mockThemeCubit;
  late MockSessionCubit mockSessionCubit;
  late MockProductTourCubit mockProductTourCubit;
  late MockSecureStorageService mockSecureStorageService;
  late MockAuthConfig mockAuthConfig;

  setUpAll(() {
    registerFallbackValue(ThemeInitial());
    registerFallbackValue(SessionInitial());
    registerFallbackValue(const TourInactive());
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockSessionCubit = MockSessionCubit();
    mockProductTourCubit = MockProductTourCubit();
    mockSecureStorageService = MockSecureStorageService();
    mockAuthConfig = MockAuthConfig();

    // Setup default stubbing
    when(() => mockThemeCubit.state).thenReturn(ThemeInitial());
    when(() => mockThemeCubit.stream)
        .thenAnswer((_) => Stream.value(ThemeInitial()));

    // Session Cubit setup - emit unauthenticated to show Login or Splash logic logic
    when(() => mockSessionCubit.state).thenReturn(SessionInitial());
    when(() => mockSessionCubit.stream)
        .thenAnswer((_) => Stream.value(SessionInitial()));
    when(() => mockSessionCubit.checkAuthStatus()).thenAnswer((_) async {});

    // Product Tour
    when(() => mockProductTourCubit.state).thenReturn(const TourInactive());
    when(() => mockProductTourCubit.stream)
        .thenAnswer((_) => Stream.value(const TourInactive()));

    // Secure Storage
    when(() => mockSecureStorageService.getToken())
        .thenAnswer((_) async => null);

    // Auth Config
    when(() => mockAuthConfig.onOnboardingRequired(any()))
        .thenAnswer((_) async {});
    when(() => mockAuthConfig.onUnauthenticated(any()))
        .thenAnswer((_) async {});
    when(() => mockAuthConfig.onAuthenticated(any())).thenAnswer((_) async {});

    // Stub close methods
    when(() => mockThemeCubit.close()).thenAnswer((_) async {});
    when(() => mockSessionCubit.close()).thenAnswer((_) async {});
    when(() => mockProductTourCubit.close()).thenAnswer((_) async {});

    // Populate GetIt
    GetIt.instance.registerSingleton<ThemeCubit>(mockThemeCubit);
    GetIt.instance.registerSingleton<SessionCubit>(mockSessionCubit);
    GetIt.instance.registerSingleton<ProductTourCubit>(mockProductTourCubit);
    GetIt.instance
        .registerSingleton<SecureStorageService>(mockSecureStorageService);
    GetIt.instance.registerSingleton<AuthConfig>(mockAuthConfig);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('App Launches and builds SplashPage',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(const DolfinTestApp());
    expect(find.byType(SplashPage), findsOneWidget);

    // Allow splash timer to complete
    await tester.pump(const Duration(seconds: 3));
  });
}
