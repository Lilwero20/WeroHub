-- Capturar prints en TextLabel
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear GUI para mensajes si no existe
if not PlayerGui:FindFirstChild("MensajesGUI") then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MensajesGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mensajeLabel = Instance.new("TextLabel")
    mensajeLabel.Name = "MensajeLabel"
    mensajeLabel.Text = ""
    mensajeLabel.Size = UDim2.new(0.3, 0, 0.07, 0)
    mensajeLabel.Position = UDim2.new(0.35, 0, 0.05, 0)
    mensajeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mensajeLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    mensajeLabel.TextSize = 18
    mensajeLabel.Font = Enum.Font.GothamBold
    mensajeLabel.Visible = false
    mensajeLabel.BackgroundTransparency = 0.2
    mensajeLabel.TextScaled = true
    mensajeLabel.BorderSizePixel = 0
    mensajeLabel.Parent = screenGui
end

-- Redirigir print a TextLabel y consola
local originalPrint = print
print = function(...)
    local args = {...}
    local text = ""
    for i, v in ipairs(args) do
        text = text .. tostring(v)
        if i < #args then text = text .. " " end
    end
    -- Mostrar en consola
    originalPrint(text)
    -- Mostrar en GUI
    local gui = PlayerGui:WaitForChild("MensajesGUI")
    local label = gui:WaitForChild("MensajeLabel")
    label.Text = text
    label.Visible = true
    task.delay(3, function()
        label.Visible = false
    end)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "WeroHub",
    Icon = 89001596756285,
    LoadingTitle = "Loading WeroHub",
    LoadingSubtitle = "by Wero",
    Theme = "Amethyst",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "Big Hub" },
    Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled", Subtitle = "Key System", Note = "No method of obtaining the key is provided",
        FileName = "Key", SaveKey = true, GrabKeyFromSite = false, Key = {"Hello"}
    }
})

-- Tab Creation
local TeleportTab   = Window:CreateTab("Teleport", 4483362458)
local PlayerTab     = Window:CreateTab("Player", 4483362458)
local ScriptsTab    = Window:CreateTab("Scripts", 4483362458)
local CharacterTab  = Window:CreateTab("Modificar Características", 4483362458)
local HerramientasTab = Window:CreateTab("🔧 Herramientas", 4483362458)
local TrolearTab    = Window:CreateTab("Trolear", 4483362458)
local MiscTab = Window:CreateTab("🔧 Miscs", 4483362458)

-- Services
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local localPlayer = Players.LocalPlayer

