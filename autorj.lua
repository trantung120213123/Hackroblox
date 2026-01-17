do
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local RunService = game:GetService("RunService")

    local lp = Players.LocalPlayer
    local placeId = game.PlaceId
    local jobId = game.JobId
    local reconnecting = false

    -- Lấy hàm queue_on_teleport (tuỳ executor)
    local queue =
        queue_on_teleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)

    -- Tự nhét lại chính script này
    if queue then
        queue([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/autorj.lua"))()
        ]])
    end

    local function rejoin()
        if reconnecting then return end
        reconnecting = true
        task.wait(2)

        pcall(function()
            TeleportService:TeleportToPlaceInstance(
                placeId,
                jobId,
                lp
            )
        end)
    end

    TeleportService.TeleportInitFailed:Connect(function()
        rejoin()
    end)

    lp.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed then
            rejoin()
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not lp.Parent then
            rejoin()
        end
    end)
end
