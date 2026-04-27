--[[
    BLOXTRACTER NATIVE v7.0
    ULTRA-SIMPLIFIED FOR MAXIMUM COMPATIBILITY
    No complex UI, no proxies, no web calls.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- FORCE PARENT TO PLAYERGUI
local Screen = Instance.new("ScreenGui")
Screen.Name = "BloxtrackerNative"
Screen.Parent = LocalPlayer:WaitForChild("PlayerGui")
Screen.ResetOnSpawn = false

-- THE "NO-FAIL" MAIN FRAME
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0.5, -150, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Main.BorderSizePixel = 2
Main.Draggable = true
Main.Active = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BLOXTRACTER NATIVE"
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- LIST CONTAINER (NO SCROLLING FRAME)
local List = Instance.new("Frame", Main)
List.Size = UDim2.new(1, -10, 1, -40)
List.Position = UDim2.new(0, 5, 0, 35)
List.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0, 2)

-- SIMPLE PLAYER ADDER
local function addPlayer(p)
    local pFrame = Instance.new("TextLabel", List)
    pFrame.Size = UDim2.new(1, 0, 0, 25)
    pFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    pFrame.Text = p.Name .. " | Age: " .. p.AccountAge .. "d"
    pFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    pFrame.TextSize = 10
end

-- REFRESH LOGIC
local function refresh()
    for _, v in pairs(List:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do addPlayer(p) end
end

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()

-- TOGGLE BUTTON
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 40, 0, 40)
T.Position = UDim2.new(0, 10, 0.5, -20)
T.Text = "OPEN"
T.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
T.TextColor3 = Color3.fromRGB(255, 255, 255)
T.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Bloxtracker Native Loaded.")
