-- =====================================================
--  AW-SCRIPT (Teleport к финишу в Ink Game)
--  Вкладка Game: кнопка Teleport to finish
-- =====================================================

repeat wait() until game:IsLoaded()
wait(0.5)

local player = game:GetService("Players").LocalPlayer
if not player then warn("Игрок не найден") return end

local TweenService = game:GetService("TweenService")

-- ============================================================
--  ЗАГРУЗКА ЛОГОТИПА (без изменений)
-- ============================================================
local imageUrl = "https://i.ibb.co/MkhPVnWs/Chat-GPT-Image-28-2026-14-13-59.png"
local fileName = "menu_logo.png"
local filePath = fileName

local function fileExists(path)
    local success, result = pcall(function() return loadfile(path) end)
    return success and result ~= nil
end

if not fileExists(filePath) then
    print("📥 Скачиваем логотип...")
    local success, content = pcall(function() return game:HttpGet(imageUrl, true) end)
    if success and content then
        local writeSuccess, err = pcall(function() writefile(filePath, content) end)
        if writeSuccess then
            print("✅ Логотип сохранён: " .. filePath)
        else
            warn("⚠️ Не удалось сохранить файл: " .. tostring(err))
        end
    else
        warn("⚠️ Не удалось скачать картинку")
    end
else
    print("✅ Логотип уже есть на диске.")
end

local logoPath = nil
if getcustomasset then
    logoPath = getcustomasset(filePath)
elseif getgenv().getcustomasset then
    logoPath = getgenv().getcustomasset(filePath)
end

-- ============================================================
--  СОЗДАЁМ МЕНЮ
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "AqwariumScript"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorners = Instance.new("UICorner")
mainCorners.CornerRadius = UDim.new(0, 12)
mainCorners.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(120, 120, 120)
stroke.Transparency = 0.5
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- ============================================================
--  HEADER (без изменений)
-- ============================================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorners = Instance.new("UICorner")
headerCorners.CornerRadius = UDim.new(0, 12)
headerCorners.Parent = header

if logoPath then
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 32, 0, 32)
    logo.Position = UDim2.new(0, 8, 0, 4)
    logo.BackgroundTransparency = 1
    logo.Image = logoPath
    logo.ZIndex = 15
    logo.Parent = header
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 8)
    lc.Parent = logo
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 220, 1, 0)
title.Position = UDim2.new(0, 48, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AW-SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamMedium
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 0, 39)
headerLine.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
headerLine.BackgroundTransparency = 0.4
headerLine.BorderSizePixel = 0
headerLine.Parent = mainFrame

-- ============================================================
--  ПАНЕЛИ (без изменений)
-- ============================================================
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.2, 0, 1, -40)
leftPanel.Position = UDim2.new(0, 0, 0, 40)
leftPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
leftPanel.BackgroundTransparency = 0
leftPanel.BorderSizePixel = 0
leftPanel.ClipsDescendants = true
leftPanel.Parent = mainFrame

local layoutLeft = Instance.new("UIListLayout")
layoutLeft.FillDirection = Enum.FillDirection.Vertical
layoutLeft.HorizontalAlignment = Enum.HorizontalAlignment.Center
layoutLeft.VerticalAlignment = Enum.VerticalAlignment.Top
layoutLeft.Padding = UDim.new(0, 6)
layoutLeft.Parent = leftPanel

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.8, 0, 1, -40)
rightPanel.Position = UDim2.new(0.2, 0, 0, 40)
rightPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
rightPanel.BackgroundTransparency = 0.1
rightPanel.BorderSizePixel = 0
rightPanel.ClipsDescendants = true
rightPanel.Parent = mainFrame

local rightCorners = Instance.new("UICorner")
rightCorners.CornerRadius = UDim.new(0, 6)
rightCorners.Parent = rightPanel

