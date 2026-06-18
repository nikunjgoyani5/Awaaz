# Awaaz - Landing Page

Next.js public landing site for **Awaaz Eye** incident/event share pages. Each event opens at `/{eventId}` with media, timeline, nearby events, and social preview metadata.

Repository: `https://github.com/nikunjgoyani5/Awaaz.git`  
Branch: `landing-page`

For architecture, API integration, SEO behavior, and operational notes, see `TECHNICAL_HANDOVER.md`.

## Stack

- Next.js 15 (Pages Router)
- React 19
- Axios (event data from Awaaz Eye API)
- Swiper, react-slick, next-seo

## Quick start

```bash
npm install
npm run dev
```

Open `http://localhost:3000`.

Test an incident page locally (replace with a valid event ID from the API):

```
http://localhost:3000/{eventId}
```

The home route (`/`) shows a "News Not Found!!!" placeholder.

## Routes

| Route | Purpose |
|-------|---------|
| `/` | Placeholder home page |
| `/[id]` | Incident detail page (SSR + client fetch) |

## External API

Event data is loaded from `https://awaazeye.com/api/v1/event-post/` (hardcoded in `pages/[id].js`).

## Scripts

| Command | Purpose |
|---------|---------|
| `npm run dev` | Development server |
| `npm run build` | Production build |
| `npm start` | Serve production build |
| `npm run lint` | Next.js lint |

## Documentation

- `TECHNICAL_HANDOVER.md` - full handover document

## Related branches (same repository)

| Branch | Purpose |
|--------|---------|
| `landing-page` | This Next.js landing site |
| `flutter_mobile_app` | Mobile app (not in this checkout) |
| `awaaz_admin_web_app` | Admin web app (not in this checkout) |
| `main` | Default branch |
