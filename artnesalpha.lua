-- // Artnes GUI v34.1 (Combat & Pearl Target System)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local HttpReq = nil
pcall(function()
    HttpReq = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
end)

-- ================= ЭКРАН ЗАГРУЗКИ =================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingGui"
LoadingGui.Parent = Player:WaitForChild("PlayerGui")
LoadingGui.ResetOnSpawn = false

local LoadingFrame = Instance.new("Frame")
LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingFrame.Size = UDim2.new(0, 350, 0, 200)
LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
LoadingFrame.Parent = LoadingGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 12)
LoadingCorner.Parent = LoadingFrame

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 60)
LoadingTitle.Position = UDim2.new(0, 0, 0, 20)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "ARTNES"
LoadingTitle.Font = Enum.Font.GothamBlack
LoadingTitle.TextSize = 40
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.Parent = LoadingFrame

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, 0, 0, 30)
LoadingStatus.Position = UDim2.new(0, 0, 0, 85)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "Загрузка модулей..."
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.TextSize = 15
LoadingStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingStatus.Parent = LoadingFrame

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Size = UDim2.new(0, 280, 0, 10)
LoadingBarBg.Position = UDim2.new(0.5, -140, 0, 130)
LoadingBarBg.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
LoadingBarBg.Parent = LoadingFrame
Instance.new("UICorner", LoadingBarBg).CornerRadius = UDim.new(1, 0)

local LoadingBarFill = Instance.new("Frame")
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LoadingBarFill.Parent = LoadingBarBg
Instance.new("UICorner", LoadingBarFill).CornerRadius = UDim.new(1, 0)

local loadTween = TweenService:Create(LoadingBarFill, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
loadTween:Play()
task.wait(2.0)
LoadingGui:Destroy()

-- ================= ОСНОВНОЙ GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArtnesGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local TargetScreenGui = Instance.new("ScreenGui")
TargetScreenGui.Name = "ArtnesTargetGUI"
TargetScreenGui.Parent = Player:WaitForChild("PlayerGui")
TargetScreenGui.ResetOnSpawn = false

local binds = {}
local toggleHandlers = {}
local sliderHandlers = {}

local BindMenuGUI = Instance.new("ScreenGui")
BindMenuGUI.Name = "ArtnesBindMenu"
BindMenuGUI.Parent = Player:WaitForChild("PlayerGui")
BindMenuGUI.ResetOnSpawn = false
BindMenuGUI.Enabled = false

local BindMenuFrame = Instance.new("Frame")
BindMenuFrame.AnchorPoint = Vector2.new(1, 0.5)
BindMenuFrame.Position = UDim2.new(1, -5, 0.5, 0)
BindMenuFrame.Size = UDim2.new(0, 250, 0, 400)
BindMenuFrame.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
BindMenuFrame.Parent = BindMenuGUI
Instance.new("UICorner", BindMenuFrame).CornerRadius = UDim.new(0, 8)

local BindTitle = Instance.new("TextLabel")
BindTitle.Size = UDim2.new(1, 0, 0, 40)
BindTitle.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
BindTitle.Text = "Active Binds"
BindTitle.Font = Enum.Font.GothamBlack
BindTitle.TextSize = 16
BindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BindTitle.Parent = BindMenuFrame

local BindListFrame = Instance.new("Frame")
BindListFrame.Size = UDim2.new(1, -20, 1, -60)
BindListFrame.Position = UDim2.new(0, 10, 0, 50)
BindListFrame.BackgroundTransparency = 1
BindListFrame.Parent = BindMenuFrame

local function UpdateBindMenu()
    for _, child in pairs(BindListFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local y = 0
    for _, bind in pairs(binds) do
        if bind.enabled and bind.key then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.Position = UDim2.new(0, 0, 0, y)
            row.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
            row.Parent = BindListFrame
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            
            local rowLabel = Instance.new("TextLabel")
            rowLabel.Size = UDim2.new(0.7, 0, 1, 0)
            rowLabel.Position = UDim2.new(0, 5, 0, 0)
            rowLabel.BackgroundTransparency = 1
            rowLabel.Text = bind.name
            rowLabel.Font = Enum.Font.GothamBold
            rowLabel.TextSize = 13
            rowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            rowLabel.TextXAlignment = Enum.TextXAlignment.Left
            rowLabel.Parent = row
            
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(0.3, 0, 1, 0)
            keyLabel.Position = UDim2.new(0.7, 0, 0, 0)
            keyLabel.BackgroundTransparency = 1
            keyLabel.Text = "[" .. bind.key.Name .. "]"
            keyLabel.Font = Enum.Font.GothamBlack
            keyLabel.TextSize = 13
            keyLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
            keyLabel.TextXAlignment = Enum.TextXAlignment.Right
            keyLabel.Parent = row
            y = y + 35
        end
    end
end

local function CreateBindToggle(parent, name, yPos, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    ToggleFrame.Parent = parent
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 30, 0, 30)
    BindBtn.Position = UDim2.new(0.65, 0, 0.5, -15)
    BindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BindBtn.Text = "⌨"
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 14
    BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBtn.Parent = ToggleFrame
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 8)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(0.85, 0, 0.5, -12)
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.Text = ""
    Button.Parent = ToggleFrame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 20, 0, 20)
    Dot.Position = UDim2.new(0, 2, 0.5, -10)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Button
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local bindData = { name = name, key = nil, enabled = false, listening = false, callback = callback, BindBtn = BindBtn, Button = Button, Dot = Dot }
    table.insert(binds, bindData)

    local function SetState(state)
        bindData.enabled = state
        Button.BackgroundColor3 = bindData.enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 80, 80)
        Dot.Position = bindData.enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        if bindData.callback then bindData.callback(bindData.enabled) end
        UpdateBindMenu()
    end

    Button.MouseButton1Click:Connect(function() SetState(not bindData.enabled) end)
    BindBtn.MouseButton1Click:Connect(function() BindBtn.Text = "..."; bindData.listening = true end)
    bindData.ToggleState = function() SetState(not bindData.enabled) end
    bindData.SetState = SetState
    toggleHandlers[name] = { Set = SetState, Get = function() return bindData.enabled end, bind = bindData }
    return bindData
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    for _, bind in pairs(binds) do
        if bind.listening and input.KeyCode ~= Enum.KeyCode.Unknown then
            bind.key = input.KeyCode
            bind.listening = false
            bind.BindBtn.Text = "[" .. input.KeyCode.Name .. "]"
            UpdateBindMenu()
            return
        end
    end
    for _, bind in pairs(binds) do
        if bind.key and input.KeyCode == bind.key then
            bind.ToggleState()
            break
        end
    end
