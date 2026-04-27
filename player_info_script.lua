--[[
    BLOXTRACTER FORCE-RENDER v8.0
    MANUAL POSITIONING - NO LAYOUTS - NO PROXIES
    If this is empty, check F9 for errors.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- CLEANUP
local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("BloxtrackerForce")
if old then old:Destroy() end

-- UI SETUP
local Screen = Instance.new("ScreenGui")
Screen.Name = "BloxtrackerForce"
Screen.Parent = LocalPlayer:WaitForChild("PlayerGui")
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Main.BorderSizePixel = 2
Main.Draggable = true
Main.Active = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BLOXTRACTER v8.0"
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- MANUAL LISTING (NO LAYOUTS)
local function renderList()
    -- Clear old labels
    for _, v in pairs(Main:GetChildren()) do
        if v:IsA("TextLabel") and v.Name == "PlayerLabel" then v:Destroy() end
    end
    
    local offset = 35
    for i, p in pairs(Players:GetPlayers()) do
        local L = Instance.new("TextLabel", Main)
        L.Name = "PlayerLabel"
        L.Size = UDim2.new(1, -10, 0, 20)
        L.Position = UDim2.new(0, 5, 0, offset)
        L.Text = i .. ". " .. p.Name .. " [" .. p.AccountAge .. "d]"
        L.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        L.TextColor3 = Color3.fromRGB(255, 255, 255)
        L.BorderSizePixel = 0
        L.TextSize = 12
        
        offset = offset + 22
        if offset > 280 then break end -- Limit to fit frame
    end
end

-- INITIAL RENDER
task.wait(1)
renderList()

-- REFRESH ON JOIN/LEAVE
Players.PlayerAdded:Connect(function() task.wait(1); renderList() end)
Players.PlayerRemoving:Connect(function() task.wait(1); renderList() end)

print("Bloxtracker Force-Render Loaded.")
