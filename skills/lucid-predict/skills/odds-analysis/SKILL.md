---
name: odds-analysis
description: "Expected value calculation, Kelly criterion position sizing, odds conversion, and market efficiency analysis"
---

# Odds Analysis

Calculate expected value, size positions with the Kelly criterion, convert between odds formats, and assess market efficiency. This skill contains all the formulas and decision logic needed for prediction market analysis.

## Odds Conversion

All formulas for converting between odds formats:

### Probability to Decimal Odds

```
decimal = 1 / probability
```

Example: 0.60 probability = 1.667 decimal odds.

### Decimal Odds to Probability

```
probability = 1 / decimal
```

### Decimal to American Odds

```
If decimal >= 2.00:
  american = (decimal - 1) x 100       (positive)

If decimal < 2.00:
  american = -100 / (decimal - 1)      (negative)
```

Examples:
- Decimal 2.50 = +150 American
- Decimal 1.50 = -200 American

### American to Decimal Odds

```
If american > 0:
  decimal = (american / 100) + 1

If american < 0:
  decimal = (100 / |american|) + 1
```

### Price to Implied Probability

For binary prediction markets, the price IS the implied probability:

```
implied_probability = price
```

A market priced at $0.65 implies a 65% probability of that outcome.

### Fractional to Decimal

```
decimal = (numerator / denominator) + 1
```

Example: 3/1 fractional = 4.00 decimal.

### Decimal to Fractional

```
fractional = (decimal - 1) / 1
```

Simplify the fraction to lowest terms.

## Expected Value Calculation

Given a **stake**, a **market price**, and your **estimated true probability**:

```
payout         = stake / price
expectedPayout = probability x payout
ev             = expectedPayout - stake
roiPct         = (ev / stake) x 100
edgePct        = (probability - price) x 100
is_positive_ev = ev > 0
```

### Worked Example

- Stake: $100
- Market price: 0.40 (implies 40% chance)
- Your estimated probability: 0.55 (you think 55% chance)

```
payout         = 100 / 0.40 = $250.00
expectedPayout = 0.55 x 250 = $137.50
ev             = 137.50 - 100 = $37.50
roiPct         = (37.50 / 100) x 100 = 37.5%
edgePct        = (0.55 - 0.40) x 100 = 15.0%
is_positive_ev = true
```

This is a +EV bet with a 15% edge and 37.5% expected ROI.

## Kelly Criterion

The Kelly criterion determines the optimal fraction of your bankroll to wager.

### Full Kelly Formula

```
f* = (b x p - q) / b
```

Where:
- **b** = net odds received on the wager = (1 / price) - 1
- **p** = your estimated probability of winning
- **q** = 1 - p (probability of losing)
- **f*** = fraction of bankroll to wager

### Clamping

```
f* = max(0, f*)
```

If f* is negative, the Kelly criterion says do not bet (the edge is not in your favor).

### Half-Kelly (Conservative)

```
halfKelly = f* / 2
```

Half-Kelly reduces variance at the cost of slightly lower expected growth. It is widely recommended for practical use because:
- Probability estimates are uncertain
- Markets can be illiquid
- Drawdowns are psychologically painful

### Position Sizing

```
kellyFraction = min(f*, max_fraction)
positionSize  = bankroll x kellyFraction
```

Where `max_fraction` defaults to **0.25** (25% of bankroll). This cap prevents over-concentration even when Kelly suggests a large bet.

### Worked Example

- Bankroll: $10,000
- Market price: 0.40
- Your probability: 0.55

```
b = (1 / 0.40) - 1 = 1.50
p = 0.55
q = 0.45
f* = (1.50 x 0.55 - 0.45) / 1.50 = (0.825 - 0.45) / 1.50 = 0.25
halfKelly = 0.25 / 2 = 0.125

Full Kelly position: $10,000 x 0.25 = $2,500
Half Kelly position: $10,000 x 0.125 = $1,250
```

## Recommendation Logic

Based on the calculated edge and Kelly fraction, generate a recommendation:

| Condition | Recommendation |
|-----------|---------------|
| `kelly <= 0` | **Don't bet** -- no edge detected |
| `edgePct >= 15%` | **High confidence** -- strong edge |
| `edgePct >= 5%` | **Medium confidence** -- moderate edge |
| `edgePct < 2%` | **Avoid** -- edge too thin to overcome fees/slippage |
| `edgePct > 5% AND kelly > 0` | **Buy** -- actionable positive-EV opportunity |

### Decision Flow

1. Calculate EV and Kelly as above.
2. If Kelly <= 0: recommend "Don't bet".
3. If edge < 2%: recommend "Avoid" (too thin).
4. If edge >= 5% and Kelly > 0: recommend "Buy".
5. Add confidence tag: High (>=15%), Medium (>=5%), or Low (<5%).
6. Size the position using Half-Kelly with the max_fraction cap.

## Market Efficiency Analysis

### Overround (Book Margin)

For a market with multiple outcomes:

```
overround = (sum(all_prices) - 1) x 100%
```

- Overround > 0%: The book has a built-in margin (prices sum to more than 1).
- Overround < 0%: The book is under-round (possible arbitrage).
- Overround = 0%: Perfectly fair book.

### Vig (Vigorish)

```
total = sum(all_prices)
vig   = ((total - 1) / total) x 100%
```

### Fair Prices (Removing the Vig)

```
fair_price[i] = price[i] / sum(all_prices)
```

This normalizes prices so they sum to exactly 1.00.

### Efficiency Assessment

A market is considered **efficient** if its overround is within +/-5% of zero.

```
is_efficient = |overround| <= 5%
```

### Liquidity Score

A composite score (0-100) measuring how tradeable a market is:

```
volume_component    = min(50, (volume_usd / 100,000) x 50)
liquidity_component = min(50, (liquidity_usd / 50,000) x 50)
liquidity_score     = volume_component + liquidity_component
```

- Score 0-30: Low liquidity -- wide spreads, hard to enter/exit
- Score 30-70: Medium liquidity -- tradeable with some slippage
- Score 70-100: High liquidity -- tight spreads, easy execution

See `references/formulas.md` for a consolidated formula reference sheet.
