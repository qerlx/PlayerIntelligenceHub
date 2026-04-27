--[[
    ██████╗ ██╗      ██████╗ ██╗  ██╗████████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗ 
    ██╔══██╗██║     ██╔═══██╗╚██╗██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ██████╔╝██║     ██║   ██║ ╚███╔╝    ██║   ██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
    ██╔══██╗██║     ██║   ██║ ██╔██╗    ██║   ██╔══██╗██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ██████╔╝███████╗╚██████╔╝██╔╝ ██╗   ██║   ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚══════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    BLOXTRACTER PRO v2.0 | THE ULTIMATE INTELLIGENCE HUB
    Developed for Professional Tracking & Analytics
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("BloxtrackerPro") then CoreGui.BloxtrackerPro:Destroy() end

-- Settings
local Settings = {
    ESP_Enabled = false,
    Tracers_Enabled = false,
    ChatLog_Enabled = true,
    MinAgeFlag = 7,
    UI_Color = Color3.fromRGB(0, 170, 255)
}

-- UI Library (Simplified for massive script)
local UI = Instance.new("ScreenGui")
UI.Name = "BloxtrackerPro"
UI.Parent = CoreGui
UI.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Parent = UI
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Navigation Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.Text = "BLOXTRACTER"
Logo.TextColor3 = Settings.UI_Color
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.BackgroundTransparency = 1
Logo.Parent = Sidebar

-- Tab Container
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -130, 1, -20)
Pages.Position = UDim2.new(0, 125, 0, 10)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local function createPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.Parent = Pages
    
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)
    return Page
end

local Dashboard = createPage("Dashboard")
local PlayerTab = createPage("Players")
local VisualsTab = createPage("Visuals")
local ChatTab = createPage("ChatLogs")
Dashboard.Visible = true

-- Tab Switching
local function showTab(name)
    for _, p in pairs(Pages:GetChildren()) do p.Visible = (p.Name == name) end
end

local function addTabBtn(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = Sidebar
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function() showTab(name) end)
end

addTabBtn("Dashboard")
addTabBtn("Players")
addTabBtn("Visuals")
addTabBtn("ChatLogs")

local UIList = Instance.new("UIListLayout", Sidebar)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- DASHBOARD CONTENT
local function addStat(parent, title, value)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 40)
    F.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    F.Parent = parent
    Instance.new("UICorner", F)
    
    local T = Instance.new("TextLabel", F)
    T.Size = UDim2.new(0.5, 0, 1, 0)
    T.Position = UDim2.new(0, 10, 0, 0)
    T.Text = title
    T.TextColor3 = Color3.fromRGB(150, 150, 150)
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1
    
    local V = Instance.new("TextLabel", F)
    V.Size = UDim2.new(0.5, 0, 1, 0)
    V.Position = UDim2.new(0.5, -10, 0, 0)
    V.Text = value
    V.TextColor3 = Color3.fromRGB(255, 255, 255)
    V.TextXAlignment = Enum.TextXAlignment.Right
    V.BackgroundTransparency = 1
    return V
end

