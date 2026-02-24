# Platform API Reference

## Polymarket

- **API Base**: `https://gamma-api.polymarket.com`
- **Authentication**: None required (public read access)
- **Rate Limits**: 3 concurrent requests max, 300ms minimum between requests

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/events` | Search and list prediction market events |
| `GET` | `/events?query={term}&limit={n}` | Search events by keyword |
| `GET` | `/markets/{id}` | Get a single market by ID |

### Response Mapping

| Polymarket Field | Unified Field |
|-----------------|---------------|
| `id` | `external_id` |
| `title` | `title` |
| `description` | `description` |
| `outcomes` | `outcomes` |
| `outcomePrices` | `current_prices` |
| `volume` | `volume_usd` |
| `liquidity` | `liquidity_usd` |
| `endDate` | `close_date` |
| `active` (true) | `status` = `open` |
| `resolved` (true) | `status` = `resolved` |

---

## Manifold

- **API Base**: `https://api.manifold.markets/v0`
- **Authentication**: None required for read operations (API key optional for write)
- **Rate Limits**: 3 concurrent requests max, 200ms minimum between requests

### Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/search-markets?term={term}&limit={n}` | Search markets by keyword |
| `GET` | `/market/{id}` | Get a single market by ID/slug |
| `GET` | `/markets` | List markets (supports pagination) |

### Response Mapping

| Manifold Field | Unified Field |
|---------------|---------------|
| `id` | `external_id` |
| `question` | `title` |
| `description` | `description` |
| `answers` | `outcomes` |
| `probability` | `current_prices` (for binary: `{yes: probability, no: 1 - probability}`) |
| `volume` | `volume_usd` |
| `totalLiquidity` | `liquidity_usd` |
| `closeTime` | `close_date` (convert from Unix ms) |
| `isResolved` | `status` = `resolved` if true, `open` otherwise |

---

## Kalshi

- **API Base**: *(not fully integrated)*
- **Authentication**: Credentials required (username + password or API key)
- **Status**: Placeholder -- not fully integrated into the system

### Notes

- Kalshi requires authentication for all API access.
- When Kalshi integration is added, credentials should be provided via environment variables.
- Markets on Kalshi are structured as "events" containing "contracts."

---

## Unified Market Data Model

All platform responses are normalized to this structure:

```
Market {
  platform:        string    -- "polymarket" | "manifold" | "kalshi"
  external_id:     string    -- Platform-specific market identifier
  title:           string    -- The market question
  description:     string    -- Full market description
  category:        string    -- politics | crypto | sports | science | economics | technology | entertainment | world_events | other
  resolution_type: string    -- binary | multiple_choice | scalar
  outcomes:        array     -- [{label: "Yes", price: 0.65}, {label: "No", price: 0.35}]
  current_prices:  object    -- {yes: 0.65, no: 0.35} or per-outcome mapping
  volume_usd:      number    -- Total traded volume in USD
  liquidity_usd:   number    -- Available liquidity in USD
  close_date:      string    -- ISO 8601 datetime when trading closes
  status:          string    -- open | closed | resolved | disputed
  url:             string    -- Direct link to market on platform
}
```

## Rate Limiting Strategy

To respect platform rate limits:

1. Maintain a concurrency limiter per platform (max 3 concurrent requests).
2. Enforce minimum delay between requests (Polymarket: 300ms, Manifold: 200ms).
3. On HTTP 429 (Too Many Requests), back off exponentially.
4. Query platforms in parallel, but respect per-platform limits independently.