-- ============================================================
-- TELEPORT TAB
-- ============================================================
-- TP to Player
TeleportTab:CreateInput({
    Name = "TP to Player", PlaceholderText = "Player Name", RemoveTextAfterFocusLost = false,
    Flag = "TPToPlayer", Callback = function(text)
        local plr = Players:FindFirstChild(text)
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                -- Ascend
                myHrp.CFrame = myHrp.CFrame * CFrame.new(0, 10, 0)
                -- Fly
                local targetPos = hrp.Position + Vector3.new(0, 10, 0)
                local dist = (targetPos - myHrp.Position).Magnitude
                local tween = TweenService:Create(myHrp, TweenInfo.new(dist/250, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                tween:Play()
                tween.Completed:Connect(function()
                    local descend = TweenService:Create(myHrp, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {CFrame = CFrame.new(hrp.Position)})
                    descend:Play()
                end)
            end
        end
    end,
})

-- TP to Fruit
TeleportTab:CreateToggle({
    Name = "Tp to Fruit", CurrentValue = false, Flag = "TpToFruit",
    Callback = function(active)
        if not active then return end
        local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local closest, dist = nil, math.huge
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                local d = (obj.Handle.Position - myHrp.Position).Magnitude
                if d < dist then dist, closest = d, obj end
            end
        end
        if closest then
            local tween = TweenService:Create(myHrp, TweenInfo.new(dist/250, Enum.EasingStyle.Linear), {CFrame = CFrame.new(closest.Handle.Position)})
            tween:Play()
        end
    end,
})

-- Ir a GoldenChest
local flyingEnabled = false
local flightConnection = nil
local flightRunning = false

TeleportTab:CreateToggle({
    Name = "Auto farm Gold(Build a Boat)",
    CurrentValue = false,
    Callback = function(value)
        flyingEnabled = value

        local function startFlying()
            if flightRunning then return end
            flightRunning = true

            task.spawn(function()
                local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local humanoid = char:WaitForChild("Humanoid")
                local TweenService = game:GetService("TweenService")

                local waypoints = {
                    Vector3.new(-55.3, 99.3, 743.4),
		    Vector3.new(-63.9, 97.4, 2592.5),
		    Vector3.new(-53.8, 113, 4329.7),
		    Vector3.new(-68.7, 92.9, 5842.8),
                    Vector3.new(-45.2, 108.1, 8669.0),
                    Vector3.new(-44.1, -254.1, 8810.3),
                    Vector3.new(-55.9, -356.3, 9441.7),
                    Vector3.new(-56.9, -344.2, 9487.2),
                }

                local speed = 450

                local function flyTo(position, isFinal)
                    local distance = (hrp.Position - position).Magnitude
                    local time = distance / speed
                    local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
                    tween:Play()
                    tween.Completed:Wait()

                    if isFinal then
                        -- Desactivar velocidad residual
                        hrp.Velocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero

                        -- Suavemente posicionarse un poco arriba del suelo
                        task.wait(0.1)
                        hrp.CFrame = CFrame.new(position + Vector3.new(0, 1.5, 0))
                    end
                end

                for i, pos in ipairs(waypoints) do
                    if not flyingEnabled then break end
                    flyTo(pos, i == #waypoints)
                end

                flightRunning = false
            end)
        end

        if flyingEnabled then
            startFlying()

            -- Reconectar si el jugador muere
            if flightConnection then flightConnection:Disconnect() end
            flightConnection = localPlayer.CharacterAdded:Connect(function()
                if flyingEnabled then
                    flightRunning = false
                    task.wait(1)
                    startFlying()
                end
            end)
        else
            -- Toggle OFF
            if flightConnection then
                flightConnection:Disconnect()
                flightConnection = nil
            end
        end
    end,
})

-- ============================================================
-- PLAYER TAB
-- ============================================================
-- Infinite Health
PlayerTab:CreateToggle({
    Name = "Inf Health", CurrentValue = false, Flag = "InfHealth",
    Callback = function(active)
        local char = localPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if active then
            humanoid.Health = humanoid.MaxHealth
            humanoid.HealthChanged:Connect(function() humanoid.Health = humanoid.MaxHealth end)
        end
    end,
})

-- Godmode
PlayerTab:CreateToggle({
    Name = "Godmode", CurrentValue = false, Flag = "Godmode",
    Callback = function(active)
        local char = localPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if active then
            humanoid.MaxHealth = math.huge; humanoid.Health = humanoid.MaxHealth
            humanoid.HealthChanged:Connect(function() humanoid.Health = humanoid.MaxHealth end)
        else
            humanoid.MaxHealth = 100; humanoid.Health = 100
        end
    end,
})

-- ============================================================
-- CHARACTER MODIFICATION TAB
-- ============================================================
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Modify Health Max
CharacterTab:CreateSlider({Name="Modificar Vida", Range={0,500}, Increment=10, Suffix="Vida", CurrentValue=humanoid.MaxHealth, Flag="HealthSlider",
    Callback = function(val) humanoid.MaxHealth=val; humanoid.Health=val end
})

-- Modify WalkSpeed
CharacterTab:CreateSlider({Name="Modificar WalkSpeed", Range={0,100}, Increment=1, Suffix="Velocidad", CurrentValue=humanoid.WalkSpeed, Flag="SpeedSlider",
    Callback = function(val) humanoid.WalkSpeed=val end
})

-- Modify JumpPower
CharacterTab:CreateSlider({Name="Modificar JumpPower", Range={0,200}, Increment=1, Suffix="Salto", CurrentValue=humanoid.JumpPower, Flag="JumpSlider",
    Callback = function(val) humanoid.JumpPower=val end
})

-- Add Accessory by ID
CharacterTab:CreateInput({Name="ID de Accesorio", PlaceholderText="Pon el ID del accesorio", RemoveTextAfterFocusLost=false,
    Callback = function(id)
        local ok,Model = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
        if ok and Model then
            local acc = Model:GetChildren()[1]
            if acc then acc.Parent=character end
        end
    end,
})

-- ============================================================
-- SCRIPTS TAB
-- ============================================================
ScriptsTab:CreateButton({Name="Hoho Hub", Callback=function()
print("Hoho Hub Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
end})

ScriptsTab:CreateButton({Name="Steal a Brainrot", Callback=function()
print("Steal a Brainrot Script Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/egor2078f/lurkhackv4/refs/heads/main/main.lua"))()
end})

ScriptsTab:CreateButton({Name="Grow a Garden AutoMiddle Pets", Callback=function()
print("Grow a Garden Script Executed")
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/FakeModz/LimitHub/refs/heads/main/LimitHub_Loader.lua')))()
end})

ScriptsTab:CreateButton({Name="Grow a Garden PetSpawner", Callback=function()
print("Grow a Garden Script Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/iwantsom3/script/refs/heads/main/Gag"))()
end})

ScriptsTab:CreateButton({Name="Grow a Garden Inf Sprinkler", Callback=function()
print("Grow a Garden Script Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end})

ScriptsTab:CreateButton({Name="Grow a Garden", Callback=function()
print("Grow a Garden Script Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"))()
end})

ScriptsTab:CreateButton({Name="Infinity yield", Callback=function()
print("Infinity Yield Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})

ScriptsTab:CreateButton({Name="Dex", Callback=function()
print("Dex Executed")
    loadstring(game:HttpGet("https://pastebin.com/raw/FeMbE4xS"))()
end})

ScriptsTab:CreateButton({Name="DeadRailsBonds", Callback=function()
print("DeadRails Script Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/thantzy/thanhub/refs/heads/main/thanv1"))()
end})

ScriptsTab:CreateButton({Name="DeadRailsBonds2", Callback=function()
print("DeadRails Script Executed")
    loadstring(game:HttpGet("https://getnative.cc/script/loader"))()
end})

ScriptsTab:CreateButton({Name="DeadRails3", Callback=function()
print("DeadRails Script Executed")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/DeadRails"))()
end})

local Button = ScriptsTab:CreateButton({
    Name = "RemoteSpy v3",
    Callback = function()
	print("RemoteSpy v3 Executed")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JaoExploiter/StellySpyV3/refs/heads/main/StellySpyV3.txt"))()
    end,
})

local Button = ScriptsTab:CreateButton({
    Name = "Blox Fruits Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
    end,
})

local Button = ScriptsTab:CreateButton({
    Name = "Fisch Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/IdiotHubz/Scripts/refs/heads/main/Fisch/SpaceHub.lua"))()
    end,
})

local Button = ScriptsTab:CreateButton({
    Name = "C00lkidd GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ShutUpJamesTheLoser/C00lkiddgui/refs/heads/main/C00lkiddgui"))()

    end,
})
-- ============================================================
-- HERRAMIENTAS TAB
-- ============================================================
-- Give All Tools
HerramientasTab:CreateButton({
    Name = "Dar TODAS las herramientas",
    Callback = function()
        local backpack = localPlayer:WaitForChild("Backpack")
        for _,c in pairs({ReplicatedStorage, game.StarterPack, Workspace}) do
            for _,item in ipairs(c:GetDescendants()) do
                if item:IsA("Tool") then
                    item:Clone().Parent = backpack
                end
            end
        end
    end,
})

-- Duplicate Equipped Tool
HerramientasTab:CreateButton({Name="Duplicar herramienta equipada", Callback=function()
    local char = localPlayer.Character
    if char then
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then tool:Clone().Parent=localPlayer.Backpack end
        end
    end
end})

-- ============================================================
-- TROLEAR TAB
-- ============================================================
-- Install ResizePlayer System
TrolearTab:CreateButton({Name="📦 Instalar ResizePlayer", Callback=function()
    if not ReplicatedStorage:FindFirstChild("ResizePlayer") then
        Instance.new("RemoteEvent").Name="ResizePlayer"; ReplicatedStorage.RemoteEvent.Parent=ReplicatedStorage
    end
    if not ServerScriptService:FindFirstChild("ResizePlayerScript") then
        local src = [[
            local RS = game:GetService("ReplicatedStorage")
            local PS = game:GetService("Players")
            RS:WaitForChild("ResizePlayer").OnServerEvent:Connect(function(_,name,scale)
                local p=PS:FindFirstChild(name)
                if p and p.Character then
                    for _,d in ipairs(p.Character:GetDescendants()) do
                        if d:IsA("BasePart") then d.Size *= scale end
                    end
                    local h=p.Character:FindFirstChildOfClass("Humanoid")
                    if h then h.HipHeight*=scale; h:BuildRigFromAttachments() end
                end
            end)
        ]]
        local scr=Instance.new("Script"); scr.Name="ResizePlayerScript"; scr.Source=src; scr.Parent=ServerScriptService
    end
end})

-- Resize Buttons would go here after installation if desired


-- ============================================================
-- NUEVO: Herramienta de Edición de Bloques
-- ============================================================
HerramientasTab:CreateButton({
    Name = "BlockEditor Tool",
    Callback = function()
        local rs = ReplicatedStorage
        local tool = rs:FindFirstChild("BlockEditorTool")
        -- Si no existe, crearlo
        if not tool then
            tool = Instance.new("Tool")
            tool.Name = "BlockEditorTool"
            -- Handle
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1,1,1)
            handle.Parent = tool
            -- LocalScript para la lógica básica
            local logic = Instance.new("LocalScript")
            logic.Name = "BlockEditorScript"
            logic.Source = [[
    local tool = script.Parent
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local selected
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.LineThickness = 0.1
    selectionBox.SurfaceTransparency = 0.5
    selectionBox.Color3 = Color3.new(0, 1, 0)
    -- Circles handles
    local handles = {}
    local function createHandle(position)
        local part = Instance.new("Part")
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Anchored = true
        part.CanCollide = false
        part.Color = Color3.new(0, 1, 0)
        part.Parent = workspace
        part.CFrame = position
        return part
    end
    local function showHandles(target)
        for _, h in pairs(handles) do h:Destroy() end
        handles = {}
        local cf = target.CFrame
        local size = target.Size
        local corners = {
            cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
            cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
            cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
            cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)
        }
        for _, pos in ipairs(corners) do
            table.insert(handles, createHandle(pos))
        end
    end
    mouse.Button2Down:Connect(function()
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            if selected then
                selectionBox.Adornee = nil
            end
            selected = target
            selectionBox.Adornee = selected
            selectionBox.Parent = workspace
            showHandles(selected)
        end
    end)
    mouse.KeyDown:Connect(function(key)
        if not selected then return end
        key = key:lower()
        if key == "s" then
            -- scale uniformly by 10%
            selected.Size = selected.Size * 1.1
            selectionBox.Adornee = selected
            showHandles(selected)
        elseif key == "m" then
            -- move upward by 1 stud
            selected.CFrame = selected.CFrame * CFrame.new(0,1,0)
            selectionBox.Adornee = selected
            showHandles(selected)
        end
    end)
]]
            logic.Parent = tool
            -- Poner en ReplicatedStorage
            tool.Parent = rs
            print("✅ BlockEditorTool creado en ReplicatedStorage")
        end
        -- Dar al jugador
        local clone = tool:Clone()
        clone.Parent = localPlayer:WaitForChild("Backpack")
        print("✅ BlockEditorTool dado al jugador")
    end,
})

