# BalanceIQ Chat Page Redesign 2025

**Document Version:** 1.0
**Last Updated:** 2025-12-14
**Status:** Design Specification
**Target:** Q1 2025 Implementation

---

## Executive Summary

This document provides comprehensive design recommendations to modernize the BalanceIQ chat interface based on 2025 UX research findings, Material Design 3 evolution, and emerging visual trends. The redesign maintains the current architecture (floating input, message list, suggested prompts) while enhancing visual appeal, accessibility, and user engagement through modern design patterns.

**Key Focus Areas:**
- Glassmorphism and depth through layering
- Micro-interactions and delightful animations
- Enhanced accessibility (WCAG 2.2 AA compliance)
- Financial app context (trust, clarity, precision)
- Bangladesh market considerations (mobile-first, Bangla support readiness)
- Performance optimization for low-end devices

---

## Table of Contents

1. [Updated Visual Design System](#1-updated-visual-design-system)
2. [Message Bubble Redesign](#2-message-bubble-redesign)
3. [Input Field Improvements](#3-input-field-improvements)
4. [Empty State Enhancement](#4-empty-state-enhancement)
5. [Interaction Patterns](#5-interaction-patterns)
6. [Financial UI Components](#6-financial-ui-components)
7. [Accessibility Enhancements](#7-accessibility-enhancements)
8. [Animation & Motion](#8-animation--motion)
9. [Responsive Design](#9-responsive-design)
10. [Implementation Roadmap](#10-implementation-roadmap)

---

## 1. Updated Visual Design System

### 1.1 Color Palette Updates for 2025

#### Primary Colors with Enhanced Vibrancy

**Light Mode:**
```dart
// Enhanced primary with more saturation
static const Color primaryLight = Color(0xFF6750A4); // Current - Keep
static const Color primaryAccentLight = Color(0xFF8A7AE0); // NEW - Lighter accent
static const Color primaryGlowLight = Color(0xFFE8DEFF); // NEW - Glow effect

// Glassmorphism support colors
static const Color glassBackgroundLight = Color(0xFFFEFBFF); // Semi-transparent base
static const Color glassFrostLight = Color(0xFFF5F0FF); // NEW - Frosted glass effect
static const Color glassBorderLight = Color(0xFFE0D7FF); // NEW - Glass border
```

**Dark Mode:**
```dart
// Enhanced primary for dark mode
static const Color primaryDark = Color(0xFFD0BCFF); // Current - Keep
static const Color primaryAccentDark = Color(0xFFB8A4F0); // NEW - Muted accent
static const Color primaryGlowDark = Color(0xFF5E44BD); // NEW - Glow effect

// Glassmorphism support colors
static const Color glassBackgroundDark = Color(0xFF1C1B1F); // Semi-transparent base
static const Color glassFrostDark = Color(0xFF2B2930); // NEW - Frosted glass effect
static const Color glassBorderDark = Color(0xFF3E3948); // NEW - Glass border
```

#### Semantic Colors (Financial Context)

```dart
// Income/Expense with better contrast
static const Color incomeGreen = Color(0xFF00C853); // Vibrant success green
static const Color incomeGreenLight = Color(0xFFE8F5E9); // Background tint
static const Color expenseRed = Color(0xFFFF5252); // Coral red (current)
static const Color expenseRedLight = Color(0xFFFFEBEE); // Background tint
static const Color neutralGray = Color(0xFF78909C); // Neutral transactions
static const Color neutralGrayLight = Color(0xFFECEFF1); // Background tint

// Warning colors for token limits
static const Color warningOrange = Color(0xFFFF9800);
static const Color warningOrangeLight = Color(0xFFFFF3E0);
static const Color errorRed = Color(0xFFD32F2F);
static const Color errorRedLight = Color(0xFFFFEBEE);
```

#### Surface Elevation System (2025 Approach)

Instead of hard-coded shadow colors, use elevation levels:

```dart
// Elevation levels with blur and tint
enum SurfaceElevation {
  level0, // Background (no elevation)
  level1, // Cards, surfaces (2dp equivalent)
  level2, // Floating elements (4dp equivalent)
  level3, // Dialogs, modals (8dp equivalent)
  level4, // Nav drawer (16dp equivalent)
}

// Implementation example
BoxShadow getElevationShadow(SurfaceElevation level, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  switch (level) {
    case SurfaceElevation.level1:
      return BoxShadow(
        color: isDark
          ? Colors.black.withOpacity(0.2)
          : Colors.black.withOpacity(0.08),
        blurRadius: 4,
        offset: const Offset(0, 2),
      );
    case SurfaceElevation.level2:
      return BoxShadow(
        color: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.12),
        blurRadius: 8,
        offset: const Offset(0, 4),
      );
    case SurfaceElevation.level3:
      return BoxShadow(
        color: isDark
          ? Colors.black.withOpacity(0.4)
          : Colors.black.withOpacity(0.16),
        blurRadius: 16,
        offset: const Offset(0, 8),
      );
    case SurfaceElevation.level4:
      return BoxShadow(
        color: isDark
          ? Colors.black.withOpacity(0.5)
          : Colors.black.withOpacity(0.20),
        blurRadius: 24,
        offset: const Offset(0, 12),
      );
    default:
      return BoxShadow(color: Colors.transparent);
  }
}
```

### 1.2 Typography Scale and Hierarchy

**Enhanced Typography with Better Readability**

```dart
// Chat-specific typography scale
class ChatTypography {
  // Message text sizes
  static const double messageFontSize = 16.0; // Current - Keep
  static const double messageLineHeight = 1.5; // Current - Keep

  // NEW - Bot name and metadata
  static const double botNameSize = 13.0;
  static const double timestampSize = 11.0;
  static const double disclaimerSize = 10.0;

  // NEW - Suggested prompts
  static const double promptLabelSize = 14.0;
  static const double promptIconSize = 20.0;

  // NEW - Financial numbers (larger, tabular)
  static const double financialNumberSize = 24.0;
  static const double financialLabelSize = 12.0;

  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Letter spacing for numbers (tabular clarity)
  static const double numberLetterSpacing = 0.5;
}

// Usage example in message bubble
TextStyle getMessageStyle(BuildContext context, {bool isUser = false}) {
  return TextStyle(
    fontSize: ChatTypography.messageFontSize,
    height: ChatTypography.messageLineHeight,
    fontWeight: ChatTypography.regular,
    color: isUser
      ? GeminiColors.userMessageText
      : GeminiColors.aiMessageText(context),
    fontFeatures: const [
      FontFeature.tabularFigures(), // NEW - For financial numbers
    ],
  );
}
```

### 1.3 Spacing System and Layout Grid

**8pt Grid System with Chat-Specific Constants**

```dart
class ChatSpacing {
  // Base unit (8pt)
  static const double unit = 8.0;

  // Horizontal padding
  static const double pageHorizontal = 16.0; // 2 units
  static const double bubblePadding = 16.0; // 2 units
  static const double inputPadding = 20.0; // 2.5 units

  // Vertical spacing
  static const double messageBubbleGap = 8.0; // 1 unit - REDUCED from 16
  static const double sectionGap = 24.0; // 3 units
  static const double componentGap = 12.0; // 1.5 units

  // NEW - Bubble internal spacing
  static const double bubbleContentPadding = 16.0; // 2 units
  static const double bubbleIconGap = 12.0; // 1.5 units
  static const double bubbleMetadataGap = 8.0; // 1 unit

  // Input field spacing
  static const double inputBottomMargin = 20.0; // Current
  static const double inputComponentGap = 12.0; // Between icons/buttons

  // GenUI component spacing
  static const double cardPadding = 20.0; // 2.5 units
  static const double cardBorderRadius = 20.0; // 2.5 units
  static const double chartHeight = 200.0; // Fixed height

  // NEW - Avatar and icon sizes
  static const double botAvatarSize = 28.0; // 3.5 units
  static const double actionIconSize = 20.0; // 2.5 units
  static const double attachmentIconSize = 24.0; // 3 units
}
```

### 1.4 Border Radius and Shape System

**Modern Rounded Corners (2025 Trend: Larger Radii)**

```dart
class ChatShapes {
  // Message bubbles
  static const double userBubbleRadius = 24.0; // Current - Keep
  static const double aiBubbleRadius = 20.0; // NEW - Slightly less rounded

  // Input field
  static const double inputRadius = 30.0; // Current pill shape - Keep
  static const double inputCollapsedRadius = 28.0; // Circular when collapsed

  // Cards and containers
  static const double cardRadius = 20.0; // Current - Keep
  static const double modalRadius = 28.0; // NEW - Larger for modals

  // Chips and buttons
  static const double chipRadius = 20.0; // Current - Keep
  static const double buttonRadius = 24.0; // NEW - For action buttons

  // NEW - Image containers
  static const double imageRadius = 12.0;
  static const double avatarRadius = 14.0; // For circular avatars

  // Border widths
  static const double thinBorder = 1.0;
  static const double mediumBorder = 1.5;
  static const double thickBorder = 2.0;
}
```

---

## 2. Message Bubble Redesign

### 2.1 User Message Bubble - Enhanced Design

**Current Implementation:**
- Dark grey background (#303030)
- 24px border radius
- White text
- Timestamp below bubble

**2025 Redesign:**

**Visual Updates:**
```dart
Widget _buildUserMessage(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: ChatSpacing.bubbleContentPadding,
      vertical: 14, // Slightly larger vertical padding
    ),
    decoration: BoxDecoration(
      // NEW - Gradient instead of solid color
      gradient: LinearGradient(
        colors: [
          GeminiColors.userMessageBg,
          GeminiColors.userMessageBg.withOpacity(0.95),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(ChatShapes.userBubbleRadius),
      // NEW - Subtle shadow for depth
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Message content
        Text(
          widget.message.content,
          style: getMessageStyle(context, isUser: true),
        ),

        // NEW - Image with better presentation
        if (widget.message.imageUrl != null &&
            widget.message.imageUrl!.isNotEmpty) ...[
          const SizedBox(height: ChatSpacing.componentGap),
          ClipRRect(
            borderRadius: BorderRadius.circular(ChatShapes.imageRadius),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(ChatShapes.imageRadius),
              ),
              child: _buildImage(widget.message.imageUrl!),
            ),
          ),
        ],

        // NEW - Inline timestamp (right-aligned, subtle)
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _formatTimestamp(widget.message.timestamp),
              style: TextStyle(
                fontSize: ChatTypography.timestampSize,
                color: Colors.white.withOpacity(0.6),
                fontWeight: ChatTypography.medium,
              ),
            ),
            // NEW - Delivery status indicator (optional)
            if (widget.message.isDelivered) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
```

**Key Changes:**
- Gradient background for depth
- Inline timestamp (more compact)
- Delivery status indicator
- Image border treatment
- Larger vertical padding for better touch targets

**Priority:** P1 - Medium Priority
**Implementation Time:** 2-3 hours
**Impact:** Medium - Better visual hierarchy and modern feel

### 2.2 AI Message Bubble - Major Redesign

**Current Implementation:**
- No background color (transparent)
- Markdown rendering
- Action buttons below (like, dislike, copy, regenerate)
- Small avatar icon with sparkle

**2025 Redesign:**

**Visual Updates:**
```dart
Widget _buildAiMessage(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.all(0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NEW - Bot header with avatar and name
        _buildBotHeader(context),

        const SizedBox(height: ChatSpacing.bubbleMetadataGap),

        // NEW - Glassmorphic container for AI message
        Container(
          padding: const EdgeInsets.all(ChatSpacing.bubbleContentPadding),
          decoration: BoxDecoration(
            // Glassmorphism effect
            color: isDark
                ? GeminiColors.glassFrostDark.withOpacity(0.6)
                : GeminiColors.glassFrostLight.withOpacity(0.8),
            borderRadius: BorderRadius.circular(ChatShapes.aiBubbleRadius),
            border: Border.all(
              color: isDark
                  ? GeminiColors.glassBorderDark.withOpacity(0.3)
                  : GeminiColors.glassBorderLight.withOpacity(0.5),
              width: ChatShapes.thinBorder,
            ),
            // NEW - Subtle inner glow
            boxShadow: [
              BoxShadow(
                color: GeminiColors.primaryColor(context).withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message content with markdown
              if (widget.message.content.isNotEmpty)
                MarkdownBody(
                  data: widget.message.content,
                  selectable: true,
                  builders: { /* existing builders */ },
                  styleSheet: _getEnhancedMarkdownStyle(context),
                ),

              // GenUI components (existing)
              if (widget.message.hasTable && widget.message.tableData != null)
                Padding(
                  padding: const EdgeInsets.only(top: ChatSpacing.componentGap),
                  child: GenUITable(data: widget.message.tableData!),
                ),

              if (widget.message.graphType != null &&
                  widget.message.graphData != null)
                Padding(
                  padding: const EdgeInsets.only(top: ChatSpacing.componentGap),
                  child: GenUIChart(
                    data: widget.message.graphData!,
                    type: widget.message.graphType!,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: ChatSpacing.bubbleMetadataGap),

        // NEW - Enhanced action bar with better spacing
        _buildActionBar(context),

        // Action type indicator (existing, but repositioned)
        if (widget.message.actionType != null &&
            _isFinancialAction(widget.message.actionType!))
          Padding(
            padding: const EdgeInsets.only(top: ChatSpacing.bubbleMetadataGap),
            child: _buildActionTypeChip(context),
          ),
      ],
    ),
  );
}

// NEW - Bot header component
Widget _buildBotHeader(BuildContext context) {
  return Row(
    children: [
      // Bot avatar with gradient background
      Container(
        width: ChatSpacing.botAvatarSize,
        height: ChatSpacing.botAvatarSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.botColor,
              widget.botColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.botColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.auto_awesome,
          color: Colors.white,
          size: 16,
        ),
      ),

      const SizedBox(width: ChatSpacing.bubbleIconGap),

      // Bot name
      Text(
        widget.botName,
        style: TextStyle(
          fontSize: ChatTypography.botNameSize,
          fontWeight: ChatTypography.semiBold,
          color: GeminiColors.aiMessageText(context),
        ),
      ),

      const Spacer(),

      // NEW - Timestamp for AI message (subtle)
      Text(
        _formatTimestamp(widget.message.timestamp),
        style: TextStyle(
          fontSize: ChatTypography.timestampSize,
          color: GeminiColors.textSecondary(context),
          fontWeight: ChatTypography.regular,
        ),
      ),
    ],
  );
}

// NEW - Enhanced action bar
Widget _buildActionBar(BuildContext context) {
  return Row(
    children: [
      // Like button
      if (ChatConfig.showFeedbackButtons)
        _buildActionButton(
          context,
          icon: widget.message.feedback == 'LIKE'
            ? Icons.thumb_up
            : Icons.thumb_up_outlined,
          isActive: widget.message.feedback == 'LIKE',
          activeColor: GeminiColors.primaryColor(context),
          onPressed: () => _handleLikeFeedback(context),
        ),

      if (ChatConfig.showFeedbackButtons)
        const SizedBox(width: 8),

      // Dislike button
      if (ChatConfig.showFeedbackButtons)
        _buildActionButton(
          context,
          icon: widget.message.feedback == 'DISLIKE'
            ? Icons.thumb_down
            : Icons.thumb_down_outlined,
          isActive: widget.message.feedback == 'DISLIKE',
          activeColor: Colors.red,
          onPressed: () => _handleDislikeFeedback(context),
        ),

      const SizedBox(width: 8),

      // Copy button
      if (ChatConfig.showCopyButton)
        _buildActionButton(
          context,
          icon: Icons.content_copy_outlined,
          onPressed: () => _handleCopy(context),
          tooltip: 'Copy',
        ),

      const SizedBox(width: 8),

      // Regenerate button
      if (ChatConfig.showRegenerateButton)
        _buildActionButton(
          context,
          icon: Icons.refresh,
          onPressed: () => _handleRegenerate(context),
          tooltip: 'Regenerate',
        ),

      const Spacer(),

      // NEW - More options menu
      _buildActionButton(
        context,
        icon: Icons.more_horiz,
        onPressed: () => _showMoreOptions(context),
        tooltip: 'More options',
      ),
    ],
  );
}

// NEW - Reusable action button
Widget _buildActionButton(
  BuildContext context, {
  required IconData icon,
  required VoidCallback onPressed,
  bool isActive = false,
  Color? activeColor,
  String? tooltip,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final buttonColor = isActive && activeColor != null
      ? activeColor
      : GeminiColors.icon(context);

  final button = Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(ChatShapes.buttonRadius),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor?.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ChatShapes.buttonRadius),
        ),
        child: Icon(
          icon,
          size: ChatSpacing.actionIconSize,
          color: buttonColor,
        ),
      ),
    ),
  );

  return tooltip != null
      ? Tooltip(message: tooltip, child: button)
      : button;
}
```

**Glassmorphism Implementation Note:**
To achieve proper glassmorphism (frosted glass effect), you can use the `BackdropFilter` widget:

```dart
// Advanced glassmorphism (optional, performance cost)
ClipRRect(
  borderRadius: BorderRadius.circular(ChatShapes.aiBubbleRadius),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      padding: const EdgeInsets.all(ChatSpacing.bubbleContentPadding),
      decoration: BoxDecoration(
        color: isDark
            ? GeminiColors.glassFrostDark.withOpacity(0.5)
            : GeminiColors.glassFrostLight.withOpacity(0.7),
        borderRadius: BorderRadius.circular(ChatShapes.aiBubbleRadius),
        border: Border.all(
          color: isDark
              ? GeminiColors.glassBorderDark.withOpacity(0.3)
              : GeminiColors.glassBorderLight.withOpacity(0.5),
          width: ChatShapes.thinBorder,
        ),
      ),
      child: /* content */,
    ),
  ),
)
```

**Performance Note:** Use `BackdropFilter` sparingly. For low-end devices, fallback to the simple opacity-based approach shown first.

**Key Changes:**
- Glassmorphic bubble background
- Bot header with avatar and name
- Timestamp moved to header
- Enhanced action bar with tooltips
- More options menu for future extensibility

**Priority:** P0 - High Priority
**Implementation Time:** 1 day
**Impact:** High - Significant visual modernization

### 2.3 Enhanced Markdown Rendering Style

```dart
MarkdownStyleSheet _getEnhancedMarkdownStyle(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return MarkdownStyleSheet(
    // Paragraphs - enhanced readability
    p: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: GeminiColors.aiMessageText(context),
      fontSize: ChatTypography.messageFontSize,
      height: ChatTypography.messageLineHeight,
      letterSpacing: 0.2, // NEW - Better letter spacing
    ),

    // Headings - better hierarchy
    h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: GeminiColors.aiMessageText(context),
      fontWeight: ChatTypography.bold,
      height: 1.2,
      letterSpacing: -0.5, // NEW - Tighter for headings
    ),

    h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: GeminiColors.aiMessageText(context),
      fontWeight: ChatTypography.bold,
      height: 1.3,
      letterSpacing: -0.3,
    ),

    h3: Theme.of(context).textTheme.titleLarge?.copyWith(
      color: GeminiColors.aiMessageText(context),
      fontWeight: ChatTypography.semiBold,
      height: 1.4,
    ),

    // Code blocks - enhanced design
    code: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontFamily: 'JetBrains Mono', // Better monospace font
      backgroundColor: isDark
        ? const Color(0xFF1e1f20)
        : const Color(0xFFf5f5f5),
      color: GeminiColors.aiMessageText(context),
      fontSize: 13,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),

    codeblockDecoration: BoxDecoration(
      color: isDark
        ? const Color(0xFF1e1f20)
        : const Color(0xFFf5f5f5),
      borderRadius: BorderRadius.circular(12), // Increased from 8
      border: Border.all(
        color: GeminiColors.divider(context).withOpacity(0.5),
        width: 1,
      ),
    ),

    // Blockquotes - more prominent
    blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: GeminiColors.textSecondary(context),
      fontStyle: FontStyle.italic,
      fontSize: 15,
    ),

    blockquoteDecoration: BoxDecoration(
      color: GeminiColors.primaryColor(context).withOpacity(0.05), // NEW - Background
      border: Border(
        left: BorderSide(
          color: GeminiColors.primaryColor(context),
          width: 3, // Reduced from 4
        ),
      ),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
    ),

    // Lists - better spacing
    listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: GeminiColors.primaryColor(context), // Accent color for bullets
      fontWeight: ChatTypography.bold,
    ),

    // Tables - enhanced design
    tableHead: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: ChatTypography.bold,
      color: GeminiColors.aiMessageText(context),
      fontSize: 14,
    ),

    tableBody: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: GeminiColors.aiMessageText(context),
      fontSize: 14,
    ),

    // Links - more prominent
    a: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: GeminiColors.primaryColor(context),
      decoration: TextDecoration.underline,
      decorationColor: GeminiColors.primaryColor(context).withOpacity(0.4),
      fontWeight: ChatTypography.medium,
    ),

    // Emphasis
    em: const TextStyle(fontStyle: FontStyle.italic),
    strong: TextStyle(
      fontWeight: ChatTypography.bold,
      color: GeminiColors.aiMessageText(context),
    ),

    // Horizontal rules
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: GeminiColors.divider(context),
          width: 1.5, // Slightly thicker
        ),
      ),
    ),
  );
}
```

**Priority:** P1 - Medium Priority
**Implementation Time:** 3-4 hours
**Impact:** Medium - Better text hierarchy and readability

---

## 3. Input Field Improvements

### 3.1 Enhanced Floating Pill Design

**Current Implementation:**
- Floating pill-shaped input at bottom
- Draggable horizontally and vertically
- Attachment, text input, voice recording, send button
- Token limit warnings

**2025 Redesign Recommendations:**

**Option A: Enhanced Floating Pill (Recommended)**

```dart
@override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final primaryColor = Theme.of(context).colorScheme.primary;
  final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  return BlocBuilder<ChatCubit, ChatState>(
    builder: (context, state) {
      bool isLimitReached = false;
      bool isNearLimit = false;

      if (state is ChatLoaded) {
        isLimitReached = state.isTokenLimitReached;
        isNearLimit = state.currentTokenUsage > (state.dailyTokenLimit * 0.9);
      }

      return Container(
        constraints: const BoxConstraints(maxWidth: 600), // Wider for tablets
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // NEW - Minimize/expand button
            if (!_isCollapsed)
              _buildMinimizeButton(context),

            // Token warning banner (existing, enhanced)
            if (!_isCollapsed && isLimitReached)
              _buildTokenWarning(context, isError: true),
            else if (!_isCollapsed && isNearLimit)
              _buildTokenWarning(context, isError: false),

            // Attachment preview (existing, enhanced)
            if (!_isCollapsed && _selectedImagePath != null)
              _buildAttachmentPreview(context),

            // Main input container
            _isCollapsed
                ? _buildCollapsedState(context)
                : _buildExpandedInput(context, primaryColor, isDark, isLimitReached),
          ],
        ),
      );
    },
  );
}

// NEW - Enhanced expanded input
Widget _buildExpandedInput(
  BuildContext context,
  Color primaryColor,
  bool isDark,
  bool isLimitReached,
) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      // NEW - Glassmorphic background
      color: isDark
          ? GeminiColors.glassFrostDark.withOpacity(0.95)
          : GeminiColors.glassFrostLight.withOpacity(0.98),
      borderRadius: BorderRadius.circular(ChatShapes.inputRadius),
      border: Border.all(
        color: _textController.text.isNotEmpty
            ? primaryColor.withOpacity(0.4) // Active state
            : (isDark
                ? GeminiColors.glassBorderDark.withOpacity(0.2)
                : GeminiColors.glassBorderLight.withOpacity(0.3)),
        width: ChatShapes.mediumBorder,
      ),
      // NEW - Enhanced shadow with glow effect when focused
      boxShadow: [
        BoxShadow(
          color: _textController.text.isNotEmpty
              ? primaryColor.withOpacity(0.25)
              : Colors.black.withOpacity(isDark ? 0.3 : 0.1),
          blurRadius: _textController.text.isNotEmpty ? 20 : 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Attachment button
        if (ChatConfig.showAttachments)
          _buildInputIconButton(
            context,
            icon: Icons.add_rounded,
            onPressed: isLimitReached ? null : _showAttachmentOptions,
            isActive: _selectedImagePath != null,
            color: primaryColor,
          ),

        if (ChatConfig.showAttachments)
          const SizedBox(width: ChatSpacing.inputComponentGap),

        // Text field
        Expanded(
          child: TextField(
            controller: _textController,
            enabled: !isLimitReached,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              hintText: isLimitReached
                  ? 'Daily limit reached'
                  : 'Ask me anything...',
              hintStyle: TextStyle(
                color: isLimitReached
                    ? Colors.grey
                    : GeminiColors.textSecondary(context),
                fontSize: 15,
                fontWeight: ChatTypography.regular,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: isLimitReached
                  ? Colors.grey
                  : GeminiColors.aiMessageText(context),
            ),
          ),
        ),

        const SizedBox(width: ChatSpacing.inputComponentGap),

        // Voice recording button
        if (ChatConfig.showAudioRecording)
          _buildInputIconButton(
            context,
            icon: _isRecording ? Icons.stop_rounded : Icons.mic_none_rounded,
            onPressed: isLimitReached ? null : _toggleRecording,
            isActive: _isRecording,
            color: _isRecording ? Colors.red : primaryColor,
          ),

        if (ChatConfig.showAudioRecording)
          const SizedBox(width: 8),

        // Send button
        _buildSendButton(context, primaryColor, isLimitReached),
      ],
    ),
  );
}

// NEW - Enhanced send button with animation
Widget _buildSendButton(
  BuildContext context,
  Color primaryColor,
  bool isLimitReached,
) {
  final hasContent = _hasContent;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      gradient: (hasContent && !isLimitReached)
          ? LinearGradient(
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: (hasContent && !isLimitReached)
          ? null
          : GeminiColors.divider(context),
      shape: BoxShape.circle,
      boxShadow: (hasContent && !isLimitReached)
          ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (hasContent && !isLimitReached) ? _sendMessage : null,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              hasContent ? Icons.arrow_upward_rounded : Icons.arrow_upward_rounded,
              key: ValueKey(hasContent),
              color: (hasContent && !isLimitReached)
                  ? Colors.white
                  : GeminiColors.textSecondary(context),
              size: 22,
            ),
          ),
        ),
      ),
    ),
  );
}

// NEW - Reusable input icon button
Widget _buildInputIconButton(
  BuildContext context, {
  required IconData icon,
  required VoidCallback? onPressed,
  bool isActive = false,
  required Color color,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive
              ? color.withOpacity(0.15)
              : color.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onPressed == null ? Colors.grey : color,
          size: 20,
        ),
      ),
    ),
  );
}

// NEW - Enhanced minimize button
Widget _buildMinimizeButton(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(right: 12, bottom: 8),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleCollapse,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: GeminiColors.divider(context).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: GeminiColors.icon(context),
            size: 20,
          ),
        ),
      ),
    ),
  );
}

// NEW - Enhanced token warning
Widget _buildTokenWarning(BuildContext context, {required bool isError}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isError
            ? [Colors.red.shade400, Colors.red.shade600]
            : [Colors.orange.shade400, Colors.orange.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: (isError ? Colors.red : Colors.orange).withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isError ? Icons.error_outline_rounded : Icons.warning_amber_rounded,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            isError
                ? 'Daily limit reached. Upgrade to continue.'
                : 'Approaching daily limit',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: ChatTypography.semiBold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}

// NEW - Enhanced attachment preview
Widget _buildAttachmentPreview(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final primaryColor = Theme.of(context).colorScheme.primary;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isDark
          ? GeminiColors.glassFrostDark.withOpacity(0.9)
          : GeminiColors.glassFrostLight.withOpacity(0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: primaryColor.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Image thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: GeminiColors.divider(context),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.file(
              File(_selectedImagePath!),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // File info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Image attached',
                style: TextStyle(
                  color: GeminiColors.aiMessageText(context),
                  fontSize: 14,
                  fontWeight: ChatTypography.semiBold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to view',
                style: TextStyle(
                  color: GeminiColors.textSecondary(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Remove button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedImagePath = null;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close_rounded,
                color: GeminiColors.icon(context),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
```

**Key Improvements:**
- Glassmorphic background with blur effect
- Active state border glow
- Enhanced token warnings with gradients
- Better attachment preview design
- Animated send button
- Improved icon buttons with better touch targets

**Priority:** P0 - High Priority
**Implementation Time:** 1 day
**Impact:** High - Core interaction modernization

### 3.2 Voice Recording Visual Feedback

**Enhanced Recording State:**

```dart
// NEW - Recording indicator overlay
Widget _buildRecordingIndicator(BuildContext context) {
  return AnimatedOpacity(
    opacity: _isRecording ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 200),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade400,
            Colors.red.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pulsing record icon
          _buildPulsingIcon(),

          const SizedBox(width: 12),

          // Recording duration
          StreamBuilder<Duration>(
            stream: _recordingDurationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return Text(
                _formatDuration(duration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: ChatTypography.semiBold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              );
            },
          ),

          const Spacer(),

          // Waveform visualization (optional)
          _buildMiniWaveform(),

          const SizedBox(width: 12),

          // Cancel button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _cancelRecording,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// NEW - Pulsing record icon
Widget _buildPulsingIcon() {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeInOut,
    builder: (context, value, child) {
      return Transform.scale(
        scale: 1.0 + (value * 0.2),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(value * 0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    },
    onEnd: () {
      // Loop animation
      setState(() {});
    },
  );
}

// NEW - Mini waveform (simplified)
Widget _buildMiniWaveform() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: _buildWaveformBar(index),
      );
    }),
  );
}

Widget _buildWaveformBar(int index) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.3, end: 1.0),
    duration: Duration(milliseconds: 300 + (index * 50)),
    curve: Curves.easeInOut,
    builder: (context, value, child) {
      return Container(
        width: 3,
        height: 16 * value,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(2),
        ),
      );
    },
    onEnd: () {
      setState(() {});
    },
  );
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
```

**Priority:** P1 - Medium Priority
**Implementation Time:** 4-5 hours
**Impact:** Medium - Enhanced audio recording UX

---

## 4. Empty State Enhancement

### 4.1 More Engaging Welcome Screen

**Current Implementation:**
- Centered sparkle icon
- "How can I help you today?" text
- Suggested prompt chips in a wrap

**2025 Redesign:**

```dart
class SuggestedPrompts extends StatelessWidget {
  final String botId;
  final Function(String) onPromptSelected;

  const SuggestedPrompts({
    super.key,
    required this.botId,
    required this.onPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    final prompts = _getPromptsForBot(botId);
    final botConfig = _getBotConfig(botId);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatSpacing.pageHorizontal,
        vertical: ChatSpacing.sectionGap,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // NEW - Animated bot avatar with gradient
          _buildAnimatedBotAvatar(context, botConfig),

          const SizedBox(height: 24),

          // NEW - Bot name
          Text(
            botConfig.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: ChatTypography.bold,
              color: GeminiColors.aiMessageText(context),
            ),
          ),

          const SizedBox(height: 12),

          // Welcome text with bot personality
          Text(
            botConfig.welcomeMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: GeminiColors.textSecondary(context),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // NEW - Feature highlights (optional)
          if (botConfig.features.isNotEmpty)
            _buildFeatureHighlights(context, botConfig.features),

          const SizedBox(height: 24),

          // Suggested prompts header
          Text(
            'Try asking:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: GeminiColors.textSecondary(context),
              fontWeight: ChatTypography.semiBold,
            ),
          ),

          const SizedBox(height: 16),

          // Enhanced prompt chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: prompts
                .map((prompt) => _buildEnhancedPromptChip(context, prompt))
                .toList(),
          ),

          const SizedBox(height: 40),

          // NEW - Onboarding hint
          _buildOnboardingHint(context),
        ],
      ),
    );
  }

  // NEW - Animated bot avatar
  Widget _buildAnimatedBotAvatar(BuildContext context, BotConfig config) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    config.color,
                    config.color.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: config.color.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                config.icon,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  // NEW - Feature highlights
  Widget _buildFeatureHighlights(BuildContext context, List<String> features) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GeminiColors.primaryColor(context).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GeminiColors.primaryColor(context).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: features.take(3).map((feature) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: GeminiColors.primaryColor(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GeminiColors.aiMessageText(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // NEW - Enhanced prompt chip
  Widget _buildEnhancedPromptChip(BuildContext context, PromptChip chip) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPromptSelected(chip.prompt),
        borderRadius: BorderRadius.circular(ChatShapes.chipRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      GeminiColors.chipBgDark.withOpacity(0.3),
                      GeminiColors.chipBgDark.withOpacity(0.2),
                    ]
                  : [
                      GeminiColors.chipBgLight.withOpacity(0.5),
                      GeminiColors.chipBgLight.withOpacity(0.3),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ChatShapes.chipRadius),
            border: Border.all(
              color: GeminiColors.chipBorder(context).withOpacity(0.3),
              width: ChatShapes.thinBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: GeminiColors.primaryColor(context).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: GeminiColors.primaryColor(context).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  chip.icon,
                  size: ChatTypography.promptIconSize,
                  color: GeminiColors.primaryColor(context),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                chip.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ChatTypography.promptLabelSize,
                  fontWeight: ChatTypography.semiBold,
                  color: GeminiColors.aiMessageText(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW - Onboarding hint
  Widget _buildOnboardingHint(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GeminiColors.divider(context).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: GeminiColors.textSecondary(context),
          ),
          const SizedBox(width: 8),
          Text(
            'You can also use voice or images to chat',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: GeminiColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Bot configuration helper
  BotConfig _getBotConfig(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return BotConfig(
          name: 'Balance Tracker',
          welcomeMessage: 'I help you track expenses and manage your daily finances effortlessly.',
          icon: Icons.account_balance_wallet,
          color: AppTheme.balanceTrackerColor,
          features: [
            'Track expenses with voice or text',
            'View spending summaries',
            'Monitor account balances',
          ],
        );
      case AppConstants.investmentGuruID:
        return BotConfig(
          name: 'Investment Guru',
          welcomeMessage: 'Get personalized investment advice and market insights.',
          icon: Icons.trending_up,
          color: AppTheme.investmentGuruColor,
          features: [
            'Investment recommendations',
            'Portfolio analysis',
            'Market trend insights',
          ],
        );
      case AppConstants.budgetPlannerID:
        return BotConfig(
          name: 'Budget Planner',
          welcomeMessage: 'Create budgets and achieve your financial goals.',
          icon: Icons.receipt_long,
          color: AppTheme.budgetPlannerColor,
          features: [
            'Monthly budget planning',
            'Category-wise tracking',
            'Savings goals',
          ],
        );
      case AppConstants.finTipsID:
        return BotConfig(
          name: 'Fin Tips',
          welcomeMessage: 'Learn financial concepts and money management tips.',
          icon: Icons.lightbulb,
          color: AppTheme.finTipsColor,
          features: [
            'Financial education',
            'Money management tips',
            'Best practices',
          ],
        );
      default:
        return BotConfig(
          name: 'Financial Assistant',
          welcomeMessage: 'How can I help you today?',
          icon: Icons.auto_awesome,
          color: GeminiColors.primary,
          features: [],
        );
    }
  }
}

// NEW - Bot configuration class
class BotConfig {
  final String name;
  final String welcomeMessage;
  final IconData icon;
  final Color color;
  final List<String> features;

  BotConfig({
    required this.name,
    required this.welcomeMessage,
    required this.icon,
    required this.color,
    required this.features,
  });
}
```

**Key Improvements:**
- Animated bot avatar with personality
- Bot-specific welcome messages
- Feature highlights
- Enhanced prompt chips with icons in containers
- Onboarding hint for multimodal input

**Priority:** P1 - Medium Priority
**Implementation Time:** 5-6 hours
**Impact:** Medium - Better first impression and onboarding

---

## 5. Interaction Patterns

### 5.1 Gesture-Based Interactions

**Swipe to Delete/Archive Messages:**

```dart
// NEW - Swipeable message wrapper
Widget _buildSwipeableMessage(BuildContext context, Message message) {
  return Dismissible(
    key: ValueKey(message.id),
    direction: DismissDirection.endToStart,
    confirmDismiss: (direction) async {
      return await _showDeleteConfirmation(context);
    },
    onDismissed: (direction) {
      context.read<ChatCubit>().deleteMessage(message.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              context.read<ChatCubit>().undoDelete(message);
            },
          ),
        ),
      );
    },
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade400,
            Colors.red.shade600,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(ChatShapes.aiBubbleRadius),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 24,
      ),
    ),
    child: MessageBubble(
      message: message,
      isUser: message.sender == 'user',
      botName: widget.botName,
      botColor: widget.botColor,
    ),
  );
}

Future<bool?> _showDeleteConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ChatShapes.modalRadius),
        ),
        title: const Text('Delete message?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
```

**Long Press for Quick Actions:**

```dart
// NEW - Long press wrapper
Widget _buildLongPressMessage(BuildContext context, Message message) {
  return GestureDetector(
    onLongPress: () => _showQuickActions(context, message),
    child: MessageBubble(
      message: message,
      isUser: message.sender == 'user',
      botName: widget.botName,
      botColor: widget.botColor,
    ),
  );
}

void _showQuickActions(BuildContext context, Message message) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: GeminiColors.surface(context),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ChatShapes.modalRadius),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: GeminiColors.divider(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Quick actions
              _buildQuickAction(
                context,
                icon: Icons.content_copy,
                label: 'Copy',
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: message.content));
                  _showSnackbar(context, 'Copied to clipboard');
                },
              ),

              _buildQuickAction(
                context,
                icon: Icons.share,
                label: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),

              if (!message.isUser)
                _buildQuickAction(
                  context,
                  icon: Icons.refresh,
                  label: 'Regenerate',
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ChatCubit>().regenerateMessage(message.id);
                  },
                ),

              _buildQuickAction(
                context,
                icon: Icons.delete_outline,
                label: 'Delete',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  context.read<ChatCubit>().deleteMessage(message.id);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildQuickAction(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color? color,
}) {
  final actionColor = color ?? GeminiColors.aiMessageText(context);

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: actionColor, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: actionColor,
                fontWeight: ChatTypography.medium,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

**Priority:** P2 - Lower Priority
**Implementation Time:** 6-8 hours
**Impact:** Medium - Enhanced power user experience

### 5.2 Haptic Feedback

```dart
// Add haptic feedback to interactions
import 'package:flutter/services.dart';

void _triggerHaptic(HapticFeedbackType type) {
  switch (type) {
    case HapticFeedbackType.light:
      HapticFeedback.lightImpact();
      break;
    case HapticFeedbackType.medium:
      HapticFeedback.mediumImpact();
      break;
    case HapticFeedbackType.heavy:
      HapticFeedback.heavyImpact();
      break;
    case HapticFeedbackType.selection:
      HapticFeedback.selectionClick();
      break;
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

// Usage examples:
// - Light impact: Tapping prompt chips, like/dislike buttons
// - Medium impact: Sending messages, opening attachments
// - Heavy impact: Deleting messages, errors
// - Selection: Scrolling through lists, toggling options
```

---

## 6. Financial UI Components

### 6.1 Enhanced GenUI Metric Card

**Current Implementation:**
- Gradient background
- Border and shadow
- Icon, title, value, change indicator

**2025 Redesign:**

```dart
class GenUIMetricCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIMetricCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String;
    final value = data['value'] as String;
    final change = data['change'] as String?;
    final trend = data['trend'] as String?;
    final icon = data['icon'] as String?;
    final category = data['category'] as String?; // NEW - income/expense/neutral

    final categoryColor = _getCategoryColor(category, context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // NEW - Category-based gradient
        gradient: LinearGradient(
          colors: [
            categoryColor.withOpacity(isDark ? 0.15 : 0.08),
            categoryColor.withOpacity(isDark ? 0.08 : 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ChatSpacing.cardBorderRadius),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
          width: ChatShapes.mediumBorder,
        ),
        // NEW - Subtle glow effect
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ChatSpacing.cardBorderRadius),
        child: Stack(
          children: [
            // NEW - Decorative background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.03,
                child: Icon(
                  _getIconData(icon),
                  size: 120,
                  color: categoryColor,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(ChatSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (icon != null) ...[
                        _buildEnhancedIcon(icon, categoryColor, context),
                        const SizedBox(width: ChatSpacing.componentGap),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: GeminiColors.textSecondary(context),
                            fontWeight: ChatTypography.semiBold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (trend != null) _buildTrendIndicator(trend, context),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // NEW - Large value with tabular figures
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: ChatTypography.bold,
                      color: categoryColor,
                      fontSize: ChatTypography.financialNumberSize,
                      letterSpacing: ChatTypography.numberLetterSpacing,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),

                  if (change != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _getChangeIcon(change),
                          size: 14,
                          color: _getChangeColor(change, context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          change,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getChangeColor(change, context),
                            fontWeight: ChatTypography.semiBold,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'from last month',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: GeminiColors.textSecondary(context),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedIcon(String iconName, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        _getIconData(iconName),
        size: 28,
        color: color,
      ),
    );
  }

  Color _getCategoryColor(String? category, BuildContext context) {
    switch (category?.toLowerCase()) {
      case 'income':
        return AppTheme.incomeLight;
      case 'expense':
        return AppTheme.expenseLight;
      default:
        return GeminiColors.primaryColor(context);
    }
  }

  IconData _getChangeIcon(String change) {
    if (change.startsWith('+')) {
      return Icons.arrow_upward_rounded;
    } else if (change.startsWith('-')) {
      return Icons.arrow_downward_rounded;
    }
    return Icons.remove;
  }

  Color _getChangeColor(String change, BuildContext context) {
    if (change.startsWith('+')) {
      return AppTheme.incomeLight;
    } else if (change.startsWith('-')) {
      return AppTheme.expenseLight;
    }
    return GeminiColors.textSecondary(context);
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'attach_money':
        return Icons.attach_money_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Widget _buildTrendIndicator(String trend, BuildContext context) {
    IconData icon;
    Color color;

    switch (trend) {
      case 'up':
        icon = Icons.arrow_upward_rounded;
        color = AppTheme.incomeLight;
        break;
      case 'down':
        icon = Icons.arrow_downward_rounded;
        color = AppTheme.expenseLight;
        break;
      default:
        icon = Icons.remove;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
```

**Priority:** P1 - Medium Priority
**Implementation Time:** 3-4 hours
**Impact:** Medium - Better financial data presentation

### 6.2 Enhanced Chart Design

**Improvements for GenUIChart:**

```dart
// NEW - Chart title header
Widget _buildChartHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: GeminiColors.primaryColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.bar_chart_rounded,
            size: 20,
            color: GeminiColors.primaryColor(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Spending Breakdown',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: ChatTypography.bold,
                ),
              ),
              Text(
                'Last 7 days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GeminiColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        // NEW - Export/share button
        IconButton(
          icon: Icon(
            Icons.ios_share_rounded,
            size: 20,
            color: GeminiColors.icon(context),
          ),
          onPressed: () {
            // Export chart as image
          },
        ),
      ],
    ),
  );
}

// NEW - Enhanced chart container
Widget build(BuildContext context) {
  if (!data.isValid) return const SizedBox.shrink();

  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [
                GeminiColors.glassFrostDark.withOpacity(0.5),
                GeminiColors.glassFrostDark.withOpacity(0.3),
              ]
            : [
                GeminiColors.glassFrostLight.withOpacity(0.7),
                GeminiColors.glassFrostLight.withOpacity(0.5),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: GeminiColors.divider(context).withOpacity(0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartHeader(context),
        SizedBox(
          height: 220, // Increased from 200
          child: _buildChart(context),
        ),
        const SizedBox(height: 12),
        // NEW - Chart legend
        _buildChartLegend(context),
      ],
    ),
  );
}

// NEW - Chart legend
Widget _buildChartLegend(BuildContext context) {
  return Wrap(
    spacing: 16,
    runSpacing: 8,
    children: data.datasets.map((dataset) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: GeminiColors.primaryColor(context),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            dataset.label ?? 'Data',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: GeminiColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
        ],
      );
    }).toList(),
  );
}
```

**Priority:** P1 - Medium Priority
**Implementation Time:** 4-5 hours
**Impact:** Medium - More professional data visualization

---

## 7. Accessibility Enhancements

### 7.1 Touch Target Sizing

**Ensure all interactive elements meet 48x48dp minimum:**

```dart
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

// Usage:
AccessibleButton(
  semanticLabel: 'Like this message',
  onPressed: () => _handleLike(),
  child: Icon(Icons.thumb_up_outlined),
)
```

### 7.2 Screen Reader Optimization

**Enhanced Semantic Labels:**

```dart
Widget _buildMessageWithSemantics(BuildContext context, Message message) {
  return Semantics(
    label: message.isUser
        ? 'You said: ${message.content}'
        : '${widget.botName} said: ${message.content}',
    hint: message.isUser
        ? 'Your message sent at ${_formatTimestamp(message.timestamp)}'
        : 'Response from ${widget.botName} at ${_formatTimestamp(message.timestamp)}',
    excludeSemantics: true,
    child: MessageBubble(
      message: message,
      isUser: message.isUser,
      botName: widget.botName,
      botColor: widget.botColor,
    ),
  );
}

// Input field semantics
TextField(
  decoration: InputDecoration(
    hintText: 'Ask me anything...',
    semanticCounterText: isNearLimit
        ? 'You have $remainingTokens messages remaining today'
        : null,
  ),
)
```

### 7.3 Color Contrast Validation

**WCAG 2.2 AA Compliance:**

```dart
// Helper function to check contrast ratio
double _calculateContrastRatio(Color foreground, Color background) {
  final fgLuminance = foreground.computeLuminance();
  final bgLuminance = background.computeLuminance();

  final lighter = max(fgLuminance, bgLuminance);
  final darker = min(fgLuminance, bgLuminance);

  return (lighter + 0.05) / (darker + 0.05);
}

// Validate color pairs (should be >= 4.5 for normal text, >= 3.0 for large text)
void _validateColorContrast() {
  final textOnPrimary = _calculateContrastRatio(
    Colors.white,
    GeminiColors.primaryLight,
  );

  assert(textOnPrimary >= 4.5, 'Text on primary color must have 4.5:1 contrast ratio');

  // ... validate all color combinations
}
```

### 7.4 Focus Indicators

```dart
// Enhanced focus indicator for keyboard navigation
Widget _buildFocusableButton(BuildContext context) {
  return Focus(
    onFocusChange: (hasFocus) {
      setState(() {
        _isFocused = hasFocus;
      });
    },
    child: Container(
      decoration: BoxDecoration(
        border: _isFocused
            ? Border.all(
                color: GeminiColors.primaryColor(context),
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(ChatShapes.buttonRadius),
      ),
      child: /* button content */,
    ),
  );
}
```

**Priority:** P0 - High Priority (Accessibility is critical)
**Implementation Time:** 1 day
**Impact:** High - Legal compliance and inclusive design

---

## 8. Animation & Motion

### 8.1 Entry/Exit Animations for Messages

**Enhanced Message Entry:**

```dart
class AnimatedMessageBubble extends StatefulWidget {
  final Message message;
  final bool isUser;
  final String botName;
  final Color botColor;
  final int index; // For staggered animation

  const AnimatedMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.botName,
    required this.botColor,
    this.index = 0,
  });

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Staggered delay based on index
    final delay = widget.index * 50; // 50ms between each message

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.easeOut,
        ),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.isUser
          ? const Offset(0.3, 0) // Slide from right for user
          : const Offset(-0.3, 0), // Slide from left for AI
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.8,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // Start animation with delay
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MessageBubble(
            message: widget.message,
            isUser: widget.isUser,
            botName: widget.botName,
            botColor: widget.botColor,
          ),
        ),
      ),
    );
  }
}
```

### 8.2 Typing Indicator Enhancement

```dart
class TypingIndicator extends StatefulWidget {
  final Color color;

  const TypingIndicator({
    super.key,
    required this.color,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -8 * _animations[index].value),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(
                        0.3 + (0.7 * _animations[index].value),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
```

### 8.3 Success/Error Feedback Animations

```dart
// Success checkmark animation
class SuccessCheckmark extends StatefulWidget {
  const SuccessCheckmark({super.key});

  @override
  State<SuccessCheckmark> createState() => _SuccessCheckmarkState();
}

class _SuccessCheckmarkState extends State<SuccessCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.incomeLight,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.incomeLight.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _checkAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: CheckmarkPainter(
                progress: _checkAnimation.value,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Checkmark path
    path.moveTo(w * 0.25, h * 0.5);
    path.lineTo(w * 0.45, h * 0.7);
    path.lineTo(w * 0.75, h * 0.3);

    final pathMetric = path.computeMetrics().first;
    final extractPath = pathMetric.extractPath(
      0,
      pathMetric.length * progress,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

**Priority:** P1 - Medium Priority
**Implementation Time:** 1 day
**Impact:** Medium - Delightful user experience

---

## 9. Responsive Design

### 9.1 Breakpoint System

```dart
class ChatResponsive {
  // Breakpoints
  static const double mobileSmall = 320;
  static const double mobileLarge = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double desktopWide = 1440;

  // Get device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileLarge) return DeviceType.mobileSmall;
    if (width < tablet) return DeviceType.mobileLarge;
    if (width < desktop) return DeviceType.tablet;
    if (width < desktopWide) return DeviceType.desktop;
    return DeviceType.desktopWide;
  }

  // Responsive value selector
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobileSmall:
      case DeviceType.mobileLarge:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
      case DeviceType.desktopWide:
        return desktop ?? tablet ?? mobile;
    }
  }
}

enum DeviceType {
  mobileSmall,
  mobileLarge,
  tablet,
  desktop,
  desktopWide,
}

// Usage example:
Widget build(BuildContext context) {
  final horizontalPadding = ChatResponsive.value<double>(
    context: context,
    mobile: 16,
    tablet: 24,
    desktop: 32,
  );

  final maxWidth = ChatResponsive.value<double>(
    context: context,
    mobile: double.infinity,
    tablet: 600,
    desktop: 800,
  );

  return Container(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    constraints: BoxConstraints(maxWidth: maxWidth),
    child: /* content */,
  );
}
```

### 9.2 Adaptive Layout

```dart
class AdaptiveChatLayout extends StatelessWidget {
  final List<Message> messages;
  final String botId;
  final String botName;

  const AdaptiveChatLayout({
    super.key,
    required this.messages,
    required this.botId,
    required this.botName,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ChatResponsive.getDeviceType(context);

    return switch (deviceType) {
      DeviceType.mobileSmall || DeviceType.mobileLarge =>
        _buildMobileLayout(context),
      DeviceType.tablet =>
        _buildTabletLayout(context),
      DeviceType.desktop || DeviceType.desktopWide =>
        _buildDesktopLayout(context),
    };
  }

  Widget _buildMobileLayout(BuildContext context) {
    // Current implementation - single column
    return MessageList(
      messages: messages,
      botId: botId,
      botName: botName,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    // Centered with max width
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: MessageList(
          messages: messages,
          botId: botId,
          botName: botName,
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    // Two-column layout with chat history sidebar (future)
    return Row(
      children: [
        // Sidebar (future implementation)
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: GeminiColors.divider(context),
                width: 1,
              ),
            ),
          ),
          child: const ChatHistorySidebar(),
        ),

        // Main chat area
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: MessageList(
                messages: messages,
                botId: botId,
                botName: botName,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

**Priority:** P2 - Lower Priority
**Implementation Time:** 1-2 days
**Impact:** Low (primarily mobile app, but good for future web version)

---

## 10. Implementation Roadmap

### Phase 1: Quick Wins (1-2 days)

**Priority: P0-P1 | High Impact, Low Effort**

1. **Color System Enhancement** (3 hours)
   - Add glassmorphism colors
   - Add semantic financial colors
   - Update GeminiColors class

2. **Typography Refinements** (2 hours)
   - Add tabular figures for numbers
   - Update ChatTypography constants
   - Apply to financial components

3. **User Message Bubble Updates** (2 hours)
   - Add gradient background
   - Inline timestamp
   - Delivery status indicator

4. **Input Field Glow Effect** (2 hours)
   - Active state border
   - Enhanced shadow on focus

5. **Accessibility - Touch Targets** (3 hours)
   - Ensure 48x48dp minimum
   - Add AccessibleButton wrapper
   - Update all action buttons

**Total Time:** 12 hours (1.5 days)

### Phase 2: Core Redesign (3-5 days)

**Priority: P0 | High Impact, Medium Effort**

1. **AI Message Bubble Glassmorphism** (1 day)
   - Glassmorphic container
   - Bot header with avatar
   - Enhanced action bar
   - More options menu

2. **Enhanced Floating Input** (1 day)
   - Glassmorphic background
   - Enhanced token warnings
   - Better attachment preview
   - Animated send button

3. **Accessibility Compliance** (1 day)
   - Screen reader optimization
   - Color contrast validation
   - Focus indicators
   - ARIA labels

4. **Markdown Style Enhancement** (4 hours)
   - Better typography
   - Enhanced code blocks
   - Improved blockquotes
   - Link styling

5. **Empty State Redesign** (5 hours)
   - Animated bot avatar
   - Feature highlights
   - Enhanced prompt chips
   - Onboarding hint

**Total Time:** 3.5 days

### Phase 3: Enhanced Components (5-7 days)

**Priority: P1 | Medium Impact, Medium Effort**

1. **GenUI Metric Card Redesign** (4 hours)
   - Category-based gradients
   - Enhanced icons
   - Better change indicators

2. **GenUI Chart Enhancement** (5 hours)
   - Chart headers
   - Legends
   - Export functionality
   - Better container design

3. **Voice Recording Feedback** (5 hours)
   - Recording indicator overlay
   - Pulsing icon
   - Waveform visualization
   - Duration display

4. **Message Entry Animations** (1 day)
   - Staggered entry
   - Slide and fade
   - Scale animation

5. **Typing Indicator Enhancement** (3 hours)
   - Better animation
   - Staggered dots
   - Color theming

**Total Time:** 2.5 days

### Phase 4: Advanced Interactions (1-2 weeks)

**Priority: P2 | Medium Impact, High Effort**

1. **Gesture Interactions** (1-2 days)
   - Swipe to delete
   - Long press menu
   - Pull to refresh

2. **Haptic Feedback** (4 hours)
   - Light/medium/heavy impacts
   - Selection clicks
   - Integration across UI

3. **Success/Error Animations** (1 day)
   - Checkmark animation
   - Error shake
   - Custom painters

4. **Responsive Layout** (2 days)
   - Breakpoint system
   - Adaptive layouts
   - Tablet optimization
   - Desktop sidebar

**Total Time:** 4-5 days

---

## Performance Considerations

### Bangladesh Market Optimization

**Low-End Device Support:**

1. **Conditional Glassmorphism**
   ```dart
   // Check device capability
   bool get supportsBackdropFilter {
     return Platform.isIOS ||
            (Platform.isAndroid && _androidVersion >= 12);
   }

   // Fallback for low-end devices
   Widget _buildMessageContainer(BuildContext context) {
     if (supportsBackdropFilter && !ChatConfig.reducedMotion) {
       return _buildGlassmorphicContainer(context);
     } else {
       return _buildSolidContainer(context);
     }
   }
   ```

2. **Animation Throttling**
   ```dart
   // Respect reduce motion preference
   Duration get animationDuration {
     if (ChatConfig.reducedMotion) {
       return Duration.zero;
     }
     return const Duration(milliseconds: 300);
   }
   ```

3. **Image Optimization**
   ```dart
   // Compress images before sending
   Future<File> _compressImage(File file) async {
     final result = await FlutterImageCompress.compressWithFile(
       file.absolute.path,
       quality: 70, // Lower for Bangladesh market
       minWidth: 800,
       minHeight: 800,
     );
     return File(result!.path);
   }
   ```

4. **Lazy Loading for GenUI**
   ```dart
   // Only build charts when visible
   Widget _buildChart(BuildContext context) {
     return VisibilityDetector(
       key: Key('chart-${message.id}'),
       onVisibilityChanged: (info) {
         if (info.visibleFraction > 0.5) {
           setState(() {
             _shouldBuildChart = true;
           });
         }
       },
       child: _shouldBuildChart
           ? GenUIChart(data: data, type: type)
           : Container(height: 200, color: Colors.grey.shade200),
     );
   }
   ```

---

## Bangla Language Support Readiness

### Typography Adjustments

```dart
// Bangla font support
TextStyle getBanglaMessageStyle(BuildContext context) {
  return TextStyle(
    fontFamily: 'Noto Sans Bengali', // Add to pubspec.yaml
    fontSize: ChatTypography.messageFontSize + 1, // Slightly larger
    height: 1.6, // More line height for Bangla script
    color: GeminiColors.aiMessageText(context),
  );
}

// Auto-detect language
TextStyle getMessageStyle(BuildContext context, String text) {
  if (_isBanglaText(text)) {
    return getBanglaMessageStyle(context);
  }
  return getEnglishMessageStyle(context);
}

bool _isBanglaText(String text) {
  // Check for Bangla Unicode range
  return RegExp(r'[\u0980-\u09FF]').hasMatch(text);
}
```

### RTL Layout Support

```dart
// Support for mixed LTR/RTL content
Widget _buildMessage(BuildContext context) {
  return Directionality(
    textDirection: _getTextDirection(message.content),
    child: MessageBubble(message: message),
  );
}

TextDirection _getTextDirection(String text) {
  if (_isBanglaText(text)) {
    return TextDirection.ltr; // Bangla is LTR
  }
  return TextDirection.ltr;
}
```

---

## Summary

This comprehensive redesign specification provides a modern, accessible, and delightful chat experience for BalanceIQ users. The phased implementation approach allows for incremental improvements while maintaining app stability.

**Key Benefits:**
- Modern 2025 design trends (glassmorphism, gradients, animations)
- WCAG 2.2 AA accessibility compliance
- Bangladesh market optimization (low-end device support)
- Bangla language readiness
- Enhanced financial data visualization
- Delightful micro-interactions
- Performance-optimized implementation

**Estimated Total Implementation Time:**
- Phase 1 (Quick Wins): 1.5 days
- Phase 2 (Core Redesign): 3.5 days
- Phase 3 (Enhanced Components): 2.5 days
- Phase 4 (Advanced Interactions): 4-5 days

**Total: 12-14 days** for complete implementation

**Recommended Priority:**
1. Start with Phase 1 (quick wins) for immediate visual improvement
2. Implement Phase 2 (core redesign) for major modernization
3. Add Phase 3 (enhanced components) for professional polish
4. Consider Phase 4 (advanced interactions) as optional enhancements

---

**Document Prepared By:** Claude (UI Designer Agent)
**Review Status:** Ready for Developer Handoff
**Next Steps:**
1. Review with product team
2. Validate accessibility requirements
3. Begin Phase 1 implementation
4. Conduct user testing after Phase 2

---
