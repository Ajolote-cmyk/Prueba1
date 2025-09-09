local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Crear Highlight en el enemigo (Model)
local function addHighlight(enemyModel)
	if not enemyModel:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(0, 255, 255) -- cian
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Parent = enemyModel
	end
end

-- Iluminar todos los enemigos dentro de Spirits
local function illuminateSpiritsFolder(spiritsFolder)
	for _, enemy in pairs(spiritsFolder:GetChildren()) do
		if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
			addHighlight(enemy)
		end
	end

	-- Detectar enemigos nuevos agregados después
	spiritsFolder.ChildAdded:Connect(function(newEnemy)
		if newEnemy:IsA("Model") and newEnemy:FindFirstChild("HumanoidRootPart") then
			addHighlight(newEnemy)
		end
	end)
end

-- Buscar todos los pisos y conectar sus Spirits
local function observeFloors()
	for _, floor in pairs(workspace:GetChildren()) do
		if floor:IsA("Folder") or floor:IsA("Model") then
			local spiritsFolder = floor:FindFirstChild("Spirits")
			if spiritsFolder then
				illuminateSpiritsFolder(spiritsFolder)
			end
		end
	end

	-- Detectar pisos nuevos que aparezcan durante la partida
	workspace.ChildAdded:Connect(function(newFloor)
		local spiritsFolder = newFloor:WaitForChild("Spirits", 5)
		if spiritsFolder then
			illuminateSpiritsFolder(spiritsFolder)
		end
	end)
end

-- Ejecutar cuando el jugador esté listo
if player.Character then
	task.defer(observeFloors)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloors)
	end)
end
