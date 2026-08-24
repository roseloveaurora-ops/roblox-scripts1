-- // Artnes GUI (Visual Only)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser") -- Для Anti AFK

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArtnesGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Create TargetScreenGui
local TargetScreenGui = Instance.new("ScreenGui")
TargetScreenGui.Name = "ArtnesTargetGUI"
TargetScreenGui.Parent = Player:WaitForChild("PlayerGui")
TargetScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Active = false
TitleBar.Draggable = false
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ARTNES"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local LetterA = Instance.new("TextLabel")
LetterA.Size = UDim2.new(0, 30, 0, 30)
LetterA.Position = UDim2.new(1, -40, 0, 5)
LetterA.BackgroundTransparency = 1
LetterA.Text = "A"
LetterA.Font = Enum.Font.GothamBlack
LetterA.TextSize = 25
LetterA.TextColor3 = Color3.fromRGB(255, 0, 0)
LetterA.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Перетаскивание
local dragging = false
local dragStart = nil
local frameStart = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Tab Frame
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 35)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -95)
ContentFrame.Position = UDim2.new(0, 10, 0, 85)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- Create Tabs
local function CreateTab(name, index)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 95, 0, 30)
    TabButton.Position = UDim2.new(0, 5 + (index * 100), 0, 2)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 11
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Parent = TabFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 15)
    TabCorner.Parent = TabButton

    local Content = Instance.new("Frame")
    Content.Name = name .. "Content"
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.BackgroundTransparency = 1
    Content.Visible = false
    Content.Parent = ContentFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        Content.Visible = true
        
        for _, child in pairs(TabFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
            end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end)

    return Content
end

-- Create Toggle
local function CreateToggle(parent, name, yPos, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local ToggleFrameCorner = Instance.new("UICorner")
    ToggleFrameCorner.CornerRadius = UDim.new(0, 8)
    ToggleFrameCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(0.85, 0, 0.5, -12)
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = ToggleFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 20, 0, 20)
    Dot.Position = UDim2.new(0, 2, 0.5, -10)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Dot.Parent = Button

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local enabled = false
    
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            Dot.Position = UDim2.new(1, -22, 0.5, -10)
            if callback then callback(true) end
        else
            Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Dot.Position = UDim2.new(0, 2, 0.5, -10)
            if callback then callback(false) end
        end
    end)
end