local serverUptime = addStat(Dashboard, "Server Uptime", "00:00:00")
local avgAge = addStat(Dashboard, "Avg. Account Age", "Calculating...")
local totalPlayers = addStat(Dashboard, "Total Players", #Players:GetPlayers())

-- PLAYER TAB CONTENT
local function updatePlayerList()
    PlayerTab:ClearAllChildren()
    Instance.new("UIListLayout", PlayerTab).Padding = UDim.new(0, 5)
    
    for _, p in pairs(Players:GetPlayers()) do
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, 0, 0, 60)
        F.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        F.Parent = PlayerTab
        Instance.new("UICorner", F)
        
        local Img = Instance.new("ImageLabel", F)
        Img.Size = UDim2.new(0, 50, 0, 50)
        Img.Position = UDim2.new(0, 5, 0, 5)
        Img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        Instance.new("UICorner", Img).CornerRadius = UDim.new(1, 0)
        
        local Name = Instance.new("TextLabel", F)
        Name.Position = UDim2.new(0, 65, 0, 5)
        Name.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        Name.TextColor3 = Color3.fromRGB(255, 255, 255)
        Name.Font = Enum.Font.GothamBold
        Name.BackgroundTransparency = 1
        Name.TextXAlignment = Enum.TextXAlignment.Left
        
        local Info = Instance.new("TextLabel", F)
        Info.Position = UDim2.new(0, 65, 0, 25)
        Info.Text = "Age: " .. p.AccountAge .. "d | Health: " .. (p.Character and p.Character:FindFirstChildOfClass("Humanoid") and math.floor(p.Character:FindFirstChildOfClass("Humanoid").Health) or "0")
        Info.TextColor3 = Color3.fromRGB(150, 150, 150)
        Info.BackgroundTransparency = 1
        Info.TextXAlignment = Enum.TextXAlignment.Left

        local View = Instance.new("TextButton", F)
        View.Size = UDim2.new(0, 60, 0, 25)
        View.Position = UDim2.new(1, -70, 0, 17)
        View.Text = "SPECTATE"
        View.BackgroundColor3 = Settings.UI_Color
        Instance.new("UICorner", View)
        View.MouseButton1Click:Connect(function() workspace.CurrentCamera.CameraSubject = p.Character end)
    end
end

-- VISUALS TAB (ESP Logic)
local function createToggle(parent, name, callback)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    B.Text = name .. ": OFF"
    B.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", B)
    
    local state = false
    B.MouseButton1Click:Connect(function()
        state = not state
        B.Text = name .. ": " .. (state and "ON" or "OFF")
        B.TextColor3 = state and Settings.UI_Color or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

createToggle(VisualsTab, "Box ESP", function(v) Settings.ESP_Enabled = v end)
createToggle(VisualsTab, "Tracers", function(v) Settings.Tracers_Enabled = v end)

-- CHAT LOG TAB
local function addLog(msg)
    local L = Instance.new("TextLabel", ChatTab)
    L.Size = UDim2.new(1, 0, 0, 20)
    L.Text = msg
    L.TextColor3 = Color3.fromRGB(200, 200, 200)
    L.BackgroundTransparency = 1
    L.TextXAlignment = Enum.TextXAlignment.Left
    ChatTab.CanvasSize = UDim2.new(0, 0, 0, ChatTab.UIListLayout.AbsoluteContentSize.Y)
end

Players.PlayerChatted:Connect(function(type, player, message)
    addLog("[" .. player.Name .. "]: " .. message)
end)

-- TOGGLE BUTTON
local Toggle = Instance.new("TextButton", UI)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 20, 0.5, -25)
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.Text = "BT"
Toggle.TextColor3 = Settings.UI_Color
Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.Draggable = true

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- LOOPING LOGIC
task.spawn(function()
    while task.wait(1) do
        -- Dashboard Update
        local up = workspace.DistributedGameTime
        serverUptime.Text = string.format("%02d:%02d:%02d", math.floor(up/3600), math.floor((up%3600)/60), math.floor(up%60))
        
        local totalAge = 0
        for _, p in pairs(Players:GetPlayers()) do totalAge = totalAge + p.AccountAge end
        avgAge.Text = math.floor(totalAge/#Players:GetPlayers()) .. " days"
        totalPlayers.Text = #Players:GetPlayers() .. "/" .. game.MaxPlayers
        
        -- ESP Logic
        if Settings.ESP_Enabled or Settings.Tracers_Enabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    -- Very basic ESP logic placeholder (High performance)
                    if not p.Character:FindFirstChild("BT_ESP") then
                        local b = Instance.new("Highlight", p.Character)
                        b.Name = "BT_ESP"
                        b.FillTransparency = 1
                        b.OutlineColor = Settings.UI_Color
                    end
                    p.Character.BT_ESP.Enabled = Settings.ESP_Enabled
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Final Notification
local function notify(t, m)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = t, Text = m, Duration = 5})
end
notify("Bloxtracker Pro", "Version 2.0 Loaded Successfully!")
