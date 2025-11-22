# Gemini UI Implementation Checklist

Use this checklist when implementing the Gemini chat interface in Flutter.

---

## Phase 1: Project Setup

- [ ] Create Flutter project with Material 3 support
- [ ] Add dependencies:
  ```yaml
  dependencies:
    google_generative_ai: ^latest
    flutter_markdown: ^latest
    intl: ^latest
  ```
- [ ] Configure theme with Material Design 3 colors
- [ ] Set `useMaterial3: true` in ThemeData
- [ ] Create theme data for both light and dark modes
- [ ] Test theme switching

---

## Phase 2: Layout Structure

### Overall Layout
- [ ] Create Scaffold-based chat screen
- [ ] Implement SafeArea wrapper with correct parameters
- [ ] Create three-part layout: AppBar → ChatView → InputField
- [ ] Set `resizeToAvoidBottomInset: true` on Scaffold
- [ ] Test layout on various screen sizes

### AppBar Implementation
- [ ] Create AppBar with 64dp height
- [ ] Add menu button (leading) - hamburger icon
- [ ] Add title "Gemini" - 20sp bold Google Sans
- [ ] Add settings button (trailing) - three-dot menu icon
- [ ] Apply correct colors (#fefbff light, #1a0a2e dark)
- [ ] Add elevation: 1dp with subtle shadow
- [ ] Test on mobile, tablet, and desktop

### Chat Messages View
- [ ] Create ListView for messages with dynamic height
- [ ] Add padding: 16dp horizontal, 8dp vertical
- [ ] Implement scroll controller for auto-scroll
- [ ] Add scroll-to-bottom animation (300ms easeOut)
- [ ] Test with varying message lengths

### Input Field Area
- [ ] Create fixed bottom input container
- [ ] Add padding: 16dp horizontal, 12dp vertical
- [ ] Implement keyboard inset handling
- [ ] Test keyboard appearance/dismissal

---

## Phase 3: Message Bubbles

### User Message Bubble
- [ ] Create right-aligned container
- [ ] Set background: #6442d6 (primary purple)
- [ ] Set border radius: 20dp
- [ ] Add padding: 16dp horizontal, 12dp vertical
- [ ] Add margin: left 80dp, right 16dp, top/bottom 4dp
- [ ] Set text color: white (#ffffff)
- [ ] Set font: 14sp Google Sans Text, line height 1.4
- [ ] Add subtle shadow (opacity 0.1)
- [ ] Constrain max width to 75-85% of screen
- [ ] Test on various screen widths

### AI Message Bubble
- [ ] Create left-aligned container
- [ ] Set background: #f2ecee (light) or #2a2a2e (dark)
- [ ] Set border radius: 20dp
- [ ] Add padding: 16dp horizontal, 12dp vertical
- [ ] Add margin: left 16dp, right 80dp, top/bottom 4dp
- [ ] Set text color: #1c1b1d (light) or #ece7ea (dark)
- [ ] Set font: 14sp Google Sans Text, line height 1.4
- [ ] Add very subtle shadow (opacity 0.08)
- [ ] Constrain max width to 75-85% of screen
- [ ] Test on various screen widths

### Message Animations
- [ ] Implement fade-in animation (300ms)
- [ ] Add slide-up animation (20dp offset)
- [ ] Test animation smoothness
- [ ] Ensure animations don't block UI

### Avatar (Optional)
- [ ] Add circular avatar for AI messages
- [ ] Set size: 32x32dp
- [ ] Set background: #6442d6
- [ ] Add icon: Icons.auto_awesome
- [ ] Align with message bubble

---

## Phase 4: Message Content Features

### Text Rendering
- [ ] Support plain text
- [ ] Implement proper line wrapping
- [ ] Handle very long words/URLs gracefully
- [ ] Test with various text lengths

### Markdown Support
- [ ] Add flutter_markdown dependency
- [ ] Implement markdown parsing
- [ ] Style markdown elements:
  - [ ] Headers (h1-h3)
  - [ ] Bold/italic text
  - [ ] Inline code
  - [ ] Lists (ordered and unordered)
  - [ ] Links (clickable, purple color)
  - [ ] Blockquotes

### Code Blocks
- [ ] Add syntax highlighting support
- [ ] Implement dark background (#2a2a2e)
- [ ] Add light text color (#e8e8e8)
- [ ] Set border radius: 8dp
- [ ] Add padding: 16dp
- [ ] Add line numbers (optional)
- [ ] Add copy button (corner floating)
- [ ] Test with multiple programming languages

### Images
- [ ] Support image URLs in responses
- [ ] Add border radius: 12dp
- [ ] Add subtle border: 1dp light gray
- [ ] Implement proper sizing/scaling
- [ ] Test image loading states

### Lists
- [ ] Style bullet points (4dp circle, on-surface color)
- [ ] Add indent: 16dp from left
- [ ] Set spacing: 8dp between items
- [ ] Style numbered lists (semi-bold numbers)
- [ ] Test nested lists

### Links
- [ ] Make links clickable
- [ ] Set color: #6442d6 (primary purple)
- [ ] Add underline decoration
- [ ] Implement URL launching
- [ ] Test on various link types

### Message Actions
- [ ] Add copy button
- [ ] Add regenerate button (if applicable)
- [ ] Add edit button (if applicable)
- [ ] Style as small buttons with icons
- [ ] Implement hover/long-press to show actions
- [ ] Test all action functionality

---

## Phase 5: Input Field Design

### Container & Layout
- [ ] Create pill-shaped container (24dp border radius)
- [ ] Set background: #f2ecee (light) or #2a2a2e (dark)
- [ ] Add border: 1dp #e8e0e8
- [ ] Add padding: 16dp horizontal, 12dp vertical
- [ ] Create Row with flex for layout

### Text Input
- [ ] Create TextField for text input
- [ ] Set placeholder: "Ask Gemini"
- [ ] Set font: 14sp Google Sans Text
- [ ] Set placeholder color: #787579
- [ ] Allow multiline input
- [ ] Expand height as user types (max 5-6 lines)
- [ ] Set max lines: null (expandable)
- [ ] Add cursor color: #6442d6

### Buttons
- [ ] Add menu/attachment button (left)
  - [ ] Icon: Icons.add
  - [ ] Size: 24x24dp icon, 48x48dp touch target
  - [ ] Color: #6442d6
  - [ ] Padding: 12dp

- [ ] Add microphone button
  - [ ] Icon: Icons.mic
  - [ ] Size: 24x24dp icon, 48x48dp touch target
  - [ ] Color: #6442d6
  - [ ] Padding: 12dp
  - [ ] Add active state animation

- [ ] Add send button (right)
  - [ ] Icon: Icons.send
  - [ ] Size: 20x20dp icon, 48x48dp touch target
  - [ ] Active color: #6442d6
  - [ ] Disabled color: #d0d0d0
  - [ ] Padding: 12dp
  - [ ] Disable when input empty

### Keyboard Handling
- [ ] Test input focus behavior
- [ ] Ensure keyboard pushes input up
- [ ] Test with various keyboard types
- [ ] Implement keyboard dismiss on send
- [ ] Test keyboard hiding animation

---

## Phase 6: Empty State & Welcome

### Empty State Screen
- [ ] Add icon: Icons.auto_awesome (64dp, primary color)
- [ ] Add title: "Welcome to Gemini" (headline-medium)
- [ ] Add subtitle: "Ask anything to get started" (body-medium, gray)
- [ ] Add spacing: 24dp between elements

### Suggested Prompts
- [ ] Create chip components (20dp border radius)
- [ ] Add suggestions: Create image, Write, Build, Deep Research
- [ ] Set background: #9f86ff (primary container)
- [ ] Set border: 1dp #6442d6
- [ ] Set text color: white
- [ ] Add icons to chips
- [ ] Make chips clickable
- [ ] Implement tap functionality

---

## Phase 7: Typing Indicator

- [ ] Create animated typing indicator widget
- [ ] Add 3 dots (8dp diameter each)
- [ ] Set color: #6442d6
- [ ] Implement bounce animation (4dp up/down)
- [ ] Stagger dots (200ms delay between each)
- [ ] Full cycle duration: 1200ms
- [ ] Show during AI response generation
- [ ] Test animation smoothness

---

## Phase 8: Responsive Design

### Mobile (< 600dp)
- [ ] Message width: 85%
- [ ] Margin: 16dp left/right
- [ ] Test portrait orientation
- [ ] Test landscape orientation
- [ ] Ensure all touch targets are 48x48dp

### Tablet (600-1200dp)
- [ ] Message width: 75%
- [ ] Margin: appropriate for wider screen
- [ ] Add split-view support (optional)
- [ ] Test portrait and landscape

### Desktop (> 1200dp)
- [ ] Message width: 60%
- [ ] Center messages on screen
- [ ] Implement wide layout optimizations
- [ ] Test resizing window

### Keyboard Integration
- [ ] Use MediaQuery.of(context).viewInsets.bottom
- [ ] Test with hardware keyboard
- [ ] Test with on-screen keyboard
- [ ] Test keyboard height changes

---

## Phase 9: Theme Implementation

### Light Mode
- [ ] Primary: #6442d6
- [ ] Background: #fefbff
- [ ] Surface: #ffffff
- [ ] On-Surface: #1c1b1d
- [ ] Outline: #787579
- [ ] Test all colors in light mode

### Dark Mode
- [ ] Primary: #cbbeff
- [ ] Background: #1a0a2e
- [ ] Surface: #1f1f25
- [ ] On-Surface: #ece7ea
- [ ] Outline: #787579 (same)
- [ ] Test all colors in dark mode

### Theme Switching
- [ ] Implement theme toggle
- [ ] Test theme persistence
- [ ] Verify all colors change correctly
- [ ] Test animations in both themes

---

## Phase 10: Polish & Performance

### Animations
- [ ] Message fade-in: 300ms
- [ ] Typing indicator: smooth
- [ ] Button ripples: 200ms
- [ ] Scroll-to-bottom: 300ms
- [ ] Keyboard transitions: 200ms
- [ ] All animations use appropriate curves

### Performance
- [ ] Implement message list pagination
- [ ] Optimize image loading
- [ ] Test with 100+ messages
- [ ] Monitor memory usage
- [ ] Check frame rate during animations
- [ ] Profile on low-end devices

### Accessibility
- [ ] All touch targets: 48x48dp minimum
- [ ] High contrast text: #1c1b1d on #fefbff
- [ ] Semantic labels on buttons
- [ ] Test with screen reader
- [ ] Keyboard navigation support
- [ ] Color blindness friendly

### Testing
- [ ] Unit tests for message formatting
- [ ] Widget tests for UI components
- [ ] Integration tests for full flow
- [ ] Test on real devices (iOS, Android)
- [ ] Test with various OS versions
- [ ] Test with accessibility features enabled

---

## Phase 11: Final Verification

### Visual Design
- [ ] [ ] Message bubbles match spec (size, color, radius)
- [ ] [ ] AppBar matches spec (height, elements, colors)
- [ ] [ ] Input field matches spec (pill shape, buttons)
- [ ] [ ] Colors match hex codes exactly
- [ ] [ ] Spacing follows 8dp grid
- [ ] [ ] Typography uses correct fonts and sizes
- [ ] [ ] Shadows and elevations are subtle
- [ ] [ ] Both light and dark modes match spec

### Functionality
- [ ] [ ] Messages send and receive correctly
- [ ] [ ] Input field expands/contracts
- [ ] [ ] Auto-scroll works
- [ ] [ ] Copy button works
- [ ] [ ] Links are clickable
- [ ] [ ] Code blocks are formatted
- [ ] [ ] Images display correctly
- [ ] [ ] Keyboard handling works

### Responsive
- [ ] [ ] Mobile layout correct
- [ ] [ ] Tablet layout correct
- [ ] [ ] Desktop layout correct
- [ ] [ ] Keyboard doesn't cover input
- [ ] [ ] Messages constrained properly
- [ ] [ ] No horizontal scroll on mobile

### Performance
- [ ] [ ] Smooth animations (60fps)
- [ ] [ ] No jank on scroll
- [ ] [ ] Fast message rendering
- [ ] [ ] Low memory usage
- [ ] [ ] Handles 1000+ messages

---

## Common Issues & Solutions

### Issue: Messages not scrolling to bottom
**Solution:** Ensure ScrollController is properly initialized and attached to ListView

### Issue: Keyboard covers input field
**Solution:** Set `resizeToAvoidBottomInset: true` and use SafeArea correctly

### Issue: Colors look wrong in dark mode
**Solution:** Verify MaterialColor brightness detection and check isDarkMode status

### Issue: Border radius not appearing
**Solution:** Use ClipRRect if needed, ensure Container has proper decoration

### Issue: Animations are janky
**Solution:** Use const constructors, avoid rebuilds, check frame rate with DevTools

### Issue: Input field not expanding
**Solution:** Remove maxLines restriction, ensure Expanded widget wraps TextField

### Issue: Text overflows message bubble
**Solution:** Add proper constraints, use Text overflow: TextOverflow.wrap

---

## Quick Implementation Order

1. **Day 1**: Basic layout (AppBar, chat area, input field)
2. **Day 2**: Message bubbles (user & AI styling)
3. **Day 3**: Input field with all buttons
4. **Day 4**: Text rendering and markdown support
5. **Day 5**: Animations and interactions
6. **Day 6**: Empty state and suggested prompts
7. **Day 7**: Responsive design and keyboard handling
8. **Day 8**: Theme implementation (light & dark)
9. **Day 9**: Polish, performance optimization
10. **Day 10**: Testing and final verification

---

## Reference Files

- **Full Specification**: `GEMINI_UI_DESIGN_SPECIFICATIONS.md`
- **Quick Reference**: `GEMINI_QUICK_REFERENCE.md`
- **This Checklist**: `GEMINI_IMPLEMENTATION_CHECKLIST.md`

---

## Notes

- Start with mobile layout first, then scale to tablet/desktop
- Test on real devices as soon as possible
- Colors should match hex codes exactly
- Spacing should follow 8dp baseline grid
- All measurements are in density-independent pixels (dp)
- Test both light and dark modes throughout development
- Performance matters more as message count increases

Good luck with your implementation!

