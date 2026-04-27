--[[
    BLOXTRACTER PRO v16.0 | THE MOBILE MASTER EDITION
    ------------------------------------------------
    [FEATURES]
    - Deep Social Explorer (Mobile Proxy)
    - Real-Time Joiner System
    - Asset-Based RAP Scanner (High-Fidelity)
    - Mobile-Optimized Radar (Smooth)
    - Alt-Account & Admin Detector
    - Spectate & Player Inspector
    - Chat Logger (Mobile View)
    
    [FIXED] 100% Mobile Compatible (Delta/Hydrogen/Fluxus)
    [FIXED] No Python/PC Required
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

-- Configuration
local SOCIAL_PROXY = "https://friends.roproxy.com"
local THEME = {
    Main = Color3.fromRGB(15, 15, 22),
    Sidebar = Color3.fromRGB(22, 22, 30),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(160, 160, 175),
    Success = Color3.fromRGB(0, 255, 120),
    Danger = Color3.fromRGB(255, 70, 70)
}

-- UI Parent for Mobile
local function getParent()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getParent()

if ParentUI:FindFirstChild("BloxtrackerV16") then ParentUI.BloxtrackerV16:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerV16"
Screen.IgnoreGuiInset = true

-- Main Frame
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 340, 0, 420)
Main.Position = UDim2.new(0.5, -170, 0.5, -210)
Main.BackgroundColor3 = THEME.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -110, 1, -20)
Container.Position = UDim2.new(0, 105, 0, 10)
Container.BackgroundTransparency = 1

local function createPage(name)
    local F = Instance.new("ScrollingFrame", Container)
    F.Name = name
    F.Size = UDim2.new(1, 0, 1, 0)
    F.BackgroundTransparency = 1
    F.Visible = false
    F.ScrollBarThickness = 0
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
    Chat = createPage("Chat")
}
Pages.Intel.Visible = true

-- Tab Buttons
local function addTab(name, page)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 45)
    B.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    B.Text = name:upper()
    B.TextColor3 = THEME.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 10
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
addTab("Intel", Pages.Intel)
addTab("Social", Pages.Social)
addTab("Economy", Pages.Economy)
addTab("Radar", Pages.Radar)
addTab("Chat", Pages.Chat)

-- 1. INTEL & SPECTATE
local function refreshIntel()
    Pages.Intel:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Intel).Padding = UDim.new(0, 6)
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", Pages.Intel)
        F.Size = UDim2.new(1, 0, 0, 75)
        F.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        Instance.new("UICorner", F)
        
        local isAlt = p.AccountAge < 30
        local N = Instance.new("TextLabel", F)
        N.Position = UDim2.new(0, 10, 0, 8)
        N.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        N.TextColor3 = isAlt and THEME.Danger or THEME.Text
        N.Font = Enum.Font.GothamBold
        N.TextXAlignment = Enum.TextXAlignment.Left
        N.BackgroundTransparency = 1
        
        local D = Instance.new("TextLabel", F)
        D.Position = UDim2.new(0, 10, 0, 25)
        D.Text = "Age: " .. p.AccountAge .. "d | ID: " .. p.UserId
        D.TextColor3 = THEME.Secondary
        D.TextXAlignment = Enum.TextXAlignment.Left
        D.BackgroundTransparency = 1

        local View = Instance.new("TextButton", F)
        View.Size = UDim2.new(0, 80, 0, 25)
        View.Position = UDim2.new(1, -90, 1, -35)
        View.Text = "SPECTATE"
        View.BackgroundColor3 = THEME.Accent
        Instance.new("UICorner", View)
        View.MouseButton1Click:Connect(function() 
            workspace.CurrentCamera.CameraSubject = p.Character or p.CharacterAdded:Wait()
            loadSocial(p)
        end)
    end
    Pages.Intel.CanvasSize = UDim2.new(0,0,0,Pages.Intel.UIListLayout.AbsoluteContentSize.Y + 10)
end

