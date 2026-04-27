--[[
    BLOXTRACTER PRO v5.0 | THE "FINAL POLISH" UPDATE
    Fixed Scaling, Dual-Proxy Social, and Advanced Radar Zoom.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local PROXIES = {"https://friends.roproxy.com", "https://friends.roblox.com.roproxy.com"}
local UI_THEME = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(180, 180, 180)
}

-- UI Parent Logic
local function getUI()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getUI()

if ParentUI:FindFirstChild("BloxtrackerV5") then ParentUI.BloxtrackerV5:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerV5"
Screen.IgnoreGuiInset = true

-- Main Hub with Scaling
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = UI_THEME.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Scaling Constraints (Fixes "Weird" Look)
local UIScale = Instance.new("UIScale", Main)
if UserInputService.TouchEnabled then UIScale.Scale = 0.8 end -- Smaller for mobile

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = UI_THEME.Sidebar
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
    Social = createPage("Social"),
    Radar = createPage("Radar"),
    Economy = createPage("Economy")
}
Pages.Social.Visible = true

-- Tab Buttons
local function addTab(name)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(0.9, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    B.Text = name:upper()
    B.TextColor3 = UI_THEME.Text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = (n == name) end
    end)
end

Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)
addTab("Social")
addTab("Radar")
addTab("Economy")

-- 1. SOCIAL (Dual-Proxy Fix)
local function loadFriends(userId)
    Pages.Social:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Social).Padding = UDim.new(0, 5)
    
    local Label = Instance.new("TextLabel", Pages.Social)
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Text = "Fetching Social Data..."
    Label.TextColor3 = UI_THEME.Accent
    Label.BackgroundTransparency = 1

    task.spawn(function()
        local success, result
        for _, proxy in pairs(PROXIES) do
            success, result = pcall(function()
                return game:HttpGet(proxy .. "/v1/users/" .. userId .. "/friends")
            end)
            if success then break end
        end
        
        Label:Destroy()
        if success then
            local data = HttpService:JSONDecode(result)
            if #data.data == 0 then
                local E = Instance.new("TextLabel", Pages.Social)
                E.Text = "No public friends found."
                E.TextColor3 = UI_THEME.SecondaryText
                return
            end
            for i, friend in pairs(data.data) do
                if i > 25 then break end
                local F = Instance.new("Frame", Pages.Social)
                F.Size = UDim2.new(1, 0, 0, 45)
                F.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                Instance.new("UICorner", F)
                
                local N = Instance.new("TextLabel", F)
                N.Position = UDim2.new(0, 10, 0, 0)
                N.Size = UDim2.new(0.7, 0, 1, 0)
                N.Text = friend.displayName .. "\n(@" .. friend.name .. ")"
                N.TextColor3 = UI_THEME.Text
                N.TextXAlignment = Enum.TextXAlignment.Left
                N.BackgroundTransparency = 1
                N.TextSize = 11
                
                local J = Instance.new("TextButton", F)
                J.Size = UDim2.new(0, 70, 0, 25)
                J.Position = UDim2.new(1, -80, 0.5, -12)
                J.Text = "JOIN"
                J.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
                Instance.new("UICorner", J)
            end
        else
            local E = Instance.new("TextLabel", Pages.Social)
            E.Text = "Proxy Error: All endpoints failed."
            E.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
end

-- 2. RADAR (Zoom & Center Fix)
local RadarFrame = Instance.new("Frame", Pages.Radar)
RadarFrame.Size = UDim2.new(0, 200, 0, 200)
RadarFrame.Position = UDim2.new(0.5, -100, 0, 10)
RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", RadarFrame).CornerRadius = UDim.new(1, 0)

local RadarZoom = 5 -- Default Zoom
local ZoomLabel = Instance.new("TextLabel", Pages.Radar)
ZoomLabel.Size = UDim2.new(1, 0, 0, 20)
ZoomLabel.Position = UDim2.new(0, 0, 0, 220)
ZoomLabel.Text = "Radar Zoom: " .. RadarZoom
ZoomLabel.TextColor3 = UI_THEME.Accent
ZoomLabel.BackgroundTransparency = 1

RunService.RenderStepped:Connect(function()
    if not Pages.Radar.Visible then return end
    for _, d in pairs(RadarFrame:GetChildren()) do if d.Name == "Dot" then d:Destroy() end end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local lpPos = char.HumanoidRootPart.Position
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local relPos = p.Character.HumanoidRootPart.Position - lpPos
            local dot = Instance.new("Frame", RadarFrame)
            dot.Name = "Dot"
            dot.Size = UDim2.new(0, 5, 0, 5)
            dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            Instance.new("UICorner", dot)
            dot.Position = UDim2.new(0.5, relPos.X/RadarZoom, 0.5, relPos.Z/RadarZoom)
        end
    end
end)

-- 3. ECONOMY (Scanned Values)
local function loadEconomy()
    Pages.Economy:ClearAllChildren()
    Instance.new("UIListLayout", Pages.Economy).Padding = UDim.new(0, 5)
    for _, p in pairs(Players:GetPlayers()) do
        local est = (p.AccountAge > 500 and 2500 or 0) + (p.MembershipType == Enum.MembershipType.Premium and 1000 or 0)
        local F = Instance.new("Frame", Pages.Economy)
        F.Size = UDim2.new(1, 0, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(25, 30, 25)
        Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, -10, 1, 0)
        T.Position = UDim2.new(0, 10, 0, 0)
        T.Text = p.DisplayName .. " | Est. RAP: " .. est .. " R$"
        T.TextColor3 = Color3.fromRGB(0, 255, 100)
        T.BackgroundTransparency = 1
        T.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- Toggle Button
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 50, 0, 50)
T.Position = UDim2.new(0, 10, 0.5, -25)
T.Text = "BT5"
T.BackgroundColor3 = UI_THEME.Accent
T.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
T.Draggable = true
T.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

loadFriends(LocalPlayer.UserId)
loadEconomy()
print("Bloxtracker Pro v5.0 Loaded!")
