# Design System: The Kinetic Blueprint

## 1. Color Palette

The palette is built on deep obsidian and emerald light, focusing on ink-like depth rather than flat blacks.

| Token | Hex Code | Description |
| :--- | :--- | :--- |
| **Primary** | `#ffffff` / `#64ffda` | Pure white text with Emerald accent for CTAs. |
| **Secondary** | `#9cd1c0` | Muted emerald for secondary elements. |
| **Success** | `#5ffbd6` | Primary Container color used for success states and highlights. |
| **Error** | `#ffb4ab` | Soft red for validation and error states. |
| **Background** | `#0c1324` | Deep obsidian "Surface" color. |
| **Surface (Low)** | `#151b2d` | Used for large sectioning areas. |
| **Surface (Container)** | `#191f31` | Used for cards and interactive components. |
| **Text (Primary)** | `#dce1fb` | High-contrast "On Background" text. |
| **Text (Muted)** | `#bacac3` | Lower contrast "On Surface Variant" for body copy. |

---

## 2. Typography Scale

Editorial feel with a high-contrast typographic scale.

### Font Families
- **Headings**: `Space Grotesk` (Conveys modern engineering precision).
- **Body**: `Inter` (Optimized for legibility).
- **Technical/Accents**: `JetBrains Mono` (For metadata, tags, and code).
- **Thai Complement**: `Noto Sans Thai` or `Sarabun` (Recommended for Flutter implementation).

### Scale Details
- **Display Large/Medium**: Used for Hero sections (Space Grotesk).
- **Headline Small**: Used for project titles with tight letter spacing.
- **Body Medium (0.875rem)**: Standard description text (Inter).
- **Label Small/Medium**: Technical callouts and metadata (JetBrains Mono).

---

## 3. Spacing, Radius & Elevation

### Spacing
- **Base Scale**: 3 (Multiplier).
- **Mental Boundaries**: Use `12` (4rem) and `16` (5.5rem) tokens instead of dividers.
- **Component Padding**: `6` (2rem) for cards to ensure technical content "breathes".

### Radius (Shape)
- **Standard UI**: `ROUND_FOUR` (Sharp, technical aesthetic).
- **Buttons**: `0.125rem` (Sharp edges).
- **Technical Tags (Chips)**: `Full` (Pill-shaped) to contrast against sharp cards.

### Elevation & Depth
- **Philosophy**: Ambient lighting, no pure black shadows.
- **Hierarchy**:
    - **Base**: `surface` (#0c1324)
    - **Section**: `surface_container_low` (#151b2d)
    - **Card/Component**: `surface_container` (#191f31)
- **Floating Effects**: Highly diffused shadows (`0 20px 40px rgba(0, 0, 0, 0.3)`).

---

## 4. Component Library

### Button Styles
- **Primary**: Emerald gradient fill (`primary_container` to `secondary`) with `on_primary` text. Sharp edges.
- **Secondary**: "Ghost Border" (outline-variant at 15-20% opacity) with primary text.
- **Tertiary/Link**: High-contrast text with a 2px underline that expands on hover.

### Cards
- **Backgroud**: `surface_container`.
- **Border**: None (Shadow/Tonal shift only).
- **Interaction**: Hover shifts background to `surface_container_high` + `0.5rem` upward translation.

### Inputs & UI Elements
- **Input Fields**: Bottom-border only (`outline_variant`). Focus transitions to Emerald glow (#5ffbd6).
- **Chips**: `surface_container_highest` background with JetBrains Mono text.
- **Navigation**: Sidebar with `surface_container_lowest` background and generous vertical spacing (token 8).

---

## 5. Layout Rules

### POS & Complex Layouts
- **Tablet Landscape (1280x800+)**: Optimized for split-screen interaction.
- **Split Layout**:
    - **Left (Product Grid)**: Flexible grid for browsing portfolio items or components.
    - **Right (Sidebar/Cart)**: Sticky sidebar for metadata, contact info, or quick actions.
- **Mobile**: Clean stacked layout with focus on single-column readability.

---

## 6. Flutter Specific Design Rules

- **Material 3**: Fully utilize M3 color schemes and token systems.
- **Responsive Framework**: Use `LayoutBuilder` to respect breakpoints (Mobile < 768, Tablet 768-1199, Desktop >= 1200).
- **Large Touch Targets**: Ensure all interactive elements have a minimum size of 48x48 dp for accessibility.
- **Performance**: Use `const` constructors and optimized widget trees for 60/120fps animations.

---

## 7. Project Screens

### [Portfolio Home (Desktop)](https://lh3.googleusercontent.com/aida/ADBb0uhPUHEcNPIgflegVS964SKQNgsRQhc4LfuARpZKq7GgRMFU_ajFWBqoMhQb_MkzSpGzuIgh9EcmpyxSoKoZsLAxaZAiHmd5CN6LohVZ-zzwQwXV-JT6r219Nqs5VEvoGF117ALfmku8rdXoTn3rsDjE2m_U29I5D8jtfDLqX1DwU5vZhI0v7WyKETVsXmq8dI1X6V7vo4T28QSLJBo9TAKTWkSFSca43fZLvElibaqLyyMa0k6xuaS7M4-_)
- **Description**: A premium, high-contrast engineering portfolio featuring asymmetrical layouts and emerald accents. Emphasizes technical depth and clean editorial typography.

### [Portfolio Home (Mobile)](https://lh3.googleusercontent.com/aida/ADBb0ujI3YnB-FK6z1h475Esa_CSZOuWbU-Wi_JxtY6L-EY9QLlNqTmcxCAgVD2jOv36RlvYquqrcZNSmIgDvSiEoOUPyoWDFurnVee7j5_3MqaQGdvMtl4kBSzRWDhmYo5zOsqsRU0UuTvCF0InKhtvfQBi5mBxvmKok93THXAVT8wEyps3fP5KD5T0EBo1Aed9SUcPHU9BdBGz2bljWgb9wKkoc8Wzt98wSEwCkYwx8yluICwS-iWS4YkUjJVz)
- **Description**: Responsive adaptation of the desktop experience, maintaining the premium feel in a vertically stacked format.

### Other Strategic Screens:
- **Flutter Design Tokens**: Centralized repository of technical constants.
- **Flutter Web Portfolio Strategy**: Documenting the interaction architecture for web-specific constraints.
- **Portfolio Refinement Guide**: Rules for maintaining the "Kinetic Blueprint" aesthetic.
