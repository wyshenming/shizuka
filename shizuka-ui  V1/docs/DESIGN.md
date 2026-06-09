---
name: Shizuka UI
colors:
  surface: '#f8f9fa'
  surface-dim: '#d9dadb'
  surface-bright: '#f8f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f5'
  surface-container: '#edeeef'
  surface-container-high: '#e7e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#41484a'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#71787a'
  outline-variant: '#c1c8c9'
  surface-tint: '#41646b'
  primary: '#41646b'
  on-primary: '#ffffff'
  primary-container: '#a5cad2'
  on-primary-container: '#32565d'
  inverse-primary: '#a8cdd5'
  secondary: '#645b6b'
  on-secondary: '#ffffff'
  secondary-container: '#ebdef2'
  on-secondary-container: '#6a6171'
  tertiary: '#566246'
  on-tertiary: '#ffffff'
  tertiary-container: '#bbc9a6'
  on-tertiary-container: '#495539'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c3e9f1'
  primary-fixed-dim: '#a8cdd5'
  on-primary-fixed: '#001f24'
  on-primary-fixed-variant: '#284c53'
  secondary-fixed: '#ebdef2'
  secondary-fixed-dim: '#cec2d5'
  on-secondary-fixed: '#1f1926'
  on-secondary-fixed-variant: '#4c4453'
  tertiary-fixed: '#dae8c3'
  tertiary-fixed-dim: '#becba8'
  on-tertiary-fixed: '#141f08'
  on-tertiary-fixed-variant: '#3f4b30'
  background: '#f8f9fa'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
typography:
  display-name:
    fontFamily: Noto Serif SC
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: 0.05em
  dialogue-main:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.8'
    letterSpacing: 0.01em
  dialogue-main-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  ui-label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  ui-label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  system-msg:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  container-padding: 24px
  element-gap: 16px
  dialogue-spacing: 32px
  max-width-desktop: 800px
---

## Brand & Style
The design system is centered on the concept of "The Sound of Silence." It blends the structured clarity of Japanese minimalism with the immersive, narrative-driven aesthetic of modern visual novels (Galgames). The target audience seeks a digital sanctuary for role-playing and storytelling—an environment that feels like a quiet afternoon in a sunlit room.

The visual style is **Glassmorphic Minimalism**. It prioritizes breathability through generous white space and utilizes layered, semi-transparent surfaces to create a sense of depth without clutter. The emotional response is one of calm, intimacy, and low cognitive load, ensuring the focus remains entirely on the narrative exchange.

## Colors
The palette is derived from natural, desaturated morning tones. 
- **Primary (Soft Blue):** Used for key interaction states and the user's dialogue bubbles. It represents clarity and calm.
- **Secondary (Pale Lavender):** Reserved for character names and accents, providing a subtle "dreamlike" quality.
- **Tertiary (Mint Green):** Used sparingly for success states or secondary narrative highlights.
- **Neutral:** A range of warm whites and soft greys (#F8F9FA to #E9ECEF) to maintain a high-key, airy feel.

Avoid pure black (#000000). Use a deep charcoal-grey (#343A40) for text to keep the contrast soft and readable against pastel backgrounds.

## Typography
The typography system uses a dual-font approach to distinguish between "System/UI" and "Narrative/Character."

1.  **Narrative Layer:** Uses **Noto Serif SC** (notoSerif) for character names and chapter headings. This adds a literary, elegant touch reminiscent of high-end visual novels.
2.  **Interaction Layer:** Uses **Plus Jakarta Sans** (plusJakartaSans) for its soft, rounded terminals and high legibility. It handles all dialogue text and interface labels.

Line heights are intentionally generous (1.8 for dialogue) to ensure the text feels uncrowded and easy to digest during long reading sessions.

## Layout & Spacing
The layout follows a **Fixed Center-Column** philosophy on desktop to mimic the focused "reading zone" of a Galgame. On mobile, it transitions to a full-width fluid layout with significant safe-area margins.

- **Margins:** Desktop uses a max-width of 800px for the chat container to prevent line lengths from becoming too wide.
- **Rhythm:** A 4px base unit is used. Dialogue blocks are separated by `dialogue-spacing` (32px) to give each exchange its own "breath."
- **Gaps:** Gutters between UI elements (like sidebars or menu buttons) remain wide (16px+) to prevent an "app-heavy" feel.

## Elevation & Depth
Depth is achieved through **Tonal Stacking** and **Backdrop Blurs** rather than traditional heavy shadows.

- **Layer 0 (Base):** Solid neutral background (#F8F9FA) or a soft-focus environmental illustration.
- **Layer 1 (Panels):** White with 70% opacity and a 20px Backdrop Blur. This is used for the main chat window.
- **Layer 2 (Overlays):** White with 90% opacity, 40px Backdrop Blur, and a very soft, tinted shadow (Primary color at 10% opacity, 20px blur, 4px offset).
- **Outlines:** Instead of shadows for secondary elements, use 1px solid borders in a slightly darker shade of the background color (#E9ECEF) to define boundaries subtly.

## Shapes
The shape language is organic and soft. 
- **Containers:** All primary chat containers and panels use `rounded-xl` (1.5rem) to evoke a friendly, non-threatening atmosphere.
- **Dialogue Bubbles:** Use a distinct asymmetrical rounding (e.g., top-left, top-right, and bottom-right are 1.5rem, while bottom-left is 0.25rem for the "tail" effect).
- **Interactive Elements:** Buttons and input fields use `rounded-lg` (1rem).

## Components
- **Dialogue Bubbles:** Semi-transparent white or Primary-Light. No harsh borders. Text is padded with 16px on all sides.
- **Character Tags:** Floating labels using **Noto Serif SC** positioned slightly overlapping the top-left of the dialogue bubble. Background is a soft gradient of the Secondary color.
- **Action Buttons:** Ghost-style buttons with 1px Primary-color borders or soft pastel fills. Hover states should involve a gentle "glow" (increased shadow spread) rather than a color shift.
- **Input Field:** A single line at the bottom, appearing as a translucent bar spanning the width of the chat container. No "Send" button icon; use a simple text label "发送" (Send) in a soft UI weight.
- **Log/History View:** A full-screen overlay with a high backdrop-blur (30px) and minimal text styling, focusing on the chronological flow of the story.
- **Choices/Branching:** Large, centered buttons that appear over the chat, using the Tertiary color to signal a moment of interaction.