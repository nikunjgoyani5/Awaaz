# Awaaz Landing Page - Technical Handover

Prepared from repository evidence in `Awaaz` on branch `landing-page`.

Evidence policy used:
- **Verified from repository**: explicit in source, config, or files in this checkout
- **Inferred from code**: derived from implementation behavior
- **Not Found in Repository**: no verifiable evidence in this checkout

---

# Project Overview

## Purpose of the application

- **Verified from repository**: Public-facing Next.js site for sharing and viewing **Awaaz Eye** incident/event posts.
- **Verified from repository**: Dynamic route `/[id]` renders event title, description, address, media carousel (images/videos), timeline updates, reaction/comment counts, and nearby events.
- **Verified from repository**: Optimized for link previews (Open Graph, Twitter cards, video meta) when events are shared on social platforms.

## Main user types

| User | Description | Evidence |
|------|-------------|----------|
| Public visitor | Opens shared event URL; no login in this app | No auth in `pages/` |
| Developer | Maintains landing page and SEO/share behavior | Repository structure |

## Major features

| Feature | Location | Status |
|---------|----------|--------|
| Incident detail page | `pages/[id].js` | Verified |
| Server-side data fetch (SSR) | `getServerSideProps` in `pages/[id].js` | Verified |
| Client-side refetch | `useEffect` + axios in `pages/[id].js` | Verified |
| Media slider (Swiper) | `pages/[id].js`, `IncidentPage.module.css` | Verified |
| Timeline and nearby events | `pages/[id].js` | Verified |
| SEO / social meta | `next-seo`, `next/head`, `utils/commonMeta.js` | Verified |
| Placeholder home | `pages/index.js` | Verified |
| Static mock incidents | `data/incidents.js` | Verified (legacy/sample data) |

---

# Tech Stack

| Layer | Technology | Evidence |
|-------|------------|----------|
| Framework | Next.js 15.2.3 (Pages Router) | `package.json`, `pages/` |
| UI | React 19 | `package.json` |
| HTTP client | Axios | `pages/[id].js` |
| Carousels | Swiper 11, react-slick, slick-carousel | `package.json`, imports in `[id].js` |
| SEO | next-seo 6 | `pages/[id].js` |
| Dates | moment | `utils/commonMeta.js` |
| Icons | react-icons | `pages/[id].js` |
| Config | `next.config.mjs`, `jsconfig.json` | Path alias `@/*` |

## Backend in this branch

**Status: Not Found in Repository**

This checkout is the landing page only. Event APIs are consumed from an external host (`awaazeye.com`).

## Infrastructure

**Status: Partial**

| Item | Status | Detail |
|------|--------|--------|
| Render deployment URL | Verified from repository | `https://aawaz-landingpage.onrender.com` referenced in OG meta (`pages/[id].js`) |
| Production news URL | Verified from repository | `https://news.awaazeye.com` used for canonical/NextSeo URLs |
| Docker / CI/CD | Not Found in Repository | |
| Vercel config | Not Found in Repository | `.vercel` gitignored only |

---

# High-Level Architecture

## Application flow

```
User opens /{eventId}
        |
        v
getServerSideProps (SSR) --> GET awaazeye.com/api/v1/event-post/event/{id}
        |
        v
Incident page renders with initialData + SEO tags
        |
        v
Client useEffect refetches event + nearby events
        |
        v
Media from DigitalOcean CDN / API attachment URLs
```

1. User lands on `/[id]` (shared link from mobile app or notifications).
2. Server fetches event JSON with no-cache headers for fresh previews.
3. Page renders Swiper media, metadata, timeline, and "In this area" cards.
4. Client refetches the same endpoints after hydration.

## Architecture diagram

```
+------------------+     HTTPS      +----------------------+
|  Browser / Social|--------------->|  Next.js (landing)   |
|  link previews   |                |  pages/[id].js       |
+------------------+                +----------+-----------+
                                               |
                                               | REST
                                               v
                                    +----------------------+
                                    |  awaazeye.com API    |
                                    |  /api/v1/event-post  |
                                    +----------+-----------+
                                               |
                                               v
                                    +----------------------+
                                    |  DigitalOcean Spaces |
                                    |  (media attachments)  |
                                    +----------------------+
```

---

# Repository Structure

| Path | Purpose |
|------|---------|
| `pages/index.js` | Home route (placeholder) |
| `pages/[id].js` | Dynamic incident page + SSR |
| `pages/_app.js` | App wrapper, global CSS import |
| `pages/style.css` | Global styles |
| `pages/IncidentPage.module.css` | Incident page component styles |
| `data/incidents.js` | Static sample incident data |
| `utils/commonMeta.js` | Metadata helper (partially reused defaults) |
| `images/` | Logo and UI icons |
| `public/` | Default Next.js static assets |
| `next.config.mjs` | Image remotePatterns for DigitalOcean CDN |

---

# Environment Configuration

**Status: Not Found in Repository**

- No `.env.example`
- `.gitignore` excludes `.env*`
- API base URL is hardcoded as `https://awaazeye.com` in `pages/[id].js`
- `utils/commonMeta.js` has commented reference to `process.env.NEXT_PUBLIC_URL` (not active)

No environment variables are required to run the dev server locally.

---

# Local Development Setup

## Prerequisites

- Node.js and npm

## Commands

```bash
npm install
npm run dev
```

Default dev URL: `http://localhost:3000`

To view an event page, use a valid event ID:

```
http://localhost:3000/<eventId>
```

Requires network access to `awaazeye.com` API.

## Build and production

```bash
npm run build
npm start
```

---

# Deployment Process

**Status: Partial**

