local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Función para añadir Highlight
local function addHighlight(model)
	if not model:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(0, 255, 255)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Parent = model
	end
end

-- Función para iluminar todos los enemigos dentro de una carpeta Spirits
local function illuminateSpiritsFolder(spiritsFolder)
	for _, enemy in pairs(spiritsFolder:GetChildren()) do
		if enemy:IsA("Model") then
			addHighlight(enemy)
		end
	end

	-- Detectar enemigos nuevos
	spiritsFolder.ChildAdded:Connect(function(newEnemy)
		if newEnemy:IsA("Model") then
			addHighlight(newEnemy)
		end
	end)
end

-- Función para observar todos los pisos
local function observeFloors()
	local floorsFolder = workspace:WaitForChild("Floors") -- si tienes varias carpetas de pisos, puedes usar "workspace"
	for _, floor in pairs(floorsFolder:GetChildren()) do
		local spiritsFolder = floor:FindFirstChild("Spirits")
		if spiritsFolder then
			illuminateSpiritsFolder(spiritsFolder)
		end
	end

	-- Detectar nuevos pisos que se agreguen
	floorsFolder.ChildAdded:Connect(function(newFloor)
		local spiritsFolder = newFloor:WaitForChild("Spirits", 5) -- espera hasta 5 segundos
		if spiritsFolder then
			illuminateSpiritsFolder(spiritsFolder)
		end
	end)
end

-- Ejecutar al cargar el jugador
if player.Character then
	task.defer(observeFloors)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloors)
	end)
end
