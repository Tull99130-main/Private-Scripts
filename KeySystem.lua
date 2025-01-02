local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "Phantom Hub V 1.0",
    IntroText = "Phantom hub V 1.0",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AimbotConfig"
})

-- Create Main Tab
local MainTab = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables for aimbot, team check, and target part
local EnableAimbot = false
local TeamCheck = false
local TargetPart = "HumanoidRootPart"
local ToggleAim = false
local IsAiming = false
local MaxDistance = 2000  -- Maximum distance for targeting

-- Add sections and toggles to Main Tab
local Section = MainTab:AddSection({Name = "Aimbot Settings"})
Section:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        EnableAimbot = Value
    end
})

Section:AddToggle({
    Name = "Team Check",
    Default = false,
    Callback = function(Value)
        TeamCheck = Value
    end
})

Section:AddDropdown({
    Name = "Target Part",
    Default = "HumanoidRootPart",
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(Value)
        TargetPart = Value
    end
})

Section:AddToggle({
    Name = "Toggle Aim (Hold Right Mouse)",
    Default = false,
    Callback = function(Value)
        ToggleAim = Value
    end
})

-- Create FOV Tab
local FOVTab = Window:MakeTab({
    Name = "Field Of View",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables for FOV circle and rainbow effect
local FOVEnabled = false
local FOVSize = 20
local FOVVisible = false
local FOVColor = Color3.fromRGB(255, 0, 0)
local RainbowEnabled = false

-- Variables for camera aiming
local Camera = workspace.CurrentCamera
local fovCircle = nil  -- To store the FOV circle drawing object

-- Create sections and controls for FOV
local FOVSection = FOVTab:AddSection({Name = "FOV Settings"})
FOVSection:AddToggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        FOVEnabled = Value
    end
})

FOVSection:AddSlider({
    Name = "FOV Size",
    Min = 10,
    Max = 85,
    Default = 20,
    Callback = function(Value)
        FOVSize = Value
    end
})

FOVSection:AddToggle({
    Name = "Visible",
    Default = false,
    Callback = function(Value)
        FOVVisible = Value
    end
})

FOVSection:AddColorpicker({
    Name = "Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        FOVColor = Value
    end
})

FOVSection:AddToggle({
    Name = "Rainbow",
    Default = false,
    Callback = function(Value)
        RainbowEnabled = Value
    end
})

-- ---------------------------------------------------------------------ESP TABS VV

-- Create ESP Tab
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://4483345998", -- Replace with your icon asset if desired
    PremiumOnly = false
})

local ESPObjects = {} -- This table stores ESP elements for each player

-- Function to get the team color or default to white
local function getPlayerColor(player)
    if player.Team then
        return player.Team.TeamColor.Color
    end
    return Color3.new(1, 1, 1) -- Default to white if no team
end

-- Box ESP Functions
local function createBoxESP(player)
    if player == localPlayer then return end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Create a box for the player
    local box = Drawing.new("Square")
    box.Color = getPlayerColor(player) -- Set color based on team
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].Box = box
end

local function deleteBoxESP(player)
    if ESPObjects[player] and ESPObjects[player].Box then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Box = nil
    end
end

-- Name ESP Functions
local function createNameESP(player)
    if player == localPlayer then return end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Create the text label for the player's name
    local nameLabel = Drawing.new("Text")
    nameLabel.Color = getPlayerColor(player) -- Set color based on team
    nameLabel.Thickness = 1
    nameLabel.Size = 15 -- Initial font size
    nameLabel.Text = player.Name
    nameLabel.Center = true
    nameLabel.Visible = false
    nameLabel.Outline = true
    nameLabel.OutlineColor = Color3.new(0, 0, 0) -- Black outline for text stroke

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].NameLabel = nameLabel
end

local function deleteNameESP(player)
    if ESPObjects[player] and ESPObjects[player].NameLabel then
        ESPObjects[player].NameLabel:Remove()
        ESPObjects[player].NameLabel = nil
    end
end

-- Distance ESP Functions
local function createDistanceESP(player)
    if player == localPlayer then return end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Create the text label for the distance
    local distanceLabel = Drawing.new("Text")
    distanceLabel.Color = getPlayerColor(player) -- Set color based on team
    distanceLabel.Thickness = 1
    distanceLabel.Size = 15 -- Initial font size
    distanceLabel.Text = "0 studs"
    distanceLabel.Center = true
    distanceLabel.Visible = false
    distanceLabel.Outline = true
    distanceLabel.OutlineColor = Color3.new(0, 0, 0) -- Black outline for text stroke

    ESPObjects[player] = ESPObjects[player] or {}
    ESPObjects[player].DistanceLabel = distanceLabel
end

local function deleteDistanceESP(player)
    if ESPObjects[player] and ESPObjects[player].DistanceLabel then
        ESPObjects[player].DistanceLabel:Remove()
        ESPObjects[player].DistanceLabel = nil
    end
end

