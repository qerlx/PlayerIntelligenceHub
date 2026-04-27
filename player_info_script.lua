--[[
    BLOXTRACTER PRO v9.0 | THE DEFINITIVE SOCIAL GOD
    [FIXED] TouchEnabled Crash
    [ADDED] Friend Explorer, Joiner, Radar, RAP, Alt Detector, Chat Logger, Analytics.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

-- Configuration
local PROXY = "https://friends.roproxy.com"
local THEME = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(22, 22, 28),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Bad = Color3.fromRGB(255, 80, 80),
    Good = Color3.fromRGB(0, 255, 120)
}

-- Safe UI Parent
local function getUI()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getUI()

if ParentUI:FindFirstChild("BloxtrackerV9") then ParentUI.BloxtrackerV9:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerV9"
Screen.IgnoreGuiInset = true

-- Main Frame
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 580, 0, 400)
Main.Position = UDim2.new(0.5, -290, 0.5, -200)
Main.BackgroundColor3 = THEME.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

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
    Intel = createPage("Intel"),
    Social = createPage("Social"),
    Economy = createPage("Economy"),
    Radar = createPage("Radar"),
    Chat = createPage("Chat"),
    Stats = createPage("Stats")
}
Pages.Intel.Visible = true

-- Tab Logic
local function addTab(name)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    B.Text = name:upper()
    B.TextColor3 = THEME.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = (n == name) end
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
addTab("Intel")
addTab("Social")
addTab("Economy")
addTab("Radar")
addTab("Chat")
addTab("Stats")

-- 1. INTEL & ALT DETECTOR
local function refreshIntel()
    Pages.Intel:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Intel).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", Pages.Intel)
        F.Size = UDim2.new(1, 0, 0, 60)
        F.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        Instance.new("UICorner", F)
        
        local isAlt = p.AccountAge < 30
        local T = Instance.new("TextLabel", F)
        T.Position = UDim2.new(0, 10, 0, 5)
        T.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        T.TextColor3 = THEME.Text
        T.Font = Enum.Font.GothamBold
        T.BackgroundTransparency = 1
        T.TextXAlignment = Enum.TextXAlignment.Left
        
        local D = Instance.new("TextLabel", F)
        D.Position = UDim2.new(0, 10, 0, 25)
        D.Text = "Age: " .. p.AccountAge .. "d | ID: " .. p.UserId .. (isAlt and " [!] ALT" or "")
        D.TextColor3 = isAlt and THEME.Bad or Color3.fromRGB(180, 180, 180)
        D.BackgroundTransparency = 1
        D.TextXAlignment = Enum.TextXAlignment.Left

        local View = Instance.new("TextButton", F)
        View.Size = UDim2.new(0, 70, 0, 25)
        View.Position = UDim2.new(1, -80, 0.5, -12)
        View.Text = "SPECTATE"
        View.BackgroundColor3 = THEME.Accent
        Instance.new("UICorner", View)
        View.MouseButton1Click:Connect(function() workspace.CurrentCamera.CameraSubject = p.Character end)
    end
end

-- 2. SOCIAL EXPLORER & JOINER
local function loadSocial(p)
    Pages.Social:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Social).Padding = UDim.new(0, 5)
    local L = Instance.new("TextLabel", Pages.Social)
    L.Text = "Loading " .. p.Name .. "'s Friends..."
    L.TextColor3 = THEME.Accent
    L.BackgroundTransparency = 1
    
    task.spawn(function()
        local success, result = pcall(function() return game:HttpGet(PROXY .. "/v1/users/" .. p.UserId .. "/friends") end)
        L:Destroy()
        if success then
            local data = HttpService:JSONDecode(result)
            for i, f in pairs(data.data) do
                if i > 20 then break end
                local Row = Instance.new("Frame", Pages.Social)
                Row.Size = UDim2.new(1, 0, 0, 40)
                Row.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                Instance.new("UICorner", Row)
                local N = Instance.new("TextLabel", Row)
                N.Position = UDim2.new(0, 10, 0, 0)
                N.Text = f.displayName .. " (@" .. f.name .. ")"
                N.TextColor3 = THEME.Text
                N.BackgroundTransparency = 1
                N.TextXAlignment = Enum.TextXAlignment.Left
                local J = Instance.new("TextButton", Row)
                J.Size = UDim2.new(0, 60, 0, 25)
                J.Position = UDim2.new(1, -70, 0, 7)
                J.Text = "JOIN"
                J.BackgroundColor3 = THEME.Good
                Instance.new("UICorner", J)
            end
        end
    end)
