# Google Gemini Chat Interface - Complete Flutter Implementation Guide

## Executive Summary

This document provides comprehensive design specifications and implementation details for replicating Google's Gemini chat interface in Flutter. Based on recent research (November 2025), Gemini has been redesigned with Material Design 3 principles, featuring a modern, clean aesthetic with purple primary colors, pill-shaped input fields, and responsive layouts optimized for mobile and tablet devices.

---

## 1. Overall Layout Structure

### Screen Composition

The Gemini chat interface follows a three-part vertical layout:

```
┌─────────────────────────────────┐
│        APP BAR (64-72dp)         │  <- AppBar with logo/menu
├─────────────────────────────────┤
│                                  │
│      CHAT MESSAGES AREA          │  <- ScrollView with messages
│    (Dynamic, Flex Growth)        │
│                                  │
├─────────────────────────────────┤
│   INPUT FIELD & CONTROLS         │  <- Fixed bottom input
│        (Height: 56-80dp)         │
└─────────────────────────────────┘
```

### SafeArea Implementation

```dart
Scaffold(
  appBar: AppBar(...),
  body: SafeArea(
    left: true,
    top: false,  // AppBar handles top inset
    right: true,
    bottom: false,  // Input field handles bottom
    child: Column(
      children: [
        Expanded(child: ChatMessagesView()),
        ChatInputField(),
      ],
    ),
  ),
)
```

### Spacing & Padding Standards

- **Message List Padding**: `EdgeInsets.symmetric(horizontal: 16, vertical: 8)`
- **Between Messages**: `8-12dp` vertical spacing
- **Screen Margins**: `16dp` on left/right
- **Top Padding (after AppBar)**: `8dp`
- **Bottom Padding (above input)**: `8dp`

---

## 2. App Bar Design

### Dimensions & Structure