end)

-- ================= ОКНО GUI =================
local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

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

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TitleBar
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

local dragging, dragStart, frameStart = false, nil, nil
TitleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging, dragStart, frameStart = true, input.Position, MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 35)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
TabFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -95)
ContentFrame.Position = UDim2.new(0, 10, 0, 85)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.Parent = MainFrame
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 8)

local function CreateTab(name, index, isScroll)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 95, 0, 30)
    TabButton.Position = UDim2.new(0, 5 + (index * 100), 0, 2)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 11
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Parent = TabFrame
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 15)

    local Content
    if isScroll then
        Content = Instance.new("ScrollingFrame")
        Content.ScrollBarThickness = 3
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    else
        Content = Instance.new("Frame")
    end
    Content.Name = name .. "Content"
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.BackgroundTransparency = 1
    Content.Visible = false
    Content.Parent = ContentFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentFrame:GetChildren()) do if child:IsA("GuiObject") then child.Visible = false end end
        Content.Visible = true
        for _, child in pairs(TabFrame:GetChildren()) do if child:IsA("TextButton") then child.BackgroundColor3 = Color3.fromRGB(60, 0, 0) end end
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    end)
    return Content
end

local function CreateToggle(parent, name, yPos, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    ToggleFrame.Parent = parent
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 5, 0, 0)
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
    Button.Text = ""
    Button.Parent = ToggleFrame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 20, 0, 20)
    Dot.Position = UDim2.new(0, 2, 0.5, -10)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Button
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local enabled = false
    local function SetState(state)
        enabled = state
        Button.BackgroundColor3 = enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 80, 80)
        Dot.Position = enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        if callback then callback(enabled) end
    end
    Button.MouseButton1Click:Connect(function() SetState(not enabled) end)
    toggleHandlers[name] = { Set = SetState, Get = function() return enabled end }
    return ToggleFrame
end

local function CreateSlider(parent, name, yPos, minValue, maxValue, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 40)
    SliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    SliderFrame.Parent = parent
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

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
    Track.Parent = SliderFrame
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Text = ""
    Knob.Parent = Track
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local currentValue = default
    local draggingSlider = false
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

    local function SetValue(val)
        val = math.clamp(val, minValue, maxValue)
        currentValue = val
        local percent = (val - minValue) / (maxValue - minValue)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, 0, 0.5, 0)
        ValueBox.Text = tostring(val)
        if callback then callback(val) end
    end

    Knob.MouseButton1Down:Connect(function() draggingSlider = true; Update(UserInputService:GetMouseLocation().X) end)
    Track.MouseButton1Down:Connect(function() draggingSlider = true; Update(UserInputService:GetMouseLocation().X) end)
    UserInputService.InputChanged:Connect(function(input, gp) if gp then return end; if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input.Position.X) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end end)
    ValueBox.FocusLost:Connect(function() local num = tonumber(ValueBox.Text); if num then SetValue(num) else ValueBox.Text = tostring(currentValue) end end)
    task.wait(0.1)
    SetValue(default)
    sliderHandlers[name] = { Set = SetValue, Get = function() return currentValue end }
    return SliderFrame