-- Inputs para nombre y escala
TrolearTab:CreateInput({
    Name = "👤 Nombre del jugador",
    PlaceholderText = "Escribe el nombre exacto",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        _G.ResizeTarget = Value
    end,
})

TrolearTab:CreateInput({
    Name = "📏 Escala (ej: 1.2)",
    PlaceholderText = "Factor de escala",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        _G.ResizeScale = tonumber(Value)
    end,
})

-- Botón para aplicar la escala
TrolearTab:CreateButton({
    Name = "✅ Aplicar Escala",
    Callback = function()
        if ReplicatedStorage:FindFirstChild("ResizePlayer") and _G.ResizeTarget and _G.ResizeScale then
            ReplicatedStorage.ResizePlayer:FireServer(_G.ResizeTarget, _G.ResizeScale)
        else
            warn("Faltan datos o RemoteEvent no existe")
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")

-- Crear GUI si no existe
if not PlayerGui:FindFirstChild("MensajesGUI") then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MensajesGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mensajeLabel = Instance.new("TextLabel")
    mensajeLabel.Name = "MensajeLabel"
    mensajeLabel.Text = ""
    mensajeLabel.Size = UDim2.new(0.3, 0, 0.07, 0)
    mensajeLabel.Position = UDim2.new(0.35, 0, 0.05, 0)
    mensajeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mensajeLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    mensajeLabel.TextSize = 18
    mensajeLabel.Font = Enum.Font.GothamBold
    mensajeLabel.Visible = false
    mensajeLabel.BackgroundTransparency = 0.2
    mensajeLabel.TextScaled = true
    mensajeLabel.BorderSizePixel = 0
    mensajeLabel.Parent = screenGui
end

-- Función para mostrar mensajes bonitos
local function MostrarMensaje(texto)
    local gui = PlayerGui:WaitForChild("MensajesGUI")
    local label = gui:WaitForChild("MensajeLabel")
    label.Text = texto
    label.Visible = true
    task.wait(3)
    label.Visible = false
end

-- Variable para manejar conexión Anti AFK
local AntiAFK_Connection

-- Toggle Anti AFK en Rayfield
MiscTab:CreateToggle({
    Name = "🛡️ Anti AFK",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            AntiAFK_Connection = Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
            MostrarMensaje("✅ Anti AFK activado.")
        else
            if AntiAFK_Connection then
                AntiAFK_Connection:Disconnect()
                AntiAFK_Connection = nil
                MostrarMensaje("❌ Anti AFK desactivado.")
            end
        end
    end,
})

MiscTab:CreateToggle({
	Name = "📍 Mostrar posición actual",
	CurrentValue = false,
	Callback = function(Value)
		local player = game.Players.LocalPlayer
		local RunService = game:GetService("RunService")
		local guiName = "PosicionGUI"
		local connection

		if Value then
			-- Crear GUI y TextLabel si no existe
			local gui = player:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
			if not gui then
				gui = Instance.new("ScreenGui")
				gui.Name = guiName
				gui.ResetOnSpawn = false
				gui.Parent = player:WaitForChild("PlayerGui")
			end

			local label = gui:FindFirstChild("PosLabel")
			if not label then
				label = Instance.new("TextLabel")
				label.Name = "PosLabel"
				label.Size = UDim2.new(0, 300, 0, 30)
				label.Position = UDim2.new(0, 10, 0, 10)
				label.BackgroundColor3 = Color3.new(0, 0, 0)
				label.BackgroundTransparency = 0.3
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextScaled = true
				label.Font = Enum.Font.SourceSansBold
				label.Text = "Posición: "
				label.Parent = gui
			end

			label.Visible = true

			-- Iniciar actualizador de posición
			connection = RunService.RenderStepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local pos = player.Character.HumanoidRootPart.Position
					label.Text = string.format("Posición: (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
				end
			end)

			-- Guardar la conexión para desconectar luego
			gui:SetAttribute("UpdaterConnection", connection)
		else
			local gui = player:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
			if gui then
				local label = gui:FindFirstChild("PosLabel")
				if label then label:Destroy() end

				local conn = gui:GetAttribute("UpdaterConnection")
				if conn then
					pcall(function() conn:Disconnect() end)
				end

				gui:Destroy()
			end
		end
	end,
})

MiscTab:CreateToggle({
	Name = "💨 Mostrar velocidad actual",
	CurrentValue = false,
	Callback = function(Value)
		local player = game.Players.LocalPlayer
		local RunService = game:GetService("RunService")
		local guiName = "VelocidadGUI"
		local connection

		if Value then
			local gui = player.PlayerGui:FindFirstChild(guiName)
			if not gui then
				gui = Instance.new("ScreenGui")
				gui.Name = guiName
				gui.ResetOnSpawn = false
				gui.Parent = player.PlayerGui
			end

			local label = gui:FindFirstChild("VelocidadLabel")
			if not label then
				label = Instance.new("TextLabel")
				label.Name = "VelocidadLabel"
				label.Size = UDim2.new(0, 300, 0, 30)
				label.Position = UDim2.new(0, 10, 0, 50)
				label.BackgroundColor3 = Color3.new(0, 0, 0)
				label.BackgroundTransparency = 0.3
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextScaled = true
				label.Font = Enum.Font.SourceSansBold
				label.Text = "Velocidad: "
				label.Parent = gui
			end

			label.Visible = true

			connection = RunService.RenderStepped:Connect(function()
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local speed = hrp.Velocity.Magnitude
					label.Text = string.format("Velocidad: %.1f", speed)
				end
			end)

			gui:SetAttribute("SpeedConnection", connection)
		else
			local gui = player.PlayerGui:FindFirstChild(guiName)
			if gui then
				local label = gui:FindFirstChild("VelocidadLabel")
				if label then label:Destroy() end

				local conn = gui:GetAttribute("SpeedConnection")
				if conn then
					pcall(function() conn:Disconnect() end)
				end

				gui:Destroy()
			end
		end
	end,
})

MiscTab:CreateToggle({
    Name = "🕒 Mostrar hora actual en México",
    CurrentValue = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local guiName = "HoraMexicoGUI"
        local connection

        if Value then
            -- Crear GUI y TextLabel si no existe
            local gui = player:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
            if not gui then
                gui = Instance.new("ScreenGui")
                gui.Name = guiName
                gui.ResetOnSpawn = false
                gui.Parent = player:WaitForChild("PlayerGui")
            end

            local label = gui:FindFirstChild("HoraLabel")
            if not label then
                label = Instance.new("TextLabel")
                label.Name = "HoraLabel"
                label.Size = UDim2.new(0, 300, 0, 30)
                label.Position = UDim2.new(0, 10, 0, 10)
                label.BackgroundColor3 = Color3.new(0, 0, 0)
                label.BackgroundTransparency = 0.3
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Text = "Hora de México: "
                label.Parent = gui
            end

            label.Visible = true

            -- Iniciar actualizador de hora
            connection = RunService.RenderStepped:Connect(function()
                local currentTime = os.date("!*t", os.time()) -- Obtiene hora UTC
                -- Convertir la hora UTC a hora de México (zona horaria UTC -6)
                currentTime.hour = currentTime.hour - 6
                if currentTime.hour < 0 then
                    currentTime.hour = currentTime.hour + 24
                end
                label.Text = string.format("Hora de México: %02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)
            end)

            -- Guardar la conexión para desconectar luego
            gui:SetAttribute("TimeConnection", connection)
        else
            local gui = player:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
            if gui then
                local label = gui:FindFirstChild("HoraLabel")
                if label then label:Destroy() end

                local conn = gui:GetAttribute("TimeConnection")
                if conn then
                    pcall(function() conn:Disconnect() end)
                end

                gui:Destroy()
            end
        end
    end,
})


-- End of WeroHub Script