| Item | Status | Detail |
|------|--------|--------|
| Render hosting | Verified from repository | OG URLs use `aawaz-landingpage.onrender.com` |
| Custom domain | Verified from repository | `news.awaazeye.com` in canonical/NextSeo |
| Deploy scripts | Not Found in Repository | Standard Next.js `build` + `start` |
| CI/CD | Not Found in Repository | |

---

# External Integrations

## Awaaz Eye API

- **Purpose**: Event details and nearby events for landing pages
- **Files**: `pages/[id].js`
- **Endpoints used**:
  - `GET https://awaazeye.com/api/v1/event-post/event/{id}`
  - `GET https://awaazeye.com/api/v1/event-post/other-nearby-events/{id}` (client-side)
  - `GET https://awaazeye.com/api/v1/video-thumbnail?url={encodedUrl}` (video poster helper)

## DigitalOcean Spaces CDN

- **Purpose**: Event images, videos, fallback OG image
- **Files**: `next.config.mjs` (`guardianshot.blr1.cdn.digitaloceanspaces.com`), attachment URLs in API responses
- **Notes**: `next/image` remote pattern configured for this hostname

## Google site verification

- **Verified from repository**: Meta tag in `utils/commonMeta.js` (`google-site-verification`)

---

# Critical Business Logic

## Routing model

- **Verified from repository**: Primary entry is `/[id]` where `id` is the MongoDB-style event `_id` from the API.
- **Verified from repository**: `/` shows static "News Not Found!!!" (`pages/index.js`).
- **Verified from repository**: Invalid/missing event falls back to home component (`if (!incident) return <Home />`).

## SSR and caching

- **Verified from repository**: `getServerSideProps` sets strict no-cache response headers (`Cache-Control: no-store`, `Pragma: no-cache`, etc.) so social crawlers and browsers get fresh event data.

## SEO and social sharing

- **Verified from repository**: Dual meta setup using `next/head` and `NextSeo`.
- **Verified from repository**: Open Graph type switches to `video.other` when first attachment is video.
- **Verified from repository**: Twitter card uses `player` for video, `summary_large_image` for images.
- **Verified from repository**: Multiple base URLs appear in meta tags:
  - `https://news.awaazeye.com/{id}` (canonical / NextSeo)
  - `https://aawaz-landingpage.onrender.com/{id}` (some OG `og:url` tags)

## Media handling

- **Verified from repository**: Attachments support `Video` and `Image` types via `attachmentFileType`.
- **Verified from repository**: Swiper carousel with autoplay; videos autoplay muted with fullscreen and mute toggles.
- **Verified from repository**: Timeline items can open fullscreen media on play icon click.

## Nearby events

- **Verified from repository**: "In this area" section lists cards from `other-nearby-events` API; clicking navigates to `/{id}`.

---

# Scheduled Jobs

**Status: Not Found in Repository**

No cron, workers, or background jobs in this landing page codebase.

---

# Known Issues / Technical Debt

| Item | Detail | Status |
|------|--------|--------|
| SSR nearby fetch bug | `getServerSideProps` calls `event/{id}` twice instead of `other-nearby-events/{id}` for the second request | Verified (`pages/[id].js` lines 840-841) |
| Inconsistent public URLs | `news.awaazeye.com` vs `aawaz-landingpage.onrender.com` in same page meta | Verified |
| Brand spelling | "Awaaz Eye", "Aawaz", "Awaaz" used in different files | Verified |
| `commonMeta.js` defaults | WalletSync placeholder title/description in helper defaults | Verified |
| Home page placeholder | `/` does not list events; shows "News Not Found!!!" | Verified |
| Hardcoded API URL | No env-based API base URL | Verified |
| README outdated | Prior README referenced App Router `app/page.js`; project uses Pages Router | Verified |
| `data/incidents.js` | Sample/static data; main page flow uses live API | Verified |
| Package name | `my-app` in `package.json` | Verified |

---

# Operational Notes

| Topic | Status | Detail |
|-------|--------|--------|
| Branching | Verified | `landing-page` = this site; `flutter_mobile_app`, `awaaz_admin_web_app` on remote |
| Environment files | Verified | `.env*` gitignored; none required for basic dev |
| API dependency | Verified | Landing page requires `awaazeye.com` API availability |
| Static assets | Verified | `images/location.png`, `images/vector.png`, `images/aawaz_logo.svg` |
| Lint | Verified | `npm run lint` |

---

# Infrastructure Ownership

| Item | Status | Detail |
|------|--------|--------|
| Repository hosting | Verified | `https://github.com/nikunjgoyani5/Awaaz.git` |
| Landing hosting | Partial | Render URL in source; no deploy config in repo |
| API backend | Partial | `awaazeye.com` referenced; backend not in this branch |
| Media CDN | Partial | DigitalOcean Spaces hostname in config and JSON assets |
| DNS | Not Found in Repository | `news.awaazeye.com` referenced in code only |

---

# Handover Checklist

| Item | Status |
|------|--------|
| Source code available | Verified |
| Deployment process documented | Partial (URLs in code; no pipeline) |
| Environment variables documented | Not Found (none used) |
| Integrations documented | Verified (Awaaz API, DigitalOcean CDN) |
| Known issues documented | Verified |
| Infrastructure documented | Partial |

---

# Quick reference

| Item | Value |
|------|-------|
| Branch | `landing-page` |
| Dev command | `npm run dev` |
| Default port | `3000` |
| Main route | `/{eventId}` |
| API base | `https://awaazeye.com/api/v1/event-post` |
| Canonical URL pattern | `https://news.awaazeye.com/{eventId}` |
