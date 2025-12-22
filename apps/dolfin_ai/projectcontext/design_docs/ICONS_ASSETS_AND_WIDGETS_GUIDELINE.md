# BalanceIQ - Icons, Assets & Widgets 2026 (Minimalist)

## Executive Summary
This document defines the visual constraints for icons, assets, and widgets. The goal is "Technical Minimalism": refined geometry, abstract imagery, and uniform grids.

---

## 1. Iconography ("Fine-Line")

### 1.1 Style Logic
- **Stroke Width**: **1.5px** (Refined). Never use 2px or Filled icons for secondary actions.
- **Corner Radius**: **4px - 8px** (Squircle geometry).
- **Library**: **Heroicons (Outline)** or **Remixicon (Line)** are preferred over standard Material Icons.

### 1.2 Interactive States
- **Normal**: Neutral Grey (`#8E8E93`).
- **Active**: Primary Blue (`#2E5CFF`).
- **Pressed**: Scale down to `0.95`. Do *not* add ripples; use scale feedback.

---

## 2. Asset Strategy ("Abstract 3D")

### 2.1 The "No-Cartoon" Rule
> [!WARNING]
> Do not use character illustrations (e.g., people holding coins, unDraw style). They reduce perceived premium quality.

### 2.2 Approved Imagery
- **Glass Objects**: 3D rendered shapes (spheres, cubes, rings) with frosted glass materials and soft lighting.
- **Gradient Meshes**: Soft, flowing gradients using the "Core 5" palette (Blue/Orange/Green).
- **Usage**:
    - **Empty States**: Single floating 3D object in center.
    - **Onboarding**: Large gradient mesh background with bold typography.

---

## 3. Widget Layouts ("Bento Grid")

### 3.1 The Grid System
All dashboards and lists must adhere to the **Bento Grid** principles:
1.  **Uniform Gaps**: `16px` everywhere.
2.  **Cell Ratios**: Cards must fit `1x1`, `2x1`, or `2x2` aspect ratios.
3.  **Content Focus**: Each cell contains **one** metric or **one** chart. No cluttered "everything" cards.

### 3.2 Widget Styling
- **Background**: Very faint surface color (`#F5F5F7` Light / `#1A1A1A` Dark).
- **Elevation**: **Level 0**. No drop shadows. Use surface separation.
- **Corners**: `24px` (Continuous Curvature).

---

## 4. Animation
- **Springs**: Use `Curves.easeOutBack` or spring simulations for all modal entrances.
- **Micro-interactions**: buttons should have a `ScaleButton` wrapper that shrinks slightly (`0.98`) on tap.
