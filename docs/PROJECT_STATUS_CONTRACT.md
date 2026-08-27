# Project Status Contract

This document defines the repository-owned metadata contract used by the portfolio aggregator.

## Purpose

Each public project owns its current portfolio description. The central `portfolio` repository decides **which** repositories are shown and in what order, while each project repository supplies **what the project currently is**.

## Required files

Each participating public repository should contain:

```text
.portfolio/
  status_en.json
  status_th.json
docs/
  PORTFOLIO_STATUS.md
```

## Schema version

Current schema version: `1`.

Both locale files use the same shape:

```json
{
  "schemaVersion": 1,
  "project": {
    "title": "Project name",
    "tagline": "Short current description",
    "status": "active",
    "version": null
  },
  "summary": {
    "short": "One-paragraph portfolio summary.",
    "long": "Optional longer current-state description."
  },
  "highlights": [],
  "tech": [],
  "links": {
    "repository": "https://github.com/owner/repo",
    "homepage": null,
    "package": null,
    "docs": null,
    "demo": null
  },
  "updatedAt": "2026-08-27T00:00:00Z"
}
```

## Field rules

- `schemaVersion` must be `1` until this contract is revised.
- `project.title` is the display name owned by the project.
- `project.tagline` is concise and suitable for project cards.
- `project.status` should be one of `active`, `maintenance`, `experimental`, `paused`, `archived`, or `complete`.
- `project.version` may be null when the project has no release version.
- `summary.short` should stand alone in portfolio cards and compact PDF output.
- `summary.long` may contain a fuller current-state description.
- `highlights` contains current capabilities, not roadmap promises.
- `tech` contains the important implementation technologies.
- unavailable links must be null rather than invented.
- `updatedAt` must be an ISO-8601 UTC timestamp reflecting the metadata update.

## Localization

`status_en.json` and `status_th.json` must describe the same project state. Only human-facing text is localized. Technical names, versions, URLs, and status semantics remain aligned between locales.

## Ownership

Project status files are maintained in the project repository. When a feature or release materially changes the project, update both locale files in the same PR whenever practical.

The central portfolio owns only editorial selection fields such as visibility, featured state, order, and PDF inclusion in `assets/content/project_selection.json`.

## Portfolio loading behavior

The portfolio should:

1. Load the selected public repositories from GitHub.
2. Read `.portfolio/status_<locale>.json` from each selected repository's default branch.
3. Validate `schemaVersion` and required fields.
4. Merge repository-owned status with live GitHub metadata such as stars, forks, language, repository URL, and push time.
5. Fall back to GitHub repository metadata if a status file is missing, unavailable, or invalid.
6. Never fail the full portfolio because one repository has invalid metadata.

## Security

These files are public metadata. They must not contain secrets, credentials, private URLs, customer data, API keys, tokens, or non-public project information.