-- Handle toggling Box ESP
local BoxToggle = ESPTab:AddToggle({
    Name = "Box ESP",
    Default = false,
    Callback = function(state)
        if state then
            for _, player in pairs(players:GetPlayers()) do
                createBoxESP(player)
            end
        else
            for _, player in pairs(players:GetPlayers()) do
                deleteBoxESP(player)
            end
        end
    end
})

-- Handle toggling Name ESP
local NameToggle = ESPTab:AddToggle({
    Name = "Name ESP",
    Default = false,
    Callback = function(state)
        if state then
            for _, player in pairs(players:GetPlayers()) do
                createNameESP(player)
            end
        else
            for _, player in pairs(players:GetPlayers()) do
                deleteNameESP(player)
            end
        end
    end
})

-- Handle toggling Distance ESP
local DistanceToggle = ESPTab:AddToggle({
    Name = "Distance ESP",
    Default = false,
    Callback = function(state)
        if state then
            for _, player in pairs(players:GetPlayers()) do
                createDistanceESP(player)
            end
        else
            for _, player in pairs(players:GetPlayers()) do
                deleteDistanceESP(player)
            end
        end
    end
})

-- Update ESP elements when players join or leave
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if BoxToggle.CurrentValue then
            createBoxESP(player)
        end
        if NameToggle.CurrentValue then
            createNameESP(player)
        end
        if DistanceToggle.CurrentValue then
            createDistanceESP(player)
        end
    end)
end)

players.PlayerRemoving:Connect(function(player)
    deleteBoxESP(player)
    deleteNameESP(player)
    deleteDistanceESP(player)
end)

-- Initialize ESP for players already in the game
for _, player in pairs(players:GetPlayers()) do
    if player.Character then
        if BoxToggle.CurrentValue then
            createBoxESP(player)
        end
        if NameToggle.CurrentValue then
            createNameESP(player)
        end
        if DistanceToggle.CurrentValue then
            createDistanceESP(player)
        end
    end
end

-- Single RenderStepped connection to update all ESP elements
game:GetService("RunService").RenderStepped:Connect(function()
    for player, espData in pairs(ESPObjects) do
        -- Update Box ESP
        if espData.Box then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local fromPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    -- Update Box size and position
                    local head = character:FindFirstChild("Head")
                    local feet = character:FindFirstChild("LeftFoot") or character:FindFirstChild("RightFoot")
                    if head and feet then
                        local playerHeight = (head.Position - feet.Position).Magnitude
                        local screenHeight = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, playerHeight, 0)).Y
                        local screenWidth = camera:WorldToViewportPoint(hrp.Position + Vector3.new(playerHeight, 0, 0)).X
                        local boxHeight = screenHeight - fromPos.Y
                        local boxWidth = screenWidth - fromPos.X
                        espData.Box.Size = Vector2.new(boxWidth, boxHeight)
                        espData.Box.Position = Vector2.new(fromPos.X - boxWidth / 2, fromPos.Y - boxHeight / 2)
                        espData.Box.Visible = true
                    end
                else
                    espData.Box.Visible = false
                end
            else
                espData.Box.Visible = false
            end
        end

        -- Update Name ESP
        if espData.NameLabel then
            local character = player.Character
            if character and character:FindFirstChild("Head") then
                local head = character.Head
                local fromPos, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0)) -- Slightly above head
                if onScreen then
                    local distance = (head.Position - camera.CFrame.Position).Magnitude
                    local adjustedSize = math.clamp(25 / (distance / 50), 10, 30)
                    espData.NameLabel.Size = adjustedSize
                    espData.NameLabel.Position = Vector2.new(fromPos.X, fromPos.Y)
                    espData.NameLabel.Visible = true
                else
                    espData.NameLabel.Visible = false
                end
            else
                espData.NameLabel.Visible = false
            end
        end

        -- Update Distance ESP
        if espData.DistanceLabel then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local fromPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (hrp.Position - camera.CFrame.Position).Magnitude
                    espData.DistanceLabel.Text = string.format("%d studs", math.floor(distance))
                    local adjustedSize = math.clamp(25 / (distance / 50), 10, 30)
                    espData.DistanceLabel.Size = adjustedSize
                    espData.DistanceLabel.Position = Vector2.new(fromPos.X, fromPos.Y - 120)
                    espData.DistanceLabel.Visible = true
                else
                    espData.DistanceLabel.Visible = false
                end
            else
                espData.DistanceLabel.Visible = false
            end
        end
    end
end)

-- ---------------------------------------------------------------------ESP TABS ^^

-- ---------------------------------------------------------------------MISC TABS VV
-- Create Miscellaneous Tab
local MiscTab = Window:MakeTab({
    Name = "Misc Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddSection({
    Name = "Player"
})

MiscTab:AddSlider({
    Name = "Slider",
    Min = 0, --  this is the minmum
    Max = 100, -- this is the max speed they can go
    Default = 5, -- this is what it is when you first execute the script
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value -- value means the slider
    end    
})

MiscTab:AddSection({
    Name = "Miscellaneous"
})

