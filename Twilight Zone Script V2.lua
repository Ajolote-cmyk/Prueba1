local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- V2Crear Highlight
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

-- ====== Items / Spawns ======
local function observeItemsInFloor(floor)
	local itemsMain = floor:WaitForChild("Items", 2)
	if not itemsMain then return end

	local itemsFolder = itemsMain:WaitForChild("Items", 2)
	if not itemsFolder then return end

	-- Cuando aparezca un Spawn y dentro de él un Model
	itemsFolder.ChildAdded:Connect(function(obj)
		if obj:IsA("BasePart") and obj.Name == "Spawn" then
			obj.ChildAdded:Connect(function(child)
				if child:IsA("Model") then
					addHighlight(child, Color3.fromRGB(255, 215, 0), 0.3)
				end
			end)
		end
	end)

	-- Procesar lo que ya estaba
	for _, obj in ipairs(itemsFolder:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "Spawn" then
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Model") then
					addHighlight(child, Color3.fromRGB(255, 215, 0), 0.3)
				end
			end
		end
	end
end

-- ====== Enemigos / Spirits ======
local function observeSpiritsInFloor(floor)
	local spiritsFolder = floor:WaitForChild("Spirits", 2)
	if not spiritsFolder then return end

	-- Detectar enemigos que ya existen
	for _, enemy in ipairs(spiritsFolder:GetChildren()) do
		if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
			addHighlight(enemy, Color3.fromRGB(0, 255, 255), 0.5)
		end
	end

	-- Detectar enemigos nuevos
	spiritsFolder.ChildAdded:Connect(function(enemy)
		if enemy:IsA("Model") then
			local hrp = enemy:FindFirstChild("HumanoidRootPart")
			if hrp then
				addHighlight(enemy, Color3.fromRGB(0, 255, 255), 0.5)
			else
				enemy.ChildAdded:Connect(function(part)
					if part.Name == "HumanoidRootPart" then
						addHighlight(enemy, Color3.fromRGB(0, 255, 255), 0.5)
					end
				end)
			end
		end
	end)
end

-- ====== Observar todos los pisos ======
local function observeFloors()
	-- Procesar pisos que ya existen
	for _, floor in ipairs(workspace:GetChildren()) do
		if floor:IsA("Folder") or floor:IsA("Model") then
			observeItemsInFloor(floor)
			observeSpiritsInFloor(floor)
		end
	end

	-- Procesar pisos nuevos
	workspace.ChildAdded:Connect(function(newFloor)
		if newFloor:IsA("Folder") or newFloor:IsA("Model") then
			-- damos chance a que carguen sus carpetas
			task.delay(0.5, function()
				observeItemsInFloor(newFloor)
				observeSpiritsInFloor(newFloor)
			end)
		end
	end)
end

-- Ejecutar
if player.Character then
	task.defer(observeFloors)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloors)
	end)
end
