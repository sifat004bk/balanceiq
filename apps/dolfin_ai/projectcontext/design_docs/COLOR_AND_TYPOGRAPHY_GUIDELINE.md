# BalanceIQ - Design System 2026 (Minimalist)

## Executive Summary
This document defines the **2026 Minimalist Design Language** for BalanceIQ. It supersedes previous Material 3 guidelines, prioritizing reduced visual noise, strict color discipline, and "Flat-Glass" aesthetics to create a premium fintech experience.

---

## 1. Minimalist Color System

### 1.1 The "Core 5" Palette
To maintain extreme simplicity while supporting essential financial contexts, we strictly limit the palette to these 5 roles.

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| **Trust (Primary)** | **Electric Blue** | `#2E5CFF` | Primary Actions, Links, Brand Identity. |
| **Spark (Accent)** | **Vibrant Orange** | `#FF6F00` | *Sparse* use: High-priority Alerts, Feature Highlights. |
| **Income (Semantic)** | **Growth Green** | `#00C853` | Income, Positive Trends, Success States. |
| **Expense (Semantic)**| **Alert Red** | `#D32F2F` | Expenses, Negative Trends, Errors. |
| **Surface (Canvas)** | **Adaptive** | `#FAFBFC` (Light) / `#000000` (Dark) | The main background. |

> [!IMPORTANT]
> **No Rainbow Categories**: Do not use distinct colors for 10+ categories. Use **Neutral Grey** (`#8E8E93`) icon containers for all categories, or map them to one of the Core 5 (e.g., Shopping = Expense Red, Salary = Income Green).

### 1.2 Dark Mode Strategy ("True Black")
- **Background**: `#000000` (OLED Black).
- **Cards**: `#121212` with `0.5px` border (`#333333`).
- **Text**: White (`#FFFFFF`) for primary, Grey (`#8E8E93`) for secondary.
- **Avoid Neon Bleed**: Keep backgrounds desaturated. Only the text/icons should be vibrant.

### 1.3 Glassmorphism 2.0 ("Flat-Glass")
We use a refined, lightweight glass effect.
- **Opacity**: `0.05` (5%) to `0.08` (8%). *Barely visible.*
- **Blur**: `BackdropFilter` sigma `10`.
- **Border**: `0.5px` solid border (`Colors.white.withOpacity(0.1)`).
- **Usage**: Only for **Input Fields** and **Floating Modals**. Dashboard cards should be solid or extremely subtle gradient surfaces.

---

## 2. Typography System (Fluid)

### 2.1 Font Family
**Google Sans** (Display) + **Google Sans Text** (Body).
*Fallback*: System San Francisco / Roboto.

### 2.2 Simplified Hierarchy
Instead of 15 Material tokens, we use 4 dynamic roles.

| Role | Weight | Size (Dynamic) | Line Height | Usage |
|------|--------|----------------|-------------|-------|
| **Hero** | Light (`w300`) | `48sp` - `64sp` | 1.1 | Main Balance, Onboarding Titles. |
| **Heading**| SemiBold (`w600`)| `20sp` - `24sp` | 1.3 | Section Headers, Card Titles. |
| **Body** | Regular (`w400`) | `16sp` | 1.6 | Reviewable text (Chat, Lists). |
| **Detail** | Medium (`w500`) | `13sp` | 1.4 | Timestamps, Labels, Captions. |

> [!TIP]
> **Whitespace is Typography**: Increase `SizedBox` heights between text elements (recommend `24px` minimum) to let the typography breathe.

---

## 3. Gradients
Use gradients *only* for "Hero" moments, not generic UI elements.

- **Blue Beam**: `LinearGradient(colors: [Color(0xFF2E5CFF), Color(0xFF00E5FF)])`
- **Orange Spark**: `LinearGradient(colors: [Color(0xFFFF6F00), Color(0xFFFF9100)])`

---

## 4. Accessibility
- **Contrast**: All text must meet WCAG AA (4.5:1).
    - *Note*: White text on `#2E5CFF` passes.
    - *Note*: Grey text on Black must use `#8E8E93` or lighter.
