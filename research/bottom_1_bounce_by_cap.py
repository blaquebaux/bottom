#!/usr/bin/python3
# =============================================================================
# bottom_1_bounce_by_cap.py — BLAQUE BAUX BOTTOM #1 (the cap-ladder hypothesis, rejected).
#
# The base found a drawdown-BOUNCE (long high-Ulcer names, beta-neutral: Blunt #5 / Bore,
# ~+0.5 Sharpe in large caps). The Bottom hypothesis: forced selling overshoots harder at
# the bottom of the cap ladder, so the bounce should be BIGGER there. FINDING: not at the
# tradable level. Small/mid-caps have more dispersion but the bounce is the SAME magnitude
# gross and, after the higher trading cost, WORSE net. The extra dispersion is idiosyncratic
# (Bio-like), not more mean-reverting — so it does not amplify the bounce.
#
# RESULTS AS TESTED (2016-2026, survivors only):
#   LARGE-cap:     dispersion 1.46%/d  gross +0.54  NET@2bp +0.52
#   SMALL/mid-cap: dispersion 1.84%/d  gross +0.51  NET@8bp +0.45
#   cost break-even (small-cap): 0bp +0.51 | 5bp +0.47 | 8bp +0.45 | 12bp +0.41 | 20bp +0.35
# Read-only.
# =============================================================================
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _bottom_common import LARGE, SMALL, prep_bounce, bounce, sharpe

RL, UL, dL = prep_bounce(LARGE); RS, US, dS = prep_bounce(SMALL)
print("=" * 74, "\nBOTTOM #1 — drawdown-bounce down the cap ladder\n" + "=" * 74)
print(f"  LARGE-cap:     dispersion {dL*100:.2f}%/d  gross {sharpe(bounce(RL,UL,0)):+.2f}  NET@2bp {sharpe(bounce(RL,UL,2)):+.2f}")
print(f"  SMALL/mid-cap: dispersion {dS*100:.2f}%/d  gross {sharpe(bounce(RS,US,0)):+.2f}  NET@8bp {sharpe(bounce(RS,US,8)):+.2f}")
print("\n  cost break-even (small-cap bounce, per-side):")
for c in [0, 2, 5, 8, 12, 20]:
    print(f"    @ {c:>2}bp: Sharpe {sharpe(bounce(RS,US,float(c))):+.2f}")
print("\nVERDICT: the bounce does NOT grow at the bottom — more dispersion but the same edge,")
print("worse after cost. The large-cap drawdown-bounce (Bore / Blunt #5) is the better home;")
print("the bottom adds cost and idiosyncratic noise, not amplified mean-reversion.")
