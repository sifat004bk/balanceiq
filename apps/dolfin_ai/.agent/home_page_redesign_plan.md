# Home Page Redesign - Material 3 Expressive with 2025 Color Trends

## Overview

Reimagine the BalanceIQ home page with a modern Material 3 Expressive design incorporating 2025 color trends. The structure remains the same, but visual styling will be significantly updated for a more engaging, premium feel.

## Design Research Summary

### Material 3 Expressive (2025)
- **Bold, Expressive Colors**: Vibrant purples, blues, pinks for visual energy
- **Enhanced Dynamic Color**: Higher chroma, richer palettes
- **Emotional Impact**: Interfaces that evoke feeling and connection
- **Prismic Darks**: Dark mode with depth and subtle glow effects

### 2025 Color Trends
- **Warm & Earthy Tones**: Mocha Mousse (Pantone 2025), terracotta, deep greens
- **Ethereal Blues**: Soft, calming otherworldly blues
- **Muted Neutrals + Bright Accents**: Cream/taupe base with neon/coral accents
- **Metallic Finishes**: Subtle gold, silver hints for luxury feel
- **Deep Rich Colors**: Emerald green, burgundy, deep blue

---

## Proposed Color Palette

### Primary Palette

| Role | Light Mode | Dark Mode | Usage |
|------|------------|-----------|-------|
| **Primary** | `#6750A4` (Deep Purple) | `#D0BCFF` | Main actions, FAB, accents |
| **Primary Container** | `#EADDFF` | `#4F378B` | Elevated surfaces, active states |
| **Secondary** | `#625B71` | `#CCC2DC` | Supporting UI elements |
| **Tertiary** | `#7D5260` (Warm Rose) | `#EFB8C8` | Highlight, personality |
| **Accent Gradient** | Purple → Blue | Purple → Pink | Hero sections, cards |

### Semantic Colors

| Role | Light Mode | Dark Mode |
|------|------------|-----------|
| **Income** | `#00C853` (Vibrant Green) | `#69F0AE` |
| **Expense** | `#FF5252` (Coral Red) | `#FF8A80` |
| **Neutral** | `#625B71` | `#938F99` |

### Surface & Background

| Role | Light Mode | Dark Mode |
|------|------------|-----------|
| **Background** | `#FEF7FF` (Warm Off-white) | `#1C1B1F` (Deep charcoal) |
| **Surface** | `#FFFBFE` | `#2B2930` |
| **Surface Variant** | `#E7E0EC` | `#49454F` |

---

## Proposed Changes

### Core Theme
#### [MODIFY] app_theme.dart

- Update color palette from green-focused to Material 3 Expressive purple-based scheme
- Add new color roles: `primaryContainer`, `secondaryContainer`, `tertiary`, `tertiaryContainer`
- Add gradient definitions for hero sections
- Update semantic colors (income green, expense coral)
- Implement new surface colors with warm undertones
- Add color tokens for the new design system

---

### Home Page Widgets

#### [MODIFY] balance_card_widget.dart

- Add gradient background (subtle purple → blue shimmer)
- Implement glassmorphism effect for income/expense cards
- Add subtle glow shadow behind net balance
- Update income/expense icon containers with new semantic colors
- Add micro-animations on value changes

#### [MODIFY] home_appbar.dart

- Profile avatar with gradient border ring
- Date selector with pill-shaped container + subtle shadow
- Theme toggle with animated icon transition
- Subtle blur background when scrolled

#### [MODIFY] category_breakdown_widget.dart

- Update category cards with new color palette
- Add gradient icon backgrounds
- Implement subtle hover/tap animations
- Add glassmorphism card effect for dark mode

#### [MODIFY] spending_trend_chart.dart

- Update chart colors to match new palette
- Add gradient fills under chart lines  
- Implement glow effect on data points

#### [MODIFY] accounts_breakdown_widget.dart

- Update account cards with new styling
- Add metallic accent for account icons
- Implement new card border styling

#### [MODIFY] financial_ratio_widget.dart

- Update progress indicators with gradient colors
- Add animated fills
- New color coding for ratio indicators

#### [MODIFY] biggest_expense_widget.dart & biggest_income_widget.dart

- Update card styling with new semantic colors
- Add subtle gradient backgrounds
- Implement new icon styling

#### [MODIFY] transaction_history_widget.dart

- Update transaction list styling
- Add new color coding for transaction types
- Implement modern list item design

#### [MODIFY] floating_chat_button.dart

- Update with new primary color
- Add gradient fill or glow effect
- Modern FAB styling with shadow depth

---

### Date Selector Modal
#### [MODIFY] date_selector_bottom_sheet.dart

**Major Redesign:**
- **Container**: Larger border radius (32px), subtle gradient background
- **Handle Bar**: Gradient colored handle instead of grey
- **Title**: Larger, bolder with subtle text shadow
- **Preset Chips**: 
  - Gradient borders on selection
  - Pill-shaped with rounded corners (16px)
  - Hover/tap animation with scale
  - Selected state with primary container color
- **Custom Range**: 
  - Modern list tile with gradient icon container
  - Animated chevron on tap
- **Visual Enhancements**:
  - Add subtle decorative blur circles in background
  - Glassmorphism for cards in dark mode

---

## Visual Style Guide

### Typography Enhancements
- Keep Manrope font family
- Increase display font weights for impact
- Add subtle letter-spacing adjustments

### Border Radius
- **Small Elements**: 8-12px
- **Cards**: 16-20px  
- **Bottom Sheets/Modals**: 28-32px
- **Pills/Chips**: 50px (fully rounded)

### Shadows & Elevation
- **Light Mode**: Subtle, diffused shadows with slight color tint
- **Dark Mode**: Glow effects using primary color at low opacity

### Animations
- Micro-interactions on all interactive elements
- Smooth 200-300ms transitions
- Spring-based animations for scale effects

---

## Decisions Required

1. **Color Palette**: New design shifts from green primary (`#2bee4b`) to purple-based Material 3 Expressive (`#6750A4`). Confirm this direction aligns with your brand.

2. **Gradients**: Plan includes subtle gradients on hero elements (balance card, FAB). Preference for gradient vs flat design?

3. **Glassmorphism**: Dark mode will use glass-like blur effects on cards. Adds depth but slightly more rendering. Enable this effect?
