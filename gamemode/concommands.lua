function startRound(ply, cmd, args)
    resetGame()
end

function endRound(ply, cmd, args)
    resetGame()
end

function resetGame()
    SetGlobalInt("FixedGenerators", 0)
end

concommand.Add("hs_start_round", startRound)
concommand.Add("hs_end_round", endRound)