-- Create Slider
local function CreateSlider(parent, name, yPos, minValue, maxValue, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 40)
    SliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0.15, 0, 1, 0)
    ValueBox.Position = UDim2.new(0.85, 0, 0, 0)
    ValueBox.BackgroundTransparency = 1
    ValueBox.Text = tostring(default)
    ValueBox.Font = Enum.Font.GothamBold
    ValueBox.TextSize = 13
    ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueBox.TextXAlignment = Enum.TextXAlignment.Right
    ValueBox.Parent = SliderFrame

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(0.6, 0, 0, 4)
    Track.Position = UDim2.new(0.25, 0, 0.5, -2)
    Track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Track.Text = ""
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Text = ""
    Knob.Parent = Track
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local currentValue = default
    local dragging = false

    local function Update(x)
        local width = Track.AbsoluteSize.X
        if width <= 0 then return end
        local percent = math.clamp((x - Track.AbsolutePosition.X) / width, 0, 1)
        currentValue = math.floor(minValue + (maxValue - minValue) * percent)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, 0, 0.5, 0)
        ValueBox.Text = tostring(currentValue)
        if callback then callback(currentValue) end
    end

    Knob.MouseButton1Down:Connect(function()
        dragging = true
        Update(UserInputService:GetMouseLocation().X)
    end)

    Track.MouseButton1Down:Connect(function()
        dragging = true
        Update(UserInputService:GetMouseLocation().X)
    end)

    UserInputService.InputChanged:Connect(function(input, gp)
        if gp then return end
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    ValueBox.FocusLost:Connect(function()
        local num = tonumber(ValueBox.Text)
        if num then
            num = math.clamp(num, minValue, maxValue)
            Update(num)
        else
            ValueBox.Text = tostring(currentValue)
        end
        ValueBox:ReleaseFocus()
    end)

    task.wait(0.1)
    Update(default)
    return SliderFrame
end

-- Create Tabs
local CombatTab = CreateTab("COMBAT", 0)
local VisualTab = CreateTab("VISUAL", 1)
local MiscTab = CreateTab("MISC", 2)

-- ================= СПИСОК ДРУЗЕЙ =================
local friendNames = {}

local function isFriend(targetPlayer)
    if not targetPlayer then return false end
    local nameToCheck = targetPlayer.Name or targetPlayer.DisplayName
    for _, name in ipairs(friendNames) do
        if name == nameToCheck or name == targetPlayer.DisplayName then
            return true
        end
    end
    return false
end

-- ================= ПОИСК ВРАГА =================
local function FindClosestEnemy()
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closestEnemy = nil
    local closestDist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and not isFriend(player) and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if root and humanoid and humanoid.Health > 0 then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= closestDist then
                    closestDist = dist
                    closestEnemy = player
                end
            end
        end
    end
    return closestEnemy
end

-- ================= AIM ASSIST =================
local aimAssistEnabled = false
local aimFOV = 30
local aimSmoothness = 10
local aimBodyPart = "Head"

local function StartAimAssist()
    task.spawn(function()
        while aimAssistEnabled do
            RunService.RenderStepped:Wait()
            local target = FindClosestEnemy()
            if target and target.Character then
                local camera = workspace.CurrentCamera
                local char = Player.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                
                if camera and myRoot and targetRoot then
                    local targetPart = target.Character:FindFirstChild(aimBodyPart) or targetRoot
                    local targetPos = targetPart.Position
                    local cameraPos = camera.CFrame.Position
                    
                    local dir = (targetPos - cameraPos).Unit
                    local angle = math.deg(math.acos(math.clamp(camera.CFrame.LookVector:Dot(dir), -1, 1)))
                    
                    if angle <= aimFOV then
                        local alpha = math.clamp(aimSmoothness / 20, 0.05, 1)
                        local targetCam = CFrame.lookAt(cameraPos, targetPos)
                        camera.CFrame = camera.CFrame:Lerp(targetCam, alpha, Enum.EasingStyle.Quad)
                        local targetChar = CFrame.lookAt(myRoot.Position, targetPos)
                        myRoot.CFrame = myRoot.CFrame:Lerp(targetChar, alpha, Enum.EasingStyle.Quad)
                    end
                end
            end
        end
    end)
end

-- Тумблер Aim Assist (0)
CreateToggle(CombatTab, "Aim Assist", 0, function(isEnabled)
    aimAssistEnabled = isEnabled
    if isEnabled then StartAimAssist() end
end)

-- Ползунок FOV (45)
CreateSlider(CombatTab, "FOV", 45, 10, 180, 30, function(value)
    aimFOV = value
end)

-- Ползунок Smoothness (90)
CreateSlider(CombatTab, "Smoothness", 90, 1, 20, 10, function(value)
    aimSmoothness = value
end)

-- Переключатель части тела (135)
local bodyPartToggle = Instance.new("Frame")
bodyPartToggle.Size = UDim2.new(1, -20, 0, 40)
bodyPartToggle.Position = UDim2.new(0, 10, 0, 135)
bodyPartToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
bodyPartToggle.BorderSizePixel = 0
bodyPartToggle.Parent = CombatTab

local bodyCorner = Instance.new("UICorner")
bodyCorner.CornerRadius = UDim.new(0, 8)
bodyCorner.Parent = bodyPartToggle

local bodyLabel = Instance.new("TextLabel")
bodyLabel.Size = UDim2.new(0.7, 0, 1, 0)
bodyLabel.BackgroundTransparency = 1
bodyLabel.Text = "Aim Target: Head"
bodyLabel.Font = Enum.Font.GothamBold
bodyLabel.TextSize = 13
bodyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
bodyLabel.Parent = bodyPartToggle

local bodyButton = Instance.new("TextButton")
bodyButton.Size = UDim2.new(0, 50, 0, 25)
bodyButton.Position = UDim2.new(0.85, 0, 0.5, -12)
bodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
bodyButton.Text = "Head"
bodyButton.Font = Enum.Font.GothamBold
bodyButton.TextSize = 12
bodyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bodyButton.Parent = bodyPartToggle

local bodyCorner2 = Instance.new("UICorner")
bodyCorner2.CornerRadius = UDim.new(1, 0)
bodyCorner2.Parent = bodyButton

bodyButton.MouseButton1Click:Connect(function()
    if aimBodyPart == "Head" then
        aimBodyPart = "Torso"
        bodyButton.Text = "Torso"
        bodyLabel.Text = "Aim Target: Torso"
    else
        aimBodyPart = "Head"
        bodyButton.Text = "Head"
        bodyLabel.Text = "Aim Target: Head"
    end
end)

-- Kill Aura (180)
CreateToggle(CombatTab, "Kill Aura", 180)

-- ================= VISUAL =================
-- ESP (0)
local espEnabled = false
local function UpdateESP(player, enabled)
    if player == Player then return end
    local character = player.Character
    if not character then return end
    
    local highlight = character:FindFirstChild("ESP_Highlight")
    
    if enabled then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillColor = Color3.fromRGB(255, 105, 180)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
    else
        if highlight then highlight:Destroy() end
    end
end

CreateToggle(VisualTab, "ESP", 0, function(isEnabled)
    espEnabled = isEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if not isFriend(player) then UpdateESP(player, isEnabled) end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.2)
        if espEnabled and not isFriend(player) then UpdateESP(player, true) end
    end)
