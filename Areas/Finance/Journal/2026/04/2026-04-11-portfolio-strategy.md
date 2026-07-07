---
title: "portfolio-strategy"
date: 2026-04-11
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/investing]
status: active
source_file: "3. Personal/Personal Finance/portfolio-strategy.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# portfolio-strategy

## meta

- owner: Thomas Wielinga
- broker: Trading 212 (Invest account)
- vehicle: single pie — AutoInvest
- horizon: 30+ years
- base_currency: EUR
- start_date: 2026-04
- last_updated: 2026-04-11

---

## holdings

| ticker | isin | name | asset_class | sleeve | target_weight | ter |
|--------|------|------|-------------|--------|---------------|-----|
| VWCE | IE00B3RBWM25 | Vanguard FTSE All-World Acc | equity_global | equity | 0.25 | 0.0022 |
| WTAI | IE00BDVPNG13 | WisdomTree Artificial Intelligence UCITS ETF Acc | equity_thematic | equity | 0.10 | 0.0040 |
| EXUS | IE0006WW1TQ4 | Xtrackers MSCI World ex-USA Acc | equity_ex_us | equity | 0.15 | 0.0015 |
| AVWS | IE0003R87OG3 | Avantis Global Small Cap Value Acc | equity_factor | equity | 0.15 | 0.0025 |
| IGLN | IE00B8Y8SV60 | iShares Physical Gold ETC | gold | real_assets | 0.20 | 0.0012 |
| ICOM | IE00BDFL4P12 | iShares Diversified Commodity Swap UCITS ETF | commodities | real_assets | 0.15 | 0.0019 |

- total_weight: 1.00
- weighted_avg_ter: 0.00209
- accumulating: true (all six ETFs — no dividend distributions)

---

## sleeves

| sleeve | weight |
|--------|--------|
| equity | 0.65 |
| real_assets | 0.35 |

---

## contributions

- schedule: monthly
- execution_day: 1
- method: SEPA bank transfer
- mode: AutoInvest — Self-Balancing
- regular_amount: 500 EUR
- currency: EUR

### self-balancing behaviour

On each AutoInvest event, new funds are allocated to whichever slices are furthest below their target weights. No sells are triggered. No manual action required.

---

## dip_buying_rule

- reserve_amount: 2000 EUR
- reserve_location: T212 cash balance (not invested)
- deploy_amount: 1000 EUR per trigger
- trigger: ETF price down >= 10% from its 3-month rolling high, measured at month-end
- scope: any of the six ETFs individually
- cap: max 1 deployment per ETF per quarter
- replenishment: restore reserve to 2000 EUR before next AutoInvest cycle

---

## rebalancing

- primary_method: self_balancing via contributions (automatic, no action required)
- drift_check: annually in January
- soft_threshold: 0.10 (10pp drift — correct via next 3 months of contributions)
- hard_threshold: 0.15 (15pp drift — trigger manual rebalance)
- manual_rebalance_method: T212 one-click rebalance on overweight slices only

---

## annual_review

- month: January
- checks:
  - weight_drift: compare actual vs target weights
  - thesis_review: assess whether underlying investment case for each ETF has changed
  - box3_record: capture portfolio peildatum value as of 1 January for Dutch income tax aangifte

---

## glide_path

- start_year: 20
- end_year: 30
- method: redirect contributions — no forced sells
- annual_shift: 0.01 to 0.02 (1-2pp per year from equity to stable assets)

### target_allocation_at_retirement

| ticker | target_weight |
|--------|---------------|
| VWCE | 0.20 |
| EXUS | 0.15 |
| WTAI | 0.05 |
| AVWS | 0.05 |
| IGLN | 0.25 |
| ICOM | 0.10 |
| AGGH | 0.20 |

---

## five_year_thesis_triggers

- EXUS: review if USD reserve currency status has materially weakened and non-US outperformance has confirmed — consider folding back into VWCE
- WTAI: review if AI compute has become a commoditised utility — consider rotating into VWCE
- ICOM: review if commodities have been a persistent drag with no crisis-period outperformance — consider reducing weight

---

## tax

- jurisdiction: Netherlands
- box: Box 3
- peildatum: 1 January each year
- pre_populated: false (Trading 212 not included in vooraf ingevulde aangifte — manual entry required)
- also_report: DEGIRO account (separate broker, also manual)
