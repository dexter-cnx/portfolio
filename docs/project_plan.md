                                                                                                                                                                                                                                        # Project Plan

## Objective

Create a single-page Flutter Web portfolio site that:
- visually references Brittany Chiang's portfolio direction
- uses content from the LearnFire portfolio as the source material
- is easy to update later by editing JSON
- works well with Anti Gravity and the toolkit workflow

## Recommended phases

### Phase 1 — Foundation
- Create Flutter web project
- Set base theme tokens
- Add content JSON loader
- Build responsive page shell
- Add sticky left/right rails for desktop

### Phase 2 — Core sections
- Hero
- About
- Skills / tech stack
- Experience timeline or tab set
- Featured projects
- Contact CTA

### Phase 3 — Polish
- scroll-to-section navigation
- subtle reveal animations
- hover states for links/cards
- SEO metadata for web
- favicon / open graph image

### Phase 4 — Production hardening
- test desktop and mobile layouts
- optimize images
- verify Lighthouse basics
- deploy to Firebase Hosting / Vercel / Cloudflare Pages

## Implementation recommendation

For this project, do not start with heavy state management. A local content loader plus light controller/state for scroll navigation is enough.

## Suggested content mapping

### Brittany-style section map
- Hero → intro, role, short summary, CTA
- About → personal intro + current focus
- Experience → timeline/tabbed work history
- Projects → featured cards + smaller archive grid
- Contact → strong closing CTA

### LearnFire source map
Map the existing content from `learnfire-56264.web.app` into:
- profile / summary
- experience items
- projects
- skills / tools
- links
- contact details