end)

-- WorldColor (45)
local function ApplyDefaultPink()
    local Lighting = game:GetService("Lighting")
    Lighting.Ambient = Color3.fromRGB(255, 100, 180)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 150, 200)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogColor = Color3.fromRGB(255, 100, 180)
    Lighting.FogEnd = 500

    local ColorCorrection = Instance.new("ColorCorrectionEffect")
    ColorCorrection.Name = "PinkSky"
    ColorCorrection.TintColor = Color3.fromRGB(255, 180, 220)
    ColorCorrection.Saturation = 0.5
    ColorCorrection.Contrast = 0.2
    ColorCorrection.Parent = Lighting

    if not Lighting:FindFirstChild("PinkSkyObj") then
        local Sky = Instance.new("Sky")
        Sky.Name = "PinkSkyObj"
        Sky.SkyboxBk = "rbxassetid://143672539"
        Sky.SkyboxDn = "rbxassetid://143672539"
        Sky.SkyboxFt = "rbxassetid://143672539"
        Sky.SkyboxLf = "rbxassetid://143672539"
        Sky.SkyboxRt = "rbxassetid://143672539"
        Sky.SkyboxUp = "rbxassetid://143672539"
        Sky.Parent = Lighting
    end
end

local function ResetWorldColor()
    local Lighting = game:GetService("Lighting")
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Brightness = 1
    Lighting.FogColor = Color3.fromRGB(128, 128, 128)
    Lighting.FogEnd = 100000
    if Lighting:FindFirstChild("PinkSky") then Lighting.PinkSky:Destroy() end
    if Lighting:FindFirstChild("PinkSkyObj") then Lighting.PinkSkyObj:Destroy() end
end

CreateToggle(VisualTab, "WorldColor", 45, function(isEnabled)
    if isEnabled then ApplyDefaultPink() else ResetWorldColor() end
end)

-- Target ESP (90)
local targetESPEnabled = false
local targetESPConnection = nil
local currentTarget = nil

local TargetPanel = Instance.new("Frame")
TargetPanel.Size = UDim2.new(0, 200, 0, 60)
TargetPanel.Position = UDim2.new(0, 20, 0.5, -30)
TargetPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetPanel.BorderSizePixel = 0
TargetPanel.Visible = false
TargetPanel.Parent = TargetScreenGui

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 8)
TargetCorner.Parent = TargetPanel

local TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.Size = UDim2.new(0, 40, 0, 40)
TargetAvatar.Position = UDim2.new(0, 6, 0.5, -20)
TargetAvatar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TargetAvatar.Parent = TargetPanel

