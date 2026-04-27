--!strict

--[[ Player Information Hub Script ]]
-- This script aims to gather detailed information about players in a Roblox server.
-- Due to limitations of executors and Roblox's API security, direct access to certain
-- web-based information (like RAP, full friend lists, favorite games, playtime)
-- is often restricted or requires complex workarounds (e.g., proxy servers, external APIs).
-- This script will focus on information accessible directly within the game environment
-- and provide placeholders/comments for where web API calls would ideally go.
--
-- Features:
-- - Basic Player Info (Username, Display Name, UserID, Account Age)
-- - Player Statistics (WalkSpeed, JumpPower, Health)
-- - Group Memberships
-- - Tool/Item Inspection (currently held tools)
-- - Basic Account Safety Check (new accounts)
-- - Server Information (Uptime, Player Count)
--
-- Usage:
-- Execute this script in a Roblox executor. Information will be printed to the executor's console.
-- For a GUI, further development would be required.
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configuration
local MIN_ACCOUNT_AGE_DAYS = 7 -- Flag accounts younger than this as potentially new/alt

-- Function to get server uptime
local function getServerUptime()
    local startTime = game.Workspace.DistributedGameTime
    local currentTime = tick()
    local uptimeSeconds = currentTime - startTime

    local days = math.floor(uptimeSeconds / 86400)
    local hours = math.floor((uptimeSeconds %% 86400) / 3600)
    local minutes = math.floor((uptimeSeconds %% 3600) / 60)
    local seconds = math.floor(uptimeSeconds %% 60)

    return string.format("%d days, %d hours, %d minutes, %d seconds", days, hours, minutes, seconds)
end

-- Function to get player account age in days
local function getAccountAgeInDays(player)
    local userId = player.UserId
    local success, data = pcall(function()
        return HttpService:JSONDecode(HttpService:GetAsync("https://users.roblox.com/v1/users/" .. userId))
    end)

    if success and data and data.created then
        local creationTime = DateTime.fromIsoDate(data.created)
        local currentTime = DateTime.now()
        local ageDuration = currentTime:ToUniversalTime() - creationTime:ToUniversalTime()
        return math.floor(ageDuration.TotalSeconds / 86400)
    end
    return nil
end

-- Main function to gather and display player information
local function gatherPlayerInfo()
    print("\n--- Server Information ---")
    print("Server Uptime: " .. getServerUptime())
    print("Current Players: " .. #Players:GetPlayers())
    print("Max Players: " .. game.MaxPlayers)
    print("------------------------\n")

    for i, player in ipairs(Players:GetPlayers()) do
        print("--- Player: " .. player.Name .. " ---")
        print("  Display Name: " .. player.DisplayName)
        print("  User ID: " .. player.UserId)

        local accountAgeDays = getAccountAgeInDays(player)
        if accountAgeDays then
            print("  Account Age: " .. accountAgeDays .. " days")
            if accountAgeDays < MIN_ACCOUNT_AGE_DAYS then
                print("  [WARNING]: Potentially new/alt account!")
            end
        else
            print("  Account Age: Could not retrieve (web API issue or rate limit)")
        end

        -- Character Stats
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                print("  WalkSpeed: " .. humanoid.WalkSpeed)
                print("  JumpPower: " .. humanoid.JumpPower)
                print("  Health: " .. humanoid.Health .. "/" .. humanoid.MaxHealth)
            end

            -- Currently held tools
            local backpack = player:FindFirstChildOfClass("Backpack")
            local tools = {}
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        table.insert(tools, item.Name)
                    end
                end
            end
            -- Check character for equipped tool too
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") then
                    table.insert(tools, item.Name)
                end
            end
            if #tools > 0 then
                print("  Held Tools: " .. table.concat(tools, ", "))
            else
                print("  Held Tools: None")
            end
        else
            print("  Character: Not found or not loaded")
        end

        -- Group Memberships (requires web API, often blocked by executors or rate-limited)
        -- This would typically involve HttpService:GetAsync to groups.roblox.com/v1/users/{userId}/groups/roles
        print("  Groups: (Web API access often restricted)")

        -- Friends, RAP, Favorite Games, Playtime (all require extensive web API calls)
        -- These are generally not directly accessible from the game client via simple HttpService calls
        -- without a proxy or specific server-side setup, which is beyond executor capabilities.
        print("  Friends: (Web API access often restricted)")
        print("  RAP (Recent Average Price): (Web API access often restricted)")
        print("  Favorite Games: (Web API access often restricted)")
        print("  Playtime: (Web API access often restricted)")

        print("---------------------------\n")
    end
end

-- Execute the function
gatherPlayerInfo()

-- Optional: You could set up a loop to refresh this info, but it might be spammy.
-- while true do
--     gatherPlayerInfo()
--     task.wait(30) -- Refresh every 30 seconds
-- end