- **Height**: 64dp (small) on mobile, 56dp minimum
- **Elevation**: Elevation 1 (subtle shadow)
- **Background**: Surface color (typically white in light mode, #1c1b1d in dark mode)

### Layout Components

```
┌────────────────────────────────────┐
│ [Menu] [Gemini Logo]    [Settings] │
│                                    │
│        "Google" text + icon        │
└────────────────────────────────────┘
```

#### Leading Element (Left)
- **Menu Button**:
  - Type: `IconButton` with hamburger menu icon
  - Size: 24x24dp icon, 48x48dp touch target
  - Color: On-Surface color (#1c1b1d light, ~#e0e0e0 dark)
  - Padding: 12dp on all sides

#### Title/Logo (Center)
- **Text**: "Gemini"
- **Font**: Google Sans Bold, 20sp
- **Color**: On-Surface color
- **Alignment**: Left-aligned after Material 3 redesign

#### Trailing Element (Right)
- **Type**: Settings/More menu button
- **Icon**: Three-dot menu or settings icon
- **Size**: 24x24dp icon, 48x48dp touch target
- **Color**: On-Surface color

### Colors & Styling

**Light Mode:**
- Background: `#fefbff` (Off-white)
- Text/Icons: `#1c1b1d` (Dark gray)
- Border/Divider: `#e8e0e8` (Light gray, Surface Variant)
- Elevation: 1dp shadow

**Dark Mode:**
- Background: `#1a0a2e` (Dark purple-black)
- Text/Icons: `#ece7ea` (Light gray)
- Border/Divider: `#49454e` (Medium gray)
- Elevation: 1dp shadow with transparency

### Elevation Shadow

```dart
elevation: 1.0,
shadowColor: Colors.black.withOpacity(0.15),
// Explicit shadow:
// 0px 1px 2px 0px rgb(0 0 0 / 30%),
// 0px 1px 3px 1px rgb(0 0 0 / 15%)
```

---

## 3. Chat Message Bubbles

### User Message (Right-aligned)

```dart
Align(
  alignment: Alignment.centerRight,
  child: Container(
    margin: EdgeInsets.only(left: 80, right: 16, top: 4, bottom: 4),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Color(0xFF6442d6),  // Primary Purple
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Text(
      message.text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Google Sans Text',
        height: 1.4,  // Line height
      ),
    ),
  ),
)
```

**Specifications:**
- **Background Color**: `#6442d6` (Primary Purple)
- **Border Radius**: 20dp (pill-shaped with squared corners on sender side)
- **Padding**: 16dp horizontal, 12dp vertical
- **Text Color**: White (`#ffffff`)
- **Max Width**: 85% of screen width
- **Margin**: 80dp left, 16dp right, 4dp top/bottom
- **Shadow**: Subtle (1px blur)

### AI/Bot Message (Left-aligned)

```dart
Align(
  alignment: Alignment.centerLeft,
  child: Container(
    margin: EdgeInsets.only(left: 16, right: 80, top: 4, bottom: 4),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Color(0xFFf2ecee),  // Surface 2 (Light)
      // OR Color(0xFF2a2a2e) for Dark Mode
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Text(
      message.text,
      style: TextStyle(
        color: Color(0xFF1c1b1d),  // On-Surface (Light)
        // OR Color(0xFFece7ea) for Dark Mode
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Google Sans Text',
        height: 1.4,
      ),
    ),
  ),
)
```

**Specifications:**
- **Background Color**: `#f2ecee` (Light), `#2a2a2e` (Dark)
- **Border Radius**: 20dp
- **Padding**: 16dp horizontal, 12dp vertical
- **Text Color**: `#1c1b1d` (Light), `#ece7ea` (Dark)
- **Max Width**: 85% of screen width
- **Margin**: 16dp left, 80dp right, 4dp top/bottom
- **Shadow**: Very subtle

### Message Avatar (Optional)

For bot messages, include a small avatar:

```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      width: 32,
      height: 32,
      margin: EdgeInsets.only(right: 8, top: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6442d6),  // Primary Purple
      ),
      child: Icon(Icons.auto_awesome, size: 18, color: Colors.white),
    ),
    // Message bubble here
  ],
)
```

---

## 4. Message Features & Content Handling

### Markdown Support

Gemini messages support rich markdown rendering:

**Implementation Strategy:**
1. Use `flutter_markdown` package for rendering
2. Apply custom styling per element

```dart
MarkdownBody(
  data: message.text,
  styleSheet: MarkdownStyleSheet(
    h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    h3: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    p: TextStyle(fontSize: 14, height: 1.5),
    code: TextStyle(
      fontFamily: 'Google Sans Mono',
      fontSize: 13,
      backgroundColor: Color(0xFFf5f5f5),
    ),
  ),
)
```

### Code Blocks

```dart
// For code blocks with syntax highlighting
CodeBlockWidget(
  code: block.code,
  language: block.language,
  backgroundColor: Color(0xFF2a2a2e),  // Dark background
  textColor: Color(0xFFe8e8e8),
  borderRadius: 8,
  padding: EdgeInsets.all(16),
  lineNumberColor: Color(0xFF686868),
)
```

**Code Block Styling:**
- **Background**: `#f5f5f5` (Light), `#2a2a2e` (Dark)
- **Border Radius**: 8dp
- **Padding**: 16dp
- **Font**: Google Sans Mono, 13sp
- **Line Numbers**: Yes, with 50% opacity
- **Copy Button**: Floating at bottom-right corner

### Lists & Bullet Points

**Unordered Lists:**
```dart
- Margin: 8dp top, 8dp bottom per item
- Bullet: 4dp circle, color: On-Surface
- Indent: 16dp from left
- Text: Body-M (14sp)
```

**Ordered Lists:**
```dart
- Same spacing as unordered
- Numbers: 14sp, semi-bold
- Format: "1. Item text" with 8dp between number and text
```

### Links

```dart
InkWell(
  onTap: () => launchUrl(Uri.parse(url)),
  child: Text(
    linkText,
    style: TextStyle(
      color: Color(0xFF6442d6),  // Primary Purple
      decoration: TextDecoration.underline,
      fontSize: 14,
    ),
  ),
)
```

### Image Display

```dart
Container(
  margin: EdgeInsets.symmetric(vertical: 8),
  constraints: BoxConstraints(maxWidth: 400),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Color(0xFFe8e0e8),
      width: 1,
    ),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
    ),
  ),
)
```

### Message Action Buttons

Displayed below messages on hover/long-press:

```dart
Padding(
  padding: EdgeInsets.only(top: 8),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ActionButton(
        icon: Icons.content_copy,
        label: 'Copy',
        onPressed: () => copyToClipboard(message.text),
      ),
      SizedBox(width: 8),
      ActionButton(
        icon: Icons.replay,
        label: 'Regenerate',
        onPressed: () => regenerateMessage(message.id),
      ),
      SizedBox(width: 8),
      ActionButton(
        icon: Icons.edit,
        label: 'Edit',
        onPressed: () => editMessage(message.id),
      ),
    ],
  ),
)
```

**Button Styling:**
- **Background**: Transparent on hover
- **Icon Size**: 18dp
- **Text Size**: 12sp
- **Color**: `#6442d6` (Primary)
- **Touch Target**: 40x40dp minimum

---

## 5. Input Field Design

### Container Structure

```dart
Container(
  color: Color(0xFFfefbff),  // Surface color
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Container(
    decoration: BoxDecoration(
      color: Color(0xFFf2ecee),  // Surface 2
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Color(0xFFe8e0e8),  // Surface Variant
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        // Components here
      ],
    ),
  ),
)
```

### Layout Components

```
[+] [Text Input Area.........] [🎤] [⬆]
```

#### Left Icon (Attachment/Menu)
```dart
IconButton(
  icon: Icon(Icons.add, size: 24),
  onPressed: () => showAttachmentMenu(),
  constraints: BoxConstraints(minWidth: 48, minHeight: 48),
  padding: EdgeInsets.all(12),
  color: Color(0xFF6442d6),
)
```

#### Text Input Field
```dart
Expanded(
  child: TextField(
    controller: _textController,
    decoration: InputDecoration(
      hintText: 'Ask Gemini',
      hintStyle: TextStyle(
        color: Color(0xFF787579),  // Outline color
        fontSize: 14,
        fontFamily: 'Google Sans Text',
      ),
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    ),
    style: TextStyle(
      fontSize: 14,
      fontFamily: 'Google Sans Text',
      color: Color(0xFF1c1b1d),
      height: 1.4,
    ),
    maxLines: null,
    keyboardType: TextInputType.multiline,
  ),
)
```

**Text Field Specs:**
- **Placeholder**: "Ask Gemini"
- **Font Size**: 14sp
- **Font Family**: Google Sans Text
- **Max Lines**: Expandable (up to 5-6 lines)
- **Padding**: 8dp horizontal, 12dp vertical
- **Cursor Color**: `#6442d6` (Primary)

#### Voice Input Button (Microphone)
```dart
IconButton(
  icon: Icon(Icons.mic, size: 24),
  onPressed: () => startVoiceInput(),
  constraints: BoxConstraints(minWidth: 48, minHeight: 48),
  padding: EdgeInsets.all(12),
  color: Color(0xFF6442d6),
)
```

**Microphone Button Specs:**
- **Icon Size**: 24dp
- **Color**: `#6442d6` (Primary Purple)
- **Active State**: Animated pulse or color change
- **Touch Target**: 48x48dp

#### Send Button
```dart
IconButton(
  icon: Icon(Icons.send, size: 20),
  onPressed: _isInputEmpty ? null : () => sendMessage(),
  constraints: BoxConstraints(minWidth: 48, minHeight: 48),
  padding: EdgeInsets.all(12),
  color: _isInputEmpty ? Color(0xFFd0d0d0) : Color(0xFF6442d6),
)
```

**Send Button Specs:**
- **Icon**: Upload/Send arrow
- **Icon Size**: 20dp
- **Color**: `#6442d6` (Active), `#d0d0d0` (Disabled)
- **Touch Target**: 48x48dp
- **Disabled State**: Grayed out when input is empty

### Complete Input Field Code

```dart
class ChatInputField extends StatefulWidget {
  const ChatInputField({required this.onSendMessage});

  final Function(String) onSendMessage;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late TextEditingController _controller;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()
      ..addListener(() {
        setState(() => _isComposing = _controller.text.isNotEmpty);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFfefbff),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFf2ecee),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFe8e0e8),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
              color: const Color(0xFF6442d6),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ask Gemini',
                  hintStyle: TextStyle(
                    color: const Color(0xFF787579),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1c1b1d),
                ),
                maxLines: null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {},
              color: const Color(0xFF6442d6),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isComposing
                  ? () {
                      widget.onSendMessage(_controller.text);
                      _controller.clear();
                    }
                  : null,
              color: _isComposing
                  ? const Color(0xFF6442d6)
                  : const Color(0xFFd0d0d0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Keyboard Handling

```dart
Container(
  // Use SingleChildScrollView for keyboard handling
  child: SingleChildScrollView(
    physics: const ClampingScrollPhysics(),
    child: Column(
      children: [
        Expanded(child: ChatMessagesView()),
        // Keyboard insets handled by input field
        ChatInputField(),
      ],
    ),
  ),
)
```

---

## 6. Colors & Theme

### Material Design 3 Color Palette

#### Primary Colors
| Role | Light | Dark | Use Case |
|------|-------|------|----------|
| Primary | `#6442d6` | `#cbbeff` | Buttons, accents, highlights |
| Primary Container | `#9f86ff` | `#4b21bd` | Filled buttons, badges |
| On Primary | `#ffffff` | `#1c1b1d` | Text on primary |

#### Surface Colors
| Role | Light | Dark | Use Case |
|------|-------|------|----------|
| Background | `#fefbff` | `#1a0a2e` | Screen background |
| Surface 0 | `#ffffff` | `#1f1f25` | Message bubbles |
| Surface 1 | `#f8f1f6` | `#2a2a2e` | Input field background |
| Surface 2 | `#f2ecee` | `#2a2a2e` | AI message bubbles |
| Surface 3 | `#ece7e9` | `#3a3a3f` | Dividers |
| Surface Variant | `#e8e0e8` | `#49454e` | Borders |
| On Surface | `#1c1b1d` | `#ece7ea` | Text, icons |

#### Error/Semantic Colors
| Role | Light | Use Case |
|------|-------|----------|
| Error | `#ff6240` | Error messages |
| Success | `#34be4d` | Confirmation |
| Caution | `#ffce22` | Warnings |

### Dark Mode Implementation

```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFcbbeff),
    primaryContainer: const Color(0xFF4b21bd),
    secondary: const Color(0xFFdcdaf5),
    surface: const Color(0xFF1f1f25),
    background: const Color(0xFF1a0a2e),
    onPrimary: const Color(0xFF1c1b1d),
    onSurface: const Color(0xFFece7ea),
  ),
)
```

### Light Mode Implementation

```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF6442d6),
    primaryContainer: const Color(0xFF9f86ff),
    secondary: const Color(0xFF5d5d74),
    surface: const Color(0xFFfefbff),
    background: const Color(0xFFfefbff),
    onPrimary: const Color(0xFFffffff),
    onSurface: const Color(0xFF1c1b1d),
  ),
)
```

---

## 7. Typography

### Font Families

- **Display/Headlines**: Google Sans (475-700 weight)
- **Body Text**: Google Sans Text (400-500 weight)
- **Monospace/Code**: Google Sans Mono (400 weight)

### Font Size Scale

```
Display Large:   57sp / Line Height: 1.12
Display Medium:  45sp / Line Height: 1.16
Display Small:   36sp / Line Height: 1.22

Headline Large:  32sp / Line Height: 1.25
Headline Medium: 28sp / Line Height: 1.29
Headline Small:  24sp / Line Height: 1.33

Title Large:     22sp / Line Height: 1.27
Title Medium:    16sp / Line Height: 1.5
Title Small:     14sp / Line Height: 1.43

Body Large:      16sp / Line Height: 1.5
Body Medium:     14sp / Line Height: 1.43
Body Small:      12sp / Line Height: 1.33

Label Large:     14sp / Line Height: 1.43
Label Medium:    12sp / Line Height: 1.33
Label Small:     11sp / Line Height: 1.45
```

### Chat-Specific Typography

| Element | Font | Size | Weight | Line Height | Color |
|---------|------|------|--------|-------------|-------|
| Appbar Title | Google Sans | 20sp | Bold (700) | 1.2 | On-Surface |
| User Message | Google Sans Text | 14sp | Regular (400) | 1.4 | White |
| AI Message | Google Sans Text | 14sp | Regular (400) | 1.4 | On-Surface |
| Timestamp | Google Sans Text | 12sp | Regular (400) | 1.33 | Outline |
| Code Block | Google Sans Mono | 13sp | Regular (400) | 1.4 | Surface |
| Input Hint | Google Sans Text | 14sp | Regular (400) | 1.4 | Outline |

---

## 8. Animations & Interactions

### Message Appearance Animation

```dart
class AnimatedMessage extends StatelessWidget {
  const AnimatedMessage({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: MessageBubble(message: message),
    );
  }
}
```

**Specs:**
- **Duration**: 300ms
- **Curve**: easeInOut
- **Effect**: Fade-in + slide-up from bottom

### Typing Indicator

```dart
class TypingIndicator extends StatefulWidget {
  const TypingIndicator();

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..repeat(
          reverse: true,
          period: const Duration(milliseconds: 1200),
        ),
    );

    // Stagger animation
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].forward(from: i * 0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _controllers[index].value * 4 - 2),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6442d6),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
```

**Typing Indicator Specs:**
- **Dots**: 3 dots, 8dp diameter
- **Color**: `#6442d6` (Primary)
- **Animation**: Bounce up/down by 4dp
- **Stagger**: 200ms delay between dots
- **Duration**: 1200ms full cycle

### Loading/Streaming Animation

For streaming responses, use a gradient animation:

```dart
class StreamingMessageLoader extends StatefulWidget {
  const StreamingMessageLoader();

  @override
  State<StreamingMessageLoader> createState() => _StreamingMessageLoaderState();
}

class _StreamingMessageLoaderState extends State<StreamingMessageLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(_animation.value - 1, 0),
                end: Alignment(_animation.value, 0),
                colors: [
                  Colors.transparent,
                  const Color(0xFF6442d6),
                  Colors.transparent,
                ],
              ).createShader(bounds);
            },
            child: Container(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Button Interactions

```dart
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(20),
    splashColor: const Color(0xFF6442d6).withOpacity(0.2),
    highlightColor: const Color(0xFF6442d6).withOpacity(0.1),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(label),
    ),
  ),
)
```

**Interaction Specs:**
- **Ripple Color**: Primary with 20% opacity
- **Duration**: 200ms
- **Highlight**: Primary with 10% opacity

### Scroll Behavior

```dart
class ChatScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

