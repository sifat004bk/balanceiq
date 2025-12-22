# Complete Theme Design Concepts for BalanceIQ (2025/2026)

This document outlines 5 fully realized theme concepts. Each concept includes a comprehensive color palette, typography system, and component styling guide.

> [!NOTE]
> All themes assume **Manrope** as the primary font family but with adjusted weights and scaling per theme.

---

## 1. Midnight Slate (The Modern Standard)
**Vibe**: Professional, Clean, Developer-tool aesthetic (Linear, Vercel).
**Best For**: Users who want a modern, fatigue-free interface that feels "tech-savvy" but serious.

### 🎨 Color Palette
| Token | Color Name | Hex | Usage |
| :--- | :--- | :--- | :--- |
| **Background** | `Slate 950` | `#020617` | App Scaffold |
| **Surface** | `Slate 900` | `#0F172A` | Cards, Inputs, Sheets |
| **Surface Highlight**| `Slate 800` | `#1E293B` | Hover states, Borders |
| **Primary** | `Indigo 500` | `#6366F1` | Main Actions, Active States |
| **Secondary** | `Sky 400` | `#38BDF8` | Accents, Charts, Gradients |
| **Destructive** | `Rose 500` | `#F43F5E` | Errors, Delete |
| **Success** | `Emerald 500`| `#10B981` | Success states, Positive Balance |

### ✒️ Typography & Text Colors
| Token | Hex | Config |
| :--- | :--- | :--- |
| **Text Primary** | `#F8FAFC` (Slate 50) | Weight: 600 for headers, 500 for body |
| **Text Secondary** | `#94A3B8` (Slate 400)| Weight: 400 |
| **Text Tertiary** | `#64748B` (Slate 500)| Weight: 400 |

### 🧩 Component Styles
- **Border Radius**: `12px` (Medium rounded) - Strikes a balance between serious and friendly.
- **Borders**: Thin, subtle borders (`1px solid #1E293B`) on all cards to define edges without heavy shadows.
- **Shadows**: Very soft, diffuse shadows (`0 4px 6px -1px rgba(0, 0, 0, 0.1)`).

---

## 2. OLED Neon Growth (The Trader)
**Vibe**: High Contrast, Financial, Cyberpunk, Data-first (Robinhood, Cash App).
**Best For**: Users who care about data clarity, battery life, and a "terminal" feel.

### 🎨 Color Palette
| Token | Color Name | Hex | Usage |
| :--- | :--- | :--- | :--- |
| **Background** | `True Black` | `#000000` | App Scaffold (OLED Friendly) |
| **Surface** | `Dark Grey` | `#121212` | Cards, Inputs |
| **Surface Highlight**| `Graphite` | `#1E1E1E` | Secondary Surface |
| **Primary** | `Neon Mint` | `#00E676` | Primary Actions, Positive Growth |
| **Secondary** | `Electric Purple`| `#651FFF` | AI Features, Secondary Actions |
| **Destructive** | `Neon Red` | `#FF1744` | Negative Balance, Errors |
| **Warning** | `Cyber Yellow`| `#FFEA00` | Alerts |

### ✒️ Typography & Text Colors
| Token | Hex | Config |
| :--- | :--- | :--- |
| **Text Primary** | `#FFFFFF` (Pure White) | Weight: 700 for numbers, 500 for text |
| **Text Secondary** | `#B0B0B0` (Light Grey)| Weight: 400 |
| **Text Tertiary** | `#757575` (Dark Grey) | Weight: 400 |

### 🧩 Component Styles
- **Border Radius**: `4px` or `8px` (Sharp/Small) - Technical, precise look.
- **Borders**: No borders on cards, relying on high contrast between `#000000` and `#121212`.
- **Shadows**: None (Flat design) or sharp hard shadows.

---

## 3. Royal Obsidian (The Premium Card)
**Vibe**: Luxury, Exclusive, Wealth, Warmth (Amex Black, Cred).
**Best For**: Users who treat finance as a lifestyle; premium experience.

