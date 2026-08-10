#!/usr/bin/python3
# =============================================================================
# bottom_2_cap_tiers.py — BLAQUE BAUX BOTTOM #2 (holding the bottom, and the honest caveats).
#
# Smaller-cap = more volatility and DEEPER drawdowns, with LOWER risk-adjusted return over
# this sample — no small-cap premium. And two structural problems make the *true* bottom even
# worse than these ETFs suggest:
#   - SURVIVORSHIP: a basket of names that still exist omits everything that went to zero, so
#     "long the losers" is flattered; the real distribution has a fat left tail of delistings.
#   - LIQUIDITY / TRADABILITY: true penny/OTC names mostly lack tradable SIP data, so the
#     tradable "bottom" is a thin, cost-heavy slice — the illiquid names where the edge might
#     be largest are exactly the ones you cannot trade.
#
# RESULTS AS TESTED (ETF tiers, 2016-2026):
#   SPY (large)      Sharpe +0.88  vol 18%  maxDD -34%
#   IJR (small-600)  Sharpe +0.60  vol 22%  maxDD -44%
#   IWM (small-2000) Sharpe +0.58  vol 23%  maxDD -41%
#   IWC (micro)      Sharpe +0.55  vol 24%  maxDD -47%
# Read-only.
# =============================================================================
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _bottom_common import panel, stats

u, ds, M = panel(["SPY", "IJR", "IWM", "IWC"]); R = {s: M[:, u.index(s)][1:] / M[:, u.index(s)][:-1] - 1 for s in u}
lab = {"SPY": "large", "IJR": "small-600", "IWM": "small-2000", "IWC": "micro"}
print("=" * 74, "\nBOTTOM #2 — holding the cap tiers (smaller = worse risk/reward)\n" + "=" * 74)
for s in ["SPY", "IJR", "IWM", "IWC"]:
    a, d, v = stats(R[s]); print(f"  {s:<5} ({lab[s]:<10}): Sharpe {a:+.2f}  vol {v*100:.0f}%  maxDD {d*100:.0f}%")
print("\nVERDICT: no small-cap premium over this sample — smaller means more vol and deeper")
print("drawdowns at a lower Sharpe. And the tradable results OVER-state the true bottom:")
print("survivorship flatters the losers, and the most inefficient names are untradable.")
print("Harvest the drawdown-bounce in large caps; the bottom is not worth the cost and risk.")
