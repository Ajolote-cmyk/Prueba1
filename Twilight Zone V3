local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Colores
local COLOR_ITEM = Color3.fromRGB(255, 215, 0)    -- dorado
local COLOR_MACHINE = Color3.fromRGB(0, 170, 255) -- azul claro
local COLOR_SPIRIT = Color3.fromRGB(0, 255, 255)  -- cian

local highlighted = {}

-- Buscar partes
local function findAnyBasePart(model)
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("BasePart") then
			return d
		end
	end
	return nil
end

-- Asegurar que el modelo está cargado
local function waitForModelReady(model, timeout)
	local t0 = tick()
	while tick() - t0 < (timeout or 3) do
		if findAnyBasePart(model) then return true end
		task.wait(0.1)
	end
	return false
end

-- Crear highlight con fallback
local function addHighlightSmart(model, color, transparency, tag)
	if not model or not model:IsA("Model") then return end
	if highlighted[model] then return end

	if not waitForModelReady(model, 3) then
		warn("[Highlight] Modelo sin partes:", model:GetFullName())
		return
	end

	local h = Instance.new("Highlight")
	h.Name = "HL_" .. (tag or "unk")
	h.FillColor = color
	h.OutlineColor = Color3.fromRGB(255, 255, 255)
	h.FillTransparency = transparency or 0.3
	h.OutlineTransparency = 0

	-- Intentar adornar el modelo entero
	local ok = pcall(function() h.Adornee = model end)
	if not ok or not h.Adornee then
		-- fallback a una parte
		local part = model:FindFirstChild("HumanoidRootPart") or findAnyBasePart(model)
		if part then
			h.Adornee = part
		else
			h:Destroy()
			return
		end
	end

	h.Parent = model
	highlighted[model] = true
end

-- Observar carpeta
local function observeFolder(folder, color, tag)
	if not folder then return end

	for _, d in ipairs(folder:GetDescendants()) do
		if d:IsA("Model") then
			addHighlightSmart(d, color, 0.3, tag)
		end
	end

	folder.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") then
			addHighlightSmart(obj, color, 0.3, tag)
		end
	end)
end

-- Procesar cada piso
local function processFloor(floor)
	task.spawn(function()
		local itemsMain = floor:WaitForChild("Items", 20)
		if itemsMain then
			local itemsFolder = itemsMain:WaitForChild("Items", 20)
			if itemsFolder then
				observeFolder(itemsFolder, COLOR_ITEM, "Item")
			end
		end

		local machinesFolder = floor:WaitForChild("Machines", 20)
		if machinesFolder then
			observeFolder(machinesFolder, COLOR_MACHINE, "Machine")
		end

		local spiritsFolder = floor:WaitForChild("Spirits", 20)
		if spiritsFolder then
			observeFolder(spiritsFolder, COLOR_SPIRIT, "Spirit")
		end
	end)
end

-- Observar floors
local function observeFloors()
	for _, f in ipairs(workspace:GetChildren()) do
		if f:IsA("Folder") or f:IsA("Model") then
			processFloor(f)
		end
	end

	workspace.ChildAdded:Connect(function(newFloor)
		if newFloor:IsA("Folder") or newFloor:IsA("Model") then
			processFloor(newFloor)
		end
	end)
end

-- Inicio
if player.Character then
	task.defer(observeFloors)
else
	player.CharacterAdded:Connect(function()
		task.defer(observeFloors)
	end)
end