local TargetAvatarCorner = Instance.new("UICorner")
TargetAvatarCorner.CornerRadius = UDim.new(1, 0)
TargetAvatarCorner.Parent = TargetAvatar

local TargetName = Instance.new("TextLabel")
TargetName.Size = UDim2.new(1, -90, 0, 20)
TargetName.Position = UDim2.new(0, 50, 0, 5)
TargetName.BackgroundTransparency = 1
TargetName.Text = "Target"
TargetName.Font = Enum.Font.GothamBold
TargetName.TextSize = 14
TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetName.TextXAlignment = Enum.TextXAlignment.Center
TargetName.Parent = TargetPanel

local TargetX = Instance.new("TextLabel")
TargetX.Size = UDim2.new(1, -90, 0, 15)
TargetX.Position = UDim2.new(0, 50, 0, 25)
TargetX.BackgroundTransparency = 1
TargetX.Text = "x  x  x  x  x"
TargetX.Font = Enum.Font.Gotham
TargetX.TextSize = 12
TargetX.TextColor3 = Color3.fromRGB(120, 120, 120)
TargetX.TextXAlignment = Enum.TextXAlignment.Center
TargetX.Parent = TargetPanel

local TargetHP = Instance.new("Frame")
TargetHP.Size = UDim2.new(0, 34, 0, 34)
TargetHP.Position = UDim2.new(1, -40, 0.5, -17)
TargetHP.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TargetHP.BorderSizePixel = 0
TargetHP.Parent = TargetPanel

local TargetHPCorner = Instance.new("UICorner")
TargetHPCorner.CornerRadius = UDim.new(1, 0)
TargetHPCorner.Parent = TargetHP

local TargetHPText = Instance.new("TextLabel")
TargetHPText.Size = UDim2.new(1, 0, 1, 0)
TargetHPText.BackgroundTransparency = 1
TargetHPText.Text = "100"
TargetHPText.Font = Enum.Font.GothamBold
TargetHPText.TextSize = 14
TargetHPText.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetHPText.Parent = TargetHP

local panelDragging = false
local panelDragStart = nil
local panelFrameStart = nil

TargetPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        panelDragging = true
        panelDragStart = input.Position
        panelFrameStart = TargetPanel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if panelDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - panelDragStart
        TargetPanel.Position = UDim2.new(panelFrameStart.X.Scale, panelFrameStart.X.Offset + delta.X, panelFrameStart.Y.Scale, panelFrameStart.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        panelDragging = false
    end
end)

local function UpdateTargetVisual(targetPlayer)
    if currentTarget == targetPlayer then return end
    currentTarget = targetPlayer

    if currentTarget and currentTarget.Character then
        local humanoid = currentTarget.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            TargetPanel.Visible = true
            TargetName.Text = currentTarget.Name
            TargetHPText.Text = tostring(math.floor(humanoid.Health))

            task.spawn(function()
                local thumbType = Enum.ThumbnailType.HeadShot
                local thumbSize = Enum.ThumbnailSize.Size100x100
                local content, isReady = Players:GetUserThumbnailAsync(currentTarget.UserId, thumbType, thumbSize)
                if content then TargetAvatar.Image = content end
            end)
        else
            TargetPanel.Visible = false
        end
    else
        TargetPanel.Visible = false
    end
end

local function StartTargetESP()
    targetESPConnection = RunService.RenderStepped:Connect(function()
        local Camera = workspace.CurrentCamera
        local viewportCenter = Camera.ViewportSize / 2
        local closestDist = math.huge
        local closestPlayer = nil

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and not isFriend(player) and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                
                if root and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end

        UpdateTargetVisual(closestPlayer)
    end)
end

local function StopTargetESP()
    if targetESPConnection then targetESPConnection:Disconnect() end
    targetESPConnection = nil
    currentTarget = nil
    TargetPanel.Visible = false
end

CreateToggle(VisualTab, "Target ESP", 90, function(isEnabled)
    targetESPEnabled = isEnabled
    if isEnabled then StartTargetESP() else StopTargetESP() end
end)

