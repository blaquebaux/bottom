# Blaque Baux Bottom

**Bottom of the barrel. Sub-small-cap, micro/nano-cap, and penny names — the least efficient, least liquid, most treacherous corner of the market.**

Bottom is a member of the Blaque Baux family. The [core repo](https://github.com/blaque-baux/base)
is the **engine and blueprint**. Bottom points that engine at the bottom of the market-cap
ladder, where mispricing is largest — and so are transaction costs, liquidity risk,
delisting, and outright fraud. This is the corner where the engine's governance matters
*most*: staleness gates, market-impact awareness, and hard position/loss caps are the
difference between an edge and a blow-up.

> **Not investment advice.** Educational/research software. Micro-cap and penny stocks carry
> extreme liquidity, delisting, and fraud risk. Nothing here is validated. See [LICENSE](LICENSE).

```bash
git clone --recursive https://github.com/blaque-baux/bottom.git
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
**Research: first pass complete; large-cap drawdown-bounce — standalone driver built** (`research/` +
`live/`). The penny/cap-ladder edge was rejected; the keeper is the large-cap pullback.

`live/bottom_live.jl` runs the drawdown-bounce on its own through the engine's governed order path +
Layer-3 safety gate: long the most-fallen quintile of quality large caps by trailing 60-day return,
equal-weight. **Dry-run by default** (logs the target, places nothing); graduates to Alpaca paper with
its own isolated keys/ledger. Not validated to the spine's bar.
```bash
BB_DRYRUN=1 julia --project=engine live/bottom_live.jl    # compute + log today's book, no orders
```

## About Blaque Baux

**Blaque Baux** is a quantitative research initiative and a subsidiary of **[Carter Warrens](https://carterwarrens.com)**.
[**BlaqueBaux.com**](https://blaquebaux.com) is the home for the work; the code lives here on GitHub — open to
study, test, and build bespoke strategies on top of.

Anyone can point an AI at a market. The edge is **understanding what the data actually says — and turning it
into something you can act on.** We test relentlessly and put most of it *on the record as rejected, with the
reason*; what survives is built, governed, and validated before it is ever called real. That combination —
honest research, reproducible evidence, and execution you can trust — is why Carter Warrens leads on
**strategy and implementation**, not merely uses the tools everyone now has.

## The Blaque Baux family
This repo is one sleeve of the **Blaque Baux** family — a single governed engine steered in
many directions. The [core repo](https://github.com/blaque-baux/base) is the
base/blueprint and holds the [full family roster](https://github.com/blaque-baux/base#the-blaque-baux-family).

## Layout
```
engine/     the Blaque Baux platform (git submodule → blaque-baux/base)
research/   two Path-A sketches (bounce by cap tier, cap tiers) + scorecard
live/       governed live drivers (once a sleeve graduates to paper A/B)
```

## License
[MIT](LICENSE). © 2026 Carter Warrens.
