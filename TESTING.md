# BalanceIQ Testing Checklist

Use this checklist to ensure all features are working correctly.

## Pre-Testing Setup

- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] n8n workflow is running and accessible
- [ ] n8n webhook URL configured in app
- [ ] Google Sign-In configured (for production testing)
- [ ] All permissions granted on test device

## Authentication Tests

### Google Sign-In
- [ ] Tap "Continue with Google" button
- [ ] Google account picker appears
- [ ] Select account successfully
- [ ] Redirected to home screen after sign-in
- [ ] User data persisted (reopen app, still signed in)

### Apple Sign-In (iOS only)
- [ ] Tap "Continue with Apple" button
- [ ] Apple authentication dialog appears
- [ ] Sign in successfully
- [ ] Redirected to home screen
- [ ] User data persisted

### Error Handling
- [ ] Cancel sign-in shows appropriate message
- [ ] Network error handled gracefully
- [ ] Invalid credentials handled properly

## Home Screen Tests

### UI Elements
- [ ] App title "BalanceIQ" displayed
- [ ] Account icon visible in top right
- [ ] "Choose a bot to start" text displayed
- [ ] All 4 bot buttons visible and styled correctly
  - [ ] Balance Tracker (green icon)
  - [ ] Investment Guru (purple icon)
  - [ ] Budget Planner (blue icon)
  - [ ] Fin Tips (yellow icon)

### Navigation
- [ ] Tap Balance Tracker → Opens chat screen
- [ ] Tap Investment Guru → Opens chat screen
- [ ] Tap Budget Planner → Opens chat screen
- [ ] Tap Fin Tips → Opens chat screen
- [ ] Back button returns to home screen

### Theme
- [ ] Light mode displays correctly
- [ ] Dark mode displays correctly
- [ ] Theme switches based on system settings

## Chat Screen Tests

### UI Elements
- [ ] Bot name displayed in app bar
- [ ] Back button works
- [ ] Welcome message displayed for empty chat
- [ ] Bot icon and color match selected bot
- [ ] Message input field visible
- [ ] Send button visible
- [ ] Image picker button visible
- [ ] Audio recorder button visible

### Text Messages

#### Sending
- [ ] Type a message in input field
- [ ] Tap send button
- [ ] Message appears in chat as user message
- [ ] Message sent to n8n webhook
- [ ] Input field clears after sending
- [ ] Typing indicator appears while waiting

#### Receiving
- [ ] Bot response appears after n8n responds
- [ ] Bot message has correct styling (different from user)
- [ ] Bot icon displayed with message
- [ ] Timestamp displayed correctly
- [ ] Long messages wrap properly

#### Message History
- [ ] Messages persist after closing and reopening chat
- [ ] Messages load from database on chat open
- [ ] Messages displayed in chronological order
- [ ] Scroll works correctly for long conversations

### Image Messages

#### Camera
- [ ] Tap image button → Shows source options
- [ ] Select "Take a photo"
- [ ] Camera opens
- [ ] Take photo
- [ ] Photo preview appears in chat input
- [ ] Can remove photo before sending (X button)
- [ ] Send photo with text message
- [ ] Photo sent as base64 to n8n
- [ ] Image displays in chat bubble

#### Gallery
- [ ] Tap image button → Shows source options
- [ ] Select "Choose from gallery"
- [ ] Gallery picker opens
- [ ] Select photo
- [ ] Photo preview appears in chat input
- [ ] Send photo successfully
- [ ] Image displays in chat

#### Error Handling
- [ ] Large image (>10MB) shows error
- [ ] Camera permission denied shows error
- [ ] Gallery permission denied shows error

### Audio Messages

#### Recording
- [ ] Tap microphone button → Starts recording
- [ ] Microphone icon turns red while recording
- [ ] Tap stop button → Stops recording
- [ ] Audio preview appears in input
- [ ] Can remove audio before sending
- [ ] Send audio message
- [ ] Audio sent as base64 to n8n

#### Error Handling
- [ ] Microphone permission denied shows error
- [ ] Long recording (>5min) handled correctly
- [ ] Large audio file (>25MB) shows error

### Multi-Modal Messages
- [ ] Send text + image together
- [ ] Send text + audio together
- [ ] All media types sent correctly to n8n

### Error Scenarios

