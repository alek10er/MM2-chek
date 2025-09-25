local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alek10er/MM2-chek/main/MM2%20loding"))()

print("🟢 M9kuuvs sistem live")

-- Ссылка на Библиотеку
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alek10er/MM2-chek/main/UI.lua"))()

-- Создать окно UI
local Window = Library.CreateLib("Exsile system", "RJTheme3")

local Tab = Window:NewTab("Main")

-- Подсекция
local Section = Tab:NewSection("Main")

-- Слайдер скорости
Section:NewSlider("Speed Hack", "You can change the speed", 500, 16, function(s) -- 500 (Макс. значение) | 16 (Мин. значение)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

--Слайдер прыжков

-- Слайдер для высоты прыжка
Section:NewSlider("Jump Power", "You can change jump height", 200, 50, function(s) -- 200 (Макс. значение) | 50 (Мин. значение)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- Глобальные переменные для отслеживания
local gunTracker = {
    lastGunPlayer = nil,
    lastGunPosition = nil,
    lastDetectionTime = 0
}

-- Функция для поиска игрока с gun
function findGunPlayer()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hasGun = false
                
                -- Проверяем backpack
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name == "gun") then
                            hasGun = true
                            break
                        end
                    end
                end
                
                -- Проверяем инструменты в руках
                if not hasGun then
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name == "gun") then
                            hasGun = true
                            break
                        end
                    end
                end
                
                if hasGun then
                    gunTracker.lastGunPlayer = player
                    gunTracker.lastGunPosition = character.HumanoidRootPart.Position
                    gunTracker.lastDetectionTime = tick()
                    return true
                end
            end
        end
    end
    return false
end

-- Кнопка для телепортации к игроку с gun
Section:NewButton("Teleport to Gun", "Teleport gun to Sheriff", function()
    local hasGun = findGunPlayer()
    
    if hasGun then
        -- Показываем уведомление об ошибке
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Gun not drop",
            Duration = 3,
            Icon = "⚠️"
        })
    elseif gunTracker.lastGunPosition then
        -- Телепортируемся к последней позиции
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(gunTracker.lastGunPosition + Vector3.new(0, 5, 0))
        end
    else
        -- Если никогда не находили gun
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Info",
            Text = "Gun never detected",
            Duration = 3
        })
    end
end)

-- Автоматическое отслеживание (опционально)
game:GetService("RunService").Heartbeat:Connect(function()
    findGunPlayer()
end)

--Авто фарм 
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local teleportingToCoins = false
local currentTween = nil

-- Функция поиска ВСЕХ монеток в workspace
local function findAllCoins()
    local coins = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Coin_Server" and obj:IsA("Part") then
            table.insert(coins, obj)
        end
    end
    
    return coins
end

-- Функция проверки валидности позиции
local function isValidPosition(position)
    return 
        position ~= nil and
        math.abs(position.X) < 10000 and
        math.abs(position.Y) < 10000 and
        math.abs(position.Z) < 10000 and
        position.X == position.X and
        position.Y == position.Y and
        position.Z == position.Z
end

-- Функция проверки расстояния до монетки
local function getDistanceToCoin(character, coin)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart or not coin then return math.huge end
    
    return (humanoidRootPart.Position - coin.Position).Magnitude
end

-- Функция для включения/выключения ходьбы
local function setHumanoidWalking(character, enabled)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = enabled and 20 or 0 -- Увеличили скорость ходьбы
    end
end

-- Функция быстрого реалистичного перемещения к монетке
local function moveToCoin(character, coin)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoidRootPart or not humanoid or not coin then return false end
    
    if not isValidPosition(coin.Position) then
        print("❌ Невалидная позиция монетки")
        return false
    end
    
    local targetPosition = coin.Position + Vector3.new(0, 2, 0)
    if not isValidPosition(targetPosition) then
        print("❌ Невалидная целевая позиция")
        return false
    end
    
    local distance = getDistanceToCoin(character, coin)
    local success = true
    
    -- Если монетка очень близко (до 15 studs) - быстрая ходьба
    if distance < 15 then
        setHumanoidWalking(character, true)
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, targetPosition)
        wait(0.3) -- Уменьшили паузу ходьбы
        setHumanoidWalking(character, false)
        
    -- Если монетка на среднем расстоянии (15-40 studs) - быстрый полет
    elseif distance < 40 then
        setHumanoidWalking(character, true)
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, targetPosition)
        wait(0.4) -- Короткая ходьба
        
        setHumanoidWalking(character, false)
        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- Ускорили полет
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
        tween:Play()
        tween.Completed:Wait()
        
    -- Если монетка далеко (40+ studs) - ускоренное комбинированное перемещение
    else
        -- Этап 1: Быстрая ходьба
        setHumanoidWalking(character, true)
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, targetPosition)
        wait(0.6) -- Уменьшили время ходьбы
        
        -- Этап 2: Быстрый полет
        setHumanoidWalking(character, false)
        local intermediatePosition = (humanoidRootPart.Position + targetPosition) / 2
        intermediatePosition = intermediatePosition + Vector3.new(0, 4, 0)
        
        local tweenInfo1 = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- Ускорили
        local tween1 = TweenService:Create(humanoidRootPart, tweenInfo1, {CFrame = CFrame.new(intermediatePosition)})
        tween1:Play()
        tween1.Completed:Wait()
        
        -- Этап 3: Быстрый завершающий полет
        local tweenInfo2 = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.In) -- Ускорили
        local tween2 = TweenService:Create(humanoidRootPart, tweenInfo2, {CFrame = CFrame.new(targetPosition)})
        tween2:Play()
        tween2.Completed:Wait()
        
        -- Короткая имитация приземления
        setHumanoidWalking(character, true)
        wait(0.2) -- Уменьшили паузу
        setHumanoidWalking(character, false)
    end
    
    return success
