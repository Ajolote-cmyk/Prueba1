local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Función para añadir Highlight a cualquier modelo
local function addHighlight(model)
	if not model:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cian
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Parent = model
	end
end

-- Función recursiva que aplica Highlight a un objeto y todos sus modelos/partes internas
local function highlightRecursive(obj)
	if obj:IsA("Model") then
		addHighlight(obj)
		for _, child in pairs(obj:GetChildren()) do
			highlightRecursive(child)
		end
	elseif obj:IsA("BasePart") then
		addHighlight(obj)
	end
end

-- Función que ilumina todos los Spirits dentro de una carpeta
local function illuminateSpiritsFolder(spiritsFolder)
	for _, obj in pairs(spiritsFolder:GetDescendants()) do
		if obj:IsA("Model") or obj:IsA("BasePart") then
			highlightRecursive(obj)
		end
	end

	-- Detectar Spirits nuevos en cualquier nivel
	spiritsFolder.DescendantAdded:Connect(function(newObj)
		if newObj:IsA("Model") or newObj:IsA("BasePart") then
			highlightRecursive(newObj)
		end
	end)
end

-- Función que observa todos los pisos en workspace
local function observeFloors()
	-- Puedes cambiar "workspace" por una carpeta específica si tus pisos están en una carpeta llamada "Floors"
	for _, floor in pairs(workspace:GetChildren()) do
		if floor:IsA("Folder") or floor:IsA("Model") then
			local spiritsFolder = floor:FindFirstChild("Spirits")
			if spiritsFolder then
				illuminateSpiritsFolder(spiritsFolder)
			end
		end
	end

	-- Detectar pisos nuevos agregados durante la partida
	workspace.ChildAdded:Connect(function(newFloor)
		if newFloor:IsA("Folder") or newFloor:IsA("Model") then
			local spiritsFolder = newFloor:WaitForChild("Spirits", 5) -- espera hasta 5 segundos
			if spiritsFolder then
				illuminateSpiritsFolder(spiritsFolder)
			end
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
