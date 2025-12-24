import 'package:flutter/widgets.dart';

/// Centralized icon reference for the app.
/// Similar to AppStrings pattern for consistency.
abstract class AppIcons {
  NavigationIcons get navigation;
  DashboardIcons get dashboard;
  TransactionIcons get transaction;
  CategoryIcons get category;
  AccountIcons get account;
  CommonIcons get common;
}

/// Navigation-related icons (arrows, chevrons, etc.)
abstract class NavigationIcons {
  Widget arrowUp({double size, Color? color});
  Widget arrowDown({double size, Color? color});
  Widget arrowLeft({double size, Color? color});
  Widget arrowRight({double size, Color? color});
  Widget chevronLeft({double size, Color? color});
  Widget chevronRight({double size, Color? color});
  Widget chevronDown({double size, Color? color});
}

/// Dashboard-related icons
abstract class DashboardIcons {
  Widget income({double size, Color? color});
  Widget expense({double size, Color? color});
  Widget category({double size, Color? color});
  Widget wallet({double size, Color? color});
  Widget chat({double size, Color? color});
  Widget lightMode({double size, Color? color});
  Widget darkMode({double size, Color? color});
  Widget user({double size, Color? color});
}

/// Transaction-related icons
abstract class TransactionIcons {
  Widget edit({double size, Color? color});
  Widget delete({double size, Color? color});
  Widget calendar({double size, Color? color});
  Widget description({double size, Color? color});
  Widget check({double size, Color? color});
  Widget close({double size, Color? color});
}

/// Category-specific icons
abstract class CategoryIcons {
  Widget food({double size, Color? color});
  Widget transport({double size, Color? color});
  Widget shopping({double size, Color? color});
  Widget bills({double size, Color? color});
  Widget home({double size, Color? color});
  Widget health({double size, Color? color});
  Widget entertainment({double size, Color? color});
  Widget other({double size, Color? color});

  /// Get icon by category name
  Widget forCategory(String categoryName, {double size, Color? color});
}

/// Account type icons
abstract class AccountIcons {
  Widget wallet({double size, Color? color});
  Widget bank({double size, Color? color});
  Widget creditCard({double size, Color? color});
  Widget investment({double size, Color? color});
  Widget payment({double size, Color? color});

  /// Get icon by account type
  Widget forAccountType(String accountType, {double size, Color? color});
}

/// Common/utility icons
abstract class CommonIcons {
  Widget search({double size, Color? color});
  Widget error({double size, Color? color});
  Widget dateRange({double size, Color? color});
}
