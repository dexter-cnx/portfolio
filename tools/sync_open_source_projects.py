#!/usr/bin/env python3
"""Generate static open-source project assets for the Flutter portfolio.

The public portfolio must not depend on GitHub APIs at runtime. This script reads
assets/content/project_selection.json, fetches repository-owned
.portfolio/status_<locale>.json files from raw.githubusercontent.com, and writes
fully resolved assets consumed by Flutter.
"""

from __future__ import annotations

import json
import sys
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SELECTION_PATH = ROOT / "assets/content/project_selection.json"
OUTPUT_PATTERN = ROOT / "assets/content/open_source_projects_{}.json"
LOCALES = ("en", "th")
BRANCHES = ("main", "master")


def _read_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"{path} must contain a JSON object")
    return value


def _fetch_json(url: str) -> dict[str, Any] | None:
    request = urllib.request.Request(
        url,
        headers={"User-Agent": "dexter-cnx-portfolio-static-builder"},
    )
    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            value = json.load(response)
    except urllib.error.HTTPError as error:
        if error.code == 404:
            return None
        raise
    if not isinstance(value, dict):
        raise ValueError(f"Expected object from {url}")
    return value


def _load_status(full_name: str, locale: str) -> dict[str, Any] | None:
    locales = (locale, "en") if locale != "en" else ("en",)
    for candidate_locale in locales:
        for branch in BRANCHES:
            url = (
                "https://raw.githubusercontent.com/"
                f"{full_name}/{branch}/.portfolio/status_{candidate_locale}.json"
            )
            status = _fetch_json(url)
            if status is not None:
                return status
    return None


def _string(value: Any) -> str:
    return value.strip() if isinstance(value, str) else ""


def _strings(value: Any) -> list[str]:
    if not isinstance(value, list):
        return []
    return [item.strip() for item in value if isinstance(item, str) and item.strip()]


def _compose(config: dict[str, Any], status: dict[str, Any] | None) -> dict[str, Any]:
    full_name = _string(config.get("repositoryFullName"))
    if not full_name or "/" not in full_name:
        raise ValueError(
            f"repositoryFullName is required for repositoryId={config.get('repositoryId')}"
        )

    project = status.get("project", {}) if status else {}
    summary = status.get("summary", {}) if status else {}
    links = status.get("links", {}) if status else {}
    if not isinstance(project, dict):
        project = {}
    if not isinstance(summary, dict):
        summary = {}
    if not isinstance(links, dict):
        links = {}

    title_override = _string(config.get("titleOverride"))
    summary_override = _string(config.get("summaryOverride"))
    name = full_name.split("/", 1)[1]
    title = title_override or _string(project.get("title")) or name
    short_summary = summary_override or _string(summary.get("short"))
    long_summary = _string(summary.get("long"))
    repository_url = _string(links.get("repository")) or f"https://github.com/{full_name}"
    live_url = _string(links.get("demo")) or _string(links.get("homepage"))
    tags = _strings(status.get("tech")) if status else []

    extra_links = []
    for key, label in (("package", "Package"), ("docs", "Docs"), ("demo", "Demo")):
        url = _string(links.get(key))
        if url:
            extra_links.append({"image": "", "title": label, "url": url})

    return {
        "repositoryId": config.get("repositoryId"),
        "repositoryFullName": full_name,
        "visible": bool(config.get("visible", False)),
        "includeInPdf": bool(config.get("includeInPdf", False)),
        "sortOrder": int(config.get("sortOrder", 0)),
        "name": title,
        "summary": short_summary,
        "longDescription": long_summary,
        "repoUrl": repository_url,
        "liveUrl": live_url,
        "images": [],
        "urls": extra_links,
        "tags": tags,
    }


def _generate(locale: str, selection: dict[str, Any]) -> dict[str, Any]:
    raw_projects = selection.get("projects", [])
    if not isinstance(raw_projects, list):
        raise ValueError("project_selection.json projects must be a list")

    selected = [
        item
        for item in raw_projects
        if isinstance(item, dict)
        and (bool(item.get("visible", False)) or bool(item.get("includeInPdf", False)))
    ]
    selected.sort(key=lambda item: int(item.get("sortOrder", 0)))

    projects = []
    for index, config in enumerate(selected, start=1):
        full_name = _string(config.get("repositoryFullName"))
        print(f"[{locale}] {index}/{len(selected)} {full_name}", flush=True)
        status = _load_status(full_name, locale)
        projects.append(_compose(config, status))

    return {
        "schemaVersion": 1,
        "locale": locale,
        "selectionUpdatedAt": selection.get("updatedAt"),
        "projects": projects,
    }


def main() -> int:
    selection = _read_json(SELECTION_PATH)
    for locale in LOCALES:
        output = _generate(locale, selection)
        path = Path(str(OUTPUT_PATTERN).format(locale))
        path.write_text(
            json.dumps(output, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"wrote {path.relative_to(ROOT)}", flush=True)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:  # build tooling should fail loudly
        print(f"sync_open_source_projects: {error}", file=sys.stderr)
        raise
