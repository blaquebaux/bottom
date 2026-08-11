#!/usr/bin/env julia
# ============================================================================
# bottom_live.jl — BLAQUE BAUX BOTTOM live driver (large-cap drawdown-bounce).
#
# Runs on the Blaque Baux ENGINE (from engine/ submodule) — same governed order path + Layer-3
# safety gate as the spine. Standalone single-sleeve driver, so anyone can run just BOTTOM.
#
# SIGNAL (research: the penny/sub-small-cap "cap-ladder" was rejected; the KEEPER is a LARGE-CAP
# play): among a set of quality large caps, go LONG the most-fallen quintile by trailing 60-day
# return — buy the pullback in quality names — equal-weight, long-only (gross 1). Monthly-ish churn.
# Sleeve math mirrors engine keeper_sleeves.jl (compute_ddbounce).
#
# MODES: dry-run by default via the wrapper (BB_DRYRUN=1 -> compute + log, NO venue). Paper: unset
# BB_DRYRUN with paper keys. Real money requires BB_LIVE_CONFIRM=I_UNDERSTAND_THIS_IS_REAL_MONEY.
# Kill switch: ~/.config/blaquebaux/HALT.  Run:  julia --project=engine live/bottom_live.jl
# NOT validated to the spine's bar — a paper-path graduation of the research.
# ============================================================================
using Dates, Printf, Statistics

const REPO   = normpath(joinpath(@__DIR__, ".."))
const ENGINE = joinpath(REPO, "engine")
include(joinpath(ENGINE, "src/module_7_execution/module_7_execution.jl"))
include(joinpath(ENGINE, "src/module_10_feedback/module_10_feedback.jl"))
include(joinpath(ENGINE, "src/module_13_portfolio/module_13_portfolio.jl"))
include(joinpath(ENGINE, "src/module_1_data/equity_panel.jl"))
include(joinpath(ENGINE, "src/module_1_data/alpaca_panel.jl"))
include(joinpath(ENGINE, "src/module_8_governance/safety_gate.jl"))
using .ExecutionLayer, .FeedbackLayer, .PortfolioOptModule, .EquityPanel, .AlpacaPanel, .SafetyGate
include(joinpath(ENGINE, "scripts/live_execution.jl"))

const NAMES = ["AAPL","MSFT","NVDA","AMZN","GOOGL","META","AVGO","JPM","V","MA","UNH","HD",
               "PG","XOM","JNJ","COST","WMT","LLY","ORCL","CVX"]
const UNIVERSE = NAMES
const LIVE_SENTINEL = "I_UNDERSTAND_THIS_IS_REAL_MONEY"
const LOOK = 60                                          # drawdown lookback (days)

_readf(p) = isfile(p) ? (v = tryparse(Float64, strip(read(p, String))); v === nothing ? NaN : v) : NaN
_writef(p, x) = (mkpath(dirname(p)); write(p, string(x)))

"Long the most-fallen quintile by trailing 60d return, EW. (Mirrors keeper_sleeves.compute_ddbounce.)"
function bottom_target(panel, cap)
    syms = panel.symbols; R = panel.returns; T = size(R, 1); N = length(NAMES)
    col(s) = R[:, findfirst(==(s), syms)]; px(s) = panel.prices[findfirst(==(s), syms)]
    tr60 = [prod(1 .+ col(s)[T-LOOK+1:T]) - 1 for s in NAMES]                     # trailing 60d return per name
    k = max(1, round(Int, N * 0.2)); o = sortperm(tr60)                           # ascending = most-fallen first
    chosen = NAMES[o[1:k]]
    net = Dict(s => 1.0 / k for s in chosen); price = Dict(s => px(s) for s in chosen)
    targets = Dict(s => round(Float64, net[s] * cap / price[s]) for s in chosen)
    (targets = targets, prices = price, net = net, fallen = [(NAMES[o[j]], tr60[o[j]]) for j in 1:k])
end

