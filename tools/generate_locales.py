#!/usr/bin/env python3
"""Generate EasyLocalization JSON assets from the canonical CSV source."""

from __future__ import annotations

import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets/translations/langs.csv"
OUTPUT_DIR = ROOT / "assets/translations/generated"


def main() -> int:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    with SOURCE.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None or "key" not in reader.fieldnames:
            raise ValueError("langs.csv must contain a key column")
        locales = [name for name in reader.fieldnames if name != "key"]
        values = {locale: {} for locale in locales}
        for row in reader:
            key = (row.get("key") or "").strip()
            if not key:
                continue
            for locale in locales:
                values[locale][key] = row.get(locale) or ""

    for locale, translations in values.items():
        output = OUTPUT_DIR / f"{locale}.json"
        output.write_text(
            json.dumps(translations, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"wrote {output.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