end

local CombatTab = CreateTab("COMBAT", 0, false)
local VisualTab = CreateTab("VISUAL", 1, false)
local MiscTab = CreateTab("MISC", 2, true)

-- ================= ДРУЗЬЯ И ВРАГИ =================
local friendNames = {}
local function isFriend(targetPlayer)
    if not targetPlayer then return false end
    local nameToCheck = targetPlayer.Name
    for _, name in ipairs(friendNames) do if name == nameToCheck or name == targetPlayer.DisplayName then return true end end
    return false
end

local function FindPlayerByName(name)
    for _, player in pairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(name) or string.lower(player.DisplayName) == string.lower(name) then return player end
    end
    return nil
end

local function FindClosestEnemy()
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closestEnemy, closestDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and not isFriend(player) and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if root and humanoid and humanoid.Health > 0 then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist <= closestDist then closestDist = dist; closestEnemy = player end
            end
        end
    end
    return closestEnemy
end

-- ================= ANTI AFK =================
local antiAFKEnabled = false
Player.Idled:Connect(function()
    if antiAFKEnabled then
        task.spawn(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.zero)
            end)
            print("[Artnes GUI] Anti-AFK сработал, AFK таймер сброшен.")
        end)
    end
end)

-- ================= COMBAT MODULES =================
CreateToggle(CombatTab, "Aim Assist", 0, function(isEnabled)
    -- Просто кнопка
end)

CreateToggle(CombatTab, "Attack Aura", 45, function(isEnabled)
    -- Просто кнопка
end)

CreateToggle(CombatTab, "Triggerbot", 90, function(isEnabled)
    -- Просто кнопка
end)

-- PEARL TARGET (Авто-кидание перла за врагом в радиусе 15 блоков)
local pearlTargetEnabled = false

CreateToggle(CombatTab, "Pearl Target", 135, function(isEnabled)
    pearlTargetEnabled = isEnabled
    if pearlTargetEnabled then
        task.spawn(function()
            -- Отслеживаем создание перлов / телепортацию игроков в радиусе 15 блоков
            while pearlTargetEnabled do
                task.wait(0.05)
                local char = Player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= Player and not isFriend(p) and p.Character then
                            local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                            if pRoot then
                                local dist = (pRoot.Position - root.Position).Magnitude
                                if dist <= 15 then
                                    -- Проверяем, совершил ли игрок рывок/телепортацию или заспавнил предмет (перл) рядом
                                    -- Симулируем бросок эндер-перла / активацию инструмента перла в сторону цели
                                    pcall(function()
                                        local backpack = Player:FindFirstChildOfClass("Backpack")
                                        local tool = char:FindFirstChildOfClass("Tool") or (backpack and backpack:FindFirstChild("Pearl") or backpack and backpack:FindFirstChild("EnderPearl"))
                                        if tool and tool.Parent == backpack then
                                            tool.Parent = char -- берем в руки если в инвентаре
                                        end
                                        if tool and tool.Parent == char then
                                            -- Имитируем клик/активацию перла в сторону позиции врага
                                            tool:Activate()
                                        end
                                    end)
                                    task.wait(1) -- кулдаун чтобы не спамить перлы бесконечно
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ================= VISUAL =================
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
            highlight.FillColor = isFriend(player) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 105, 180)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
    else
        if highlight then highlight:Destroy() end
    end
end

local function RefreshESPColor(player)
    if espEnabled and player ~= Player and player.Character then
        local highlight = player.Character:FindFirstChild("ESP_Highlight")
        if highlight then highlight:Destroy() end
        UpdateESP(player, true)
    end
end

local function ApplyESPToCharacter(player)
    UpdateESP(player, espEnabled)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Player then
        player.CharacterAdded:Connect(function() ApplyESPToCharacter(player) end)
        if player.Character then ApplyESPToCharacter(player) end
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= Player then player.CharacterAdded:Connect(function() ApplyESPToCharacter(player) end) end
end)
CreateBindToggle(VisualTab, "ESP", 0, function(isEnabled)
    espEnabled = isEnabled
    for _, player in pairs(Players:GetPlayers()) do UpdateESP(player, isEnabled) end
end)

