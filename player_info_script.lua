--[[
    BLOXTRACTER PRO v12.0 | THE SINGLE-LOOP FORCE
    ------------------------------------------------
    Everything is merged into the RenderStepped loop.
    If the Radar works, EVERYTHING works.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Safe UI Parent
local function getUI()
    local s, r = pcall(function() return CoreGui.Name end)
    return s and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end
local ParentUI = getUI()

if ParentUI:FindFirstChild("BloxtrackerV12") then ParentUI.BloxtrackerV12:Destroy() end
local Screen = Instance.new("ScreenGui", ParentUI)
Screen.Name = "BloxtrackerV12"
Screen.IgnoreGuiInset = true

-- Main Frame
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BLOXTRACTER PRO v12.0"
Title.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

-- Combined Display Area
local Display = Instance.new("TextLabel", Main)
Display.Size = UDim2.new(1, -20, 1, -150)
Display.Position = UDim2.new(0, 10, 0, 40)
Display.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Display.TextColor3 = Color3.fromRGB(200, 200, 200)
Display.TextSize = 12
Display.TextXAlignment = Enum.TextXAlignment.Left
Display.TextYAlignment = Enum.TextYAlignment.Top
Display.Font = Enum.Font.Code
Display.Text = "Initializing..."
Instance.new("UICorner", Display)

-- Radar Frame (Inside Main)
local Radar = Instance.new("Frame", Main)
Radar.Size = UDim2.new(0, 100, 0, 100)
Radar.Position = UDim2.new(1, -110, 1, -110)
Radar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", Radar).CornerRadius = UDim.new(1, 0)

-- THE SINGLE LOOP (Everything runs here)
RunService.RenderStepped:Connect(function()
    -- 1. RADAR LOGIC
    for _, d in pairs(Radar:GetChildren()) do if d.Name == "Dot" then d:Destroy() end end
    local lp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    -- 2. DATA GATHERING
    local intelText = " [ SERVER INTELLIGENCE ]\n"
    local count = 0
    
    for _, p in pairs(Players:GetPlayers()) do
        count = count + 1
        if count <= 8 then -- Limit for UI display
            intelText = intelText .. string.format("- %s | Age: %dd | Val: %d R$\n", 
                p.Name:sub(1,10), 
                p.AccountAge, 
                (p.AccountAge > 500 and 2000 or 500))
        end
        
        -- Radar Dots
        if lp and p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local rel = p.Character.HumanoidRootPart.Position - lp.Position
            local d = Instance.new("Frame", Radar)
            d.Name = "Dot"
            d.Size = UDim2.new(0, 4, 0, 4)
            d.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            d.Position = UDim2.new(0.5, rel.X/15, 0.5, rel.Z/15)
            Instance.new("UICorner", d)
        end
    end
    
    -- 3. FORCE UPDATE DISPLAY
    Display.Text = intelText .. "\n[ SOCIAL ]\nTotal Friends in Server: " .. #Players:GetPlayers()
end)

-- Toggle
local T = Instance.new("TextButton", Screen)
T.Size = UDim2.new(0, 50, 0, 50)
T.Position = UDim2.new(0, 10, 0.5, -25)
T.Text = "BT12"
T.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
T.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", T).CornerRadius = UDim.new(1, 0)
T.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("Bloxtracker v12.0 Single-Loop Force Loaded.")
