local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alek10er/MM2-chek/main/MM2%20loding"))()

print("🟢 M9kuuvs sistem live")

-- Ссылка на Библиотеку
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alek10er/MM2-chek/main/UI.lua"))()

-- Создать окно UI
local Window = Library.CreateLib("M9kuuvs system", "RJTheme3")

local Tab = Window:NewTab("Main")

-- Подсекция
local Section = Tab:NewSection("Main")

-- Секция
local Tab = Window:NewTab("ESP")

-- Подсекция
local Section = Tab:NewSection("Esp Settings")


-- Подсветка игроков
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Highlights"
espFolder.Parent = workspace

local highlights = {}

-- Функция для проверки инструментов игрока
function getPlayerColor(player)
    local character = player.Character
    if not character then return Color3.fromRGB(0, 255, 0) end -- зеленый по умолчанию
    
    local backpack = player:FindFirstChild("Backpack")
    local hasKnife = false
    local hasGun = false
    
    -- Проверяем инструменты в инвентаре
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if toolName:find("knife") or toolName:find("нож") then
                    hasKnife = true
                elseif toolName:find("gun") or toolName == "gun" then
                    hasGun = true
                end
            end
        end
    end
    
    -- Проверяем инструменты в руках
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if toolName:find("knife") or toolName:find("нож") then
                    hasKnife = true
                elseif toolName:find("gun") or toolName == "gun" then
                    hasGun = true
                end
            end
        end
    end
    
    -- Определяем цвет
    if hasKnife then
        return Color3.fromRGB(255, 0, 0) -- красный
    elseif hasGun then
        return Color3.fromRGB(0, 0, 255) -- синий
    else
        return Color3.fromRGB(0, 255, 0) -- зеленый
    end
end

-- Функция создания Highlight
function createHighlight(character, player)
    if highlights[character] then
        highlights[character]:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.Adornee = character
    highlight.Parent = espFolder
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    highlights[character] = highlight
    updateHighlightColor(player)
end

-- Функция обновления цвета Highlight
function updateHighlightColor(player)
    local character = player.Character
    if character and highlights[character] then
        highlights[character].FillColor = getPlayerColor(player)
        highlights[character].OutlineColor = getPlayerColor(player)
    end
end

-- Функция удаления Highlight
function removeHighlight(character)
    if highlights[character] then
        highlights[character]:Destroy()
        highlights[character] = nil
    end
end

-- Обработчики игроков
function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        createHighlight(character, player)
    end)
    
    if player.Character then
        createHighlight(player.Character, player)
    end
    
    player.CharacterRemoving:Connect(function(character)
        removeHighlight(character)
    end)
end

-- Обработчик изменений в инвентаре
function monitorPlayerTools(player)
    local function checkTools()
        updateHighlightColor(player)
    end
    
    -- Проверяем при изменении инвентаря
    local backpack = player:WaitForChild("Backpack")
    backpack.ChildAdded:Connect(checkTools)
    backpack.ChildRemoved:Connect(checkTools)
    
    -- Проверяем при изменении инструмента в руках
    player.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                checkTools()
            end
        end)
        character.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                checkTools()
            end
        end)
    end)
end

-- Основная функция ESP
function enableESP()
    -- Очищаем старые подсветки
    for character, highlight in pairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}
    
    -- Добавляем обработчики для существующих игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then -- Исключаем себя
            onPlayerAdded(player)
            monitorPlayerTools(player)
        end
    end
    
    -- Обработчик новых игроков
    Players.PlayerAdded:Connect(function(player)
        if player ~= Players.LocalPlayer then
            onPlayerAdded(player)
            monitorPlayerTools(player)
        end
    end)
    
    -- Постоянное обновление (на всякий случай)
    local updateConnection
    updateConnection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                updateHighlightColor(player)
            end
        end
    end)
    
    return updateConnection
end

function disableESP()
    -- Очищаем все подсветки
    for character, highlight in pairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}
    
    -- Очищаем папку
    espFolder:ClearAllChildren()
end

-- Использование с вашим toggle
Section:NewToggle("ESP PLAYER", "When you enable the feature, you can see players.", function(state)
    if state then
        print("ESP On")
        enableESP()
    else
        print("ESP Off")
        disableESP()
    end
end)


local Tab = Window:NewTab("Misc")
-- Подсекция
local Section = Tab:NewSection("Misc")



local Tab = Window:NewTab("Developers")
-- Подсекция
local Section = Tab:NewSection("Developers")



local Tab = Window:NewTab("News")
-- Подсекция
local Section = Tab:NewSection("News")
-- Заголовок
Section:NewLabel("M9KUUVS SOFTWARE SYSTEMS V1.0.0")
Section:NewLabel("Last UPD in 24.09.25")
Section:NewLabel("Thx for play)) ")

