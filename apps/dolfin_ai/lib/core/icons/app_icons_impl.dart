import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'app_icons.dart';

/// Implementation of AppIcons using Lucide Icons package.
class AppIconsImpl implements AppIcons {
  const AppIconsImpl();

  @override
  NavigationIcons get navigation => const NavigationIconsImpl();

  @override
  DashboardIcons get dashboard => const DashboardIconsImpl();

  @override
  TransactionIcons get transaction => const TransactionIconsImpl();

  @override
  CategoryIcons get category => const CategoryIconsImpl();

  @override
  AccountIcons get account => const AccountIconsImpl();

  @override
  CommonIcons get common => const CommonIconsImpl();

  @override
  ChatErrorIcons get chatError => const ChatErrorIconsImpl();
}

/// Navigation icons implementation
class NavigationIconsImpl implements NavigationIcons {
  const NavigationIconsImpl();

  @override
  Widget arrowUp({double size = 24, Color? color}) => Icon(
        LucideIcons.arrowUp,
        size: size,
        color: color,
      );

  @override
  Widget arrowDown({double size = 24, Color? color}) => Icon(
        LucideIcons.arrowDown,
        size: size,
        color: color,
      );

  @override
  Widget arrowLeft({double size = 24, Color? color}) => Icon(
        LucideIcons.arrowLeft,
        size: size,
        color: color,
      );

  @override
  Widget arrowRight({double size = 24, Color? color}) => Icon(
        LucideIcons.arrowRight,
        size: size,
        color: color,
      );

  @override
  Widget chevronLeft({double size = 24, Color? color}) => Icon(
        LucideIcons.chevronLeft,
        size: size,
        color: color,
      );

  @override
  Widget chevronRight({double size = 24, Color? color}) => Icon(
        LucideIcons.chevronRight,
        size: size,
        color: color,
      );

  @override
  Widget chevronDown({double size = 24, Color? color}) => Icon(
        LucideIcons.chevronDown,
        size: size,
        color: color,
      );
}

/// Dashboard icons implementation
class DashboardIconsImpl implements DashboardIcons {
  const DashboardIconsImpl();

  @override
  Widget income({double size = 24, Color? color}) => Icon(
        LucideIcons.trendingDown,
        size: size,
        color: color,
      );

  @override
  Widget expense({double size = 24, Color? color}) => Icon(
        LucideIcons.trendingUp,
        size: size,
        color: color,
      );

  @override
  Widget category({double size = 24, Color? color}) => Icon(
        LucideIcons.folder,
        size: size,
        color: color,
      );

  @override
  Widget wallet({double size = 24, Color? color}) => Icon(
        LucideIcons.wallet,
        size: size,
        color: color,
      );

  @override
  Widget chat({double size = 24, Color? color}) => Icon(
        LucideIcons.messageCircle,
        size: size,
        color: color,
      );

  @override
  Widget lightMode({double size = 24, Color? color}) => Icon(
        LucideIcons.sun,
        size: size,
        color: color,
      );

  @override
  Widget darkMode({double size = 24, Color? color}) => Icon(
        LucideIcons.moon,
        size: size,
        color: color,
      );

  @override
  Widget user({double size = 24, Color? color}) => Icon(
        LucideIcons.user,
        size: size,
        color: color,
      );
}

/// Transaction icons implementation
class TransactionIconsImpl implements TransactionIcons {
  const TransactionIconsImpl();

  @override
  Widget edit({double size = 24, Color? color}) => Icon(
        LucideIcons.pencil,
        size: size,
        color: color,
      );

  @override
  Widget delete({double size = 24, Color? color}) => Icon(
        LucideIcons.trash2,
        size: size,
        color: color,
      );

  @override
  Widget calendar({double size = 24, Color? color}) => Icon(
        LucideIcons.calendar,
        size: size,
        color: color,
      );

  @override
  Widget description({double size = 24, Color? color}) => Icon(
        LucideIcons.fileText,
        size: size,
        color: color,
      );

  @override
  Widget check({double size = 24, Color? color}) => Icon(
        LucideIcons.check,
        size: size,
        color: color,
      );

  @override
  Widget close({double size = 24, Color? color}) => Icon(
        LucideIcons.x,
        size: size,
        color: color,
      );
}

/// Category icons implementation
class CategoryIconsImpl implements CategoryIcons {
  const CategoryIconsImpl();

  @override
  Widget food({double size = 24, Color? color}) => Icon(
        LucideIcons.utensils,
        size: size,
        color: color,
      );

  @override
  Widget transport({double size = 24, Color? color}) => Icon(
        LucideIcons.car,
        size: size,
        color: color,
      );

  @override
  Widget shopping({double size = 24, Color? color}) => Icon(
        LucideIcons.shoppingBag,
        size: size,
        color: color,
      );

  @override
  Widget bills({double size = 24, Color? color}) => Icon(
        LucideIcons.receipt,
        size: size,
        color: color,
      );

  @override
  Widget home({double size = 24, Color? color}) => Icon(
        LucideIcons.house,
        size: size,
        color: color,
      );

