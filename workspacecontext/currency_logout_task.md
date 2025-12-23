# Task Plan: Currency & Logout Integration

**Objective**: Integrate the `update_currency` and `logout` APIs and enforce currency selection validation in the Chat feature.

## Phase 1: Authentication Feature (`packages/features/feature_auth`)

### 1. Data Layer Implementation
- [ ] **Update `AuthApiService`**:
    - [ ] Add `PATCH /api/auth/currency` endpoint definition.
    - [ ] Add `POST /api/auth/logout` endpoint definition.
- [ ] **Update `AuthRemoteDataSource`**:
    - [ ] Implement `updateCurrency(String currency)` method.
    - [ ] Implement `logout()` method.
- [ ] **Update `AuthRepository` & Implementation**:
    - [ ] Add `updateCurrency(String currency)` to interface and implementation.
    - [ ] Add `logout()` to interface and implementation.

### 2. Domain Layer Implementation
- [ ] **Create Use Cases**:
    - [ ] Create `UpdateCurrencyUseCase` (accepts currency code).
    - [ ] Create `LogoutUseCase` (void).

## Phase 2: UI Wiring & Logic Connection

### 3. Logout Implementation
- [ ] **Update `SessionCubit`** (or `LogoutButton` logic):
    - [ ] Inject `LogoutUseCase`.
    - [ ] Call `logout()` API before performing local session cleanup (clearing tokens/storage).

### 4. Currency Update Implementation
- [ ] **Update `ProfilePage` logic**:
    - [ ] When currency is selected in the picker:
        - [ ] Call `authRepository.updateCurrency(code)` to update server.
        - [ ] Call `currencyCubit.setCurrency(currency)` to update local state/prefs.
    - [ ] Ensure error handling (e.g., if API fails, revert local change or show snackbar).

## Phase 3: Chat Feature (`packages/features/feature_chat`)

### 5. Chat Validation Enforecement
- [ ] **Update `ChatRepositoryImpl`**:
    - [ ] Catch 400 Bad Request with message "Please set your preferred currency...".
    - [ ] Return specific `ChatFailure(ChatFailureType.currencyRequired)`.
- [ ] **Update `ChatCubit`**:
    - [ ] Map `ChatFailureType.currencyRequired` to `ChatErrorType.currencyRequired`.
- [ ] **Update `ChatErrorWidget`**:
    - [ ] Handle `ChatErrorType.currencyRequired`.
    - [ ] Show "Currency Required" error UI.
    - [ ] Add "Set Currency" button navigating to `/profile`.

## Phase 4: Verification

### 6. Testing
- [ ] **Manual Verification**:
    - [ ] Test Logout: Verify API call is made and local session cleared.
    - [ ] Test Currency Update: Change currency in Profile, verify API call and local update.
    - [ ] Test Chat Block:
        - [ ] Clear currency (if possible) or create a new user without currency.
        - [ ] Try to chat.
        - [ ] Verify "Currency Required" error screen appears.
        - [ ] Verify "Set Currency" button redirects to Profile.
