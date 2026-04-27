--[[
    BLOXTRACTER PRO v6.0 | THE "BULLETPROOF" UPDATE
    Independent Module Loading - UI will always appear.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local PROXIES = {"https://friends.roproxy.com", "https://friends.roblox.com.roproxy.com"}
local UI_THEME = {
    Main = Color3.fromRGB(12, 12, 15),
    Sidebar = Color3.fromRGB(18, 18, 22),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(150, 150, 160)
}

-- UI Parent Logic
local function getUI()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getUI()

if ParentUI:FindFirstChild("BloxtrackerV6") then ParentUI.BloxtrackerV6:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerV6"
Screen.IgnoreGuiInset = true

-- Main Frame (Created FIRST to ensure visibility)
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = UI_THEME.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = UI_THEME.Sidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -130, 1, -20)
Container.Position = UDim2.new(0, 125, 0, 10)
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
    Radar = createPage("Radar"),
    Economy = createPage("Economy")
}
Pages.Intelligence.Visible = true

-- Tab Buttons
local function addTab(name)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    B.Text = name:upper()
    B.TextColor3 = UI_THEME.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = (n == name) end
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
addTab("Intelligence")
addTab("Social")
addTab("Radar")
addTab("Economy")

-- FEATURE 1: BASIC INTELLIGENCE (Bulletproof)
local function updateIntel()
    Pages.Intelligence:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Intelligence).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame", Pages.Intelligence)
        F.Size = UDim2.new(1, 0, 0, 50)
        F.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, -10, 1, 0)
        T.Position = UDim2.new(0, 10, 0, 0)
        T.Text = p.DisplayName .. " (@" .. p.Name .. ")\nAge: " .. p.AccountAge .. "d | ID: " .. p.UserId
        T.TextColor3 = UI_THEME.Text
        T.TextSize = 12
        T.TextXAlignment = Enum.TextXAlignment.Left
        T.BackgroundTransparency = 1
        T.Font = Enum.Font.Gotham
    end
    Pages.Intelligence.CanvasSize = UDim2.new(0,0,0,Pages.Intelligence.UIListLayout.AbsoluteContentSize.Y + 10)
end

-- FEATURE 2: SOCIAL (Wrapped in pcall)
local function loadSocial()
    task.spawn(function()
        local target = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
        local F = Instance.new("TextLabel", Pages.Social)
        F.Size = UDim2.new(1, 0, 0, 30)
        F.Text = "Loading friends for " .. target.Name .. "..."
        F.TextColor3 = UI_THEME.Accent
        F.BackgroundTransparency = 1
        
        local success, result
        for _, proxy in pairs(PROXIES) do
            pcall(function()
                result = game:HttpGet(proxy .. "/v1/users/" .. target.UserId .. "/friends")
                if result then success = true end
            end)
            if success then break end
        end
        
        F:Destroy()
        if success then
            local data = HttpService:JSONDecode(result)
            for i, friend in pairs(data.data) do
                if i > 15 then break end
                local Row = Instance.new("Frame", Pages.Social)
                Row.Size = UDim2.new(1, 0, 0, 40)
                Row.BackgroundColor3 = Color3.fromRGB(25, 30, 25)
                Instance.new("UICorner", Row)
                local L = Instance.new("TextLabel", Row)
                L.Size = UDim2.new(1, -10, 1, 0)
                L.Position = UDim2.new(0, 10, 0, 0)
                L.Text = friend.displayName .. " (@" .. friend.name .. ")"
                L.TextColor3 = UI_THEME.Text
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.BackgroundTransparency = 1
            end
        else
            local E = Instance.new("TextLabel", Pages.Social)
            E.Text = "Social API Blocked by Executor."
            E.TextColor3 = Color3.fromRGB(255, 100, 100)
            E.Size = UDim2.new(1, 0, 0, 30)
            E.BackgroundTransparency = 1
        end
    end)
end

-- FEATURE 3: RADAR (Simplified & Safe)
local RadarBox = Instance.new("Frame", Pages.Radar)
RadarBox.Size = UDim2.new(0, 200, 0, 200)
RadarBox.Position = UDim2.new(0.5, -100, 0, 10)
RadarBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", RadarBox).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Pages.Radar.Visible then return end
    for _, d in pairs(RadarBox:GetChildren()) do if d.Name == "Dot" then d:Destroy() end end
    local lp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not lp then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local rel = p.Character.HumanoidRootPart.Position - lp.Position
            local d = Instance.new("Frame", RadarBox)
            d.Name = "Dot"
            d.Size = UDim2.new(0, 4, 0, 4)
            d.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            d.Position = UDim2.new(0.5, rel.X/10, 0.5, rel.Z/10)
            Instance.new("UICorner", d)
        end
    end
end)

-- FEATURE 4: ECONOMY
local function loadEconomy()
    Pages.Economy:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Economy).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local est = (p.AccountAge > 365 and 1000 or 0) + (p.MembershipType == Enum.MembershipType.Premium and 500 or 0)
        local F = Instance.new("Frame", Pages.Economy)
        F.Size = UDim2.new(1, 0, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
        Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, -10, 1, 0)
        T.Position = UDim2.new(0, 10, 0, 0)
        T.Text = p.Name .. " | Est. Value: " .. est .. " R$"
        T.TextColor3 = Color3.fromRGB(0, 255, 100)
        T.BackgroundTransparency = 1
        T.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- Toggle Button
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 50, 0, 50)
T.Position = UDim2.new(0, 10, 0.5, -25)
T.Text = "BT6"
T.BackgroundColor3 = UI_THEME.Accent
T.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
T.Draggable = true
T.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Initial Calls
updateIntel()
loadSocial()
loadEconomy()

Players.PlayerAdded:Connect(updateIntel)
Players.PlayerRemoving:Connect(updateIntel)
print("Bloxtracker Pro v6.0 Loaded!")
