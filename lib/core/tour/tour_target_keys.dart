import 'package:flutter/material.dart';

/// Central registry for all GlobalKeys used in the product tour.
///
/// This allows tour targets to be referenced from any widget
/// and ensures consistent targeting across the app.
class TourTargetKeys {
  TourTargetKeys._();

  /// Key for the profile icon in the home app bar (Step 1)
  static final GlobalKey profileIcon =
      GlobalKey(debugLabel: 'tour_profile_icon');

  /// Key for the email verification banner on profile page (Step 2)
  static final GlobalKey emailVerifyBanner =
      GlobalKey(debugLabel: 'tour_email_verify_banner');

  /// Key for the subscription card on profile page (Step 3)
  static final GlobalKey subscriptionCard =
      GlobalKey(debugLabel: 'tour_subscription_card');

  /// Key for the floating chat button on dashboard (Step 4 navigation)
  static final GlobalKey floatingChatButton =
      GlobalKey(debugLabel: 'tour_floating_chat_button');

  /// Key for the chat input field on chat page (Step 4)
  static final GlobalKey chatInputField =
      GlobalKey(debugLabel: 'tour_chat_input_field');
}