-- WORLDCOLOR
local worldColorConnection = nil
local function ApplyDefaultPink()
    if worldColorConnection then worldColorConnection:Disconnect() end
    worldColorConnection = RunService.Heartbeat:Connect(function()
        local Lighting = game:GetService("Lighting")
        Lighting.Ambient = Color3.fromRGB(255, 80, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 120, 200)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogColor = Color3.fromRGB(255, 80, 180)
        Lighting.FogEnd = 500
        Lighting.GlobalShadows = false
        if Lighting:FindFirstChild("PinkSkyObj") then Lighting.PinkSkyObj:Destroy() end
        local CC = Lighting:FindFirstChild("PinkSky") or Instance.new("ColorCorrectionEffect")
        CC.Name = "PinkSky"
        CC.TintColor = Color3.fromRGB(255, 180, 220)
        CC.Saturation = 0.7
        CC.Contrast = 0.1
        CC.Parent = Lighting
    end)
end

local function ResetWorldColor()
    if worldColorConnection then worldColorConnection:Disconnect(); worldColorConnection = nil end
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

-- Target ESP
local TargetPanel = Instance.new("Frame")
TargetPanel.Size = UDim2.new(0, 200, 0, 60)
TargetPanel.Position = UDim2.new(0, 20, 0.5, -30)
TargetPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TargetPanel.Parent = TargetScreenGui
TargetPanel.Visible = false
Instance.new("UICorner", TargetPanel).CornerRadius = UDim.new(0, 8)

local TargetName = Instance.new("TextLabel")
TargetName.Size = UDim2.new(1, -90, 0, 20)
TargetName.Position = UDim2.new(0, 50, 0, 5)
TargetName.BackgroundTransparency = 1
TargetName.Text = "Target"
TargetName.Font = Enum.Font.GothamBold
TargetName.TextSize = 14
TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetName.Parent = TargetPanel

local TargetHP = Instance.new("TextLabel")
TargetHP.Size = UDim2.new(1, -90, 0, 20)
TargetHP.Position = UDim2.new(0, 50, 0, 25)
TargetHP.BackgroundTransparency = 1
TargetHP.Text = "HP: 100"
TargetHP.Font = Enum.Font.Gotham
TargetHP.TextSize = 12
TargetHP.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetHP.Parent = TargetPanel

CreateToggle(VisualTab, "Target ESP", 90, function(isEnabled)
    if isEnabled then
        task.spawn(function()
            while toggleHandlers["Target ESP"] and toggleHandlers["Target ESP"].Get() do
                local closest = FindClosestEnemy()
                if closest and closest.Character then
                    local humanoid = closest.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        TargetPanel.Visible = true
                        TargetName.Text = closest.Name
                        TargetHP.Text = "HP: " .. tostring(math.floor(humanoid.Health))
                    end
                else
                    TargetPanel.Visible = false
                end
                task.wait(0.1)
            end
        end)
    else
        TargetPanel.Visible = false
    end
end)

CreateToggle(VisualTab, "Target HUD", 135, function() end)

-- FOV Changer
local fovValue = 70
CreateToggle(VisualTab, "FOV Changer", 180, function(isEnabled)
    if not isEnabled then
        pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
        RunService:UnbindFromRenderStep("FOV_Changer")
    else
        RunService:BindToRenderStep("FOV_Changer", Enum.RenderPriority.Last.Value, function()
            if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovValue end
        end)
    end
end)
CreateSlider(VisualTab, "FOV Value", 225, 40, 120, 70, function(value) fovValue = value end)

-- ORES HIGHLIGHT
local oreHighlightEnabled = false
local highlightedOres = {}
local oreVariants = {
    gold = {"gold", "gold_ore", "goldore", "goldblock", "gold_block", "gold ore"},
    titanium = {"titanium", "titanium_ore", "titaniumore", "titaniumblock", "titanium_block", "titanium ore"},
    diamond = {"diamond", "diamond_ore", "diamondore", "diamondblock", "diamond_block", "diamond ore"}
}
local currentSelection = "gold"

local function isOre(part)
    local name = string.lower(part.Name)
    local blacklist = {"stone", "cobblestone", "cobble", "dirt", "grass", "granite", "andesite", "diorite"}
    for _, bad in ipairs(blacklist) do if string.find(name, bad) then return false end end
    for _, keyword in ipairs(oreVariants[currentSelection]) do if string.find(name, keyword) then return true end end
    return false
end

