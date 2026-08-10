# Blaque Baux Bottom

**Bottom of the barrel. Sub-small-cap, micro/nano-cap, and penny names — the least efficient, least liquid, most treacherous corner of the market.**

Bottom is a member of the Blaque Baux family. The [core repo](https://github.com/Carter-Warrens/blaquebaux)
is the **engine and blueprint**. Bottom points that engine at the bottom of the market-cap
ladder, where mispricing is largest — and so are transaction costs, liquidity risk,
delisting, and outright fraud. This is the corner where the engine's governance matters
*most*: staleness gates, market-impact awareness, and hard position/loss caps are the
difference between an edge and a blow-up.

> **Not investment advice.** Educational/research software. Micro-cap and penny stocks carry
> extreme liquidity, delisting, and fraud risk. Nothing here is validated. See [LICENSE](LICENSE).

```bash
git clone --recursive https://github.com/Carter-Warrens/blaquebaux-bottom.git
julia --project=engine -e 'using Pkg; Pkg.instantiate()'   # one-time engine setup
```

## The thesis

The base research found a genuine short-term **contrarian bounce** in beaten-down names —
strongest when selected by *drawdown* (the Ulcer/Pain screen: ~+0.46 beta-neutral Sharpe,
the best of that trio). That effect is plausibly *larger* at the bottom of the cap ladder,
where forced selling and illiquidity overshoot hardest — but it is also where costs and
zeros eat naive edges alive. Bottom's job is to separate the real bounce from the value
traps and frauds, and to trade it only where liquidity and borrow actually permit.

## Research plan (Path A — not yet built)

- **Drawdown-bounce, cap-scaled** — extend the base's beta-neutral loser-bounce screen down
  the cap ladder; measure whether the edge grows faster than the cost.
- **Quality/junk filters** — screens to avoid dilution, going-concern, and fraud (the zeros
  that ruin a naive low-price basket).
- **Liquidity & impact modeling** — realistic spreads/ADV caps; many names are simply
  untradeable, and the backtest must say so.
- **Survivorship & delisting honesty** — point-in-time universes; delisted names kept in.

Data caveat: many sub-small-cap / OTC names are not tradeable on the paper venue; the
tradeable subset is the real universe, and results will be reported on it, not a clean
survivor list.

## Research — first pass done

Full detail in [`research/README.md`](research/README.md). The scorecard:

| # | Question | Verdict |
|---|----------|---------|
| 1 | Does the drawdown-bounce grow at the bottom? | ❌ no — same edge, worse after cost (large +0.52 vs small +0.45 net) |
| 2 | Is there a small-cap premium? | ❌ no — SPY +0.88 → IWM +0.58 → IWC +0.55, deeper drawdowns |

**The synthesis:** the cap-ladder hypothesis is rejected. Small/mid-caps have more dispersion
(1.84 vs 1.46 %/d) but the drawdown-bounce is the *same* magnitude gross and *worse* net after
the higher cost — the extra dispersion is idiosyncratic (Bio-like), not more mean-reverting.
There's no small-cap premium either (smaller = more vol, deeper drawdowns, lower Sharpe). And
the honest caveats make the true bottom worse than measured: the basket is **survivors only**
(the delisted zeros are gone, flattering "long the losers"), and true penny/OTC names are
**untradable** (no clean data, wide spreads, borrow, fraud). Harvest the drawdown-bounce in
**large caps** (Bore / Blunt #5) — the bottom adds cost, noise, and survivorship illusion, not edge.

## Status
**Research: first pass complete — null** (`research/`). No cap-ladder edge; the bounce is a
large-cap play. No live driver. Nothing validated to the spine's bar.

## The Blaque Baux family
This repo is one sleeve of the **Blaque Baux** family — a single governed engine steered in
many directions. The [core repo](https://github.com/Carter-Warrens/blaquebaux) is the
base/blueprint and holds the [full family roster](https://github.com/Carter-Warrens/blaquebaux#the-blaque-baux-family).

## Layout
```
engine/     the Blaque Baux platform (git submodule → Carter-Warrens/blaquebaux)
research/   two Path-A sketches (bounce by cap tier, cap tiers) + scorecard
live/       governed live drivers (once a sleeve graduates to paper A/B)
```

## License
[MIT](LICENSE). © 2026 Carter Warrens.
