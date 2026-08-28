# Design System: Technical Editorial

## 1. Direction

The portfolio uses a premium technical-editorial visual system for a senior engineer. The design prioritizes clarity, real engineering evidence, structured metadata, and print readiness over decoration.

Principles:
- clarity over clutter
- strong editorial hierarchy
- technical metadata as supporting information
- subtle borders and tonal surfaces instead of heavy shadows
- one restrained interaction accent
- web and A4/PDF output should feel like the same product

## 2. Color Tokens

| Token | Value | Usage |
| --- | --- | --- |
| `background` | `#F9F9F8` | Warm paper page background |
| `surface` | `#FFFFFF` | Primary cards and elevated content |
| `surface_low` | `#F3F4F3` | Secondary surfaces |
| `surface_container` | `#EEEEED` | Code, metadata, utility panels |
| `surface_high` | `#E8E8E7` | Selected / hover-neutral states |
| `text_primary` | `#1A1C1C` | Headings and primary content |
| `text_secondary` | `#444748` | Body and secondary content |
| `meta_text` | `#6B7280` | Dates, versions, repository metadata |
| `border` | `#E5E7EB` | Structural containment |
| `primary` | `#000000` | Primary CTA |
| `on_primary` | `#FFFFFF` | Primary CTA text |
| `secondary` | `#0061A3` | Engineering / interaction accent |
| `rust_accent` | `#E98329` | Rust-specific technical accent only |
| `error` | `#BA1A1A` | Validation and error states |

Avoid gradients, neon effects, glassmorphism, and section-specific accent palettes.

## 3. Typography

Preferred families:
- Primary UI/editorial: `Geist`
- Technical metadata/code: `JetBrains Mono`
- Thai fallback: `Noto Sans Thai` or `Sarabun`

Scale:

| Style | Size | Weight | Line height |
| --- | ---: | ---: | ---: |
| Display / Hero | 48 | 700 | 1.1 |
| H1 / Section lead | 32 | 600 | 1.2 |
| H3 / Card title | 20 | 600 | 1.4 |
| Body large | 18 | 400 | 1.6 |
| Body | 16 | 400 | 1.6 |
| Metadata | 14 | 500 | 1.0 |
| Code | 13 | 400 | 1.5 |
| Mobile display | 32 | 700 | 1.2 |

Use monospace sparingly for versions, package names, repository identifiers, languages, technical labels, and concise code.

## 4. Layout and Spacing

- desktop content max width: `1120px`
- desktop gutter: `24px`
- mobile side margin: `20px`
- large section gap: `80px`
- default stack gap: `12px`
- base spacing rhythm: `8px`

Desktop uses a structured 12-column mental model. Featured work may span full width; standard projects normally use two columns. Long-form case study content must use a narrower readable measure.

Breakpoints:
- mobile: `< 768`
- tablet: `768–1199`
- desktop: `>= 1200`

## 5. Shape and Depth

Radius scale:
- small: `4px`
- default: `8px`
- medium: `12px`
- large: `16px`
- pills: fully rounded, reserved for filters/status chips

Depth is created with whitespace, low-contrast borders, and tonal surface shifts. Avoid large floating shadows.

## 6. Core Components

### Buttons
- Primary: near-black fill, white text
- Secondary: transparent/white surface with 1px neutral border
- Tertiary: text link with consistent underline/arrow treatment
- Motion: restrained ~150ms opacity/background/position feedback

### Project cards
Standard flow:
1. project type / status metadata
2. project name
3. concise portfolio-owned description
4. engineering highlights or stack
5. repository/package metadata
6. actions

Variants are `featured`, `standard`, and `compact`; they share one visual foundation and only change density.

### Technology metadata
Prefer text such as `Flutter · Dart · Rust · FFI` or compact neutral chips. Do not create colorful framework-logo walls.

Rust-specific items may use a 2px `rust_accent` edge/sliver, but Rust must not create a separate visual theme.

### Status
Use a single restrained lifecycle system:
- Active
- Stable
- Published
- In Development
- Maintenance
- Experimental
- Archived

Status must not rely on color alone.

### Data tables
Use horizontal dividers only where possible. Values may use monospace. Avoid dense vertical borders.

### Navigation
Public navigation is a compact top bar. Use the same navigation on all public screens with a clear active state and a restrained Resume/PDF action.

## 7. Public Information Architecture

The public portfolio should support:
- Home
- Projects
- Project Case Study
- Open Source
- Experience
- About
- Contact

Home is a concise discovery/routing page, not a duplicate of all other screens.

Recommended Home hierarchy:
1. identity / hero
2. engineering snapshot
3. featured work
4. projects bridge
5. open source
6. engineering approach
7. selected companies / experience
8. Resume / Portfolio PDF CTA
9. contact

Company / product names in experience must remain directly scannable.

## 8. Projects and Case Studies

Projects are engineering case studies rather than generic portfolio tiles.

Project pages may contain:
- Overview
- Problem
- Solution
- Why It Matters
- Engineering Highlights
- Architecture
- Technical Stack
- Engineering Decisions
- Challenges & Solutions
- Performance (only with evidence)
- Features
- Development Timeline
- Code Examples
- Related Projects

Do not put every section in a bordered card. Use typography and whitespace first.

## 9. Open Source

Open-source/package items should show the information most useful to an engineer:
- package/repository name
- registry/platform
- version when useful
- concise description
- primary use case
- technical stack
- GitHub / pub.dev / crates.io links

Repository statistics remain secondary to engineering content.

## 10. Admin

Admin shares typography, borders, accent, radius, buttons, status components, and metadata treatment with the public site, but uses tighter spacing and greater information density.

Admin must clearly distinguish:

### GitHub-synced data
- repository name
- stars
- forks
- primary language
- topics
- license
- GitHub description
- latest update/release

### Portfolio-owned data
- display name
- custom description
- project type
- lifecycle status
- featured state
- display order
- engineering highlights
- case study content
- custom image
- relationships
- public visibility
- PDF visibility

GitHub sync must never silently overwrite portfolio-owned data.

## 11. PDF / Resume

PDF output is a print transformation of the same portfolio data, not a separate content silo.

Data hierarchy:
`Full website case study -> condensed engineering portfolio PDF -> compact resume summary`

Print rules:
- A4 portrait
- warm-white/white background
- strong contrast
- visible URLs where useful
- predictable page breaks
- no hover-dependent content
- keep headings with their first content block
- keep project title + intro together
- keep diagrams/code blocks intact where possible

## 12. Accessibility

- keyboard navigation required
- visible focus states
- minimum practical touch targets
- strong text contrast
- logical heading order
- do not communicate lifecycle/status using color only
- external actions need meaningful semantics

## 13. Anti-patterns

Do not introduce:
- glassmorphism
- neon/hacker visuals
- excessive gradients
- large decorative code backgrounds
- giant metric cards
- skill percentages/progress bars
- colorful technology logo walls
- heavy dashboard charting without a real data need
- excessive card nesting

The portfolio should communicate seniority through information quality, engineering evidence, and disciplined visual hierarchy.