-- ============================================================
--  ФУНКЦИЯ ТЕЛЕПОРТА К ФИНИШУ (без куклы)
-- ============================================================
local function teleportToFinish()
    local character = player.Character
    if not character then
        print("❌ Персонаж не найден")
        return
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        print("❌ HumanoidRootPart не найден")
        return
    end

    -- Ищем объект финиша (Finish, End, FinishLine)
    local finishPart = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (string.lower(obj.Name):find("finish") or string.lower(obj.Name):find("end") or string.lower(obj.Name):find("line")) then
            finishPart = obj
            break
        end
    end

    if not finishPart then
        print("❌ Финиш не найден на карте. Возможно, игра ещё не началась.")
        return
    end

    -- Рассчитываем позицию: встаём за финишной линией (на 5 стёбов вперёд)
    -- Для этого находим направление от центра карты к финишу или просто используем направление вверх? 
    -- Проще: добавим к позиции финиша смещение по оси Z (обычно финиш расположен по оси Z, но может быть иначе).
    -- Чтобы быть универсальным, используем вектор направления от игрока к финишу, чтобы встать за финиш (дальше от игрока)
    local playerPos = hrp.Position
    local finishPos = finishPart.Position
    local dir = (finishPos - playerPos).Unit  -- направление от игрока к финишу
    local targetPos = finishPos + dir * 5      -- смещаем на 5 стёбов за финиш

    -- Добавляем небольшое смещение по Y, чтобы не провалиться
    targetPos = Vector3.new(targetPos.X, targetPos.Y + 3, targetPos.Z)

    hrp.CFrame = CFrame.new(targetPos)
    print("✅ Телепорт к финишу выполнен! Позиция: " .. tostring(targetPos))
end

-- ============================================================
--  ВКЛАДКИ (анимации без изменений)
-- ============================================================
local tabNames = {"Game", "Рlayer","Combat", "Misc"}
local tabButtons = {}
local rightContentFrames = {}

local function animateTabButton(btn, isActive)
    local targetSize = isActive and UDim2.new(0.9, 0, 0, 34) or UDim2.new(0.85, 0, 0, 30)
    local targetColor = isActive and Color3.fromRGB(60, 60, 70) or Color3.fromRGB(28, 28, 28)
    local targetTrans = isActive and 0.1 or 0.5
    local targetTextColor = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(btn, tweenInfo, {Size = targetSize}):Play()
    TweenService:Create(btn, tweenInfo, {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(btn, tweenInfo, {BackgroundTransparency = targetTrans}):Play()
    TweenService:Create(btn, tweenInfo, {TextColor3 = targetTextColor}):Play()
end

local function animateContent(content, show)
    if show then
        content.Visible = true
        content.Position = UDim2.new(0, 5, 0, 10)
        content.BackgroundTransparency = 0.5
        TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 0.2
        }):Play()
    else
        TweenService:Create(content, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 5, 0, 10),
            BackgroundTransparency = 0.6
        }):Play()
        task.wait(0.2)
        content.Visible = false
    end
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = leftPanel
    local btnCorners = Instance.new("UICorner")
    btnCorners.CornerRadius = UDim.new(0, 6)
    btnCorners.Parent = btn

    btn.MouseEnter:Connect(function()
        if btn.BackgroundTransparency > 0.2 then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 50), BackgroundTransparency = 0.2}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundTransparency > 0.2 then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 28), BackgroundTransparency = 0.5}):Play()
        end
    end)

    tabButtons[name] = btn

    local content

    if name == "Game" then
        content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -10, 1, -10)
        content.Position = UDim2.new(0, 5, 0, 5)
        content.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        content.BackgroundTransparency = 0.2
        content.BorderSizePixel = 0
        content.Visible = (i == 1)
        content.Parent = rightPanel
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        content.CanvasSize = UDim2.new(0, 0, 0, 120)
        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(0, 6)
        sc.Parent = content

        -- Блок Red Light, Green Light
        local block = Instance.new("Frame")
        block.Size = UDim2.new(0.9, 0, 0, 100)
        block.Position = UDim2.new(0.05, 0, 0, 10)
        block.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        block.BackgroundTransparency = 0.1
        block.BorderSizePixel = 0
        block.Parent = content
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = block

        -- Заголовок
        local blockTitle = Instance.new("TextLabel")
        blockTitle.Size = UDim2.new(1, 0, 0, 25)
        blockTitle.Position = UDim2.new(0, 0, 0, 0)
        blockTitle.BackgroundTransparency = 1
        blockTitle.Text = "Red Light, Green Light"
        blockTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        blockTitle.TextSize = 14
        blockTitle.Font = Enum.Font.GothamMedium
        blockTitle.TextXAlignment = Enum.TextXAlignment.Center
        blockTitle.TextYAlignment = Enum.TextYAlignment.Center
        blockTitle.Parent = block

        -- Серая полоска
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(0.9, 0, 0, 1)
        separator.Position = UDim2.new(0.05, 0, 0, 25)
        separator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        separator.BackgroundTransparency = 0.4
        separator.BorderSizePixel = 0
        separator.Parent = block

        -- Кнопка Teleport
        local teleportBtn = Instance.new("TextButton")
        teleportBtn.Size = UDim2.new(0.8, 0, 0, 40)
        teleportBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
        teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        teleportBtn.BackgroundTransparency = 0.3
        teleportBtn.BorderSizePixel = 0
        teleportBtn.Text = "Teleport to finish"
        teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportBtn.TextSize = 16
        teleportBtn.Font = Enum.Font.GothamBold
        teleportBtn.Parent = block
        local tbc = Instance.new("UICorner")
        tbc.CornerRadius = UDim.new(0, 8)
        tbc.Parent = teleportBtn

        teleportBtn.MouseButton1Click:Connect(function()
            teleportToFinish()
        end)

        rightContentFrames[name] = content
    else
        content = Instance.new("Frame")
        content.Size = UDim2.new(1, -10, 1, -10)
        content.Position = UDim2.new(0, 5, 0, 5)
        content.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        content.BackgroundTransparency = 0.2
        content.BorderSizePixel = 0
        content.Visible = (i == 1)
        content.Parent = rightPanel
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(0, 6)
        cc.Parent = content
        rightContentFrames[name] = content
    end
