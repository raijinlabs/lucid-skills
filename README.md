# Lucid Predict

Prediction market intelligence skills for AI agents. Pure markdown domain knowledge covering odds analysis, Kelly criterion position sizing, cross-platform arbitrage detection, and portfolio tracking.

## Install

### Claude Code

```bash
claude install lucid-predict
```

### OpenClaw

```bash
openclaw install lucid-predict
```

## Skills

| Skill | Description |
|-------|-------------|
| **market-research** | Search, discover, and analyze prediction markets across Polymarket, Manifold, and Kalshi |
| **odds-analysis** | Expected value calculation, Kelly criterion position sizing, odds conversion, and market efficiency |
| **arbitrage** | Cross-platform arbitrage detection — find mispricings across platforms |
| **portfolio** | Position tracking, PnL calculation, exposure analysis, and performance metrics |

## Project Structure

```
lucid-predict/
  skill.yaml                              # Package manifest
  HEARTBEAT.md                            # Periodic monitoring checks
  skills/
    market-research/
      SKILL.md                            # Market search and analysis
      references/
        platforms.md                      # API endpoints and data models
    odds-analysis/
      SKILL.md                            # EV, Kelly, efficiency analysis
      references/
        formulas.md                       # Consolidated formula reference
    arbitrage/
      SKILL.md                            # Cross-platform arbitrage detection
    portfolio/
      SKILL.md                            # Position and PnL tracking
      references/
        metrics.md                        # Portfolio metrics reference
  .claude-plugin/
    plugin.json                           # Claude Code manifest
  openclaw.plugin.json                    # OpenClaw manifest
```

## Part of Lucid Foundation

This package is part of the **Lucid Foundation** ecosystem of AI agent skills.

## License

MIT
