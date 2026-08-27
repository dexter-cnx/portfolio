PYTHON ?= python3
FLUTTER ?= flutter
BASE_HREF ?= /portfolio/

.PHONY: prepare sync-projects generate-locales format analyze test build-web verify

prepare: generate-locales sync-projects

generate-locales:
	$(PYTHON) tools/generate_locales.py

sync-projects:
	$(PYTHON) tools/sync_open_source_projects.py

format:
	dart format lib test

analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

verify: prepare format analyze test

build-web: prepare
	$(FLUTTER) build web --release --base-href "$(BASE_HREF)"
