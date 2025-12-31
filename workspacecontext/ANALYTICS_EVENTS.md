# Analytics Events Catalog

This document lists all the custom analytics events implemented in the Dolfin workspace, organized by feature. These events are logged to Firebase Analytics via the `AnalyticsService` interface.

## Table of Contents
1. [Authentication](#authentication)
2. [Subscription](#subscription)
3. [Tour & Onboarding](#tour--onboarding)
4. [Settings](#settings)
5. [Chat](#chat)
6. [Transactions](#transactions)
7. [Navigation](#navigation)

---

## Authentication
**Source:** `packages/features/feature_auth/lib/presentation/cubit/login/login_cubit.dart` & `signup_cubit.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `login` | `method`: String ('email' \| 'google') | User logged in successfully. | Successful login completion. |
| `sign_up` | `method`: String ('email' \| 'google') | User signed up successfully. | Successful registration completion. |

---

## Subscription
**Source:** `packages/features/feature_subscription/lib/presentation/cubit/subscription_cubit.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `view_promotion` | `items_count`: int | User viewed the subscription plans list. | When `loadPlans` or `loadPlansAndStatus` completes successfully. |
| `begin_checkout` | `plan_name`: String<br>`auto_renew`: bool | User initiated the checkout process. | When `createSubscription` is called. |
| `purchase` | `plan_name`: String<br>`currency`: String ('USD') | User successfully purchased a subscription. | When `createSubscription` succeeds. |
| `subscription_cancel` | `plan_name`: String<br>`reason`: String | User cancelled their subscription. | When `cancelSubscription` succeeds. |

---

## Tour & Onboarding
**Source:** `packages/core/dolfin_core/lib/tour/product_tour_cubit.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `tutorial_begin` | *(None)* | User started the product tour. | When `startTour` is called. |
| `tutorial_complete` | `skipped`: bool | User finished or skipped the tour. | When `completeTour` (skipped=false) or `skipTour` (skipped=true) is called. |

---

## Settings
**Source:** `packages/core/dolfin_core/lib/currency/currency_cubit.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `select_currency` | `currency_code`: String | User changed their preferred currency. | When `setCurrency` is called. |

---

## Chat
**Source:** `packages/features/feature_chat/lib/presentation/cubit/chat_cubit.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `send_message` | `bot_id`: String<br>`has_image`: bool<br>`has_audio`: bool | User sent a message to a bot. | When `sendNewMessage` is called. |

---

## Transactions
**Source:** `apps/dolfin_ai/lib/features/home/presentation/widgets/transaction_detail_widgets/transaction_detail_modal.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `modify_transaction` | `action`: 'update'<br>`type`: String<br>`category`: String<br>`amount`: double | User updated an existing transaction. | When saving edits in Transaction Detail modal. |
| `modify_transaction` | `action`: 'delete'<br>`id`: String | User deleted a transaction. | When confirming delete in Transaction Detail modal. |

---

## Navigation
**Source:** `apps/dolfin_ai/lib/features/home/presentation/pages/home_page.dart`

| Event Name | Parameters | Description | Trigger |
| :--- | :--- | :--- | :--- |
| `screen_view` | `screen_name`: String ('dashboard') | User viewed a screen (Manually logged). | `initState` of `DashboardView`. |

---

## Verification Guide

To verify these events:
1.  Run the app with the Firebase DebugView arguments (or use a debug build properly configured).
    *   **Android:** `adb shell setprop debug.firebase.analytics.app <package_name>`
    *   **iOS:** Launch argument `-FIRDebugEnabled` in Xcode Scheme.
2.  Open **Firebase Console** > **Analytics** > **DebugView**.
3.  Perform the actions in the app (e.g., log in, change currency, start a chat).
4.  Confirm events appear in the timeline with correct parameters.
