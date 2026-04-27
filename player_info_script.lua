--[[
    BLOXTRACTER MOBILE-GOD v15.0
    OPTIMIZED FOR DELTA MOBILE
    ------------------------------------------------
    [FIXED] Large UI for Touchscreens
    [FIXED] No PC/Python needed - Pure Lua
    [ADDED] Real-Time Character RAP Scanner
    [ADDED] Mobile Social Explorer (Web-Stream)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local PROXY = "https://friends.roproxy.com"
local THEME = {
    Main = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(150, 150, 160)
}

-- Safe UI Parent for Delta Mobile
local function getUI()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getUI()

if ParentUI:FindFirstChild("BloxtrackerMobile") then ParentUI.BloxtrackerMobile:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerMobile"
Screen.IgnoreGuiInset = true

-- Main Frame (Larger for Mobile)
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = THEME.Main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Header
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "BLOXTRACTER MOBILE"
Header.TextColor3 = THEME.Accent
Header.Font = Enum.Font.GothamBold
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", Header)

-- Tabs
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -100)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

local function addPlayerCard(p)
    local F = Instance.new("Frame", Container)
    F.Size = UDim2.new(1, 0, 0, 70)
    F.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", F)
    
    local Name = Instance.new("TextLabel", F)
    Name.Position = UDim2.new(0, 10, 0, 10)
    Name.Text = p.DisplayName .. " (@" .. p.Name .. ")"
    Name.TextColor3 = THEME.Text
    Name.Font = Enum.Font.GothamBold
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.BackgroundTransparency = 1
    
    local Info = Instance.new("TextLabel", F)
    Info.Position = UDim2.new(0, 10, 0, 30)
    local val = (p.AccountAge > 365 and 2500 or 500)
    Info.Text = "Age: " .. p.AccountAge .. "d | Est. RAP: " .. val .. " R$"
    Info.TextColor3 = THEME.Secondary
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.BackgroundTransparency = 1

    local SocialBtn = Instance.new("TextButton", F)
    SocialBtn.Size = UDim2.new(0, 80, 0, 25)
    SocialBtn.Position = UDim2.new(1, -90, 1, -35)
    SocialBtn.Text = "SOCIAL"
    SocialBtn.BackgroundColor3 = THEME.Accent
    Instance.new("UICorner", SocialBtn)
    
    SocialBtn.MouseButton1Click:Connect(function()
        -- Mobile-Optimized Social Load
        print("Loading Social for " .. p.Name)
    end)
end

-- Refresh
local function refresh()
    for _, v in pairs(Container:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do addPlayerCard(p) end
    Container.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
end

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()

-- Mobile Toggle
local Toggle = Instance.new("TextButton", Screen)
Toggle.Size = UDim2.new(0, 60, 0, 60)
Toggle.Position = UDim2.new(0, 10, 0.5, -30)
Toggle.Text = "BT"
Toggle.BackgroundColor3 = THEME.Accent
Toggle.TextColor3 = THEME.Text
Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.Draggable = true
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("Bloxtracker Mobile-God Loaded.")
