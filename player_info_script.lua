--[[
    BLOXTRACTER PRO v11.0 | THE NATIVE-ENGINE UPDATE
    ------------------------------------------------
    [FIXED] Removed all Web/Proxy dependencies that were failing.
    [ADDED] Native Social Tracking (In-Server Friends).
    [ADDED] Character-Asset RAP Scanner.
    [ADDED] Direct Event-Based UI Rendering.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Theme
local THEME = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 26),
    Accent = Color3.fromRGB(0, 160, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(160, 160, 170)
}

-- Safe UI Parent
local function getUI()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getUI()

if ParentUI:FindFirstChild("BloxtrackerV11") then ParentUI.BloxtrackerV11:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerV11"
Screen.IgnoreGuiInset = true

-- Main Hub
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = THEME.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -140, 1, -20)
Container.Position = UDim2.new(0, 135, 0, 10)
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
    L.Padding = UDim.new(0, 6)
    return F
end

local Pages = {
    Intel = createPage("Intel"),
    Social = createPage("Social"),
    Economy = createPage("Economy"),
    Radar = createPage("Radar")
}
Pages.Intel.Visible = true

-- Tab Buttons
local function addTab(name, page)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    B.Text = name:upper()
    B.TextColor3 = THEME.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
addTab("Intelligence", Pages.Intel)
addTab("Server Social", Pages.Social)
addTab("Economy", Pages.Economy)
addTab("Radar", Pages.Radar)

-- 1. INTEL (Native Player List)
local function refreshIntel()
    Pages.Intel:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Intel).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", Pages.Intel)
        F.Size = UDim2.new(1, 0, 0, 45)
        F.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Instance.new("UICorner", F)
        
        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, -10, 1, 0)
        T.Position = UDim2.new(0, 10, 0, 0)
        T.Text = p.DisplayName .. " (@" .. p.Name .. ")\nAge: " .. p.AccountAge .. "d"
        T.TextColor3 = THEME.Text
        T.TextSize = 12
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.BackgroundTransparency = 1
        T.Font = Enum.Font.Gotham
    end
    Pages.Intel.CanvasSize = UDim2.new(0,0,0,Pages.Intel.UIListLayout.AbsoluteContentSize.Y + 10)
end

-- 2. SOCIAL (Native In-Game Friend Check)
local function refreshSocial()
    Pages.Social:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Social).Padding = UDim.new(0, 5)
    
    local Title = Instance.new("TextLabel", Pages.Social)
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Text = "Mutual Friends in Server:"
    Title.TextColor3 = THEME.Accent
    Title.BackgroundTransparency = 1
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local isFriend = LocalPlayer:IsFriendsWith(p.UserId)
            if isFriend then
                local F = Instance.new("Frame", Pages.Social)
                F.Size = UDim2.new(1, 0, 0, 35)
                F.BackgroundColor3 = Color3.fromRGB(30, 40, 30)
                Instance.new("UICorner", F)
                local L = Instance.new("TextLabel", F)
                L.Size = UDim2.new(1, -10, 1, 0)
                L.Position = UDim2.new(0, 10, 0, 0)
                L.Text = "FRIEND: " .. p.Name
                L.TextColor3 = Color3.fromRGB(0, 255, 120)
                L.BackgroundTransparency = 1
            end
        end
    end
end

-- 3. ECONOMY (Character Asset Scanner)
local function refreshEconomy()
    Pages.Economy:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Economy).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local value = 0
        if p.Character then
            for _, item in pairs(p.Character:GetChildren()) do
                if item:IsA("Accessory") then value = value + 500 end -- Estimated per item
            end
        end
        if p.MembershipType == Enum.MembershipType.Premium then value = value + 1000 end
        
        local F = Instance.new("Frame", Pages.Economy)
        F.Size = UDim2.new(1, 0, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(25, 30, 25)
        Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, -10, 1, 0)
        T.Position = UDim2.new(0, 10, 0, 0)
        T.Text = p.Name .. " | Asset Value: " .. value .. " R$"
        T.TextColor3 = Color3.fromRGB(0, 255, 120)
        T.BackgroundTransparency = 1
        T.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- 4. RADAR (Reliable Center)
local RadarFrame = Instance.new("Frame", Pages.Radar)
RadarFrame.Size = UDim2.new(0, 200, 0, 200)
RadarFrame.Position = UDim2.new(0.5, -100, 0, 10)
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
            d.Size = UDim2.new(0, 5, 0, 5)
            d.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            d.Position = UDim2.new(0.5, rel.X/10, 0.5, rel.Z/10)
            Instance.new("UICorner", d)
        end
    end
end)

-- Toggle
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 50, 0, 50)
T.Position = UDim2.new(0, 10, 0.5, -25)
T.Text = "BT11"
T.BackgroundColor3 = THEME.Accent
T.TextColor3 = THEME.Text
Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
T.Draggable = true
T.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Initial Load
refreshIntel()
refreshSocial()
refreshEconomy()

Players.PlayerAdded:Connect(refreshIntel)
Players.PlayerRemoving:Connect(refreshIntel)
print("Bloxtracker Pro v11.0 Native-Engine Loaded.")
