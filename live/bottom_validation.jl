#!/usr/bin/env julia
# bottom_validation.jl — validate-before-live gate for the BOTTOM sleeve (walk-forward / OOS / net-of-cost).
# Reuses bottom_target from bottom_live.jl. Run:  julia --project=engine live/bottom_validation.jl
include(joinpath(@__DIR__, "bottom_live.jl"))
include(joinpath(@__DIR__, "_sleeve_validation.jl"))
validate_sleeve(bottom_target; label = "BOTTOM", universe = UNIVERSE, warmup = 120, kind = :directional)