end

-- Функция сортировки монеток по расстоянию
local function sortCoinsByDistance(character, coins)
    local sortedCoins = {}
    local distances = {}
    
    for _, coin in ipairs(coins) do
        local distance = getDistanceToCoin(character, coin)
        table.insert(sortedCoins, coin)
        table.insert(distances, distance)
    end
    
    for i = 1, #sortedCoins - 1 do
        for j = i + 1, #sortedCoins do
            if distances[i] > distances[j] then
                sortedCoins[i], sortedCoins[j] = sortedCoins[j], sortedCoins[i]
                distances[i], distances[j] = distances[j], distances[i]
            end
        end
    end
    
    return sortedCoins
end

-- Функция быстрого поиска и перемещения к монеткам
local function startCoinCollection()
    if teleportingToCoins then return end
    teleportingToCoins = true
    
    local function collectCoins()
        while teleportingToCoins do
            local localPlayer = game.Players.LocalPlayer
            local character = localPlayer.Character
            
            if not character or not character.Parent then
                wait(1) -- Уменьшили паузу
                continue
            end
            
            setHumanoidWalking(character, true)
            wait(0.3) -- Уменьшили начальную паузу
            
            local coins = findAllCoins()
            
            if #coins == 0 then
                print("Монетки не найдены")
                setHumanoidWalking(character, false)
                wait(2) -- Уменьшили паузу
                continue
            end
            
            print("⚡ Найдено монеток: " .. #coins)
            
            local sortedCoins = sortCoinsByDistance(character, coins)
            
            for i, coin in ipairs(sortedCoins) do
                if not teleportingToCoins then break end
                if not character or character.Parent == nil then break end
                
                if not coin or not coin.Parent then
                    continue
                end
                
                if not isValidPosition(coin.Position) then
                    continue
                end
                
                local distance = getDistanceToCoin(character, coin)
                print("🎯 Монетка " .. i .. "/" .. #sortedCoins .. " (" .. math.floor(distance) .. " studs)")
                
                local success = moveToCoin(character, coin)
                
                if success then
                    print("✅ Забрал монетку " .. i)
                    -- Короткие паузы после сбора
                    setHumanoidWalking(character, true)
                    wait(0.4) -- Уменьшили
                    setHumanoidWalking(character, false)
                    wait(0.3) -- Уменьшили
                else
                    print("❌ Ошибка")
                    wait(0.5) -- Уменьшили
                end
            end
            
            if teleportingToCoins then
                setHumanoidWalking(character, false)
                print("🔁 Поиск новых монеток...")
                wait(1) -- Уменьшили паузу между циклами
            end
        end
    end
    
    spawn(collectCoins)
end

local function stopCoinCollection()
    teleportingToCoins = false
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    
    local localPlayer = game.Players.LocalPlayer
    if localPlayer and localPlayer.Character then
        setHumanoidWalking(localPlayer.Character, false)
    end
    
    print("Авто-сбор выключен")
end

-- Переключатель
Section:NewToggle("Auto Coin Collection (Fast)", "Fast realistic movement to coins", function(state)
    if state then
        print("⚡ Авто-сбор включен (быстрый режим)")
        startCoinCollection()
    else
        print("Авто-сбор выключен")
        stopCoinCollection()
    end
end)

-- Бинд на правый Shift для открытия/закрытия меню
Section:NewKeybind("Toggle Menu", "Press RightShift to open/close menu", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

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
local connections = {} -- Таблица для хранения всех соединений
local updateConnection = nil

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
    local playerConnections = {}
    
    local charAdded = player.CharacterAdded:Connect(function(character)
        createHighlight(character, player)
    end)
    table.insert(playerConnections, charAdded)
    
    if player.Character then
        createHighlight(player.Character, player)
    end
    
    local charRemoving = player.CharacterRemoving:Connect(function(character)
        removeHighlight(character)
    end)
    table.insert(playerConnections, charRemoving)
    
    connections[player] = playerConnections
end

-- Обработчик изменений в инвентаре
function monitorPlayerTools(player)
    local function checkTools()
        updateHighlightColor(player)
    end
    
    local toolConnections = {}
    
    -- Проверяем при изменении инвентаря
    local backpack = player:WaitForChild("Backpack")
    local backpackAdded = backpack.ChildAdded:Connect(checkTools)
    local backpackRemoved = backpack.ChildRemoved:Connect(checkTools)
    table.insert(toolConnections, backpackAdded)
    table.insert(toolConnections, backpackRemoved)
    
    -- Проверяем при изменении инструмента в руках
    player.CharacterAdded:Connect(function(character)
        local charAdded = character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                checkTools()
            end
        end)
        local charRemoved = character.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                checkTools()
            end
        end)
        table.insert(toolConnections, charAdded)
        table.insert(toolConnections, charRemoved)
    end)
    
    -- Сохраняем соединения для этого игрока
    if connections[player] then
        for _, conn in ipairs(toolConnections) do
            table.insert(connections[player], conn)
        end
    else
        connections[player] = toolConnections
    end
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
    local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        if player ~= Players.LocalPlayer then
            onPlayerAdded(player)
            monitorPlayerTools(player)
        end
    end)
    connections["PlayerAdded"] = playerAddedConnection
    
    -- Постоянное обновление
    updateConnection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                updateHighlightColor(player)
            end
        end
    end)
