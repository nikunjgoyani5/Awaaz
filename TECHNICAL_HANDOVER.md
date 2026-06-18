# Awaaz News Page - Technical Handover

Prepared from repository evidence in `Awaaz` on branch `news_page`.

Evidence policy used:
- **Verified from repository**: explicit in source, config, or files in this checkout
- **Inferred from code**: derived from implementation behavior
- **Not Found in Repository**: no verifiable evidence in this checkout

---

# Project Overview

## Purpose of the application

- **Verified from repository**: Public Next.js site for sharing and viewing **Awaaz Eye** event/incident posts.
- **Verified from repository**: Dynamic route `/[id]` renders event title, description, date/time, notified count, and a media gallery (images and videos).
- **Verified from repository**: Built for link previews on social platforms (Open Graph, Twitter player/summary cards, WhatsApp-friendly video/image meta).

## Main user types

| User | Description | Evidence |
|------|-------------|----------|
| Public visitor | Opens shared event URL; no authentication | No auth in `pages/` |
| Developer | Maintains news page and share-preview behavior | Repository structure |

## Major features

| Feature | Location | Status |
|---------|----------|--------|
| Event detail page | `pages/[id].js` | Verified |
| Server-side rendering | `getServerSideProps` in `pages/[id].js` | Verified |
| Client-side fallback fetch | `useEffect` when `initialData` absent | Verified |
| Media carousel / grid | react-slick (4+ items) or static grid (1-3 items) | Verified |
| Social / SEO meta tags | `next/head` in `pages/[id].js` | Verified |
| Placeholder home | `pages/index.js` | Verified |
| Sample incident data | `data/incidents.js` | Verified (not used by live routes) |

---

# Tech Stack

| Layer | Technology | Evidence |
|-------|------------|----------|
| Framework | Next.js 15.2.3 (Pages Router) | `package.json`, `pages/` |
| UI | React 19 | `package.json` |
| HTTP client | Axios | `pages/[id].js` |
| Carousel | react-slick, slick-carousel | `package.json`, `pages/[id].js` |
| Images | `next/image` | `pages/[id].js` |
| Styling | Inline JS styles + `pages/style.css` | `pages/[id].js`, `pages/_app.js` |
| Config | `next.config.mjs`, `jsconfig.json` | Remote image patterns |

## Backend in this branch

**Status: Not Found in Repository**

This checkout is the news page frontend only. Event data comes from `awaazeye.com` API.

## Infrastructure

**Status: Partial**

| Item | Status | Detail |
|------|--------|--------|
| Production URL | Verified from repository | `https://news.awaazeye.com/{id}` in OG meta (`pages/[id].js`) |
| Docker / CI/CD | Not Found in Repository | |
| Vercel config | Not Found in Repository | `.vercel` gitignored only |

---

# High-Level Architecture

## Application flow

```
User opens /{eventId}
        |
        v
getServerSideProps --> GET awaazeye.com/api/v1/event-post/event/{id}
        |
        v
formatIncidentData() --> props.initialData
        |
        v
Page renders media + meta tags (no-cache headers on SSR)
        |
        v
(Optional) Client refetch if initialData missing
```

1. Shared link opens `/[id]`.
2. Server fetches event JSON with strict no-cache response headers.
3. Data is formatted to a flat incident object (media URLs, thumbnails, types).
4. Page renders slick carousel or static grid based on media count.
5. If SSR fails or `initialData` is null, client attempts axios fetch; otherwise shows "News Not Found!!".

## Architecture diagram

```
+------------------+     HTTPS      +----------------------+
|  Browser / Social|--------------->|  Next.js (news_page) |
|  crawlers        |                |  pages/[id].js       |
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
| `pages/index.js` | Home route placeholder |
| `pages/[id].js` | Event page, SSR, SEO meta, inline styles |
| `pages/_app.js` | App wrapper |
| `pages/style.css` | Minimal global body reset |
| `data/incidents.js` | Static sample data (not wired to API flow) |
| `public/` | Default Next.js static assets |
| `next.config.mjs` | `next/image` remotePatterns for DigitalOcean CDN |

---

# Environment Configuration

**Status: Not Found in Repository**

- No `.env.example`
- `.gitignore` excludes `.env*`
- API URL hardcoded: `https://awaazeye.com/api/v1/event-post/event/{id}`

No environment variables are required for local development.

---

# Local Development Setup

## Prerequisites

- Node.js and npm

## Commands

```bash
npm install
npm run dev
```

Default URL: `http://localhost:3000/{eventId}`

Requires network access to `awaazeye.com` API for live event pages.

## Production

```bash
npm run build
npm start
```

---

# Deployment Process

**Status: Partial**

| Item | Status | Detail |
|------|--------|--------|
| Public domain | Verified from repository | `news.awaazeye.com` referenced in `og:url` |
| Deploy automation | Not Found in Repository | Standard Next.js build/start |
| CI/CD | Not Found in Repository | |

