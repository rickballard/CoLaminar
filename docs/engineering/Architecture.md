<!-- status: stub; target: 150+ words -->
<!-- status: stub; target: 150+ words -->

# Architecture

## Surfaces
- **Browser extension (MV3).**  Content script hides UI; popup shows grades and "Clean Feed."  
- **Web app (PWA).**  Loads policy JSON + OPML; renders feed; later: serverless fetcher.  
- **iOS Safari content blocker + web‑extension.**  Rules + panel; no native app rewiring.

## Data
- **Policy JSON** (portable).  **OPML** feeds.  **Local grades/logs** (on device).

## Scoring Heuristics
- Educational Value = topic match × source reliability × completion.  
- Focus = long‑form time ÷ total − autoplay penalties.  
- Diversity Index = coverage across ideological/geo sources.

## Write Operations
- OAuth to YouTube Data API for subscriptions/playlists (optional).  All changes logged; one‑tap apply.

## Guardrails
- No password capture.  No scraping behind logins.  No stealth automation.  Kid data minimized.


