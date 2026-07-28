-- =====================================================
--  AQWARIUM SCRIPT (с вкладками Game, Player, Misc, Combat)
--  Логотип + надпись, серая обводка
--  Скрывает "секунд", не трогает GUI игры
-- =====================================================

-- Ждём загрузки
repeat wait() until game:IsLoaded()
wait(0.5)

local player = game:GetService("Players").LocalPlayer
if not player then
    warn("Игрок не найден")
    return
end

-- ============================================================
--  ЗАГРУЗКА ЛОГОТИПА
-- ============================================================
local imageUrl = "https://i.ibb.co/MkhPVnWs/Chat-GPT-Image-28-2026-14-13-59.png"
local fileName = "menu_logo.png"
local filePath = fileName

local function fileExists(path)
    local success, result = pcall(function()
        return loadfile(path)
    end)
    return success and result ~= nil
end

if not fileExists(filePath) then
    print("📥 Скачиваем логотип...")
    local success, content = pcall(function()
        return game:HttpGet(imageUrl, true)
    end)
    if success and content then
        local writeSuccess, err = pcall(function()
            writefile(filePath, content)
        end)
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
--  HEADER
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

-- Логотип
if logoPath then
    local logo = Instance.new("ImageLabel")
    logo.Name = "MenuLogoIcon"
    logo.Size = UDim2.new(0, 32, 0, 32)
    logo.Position = UDim2.new(0, 8, 0, 4)
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.Image = logoPath
    logo.ZIndex = 15
    logo.Parent = header

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo
    print("🖼️ Логотип загружен")
else
    print("❌ Логотип не загружен")
end

-- Надпись
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 220, 1, 0)
title.Position = UDim2.new(0, 48, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AQWARIUM SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

-- Серая линия
local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 0, 39)
headerLine.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
headerLine.BackgroundTransparency = 0.4
headerLine.BorderSizePixel = 0
headerLine.Parent = mainFrame

-- ============================================================
--  ПАНЕЛИ
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
--  ВКЛАДКИ (Game, Players, Misc, Combat)
-- ============================================================
local tabNames = {"Game", "Players","Combat", "Misc"}   -- изменено
local tabButtons = {}
local rightContentFrames = {}

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
        if btn.BackgroundTransparency > 0.1 then
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            btn.BackgroundTransparency = 0.2
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundTransparency < 0.9 then
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            btn.BackgroundTransparency = 0.5
        end
    end)
    tabButtons[name] = btn

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -10)
    content.Position = UDim2.new(0, 5, 0, 5)
    content.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    content.BackgroundTransparency = 0.2
    content.BorderSizePixel = 0
    content.Visible = (i == 1)
    content.Parent = rightPanel
    local contentCorners = Instance.new("UICorner")
    contentCorners.CornerRadius = UDim.new(0, 6)
    contentCorners.Parent = content
    rightContentFrames[name] = content
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for n, frame in pairs(rightContentFrames) do
            frame.Visible = (n == name)
        end
        for n, b in pairs(tabButtons) do
            if n == name then
                b.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                b.BackgroundTransparency = 0.1
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                b.BackgroundTransparency = 0.5
                b.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end)
end

tabButtons["Game"].BackgroundColor3 = Color3.fromRGB(60, 60, 70)
tabButtons["Game"].BackgroundTransparency = 0.1
tabButtons["Game"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- ============================================================
--  ФУТЕР
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
print("✅ AQWARIUM SCRIPT (вкладки Game, Player, Misc, Combat) загружен!")
