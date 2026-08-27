# Portfolio Development Roadmap: GitHub Projects + PDF Export

Status: planned on `develop`

## Goals

1. Keep `main` as the production/stable branch and continue feature work through `develop`.
2. Add a current GitHub public-project catalog to the portfolio.
3. Add a back-office workflow that controls which repositories are published, their order, and portfolio-specific overrides.
4. Generate a professional PDF from the same portfolio data used by the website.
5. Reuse the architecture and appropriate rendering code from `dexter-cnx/flutter_report_suite`, especially the reusable `report_engine` concepts, rather than building a second unrelated PDF stack.
6. Merge `develop` into `main` only after CI, tests, web behavior, admin behavior, and PDF output are verified.

## Current baseline

- Portfolio content is loaded from locale-specific JSON assets through `LocalContentLoader`.
- `PortfolioData` already has structured site, experience, featured-project, other-project, contact, social and navigation models.
- `pdf` and `printing` are already declared dependencies, but PDF generation is not yet treated as a first-class portfolio feature.
- The project already uses a feature-oriented structure with data/domain/presentation boundaries.
- `flutter_report_suite` provides a reusable report model/rendering architecture including report templates, value resolution, PDF rendering, printing, JSON template persistence and Thai-capable font handling.

## Target architecture

```text
GitHub Public API
      |
      v
GitHubProjectRemoteDataSource
      |
      v
GitHubProjectRepository
      |
      +-----------------------------+
      |                             |
      v                             v
Admin / Back-office          Public Portfolio UI
selection + metadata         selected projects only
      |                             |
      v                             |
PortfolioProjectConfig -------------+
      |
      +-----------------------------+
      |
      v
PortfolioDocumentData
      |
      v
PortfolioPdfService
      |
      v
report_engine / PdfRenderService
      |
      v
PDF preview / download / print
```

The website and PDF must consume the same normalized portfolio data. Do not maintain a second hand-written resume dataset for the PDF.

## Backend strategy

Introduce backend boundaries before tying the UI to one provider:

```dart
abstract interface class ProjectSelectionStore {
  Future<ProjectSelectionConfig> load();
  Future<void> save(ProjectSelectionConfig config);
}
```

Recommended first production implementation: a small hosted document store (Supabase or Firestore are both suitable). Provider-specific code must stay under the data layer so it can be replaced without touching presentation/domain logic.

Do not place a GitHub personal access token or backend service-role key in the Flutter Web client. Public GitHub repository metadata can be fetched without a private token; privileged persistence must use backend-safe authentication/rules.

## Data model

### GitHubProject

Persist the stable GitHub repository id plus current remote metadata:

- repository id
- owner/login
- name
- full name
- description
- html URL
- homepage URL
- primary language
- topics
- stars
- forks
- archived flag
- fork flag
- created/updated/pushed timestamps
- optional license
- optional open-graph/cover image resolved by the portfolio layer

### PortfolioProjectConfig

Back-office controlled fields:

- `repositoryId`
- `visible`
- `featured`
- `sortOrder`
- localized display title override
- localized short summary override
- localized long/detail description override
- cover image override
- technology/tag overrides
- highlights
- demo URL override
- package/pub.dev URL when applicable
- case-study URL when applicable
- `includeInPdf`
- optional PDF-only summary/highlights

Remote GitHub metadata remains remote-derived. Portfolio-specific editorial content remains config-derived.

## Phase P1 — GitHub repository catalog

Create a new `github_projects` feature or a clearly separated subfeature under portfolio.

Deliverables:

- `GitHubProject` domain entity
- GitHub public API datasource
- repository interface + implementation
- pagination support
- filter out archived/fork repositories by default, with explicit override support
- cache current results to avoid unnecessary GitHub API calls
- loading / empty / error states
- unit tests for mapping/filtering/sorting

Acceptance:

- The app can load the current public repositories for the configured GitHub account.
- A GitHub API failure does not break the rest of the portfolio.
- Repository metadata is normalized before reaching UI code.

## Phase P2 — Back-office project selection

Add an authenticated admin route, e.g. `/admin/projects`.

Capabilities:

- list current public GitHub repositories
- search/filter repositories
- visible toggle
- featured toggle
- include-in-PDF toggle
- drag or explicit numeric ordering
- edit title/summary/highlights/tags/links/cover overrides
- preview public project card before save
- save/publish configuration
- show last synchronized GitHub timestamp
- manual refresh from GitHub

Security:

- public portfolio reads only published configuration
- admin writes require authenticated authorization
- no privileged keys embedded in web assets
- provider rules restrict writes to the portfolio owner/admin account

Acceptance:

- Choosing a repo in admin changes what is rendered publicly without changing Dart source code.
- Ordering and featured status are persisted.
- Removed/private/archived repos degrade safely instead of crashing rendering.