end

-- Обработчики кликов для всех вкладок
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(tabButtons) do
            animateTabButton(b, n == name)
        end
        for n, frame in pairs(rightContentFrames) do
            animateContent(frame, n == name)
        end
    end)
end

animateTabButton(tabButtons["Game"], true)

-- ============================================================
--  ФУТЕР (без изменений)
-- ============================================================
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 35)
footer.Position = UDim2.new(0, 0, 1, -35)
footer.BackgroundTransparency = 1
footer.Parent = mainFrame

local lineUp = Instance.new("Frame")
lineUp.Size = UDim2.new(1, 0, 0, 1)
lineUp.Position = UDim2.new(0, 0, 0, 2)
lineUp.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
lineUp.BackgroundTransparency = 0.4
lineUp.BorderSizePixel = 0
lineUp.Parent = footer

local lineDown = Instance.new("Frame")
lineDown.Size = UDim2.new(1, 0, 0, 1)
lineDown.Position = UDim2.new(0, 0, 1, -3)
lineDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
lineDown.BackgroundTransparency = 0.4
lineDown.BorderSizePixel = 0
lineDown.Parent = footer

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0.2, 0, 1, 0)
versionText.Position = UDim2.new(0.02, 0, 0, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "v1.5"
versionText.TextColor3 = Color3.fromRGB(180, 180, 180)
versionText.TextTransparency = 0.4
versionText.TextSize = 13
versionText.Font = Enum.Font.GothamMedium
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.TextYAlignment = Enum.TextYAlignment.Center
versionText.Parent = footer

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, 0, 1, 0)
footerText.Position = UDim2.new(0, 0, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "script By | tormentor412"
footerText.TextColor3 = Color3.fromRGB(150, 150, 150)
footerText.TextSize = 14
footerText.Font = Enum.Font.GothamMedium
footerText.TextXAlignment = Enum.TextXAlignment.Center
footerText.TextYAlignment = Enum.TextYAlignment.Center
footerText.Parent = footer

-- ============================================================
--  СКРЫВАЕМ "секунд" (без изменений)
-- ============================================================
local function hideSeconds()
    for _, v in pairs(player.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and (v.Text:lower():find("секунд") or v.Text:lower():find("игрок") or v.Text:lower():find("game")) then
            v.Visible = false
            v.Text = ""
        end
    end
end
hideSeconds()
player.PlayerGui.DescendantAdded:Connect(function(child)
    if child:IsA("TextLabel") and (child.Text:lower():find("секунд") or child.Text:lower():find("игрок") or child.Text:lower():find("game")) then
        child.Visible = false
        child.Text = ""
    end
end)

print("✅ AW-SCRIPT (Teleport к финишу) загружен!")
