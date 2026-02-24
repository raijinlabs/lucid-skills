# Portfolio Metrics Reference

A consolidated reference of all portfolio formulas and metrics.

---

## Position Tracking

```
cost_basis = shares x avg_price
```

Adding to a position:
```
new_avg_price  = (old_cost_basis + new_shares x new_price) / (old_shares + new_shares)
new_cost_basis = (old_shares + new_shares) x new_avg_price
```

---

## PnL Formulas

### Unrealized (Open)

```
current_value  = shares x current_price
unrealized_pnl = current_value - cost_basis
roi_pct        = ((current_value - cost_basis) / cost_basis) x 100
```

### Realized (Closed)

```
realized_pnl = exit_value - cost_basis
roi_pct      = ((exit_value - cost_basis) / cost_basis) x 100
```

Resolution payouts:
- Won: `exit_value = shares x 1.00`
- Lost: `exit_value = shares x 0.00`

---

## Portfolio Summary

```
total_invested      = sum(cost_basis) for all positions
total_current_value = sum(current_value) for open + sum(exit_value) for closed
total_pnl           = total_current_value - total_invested
total_pnl_pct       = (total_pnl / total_invested) x 100
```

---

## Position Counts and Win Rate

```
open_count   = count(status = "open")
closed_count = count(status = "closed")
won_count    = count(closed AND outcome correct)
lost_count   = count(closed AND outcome incorrect)
win_rate     = (won_count / (won_count + lost_count)) x 100
```

---

## Trade Statistics

```
best_trade_pnl    = max(pnl) across closed positions
worst_trade_pnl   = min(pnl) across closed positions
avg_position_size = total_invested / (open_count + closed_count)
```

---

## Exposure Analysis

### By Platform

```
platform_exposure = sum(current_value) per platform
platform_pct      = (platform_exposure / total_exposure) x 100
```

### By Category

```
category_exposure = sum(current_value) per category
category_pct      = (category_exposure / total_exposure) x 100
```

### By Outcome

```
yes_exposure = sum(current_value) where outcome = "Yes"
no_exposure  = sum(current_value) where outcome = "No"
```

### Concentration

```
total_exposure       = sum(current_value) for all open positions
largest_position     = max(current_value) across open positions
largest_position_pct = (largest_position / total_exposure) x 100
```

High concentration warning: `largest_position_pct > 30%`

---

## Alert Thresholds

| Alert | Condition |
|-------|-----------|
| `odds_above` | `current_price > threshold` |
| `odds_below` | `current_price < threshold` |
| `resolved` | `market.status == "resolved"` |