end

function disableESP()
    -- Отключаем все соединения
    for player, playerConnections in pairs(connections) do
        if type(playerConnections) == "table" then
            for _, connection in ipairs(playerConnections) do
                if connection then
                    connection:Disconnect()
                end
            end
        elseif playerConnections then
            playerConnections:Disconnect()
        end
    end
    connections = {}
    
    -- Отключаем постоянное обновление
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end
    
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

--Функция ESP


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local ESPFolders = {}

-- Функция определения класса и цвета (по вашему подобию)
function getPlayerInfo(player)
    local character = player.Character
    if not character then return "innocent", Color3.fromRGB(0, 255, 0) end
    
    local backpack = player:FindFirstChild("Backpack")
    local hasKnife = false
    local hasGun = false
    
    -- Проверяем инструменты в инвентаре (Backpack)
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
    
    -- Проверяем инструменты в руках (Character)
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
    
    -- Определяем класс и цвет
    if hasKnife then
        return "murderer", Color3.fromRGB(255, 0, 0) -- красный
    elseif hasGun then
        return "Sheriff", Color3.fromRGB(0, 0, 255) -- синий
    else
        return "innocent", Color3.fromRGB(0, 255, 0) -- зеленый
    end
end

-- Функция создания ESP для игрока
local function createESP(player)
    if ESPFolders[player] or player == LocalPlayer then return end
    
    local folder = Instance.new("Folder")
    folder.Name = player.Name .. "_ESP"
    folder.Parent = workspace
    
    -- Текст с ником и классом
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPText"
    billboard.Adornee = nil
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.Parent = folder
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 18
    textLabel.TextScaled = false
    textLabel.Parent = billboard
    
    ESPFolders[player] = folder
    return folder
end

-- Функция обновления ESP
local function updateESP(player)
    if not ESPEnabled then return end
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local folder = ESPFolders[player]
    if not folder then
        folder = createESP(player)
    end
    
    local billboard = folder:FindFirstChild("ESPText")
    if not billboard then return end
    
    billboard.Adornee = humanoidRootPart
    
    local className, color = getPlayerInfo(player)
    local textLabel = billboard:FindFirstChild("TextLabel")
    
    if textLabel then
        textLabel.Text = player.Name .. " (" .. className .. ")"
        textLabel.TextColor3 = color
    end
end

-- Функция удаления ESP
local function removeESP(player)
    if ESPFolders[player] then
        ESPFolders[player]:Destroy()
        ESPFolders[player] = nil
    end
end

-- Мониторинг изменений инвентаря
local function monitorPlayerTools(player)
    local function checkTools()
        updateESP(player)
    end
    
    -- Мониторим Backpack
    local backpack = player:WaitForChild("Backpack")
    backpack.ChildAdded:Connect(checkTools)
    backpack.ChildRemoved:Connect(checkTools)
    
    -- Мониторим инструменты в руках
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

