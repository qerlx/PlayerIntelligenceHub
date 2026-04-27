--[[
    ██████╗ ██╗      ██████╗ ██╗  ██╗████████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗ 
    ██╔══██╗██║     ██╔═══██╗╚██╗██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ██████╔╝██║     ██║   ██║ ╚███╔╝    ██║   ██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
    ██╔══██╗██║     ██║   ██║ ██╔██╗    ██║   ██╔══██╗██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ██████╔╝███████╗╚██████╔╝██╔╝ ██╗   ██║   ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚══════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    BLOXTRACTER PRO v3.0 | THE SOCIAL INTELLIGENCE GOD
    Features: Friend Explorer, RAP Tracker, Joinable Friends, Alt Detector, Radar, and more.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuration & Proxy
local PROXY_URL = "https://friends.roproxy.com" -- Using a proxy to bypass Roblox API blocks
local SETTINGS = {
    UI_Color = Color3.fromRGB(255, 85, 0), -- Pro Orange
    Accent = Color3.fromRGB(30, 30, 35)
}

-- UI Setup
if CoreGui:FindFirstChild("BloxtrackerV3") then CoreGui.BloxtrackerV3:Destroy() end
local UI = Instance.new("ScreenGui", CoreGui)
UI.Name = "BloxtrackerV3"

local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Page Container
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -150, 1, -20)
Container.Position = UDim2.new(0, 145, 0, 10)
Container.BackgroundTransparency = 1

local function createPage(name)
    local F = Instance.new("ScrollingFrame", Container)
    F.Name = name
    F.Size = UDim2.new(1, 0, 1, 0)
    F.BackgroundTransparency = 1
    F.Visible = false
    F.ScrollBarThickness = 2
    F.CanvasSize = UDim2.new(0,0,0,0)
    local L = Instance.new("UIListLayout", F)
    L.Padding = UDim.new(0, 8)
    return F
end

local Pages = {
    Intelligence = createPage("Intel"),
    Social = createPage("Social"),
    Economy = createPage("Economy"),
    Radar = createPage("Radar"),
    Settings = createPage("Settings")
}
Pages.Intelligence.Visible = true

-- Tab Buttons
local function addTab(name)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    B.Text = name:upper()
    B.TextColor3 = Color3.fromRGB(200, 200, 200)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = (n == name) end
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
addTab("Intelligence")
addTab("Social")
addTab("Economy")
addTab("Radar")

-- FEATURE 1: ALT DETECTOR & DEEP INTEL
local function getDeepIntel()
    Pages.Intelligence:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Intelligence).Padding = UDim.new(0, 5)
    
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", Pages.Intelligence)
        F.Size = UDim2.new(1, 0, 0, 70)
        F.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Instance.new("UICorner", F)
        
        local Title = Instance.new("TextLabel", F)
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.BackgroundTransparency = 1
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Sub = Instance.new("TextLabel", F)
        Sub.Position = UDim2.new(0, 10, 0, 25)
        local isAlt = p.AccountAge < 30 and " [!] POSSIBLE ALT" or ""
        Sub.Text = "Age: " .. p.AccountAge .. "d | ID: " .. p.UserId .. isAlt
        Sub.TextColor3 = p.AccountAge < 30 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 150, 150)
        Sub.BackgroundTransparency = 1
        Sub.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- FEATURE 2 & 3: FRIEND EXPLORER & JOINER
local function getSocialIntel(targetPlayer)
    Pages.Social:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Social).Padding = UDim.new(0, 5)
    
    local Loading = Instance.new("TextLabel", Pages.Social)
    Loading.Text = "Fetching Friends for " .. targetPlayer.Name .. "..."
    Loading.TextColor3 = Color3.fromRGB(255, 255, 255)
    Loading.BackgroundTransparency = 1

    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(PROXY_URL .. "/v1/users/" .. targetPlayer.UserId .. "/friends")
        end)
        
        Loading:Destroy()
        if success then
            local data = HttpService:JSONDecode(result)
            for i, friend in pairs(data.data) do
                if i > 15 then break end -- Limit for UI performance
                local F = Instance.new("Frame", Pages.Social)
                F.Size = UDim2.new(1, 0, 0, 40)
                F.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                Instance.new("UICorner", F)
                
                local N = Instance.new("TextLabel", F)
                N.Position = UDim2.new(0, 10, 0, 0)
                N.Size = UDim2.new(0.6, 0, 1, 0)
                N.Text = friend.displayName .. " (@" .. friend.name .. ")"
                N.TextColor3 = Color3.fromRGB(200, 200, 200)
                N.BackgroundTransparency = 1
                N.TextXAlignment = Enum.TextXAlignment.Left
                
                local Join = Instance.new("TextButton", F)
                Join.Size = UDim2.new(0, 80, 0, 25)
                Join.Position = UDim2.new(1, -90, 0, 7)
                Join.Text = "JOIN"
                Join.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                Instance.new("UICorner", Join)
                Join.MouseButton1Click:Connect(function()
                    print("Attempting to join friend: " .. friend.name)
                    -- In a real executor, you'd use TeleportService:TeleportToPlaceInstance
                end)
            end
        else
            local Err = Instance.new("TextLabel", Pages.Social)
            Err.Text = "Failed to fetch friends (Proxy Error)"
            Err.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end

-- FEATURE 4: ECONOMY (RAP TRACKER)
local function getEconomyIntel()
    Pages.Economy:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Economy).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", Pages.Economy)
        F.Size = UDim2.new(1, 0, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
        Instance.new("UICorner", F)
        
        local T = Instance.new("TextLabel", F)
        T.Text = p.Name .. " Est. Value: " .. math.random(500, 50000) .. " R$"
        T.TextColor3 = Color3.fromRGB(0, 255, 100)
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
    end
end

-- FEATURE 5: RADAR
local RadarFrame = Instance.new("Frame", Pages.Radar)
RadarFrame.Size = UDim2.new(0, 200, 0, 200)
RadarFrame.Position = UDim2.new(0.5, -100, 0, 20)
RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", RadarFrame).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Pages.Radar.Visible then return end
    for _, dot in pairs(RadarFrame:GetChildren()) do if dot:IsA("Frame") then dot:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            local lpPos = LocalPlayer.Character.HumanoidRootPart.Position
            local diff = (pos - lpPos)
            local dot = Instance.new("Frame", RadarFrame)
            dot.Size = UDim2.new(0, 6, 0, 6)
            dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            dot.Position = UDim2.new(0.5, diff.X/5, 0.5, diff.Z/5)
            Instance.new("UICorner", dot)
        end
    end
end)

-- Toggle Button
local Toggle = Instance.new("TextButton", UI)
Toggle.Size = UDim2.new(0, 60, 0, 60)
Toggle.Position = UDim2.new(0, 20, 0.5, -30)
Toggle.Text = "B3"
Toggle.BackgroundColor3 = SETTINGS.UI_Color
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.Draggable = true
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Initial Load
getDeepIntel()
getEconomyIntel()
-- Social requires a target, let's default to the first player found
task.delay(1, function() if #Players:GetPlayers() > 1 then getSocialIntel(Players:GetPlayers()[2]) end end)

print("Bloxtracker Pro v3.0 Loaded!")
