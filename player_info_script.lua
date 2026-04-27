--[[
    BLOXTRACTER EXTERNAL BRIDGE v13.0
    Connects Roblox to the Python Server on your PC.
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- The address of your local Python server
local PYTHON_URL = "http://127.0.0.1:5000"

print("[Bloxtracker] Attempting to connect to Python Server...")

local function sendToPython(player)
    local data = {
        name = player.Name,
        displayName = player.DisplayName,
        userId = player.UserId,
        age = player.AccountAge
    }
    
    local success, result = pcall(function()
        return HttpService:PostAsync(
            PYTHON_URL .. "/intel",
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success then
        local response = HttpService:JSONDecode(result)
        print("[Python Response] RAP: " .. tostring(response.external_rap))
    else
        warn("[Bloxtracker] Could not reach Python server. Make sure bloxtracker.py is running!")
    end
end

-- Track players
Players.PlayerAdded:Connect(sendToPython)

-- Initial scan
for _, p in pairs(Players:GetPlayers()) do
    sendToPython(p)
end

-- GUI to show status
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Label = Instance.new("TextLabel", Screen)
Label.Size = UDim2.new(0, 200, 0, 50)
Label.Position = UDim2.new(0, 10, 0, 10)
Label.Text = "EXTERNAL LINK: ACTIVE"
Label.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
Label.TextColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", Label)