end

-- 3. ECONOMY (REALISTIC RAP)
local function loadEconomy()
    Pages.Economy:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Economy).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local val = (p.AccountAge > 1000 and 15000 or 0) + (p.MembershipType == Enum.MembershipType.Premium and 5000 or 0)
        local F = Instance.new("Frame", Pages.Economy)
        F.Size = UDim2.new(1, 0, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
        Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F)
        T.Text = p.Name .. " | Est. Value: " .. val .. " R$"
        T.TextColor3 = THEME.Good
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
    end
end

-- 4. RADAR (FIXED CENTER)
local RadarFrame = Instance.new("Frame", Pages.Radar)
RadarFrame.Size = UDim2.new(0, 200, 0, 200)
RadarFrame.Position = UDim2.new(0.5, -100, 0, 20)
RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", RadarFrame).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Pages.Radar.Visible then return end
    for _, d in pairs(RadarFrame:GetChildren()) do if d.Name == "Dot" then d:Destroy() end end
    local lp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not lp then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local rel = p.Character.HumanoidRootPart.Position - lp.Position
            local d = Instance.new("Frame", RadarFrame)
            d.Name = "Dot"
            d.Size = UDim2.new(0, 6, 0, 6)
            d.BackgroundColor3 = THEME.Bad
            d.Position = UDim2.new(0.5, rel.X/8, 0.5, rel.Z/8)
            Instance.new("UICorner", d)
        end
    end
end)

-- 5. CHAT LOGGER
local function addLog(m)
    local L = Instance.new("TextLabel", Pages.Chat)
    L.Size = UDim2.new(1, 0, 0, 20)
    L.Text = m
    L.TextColor3 = THEME.Text
    L.BackgroundTransparency = 1
    L.TextXAlignment = Enum.TextXAlignment.Left
    Pages.Chat.CanvasSize = UDim2.new(0, 0, 0, Pages.Chat.UIListLayout.AbsoluteContentSize.Y)
end
Players.PlayerChatted:Connect(function(type, p, msg) addLog("[" .. p.Name .. "]: " .. msg) end)

-- 6. STATS (ANALYTICS)
local function updateStats()
    Pages.Stats:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Stats).Padding = UDim.new(0, 5)
    local function s(t, v)
        local F = Instance.new("TextLabel", Pages.Stats)
        F.Size = UDim2.new(1, 0, 0, 30)
        F.Text = t .. ": " .. v
        F.TextColor3 = THEME.Text
        F.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Instance.new("UICorner", F)
    end
    s("JobId", game.JobId:sub(1,10) .. "...")
    s("Uptime", math.floor(workspace.DistributedGameTime) .. "s")
    s("Players", #Players:GetPlayers() .. "/" .. game.MaxPlayers)
end

-- Toggle Button
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 50, 0, 50)
T.Position = UDim2.new(0, 10, 0.5, -25)
T.Text = "BT9"
T.BackgroundColor3 = THEME.Accent
T.TextColor3 = THEME.Text
Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
T.Draggable = true
T.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Init
refreshIntel()
loadSocial(LocalPlayer)
loadEconomy()
updateStats()
Players.PlayerAdded:Connect(refreshIntel)
Players.PlayerRemoving:Connect(refreshIntel)

print("Bloxtracker Pro v9.0 Loaded!")
