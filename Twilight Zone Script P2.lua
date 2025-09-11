local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Función para añadir Highlight a un Model
local function addHighlight(model)
	if not model:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(255, 215, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.3
		highlight.OutlineTransparency = 0
		highlight.Parent = model
		print("Highlight añadido a:", model:GetFullName())
	end
end

-- Función recursiva para procesar todos los modelos dentro de un spawn
local function highlightModels(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("Model") then
			addHighlight(child)
			highlightModels(child) -- revisa descendientes
		end
	end
end

-- Procesar un Spawn
local function processSpawn(spawnPart)
	print("Procesando Spawn:", spawnPart.Name)
	highlightModels(spawnPart)

	spawnPart.ChildAdded:Connect(function(newChild)
		if newChild:IsA("Model") then
			addHighlight(newChild)
			highlightModels(newChild)
		end
	end)
end

-- Observar Items dentro de un piso
local function observeItemsInFloor(floor)
	local success, itemsFolder = pcall(function()
		return floor:WaitForChild("Items"):WaitForChild("Items")
	end)
	if not success then return end

	print("Observando carpeta:", itemsFolder:GetFullName())

	-- Revisar Spawns existentes
	for _, obj in ipairs(itemsFolder:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "Spawn" then
			processSpawn(obj)
		end
	end

	-- Detectar nuevos Spawns
	itemsFolder.ChildAdded:Connect(function(newObj)
		if newObj:IsA("BasePart") and newObj.Name == "Spawn" then
			processSpawn(newObj)
		end
	end)
end

-- Observar todos los pisos actuales y futuros
local function observeFloors()
	for _, floor in ipairs(workspace:GetChildren()) do
		if floor.Name:match("Floor") then
			observeItemsInFloor(floor)
		end
	end

	-- Observar pisos que se agreguen dinámicamente
	workspace.ChildAdded:Connect(function(newFloor)
		if newFloor.Name:match("Floor") then
			observeItemsInFloor(newFloor)
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
