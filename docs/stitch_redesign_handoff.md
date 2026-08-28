# Stitch Redesign Implementation Handoff

## Source

Implementation reference: the latest Google Stitch export supplied on 2026-08-28, covering Home, Projects, Project Case Study, Open Source, Experience, Admin, Project Editor, PDF/Resume Management, and the Technical Editorial design system.

## Branch policy

- Work on `develop`.
- `main` remains release/stable.
- Merge to `main` only after the redesign slice is coherent and CI is green.

## Current baseline

At the start of this redesign pass, `main` and `develop` pointed to the same commit (`aa6577020c536562b810f834d4a8506cf4b98fff`). Existing `develop` therefore already represented a branch created directly from current `main`; it was retained instead of deleting/recreating the ref.

## Delivery sequence

### R1 — Design foundation

- Replace the previous dark Kinetic Blueprint direction with Technical Editorial tokens.
- Update app theme tokens to warm-paper surfaces, near-black typography, restrained engineering-blue interaction color, subtle borders, disciplined radius, minimal shadows.
- Normalize typography, spacing, buttons, metadata, status chips, and responsive containers.
- Preserve accessibility and Thai fallback typography.

Acceptance:
- Home can consume the new tokens without page-specific colors.
- Existing widgets compile with no dark-theme assumptions.

### R2 — Home integration

Implement the refined Home structure:
1. compact hero
2. engineering snapshot
3. featured work
4. projects bridge
5. open-source preview
6. engineering approach
7. selected companies / experience
8. Resume + Engineering Portfolio PDF CTA
9. contact

Acceptance:
- company/product names are directly scannable
- Featured Project uses the same base component as Projects
- Home stays concise and routes to deeper content

### R3 — Projects browser

- Featured / standard / compact project presentation
- search
- project-type / technology filters
- lifecycle status
- GitHub/package actions
- backend/project-selection-driven ordering and visibility

Acceptance:
- no hardcoded repository cards
- missing GitHub fields degrade gracefully
- GitHub metadata stays secondary to portfolio-owned content

### R4 — Project Case Study

Support structured sections:
- overview
- problem / solution / why it matters
- engineering highlights
- architecture
- technical stack
- engineering decisions
- challenges & solutions
- performance with evidence only
- features
- timeline
- short code samples
- related projects

Acceptance:
- sections can be absent without empty placeholders
- long-form content uses a readable narrower measure
- not every section is rendered as a card

### R5 — Open Source + Experience

Open Source:
- package/crate/repository catalog
- registry/version/use case/technical stack
- pub.dev/crates.io/GitHub links

Experience:
- full work history
- clear company/product names
- role, period, impact, stack
- Home reuses condensed versions of the same data

### R6 — Admin project management

- repository selection
- visibility / featured / ordering
- project type / status
- portfolio-owned descriptions
- metadata show/hide controls
- case-study editor structure
- related-project relationships
- draft/publish/preview model as appropriate to current architecture

Hard rule:
GitHub sync must not overwrite portfolio-owned configuration.

### R7 — PDF / Resume

Two output modes:
- Resume: compact 1–2 page target
- Engineering Portfolio: richer multi-page output

Use the same structured data as the website.

Hierarchy:
`Website case study -> condensed portfolio PDF -> compact resume summary`

Add print-safe layout and page-break rules before visual polish.

### R8 — Final consistency + QA

Audit:
- typography
- spacing
- buttons
- cards
- status language
- technical metadata
- navigation
- breakpoints
- accessibility
- print/PDF compatibility

Run:
- formatter
- analyzer
- tests
- web build
- existing PDF tests

## Data ownership

### GitHub-synced
- repository name
- GitHub description
- stars/forks
- primary language
- topics
- license
- latest update/release

### Portfolio-owned
- display name
- custom description
- project type
- lifecycle status
- featured
- order
- engineering highlights
- case-study content
- custom image
- relationships
- public visibility
- PDF/Resume visibility

## Design source of truth

Use `design/DESIGN.md` for implementation tokens. Stitch HTML/screenshots are visual references, not code to paste wholesale into Flutter.
