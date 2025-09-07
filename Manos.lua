while true do
    if game.Workspace.tono.Reflectance == 0 then
        game.Workspace.chilaquiles.nahual.PointLight.Enabled = false
    else
        game.Workspace.chilaquiles.nahual.PointLight.Enabled = true
    end
    wait(0.1)  -- ← Evita que Roblox se crashee
end
