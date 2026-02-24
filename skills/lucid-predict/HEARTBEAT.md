# Heartbeat Checks

Periodic monitoring tasks to keep the prediction market portfolio healthy and up to date.

---

## 1. Position Monitoring

**Purpose:** Check PnL on all open positions and alert if significant losses occur.

**Procedure:**
1. For each open position, fetch the current market price from the respective platform.
2. Calculate unrealized PnL: `unrealized_pnl = (shares x current_price) - cost_basis`
3. Calculate ROI: `roi_pct = ((current_value - cost_basis) / cost_basis) x 100`
4. **Alert** if any position has `roi_pct < -20%` (significant loss threshold).
5. **Alert** if total portfolio `total_pnl_pct < -10%`.
6. Report a summary of all position changes since the last check.

---

## 2. Market Resolution

**Purpose:** Check if any tracked markets have resolved and update position statuses.

**Procedure:**
1. For each open position, query the market status from the platform API.
2. If `status == "resolved"`:
   - Determine the winning outcome.
   - Calculate realized PnL for the position.
   - Mark the position as "closed".
   - Report: market title, winning outcome, PnL, ROI%.
3. Log any markets that have moved to "closed" (trading stopped, pending resolution).
4. Log any markets that are "disputed" (resolution contested).

---

## 3. Arbitrage Scan

**Purpose:** Run cross-platform arbitrage detection to find new mispricing opportunities.

**Procedure:**
1. Fetch current open markets from all configured platforms.
2. Match markets across platforms using the title matching algorithm (exact match after cleaning, or >=60% word overlap).
3. For matched pairs, calculate the spread: `spread = ((priceB - priceA) / priceA) x 100`
4. Filter for spreads >= 3% (minimum profitable spread).
5. Report the top opportunities sorted by spread descending.
6. Flag any opportunities involving markets the user already has positions in (potential hedge or conflict).

---

## 4. Portfolio Health

**Purpose:** Assess overall portfolio health including exposure concentration and risk metrics.

**Procedure:**
1. Calculate total exposure: `total_exposure = sum(current_value)` across all open positions.
2. Calculate concentration risk:
   - `largest_position_pct = max(current_value) / total_exposure x 100`
   - **Alert** if `largest_position_pct > 30%` (over-concentrated).
3. Calculate platform exposure:
   - For each platform, `platform_pct = sum(current_value on platform) / total_exposure x 100`
   - **Alert** if any single platform > 70% of total exposure.
4. Calculate category exposure:
   - For each category, `category_pct = sum(current_value in category) / total_exposure x 100`
   - **Alert** if any single category > 50% of total exposure.
5. Report win rate, average position size, and overall PnL.
