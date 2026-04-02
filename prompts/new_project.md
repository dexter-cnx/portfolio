We are starting a new Flutter Web portfolio project.

Use this repo as a lightweight content-driven portfolio, not a heavy app.

Goals:
- build a single-page portfolio website
- use `assets/content/portfolio_content.json` as the primary content source
- implement a dark premium UI inspired by Brittany Chiang's portfolio language
- keep the codebase friendly for Anti Gravity + toolkit workflows

Architecture:
- feature-first
- minimal clean architecture
- no unnecessary repository/usecase layers for static local content
- extract reusable widgets only when duplication is visible

Implementation plan:
1. create typed models for the content JSON
2. create a responsive page shell
3. implement hero section
4. implement about section
5. implement experience section
6. implement featured projects section
7. implement contact section
8. add scroll navigation and polish

Definition of done:
- desktop/tablet/mobile responsive
- JSON-driven content
- accessible links and buttons
- readable code with small focused widgets
- no business logic in presentational widgets
