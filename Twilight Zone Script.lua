local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

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

-- Función recursiva para iluminar modelos y submodelos
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

-- Función que recorre todos los Spirits de un piso
local function illuminateSpiritsFolder(spiritsFolder)
	for _, obj in pairs(spiritsFolder:GetDescendants()) do
		if obj:IsA("Model") or obj:IsA("BasePart") then
			highlightRecursive(obj)
		end
	end
end

-- Función que revisa todos los pisos periódicamente
local function observeFloorsPeriodically()
	while true do
		for _, floor in pairs(workspace:GetChildren()) do
			if floor:IsA("Folder") or floor:IsA("Model") then
				local spiritsFolder = floor:FindFirstChild("Spirits")
				if spiritsFolder then
					illuminateSpiritsFolder(spiritsFolder)
				end
			end
		end
		task.wait(1) -- revisa cada segundo
	end
end

-- Ejecutar al cargar el jugador
if player.Character then
	task.defer(observeFloorsPeriodically)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloorsPeriodically)
	end)
end
