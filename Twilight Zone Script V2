local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Función general para agregar Highlight
local function addHighlight(model, color, transparency)
	if not model:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = color
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = transparency
		highlight.OutlineTransparency = 0
		highlight.Parent = model
	end
end

-- Función recursiva para todos los modelos
local function highlightModels(parent, color, transparency)
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("Model") then
			addHighlight(child, color, transparency)
			highlightModels(child, color, transparency)
		end
	end
end

-- ===== Items/Spawns =====
local function processSpawn(spawnPart)
	highlightModels(spawnPart, Color3.fromRGB(255, 215, 0), 0.3)
	spawnPart.ChildAdded:Connect(function(newChild)
		if newChild:IsA("Model") then
			addHighlight(newChild, Color3.fromRGB(255, 215, 0), 0.3)
			highlightModels(newChild, Color3.fromRGB(255, 215, 0), 0.3)
		end
	end)
end

local function observeItemsInFloor(floor)
	local success, itemsFolder = pcall(function()
		return floor:WaitForChild("Items", 2):WaitForChild("Items", 2)
	end)
	if success and itemsFolder then
		for _, obj in ipairs(itemsFolder:GetChildren()) do
			if obj:IsA("BasePart") and obj.Name == "Spawn" then
				processSpawn(obj)
			end
		end
		itemsFolder.ChildAdded:Connect(function(newObj)
			if newObj:IsA("BasePart") and newObj.Name == "Spawn" then
				processSpawn(newObj)
			end
		end)
	end
end

-- ===== Enemigos/Spirits =====
local function illuminateSpiritsFolder(spiritsFolder)
	for _, enemy in ipairs(spiritsFolder:GetChildren()) do
		if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
			addHighlight(enemy, Color3.fromRGB(0, 255, 255), 0.5)
		end
	end
	spiritsFolder.ChildAdded:Connect(function(newEnemy)
		if newEnemy:IsA("Model") and newEnemy:FindFirstChild("HumanoidRootPart") then
			addHighlight(newEnemy, Color3.fromRGB(0, 255, 255), 0.5)
		end
	end)
end

local function observeSpiritsInFloor(floor)
	local spiritsFolder = floor:FindFirstChild("Spirits")
	if spiritsFolder then
		illuminateSpiritsFolder(spiritsFolder)
	end
end

-- ===== Observar todos los pisos =====
local function observeFloors()
	-- Procesar pisos existentes
	for _, floor in ipairs(workspace:GetChildren()) do
		if floor:IsA("Folder") or floor:IsA("Model") then
			observeItemsInFloor(floor)
			observeSpiritsInFloor(floor)
		end
	end
	-- Detectar pisos nuevos
	workspace.ChildAdded:Connect(function(newFloor)
		if newFloor:IsA("Folder") or newFloor:IsA("Model") then
			observeItemsInFloor(newFloor)
			observeSpiritsInFloor(newFloor)
		end
	end)
end

-- Ejecutar cuando el jugador cargue
if player.Character then
	task.defer(observeFloors)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloors)
	end)
end
