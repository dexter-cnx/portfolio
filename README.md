# Flutter Web Portfolio Starter

Starter kit for a Flutter Web portfolio inspired by the information architecture and dark aesthetic of Brittany Chiang's portfolio, adapted for a clean Flutter implementation and intended to be used together with `codex-claude-mobile-toolkit` inside Anti Gravity.

## Goal

Build a fast, single-page portfolio web app with these traits:

- dark, minimal, technical visual language
- strong typography and spacing
- left rail / sticky social links on desktop
- section-based one-page navigation
- JSON-driven content so content edits do not require Dart changes
- Flutter web friendly structure
- lightweight architecture instead of over-engineering

## What is included

- starter JSON schema for portfolio content
- Flutter web app shell
- theme tokens inspired by the reference aesthetic
- prompt pack for Google Stitch
- step-by-step build plan
- AGENTS.md for AI-assisted implementation

## Important note about the source content

The source website `https://learnfire-56264.web.app/` appears to be a Flutter web app. In this environment, its public HTML was mostly client-rendered and not fully extractable as structured text. Because of that, `assets/content/portfolio_content.json` is prepared as a ready-to-fill content file with a production-safe schema, plus a few values inferred from the public manifest.

## Suggested workflow

1. Put this starter in a fresh repo.
2. Add `codex-claude-mobile-toolkit` as a submodule or copy the relevant toolkit files into the repo.
3. Use the Google Stitch prompts in `prompts/google_stitch/` to generate layout direction.
4. Replace placeholder text inside `assets/content/portfolio_content.json` with final content.
5. Use Anti Gravity to implement section by section.
6. use this

Use the Stitch MCP to fetch my current Stitch project named "Portfolio Design Strategy".

Extract the following and create a complete DESIGN.md file in the folder "design/DESIGN.md":

- Full Color Palette (with hex codes, primary, secondary, success, error, background, text colors)
- Typography scale (headings, body, captions) + recommended Flutter font (Noto Sans Thai / Sarabun)
- Spacing / Radius / Elevation tokens
- Component Library (Button styles, Card, Input, Dialog, Bottom Sheet)
- Layout rules สำหรับ POS (Tablet Landscape, Split layout: Product Grid + Cart Sidebar)
- Design rules เฉพาะสำหรับ Flutter (Material 3, responsive, large touch targets)
- Screenshot หรือ description สั้น ๆ ของแต่ละ screen ที่ออกแบบไว้

หลังจากสร้างไฟล์แล้ว แสดงเนื้อหาของ DESIGN.md ให้ฉันตรวจสอบด้วย
ึึ7. update agents

## Visual rules
- Follow the "The Kinetic Blueprint" system defined in `design/DESIGN.md`.
...

## Preferred workflow
1. Read `design/DESIGN.md` to understand the design tokens and system.
2. Read `docs/project_plan.md`
...

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Suggested next files to create after scaffold

- `lib/features/portfolio/presentation/widgets/hero_section.dart`
- `lib/features/portfolio/presentation/widgets/about_section.dart`
- `lib/features/portfolio/presentation/widgets/experience_section.dart`
- `lib/features/portfolio/presentation/widgets/project_section.dart`
- `lib/features/portfolio/presentation/widgets/contact_section.dart`
- `lib/features/portfolio/presentation/widgets/side_rail.dart`
- `lib/features/portfolio/presentation/widgets/section_container.dart`
- `lib/features/portfolio/presentation/controllers/scroll_nav_controller.dart`

