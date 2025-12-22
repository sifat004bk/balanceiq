# Migration Checklist: Monorepo Transition

## Phase 1: Workspace Initialization
- [ ] Install Melos globally: `dart pub global activate melos`
- [ ] Create workspace root directory
- [ ] Create `melos.yaml`
- [ ] Create `apps/` and `packages/` directories
- [ ] Move existing `balance_iq` project into `apps/balance_iq`
- [ ] Fix relative paths in `apps/balance_iq` (if any rely on being root)

## Phase 2: Core Package Extraction
### Package: `balance_core`
- [ ] Create `packages/core/balance_core`
- [ ] Move `lib/core/error`
- [ ] Move `lib/core/network` (NetworkInfo, Dio setup)
- [ ] Move `lib/core/usecases`
- [ ] Move `lib/core/utils` (Logger, Validator)
- [ ] Move `lib/core/storage` (SecureStorage)
- [ ] Verify `balance_core` builds and tests pass
- [ ] Update `apps/balance_iq` to depend on `balance_core`

### Package: `balance_ui_kit`
- [ ] Create `packages/core/balance_ui_kit`
- [ ] Move `lib/core/theme` (AppPalette, Theme logic)
- [ ] Update `apps/balance_iq` to depend on `balance_ui_kit`

## Phase 3: Feature Package Extraction
### Package: `feature_auth`
- [ ] Create `packages/features/feature_auth`
- [ ] Define `AuthConfig` interface (urls, logo, callbacks)
- [ ] Move `lib/features/auth` code
- [ ] Refactor `AuthRepository` to be generic or configurable
- [ ] Remove hardcoded GoRouter routes from package
- [ ] Update `apps/balance_iq`

### Package: `feature_chat`
- [ ] Create `packages/features/feature_chat`
- [ ] Define `ChatConfig` (Persona name, avatar, prompts)
- [ ] Move `lib/features/chat` code
- [ ] Ensure `Gemini` API key is injected, not hardcoded
- [ ] Update `apps/balance_iq`

### Package: `feature_subscription`
- [ ] Create `packages/features/feature_subscription`
- [ ] Define `SubscriptionConfig` (products, revenuecat keys)
- [ ] Move logic
- [ ] Update `apps/balance_iq`

## Phase 4: Clean Up & Verification
- [ ] Run `melos bootstrap`
- [ ] Run `melos analyze` across all packages
- [ ] Run `melos test`
- [ ] Verify `balance_iq` app (manual testing)