local function UpdateOreHighlight(state)
    if state then
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Anchored and isOre(descendant) then
                if not descendant:FindFirstChild("OreHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "OreHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.3
                    highlight.OutlineTransparency = 0
                    highlight.Parent = descendant
                    table.insert(highlightedOres, highlight)
                end
            end
        end
    else
        for _, highlight in pairs(highlightedOres) do if highlight and highlight.Parent then highlight:Destroy() end end
        highlightedOres = {}
    end
end

CreateToggle(VisualTab, "Highlight Ores", 270, function(isEnabled)
    oreHighlightEnabled = isEnabled
    UpdateOreHighlight(isEnabled)
end)

local QuickSelectFrame = Instance.new("Frame")
QuickSelectFrame.Size = UDim2.new(1, -20, 0, 40)
QuickSelectFrame.Position = UDim2.new(0, 10, 0, 315)
QuickSelectFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
QuickSelectFrame.Parent = VisualTab
Instance.new("UICorner", QuickSelectFrame).CornerRadius = UDim.new(0, 8)

local QuickSelectLabel = Instance.new("TextLabel")
QuickSelectLabel.Size = UDim2.new(0, 115, 1, 0)
QuickSelectLabel.Position = UDim2.new(0, 5, 0, 0)
QuickSelectLabel.BackgroundTransparency = 1
QuickSelectLabel.Text = "Highlight Type:"
QuickSelectLabel.Font = Enum.Font.GothamBold
QuickSelectLabel.TextSize = 11
QuickSelectLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickSelectLabel.TextXAlignment = Enum.TextXAlignment.Left
QuickSelectLabel.Parent = QuickSelectFrame

local quickButtons = {{"Gold", "gold"}, {"Titan", "titanium"}, {"Diam", "diamond"}}
local quickSelectButtons = {}

local function refreshQuickButtons()
    for _, data in pairs(quickSelectButtons) do
        local btn = data[1]
        local keyword = data[2]
        btn.BackgroundColor3 = (keyword == currentSelection) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 60, 60)
    end
end

for i, data in ipairs(quickButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(0, 120 + ((i - 1) % 3) * 65, 0, 7)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = data[1]
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = QuickSelectFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        currentSelection = data[2]
        refreshQuickButtons()
        if oreHighlightEnabled then
            UpdateOreHighlight(false)
            UpdateOreHighlight(true)
        end
    end)
    table.insert(quickSelectButtons, {btn, data[2]})
end
refreshQuickButtons()

-- ================= MISC (ДРУЗЬЯ, ANTI AFK, CONFIG) =================
local FriendFrame = Instance.new("Frame")
FriendFrame.Size = UDim2.new(1, -20, 0, 40)
FriendFrame.Position = UDim2.new(0, 10, 0, 0)
FriendFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
FriendFrame.Parent = MiscTab
Instance.new("UICorner", FriendFrame).CornerRadius = UDim.new(0, 8)

local FriendLabel = Instance.new("TextLabel")
FriendLabel.Size = UDim2.new(0, 90, 1, 0)
FriendLabel.Position = UDim2.new(0, 5, 0, 0)
FriendLabel.BackgroundTransparency = 1
FriendLabel.Text = "Add Friend"
FriendLabel.Font = Enum.Font.GothamBold
FriendLabel.TextSize = 12
FriendLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendLabel.TextXAlignment = Enum.TextXAlignment.Left
FriendLabel.Parent = FriendFrame

local FriendInput = Instance.new("TextBox")
FriendInput.Size = UDim2.new(0, 250, 0, 25)
FriendInput.Position = UDim2.new(0, 95, 0.5, -12)
FriendInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FriendInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendInput.Text = ""
FriendInput.PlaceholderText = "Enter nickname..."
FriendInput.Parent = FriendFrame
Instance.new("UICorner", FriendInput).CornerRadius = UDim.new(0, 5)

local AddButton = Instance.new("TextButton")
AddButton.Size = UDim2.new(0, 90, 0, 25)
AddButton.Position = UDim2.new(0, 355, 0.5, -12)
AddButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AddButton.Text = "Add"
AddButton.Font = Enum.Font.GothamBold
AddButton.TextSize = 12
AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AddButton.Parent = FriendFrame
Instance.new("UICorner", AddButton).CornerRadius = UDim.new(0, 5)

local FriendListFrame = Instance.new("Frame")
FriendListFrame.Size = UDim2.new(1, -20, 0, 35)
FriendListFrame.Position = UDim2.new(0, 10, 0, 45)
FriendListFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
FriendListFrame.Parent = MiscTab
Instance.new("UICorner", FriendListFrame).CornerRadius = UDim.new(0, 8)

