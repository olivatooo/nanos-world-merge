Package.Require("BouncyGun.lua")

function RandomFloat(min, max)
    return min + math.random() * (max - min)
end

function MakeItRain()
    local num_spawns = math.random(50, 100)
    for i = 1, num_spawns do
        Timer.SetTimeout(function()
            if #Player.GetAll() > 0 then
                SpawnProp(math.random(1, 3),
                    ARENA_POSITION + Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
                GameState.Points = GameState.Points + 1
            end
        end, math.random(100, 1000))
    end
end

function DistributeBouncyGuns()
    for k, v in pairs(Character.GetAll()) do
        local bouncy_gun = BouncyGun(Vector(), Rotator())
        v:PickUp(bouncy_gun)
    end
    Timer.SetTimeout(function()
        for k, v in pairs(Weapon.GetAll()) do
            v:Destroy()
        end
    end, 10000 * BallToSpawn)
end

function PropExplosion()
    local props = Prop.GetAll()
    for _, prop in pairs(props) do
        local direction = Vector(
            RandomFloat(-1, 1),
            RandomFloat(-1, 1),
            RandomFloat(0.5, 1)
        )
        prop:AddImpulse(direction * 4000, true)
    end
end

function ColorParty()
    for _, prop in pairs(Prop.GetAll()) do
        prop:SetMaterialColorParameter("Tint", Color.Random())
        prop:SetMaterialColorParameter("Emissive", Color.Random())
    end
end

function Vacuum()
    for _, prop in pairs(Prop.GetAll()) do
        prop:TranslateTo(ARENA_POSITION + Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)),
            5, 0)
    end
end

GoodSpecialEvents = {
    { name = "Bouncy Gun Time!", func = DistributeBouncyGuns },
    { name = "Make it Rain!",    func = MakeItRain },
    { name = "Vacuum!",          func = Vacuum },
}

NonSenseSpecialEvents = {
    { name = "Color Party!",    func = ColorParty },
    { name = "Prop Explosion!", func = PropExplosion }
}