  @override
  Widget health({double size = 24, Color? color}) => Icon(
        LucideIcons.heart,
        size: size,
        color: color,
      );

  @override
  Widget entertainment({double size = 24, Color? color}) => Icon(
        LucideIcons.film,
        size: size,
        color: color,
      );

  @override
  Widget other({double size = 24, Color? color}) => Icon(
        LucideIcons.ellipsis,
        size: size,
        color: color,
      );

  @override
  Widget forCategory(String categoryName, {double size = 24, Color? color}) {
    final lowerName = categoryName.toLowerCase();
    if (lowerName.contains('food') ||
        lowerName.contains('restaurant') ||
        lowerName.contains('dining')) {
      return food(size: size, color: color);
    } else if (lowerName.contains('transport') ||
        lowerName.contains('car') ||
        lowerName.contains('fuel')) {
      return transport(size: size, color: color);
    } else if (lowerName.contains('shop') || lowerName.contains('retail')) {
      return shopping(size: size, color: color);
    } else if (lowerName.contains('bill') ||
        lowerName.contains('utility') ||
        lowerName.contains('receipt')) {
      return bills(size: size, color: color);
    } else if (lowerName.contains('home') ||
        lowerName.contains('rent') ||
        lowerName.contains('housing')) {
      return home(size: size, color: color);
    } else if (lowerName.contains('health') ||
        lowerName.contains('medical') ||
        lowerName.contains('doctor')) {
      return health(size: size, color: color);
    } else if (lowerName.contains('entertainment') ||
        lowerName.contains('movie') ||
        lowerName.contains('game')) {
      return entertainment(size: size, color: color);
    }
    return other(size: size, color: color);
  }
}

/// Account icons implementation
class AccountIconsImpl implements AccountIcons {
  const AccountIconsImpl();

  @override
  Widget wallet({double size = 24, Color? color}) => Icon(
        LucideIcons.wallet,
        size: size,
        color: color,
      );

  @override
  Widget bank({double size = 24, Color? color}) => Icon(
        LucideIcons.landmark,
        size: size,
        color: color,
      );

  @override
  Widget creditCard({double size = 24, Color? color}) => Icon(
        LucideIcons.creditCard,
        size: size,
        color: color,
      );

  @override
  Widget investment({double size = 24, Color? color}) => Icon(
        LucideIcons.trendingUp,
        size: size,
        color: color,
      );

  @override
  Widget payment({double size = 24, Color? color}) => Icon(
        LucideIcons.banknote,
        size: size,
        color: color,
      );

  @override
  Widget forAccountType(String accountType, {double size = 24, Color? color}) {
    final lowerType = accountType.toLowerCase();
    if (lowerType.contains('bank') ||
        lowerType.contains('checking') ||
        lowerType.contains('savings')) {
      return bank(size: size, color: color);
    } else if (lowerType.contains('credit') || lowerType.contains('card')) {
      return creditCard(size: size, color: color);
    } else if (lowerType.contains('invest') ||
        lowerType.contains('stock') ||
        lowerType.contains('trading')) {
      return investment(size: size, color: color);
    } else if (lowerType.contains('payment') ||
        lowerType.contains('digital') ||
        lowerType.contains('mobile')) {
      return payment(size: size, color: color);
    }
    return wallet(size: size, color: color);
  }
}

/// Common icons implementation
class CommonIconsImpl implements CommonIcons {
  const CommonIconsImpl();

  @override
  Widget search({double size = 24, Color? color}) => Icon(
        LucideIcons.search,
        size: size,
        color: color,
      );

  @override
  Widget error({double size = 24, Color? color}) => Icon(
        LucideIcons.circleAlert,
        size: size,
        color: color,
      );

  @override
  Widget dateRange({double size = 24, Color? color}) => Icon(
        LucideIcons.calendarDays,
        size: size,
        color: color,
      );
}

/// Chat error icons implementation
class ChatErrorIconsImpl implements ChatErrorIcons {
  const ChatErrorIconsImpl();

  @override
  Widget emailNotVerified({double size = 24, Color? color}) => Icon(
        LucideIcons.mailWarning,
        size: size,
        color: color,
      );

  @override
  Widget subscriptionRequired({double size = 24, Color? color}) => Icon(
        LucideIcons.crown,
        size: size,
        color: color,
      );

  @override
  Widget subscriptionExpired({double size = 24, Color? color}) => Icon(
        LucideIcons.clockAlert,
        size: size,
        color: color,
      );

  @override
  Widget messageLimitExceeded({double size = 24, Color? color}) => Icon(
        LucideIcons.messageSquareOff,
        size: size,
        color: color,
      );

  @override
  Widget rateLimitExceeded({double size = 24, Color? color}) => Icon(
        LucideIcons.timer,
        size: size,
        color: color,
      );

  @override
  Widget currencyRequired({double size = 24, Color? color}) => Icon(
        LucideIcons.circlePercent,
        size: size,
        color: color,
      );

  @override
  Widget genericError({double size = 24, Color? color}) => Icon(
        LucideIcons.circleAlert,
        size: size,
        color: color,
      );
}
