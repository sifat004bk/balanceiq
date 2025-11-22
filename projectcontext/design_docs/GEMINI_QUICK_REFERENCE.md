# Gemini UI Design - Quick Reference Guide

A concise reference for implementing Google Gemini's chat interface in Flutter.

---

## Essential Color Codes

### Primary Colors
```
Light Mode:  #6442d6 (Primary Purple)
Dark Mode:   #cbbeff (Light Purple)
```

### Background & Surfaces
```
Light - Background:     #fefbff
Light - Message (User): #6442d6
Light - Message (AI):   #f2ecee
Light - Input:          #f2ecee

Dark - Background:      #1a0a2e
Dark - Message (User):  #6442d6 (same)
Dark - Message (AI):    #2a2a2e
Dark - Input:           #2a2a2e
```

### Text Colors
```
Light - Primary:   #1c1b1d (Dark gray)
Light - Secondary: #787579 (Medium gray)
Dark - Primary:    #ece7ea (Light gray)
Dark - Secondary:  #787579 (Medium gray)
```

---

## Key Measurements (in dp)

### Spacing
```
Small Gap:     4dp
Standard Gap:  8dp
Medium Gap:    12dp
Large Gap:     16dp
XL Gap:        24dp
```

### Border Radius
```
Buttons/Chips: 20dp
Input Field:   24dp
Cards:         12dp
Code Blocks:   8dp
Avatar:        50% (circle)
```

### Dimensions
```
AppBar Height:        64dp
Input Field Height:   56-80dp (expandable)
Icon Size:            24dp
Touch Target:         48x48dp
Avatar Size:          32x32dp
Max Message Width:    75-85% of screen
```

### Padding/Margin
```
Message Bubbles:  16dp horizontal, 12dp vertical
Input Field:      16dp horizontal, 12dp vertical overall
Screen Margins:   16dp left/right
Text Padding:     8dp horizontal, 12dp vertical
Icon Button:      12dp padding
```

---

## Typography

### Font Family
- Display/Headlines: Google Sans (Bold)
- Body Text: Google Sans Text (Regular)
- Code: Google Sans Mono

### Sizes
```
Appbar Title:   20sp (bold)
Headlines:      24-32sp
Body Text:      14sp
Input Hint:     14sp
Timestamps:     12sp
Code Blocks:    13sp
```

---

## Message Bubble Pattern

### User Message (Right-aligned)
```dart
Align(
  alignment: Alignment.centerRight,
  child: Container(
    margin: EdgeInsets.only(left: 80, right: 16, top: 4, bottom: 4),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Color(0xFF6442d6),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(/* white text */),
  ),
)
```

### AI Message (Left-aligned)
```dart
Align(
  alignment: Alignment.centerLeft,
  child: Container(
    margin: EdgeInsets.only(left: 16, right: 80, top: 4, bottom: 4),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Color(0xFFf2ecee),  // Light
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(/* dark text */),
  ),
)
```

---

## Input Field Layout

```
[+] [Text Input Area...] [🎤] [↗]
├─── Add Menu
├─── Text Field (max 5-6 lines, expandable)
├─── Voice Input Button
└─── Send Button
```

All buttons are 48x48dp touch targets with 24x24dp icons.

---

## Animation Timings

```
Message Appearance:     300ms (fade + slide-up)
Typing Indicator:       1200ms per cycle (3 bouncing dots)
Button Tap:            200ms ripple
Scroll to Bottom:       300ms easeOut
Keyboard Inset:        200ms animation
```

---

## Responsive Breakpoints

```
Mobile:   < 600dp      (Message width: 85%)
Tablet:   600-1200dp   (Message width: 75%)
Desktop:  > 1200dp     (Message width: 60%)
```

---

## Complete Input Field Code

```dart
class ChatInputField extends StatefulWidget {
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
          border: Border.all(color: const Color(0xFFe8e0e8)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              color: const Color(0xFF6442d6),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ask Gemini',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              color: const Color(0xFF6442d6),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: _isComposing
                  ? const Color(0xFF6442d6)
                  : const Color(0xFFd0d0d0),
              onPressed: _isComposing ? () {
                widget.onSendMessage(_controller.text);
                _controller.clear();
              } : null,
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

---

## Typing Indicator Code

```dart
class TypingIndicator extends StatefulWidget {
  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..repeat(reverse: true);
      controller.forward(from: index * 0.2);
      return controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, _) {
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
        );
      }),
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

---

## Theme Configuration

```dart
ThemeData(
  useMaterial3: true,
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

## Desktop/Responsive Pattern

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final messageWidth = constraints.maxWidth < 600
        ? constraints.maxWidth * 0.85
        : constraints.maxWidth < 1200
            ? constraints.maxWidth * 0.75
            : constraints.maxWidth * 0.60;

    return Container(
      constraints: BoxConstraints(maxWidth: messageWidth),
      // Message bubble content
    );
  },
)
```

---

## Key Implementation Tips

1. **Always use Material Design 3**: Set `useMaterial3: true` in ThemeData
2. **SafeArea is critical**: Wrap body with SafeArea for notch/keyboard support
3. **Message width constraints**: Never let messages use 100% screen width
4. **Touch targets**: All interactive elements must be 48x48dp minimum
5. **Keyboard handling**: Use `resizeToAvoidBottomInset: true` on Scaffold
6. **Colors should adapt**: Always respect light/dark mode distinction
7. **Spacing consistency**: Use 8dp, 12dp, 16dp, 24dp for all spacing
8. **Border radius**: Messages are 20dp, input is 24dp, cards are 12dp
9. **Shadow should be subtle**: Use `withOpacity(0.1)` or less for shadows
10. **Animation should be smooth**: Use easeInOut curves, 200-300ms duration

---

## Common Mistakes to Avoid

- Using pure black (#000000) instead of #1c1b1d
- Using pure white (#FFFFFF) instead of #fefbff
- Making border radius too sharp (< 8dp)
- Not constraining message width
- Using TouchableOpacity instead of Material InkWell
- Not handling keyboard insets
- Forgetting SafeArea
- Using wrong primary color (#6442d6, not blue)
- Spacing that doesn't follow 8dp grid
- Not supporting both light and dark modes

---

## File Reference

For complete details, see: `/Users/sifatullahchowdhury/Projects/Applications/balanceIQ/GEMINI_UI_DESIGN_SPECIFICATIONS.md`

This quick reference covers the essentials. The full specification document contains:
- Detailed elevation shadow specifications
- Complete color palette with all tones
- Extended typography guidelines
- Markdown and code block implementation
- Advanced animation patterns
- Tablet layout specifications
- Empty state designs
- Complete working examples