### 🎨 Color Palette
| Token | Color Name | Hex | Usage |
| :--- | :--- | :--- | :--- |
| **Background** | `Obsidian` | `#100C08` | Very warm, almost brown-black |
| **Surface** | `Charcoal` | `#1C1917` | Cards with minimal contrast |
| **Surface Highlight**| `Tungsten` | `#292524` | Inputs, Active states |
| **Primary** | `Gold Leaf` | `#D4AF37` | Luxury accents, CTA |
| **Secondary** | `Bronze` | `#CD7F32` | Secondary data points |
| **Tertiary** | `Silk` | `#E7E5E4` | Soft white highlights |

### ✒️ Typography & Text Colors
| Token | Hex | Config |
| :--- | :--- | :--- |
| **Text Primary** | `#E7E5E4` (Warm White)| Font: **Playfair Display** (Headings) + Manrope (Body) |
| **Text Secondary** | `#A8A29E` (Warm Grey)| Weight: 300 (Light) |

### 🧩 Component Styles
- **Border Radius**: `24px` (Highly rounded) - Soft, organic, premium feel.
- **Borders**: Gradient borders (Gold to Transparent) using custom painters.
- **Effects**: Subtle "Noise" texture overlay on backgrounds for tactile feel.

---

## 4. Nebula Glass (The AI Futurist)
**Vibe**: Futuristic, Transparency, Depth, Glowing (Gemini, Siri 2.0).
**Best For**: Emphasizing the "IQ" and AI capabilities of BalanceIQ.

### 🎨 Color Palette
| Token | Color Name | Hex | Usage |
| :--- | :--- | :--- | :--- |
| **Background** | `Deep Space` | `#0B0418` | Dark Violet-Black |
| **Surface** | `Glass Plum` | `#1E1B2E` | Base layer for glass cards |
| **Glass Layer** | `Flux` | `rgba(255, 255, 255, 0.05)` | Glassmorphism overlays |
| **Primary** | `Fuchsia` | `#D946EF` | AI Triggers, Primary Buttons |
| **Secondary** | `Cyan` | `#06B6D4` | Data visualizations |
| **Glow** | `Violet` | `#8B5CF6` | Background glow effects |

### ✒️ Typography & Text Colors
| Token | Hex | Config |
| :--- | :--- | :--- |
| **Text Primary** | `#E2E8F0` (Cool White) | Weight: 400 (Clean) |
| **Text Secondary** | `#94A3B8` (Blue Grey) | Weight: 300 |
| **Text Gradient**| `Fuchsia->Cyan` | Used for "BalanceIQ" headers and AI text |

### 🧩 Component Styles
- **Border Radius**: `20px` (Soft modern).
- **Glassmorphism**: Backdrop blur (`10px`) + white borders with low opacity (`0.1`).
- **Gradients**: Heavy use of mesh gradients in backgrounds.

---

## 5. Nordic Frost (The Minimalist)
**Vibe**: Calm, Serene, Focused, Arctic (Things 3, Notion Dark).
**Best For**: Anxiety-free finance management.

### 🎨 Color Palette
| Token | Color Name | Hex | Usage |
| :--- | :--- | :--- | :--- |
| **Background** | `Nordic Navy` | `#18202F` | Deep desaturated blue |
| **Surface** | `Frost Blue` | `#222D3E` | Lighter navy surface |
| **Surface Highlight**| `Glacier` | `#2D3B52` | Inputs, Hover |
| **Primary** | `Arctic Teal` | `#5EEAD4` | Fresh, calming primary |
| **Secondary** | `Soft Indigo` | `#818CF8` | Secondary accents |
| **Text Primary** | `#F0F9FF` | Very cool white |

### ✒️ Typography & Text Colors
| Token | Hex | Config |
| :--- | :--- | :--- |
| **Text Primary** | `#F0F9FF` | Weight: 500 |
| **Text Secondary** | `#94A3B8` | Weight: 400 |

### 🧩 Component Styles
- **Border Radius**: `16px` (Standard Rounded).
- **Design**: "Flat 2.0" - No shadows, but subtle color differences to show depth.
- **Layout**: Spacious padding (`24px` standard) to promote calmness.
