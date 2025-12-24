import 'package:flutter/widgets.dart';
import 'package:feature_chat/presentation/widgets/chat_page_widgets/chat_error_widget.dart';
import 'app_icons.dart';

/// Adapter that bridges AppIcons.chatError to the ChatErrorIconProvider interface
/// required by the feature_chat package.
class ChatErrorIconProviderImpl implements ChatErrorIconProvider {
  final ChatErrorIcons _icons;

  const ChatErrorIconProviderImpl(this._icons);

  @override
  Widget emailNotVerified({double size = 24, Color? color}) =>
      _icons.emailNotVerified(size: size, color: color);

  @override
  Widget subscriptionRequired({double size = 24, Color? color}) =>
      _icons.subscriptionRequired(size: size, color: color);

  @override
  Widget subscriptionExpired({double size = 24, Color? color}) =>
      _icons.subscriptionExpired(size: size, color: color);

  @override
  Widget messageLimitExceeded({double size = 24, Color? color}) =>
      _icons.messageLimitExceeded(size: size, color: color);

  @override
  Widget rateLimitExceeded({double size = 24, Color? color}) =>
      _icons.rateLimitExceeded(size: size, color: color);

  @override
  Widget currencyRequired({double size = 24, Color? color}) =>
      _icons.currencyRequired(size: size, color: color);

  @override
  Widget genericError({double size = 24, Color? color}) =>
      _icons.genericError(size: size, color: color);
}