---

# External Integrations

## Awaaz Eye API

- **Purpose**: Fetch event details for share pages
- **Files**: `pages/[id].js`
- **Endpoint**: `GET https://awaazeye.com/api/v1/event-post/event/{id}`
- **Response shape used**: `response.data.body` with `_id`, `title`, `description`, `eventTime`, `notifiedUserCount`, `attachments[]` (`attachment`, `thumbnail`, `attachmentFileType`)

## DigitalOcean Spaces CDN

- **Purpose**: Host event images and videos
- **Files**: `next.config.mjs`, attachment URLs from API
- **Hostname**: `guardianshot.blr1.cdn.digitaloceanspaces.com`

---

# Critical Business Logic

## Data formatting

**Verified from repository** (`formatIncidentData` in `pages/[id].js`)

Maps API body to:
- `id`, `title`, `description`
- `date` (short month/day), `time` (relative ago string)
- `notified` from `notifiedUserCount`
- `media`, `thumbnails`, `mediaTypes` from `attachments`

## Media display rules

**Verified from repository**

- 1-3 media items: static CSS grid
- 4+ items: react-slick carousel (3 slides desktop, responsive breakpoints)
- Video detected by `.mp4` extension; images by common image extensions
- Videos render with HTML5 `<video controls>`

## SSR caching policy

**Verified from repository**

`getServerSideProps` sets:
- `Cache-Control: no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0`
- `Pragma: no-cache`, `Expires: -1`, `Surrogate-Control: no-store`

Page `<Head>` also includes cache-control meta tags.

## SEO / social sharing

**Verified from repository**

- `og:url`: `https://news.awaazeye.com/{id}`
- `og:site_name`: "Awaaz Eye"
- Video posts: `og:type` = `video.other`, Twitter `player` card with stream meta
- Image posts: `summary_large_image` / standard OG image tags
- Additional tags for Microsoft Teams/Skype thumbnails

## Error / not-found UX

**Verified from repository**

- Loading, error, or missing incident shows centered "News Not Found!!" on dark gradient background
- Home `/` shows "News Not Found!!!" (three exclamation marks)

---

# Scheduled Jobs

**Status: Not Found in Repository**

No cron jobs or background workers in this codebase.

---

# Known Issues / Technical Debt

| Item | Detail | Status |
|------|--------|--------|
| Unused import on home | `pages/index.js` imports `data/incidents` but does not use it | Verified |
| Hardcoded API URL | No env-based configuration | Verified |
| `data/incidents.js` unused in live flow | Sample data only | Verified |
| `react-responsive-carousel` dependency | Listed in `package.json`; import commented out in `_app.js` | Verified |
| Package name | `my-app` in `package.json` | Verified |
| No home feed | `/` is placeholder only | Verified |
| Branch divergence | `landing-page` branch has richer UI (timeline, nearby events, Swiper, next-seo) | Verified from git diff between branches |

---

# Operational Notes

| Topic | Status | Detail |
|-------|--------|--------|
| Current branch | Verified | `news_page` |
| Related branches | Verified | `landing-page`, `flutter_mobile_app`, `awaaz_admin_web_app`, `main` |
| API dependency | Verified | Requires `awaazeye.com` availability |
| Lint | Verified | `npm run lint` |

### Branch comparison (summary)

| Feature | `news_page` (this branch) | `landing-page` |
|---------|---------------------------|----------------|
| Media UI | react-slick / static grid | Swiper carousel |
| Nearby events | No | Yes |
| Timeline | No | Yes |
| SEO library | `next/head` only | `next-seo` + `next/head` |
| CSS | Inline styles | CSS modules |
| Extra deps | Minimal | moment, react-icons, swiper, next-seo |

---

# Infrastructure Ownership

| Item | Status | Detail |
|------|--------|--------|
| Repository hosting | Verified | `https://github.com/nikunjgoyani5/Awaaz.git` |
| News site domain | Partial | `news.awaazeye.com` in source meta tags |
| API backend | Partial | `awaazeye.com` referenced; not in this branch |
| Media CDN | Partial | DigitalOcean Spaces hostname in config |

---

# Handover Checklist

| Item | Status |
|------|--------|
| Source code available | Verified |
| Deployment process documented | Partial (domain in meta only) |
| Environment variables documented | Not Found (none used) |
| Integrations documented | Verified |
| Known issues documented | Verified |
| Infrastructure documented | Partial |

---

# Quick reference

| Item | Value |
|------|-------|
| Branch | `news_page` |
| Dev command | `npm run dev` |
| Default port | `3000` |
| Main route | `/{eventId}` |
| API | `GET https://awaazeye.com/api/v1/event-post/event/{id}` |
| Public URL pattern | `https://news.awaazeye.com/{eventId}` |
