# AGENTS.md

This repository is a Flutter Web portfolio project.

## Primary goal

Build a polished portfolio website with:
- Flutter Web
- JSON-driven content
- strong visual inspiration from Brittany Chiang v4 style language
- implementation adapted to Flutter widgets and responsive layout
- minimal but clean architecture

## Architecture rules

- Keep the app lightweight. This is a content-driven portfolio, not a large CRUD app.
- Use feature-first structure.
- Keep content in `assets/content/portfolio_content.json`.
- Do not hardcode user-facing content in widgets unless it is a fallback.
- Presentation widgets should focus on layout and rendering only.
- Theme tokens belong in `lib/app/theme/`.
- Reusable section widgets should be extracted once duplication is visible.
- Avoid unnecessary abstraction, repositories, and use cases unless they clearly improve maintainability.

## Visual rules

- Primary source: Follow the "The Kinetic Blueprint" system in `design/DESIGN.md`.
- Reference Brittany Chiang's visual system for general composition, but prioritize `design/DESIGN.md` tokens.
- Preserve a dark, elegant, technical mood.
- Use high contrast text, muted body copy, and one accent color.
- Prefer generous spacing and restrained motion.
- Desktop should feel premium and airy; mobile should become a clean stacked layout.

## Responsiveness

Target these breakpoints:
- mobile: < 768
- tablet: 768-1199
- desktop: >= 1200

## Accessibility

- Ensure keyboard navigability.
- Provide semantic labels for external links and icons.
- Keep color contrast high.
- Avoid relying on hover as the only interaction state.

## Content model

Content is loaded from JSON and should support:
- site metadata
- hero
- about
- skills
- experience
- featured projects
- other projects
- contact
- social links

## Preferred workflow in Anti Gravity

1. Read `design/DESIGN.md` to understand design tokens and system details.
2. Read `docs/project_plan.md`
2. Read the current JSON schema
3. Implement one section at a time
4. Keep commits small and reviewable
5. After each section, do a coherence pass for spacing, typography, and responsive behavior

