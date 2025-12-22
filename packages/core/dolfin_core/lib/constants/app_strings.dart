import 'package:get_it/get_it.dart';
import 'core_strings.dart';

export 'core_strings.dart';

/// Centralized Strings Accessor for Core Modules
///
/// Features should access their own strings via DI:
/// e.g., `GetIt.I<AuthStrings>()`
class AppStrings {
  const AppStrings._();

  static CoreStrings get core => GetIt.I<CoreStrings>();

  // Shortcuts for Core sections
  static CommonStrings get common => core.common;
  static ErrorStrings get errors => core.errors;
  static AccessibilityStrings get accessibility => core.accessibility;
  static SyncStrings get sync => core.sync;

  // Temporary: Expose these until they move to their own features

  static TransactionsStrings get transactions => core.transactions;
  static AccountStrings get accounts => core.accounts;
}