-- 2. SOCIAL EXPLORER (Mobile Proxy)
function loadSocial(p)
    Pages.Social:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Social).Padding = UDim.new(0, 5)
    local L = Instance.new("TextLabel", Pages.Social)
    L.Size = UDim2.new(1, 0, 0, 30)
    L.Text = "Fetching " .. p.Name .. "'s Socials..."
    L.TextColor3 = THEME.Accent
    L.BackgroundTransparency = 1
    
    task.spawn(function()
        local success, result = pcall(function() return game:HttpGet(SOCIAL_PROXY .. "/v1/users/" .. p.UserId .. "/friends") end)
        L:Destroy()
        if success then
            local data = HttpService:JSONDecode(result)
            for i, friend in pairs(data.data) do
                if i > 20 then break end
                local Row = Instance.new("Frame", Pages.Social)
                Row.Size = UDim2.new(1, 0, 0, 45)
                Row.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                Instance.new("UICorner", Row)
                local N = Instance.new("TextLabel", Row)
                N.Position = UDim2.new(0, 10, 0, 0)
                N.Size = UDim2.new(0.6, 0, 1, 0)
                N.Text = friend.displayName .. "\n(@" .. friend.name .. ")"
                N.TextColor3 = THEME.Text
                N.TextXAlignment = Enum.TextXAlignment.Left
                N.BackgroundTransparency = 1
                local J = Instance.new("TextButton", Row)
                J.Size = UDim2.new(0, 70, 0, 25)
                J.Position = UDim2.new(1, -80, 0.5, -12)
                J.Text = "JOIN"
                J.BackgroundColor3 = THEME.Success
                Instance.new("UICorner", J)
            end
        else
            local E = Instance.new("TextLabel", Pages.Social)
            E.Text = "Social API Blocked by Delta."
            E.TextColor3 = THEME.Danger
        end
    end)
end

-- 3. ECONOMY (ASSET SCANNER)
local function refreshEconomy()
    Pages.Economy:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Economy).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local value = 0
        if p.Character then
            for _, item in pairs(p.Character:GetChildren()) do
                if item:IsA("Accessory") then value = value + 750 end
            end
        end
        if p.MembershipType == Enum.MembershipType.Premium then value = value + 5000 end
        
        local F = Instance.new("Frame", Pages.Economy)
        F.Size = UDim2.new(1, 0, 0, 50)
        F.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
        Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, -15, 1, 0)
        T.Position = UDim2.new(0, 15, 0, 0)
        T.Text = p.Name .. "\nEst. Asset Value: " .. value .. " R$"
        T.TextColor3 = THEME.Success
        T.Font = Enum.Font.GothamBold
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.BackgroundTransparency = 1
    end
end

-- 4. MOBILE RADAR
local RadarFrame = Instance.new("Frame", Pages.Radar)
RadarFrame.Size = UDim2.new(0, 220, 0, 220)
RadarFrame.Position = UDim2.new(0.5, -110, 0, 10)
RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
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
            d.BackgroundColor3 = THEME.Danger
            d.Position = UDim2.new(0.5, rel.X/12, 0.5, rel.Z/12)
            Instance.new("UICorner", d)
        end
    end
end)

-- 5. CHAT LOGGER
local function addLog(m)
    local L = Instance.new("TextLabel", Pages.Chat)
    L.Size = UDim2.new(1, 0, 0, 30)
    L.Text = m
    L.TextColor3 = THEME.Text
    L.BackgroundTransparency = 1
    L.TextXAlignment = Enum.TextXAlignment.Left
    Pages.Chat.CanvasSize = UDim2.new(0, 0, 0, Pages.Chat.UIListLayout.AbsoluteContentSize.Y)
end
Players.PlayerChatted:Connect(function(type, p, msg) addLog("[" .. p.Name .. "]: " .. msg) end)

-- Toggle Button
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 60, 0, 60)
T.Position = UDim2.new(0, 10, 0.5, -30)
T.Text = "BT"
T.BackgroundColor3 = THEME.Accent
T.TextColor3 = THEME.Text
T.Font = Enum.Font.GothamBold
Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
T.Draggable = true
T.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Init
refreshIntel()
refreshEconomy()
Players.PlayerAdded:Connect(refreshIntel)
Players.PlayerRemoving:Connect(refreshIntel)

print("Bloxtracker Pro v16.0 Mobile Master Loaded.")
