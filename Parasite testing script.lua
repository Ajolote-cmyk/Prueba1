local player = game.Players.LocalPlayer

-- Crear la UI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false -- 🔑 Esto evita que desaparezca al respawn
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.9, 0) -- centrado abajo
toggleButton.Text = "Activar Script"
toggleButton.Parent = screenGui

-- Variable para controlar el estado
local scriptActivo = false
local loopThread

-- Función que maneja el loop
local function startLoop(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    while scriptActivo and humanoid.Parent do
        -- Elegir ubicación aleatoria
        local choice = math.random(1, 3)
        if choice == 1 then
            hrp.CFrame = CFrame.new(-3, 6, 51)
        elseif choice == 2 then
            hrp.CFrame = CFrame.new(11, 4, 43)
        else
            hrp.CFrame = CFrame.new(13, 5, 63)
        end

        -- Forzar la muerte del jugador
        
        wait(4)
        humanoid.Health = 0

        wait(6)
    end
end

-- Conectar el botón
toggleButton.MouseButton1Click:Connect(function()
    scriptActivo = not scriptActivo
    if scriptActivo then
        toggleButton.Text = "Desactivar Script"
        if player.Character then
            loopThread = coroutine.wrap(startLoop)
            loopThread(player.Character)
        end
    else
        toggleButton.Text = "Activar Script"
    end
end)

-- Reiniciar el loop al reaparecer
player.CharacterAdded:Connect(function(char)
    if scriptActivo then
        loopThread = coroutine.wrap(startLoop)
        loopThread(char)
    end
end)