MiscTab:AddButton({
    Name = "Unload UI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Create a Tab for Contributions and Safety
local InfoTab = Window:MakeTab({
    Name = "Contributions",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add a Section for Contributions
local ContributionsSection = InfoTab:AddSection({
    Name = "Contributions"
})

ContributionsSection:AddLabel("This script was developed by PhantomScript01.")
ContributionsSection:AddLabel("Thanks to the Orion Library for providing the GUI framework.")
ContributionsSection:AddLabel("For more information, visit the Orion Library documentation: https://github.com/shlexware/Orion")

-- Add a Section for Safe Scripting Practices
local SafetySection = InfoTab:AddSection({
    Name = "Careful Exploiting Practices"
})
-- ---------------------------------------------------------------------MISC TABS ^^

SafetySection:AddLabel("Ensure your scripts are hidden using tools like Lua-Obfuscator.")
SafetySection:AddLabel("Avoid using script sites that take you to third party sites.")
SafetySection:AddLabel("Regularly review and update your scripts to maintain security.")
SafetySection:AddLabel("Never exploit on your main account.")

-- Aimbot Functionality
local function GetPlayerPartPosition(player)
    local character = player.Character
    if character and character:FindFirstChild(TargetPart) then
        return character[TargetPart].Position
    end
    return nil
end

-- Check if a player is alive
local function IsPlayerAlive(player)
    local character = player.Character
    return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
end

-- Check if player is in FOV
local function IsPlayerInFOV(playerPosition)
    local screenPosition, onScreen = Camera:WorldToScreenPoint(playerPosition)
    local fovRadius = (FOVSize / 360) * Camera.ViewportSize.X
    local fovCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Check if the player is inside the FOV circle
    if (Vector2.new(screenPosition.X, screenPosition.Y) - fovCenter).Magnitude <= fovRadius then
        return true
    end
    return false
end

-- Smooth Mouse Movement (for aimbot)
local function SmoothAim(targetPosition, smoothness)
    local direction = (targetPosition - Camera.CFrame.p).unit
    local newPosition = Camera.CFrame.p + direction * smoothness
    Camera.CFrame = CFrame.new(newPosition, targetPosition)
end

-- Aimbot logic (when enabled and toggle is active)
local function LockAimbot()
    if EnableAimbot and (not ToggleAim or IsAiming) then
        local closestPlayer = nil
        local closestDistance = math.huge
        local closestPlayerPosition = nil
        
        -- Find the closest player within the FOV and 2000 studs
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and IsPlayerAlive(player) then
                -- If there are no teams, or the player isn't on the same team, use the aimbot
                if not TeamCheck or (player.Team ~= game.Players.LocalPlayer.Team) then
                    local partPosition = GetPlayerPartPosition(player)
                    if partPosition then
                        -- Calculate the distance to the player
                        local distance = (partPosition - Camera.CFrame.p).magnitude
                        
                        -- Check if the player is within the distance limit and is in the FOV
                        if distance <= MaxDistance and IsPlayerInFOV(partPosition) then
                            -- Check if the player is closer than the previous closest one
                            if distance < closestDistance then
                                closestPlayer = player
                                closestDistance = distance
                                closestPlayerPosition = partPosition
                            end
                        end
                    end
                end
            end
        end
        
        -- Aim at the closest player if found
        if closestPlayerPosition then
            SmoothAim(closestPlayerPosition, 0.1)
        end
    end
end

-- FOV Circle handling using Drawing.new("Circle")
local function DrawFOVCircle()
    if FOVEnabled and FOVVisible then
        -- Remove any existing FOV circle if present
        if fovCircle then
            fovCircle:Remove()
        end
        
        -- Create a new circle for FOV
        fovCircle = Drawing.new("Circle")
        fovCircle.Color = FOVColor
        fovCircle.Thickness = 3  -- Make it visible as a hollow circle
        fovCircle.Transparency = 1
        fovCircle.Filled = false
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        -- Adjust the size of the circle based on the FOV size
        local fovRadius = (FOVSize / 360) * Camera.ViewportSize.X
        fovCircle.Radius = fovRadius
        
        -- Make the circle visible
        fovCircle.Visible = true
    else
        -- Hide the circle when FOV is disabled or visibility is off
        if fovCircle then
            fovCircle.Visible = false
        end
    end
end

-- Rainbow effect for FOV
local function ApplyRainbowEffect()
    if RainbowEnabled then
        local time = tick()
        FOVColor = Color3.fromHSV(time % 5 / 5, 1, 1)  -- Gradually cycle through the color spectrum
    end
end

-- Mouse input listener for Toggle Aim
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsAiming = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsAiming = false
    end
end)

-- Main Update Loop
game:GetService("RunService").RenderStepped:Connect(function()
    if EnableAimbot then
        LockAimbot()
    end
    
    -- Update FOV circle
    DrawFOVCircle()
    
    -- Apply rainbow effect for FOV color
    ApplyRainbowEffect()
end)

-- Finalize the UI
OrionLib:Init()