// Usage
ScrollConfiguration(
  behavior: ChatScrollBehavior(),
  child: ListView(
    // Messages
  ),
)
```

---

## 9. Special UI Elements

### Welcome/Empty State Screen

When no messages exist, display:

```dart
class EmptyStateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: const Color(0xFF6442d6),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Gemini',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Ask anything to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF787579),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SuggestedPromptChip(
                label: 'Create image',
                icon: Icons.image,
              ),
              SuggestedPromptChip(
                label: 'Write',
                icon: Icons.edit,
              ),
              SuggestedPromptChip(
                label: 'Build',
                icon: Icons.build,
              ),
              SuggestedPromptChip(
                label: 'Deep Research',
                icon: Icons.search,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### Suggested Prompts/Chips

```dart
class SuggestedPromptChip extends StatelessWidget {
  const SuggestedPromptChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF9f86ff),  // Primary Container
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6442d6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
```

**Chip Specs:**
- **Background**: `#9f86ff` (Primary Container)
- **Border**: 1dp, `#6442d6` (Primary)
- **Border Radius**: 20dp
- **Padding**: 16dp horizontal, 12dp vertical
- **Text Color**: White
- **Font Size**: 14sp

### Canvas/Article Suggestion Card

For complex responses, show a preview card:

```dart
class CanvasCard extends StatelessWidget {
  const CanvasCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf2ecee),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFe8e0e8),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF787579),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 10. Responsive Design

### Breakpoints (Material Design 3)

| Size Category | Width Range | Grid Columns | Example Device |
|---------------|-------------|-------------|-----------------|
| Compact | < 600dp | 4 | Mobile phone |
| Medium | 600dp - 1200dp | 8 | Tablet portrait |
| Expanded | > 1200dp | 12 | Tablet landscape, Desktop |

### Adaptive Message Constraints

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final maxWidth = constraints.maxWidth;
    final messageWidth = maxWidth < 600
        ? maxWidth * 0.85  // Mobile: 85% width
        : maxWidth < 1200
            ? maxWidth * 0.75  // Tablet: 75% width
            : maxWidth * 0.60; // Desktop: 60% width

    return Container(
      constraints: BoxConstraints(maxWidth: messageWidth),
      // Message bubble content
    );
  },
)
```

### Adaptive AppBar

```dart
AppBar(
  title: LayoutBuilder(
    builder: (context, constraints) {
      return constraints.maxWidth < 600
          ? const Text('Gemini')
          : const Row(
              children: [
                Icon(Icons.auto_awesome),
                SizedBox(width: 8),
                Text('Google Gemini'),
              ],
            );
    },
  ),
)
```

### SafeArea with Keyboard

```dart
body: SafeArea(
  top: false,
  bottom: false,
  child: Column(
    children: [
      Expanded(
        child: ScrollConfiguration(
          behavior: ChatScrollBehavior(),
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return AnimatedMessage(message: messages[index]);
            },
          ),
        ),
      ),
      // Keyboard automatically pushes this up
      ChatInputField(),
    ],
  ),
)
```

### Keyboard Handling Best Practices

```dart
// Option 1: Use resizeToAvoidBottomInset
Scaffold(
  resizeToAvoidBottomInset: true,
  body: Column(...),
)

// Option 2: Manual keyboard inset handling
body: SingleChildScrollView(
  child: Column(
    children: [
      Expanded(child: ChatView()),
      AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatInputField(),
      ),
    ],
  ),
)
```

---

## 11. Complete Implementation Example

### Full Chat Screen

```dart
import 'package:flutter/material.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({Key? key}) : super(key: key);

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final List<ChatMessage> _messages = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add(ChatMessage(
          text: 'This is a sample response from Gemini.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gemini',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1c1b1d),
          ),
        ),
        backgroundColor: const Color(0xFFfefbff),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.15),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: const Color(0xFF1c1b1d),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          color: const Color(0xFF1c1b1d),
        ),
      ),
      body: SafeArea(
        left: true,
        top: false,
        right: true,
        bottom: false,
        child: Column(
          children: [
            if (_messages.isEmpty)
              Expanded(child: _buildEmptyState())
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_messages[index]);
                  },
                ),
              ),
            ChatInputField(onSendMessage: _handleSendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: const Color(0xFF6442d6).withOpacity(0.6),
          ),
          const SizedBox(height: 24),
          Text(
            'Hello there',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'How can I help you today?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF787579),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isUser ? 80 : 16,
          right: message.isUser ? 16 : 80,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF6442d6)
              : const Color(0xFFf2ecee),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                message.isUser ? 0.1 : 0.08,
              ),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? Colors.white
                : const Color(0xFF1c1b1d),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
```

---

## 12. Key Design Takeaways

### Design Principles

1. **Simplicity**: Clean, minimal interface with focus on content
2. **Material Design 3**: Uses Material You design tokens and components
3. **Accessibility**: High contrast, clear typography, sufficient touch targets
4. **Responsiveness**: Adapts from mobile to tablet to desktop
5. **Consistency**: Unified color palette, spacing, and typography

### Distinctive Features

- **Purple Primary Color** (`#6442d6`): Strong brand identity
- **Pill-Shaped UI**: Input field, buttons, and chips use rounded rectangles
- **Generous Spacing**: 16dp baseline for most margins and padding
- **Soft Shadows**: Subtle elevation for depth
- **Message Constraints**: 75-85% width for optimal readability
- **Bottom Input**: Fixed input field above keyboard for accessibility

### Common Pitfalls to Avoid

1. Don't use sharp 0dp border radius - Gemini prefers rounded corners
2. Don't ignore keyboard behavior - SafeArea and viewInsets are crucial
3. Don't use pure black/white - Use on-surface colors instead
4. Don't neglect touch targets - Minimum 48x48dp
5. Don't make input field too tall - Keep it compact and expandable

---

## 13. Resources

### Official Documentation
- [Material Design 3](https://m3.material.io/)
- [Flutter Material 3 Support](https://docs.flutter.dev/ui/design-systems/material)
- [Flutter AI Toolkit](https://docs.flutter.dev/ai-toolkit)
- [Google Generative AI API](https://ai.google.dev/)

### Useful Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_generative_ai: ^latest
  flutter_markdown: ^latest
  intl: ^latest
  riverpod: ^latest
  firebase_core: ^latest
```

### Related Research
- Google Gemini App Blog: https://blog.google/products/gemini/
- Material Design 3 Blog: https://m3.material.io/blog
- Android Police Gemini Coverage: https://www.androidpolice.com/

---

## Conclusion

Google's Gemini chat interface demonstrates a masterclass in modern UI design. By following these specifications, you can create a Flutter application that replicates Gemini's aesthetic and functionality while maintaining the principles that make it successful: clarity, consistency, and user-focused design.

The key to success is attention to detail—proper spacing, color usage, and interaction patterns matter more than individual components. Start with the basic layout, implement message bubbles correctly, and progressively add features like markdown support, animations, and responsive design.