-- Target HUD (135)
local targetHUDEnabled = false
local targetHUDConnection = nil
local TargetHUDBillboard = nil
local TargetHUDTarget = nil
local TargetHUDRotationConnection = nil

local function DestroyTargetHUD()
    if TargetHUDBillboard then
        TargetHUDBillboard:Destroy()
        TargetHUDBillboard = nil
    end
    if TargetHUDRotationConnection then
        TargetHUDRotationConnection:Disconnect()
        TargetHUDRotationConnection = nil
    end
    TargetHUDTarget = nil
end

local function CreateTargetHUD(targetChar)
    DestroyTargetHUD()
    if not targetChar then return end

    local root = targetChar:FindFirstChild("HumanoidRootPart")
    if not root then return end

    TargetHUDBillboard = Instance.new("BillboardGui")
    TargetHUDBillboard.Name = "TargetHUD"
    TargetHUDBillboard.Size = UDim2.new(0, 100, 0, 100)
    TargetHUDBillboard.StudsOffset = Vector3.new(0, 0, 0)
    TargetHUDBillboard.AlwaysOnTop = true
    TargetHUDBillboard.MaxDistance = 500
    TargetHUDBillboard.Parent = root

    local Container = Instance.new("Frame")
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 67, 0, 67)
    Container.BackgroundTransparency = 1
    Container.Parent = TargetHUDBillboard

    local neonColor = Color3.fromRGB(255, 255, 255)
    local innerColor = Color3.fromRGB(200, 200, 200)

    local function createCorner(xAnchor, yAnchor, isTopLeft, isTopRight, isBottomLeft, isBottomRight)
        local w, t = 20, 4
        local line1 = Instance.new("Frame")
        line1.Size = UDim2.new(0, w, 0, t)
        line1.Position = UDim2.new(xAnchor, 0, yAnchor, 0)
        line1.BackgroundColor3 = neonColor
        line1.BorderSizePixel = 0
        line1.Parent = Container

        local stroke1 = Instance.new("UIStroke")
        stroke1.Color = innerColor
        stroke1.Thickness = 3
        stroke1.Transparency = 0.3
        stroke1.Parent = line1

        local line2 = Instance.new("Frame")
        line2.Size = UDim2.new(0, t, 0, w)
        line2.Position = UDim2.new(xAnchor, 0, yAnchor, 0)
        line2.BackgroundColor3 = neonColor
        line2.BorderSizePixel = 0
        line2.Parent = Container

        local stroke2 = Instance.new("UIStroke")
        stroke2.Color = innerColor
        stroke2.Thickness = 3
        stroke2.Transparency = 0.3
        stroke2.Parent = line2

        if isTopLeft then
            line1.AnchorPoint = Vector2.new(0, 0)
            line2.AnchorPoint = Vector2.new(0, 0)
        elseif isTopRight then
            line1.AnchorPoint = Vector2.new(1, 0)
            line2.AnchorPoint = Vector2.new(1, 0)
        elseif isBottomLeft then
            line1.AnchorPoint = Vector2.new(0, 1)
            line2.AnchorPoint = Vector2.new(0, 1)
        elseif isBottomRight then
            line1.AnchorPoint = Vector2.new(1, 1)
            line2.AnchorPoint = Vector2.new(1, 1)
        end
    end

    createCorner(0, 0, true, false, false, false)
    createCorner(1, 0, false, true, false, false)
    createCorner(0, 1, false, false, true, false)
    createCorner(1, 1, false, false, false, true)

    local rotationSpeed = 120
    TargetHUDRotationConnection = RunService.RenderStepped:Connect(function(dt)
        if Container and Container.Parent then
            Container.Rotation = (Container.Rotation + rotationSpeed * dt) % 360
        end
    end)
end

local function StartTargetHUD()
    targetHUDConnection = RunService.RenderStepped:Connect(function()
        local closestEnemy = FindClosestEnemy()
        if closestEnemy then
            if TargetHUDTarget ~= closestEnemy then
                TargetHUDTarget = closestEnemy
                CreateTargetHUD(closestEnemy.Character)
            end
        else
            DestroyTargetHUD()
        end
    end)
