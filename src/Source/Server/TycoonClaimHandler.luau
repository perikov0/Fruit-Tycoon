local TycoonClaimHandler = {}
TycoonClaimHandler.Callbacks = {}
TycoonClaimHandler.Tycoons = {} :: {
    {
        Owned: Player,
        TimeOwned: number,
    }
}

local function FindFirstOpenTycoon()
    local firstOpenIndex = nil
    for index, tycoon in TycoonClaimHandler.Tycoons do
        if tycoon.Owned then continue end
        firstOpenIndex = index
    end
    return firstOpenIndex
end

function TycoonClaimHandler.PlayerInit(player)
    local tycoonSlot = FindFirstOpenTycoon()
    TycoonClaimHandler.Tycoons[tycoonSlot].Owned = player
    TycoonClaimHandler.Tycoons[tycoonSlot].TimeOwned = workspace:GetServerTimeNow()

    TycoonClaimHandler.Callbacks[player] = function()

    end -- Cleanup callback
end

function TycoonClaimHandler.PlayerLeave(player)
    TycoonClaimHandler.Callbacks[player]()
end

return TycoonClaimHandler