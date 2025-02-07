local ret = Assets.GetStaticMeshes("nanos-world")
local decorations = {}
for k, v in pairs(ret) do
    table.insert(decorations, v.key)
end


function GetRandomDecoration()
    return "nanos-world::" .. decorations[math.random(1, #decorations)]
end
function RandomFloat(min, max)
    return min + math.random() * (max - min)
end

function SpawnDecoration(location)
    local decoration = GetRandomDecoration()
    local static_mesh = StaticMesh(location , Rotator(math.random(0,360),math.random(0,360),math.random(0,360)), decoration, CollisionType.NoCollision)
    static_mesh:SetScale(Vector(RandomFloat(1,5)))
    static_mesh:SetGravityEnabled(false)
    static_mesh:SetMaterialColorParameter("Tint", Color.Random())
    static_mesh:TranslateTo(location+Vector(0,0,20000), 60, 1)
    static_mesh:SetLifeSpan(60)
    return static_mesh
end

Timer.SetInterval(function()
    local angle = math.random() * math.pi * 2 -- Random angle around arena
    local x = math.cos(angle) * (Offset * 2) -- Doubled the radius
    local y = math.sin(angle) * (Offset * 2) -- Doubled the radius 
    local z = -7000
    SpawnDecoration(ARENA_POSITION + Vector(x, y, z))
end, 2000)
