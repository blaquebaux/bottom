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

## Status
**Scaffold.** Engine wired as a submodule; strategy research not yet conducted.

## The Blaque Baux family
Base: **Blaque Baux** (engine + spine). Sleeves: **Blunt** (short-horizon tactical) · **Boom** (mega-cap blue chips) · **Brash** (crypto/alternatives) · **Bleed** (tail-catcher) · **Bottom** *(this repo)* · **Brittle** (near-expiry OTM options) · **Broad** (broad/thematic ETFs) · **Bore** (market-neutral) · **Bulk** (defense) · **Brown** (conservative sectors) · **Blue** (entertainment/green-energy/tech) · **Beyond** (short-horizon growth) · **Bubble** (the AI complex) · **Basel** (Basel-regulated banks) · **Bio** (biotech / idiosyncratic) · **Bounce** (range-bound 'kangaroo' market) · **EMEA** (Europe/Middle East/Africa) · **APAC** (Asia-Pacific) · **LATAM** (Latin America) · **BitDollar** (crypto / dollar axis) · **Blurred** (uncorrelated basket) · **Backsliders** (broken decliners (short)) · **Brute Force** (artificially propped-up) · **Block** (derivative-strategy basket).

## Layout
```
engine/     the Blaque Baux platform (git submodule → Carter-Warrens/blaquebaux)
research/   Path-A strategy sketches (to come)
live/       governed live drivers (once a sleeve graduates to paper A/B)
```

## License
[MIT](LICENSE). © 2026 Carter Warrens.