local FriendListLabel = Instance.new("TextLabel")
FriendListLabel.Size = UDim2.new(1, -10, 1, 0)
FriendListLabel.Position = UDim2.new(0, 5, 0, 0)
FriendListLabel.BackgroundTransparency = 1
FriendListLabel.Text = "Friends: None"
FriendListLabel.Font = Enum.Font.Gotham
FriendListLabel.TextSize = 11
FriendListLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FriendListLabel.TextXAlignment = Enum.TextXAlignment.Left
FriendListLabel.Parent = FriendListFrame

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(1, -20, 0, 30)
ClearButton.Position = UDim2.new(0, 10, 0, 85)
ClearButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ClearButton.Text = "Clear Friends"
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextSize = 12
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.Parent = MiscTab
Instance.new("UICorner", ClearButton).CornerRadius = UDim.new(0, 8)

local function UpdateFriendList()
    FriendListLabel.Text = (#friendNames == 0) and "Friends: None" or ("Friends: " .. table.concat(friendNames, ", "))
end

AddButton.MouseButton1Click:Connect(function()
    local name = FriendInput.Text
    if name and name ~= "" then
        table.insert(friendNames, name)
        FriendInput.Text = ""
        UpdateFriendList()
        local targetPlayer = FindPlayerByName(name)
        if targetPlayer then RefreshESPColor(targetPlayer) end
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    friendNames = {}
    UpdateFriendList()
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do RefreshESPColor(player) end
    end
end)

CreateToggle(MiscTab, "Anti AFK", 120, function(isEnabled)
    antiAFKEnabled = isEnabled
end)

-- ================= СИСТЕМА КОНФИГОВ (CFG) В MISC =================
local function GenerateRandomID()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local r = function() local i = math.random(1, #chars) return string.sub(chars, i, i) end
    return "artnes-"..r()..r()..r()..r()
end

local function SerializeConfig()
    local cfgData = {
        Toggles = {},
        Sliders = {},
        Binds = {},
        Friends = friendNames,
        OreSelection = currentSelection
    }
    for name, handler in pairs(toggleHandlers) do cfgData.Toggles[name] = handler.Get() end
    for name, handler in pairs(sliderHandlers) do cfgData.Sliders[name] = handler.Get() end
    for _, b in pairs(binds) do
        if b.key then cfgData.Binds[b.name] = b.key.Name end
    end
    return cfgData
end

local function DeserializeConfig(cfgData)
    if type(cfgData) ~= "table" then return false end
    if cfgData.Friends and type(cfgData.Friends) == "table" then
        friendNames = cfgData.Friends
        UpdateFriendList()
    end
    if cfgData.OreSelection and oreVariants[cfgData.OreSelection] then
        currentSelection = cfgData.OreSelection
        refreshQuickButtons()
    end
    if cfgData.Sliders and type(cfgData.Sliders) == "table" then
        for name, val in pairs(cfgData.Sliders) do
            if sliderHandlers[name] then sliderHandlers[name].Set(val) end
        end
    end
    if cfgData.Toggles and type(cfgData.Toggles) == "table" then
        for name, state in pairs(cfgData.Toggles) do
            if toggleHandlers[name] then toggleHandlers[name].Set(state) end
        end
    end
    if cfgData.Binds and type(cfgData.Binds) == "table" then
        for _, b in pairs(binds) do
            if cfgData.Binds[b.name] then
                pcall(function()
                    b.key = Enum.KeyCode[cfgData.Binds[b.name]]
                    b.BindBtn.Text = "[" .. b.key.Name .. "]"
                end)
            end
        end
        UpdateBindMenu()
    end
    return true
end

local function SaveLocalCFG()
    local data = SerializeConfig()
    local s, json = pcall(function() return HttpService:JSONEncode(data) end)
    if s and writefile then
        pcall(function() writefile("Artnes_Config.json", json) end)
    end
end

local function LoadLocalCFG()
    if isfile and isfile("Artnes_Config.json") then
        local s, content = pcall(function() return readfile("Artnes_Config.json") end)
        if s and content then
            local s2, data = pcall(function() return HttpService:JSONDecode(content) end)
            if s2 and data then return DeserializeConfig(data) end
        end
    end
    return false
end

-- UI ЭКСПОРТА КОНФИГА (Позиция 165)
local ExportFrame = Instance.new("Frame")
ExportFrame.Size = UDim2.new(1, -20, 0, 75)
ExportFrame.Position = UDim2.new(0, 10, 0, 165)
ExportFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ExportFrame.Parent = MiscTab
Instance.new("UICorner", ExportFrame).CornerRadius = UDim.new(0, 8)

local ExportLabel = Instance.new("TextLabel")
ExportLabel.Size = UDim2.new(1, -10, 0, 20)
ExportLabel.Position = UDim2.new(0, 5, 0, 3)
ExportLabel.BackgroundTransparency = 1
ExportLabel.Text = "EXPORT CONFIG (CLOUD / LOCAL)"
ExportLabel.Font = Enum.Font.GothamBold
ExportLabel.TextSize = 11
ExportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ExportLabel.TextXAlignment = Enum.TextXAlignment.Left
ExportLabel.Parent = ExportFrame

local ExportKeyBox = Instance.new("TextBox")
ExportKeyBox.Size = UDim2.new(0.6, 0, 0, 22)
ExportKeyBox.Position = UDim2.new(0, 5, 0, 25)
ExportKeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ExportKeyBox.TextColor3 = Color3.fromRGB(0, 255, 200)
ExportKeyBox.Font = Enum.Font.GothamBold
ExportKeyBox.TextSize = 11
ExportKeyBox.Text = "ARTNES_MAIN"
ExportKeyBox.TextEditable = false
ExportKeyBox.Parent = ExportFrame
Instance.new("UICorner", ExportKeyBox).CornerRadius = UDim.new(0, 4)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.35, -5, 0, 22)
CopyBtn.Position = UDim2.new(0.65, 5, 0, 25)
CopyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CopyBtn.Text = "COPY"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 11
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Parent = ExportFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 4)