function main(; capital = nothing, pool = "us", limits::SafetyLimits = SafetyLimits(),
              db_path     = get(ENV, "BB_LEDGER_PATH", joinpath(REPO, "alpaca_ledger_bottom.sqlite")),
              audit_path  = get(ENV, "BB_AUDIT_PATH",  joinpath(REPO, "alpaca_audit_bottom.jsonl")),
              hwm_path    = get(ENV, "BB_HWM_PATH",    joinpath(homedir(), ".config", "blaquebaux", "equity_hwm_bottom.txt")),
              equity_path = get(ENV, "BB_EQUITY_PATH", joinpath(homedir(), ".config", "blaquebaux", "equity_last_bottom.txt")))
    (get(ENV, "ALPACA_KEY_ID", "") == "" || get(ENV, "ALPACA_SECRET_KEY", "") == "") &&
        error("Set ALPACA_KEY_ID and ALPACA_SECRET_KEY (read-only bars are needed even in dry-run).")
    dryrun = get(ENV, "BB_DRYRUN", "") in ("1", "true", "yes")

    if dryrun
        panel = panel_at(AlpacaPanelProvider(UNIVERSE; lookback = 150))
        bk = bottom_target(panel, capital === nothing ? 100_000.0 : capital)
        @info "BOTTOM dry run" asof=panel.asof
        println("\n  BOTTOM -> long the most-fallen quintile by trailing 60d return, equal-weight:")
        for (s, dd) in bk.fallen
            @printf("    %-6s  60d %+5.1f%%  -> %5.1f%%  %d sh @ \$%.2f\n", s, 100dd, 100*get(bk.net, s, 0.0),
                    Int(get(bk.targets, s, 0.0)), get(bk.prices, s, NaN))
        end
        ok, reasons = preflight(; account_status = "ACTIVE", equity = 100_000.0, hwm = 100_000.0,
            last_equity = 100_000.0, buying_power = 100_000.0, data_fresh = (Dates.today() - panel.asof) <= Day(5),
            targets = bk.targets, prices = bk.prices, limits = limits)
        println("\n  DRY RUN — no venue, no orders. Gate: ", ok ? "PASS" : "ABORT: " * join(reasons, "; "))
        return ok ? :dryrun_ok : :dryrun_gate_abort
    end

    live = get(ENV, "BB_LIVE_CONFIRM", "") == LIVE_SENTINEL; paper = !live
    mode = live ? "*** LIVE REAL MONEY ***" : "paper"
    @info "bottom_live starting" mode
    live && alert("BOTTOM LIVE REAL-MONEY mode engaged"; level = :critical)
    venue = AlpacaVenue(AlpacaConfig(; paper = paper))
    built = build_live_controller(; venue = venue, ledger_config = LedgerConfig(; db_path = db_path), audit_path = audit_path)
    ctrl, ledger = built.ctrl, built.ledger
    try
        connect!(venue) || (alert("ABORT [$mode]: Alpaca connect failed (bottom)"; level = :critical); return :connect_failed)
        acct = account_info(venue)
        acct === nothing && (alert("ABORT [$mode]: could not read account (bottom)"; level = :critical); return :no_account)
        cap = capital === nothing ? acct.equity : capital
        hwm = max(load_hwm(hwm_path), acct.equity); last_eq = _readf(equity_path)
        panel = panel_at(AlpacaPanelProvider(UNIVERSE; lookback = 150)); fresh = (Dates.today() - panel.asof) <= Day(5)
        bk = bottom_target(panel, cap)
        ok, reasons = preflight(; account_status = acct.status, trading_blocked = acct.trading_blocked,
            account_blocked = acct.account_blocked, equity = acct.equity, hwm = hwm, last_equity = last_eq,
            buying_power = acct.buying_power, data_fresh = fresh, targets = bk.targets, prices = bk.prices, limits = limits)
        save_hwm(hwm, hwm_path); _writef(equity_path, acct.equity)
        if !ok
            msg = "SAFETY ABORT [$mode] (bottom): " * join(reasons, "; "); @error msg
            halt!(ctrl, "safety gate"); alert(msg; level = :critical); return :aborted
        end
        reset_daily!(ctrl)
        set_pool_budget!(ctrl, pool, limits.max_gross_leverage * acct.equity)
        set_pool_loss_limit!(ctrl, pool, limits.max_daily_loss)
        set_pool_staleness!(ctrl, pool, Day(5)); feed_staleness!(ctrl, pool; stale = !fresh)
        isfinite(last_eq) && update_pnl!(ctrl, pool, acct.equity - last_eq)
        ncanc = cancel_all_open!(venue); ncanc > 0 && sleep(2)
        for (sym, qty) in positions(venue, ctrl.account); apply_fill!(ctrl, sym, qty); end
        res = execute_rebalance!(ctrl, ledger; targets = bk.targets, prices = bk.prices,
            signal_id = "bottom", regime = "drawdown-bounce", solve_id = Dates.format(panel.asof, "yyyymmdd"),
            pool_id = pool, settle_secs = 20)
        !res.reconciled && (alert("RECONCILE FAILED [$mode] (bottom) — halting"; level = :critical); halt!(ctrl, "reconcile mismatch"))
        summary = "[$mode] bottom drawdown-bounce; orders=$(length(res.acks)) fills=$(length(res.fills)) reconciled=$(res.reconciled) equity=$(round(Int, acct.equity))"
        @info "bottom_live complete" summary; alert(summary; level = :info)
        return res.reconciled ? :ok : :reconcile_failed
    finally
        disconnect!(venue); close_ledger(ledger)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
