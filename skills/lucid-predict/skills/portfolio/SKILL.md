---
name: portfolio
description: "Prediction market position tracking, PnL calculation, exposure analysis, and performance metrics"
---

# Portfolio Management

Track prediction market positions, calculate profit and loss, analyze exposure, and monitor performance. This skill covers all the formulas and procedures for managing a prediction market portfolio.

## Position Tracking

Each position in the portfolio is recorded with the following fields:

| Field | Type | Description |
|-------|------|-------------|
| `platform` | string | The platform where the position is held |
| `market_id` | string | The platform-specific market identifier |
| `market_title` | string | Human-readable market title |
| `outcome` | string | The outcome you hold ("Yes" or "No") |
| `shares` | number | Number of shares owned |
| `avg_price` | number | Average purchase price per share |
| `cost_basis` | number | Total cost of the position |
| `category` | string | Market category for exposure analysis |
| `status` | string | "open" or "closed" |

### Cost Basis Calculation

```
cost_basis = shares x avg_price
```

When adding to an existing position:
```
new_avg_price = (old_cost_basis + new_shares x new_price) / (old_shares + new_shares)
new_cost_basis = (old_shares + new_shares) x new_avg_price
```

## PnL Calculation

### Unrealized PnL (Open Positions)

For each open position, given the current market price:

```
current_value  = shares x current_price
unrealized_pnl = current_value - cost_basis
roi_pct        = ((current_value - cost_basis) / cost_basis) x 100
```

### Realized PnL (Closed Positions)

For positions that have been closed (market resolved or position sold):

```
realized_pnl = exit_value - cost_basis
roi_pct      = ((exit_value - cost_basis) / cost_basis) x 100
```

For resolved markets:
- If your outcome **won**: `exit_value = shares x 1.00`
- If your outcome **lost**: `exit_value = shares x 0.00`

## Portfolio Summary

Aggregate metrics across all positions:

```
total_invested      = sum(cost_basis) for all positions
total_current_value = sum(current_value) for all open positions
                    + sum(exit_value) for all closed positions
total_pnl           = total_current_value - total_invested
total_pnl_pct       = (total_pnl / total_invested) x 100
```

### Position Counts

```
open_count   = count of positions where status = "open"
closed_count = count of positions where status = "closed"
won_count    = count of closed positions where outcome was correct
lost_count   = count of closed positions where outcome was incorrect
```

### Win Rate

```
win_rate = (won_count / (won_count + lost_count)) x 100
```

If `won_count + lost_count = 0`, win rate is undefined (no resolved positions yet).

### Trade Statistics

```
best_trade_pnl  = max(pnl) across all closed positions
worst_trade_pnl = min(pnl) across all closed positions
avg_position_size = total_invested / (open_count + closed_count)
```

## Exposure Breakdown

Exposure analysis shows how the portfolio is distributed across different dimensions.

### By Platform

```
For each platform:
    platform_exposure = sum(current_value) for positions on that platform
    platform_pct      = (platform_exposure / total_exposure) x 100
```

### By Category

```
For each category:
    category_exposure = sum(current_value) for positions in that category
    category_pct      = (category_exposure / total_exposure) x 100
```

### By Outcome

```
yes_exposure = sum(current_value) for positions where outcome = "Yes"
no_exposure  = sum(current_value) for positions where outcome = "No"
```

### Concentration Risk

```
total_exposure       = sum(current_value) for all open positions
largest_position     = max(current_value) across all open positions
largest_position_pct = (largest_position / total_exposure) x 100
```

A `largest_position_pct` above 30% indicates high concentration risk.

## Alerts

Set up alerts to monitor portfolio conditions:

| Alert Type | Parameter | Trigger Condition |
|-----------|-----------|-------------------|
| `odds_above` | `threshold` (0-1) | Current price of a tracked market rises above threshold |
| `odds_below` | `threshold` (0-1) | Current price of a tracked market falls below threshold |
| `resolved` | *(none)* | A tracked market has resolved |

### Alert Evaluation

For each open position:
1. Fetch the current market price.
2. Check all configured alerts:
   - **odds_above**: `current_price > threshold` -- triggers when a market becomes more likely.
   - **odds_below**: `current_price < threshold` -- triggers when a market becomes less likely.
   - **resolved**: `market.status == "resolved"` -- triggers when a market resolves.
3. Return all triggered alerts with position details.

See `references/metrics.md` for a consolidated portfolio metrics reference.
