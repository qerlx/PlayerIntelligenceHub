--!strict

--[[ Player Intelligence Hub v2 ]]
-- Added visual notifications and better console logging.

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Function to send a notification to the user's screen
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 5;
        })
    end)
end

-- Immediate feedback
notify("Intelligence Hub", "Script Loading... Check F9 Console.")

-- Configuration
local MIN_ACCOUNT_AGE_DAYS = 7

local function getServerUptime()
    local uptimeSeconds = workspace.DistributedGameTime
    
    local days = math.floor(uptimeSeconds / 86400)
    local hours = math.floor((uptimeSeconds % 86400) / 3600)
    local minutes = math.floor((uptimeSeconds % 3600) / 60)
    local seconds = math.floor(uptimeSeconds % 60)

    return string.format("%d days, %d hours, %d minutes, %d seconds", days, hours, minutes, seconds)
end

local function gatherPlayerInfo()
    print("\n" .. string.rep("=", 40))
    print("      PLAYER INTELLIGENCE HUB v2      ")
    print(string.rep("=", 40))
    print("Server Uptime: " .. getServerUptime())
    print("Player Count: " .. #Players:GetPlayers() .. "/" .. game.MaxPlayers)
    print(string.rep("-", 40))

    for _, player in ipairs(Players:GetPlayers()) do
        print("\n[+] PLAYER: " .. player.Name)
        print("    Display: " .. player.DisplayName)
        print("    User ID: " .. player.UserId)
        print("    Account Age: " .. player.AccountAge .. " days")
        
        if player.AccountAge < MIN_ACCOUNT_AGE_DAYS then
            print("    [!] WARNING: NEW ACCOUNT")
        end

        local character = player.Character
        if character then
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                print(string.format("    Health: %.1f/%.1f", hum.Health, hum.MaxHealth))
                print("    WalkSpeed: " .. hum.WalkSpeed)
            end
            
            local tools = {}
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then table.insert(tools, item.Name) end
                end
            end
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") then table.insert(tools, item.Name) end
            end
            print("    Tools: " .. (#tools > 0 and table.concat(tools, ", ") or "None"))
        end
        print(string.rep("-", 20))
    end
    
    print("\n" .. string.rep("=", 40))
    notify("Intelligence Hub", "Data gathered! Press F9 to view.")
end

-- Run with error handling
local success, err = pcall(gatherPlayerInfo)
if not success then
    warn("Intelligence Hub Error: " .. tostring(err))
    notify("Hub Error", "Check console for details.")
end
