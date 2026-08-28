# AGENTS.md

This repository is a Flutter Web engineering portfolio project.

## Primary goal

Build a polished portfolio website with:
- Flutter Web
- JSON-driven content
- a premium technical-editorial visual system
- first-class GitHub/open-source project presentation
- engineering case studies
- admin-driven project selection and overrides
- printable Resume / Engineering Portfolio PDF output
- minimal but clean architecture

## Architecture rules

- Keep the app lightweight. This is a content-driven portfolio, not a large generic CMS.
- Use feature-first structure.
- Keep user-facing portfolio data JSON-driven; do not hardcode content in presentation widgets except explicit fallbacks.
- Presentation widgets should focus on layout and rendering only.
- Theme tokens belong in `lib/app/theme/`.
- Reusable section widgets should be extracted once duplication is visible.
- Avoid unnecessary abstraction, repositories, and use cases unless they clearly improve maintainability.
- GitHub-synced data and portfolio-owned override data must remain separate.
- GitHub sync must never silently overwrite portfolio-owned descriptions, featured state, ordering, case studies, images, or PDF visibility.

## Visual rules

- Primary source: follow `design/DESIGN.md` (Technical Editorial system).
- Preserve a warm, editorial, technically precise mood.
- Use warm neutral backgrounds, near-black text, restrained blue interaction accents, subtle borders, and minimal shadows.
- Use Geist-style sans typography for narrative content and JetBrains Mono-style treatment for technical metadata.
- Prefer generous spacing and restrained motion.
- Do not use glassmorphism, neon/hacker visuals, giant gradients, decorative code backgrounds, skill progress bars, or colorful logo walls.
- Desktop should feel premium and airy; mobile should become a clean stacked layout.
- PDF output should feel like a print transformation of the same product.

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
- Do not rely on color alone for project lifecycle/status.

## Content model

Content should support:
- site metadata
- hero
- engineering snapshot
- about / engineering approach
- skills
- experience / selected companies
- featured projects
- broader project catalog
- open-source packages/crates
- project case studies
- contact
- social links
- PDF / Resume visibility and ordering

## Public information architecture

Public screens should converge on:
- Home
- Projects
- Project Case Study
- Open Source
- Experience
- About
- Contact

Home should remain concise and route visitors deeper rather than duplicate every section.

## Preferred workflow

1. Read `design/DESIGN.md`.
2. Read `docs/project_plan.md` and the current implementation handoff.
3. Read the current JSON schema and project-selection data.
4. Implement one coherent slice at a time.
5. Keep commits small and reviewable.
6. Run format/analyze/tests before push when tooling is available.
7. After each slice, do a coherence pass for spacing, typography, responsive behavior, status terminology, and print compatibility.
