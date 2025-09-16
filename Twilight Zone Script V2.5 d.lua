local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Función general para añadir Highlight
local function addHighlight(model, color, transparency, tag)
	if model and model:IsA("Model") then
		if not model:FindFirstChild("Highlight") then
			local highlight = Instance.new("Highlight")
			highlight.FillColor = color
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = transparency or 0.5
			highlight.OutlineTransparency = 0
			highlight.Parent = model
			print("[Highlight] Añadido a:", model:GetFullName(), "Tag:", tag)
		end
	end
end

-- ===== Spirits =====
local function hookSpirits(floor)
	task.spawn(function()
		local spiritsFolder = floor:WaitForChild("Spirits", 20) -- esperamos hasta 20s
		if not spiritsFolder then
			warn("[Spirits] No apareció en piso:", floor.Name)
			return
		end
		print("[Spirits] Detectado en piso:", floor.Name)

		-- iluminar existentes
		for _, enemy in ipairs(spiritsFolder:GetChildren()) do
			if enemy:IsA("Model") then
				if enemy:FindFirstChild("HumanoidRootPart") then
					addHighlight(enemy, Color3.fromRGB(0, 255, 255), 0.5, "Spirit")
				else
					-- Si el HRP aparece después
					enemy.ChildAdded:Connect(function(child)
						if child.Name == "HumanoidRootPart" then
							addHighlight(enemy, Color3.fromRGB(0, 255, 255), 0.5, "Spirit")
						end
					end)
				end
			end
		end

		-- iluminar nuevos enemigos
		spiritsFolder.ChildAdded:Connect(function(newEnemy)
			if newEnemy:IsA("Model") then
				if newEnemy:FindFirstChild("HumanoidRootPart") then
					addHighlight(newEnemy, Color3.fromRGB(0, 255, 255), 0.5, "Spirit")
				else
					newEnemy.ChildAdded:Connect(function(child)
						if child.Name == "HumanoidRootPart" then
							addHighlight(newEnemy, Color3.fromRGB(0, 255, 255), 0.5, "Spirit")
						end
					end)
				end
			end
		end)
	end)
end

-- ===== Items =====
local function hookItems(floor)
	task.spawn(function()
		local itemsMain = floor:WaitForChild("Items", 20)
		if not itemsMain then
			warn("[Items] No apareció carpeta Items en piso:", floor.Name)
			return
		end

		local itemsFolder = itemsMain:WaitForChild("Items", 20)
		if not itemsFolder then
			warn("[Items] No apareció carpeta Items.Items en piso:", floor.Name)
			return
		end
		print("[Items] Detectado en piso:", floor.Name)

		-- revisar spawns existentes
		for _, spawnPart in ipairs(itemsFolder:GetChildren()) do
			if spawnPart:IsA("BasePart") and spawnPart.Name == "Spawn" then
				for _, child in ipairs(spawnPart:GetChildren()) do
					if child:IsA("Model") then
						addHighlight(child, Color3.fromRGB(255, 215, 0), 0.3, "Item")
					end
				end
				-- futuros hijos del spawn
				spawnPart.ChildAdded:Connect(function(newChild)
					if newChild:IsA("Model") then
						addHighlight(newChild, Color3.fromRGB(255, 215, 0), 0.3, "Item")
					end
				end)
			end
		end

		-- detectar nuevos spawns
		itemsFolder.ChildAdded:Connect(function(newObj)
			if newObj:IsA("BasePart") and newObj.Name == "Spawn" then
				newObj.ChildAdded:Connect(function(child)
					if child:IsA("Model") then
						addHighlight(child, Color3.fromRGB(255, 215, 0), 0.3, "Item")
					end
				end)
			end
		end)
	end)
end

-- ===== Observar todos los pisos =====
local function observeFloors()
	-- pisos ya existentes
	for _, floor in ipairs(workspace:GetChildren()) do
		if floor:IsA("Folder") or floor:IsA("Model") then
			hookSpirits(floor)
			hookItems(floor)
		end
	end

	-- pisos nuevos
	workspace.ChildAdded:Connect(function(newFloor)
		if newFloor:IsA("Folder") or newFloor:IsA("Model") then
			hookSpirits(newFloor)
			hookItems(newFloor)
		end
	end)
end

-- ejecutar
if player.Character then
	task.defer(observeFloors)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloors)
	end)
end
