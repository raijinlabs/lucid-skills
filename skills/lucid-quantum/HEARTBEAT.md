# Heartbeat Checks

Periodic health checks for the Before Quantum GPU fleet.

## 1. Worker Connectivity

Verify that GPU workers are online and reporting heartbeats.

- Call `quantum_protect` to get fleet health status
- **Alert** if overall risk is HIGH or CRITICAL
- **Alert** if more than 50% of workers are offline
- **Alert** if total throughput drops below 1M keys/sec
- Check that no workers have been offline for more than 1 hour without explanation

## 2. Mode Progress Monitoring

Ensure all active modes are making progress.

- Call `quantum_fleet` to get mode status
- **Alert** if any non-exhausted mode has priority_weight=0 (stalled)
- **Alert** if any finite mode has been stuck at the same percent_complete for more than 2 hours
- Report number of modes exhausted vs. remaining

## 3. Intelligence Freshness

Verify that intelligence data is being updated.

- Call `quantum_triage` with a small limit to check if mode_scores are computed
- **Alert** if triage scores are all equal (suggesting no metadata is populated)
- **Alert** if no fingerprints exist when target count > 0
- Recommend running `quantum_optimize` if weights haven't been updated in 24 hours

## 4. Brain Wallet Strategy Health

Check brain wallet strategy performance.

- Call `quantum_brain` to review strategy hit rates
- **Alert** if any active strategy has 0 hits after 100K+ candidates
- **Alert** if total brain wallet throughput drops to zero
- Report best-performing strategy and recommend scaling it up

## 5. Cost Efficiency

Monitor GPU resource utilization.

- Call `quantum_cost` to get per-mode efficiency data
- **Alert** if any mode costs > 200 GPU-seconds per billion keys (extremely inefficient)
- **Alert** if estimated remaining time for all modes exceeds 1 year
- Recommend priority rebalancing if cost variance between modes exceeds 10x