end

local function StopTargetHUD()
    if targetHUDConnection then targetHUDConnection:Disconnect() end
    targetHUDConnection = nil
    DestroyTargetHUD()
end

CreateToggle(VisualTab, "Target HUD", 135, function(isEnabled)
    targetHUDEnabled = isEnabled
    if isEnabled then StartTargetHUD() else StopTargetHUD() end
end)

-- ================= НОВОЕ: FOV CHANGER (РАБОЧИЙ) =================
local fovEnabled = false
local fovValue = 70

CreateToggle(VisualTab, "FOV Changer", 180, function(isEnabled)
    fovEnabled = isEnabled
    if not isEnabled then
        pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
    end
end)

CreateSlider(VisualTab, "FOV Value", 225, 40, 120, 70, function(value)
    fovValue = value
end)

-- Принудительно обновляем FOV каждый кадр (работает в любых играх!)
RunService.RenderStepped:Connect(function()
    if fovEnabled and workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovValue
    end
end)
-- =========================================================

-- ================= MISC =================
-- Add Friend (0, 45, 90)
local FriendFrame = Instance.new("Frame")
FriendFrame.Size = UDim2.new(1, -20, 0, 40)
FriendFrame.Position = UDim2.new(0, 10, 0, 0)
FriendFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
FriendFrame.BorderSizePixel = 0
FriendFrame.Parent = MiscTab

local FriendCorner = Instance.new("UICorner")
FriendCorner.CornerRadius = UDim.new(0, 8)
FriendCorner.Parent = FriendFrame

local FriendLabel = Instance.new("TextLabel")
FriendLabel.Size = UDim2.new(0, 100, 1, 0)
FriendLabel.Position = UDim2.new(0, 5, 0, 0)
FriendLabel.BackgroundTransparency = 1
FriendLabel.Text = "Add Friend"
FriendLabel.Font = Enum.Font.GothamBold
FriendLabel.TextSize = 13
FriendLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendLabel.TextXAlignment = Enum.TextXAlignment.Left
FriendLabel.Parent = FriendFrame

local FriendInput = Instance.new("TextBox")
FriendInput.Size = UDim2.new(0, 280, 0, 25)
FriendInput.Position = UDim2.new(0, 105, 0.5, -12)
FriendInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FriendInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendInput.Font = Enum.Font.GothamBold
FriendInput.TextSize = 13
FriendInput.Text = ""
FriendInput.PlaceholderText = "Enter nickname..."
FriendInput.Parent = FriendFrame

local FriendInputCorner = Instance.new("UICorner")
FriendInputCorner.CornerRadius = UDim.new(0, 5)
FriendInputCorner.Parent = FriendInput

local AddButton = Instance.new("TextButton")
AddButton.Size = UDim2.new(0, 80, 0, 25)
AddButton.Position = UDim2.new(0, 390, 0.5, -12)
AddButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AddButton.Text = "Add"
AddButton.Font = Enum.Font.GothamBold
AddButton.TextSize = 13
AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AddButton.Parent = FriendFrame

local AddButtonCorner = Instance.new("UICorner")
AddButtonCorner.CornerRadius = UDim.new(0, 5)
AddButtonCorner.Parent = AddButton

local FriendListFrame = Instance.new("Frame")
FriendListFrame.Size = UDim2.new(1, -20, 0, 40)
FriendListFrame.Position = UDim2.new(0, 10, 0, 45)
FriendListFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
FriendListFrame.BorderSizePixel = 0
FriendListFrame.Parent = MiscTab

local FriendListCorner = Instance.new("UICorner")
FriendListCorner.CornerRadius = UDim.new(0, 8)
FriendListCorner.Parent = FriendListFrame

