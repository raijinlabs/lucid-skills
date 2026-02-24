---
name: market-research
description: "Search, discover, and analyze prediction markets across Polymarket, Manifold, and Kalshi"
---

# Market Research

Search, discover, and analyze prediction markets across multiple platforms. This skill teaches you how to query prediction market APIs, aggregate results, and perform trend analysis.

## Supported Platforms

| Platform | API Base | Auth | Status |
|----------|----------|------|--------|
| **Polymarket** | `https://gamma-api.polymarket.com` | Public (read-only) | Fully integrated |
| **Manifold** | `https://api.manifold.markets/v0` | Public (read-only) | Fully integrated |
| **Kalshi** | *(placeholder)* | Credentials required | Not fully integrated |

See `references/platforms.md` for full endpoint documentation and rate limits.

## Market Search Procedure

1. **Accept a search query** from the user (e.g., "Bitcoin price", "2026 election").
2. **Query each configured platform** in parallel:
   - Polymarket: `GET /events?query={term}&limit=50`
   - Manifold: `GET /search-markets?term={term}&limit=50`
3. **Normalize results** into the unified Market data model (see below).
4. **Aggregate** results from all platforms into a single list.
5. **Sort by `volume_usd` descending** (highest activity first).
6. **Return** the merged, sorted list to the user.

## Market Data Model

Every market is normalized to this structure:

| Field | Type | Description |
|-------|------|-------------|
| `platform` | string | Source platform (`polymarket`, `manifold`, `kalshi`) |
| `external_id` | string | Platform-specific market identifier |
| `title` | string | Market question/title |
| `description` | string | Full description of the market |
| `category` | string | One of the categories below |
| `resolution_type` | string | One of the market types below |
| `outcomes` | array | List of possible outcomes with labels |
| `current_prices` | object | Current prices per outcome (0.00 to 1.00) |
| `volume_usd` | number | Total volume traded in USD |
| `liquidity_usd` | number | Available liquidity in USD |
| `close_date` | ISO 8601 | When the market stops accepting trades |
| `status` | string | One of the market statuses below |
| `url` | string | Direct link to the market on its platform |

## Market Categories

- `politics` -- Elections, legislation, government actions
- `crypto` -- Cryptocurrency prices, protocol events, DeFi
- `sports` -- Sporting events, league outcomes, player performance
- `science` -- Scientific discoveries, climate, health/pandemic
- `economics` -- GDP, inflation, interest rates, employment
- `technology` -- Product launches, AI milestones, tech industry
- `entertainment` -- Awards, media, cultural events
- `world_events` -- Geopolitics, conflicts, international affairs
- `other` -- Anything that does not fit the above

## Market Types

| Type | Description |
|------|-------------|
| `binary` | Yes/No resolution. Two outcomes. Price of Yes = probability. |
| `multiple_choice` | Multiple mutually exclusive outcomes. Prices should sum to ~1.00. |
| `scalar` | Numeric resolution within a range. |

## Market Statuses

| Status | Meaning |
|--------|---------|
| `open` | Market is actively trading |
| `closed` | Trading has stopped, awaiting resolution |
| `resolved` | Outcome is determined |
| `disputed` | Resolution is being contested |

## Trending Markets

To find trending markets, sort all open markets by `volume_usd` descending. The top results represent the most actively traded (and therefore most interesting) markets at the moment.

**Procedure:**
1. Fetch open markets from each platform (no specific query, or use broad query).
2. Filter to `status = open`.
3. Sort by `volume_usd` descending.
4. Return the top N results.

## Resolved Markets

To find recently resolved markets:
1. Query each platform for markets with `status = resolved`.
2. Check the `outcomes` array for which outcome was marked as the winner.
3. Report the resolution outcome and final prices.

## Category Overview

To generate a category overview (e.g., "How is the politics category doing?"):
1. Fetch all open markets in the given category.
2. Calculate:
   - **Total volume**: Sum of `volume_usd` across all markets in the category.
   - **Total liquidity**: Sum of `liquidity_usd` across all markets in the category.
   - **Market count**: Number of open markets.
   - **Average leading price**: For each market, take the highest outcome price; then average those across all markets.
3. Present the summary.

## Trend Analysis from Historical Data

When historical price data is available (a time series of prices), compute the following:

### Direction
- Calculate the percentage change from the oldest price to the newest price.
- If change > +2%: direction is **up**
- If change < -2%: direction is **down**
- Otherwise: direction is **stable**

### Volatility
- Compute returns: for each consecutive pair of prices, `return = (price[i] - price[i-1]) / price[i-1]`
- Calculate the standard deviation of all returns.
- Volatility = standard deviation x 100 (expressed as a percentage).

### Momentum
- Split the time series in half.
- Compute the average price for the recent half and the older half.
- Momentum = ((recent_avg - old_avg) / old_avg) x 100
- Positive momentum means prices are trending upward recently.
