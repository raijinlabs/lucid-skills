---
name: arbitrage
description: "Cross-platform arbitrage detection for prediction markets — find mispricings across Polymarket, Manifold, and Kalshi"
---

# Arbitrage Detection

Detect cross-platform arbitrage opportunities in prediction markets. When the same event is priced differently on two platforms, a guaranteed profit may exist.

## Arbitrage Concept

Arbitrage exists when you can buy YES on Platform A and NO on Platform B (or vice versa) for a combined cost of less than $1.00. Since one of YES or NO must resolve to $1.00, the difference is guaranteed profit.

**Example:**
- Platform A prices "Will X happen?" YES at $0.40
- Platform B prices "Will X happen?" NO at $0.50

Combined cost: $0.40 + $0.50 = $0.90
Guaranteed payout: $1.00
Guaranteed profit: $0.10 (11.1% return)

## Requirements

Arbitrage detection **requires at least 2 configured providers**. If only one platform is available, cross-platform comparison is impossible and no arbitrage opportunities can be found.

## Detection Procedure

### Step 1: Fetch Open Markets

Fetch all open markets from each configured platform:
- Polymarket: `GET /events` (filter for active markets)
- Manifold: `GET /search-markets` (filter for open markets)
- Kalshi: *(when integrated)*

### Step 2: Match Markets Across Platforms

For every market on Platform A, check if the same market exists on Platform B. Two markets are considered a match if **either** condition is met:

#### Exact Match
1. Convert both titles to lowercase.
2. Remove all special characters (keep only alphanumeric and spaces).
3. Compare the cleaned strings for exact equality.

#### Fuzzy Match (Word Overlap)
1. Split each cleaned title into individual words.
2. Count the number of words that appear in both titles.
3. Calculate overlap percentage: `overlap = shared_words / max(words_in_A, words_in_B)`
4. If `overlap >= 0.60` (60% or more words in common), it is a match.

### Step 3: Calculate Spread

For each matched market pair:

```
spread = ((priceB - priceA) / priceA) x 100
```

Where:
- `priceA` is the YES price on the cheaper platform
- `priceB` is the equivalent YES price on the more expensive platform

A positive spread means Platform B prices the outcome higher than Platform A.

### Step 4: Filter by Minimum Spread

Only record opportunities where:

```
spread >= minSpreadPct
```

Default `minSpreadPct` = **3%**

Spreads below this threshold are unlikely to be profitable after accounting for fees, slippage, and execution delay.

### Step 5: Return Results

Return the **top 20 opportunities** sorted by spread descending (largest mispricing first).

Each opportunity should include:
- Market title
- Platform A name, price, and market URL
- Platform B name, price, and market URL
- Spread percentage
- Combined cost (priceA + (1 - priceB) for YES/NO arb)
- Estimated profit per $1 deployed

## Title Matching Algorithm (Detail)

```
function titlesMatch(titleA, titleB):
    cleanA = lowercase(titleA).replace(/[^a-z0-9\s]/g, "").trim()
    cleanB = lowercase(titleB).replace(/[^a-z0-9\s]/g, "").trim()

    // Exact match
    if cleanA == cleanB:
        return true

    // Word overlap
    wordsA = split(cleanA, " ")
    wordsB = split(cleanB, " ")
    shared = count of words in wordsA that also appear in wordsB
    overlapPct = shared / max(len(wordsA), len(wordsB))

    return overlapPct >= 0.60
```

## Risk Factors

Even when a mathematical arbitrage exists, real-world risks can erode or eliminate the profit:

| Risk | Description |
|------|-------------|
| **Execution delay** | Prices may change between placing the two legs of the trade. |
| **Liquidity differences** | One platform may not have enough liquidity to fill your order at the quoted price. |
| **Resolution risk** | Platforms may resolve the same event differently (different rules, different interpretations). |
| **Fee structures** | Trading fees, withdrawal fees, and platform-specific costs reduce net profit. |
| **Capital lockup** | Funds are locked until market resolution, which may be weeks or months away. |

## Best Practices

1. **Verify the match manually** -- Automated title matching can produce false positives. Always confirm both markets refer to the same event with the same resolution criteria.
2. **Check liquidity on both sides** -- Ensure sufficient depth to execute both legs at the expected prices.
3. **Account for all fees** -- Include trading fees, withdrawal fees, and any spread costs.
4. **Execute both legs simultaneously** -- Minimize the window for price changes.
5. **Start small** -- Test with small amounts before scaling up.
