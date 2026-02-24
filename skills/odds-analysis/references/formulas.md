# Odds Analysis Formula Reference

A consolidated reference of all formulas used in odds analysis.

---

## Odds Conversion

| Conversion | Formula |
|-----------|---------|
| Probability to Decimal | `decimal = 1 / probability` |
| Decimal to Probability | `probability = 1 / decimal` |
| Decimal to American (+) | `american = (decimal - 1) x 100` (when decimal >= 2.00) |
| Decimal to American (-) | `american = -100 / (decimal - 1)` (when decimal < 2.00) |
| American (+) to Decimal | `decimal = (american / 100) + 1` |
| American (-) to Decimal | `decimal = (100 / |american|) + 1` |
| Price to Implied Prob | `implied_probability = price` (binary markets) |
| Fractional to Decimal | `decimal = (numerator / denominator) + 1` |
| Decimal to Fractional | `fractional = (decimal - 1) / 1` (simplify) |

---

## Expected Value

```
payout         = stake / price
expectedPayout = probability x payout
ev             = expectedPayout - stake
roiPct         = (ev / stake) x 100
edgePct        = (probability - price) x 100
is_positive_ev = ev > 0
```

---

## Kelly Criterion

### Full Kelly

```
b  = (1 / price) - 1
p  = estimated probability of winning
q  = 1 - p
f* = (b x p - q) / b
f* = max(0, f*)
```

### Half-Kelly (Conservative)

```
halfKelly = f* / 2
```

### Position Sizing

```
kellyFraction = min(f*, max_fraction)     -- max_fraction default = 0.25
positionSize  = bankroll x kellyFraction
```

---

## Recommendation Thresholds

| Metric | Threshold | Action |
|--------|-----------|--------|
| Kelly | <= 0 | Don't bet |
| Edge | >= 15% | High confidence |
| Edge | >= 5% | Medium confidence |
| Edge | < 2% | Avoid |
| Edge > 5% AND Kelly > 0 | -- | Buy |

---

## Market Efficiency

### Overround

```
overround = (sum(all_prices) - 1) x 100%
```

### Vig

```
total = sum(all_prices)
vig   = ((total - 1) / total) x 100%
```

### Fair Prices

```
fair_price[i] = price[i] / sum(all_prices)
```

### Efficiency Test

```
is_efficient = |overround| <= 5%
```

---

## Liquidity Score (0-100)

```
volume_component    = min(50, (volume_usd / 100,000) x 50)
liquidity_component = min(50, (liquidity_usd / 50,000) x 50)
liquidity_score     = volume_component + liquidity_component
```

| Score Range | Rating |
|-------------|--------|
| 0-30 | Low liquidity |
| 30-70 | Medium liquidity |
| 70-100 | High liquidity |
