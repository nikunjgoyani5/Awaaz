# Awaaz - News Page

Next.js public news/event share site for **Awaaz Eye**. Shared incident links open at `/{eventId}` with media, title, description, and social preview metadata.

Repository: `https://github.com/nikunjgoyani5/Awaaz.git`  
Branch: `news_page`

For architecture, API integration, SEO behavior, and branch notes, see `TECHNICAL_HANDOVER.md`.

## Stack

- Next.js 15 (Pages Router)
- React 19
- Axios (event data from Awaaz Eye API)
- react-slick / slick-carousel (media carousel)

## Quick start

```bash
npm install
npm run dev
```

Open `http://localhost:3000`.

View an event (replace with a valid event ID):

```
http://localhost:3000/{eventId}
```

The home route (`/`) shows a "News Not Found!!!" placeholder.

## Routes

| Route | Purpose |
|-------|---------|
| `/` | Placeholder home page |
| `/[id]` | Event/news detail page (SSR + optional client fetch) |

## External API

Event data is loaded from `https://awaazeye.com/api/v1/event-post/event/{id}` (hardcoded in `pages/[id].js`).

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
| `news_page` | This simplified news share site (current) |
| `landing-page` | Richer incident landing UI (timeline, nearby events, Swiper) |
| `flutter_mobile_app` | Mobile app (not in this checkout) |
| `awaaz_admin_web_app` | Admin web app (not in this checkout) |
| `main` | Default branch |