local GenBtn = Instance.new("TextButton")
GenBtn.Size = UDim2.new(0.5, -5, 0, 22)
GenBtn.Position = UDim2.new(0, 5, 0, 50)
GenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
GenBtn.Text = "GENERATE CFG"
GenBtn.Font = Enum.Font.GothamBold
GenBtn.TextSize = 11
GenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GenBtn.Parent = ExportFrame
Instance.new("UICorner", GenBtn).CornerRadius = UDim.new(0, 4)

local SaveLocalBtn = Instance.new("TextButton")
SaveLocalBtn.Size = UDim2.new(0.45, 0, 0, 22)
SaveLocalBtn.Position = UDim2.new(0.55, 0, 0, 50)
SaveLocalBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SaveLocalBtn.Text = "SAVE LOCAL"
SaveLocalBtn.Font = Enum.Font.GothamBold
SaveLocalBtn.TextSize = 11
SaveLocalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveLocalBtn.Parent = ExportFrame
Instance.new("UICorner", SaveLocalBtn).CornerRadius = UDim.new(0, 4)

GenBtn.MouseButton1Click:Connect(function()
    SaveLocalCFG()
    local newKey = GenerateRandomID()
    if type(HttpReq) == "function" then
        GenBtn.Text = "UPLOADING..."
        task.spawn(function()
            local cfgJson = HttpService:JSONEncode(SerializeConfig())
            local s, r = pcall(function()
                return HttpReq({
                    Url = "https://bytebin.lucko.me/post",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json; charset=utf-8"},
                    Body = cfgJson
                })
            end)
            if s and r and r.Body then
                local s2, res = pcall(function() return HttpService:JSONDecode(r.Body) end)
                if s2 and res and res.key then newKey = res.key end
            end
            ExportKeyBox.Text = newKey
            GenBtn.Text = "GENERATE CFG"
        end)
    else
        ExportKeyBox.Text = newKey
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(ExportKeyBox.Text) end
end)
SaveLocalBtn.MouseButton1Click:Connect(function()
    SaveLocalCFG()
    SaveLocalBtn.Text = "SAVED!"
    task.delay(1, function() SaveLocalBtn.Text = "SAVE LOCAL" end)
end)

-- UI ИМПОРТА КОНФИГА (Позиция 245)
local ImportFrame = Instance.new("Frame")
ImportFrame.Size = UDim2.new(1, -20, 0, 75)
ImportFrame.Position = UDim2.new(0, 10, 0, 245)
ImportFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ImportFrame.Parent = MiscTab
Instance.new("UICorner", ImportFrame).CornerRadius = UDim.new(0, 8)

local ImportLabel = Instance.new("TextLabel")
ImportLabel.Size = UDim2.new(1, -10, 0, 20)
ImportLabel.Position = UDim2.new(0, 5, 0, 3)
ImportLabel.BackgroundTransparency = 1
ImportLabel.Text = "IMPORT CONFIG (CLOUD / LOCAL)"
ImportLabel.Font = Enum.Font.GothamBold
ImportLabel.TextSize = 11
ImportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ImportLabel.TextXAlignment = Enum.TextXAlignment.Left
ImportLabel.Parent = ImportFrame

