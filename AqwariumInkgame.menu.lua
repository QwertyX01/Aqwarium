-- Aqwarium SCRIPT v1.0
print("Aqwarium SCRIPT загружен!")

local player = game.Players.LocalPlayer

-- Создаём экранное меню
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главный фрейм 600x400
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Скругление углов 20px
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

-- Серая обводка 1px
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 150, 150)
stroke.Thickness = 1
stroke.Parent = frame

-- Заголовок (теперь с нужным названием)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.BackgroundTransparency = 0
title.Text = "Aqwarium SCRIPT"   -- <-- изменено
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = frame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = title

-- Функция создания кнопки
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 20
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== КНОПКИ (примеры, замени под свой геймплей) =====
createButton("🔄 Респавн", 70, function()
    player.Character:BreakJoints()
end)

createButton("💨 Супер-скорость", 130, function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = hrp.Velocity * 3
        end
    end
end)

createButton("🖊️ Бесконечные чернила", 190, function()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Ink") then
                local val = tool:FindFirstChild("Amount")
                if val and val:IsA("NumberValue") then
                    val.Value = 999
                end
            end
        end
    end
end)

createButton("🚀 Телепорт", 250, function()
    local target = game:GetService("Players"):FindFirstChild("Игрок_ник") -- замени ник
    if target and target.Character then
        player.Character:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end)

createButton("❌ Закрыть", 320, function()
    screenGui:Destroy()
end)

-- Открытие/закрытие по клавише X
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.X then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