## Phase P3 — Public Projects UI refresh

Replace or augment the current static featured/other project lists with normalized selected GitHub projects.

Behavior:

- featured projects get richer cards/case-study presentation
- remaining selected projects use compact cards
- show useful current metadata such as language, topics, stars and last-active date where appropriate
- portfolio editorial overrides take priority over raw GitHub text
- preserve existing localized portfolio content
- support deep links to GitHub, demo, pub.dev/package and case studies

Do not turn the portfolio into a raw GitHub mirror. GitHub metadata is evidence/context; curated portfolio copy remains primary.

## Phase P4 — Shared document data for web and PDF

Create a normalized export model, for example:

```dart
final class PortfolioDocumentData {
  final Site site;
  final About about;
  final List<Experience> experience;
  final List<PortfolioProjectViewData> projects;
  final Contact contact;
}
```

Add a mapper from live `PortfolioData` + selected GitHub projects into `PortfolioDocumentData`.

This becomes the single input contract for PDF generation.

Acceptance:

- PDF code does not read JSON assets directly.
- PDF code does not call GitHub directly.
- Web and PDF derive project selection/order from the same configuration.

## Phase P5 — PDF generation using Flutter Report Suite patterns

Prefer reuse/extraction from `flutter_report_suite/packages/report_engine` over duplicating low-level PDF logic.

Candidate components/concepts to reuse:

- `ReportTemplate`
- `ReportValueResolver`
- `PdfRenderService`
- JSON-backed template definitions
- bundled font strategy / Thai text support
- PDF preview/share/print separation

Implementation options, in order of preference:

1. Depend on a published/path/git `report_engine` package if its public API is clean enough for portfolio use.
2. Extract the generic reusable PDF/reporting subset into a shared package if portfolio exposes gaps in the current package boundary.
3. Only copy narrowly scoped code when package reuse is genuinely impractical; keep attribution/license and avoid forked duplicated engines.

Portfolio PDF templates:

- `portfolio_full` — multi-page portfolio/profile document
- `resume_compact` — concise 1–2 page resume-oriented export

Suggested sections:

- identity / headline / contact
- summary/about
- skills
- work experience
- selected GitHub projects
- project highlights + technologies + repository URL
- optional QR code linking to live portfolio/GitHub

Required actions:

- Preview PDF
- Download/Save PDF
- Print through system print dialog

Acceptance:

- PDF is generated from current live portfolio data.
- English and Thai text render correctly.
- pagination avoids clipped sections and orphaned headings.
- URLs are clickable where supported.
- output works on Flutter Web first; desktop/mobile compatibility is retained by the reporting boundary.

## Phase P6 — Quality and CI

Before `develop -> main`:

- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- GitHub project datasource/mapping tests
- project-selection config tests
- admin permission/error-state tests where feasible
- PDF mapper tests
- PDF smoke/golden-style assertions for both locales
- Flutter Web build
- manual responsive check
- manual admin selection/publish check
- manual PDF preview/download/print check

Add CI checks so format/analyze/test failures are caught before merge.

## Proposed PR sequence

### PR 1 — GitHub project foundation

- domain/data boundaries
- GitHub public repository loading
- cache/filter/error handling
- tests

Target: `develop`

### PR 2 — Project selection backend + admin

- selection store abstraction
- initial backend implementation
- admin route and controls
- publish/read model
- tests

Target: `develop`

### PR 3 — Public project experience

- render selected repositories
- featured/other layout
- metadata + editorial overrides
- responsive and localization pass

Target: `develop`

### PR 4 — Portfolio document/export model

- normalized `PortfolioDocumentData`
- mapper from portfolio + selected projects
- export-specific tests

Target: `develop`

### PR 5 — Report engine integration + PDF templates

- integrate/reuse `flutter_report_suite` report engine
- full and compact templates
- preview/download/print UI
- Thai/English font verification
- tests

Target: `develop`

### PR 6 — Hardening + documentation

- CI gates
- error/empty/loading polish
- admin security review
- web/PDF verification
- README / architecture / handoff updates

Target: `develop`

### Release PR — `develop -> main`

Open only after all prior PRs are green and the acceptance checklist is complete.

## Merge policy

- Feature branches branch from `develop`.
- Feature PRs merge into `develop`.
- Keep `main` production/stable.
- After each major milestone, re-check `main...develop` divergence.
- Final release is one reviewed PR from `develop` to `main`.
- Do not merge `develop` to `main` while PDF/admin security or CI gates are failing.

## Recommended next action

Start PR 1: GitHub project foundation. It has no backend-secret dependency and establishes the domain contracts needed by both the admin UI and public portfolio before persistence/PDF work begins.