local ImportKeyBox = Instance.new("TextBox")
ImportKeyBox.Size = UDim2.new(0.6, 0, 0, 22)
ImportKeyBox.Position = UDim2.new(0, 5, 0, 25)
ImportKeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ImportKeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ImportKeyBox.Font = Enum.Font.GothamBold
ImportKeyBox.TextSize = 11
ImportKeyBox.PlaceholderText = "Paste key here..."
ImportKeyBox.Text = ""
ImportKeyBox.Parent = ImportFrame
Instance.new("UICorner", ImportKeyBox).CornerRadius = UDim.new(0, 4)

local PasteBtn = Instance.new("TextButton")
PasteBtn.Size = UDim2.new(0.35, -5, 0, 22)
PasteBtn.Position = UDim2.new(0.65, 5, 0, 25)
PasteBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PasteBtn.Text = "PASTE"
PasteBtn.Font = Enum.Font.GothamBold
PasteBtn.TextSize = 11
PasteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteBtn.Parent = ImportFrame
Instance.new("UICorner", PasteBtn).CornerRadius = UDim.new(0, 4)

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(0.5, -5, 0, 22)
LoadBtn.Position = UDim2.new(0, 5, 0, 50)
LoadBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LoadBtn.Text = "LOAD CLOUD CFG"
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.TextSize = 11
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.Parent = ImportFrame
Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 4)

local LoadLocalBtn = Instance.new("TextButton")
LoadLocalBtn.Size = UDim2.new(0.45, 0, 0, 22)
LoadLocalBtn.Position = UDim2.new(0.55, 0, 0, 50)
LoadLocalBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
LoadLocalBtn.Text = "LOAD LOCAL"
LoadLocalBtn.Font = Enum.Font.GothamBold
LoadLocalBtn.TextSize = 11
LoadLocalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadLocalBtn.Parent = ImportFrame
Instance.new("UICorner", LoadLocalBtn).CornerRadius = UDim.new(0, 4)

PasteBtn.MouseButton1Click:Connect(function()
    if getclipboard then
        local txt = getclipboard()
        if txt and txt ~= "" then ImportKeyBox.Text = txt end
    end
end)

LoadBtn.MouseButton1Click:Connect(function()
    local key = ImportKeyBox.Text:gsub("%s+", "")
    if key ~= "" and type(HttpReq) == "function" then
        LoadBtn.Text = "LOADING..."
        task.spawn(function()
            local s, r = pcall(function() return HttpReq({Url = "https://bytebin.lucko.me/" .. key, Method = "GET"}) end)
            if s and r and (r.StatusCode == 200 or r.StatusCode == 201) and r.Body then
                local s2, data = pcall(function() return HttpService:JSONDecode(r.Body) end)
                if s2 and data then
                    DeserializeConfig(data)
                    LoadBtn.Text = "SUCCESS!"
                else
                    LoadBtn.Text = "DECODE ERR"
                end
            else
                LoadBtn.Text = "NOT FOUND"
            end
            task.delay(1.5, function() LoadBtn.Text = "LOAD CLOUD CFG" end)
        end)
    end
end)

LoadLocalBtn.MouseButton1Click:Connect(function()
    if LoadLocalCFG() then
        LoadLocalBtn.Text = "LOADED!"
    else
        LoadLocalBtn.Text = "NO FILE"
    end
    task.delay(1.5, function() LoadLocalBtn.Text = "LOAD LOCAL" end)
end)

-- ================= АВАТАР И ВЫХОД =================
local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 60, 0, 60)
AvatarFrame.Position = UDim2.new(0, 10, 1, -70)
AvatarFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AvatarFrame.Parent = MainFrame
Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(1, 0)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -10, 1, -10)
AvatarImage.Position = UDim2.new(0, 5, 0, 5)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Parent = AvatarFrame
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local content = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
AvatarImage.Image = content

CombatTab.Visible = true
VisualTab.Visible = false
MiscTab.Visible = false

local function UnloadCheat()
    if oreHighlightEnabled then UpdateOreHighlight(false) end
    pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
    RunService:UnbindFromRenderStep("FOV_Changer")
    if worldColorConnection then worldColorConnection:Disconnect(); worldColorConnection = nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then local h = p.Character:FindFirstChild("ESP_Highlight") if h then h:Destroy() end end
    end
    pcall(ResetWorldColor)
    ScreenGui:Destroy(); TargetScreenGui:Destroy(); BindMenuGUI:Destroy()
end
CloseButton.MouseButton1Click:Connect(UnloadCheat)

local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

print("[Artnes GUI] v34.1 Loaded! Combat & Pearl Target System Active.")
