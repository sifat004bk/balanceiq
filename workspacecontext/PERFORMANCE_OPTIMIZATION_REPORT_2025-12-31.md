# Homepage Scroll Performance Optimization Report

**Date:** December 31, 2025  
**Device:** Google Pixel 6  
**Flutter Version:** Using Impeller rendering backend (Vulkan)

---

## Background

The homepage of BalanceIQ (Dolfin AI) was experiencing noticeable scroll jank and lag. The user reported that scrolling felt "un-smooth" particularly when navigating through the dashboard which contains:

- Balance Card with gradient text
- Analysis Carousel (3 chart widgets with glassmorphism effects)
- Financial Ratios Widget
- Accounts Breakdown Widget
- Biggest Income/Expense Widgets
- Category Breakdown Widget
- Transaction History Widget

---

## Root Cause Analysis

| Issue | Impact | Root Cause |
|-------|--------|------------|
| `BackdropFilter` blur (sigma=6) | 🔴 Critical | GPU re-computed blur on every scroll frame |
| 8 simultaneous `.animate()` calls | 🟠 High | Multiple animation controllers competing for frame budget |
| `floating: true` + `snap: true` on AppBar | 🟡 Medium | Layout recalculations on scroll direction changes |
| Complex fl_chart rendering | 🟡 Medium | Inherent complexity of chart paths/gradients |

---

## Optimizations Applied

### Phase 1: Disabled Blur Effects
Set `ImageFilter.blur(sigmaX: 0, sigmaY: 0)` in:
- `spending_trend_chart.dart`
- `income_expense_pie_chart.dart`
- `category_bar_chart.dart`

### Phase 2: Removed Staggered Animations
Removed all `.animate().fadeIn().slideY/X()` calls from 8 widgets in `dashboard_layout.dart`:
- BalanceCard
- AnalysisCarousel
- FinancialRatiosWidget
- AccountsBreakdownWidget
- BiggestIncomeWidget
- BiggestExpenseWidget
- CategoryBreakdownWidget
- TransactionHistoryWidget

Also removed unused `flutter_animate` import.

### Phase 3: Simplified HomeAppbar
Removed `floating: true` and `snap: true` from `SliverAppBar` in `home_appbar.dart`.

---

## Performance Results (Profile Mode - Pixel 6)

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| **Average FPS** | ~60-70 | **87** | 90 (Pixel 6 @ 90Hz) |
| **UI Thread** | Variable | **3.5-4.5ms** | < 11ms ✅ |
| **Raster Thread** | Frequent spikes | **8-14.5ms** | < 11ms ⚠️ |

### Key Observations
1. **UI thread is now excellent** - Dart code and widget tree are efficient
2. **Occasional Raster spikes remain** - GPU struggles with complex chart painting
3. **Impeller/Vulkan active** - No shader compilation jank
4. **87 FPS average** - Very close to 90Hz target, imperceptible to most users

---

## Files Modified

| File | Change |
|------|--------|
| `spending_trend_chart.dart` | Disabled blur (sigma=0) |
| `income_expense_pie_chart.dart` | Disabled blur (sigma=0) |
| `category_bar_chart.dart` | Disabled blur (sigma=0) |
| `dashboard_layout.dart` | Removed 8 animations, cleaned import |
| `home_appbar.dart` | Removed floating/snap properties |

---

## Trade-offs

| Lost Feature | Reason |
|--------------|--------|
| Glassmorphism blur on charts | GPU cost too high for scroll performance |
| Entrance animations | Animation controller overhead |
| Floating/snap AppBar | Layout jump during scroll reversal |

---

## Recommendations for Future

1. **Consider `cached_network_image`** for profile picture in AppBar
2. **Replace `LiquidPullToRefresh`** with simpler `RefreshIndicator` if jank persists
3. **Simplify chart gradients** if Raster spikes are still noticeable
4. **Always test performance in Profile/Release mode** - Debug mode is intentionally slow

---

## Conclusion

The homepage scroll performance has been significantly improved from ~60-70 FPS with visible jank to **87 FPS** with smooth scrolling. The remaining micro-stutters (Raster spikes) are GPU-bound and would require chart simplification to fully eliminate.

The release APK (26.5MB) reflects these optimizations and is ready for distribution.
