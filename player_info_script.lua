--[[
    ██████╗ ██╗      ██████╗ ██╗  ██╗████████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗ 
    ██╔══██╗██║     ██╔═══██╗╚██╗██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ██████╔╝██║     ██║   ██║ ╚███╔╝    ██║   ██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
    ██╔══██╗██║     ██║   ██║ ██╔██╗    ██║   ██╔══██╗██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ██████╔╝███████╗╚██████╔╝██╔╝ ██╗   ██║   ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚══════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    BLOXTRACTER UNIVERSAL v3.5 | MAXIMUM COMPATIBILITY
    If this doesn't work, check your executor's console (F9).
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- UNIVERSAL UI PARENTING
local function getUIPath()
    local success, _ = pcall(function() return CoreGui.Name end)
    if success then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UIPath = getUIPath()
print("[Bloxtracker] Attempting to parent UI to: " .. UIPath.Name)

-- CLEANUP
if UIPath:FindFirstChild("BloxtrackerUniversal") then
    UIPath.BloxtrackerUniversal:Destroy()
end

-- MAIN UI
local Screen = Instance.new("ScreenGui")
Screen.Name = "BloxtrackerUniversal"
Screen.Parent = UIPath
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.5, -200, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BLOXTRACTER UNIVERSAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local List = Instance.new("ScrollingFrame", Main)
List.Size = UDim2.new(1, -20, 1, -60)
List.Position = UDim2.new(0, 10, 0, 50)
List.BackgroundTransparency = 1
List.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0, 5)

-- FUNCTION TO ADD PLAYER INFO
local function addPlayer(p)
    local F = Instance.new("Frame", List)
    F.Size = UDim2.new(1, 0, 0, 50)
    F.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Instance.new("UICorner", F)
    
    local N = Instance.new("TextLabel", F)
    N.Size = UDim2.new(1, -10, 1, 0)
    N.Position = UDim2.new(0, 10, 0, 0)
    N.Text = p.DisplayName .. " (@" .. p.Name .. ")\nAge: " .. p.AccountAge .. "d | ID: " .. p.UserId
    N.TextColor3 = Color3.fromRGB(200, 200, 200)
    N.TextXAlignment = Enum.TextXAlignment.Left
    N.BackgroundTransparency = 1
    N.TextSize = 12
    N.Font = Enum.Font.Gotham
    
    List.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

-- REFRESH
local function refresh()
    for _, v in pairs(List:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do addPlayer(p) end
end

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()

-- TOGGLE BUTTON (Essential for Mobile)
local Toggle = Instance.new("TextButton", Screen)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 10, 0.5, -25)
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Toggle.Text = "BT"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.Draggable = true

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- DEBUG LOG
warn("[Bloxtracker] Script initialized successfully.")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Bloxtracker",
    Text = "Universal Version Loaded!",
    Duration = 5
})
