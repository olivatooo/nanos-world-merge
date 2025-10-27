Package.Require("MergeConfig.lua")


function SetIconFromWebUI(prop)
  local my_ui = WebUI("my_ui", "file://UI/Index.html")
  prop:SetMaterialFromWebUI(my_ui)
end

function SpawnProp(propId, location, rotation)
  location = location or Vector(0, 0, 0)
  rotation = rotation or Rotator(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180))

  -- Find prop config by ID
  local propConfig = Props[propId]

  if not propConfig then
    Console.Error("No prop found with ID: " .. tostring(propId))
    return nil
  end

  -- Create the prop
  local prop = Prop(
    location,
    rotation,
    propConfig.Mesh
  )

  -- Apply texture if specified
  if propConfig.TexturePath then
    prop:SetMaterialTextureParameter("Texture", propConfig.TexturePath)
  end

  -- Apply custom material properties if specified
  if propConfig.Custom then
    for i = 1, #propConfig.Custom, 2 do
      local key = propConfig.Custom[i]
      local value = propConfig.Custom[i + 1]
      if key == "Material" then
        prop:SetMaterial(value)
      end
      if key == "Tint" then
        prop:SetMaterialColorParameter("Tint", value)
      end
      if key == "Emissive" then
        prop:SetMaterialColorParameter("Emissive", value)
      end
      if key == "Icon" then
        -- Console.Log("Setting icon to " .. GetRandomIconURL())
        -- prop:SetMaterialTextureParameter("Texture", GetRandomIconURL())
      end
      if key == "StaticMesh" then
        local sm = StaticMesh(location, rotation, value)
        sm:SetScale(Vector(0.2))
        sm:SetMaterialColorParameter("Tint", Color.Random())
        prop:SetMaterialColorParameter("Tint", Color.Random())
        sm:SetCollision(CollisionType.NoCollision)
        sm:AttachTo(prop, AttachmentRule.SnapToTarget, nil, 0)
      end
      if key == "ColorBounce" then
        local timer = Timer.SetInterval(function(_prop)
          _prop:SetMaterialColorParameter("Tint", Color.Random())
          _prop:SetMaterialColorParameter("Emissive", Color.Random())
          _prop:RotateTo(Rotator(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180)), 1, 0)
        end, 10000, prop)
        Timer.Bind(timer, prop)
      end
      if key == "BlackHole" then
        Events.BroadcastRemote("PlaySound", "ave.ogg")
        -- Set material parameters to make it look like a black hole
        prop:SetMaterialScalarParameter("Metallic", 1.0)
        prop:SetMaterialScalarParameter("Specular", 0.0)
        prop:SetMaterialScalarParameter("Roughness", 0.0)
        prop:SetMaterialScalarParameter("Opacity", 0.7)

        -- Set black color with slight emission
        prop:SetMaterialColorParameter("Tint", Color(0, 0, 0))
        prop:SetMaterialColorParameter("Emissive", Color(0, 0, 0))

        local trigger = Trigger(location, rotation, Vector(propId * 1.2 * (prop:GetScale().X * 100) * 1.1),
          TriggerType.Sphere, false, Color(1, 0, 0))
        trigger:SetOverlapOnlyClasses({ "Prop" })
        trigger:Subscribe("BeginOverlap", function(self, other_actor)
          if other_actor then
            local current_location = other_actor:GetLocation()
            local black_hole_location = self:GetLocation()
            local halfway_location = (current_location + black_hole_location) / 2
            other_actor:TranslateTo(halfway_location, 1, 0)
          end
        end)
      end
      if key == "Dirac" then
        Events.BroadcastRemote("PlaySound", "dorime.ogg")
        -- Get all props in the game
        local all_props = Prop.GetAll()
        -- Group props by their ID
        local props_by_id = {}
        for _, p in pairs(all_props) do
          local id = p:GetValue("PropId")
          if id then
            if not props_by_id[id] then
              props_by_id[id] = {}
            end
            table.insert(props_by_id[id], p)
          end
        end

        -- For each group of same-ID props
        for id, props in pairs(props_by_id) do
          if #props > 1 then
            -- Calculate position near arena center
            local target_pos = ARENA_POSITION + Vector(
              math.random(-500, 500),
              math.random(-500, 500),
              math.random(-500, 500)
            )

            -- Move all props of this ID to the target position
            for _, p in pairs(props) do
              p:SetGravityEnabled(false)
              p:SetCollision(CollisionType.NoCollision)
              p:TranslateTo(target_pos, 1, 0)
            end
          end
        end
      end
    end
  end
  -- Apply physical material if specified
  if propConfig.PhysicalMaterial then
    prop:SetPhysicalMaterial("nanos-world::" .. propConfig.PhysicalMaterial)
  end
  -- Store prop info for reference
  prop:SetValue("Name", propConfig.Name, true)
  prop:SetValue("Description", propConfig.Description, true)
  prop:SetValue("PropId", propId, true)
  prop:SetScale(Vector(propId * 1.017))
  prop:SetGrabMode(GrabMode.Enabled)

  local propSize = (prop:GetScale().X * 100) * 1.1
  if propId == 15 then
    propSize = propSize * 1.5
  end
  -- Create a sphere trigger around the prop
  local trigger = Trigger(
    location,
    Rotator(),
    Vector(propSize), -- Default size of 100 units
    TriggerType.Sphere,
    false,            -- Enabled
    Color(1, 0, 0)    -- Red color
  )
  trigger:SetValue("prop", prop)
  trigger:SetOverlapOnlyClasses({ "Trigger" })
  trigger:SetValue("Mergeable", true)
  trigger:SetValue("Id", propId)
  trigger:Subscribe("BeginOverlap", function(_trigger, other_triggers)
    if other_triggers and _trigger and other_triggers:IsValid() and _trigger:IsValid() and other_triggers:GetValue("Mergeable") and _trigger:GetValue("Mergeable") and other_triggers:GetValue("Id") == _trigger:GetValue("Id") then
      _trigger:SetValue("Mergeable", false)
      other_triggers:SetValue("Mergeable", false)
      _trigger:SetColor(Color(0, 1, 0))
      other_triggers:SetColor(Color(0, 1, 0))
      local my_prop = _trigger:GetValue("prop")
      local other_prop = other_triggers:GetValue("prop")
      if not other_prop then
        _trigger:SetValue("Mergeable", true)
        other_triggers:SetValue("Mergeable", true)
        _trigger:SetColor(Color(1, 0, 0))
        other_triggers:SetColor(Color(1, 0, 0))
        return
      end
      my_prop:SetGravityEnabled(false)
      other_prop:SetGravityEnabled(false)
      my_prop:SetCollision(CollisionType.NoCollision)
      other_prop:SetCollision(CollisionType.NoCollision)
      local half_point = (my_prop:GetLocation() + other_prop:GetLocation()) / 2
      my_prop:TranslateTo(half_point, 0.2, 0.2)
      other_prop:TranslateTo(half_point, 0.2, 0.2)
      Timer.SetTimeout(function()
        local id = _trigger:GetValue("Id")
        local nextPropConfig = Props[id + 1]
        -- Check if the next prop has a custom SFX defined
        if nextPropConfig and nextPropConfig.sfx then
          Events.BroadcastRemote("PlayPop", _trigger:GetLocation(), nextPropConfig.sfx)
        else
          Events.BroadcastRemote("PlayPop", _trigger:GetLocation(), nil)
        end
        SpawnProp(id + 1, half_point)
        if (id + 1 == 7 and BallToSpawn == 1) or
            (id + 1 == 10 and BallToSpawn == 2) or
            (id + 1 == 13 and BallToSpawn == 3) or
            (id + 1 == 16 and BallToSpawn == 4) or
            (id + 1 == 17 and BallToSpawn == 5) or
            (id + 1 == 19 and BallToSpawn == 6) or
            (id + 1 == 20 and BallToSpawn == 7) or
            (id + 1 == 22 and BallToSpawn == 8) or
            (id + 1 == 25 and BallToSpawn == 9) then
          BallToSpawn = BallToSpawn + 1
          local messages = {
            "UPGRADING YOUR BALLS!",
            "YOUR BALLS ARE EVOLVING!",
            "WITNESS THE POWER OF YOUR BALLS!",
            "BALLS HAVE REACHED A NEW LEVEL!",
            "YOUR BALLS ARE GETTING STRONGER!",
            "YOUR BALLS ARE UNSTOPPABLE!",
            "BEHOLD THE MIGHTY BALLS!",
            "THE BALLS GROW MORE POWERFUL!",
            "THESE BALLS CANNOT BE CONTAINED!",
            "YOUR BALLS TRANSCEND REALITY!",
            "BALLS OF LEGEND!",
            "THE BALLS HAVE ASCENDED!",
            "UNLIMITED BALL POWER!",
            "YOUR BALLS DEFY PHYSICS!",
            "WITNESS THE BALL REVOLUTION!"
          }
          local message = messages[math.random(#messages)]
          Events.BroadcastRemote("UpdateMotivation", message)
        end
        my_prop:Destroy()
        other_prop:Destroy()
        GameState.Points = GameState.Points + (2 ^ id)
      end, 200)
    end
  end)
  trigger:AttachTo(prop, AttachmentRule.SnapToTarget, nil, 0)

  return prop
end
