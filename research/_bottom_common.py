#!/usr/bin/python3
# =============================================================================
# _bottom_common.py — shared helpers for the Blaque Baux Bottom (sub-small-cap) sketches.
# Alpaca SIP daily bars; reads ALPACA_KEY_ID / ALPACA_SECRET_KEY from env. Read-only.
# CAVEAT: the small-cap basket is SURVIVORS ONLY (2016-2026); true penny/OTC names mostly
# lack tradable SIP data. Results here OVER-state the tradable bottom — that is the finding.
# =============================================================================
import os, json, urllib.request, math
import numpy as np

H = {"APCA-API-KEY-ID": os.environ["ALPACA_KEY_ID"], "APCA-API-SECRET-KEY": os.environ["ALPACA_SECRET_KEY"]}
START, END = "2016-01-01", "2026-08-01"
_cache = {}

LARGE = ["AAPL","MSFT","NVDA","AMZN","GOOGL","META","AVGO","JPM","V","MA","UNH","HD","PG","XOM","JNJ",
"COST","WMT","BAC","KO","PEP","CVX","MRK","CRM","ADBE","NFLX","AMD","INTC","QCOM","TXN","ORCL","DIS","GS","MS","CAT","HON","LLY","ABBV","TMO","NKE","WFC"]
# Liquid small/mid-caps with full 2016-2026 history (i.e. survivors — see caveat above).
SMALL = ["CROX","DECK","RMBS","PLAB","CALX","FORM","POWI","SLAB","DIOD","VICR","OSIS","ITRI","CVLT","PRGS","MANH",
"SAIA","LSTR","WERN","MATX","RHI","ASGN","EXLS","CBZ","HURN","EXPO","JJSF","WDFC","HELE","CENT","SCSC","PLXS","BMI","KAI","SXI","AWI","TREX","SHOO","CRAI","MGPI","UFPT"]

def closes(s):
    if s in _cache: return _cache[s]
    u = (f"https://data.alpaca.markets/v2/stocks/bars?symbols={s}&timeframe=1Day"
         f"&start={START}&end={END}&adjustment=all&feed=sip&limit=10000")
    b = json.load(urllib.request.urlopen(urllib.request.Request(u, headers=H), timeout=40)).get("bars", {}).get(s, [])
    _cache[s] = {x["t"][:10]: x["c"] for x in b}
    return _cache[s]

def panel(syms):
    D = {s: closes(s) for s in syms}; D = {s: v for s, v in D.items() if len(v) > 500}
    u = list(D); ds = sorted(set.intersection(*[set(v) for v in D.values()]))
    return u, ds, np.array([[D[s][d] for s in u] for d in ds], float)

def sharpe(r):
    r = np.asarray(r, float); r = r[np.isfinite(r)]
    return r.mean() / r.std() * math.sqrt(252) if len(r) > 30 and r.std() > 0 else float('nan')

def stats(r):
    r = np.asarray(r, float); r = r[np.isfinite(r)]; cum = np.cumprod(1 + r)
    return sharpe(r), (cum / np.maximum.accumulate(cum) - 1).min(), r.std() * math.sqrt(252)

def prep_bounce(basket):
    """Returns matrix, 60d-Ulcer scores, and daily cross-sectional dispersion."""
    u, ds, M = panel(basket); R = M[1:] / M[:-1] - 1; T, N = R.shape
    ulcer = np.full((T, N), np.nan)
    for t in range(60, T):
        seg = M[t - 60:t + 1]; dd = (seg / np.maximum.accumulate(seg, 0) - 1) * 100
        ulcer[t] = np.sqrt((dd ** 2).mean(0))
    return R, ulcer, np.nanmean(np.nanstd(R, 1))

def bounce(R, ulcer, cost_bps):
    """Long top-Ulcer quintile minus EW basket (beta-neutral drawdown-bounce), monthly, net."""
    T, N = R.shape; k = max(1, int(N * 0.2)); wp = np.zeros(N); pnl = []; c = cost_bps / 1e4
    for t in range(60, T - 1):
        if (t - 60) % 21 == 0:
            s = ulcer[t]; m = np.isfinite(s); o = np.argsort(np.where(m, s, np.nan))
            w = np.zeros(N); w[o[-k:]] = 1 / k; w -= m / m.sum()
        else:
            w = wp
        pnl.append(float(np.nansum(w * R[t + 1])) - np.abs(w - wp).sum() * c); wp = w
    return np.array(pnl)