#### Network Errors
- [ ] Airplane mode → Shows error message
- [ ] Poor connection → Shows timeout error
- [ ] n8n workflow stopped → Shows server error
- [ ] Invalid response format → Handled gracefully

#### UI Errors
- [ ] Empty message not sent
- [ ] Send button disabled while sending
- [ ] Error message displayed in snackbar
- [ ] Can retry after error

## Database Tests

### Message Persistence
- [ ] Send messages in Balance Tracker
- [ ] Close app completely
- [ ] Reopen app and go to Balance Tracker
- [ ] All messages still visible
- [ ] Send message in Investment Guru
- [ ] Switch to Budget Planner
- [ ] Return to Investment Guru
- [ ] Messages still there

### Multi-Bot Separation
- [ ] Messages in Balance Tracker don't appear in Investment Guru
- [ ] Messages in Budget Planner don't appear in Fin Tips
- [ ] Each bot maintains separate history

### Data Integrity
- [ ] Timestamps correct
- [ ] Message order maintained
- [ ] Images/audio references preserved
- [ ] No duplicate messages

## n8n Integration Tests

### Request Format
- [ ] bot_id sent correctly
- [ ] message text sent correctly
- [ ] timestamp in ISO 8601 format
- [ ] image base64 encoded correctly
- [ ] audio base64 encoded correctly

### Response Handling
- [ ] Text response displayed
- [ ] Optional image_url handled
- [ ] Optional audio_url handled
- [ ] Missing fields handled gracefully
- [ ] Malformed JSON handled

### Different Bots
- [ ] Balance Tracker bot_id: "balance_tracker"
- [ ] Investment Guru bot_id: "investment_guru"
- [ ] Budget Planner bot_id: "budget_planner"
- [ ] Fin Tips bot_id: "fin_tips"

## Performance Tests

### Load Time
- [ ] App launches in <3 seconds
- [ ] Chat history loads quickly (<1 second)
- [ ] Images load smoothly
- [ ] No lag when typing

### Memory
- [ ] No memory leaks during extended use
- [ ] App doesn't crash with many messages
- [ ] Large images handled efficiently

### Battery
- [ ] No excessive battery drain
- [ ] Background processes minimal

## Platform-Specific Tests

### Android
- [ ] All features work on Android
- [ ] Permissions requested correctly
- [ ] Back button behavior correct
- [ ] Notifications (if implemented) work
- [ ] App works on different screen sizes

### iOS
- [ ] All features work on iOS
- [ ] Permissions requested correctly
- [ ] Swipe back gesture works
- [ ] Keyboard behavior correct
- [ ] Safe area handled correctly

## Edge Cases

### Empty States
- [ ] Empty chat shows welcome message
- [ ] No internet shows appropriate message
- [ ] No auth shows onboarding

### Long Content
- [ ] Very long text message wraps correctly
- [ ] Many messages (100+) scroll smoothly
- [ ] Long bot responses display well

### Special Characters
- [ ] Emojis in messages work
- [ ] Special characters (", ', etc.) handled
- [ ] Multiple languages supported

### Rapid Actions
- [ ] Rapidly tapping send doesn't duplicate
- [ ] Quick bot switching works
- [ ] Fast typing doesn't lag

## Accessibility Tests

- [ ] Screen reader compatibility
- [ ] Text size adjusts with system settings
- [ ] Sufficient contrast ratios
- [ ] Touch targets appropriately sized

## Security Tests

- [ ] API keys not exposed in code
- [ ] User data encrypted in database
- [ ] HTTPS used for all network calls
- [ ] No sensitive data in logs

## Final Checks

- [ ] No console errors
- [ ] No analyzer warnings
- [ ] All imports used
- [ ] Code formatted properly
- [ ] README accurate
- [ ] Version number correct

## Test Results

| Test Category | Pass/Fail | Notes |
|--------------|-----------|-------|
| Authentication | | |
| Home Screen | | |
| Chat - Text | | |
| Chat - Image | | |
| Chat - Audio | | |
| Database | | |
| n8n Integration | | |
| Performance | | |
| Android | | |
| iOS | | |

## Known Issues

List any known issues here:

1.
2.
3.

## Test Sign-Off

- Tested by: _______________
- Date: _______________
- Platform: _______________
- Build version: _______________
- Status: ✅ Pass / ❌ Fail

---

**Note:** This is a comprehensive checklist. Not all items may be applicable depending on your implementation and requirements.
