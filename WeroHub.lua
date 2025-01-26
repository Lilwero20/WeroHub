local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "WeroHub",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Loading WeroHub",
    LoadingSubtitle = "by Wero",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local TeleportTab = Window:CreateTab("Teleport", 4483362458) -- Title, Image

 local Input = TeleportTab:CreateInput({
    Name = "TP to Player",
    CurrentValue = "",
    PlaceholderText = "Input Placeholder",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        
        local targetPlayerName = Text
        local localPlayer = Players.LocalPlayer
        
        local function flyToPlayer(targetPlayerName)
            local targetPlayer = Players:FindFirstChild(targetPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                local character = localPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
                    local speed = 250
                    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                    tween:Play()
                end
            end
        end
        
        flyToPlayer(targetPlayerName)
    end,
 })

 local Toggle = TeleportTab:CreateToggle({
    Name = "Tp to Fruit",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local Workspace = game:GetService("Workspace")

        local localPlayer = Players.LocalPlayer

        local function flyToFruit()
            local closestFruit
            local closestDistance = math.huge

            for _, fruit in pairs(Workspace:GetChildren()) do
            if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                local distance = (fruit.Handle.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                closestDistance = distance
                closestFruit = fruit
                end
            end
            end

            if closestFruit then
            local targetPosition = closestFruit.Handle.Position
            local character = localPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = character.HumanoidRootPart
                local distance = (targetPosition - humanoidRootPart.Position).Magnitude
                local speed = 250
                local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                tween:Play()
            end
            end
        end

        if Value then
            flyToFruit()
        end
    end,
 })

 
 local PlayerTab = Window:CreateTab("Player", 4483362458) -- Title, Image

 local Toggle = PlayerTab:CreateToggle({
    Name = "Inf Energy",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local energyConnection

        if Value then
            energyConnection = localPlayer.Character.Energy.Changed:Connect(function()
            localPlayer.Character.Energy.Value = localPlayer.Character.Energy.MaxValue
            end)
        else
            if energyConnection then
            energyConnection:Disconnect()
            energyConnection = nil
            end
        end
    end,
 })
local Toggle = PlayerTab:CreateToggle({
    Name = "Inf Health",
    CurrentValue = false,
    Flag = "Toggle2", -- Ensure this flag is unique
    Callback = function(Value)
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local healthConnection

        if Value then
            healthConnection = localPlayer.Character.Humanoid.HealthChanged:Connect(function()
                localPlayer.Character.Humanoid.Health = localPlayer.Character.Humanoid.MaxHealth
            end)
        else
            if healthConnection then
                healthConnection:Disconnect()
                healthConnection = nil
            end
        end
    end,
})

local Toggle = PlayerTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "Toggle3", -- Ensure this flag is unique
    Callback = function(Value)
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local Workspace = game:GetService("Workspace")
        local localPlayer = Players.LocalPlayer
        local autoFarmConnection

        local function autoFarm()
            while Value do
                local closestEnemy
                local closestDistance = math.huge

                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local distance = (enemy.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestEnemy = enemy
                        end
                    end
                end

                if closestEnemy then
                    local targetPosition = closestEnemy.HumanoidRootPart.Position
                    local character = localPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = character.HumanoidRootPart
                        local distance = (targetPosition - humanoidRootPart.Position).Magnitude
                        local speed = 250
                        humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 10, 0)) -- Fly above the enemy
                        localPlayer.Character:FindFirstChildOfClass("Tool").Handle.Size = Vector3.new(10, 10, 10) -- Increase hitbox size
                        local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                        tween:Play()
                        while tween.PlaybackState == Enum.PlaybackState.Playing do
                            localPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                            wait(0.1)
                        end
                        tween.Completed:Wait()
                        -- Attack the enemy
                        localPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
                    end
                end
                wait(1) -- Adjust the wait time as needed
            end
        end

        if Value then
            autoFarmConnection = game:GetService("RunService").Heartbeat:Connect(autoFarm)
        else
            if autoFarmConnection then
                autoFarmConnection:Disconnect()
                autoFarmConnection = nil
            end
        end
    end,
})