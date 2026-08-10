# Blaque Baux Bottom — research

First-pass Path-A research on the sub-small-cap / penny sleeve. The hypothesis: the base's
drawdown-**bounce** (long high-Ulcer names, beta-neutral — Blunt #5 / Bore, ~+0.5 Sharpe in
large caps) should be *larger* at the bottom of the cap ladder, where forced selling
overshoots hardest. All sketches read Alpaca SIP daily bars, are read-only, print their
results.

**Data caveat (which is itself the finding):** the small-cap basket is **survivors only**
(2016–2026), and true penny/OTC names mostly lack tradable SIP data. So these results
*over-state* the tradable bottom — the names that went to zero are absent, and the most
inefficient names are untradable.

```bash
export $(grep -v '^#' ~/.config/blaquebaux/alpaca.env | xargs)   # or source it
python research/bottom_1_bounce_by_cap.py   # does the bounce grow at the bottom?
python research/bottom_2_cap_tiers.py        # holding the tiers + the honest caveats
```

## Scorecard

| # | Question | Result | Verdict |
|---|----------|--------|---------|
| 1 | Does the drawdown-bounce grow at the bottom? | large NET@2bp +0.52 vs small NET@8bp +0.45 | ❌ no — same edge, worse after cost |
| 2 | Is there a small-cap premium (buy&hold)? | SPY +0.88 → IWM +0.58 → IWC +0.55, deeper DD | ❌ no — smaller = worse risk/reward |

## The synthesis — the bottom adds cost and risk, not edge

- **#1 — the cap-ladder hypothesis is rejected at the tradable level.** Small/mid-caps do have
  more cross-sectional dispersion (1.84 vs 1.46 %/day), but the drawdown-bounce is the **same
  magnitude gross** (+0.51 vs +0.54) and, after the higher trading cost, **worse net** (+0.45
  vs +0.52). The extra dispersion is *idiosyncratic* (Bio-like), not more mean-reverting — so
  it does not amplify the bounce. The bounce degrades gracefully with cost (still +0.35 at 20
  bp/side), so cost isn't the killer; the edge simply isn't bigger down here.

- **#2 — no small-cap premium.** Over this sample smaller means more volatility and deeper
  drawdowns at a *lower* Sharpe: SPY +0.88/−34% → small-600 +0.60/−44% → micro +0.55/−47%.

- **And the honest caveats make the true bottom worse than measured.** Survivorship flatters
  "long the losers" (the delisted zeros are gone — a fat left tail is missing), and the most
  inefficient names are *untradable* (no clean data, wide spreads, borrow, fraud risk). The
  measured +0.45 is an upper bound on a slice you can't fully access.

**Verdict:** Bottom offers no advantage over harvesting the drawdown-bounce in **large caps**
(where Bore / Blunt #5 already do it at +0.5 net, cleaner and cheaper). The bottom of the cap
ladder adds cost, idiosyncratic noise, survivorship illusion, and fraud risk — not amplified
mean-reversion. A documented null.

## Files
- `_bottom_common.py` — shared helpers + the large- and small-cap baskets (survivors).
- `bottom_1_bounce_by_cap.py` — the drawdown-bounce by cap tier + cost break-even.
- `bottom_2_cap_tiers.py` — buy&hold by tier + the survivorship / liquidity honesty.
