# Heartbeat Checks

Periodic monitoring tasks for the lucid-defi package.

## DeFi Position Health

- **Health Factor Monitoring**: Check health factors on all lending/borrowing positions across Aave, Compound, Spark, Solend, and Marginfi. Alert if any position drops below 1.5.
- **Impermanent Loss Monitoring**: Calculate current IL on all active LP positions. Flag positions where IL exceeds fee income earned (underwater positions).
- **Yield Rate Changes**: Compare current APY against entry APY for all yield positions. Alert on drops exceeding 50% from entry rate.
- **TVL Trend Monitoring**: Track protocol TVL for all protocols where user has positions. Alert on declines exceeding 25% over 7 days.

## Airdrop Deadlines

- **Snapshot Date Tracking**: Check for newly announced or updated snapshot dates across all protocols being farmed. Flag any snapshots within 7 days as URGENT.
- **Claim Window Monitoring**: Track open claim windows for eligible airdrops. Alert when claim deadlines are within 7 days to prevent expiration.
- **Farming Progress Review**: Assess completion percentage of farming criteria for each active protocol. Prioritize protocols with upcoming snapshots.
- **New Airdrop Discovery**: Scan for newly rumored or announced airdrops matching the user's farming profile and budget.

## Bridge Transaction Monitoring

- **Pending Transfer Tracking**: Check status of all in-flight bridge transactions. Report current stage (INITIATED, PENDING, CONFIRMED, FINALIZED, COMPLETED).
- **Stuck Transaction Detection**: Flag any bridge transaction that has exceeded 2x the expected completion time. Provide escalation steps for transactions stuck over 24 hours.
- **Bridge Health Check**: Verify operational status of regularly used bridges before initiating new transfers. Check for reported exploits or paused operations.
- **Approval Hygiene**: Periodically review outstanding token approvals to bridge contracts. Recommend revoking unlimited approvals on bridges not actively in use.