-- Основной цикл ESP
local ESPLoop
local function startESP()
    if ESPLoop then return end
    
    ESPLoop = RunService.Heartbeat:Connect(function()
        if not ESPEnabled then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                pcall(updateESP, player)
            end
        end
    end)
end

local function stopESP()
    if ESPLoop then
        ESPLoop:Disconnect()
        ESPLoop = nil
    end
    
    for player, folder in pairs(ESPFolders) do
        removeESP(player)
    end
    ESPFolders = {}
end

-- Переключатель ESP
Section:NewToggle("Class and Nick ESP", "Shows players' nicknames and classes", function(state)
    ESPEnabled = state
    if state then
        print("Player ESP включен")
        startESP()
        
        -- Создаем ESP для существующих игроков
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
                monitorPlayerTools(player)
                updateESP(player)
            end
        end
    else
        print("Player ESP выключен")
        stopESP()
    end
end)

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        createESP(player)
        monitorPlayerTools(player)
        updateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Обработка своего персонажа
LocalPlayer.CharacterAdded:Connect(function()
    if ESPEnabled then
        wait(2)
        -- Перезапускаем ESP чтобы обновить все данные
        stopESP()
        startESP()
    end
end)

--Ник и класс игрока (Подсветка)


local Tab = Window:NewTab("Misc")
-- Подсекция
local Section = Tab:NewSection("Misc")

-- Кнопка
Section:NewButton("Infinite Yield", "Infinite Yield console", function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alek10er/MM2-chek/main/infyal.lua"))()
end)

--Кнопка тп мардер

-- Кнопка телепорта к игроку с ножом
Section:NewButton("TP to Murdere", "TP to Killer", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    if not localRoot then
        print("Ошибка: ваш персонаж не найден")
        return
    end
    
    -- Функция проверки наличия ножа у игрока
    local function hasKnife(player)
        if player == LocalPlayer then return false end
        
        local character = player.Character
        if not character then return false end
        
        -- Проверяем инструменты в инвентаре (Backpack)
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolName = tool.Name:lower()
                    if toolName:find("knife") or toolName:find("нож") then
                        return true
                    end
                end
            end
        end
        
        -- Проверяем инструменты в руках (Character)
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if toolName:find("knife") or toolName:find("нож") then
                    return true
                end
            end
        end
        
        return false
    end
    
    -- Ищем игрока с ножом
    local targetPlayer = nil
    local targetRoot = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if hasKnife(player) then
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    targetPlayer = player
                    targetRoot = humanoidRootPart
                    break
                end
            end
        end
    end
    
    if targetPlayer and targetRoot then
        -- Телепортируемся к игроку с ножом
        localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0) -- Немного выше чтобы не застрять
        print("Телепортирован к игроку с ножом: " .. targetPlayer.Name)
    else
        print("Игрок с ножом не найден")
    end
end)

--Tp to Sheriff

-- Кнопка телепорта к любому игроку с gun
Section:NewButton("TP to Sheriff", "TP to Sheriff", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    if not localRoot then
        print("Ошибка: ваш персонаж не найден")
        return
    end
    
    -- Функция проверки наличия gun у игрока
    local function hasGun(player)
        if player == LocalPlayer then return false end
        
        local character = player.Character
        if not character then return false end
        
        -- Проверяем инструменты в инвентаре (Backpack)
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolName = tool.Name:lower()
                    if toolName:find("gun") or toolName == "gun" then
                        return true
                    end
                end
            end
        end
        
        -- Проверяем инструменты в руках (Character)
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if toolName:find("gun") or toolName == "gun" then
                    return true
                end
            end
        end
        
        return false
    end
    
    -- Ищем ЛЮБОГО игрока с gun (первого найденного)
    local targetPlayer = nil
    local targetRoot = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if hasGun(player) then
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    targetPlayer = player
                    targetRoot = humanoidRootPart
                    break -- Нашли первого - выходим из цикла
                end
            end
        end
    end
    
    if targetPlayer and targetRoot then
        -- Телепортируемся к игроку с gun
        localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0) -- Немного выше чтобы не застрять
        print("Телепортирован к игроку с gun: " .. targetPlayer.Name)
    else
        print("Игрок с gun не найден")
    end
end)



local Tab = Window:NewTab("Developers")
-- Подсекция
local Section = Tab:NewSection("Developers")
Section:NewButton("Skuuv", "Main developer", function()
end)
Section:NewButton("Alek", "scripter", function()
end)




local Tab = Window:NewTab("News")
-- Подсекция
local Section = Tab:NewSection("News")

Section:NewButton("EXSILE SOFTWARE SYSTEMS V1.16.2", "IDK", function()
end)
Section:NewButton("Last UPD in 25.09.25", "IDK", function()
end)
Section:NewButton("Thx for play))", "Good luck", function()
end)
