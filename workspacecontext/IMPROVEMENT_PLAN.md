# Dolfin Workspace - Codebase Improvement Plan (Road to 10/10)

> **Status:** Draft
> **Based on:** Codebase Re-Assessment 2025 (v3.0) & Production Ready Guidelines

This plan outlines the specific tasks required to bridge the gap from the current **9.5/10** score to a perfect **10/10** production-ready state.

## 1. Security Hardening (Current: 9.0/10)

**Goal:** Achieve banking-grade security standards.

- [ ] **Certificate Pinning**
  - Implement SHA-256 certificate pinning in `DioClient`.
  - Configurable for different environments (strict in production).
- [x] **Database Encryption**
  - Migrate from standard `sqflite` to `sqflite_sqlcipher`.
  - Securely manage encryption keys using `flutter_secure_storage`.
- [x] **Biometric Authentication**
  - Implement `local_auth` for sensitive actions (e.g., viewing card details, large transactions).
- [x] **Code Obfuscation & Hardening**
  - Configure `ProGuard` rules for Android.
  - Verify symbolication setup for crash reporting.

## 2. Testing Excellence (Current: 8.8/10)

**Goal:** Reach >80% code coverage and implement robust visual regression testing.

- [ ] **Widget Testing Expansion** (Target: 80% coverage)
  - Write widget tests for all core UI components in `dolfin_ui_kit`.
  - Cover complex feature widgets (ChatBubble, SubscriptionCard).
- [ ] **Integration Testing** (Target: 15+ tests)
  - Automate full user flows:
    - Login → Dashboard → Chat.
    - Subscription Purchase Flow.
    - Offline Sync Flow.
- [ ] **Golden Tests** (Target: 20+ scenarios)
  - Set up `golden_toolkit` or standard flutter goldens.
  - Create snapshots for all major app themes (Light/Dark) and device sizes.
- [ ] **DI Validation Tests**
  - Create a test to verify the dependency graph ensures no missing dependencies at runtime.

## 3. Dependency Injection (Current: 9.0/10)

**Goal:** Automate and validate dependency management.

- [ ] **Migrate to `injectable`**
  - Replace manual `GetIt` registration with `@Injectable` annotations.
  - Use environments to switch between Mock/Real implementations cleanly.
  - Eliminate boilerplate registration code.

## 4. Performance Optimization (Current: 8.0/10)

**Goal:** Ensure 60fps consistent performance and optimized resource usage.

- [ ] **Rendering Optimization**
  - Audit widget tree for unnecessary rebuilds.
  - Apply `RepaintBoundary` to complex animations and list items.
- [ ] **Image Caching Strategy**
  - Implement `cached_network_image` with custom cache manager constraints.
- [ ] **Bundle Size Optimization**
  - Analyze app bundle size.
  - Implement deferred loading for non-critical features if necessary.

## 5. Error Handling & Observability (Current: 8.5/10)

**Goal:** Proactive error monitoring and self-healing.

- [ ] **Global Error Handler**
  - Hook into `FlutterError.onError` and `PlatformDispatcher.instance.onError`.
- [ ] **Retry Policies**
  - Implement exponential backoff for network requests using `retry` package or custom interceptor.
- [ ] **User Feedback Loop**
  - Ensure all errors map to user-friendly, localized messages (already partially done, verify coverage).

## 6. Future: App Store Publishing (Pre-Launch)

**Goal:** Prepare for successful App Store verification and launch.

- [ ] **Developer Account**
  - Enroll in the Apple Developer Program ($99/year).
  - Invite team members if necessary (Development vs. Distribution roles).
- [ ] **App Store Connect Setup**
  - Create the App Record in App Store Connect with Bundle ID `com.dolfinmind.balanceiq`.
  - Fill in App Privacy Details (use `PrivacyInfo.xcprivacy` as reference).
  - Prepare Marketing Assets (Screenshots for 6.5" and 5.5" iPhones, App Icon 1024x1024).
- [ ] **TestFlight Beta**
  - Archive specific "Beta" build.
  - Set up Internal Testing group.
  - Validate In-App Purchases in Sandbox environment.
- [ ] **Review Guidelines Compliance**
  - Verify "Sign in with Apple" implementation (Required if Google Sign-In is used).
  - Verify Delete Account functionality is visible and functional within the app.
  - Ensure Subscription terms and policies are linked in the paywall.

## 7. Verification Steps

To validate the completion of these improvements:
1.  **Security Audit:** Run automated security scan (if available) and manual verification of encrypted DB access.
2.  **Coverage Report:** Generate `lcov` report to confirm >80% coverage.
3.  **Golden Diff:** Run golden tests to ensure no visual regressions.
4.  **Performance Profiling:** Record timeline traces for critical interactions (scrolling, navigation).

---

## Next Immediate Actions

1.  **Approval:** Review and approve this improvement plan.
2.  **Prioritization:** Select the first area of focus (Recommend: **Testing** or **Security**).
3.  **Execution:** Begin implementation of high-priority tasks.