local FriendListLabel = Instance.new("TextLabel")
FriendListLabel.Size = UDim2.new(1, -10, 1, 0)
FriendListLabel.Position = UDim2.new(0, 5, 0, 0)
FriendListLabel.BackgroundTransparency = 1
FriendListLabel.Text = "Friends: None"
FriendListLabel.Font = Enum.Font.Gotham
FriendListLabel.TextSize = 12
FriendListLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FriendListLabel.TextXAlignment = Enum.TextXAlignment.Left
FriendListLabel.TextWrapped = true
FriendListLabel.Parent = FriendListFrame

local function UpdateFriendList()
    if #friendNames == 0 then
        FriendListLabel.Text = "Friends: None"
    else
        FriendListLabel.Text = "Friends: " .. table.concat(friendNames, ", ")
    end
end

AddButton.MouseButton1Click:Connect(function()
    local name = FriendInput.Text
    if name and name ~= "" then
        table.insert(friendNames, name)
        FriendInput.Text = ""
        UpdateFriendList()
    end
end)

FriendInput.FocusLost:Connect(function()
    local name = FriendInput.Text
    if name and name ~= "" then
        table.insert(friendNames, name)
        FriendInput.Text = ""
        UpdateFriendList()
    end
end)

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(1, -20, 0, 40)
ClearButton.Position = UDim2.new(0, 10, 0, 90)
ClearButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ClearButton.Text = "Clear Friends"
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextSize = 13
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.Parent = MiscTab

local ClearButtonCorner = Instance.new("UICorner")
ClearButtonCorner.CornerRadius = UDim.new(0, 8)
ClearButtonCorner.Parent = ClearButton

ClearButton.MouseButton1Click:Connect(function()
    friendNames = {}
    UpdateFriendList()
end)

-- ================= НОВОЕ: ANTI AFK (РАБОЧИЙ) =================
local antiAFKEnabled = false

task.spawn(function()
    while true do
        task.wait(10) -- Проверяем каждые 10 секунд
        if antiAFKEnabled then
            pcall(function()
                -- Имитируем активность мыши (классический обход анти-афк)
                VirtualUser:CaptureController()
                VirtualUser:ButtonDown(Vector2.new(0, 0), workspace.CurrentCamera)
                task.wait(0.1)
                VirtualUser:ButtonUp(Vector2.new(0, 0), workspace.CurrentCamera)
            end)
        end
    end
end)

CreateToggle(MiscTab, "Anti AFK", 135, function(isEnabled)
    antiAFKEnabled = isEnabled
end)
-- =========================================================

-- Avatar Frame
local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 60, 0, 60)
AvatarFrame.Position = UDim2.new(0, 10, 1, -70)
AvatarFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AvatarFrame.BackgroundTransparency = 0.3
AvatarFrame.BorderSizePixel = 0
AvatarFrame.Parent = MainFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -10, 1, -10)
AvatarImage.Position = UDim2.new(0, 5, 0, 5)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Parent = AvatarFrame

local AvatarImageCorner = Instance.new("UICorner")
AvatarImageCorner.CornerRadius = UDim.new(1, 0)
AvatarImageCorner.Parent = AvatarImage

local userId = Player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size100x100
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
AvatarImage.Image = content

-- Show first tab
CombatTab.Visible = true

-- Функция полного отключения
local function UnloadCheat()
    aimAssistEnabled = false
    espEnabled = false
    targetESPEnabled = false
    targetHUDEnabled = false
    fovEnabled = false
    antiAFKEnabled = false

    pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)

    if targetESPConnection then targetESPConnection:Disconnect() end
    if targetHUDConnection then targetHUDConnection:Disconnect() end
    if TargetHUDRotationConnection then TargetHUDRotationConnection:Disconnect() end

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local h = player.Character:FindFirstChild("ESP_Highlight")
            if h then h:Destroy() end
        end
    end

    pcall(function()
        ResetWorldColor()
    end)

    if TargetPanel then TargetPanel:Destroy() end
    ScreenGui:Destroy()
    TargetScreenGui:Destroy()
end

CloseButton.MouseButton1Click:Connect(function()
    UnloadCheat()
end)
CloseButton.MouseButton1Down:Connect(function()
    UnloadCheat()
end)

-- Toggle GUI on Delete key
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

print("Artnes GUI loaded! Fullbright removed, FOV and Anti AFK fixed!")
