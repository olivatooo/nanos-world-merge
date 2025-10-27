-- Items.lua - Shop Items Configuration
-- Each item has: name, description, price, category, and apply function

ShopItems = {
    -- HATS/ACCESSORIES
    {
        id = "hat_tophat",
        name = "Top Hat",
        description = "A fancy top hat for the distinguished player",
        price = 1000,
        category = "hat",
        apply = function(character)
            local hat = StaticMesh(
                Vector(0, 0, 95),
                Rotator(0, 0, 0),
                "nanos-world::SM_Cone"
            )
            hat:SetScale(Vector(0.5, 0.5, 1.2))
            hat:SetMaterialColorParameter("Tint", Color(0.1, 0.1, 0.1))
            hat:AttachTo(character, AttachmentRule.SnapToTarget, "head", 0)
            return hat
        end
    },
    {
        id = "hat_crown",
        name = "Golden Crown",
        description = "Become the king of merging!",
        price = 5000,
        category = "hat",
        apply = function(character)
            local crown = StaticMesh(
                Vector(0, 0, 95),
                Rotator(0, 0, 0),
                "nanos-world::SM_Cone"
            )
            crown:SetScale(Vector(0.6, 0.6, 0.4))
            crown:SetMaterialColorParameter("Tint", Color(1, 0.84, 0))
            crown:SetMaterialColorParameter("Emissive", Color(1, 0.84, 0) * 2)
            crown:SetMaterialScalarParameter("Metallic", 1.0)
            crown:AttachTo(character, AttachmentRule.SnapToTarget, "head", 0)
            return crown
        end
    },
    {
        id = "hat_halo",
        name = "Angel Halo",
        description = "You're an angel... or are you?",
        price = 3000,
        category = "hat",
        apply = function(character)
            local halo = StaticMesh(
                Vector(0, 0, 110),
                Rotator(90, 0, 0),
                "nanos-world::SM_Ring"
            )
            halo:SetScale(Vector(0.3, 0.3, 0.05))
            halo:SetMaterialColorParameter("Tint", Color(1, 1, 0.5))
            halo:SetMaterialColorParameter("Emissive", Color(1, 1, 0.5) * 5)
            halo:AttachTo(character, AttachmentRule.SnapToTarget, "head", 0)
            return halo
        end
    },
    {
        id = "hat_cube",
        name = "Thinking Cube",
        description = "Think outside the box... or inside it?",
        price = 2500,
        category = "hat",
        apply = function(character)
            local cube = StaticMesh(
                Vector(0, 0, 100),
                Rotator(45, 45, 0),
                "nanos-world::SM_Cube"
            )
            cube:SetScale(Vector(0.3, 0.3, 0.3))
            cube:SetMaterialColorParameter("Tint", Color.Random())
            -- Rotate the cube continuously
            Timer.SetInterval(function()
                if cube:IsValid() then
                    local current_rot = cube:GetRelativeRotation()
                    cube:SetRelativeRotation(current_rot + Rotator(2, 3, 1))
                end
            end, 50)
            cube:AttachTo(character, AttachmentRule.SnapToTarget, "head", 0)
            return cube
        end
    },
    {
        id = "hat_sphere",
        name = "Floating Orb",
        description = "A mysterious floating sphere",
        price = 4000,
        category = "hat",
        apply = function(character)
            local orb = StaticMesh(
                Vector(0, 0, 120),
                Rotator(0, 0, 0),
                "nanos-world::SM_Sphere"
            )
            orb:SetScale(Vector(0.25, 0.25, 0.25))
            orb:SetMaterialColorParameter("Tint", Color(0.3, 0.5, 1))
            orb:SetMaterialColorParameter("Emissive", Color(0.3, 0.5, 1) * 3)
            -- Make it bob up and down
            local start_z = 120
            local time = 0
            Timer.SetInterval(function()
                if orb:IsValid() then
                    time = time + 0.1
                    local offset = math.sin(time) * 10
                    orb:SetRelativeLocation(Vector(0, 0, start_z + offset))
                end
            end, 50)
            orb:AttachTo(character, AttachmentRule.SnapToTarget, "head", 0)
            return orb
        end
    },

    -- CHARACTER COLORS
    {
        id = "color_red",
        name = "Red Skin",
        description = "Turn yourself red!",
        price = 500,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Tint", Color(1, 0.2, 0.2))
        end
    },
    {
        id = "color_blue",
        name = "Blue Skin",
        description = "Feeling blue?",
        price = 500,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Tint", Color(0.2, 0.4, 1))
        end
    },
    {
        id = "color_green",
        name = "Green Skin",
        description = "Go green!",
        price = 500,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Tint", Color(0.2, 1, 0.3))
        end
    },
    {
        id = "color_purple",
        name = "Purple Skin",
        description = "Royal purple vibes",
        price = 500,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Tint", Color(0.8, 0.2, 1))
        end
    },
    {
        id = "color_gold",
        name = "Golden Skin",
        description = "Shine like gold!",
        price = 2000,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Tint", Color(1, 0.84, 0))
            character:SetMaterialColorParameter("Emissive", Color(1, 0.84, 0) * 0.5)
            character:SetMaterialScalarParameter("Metallic", 0.8)
        end
    },
    {
        id = "color_rainbow",
        name = "Rainbow Skin",
        description = "Taste the rainbow!",
        price = 5000,
        category = "color",
        apply = function(character)
            local time = 0
            Timer.SetInterval(function()
                if character:IsValid() then
                    time = time + 0.05
                    local r = (math.sin(time) + 1) / 2
                    local g = (math.sin(time + 2.094) + 1) / 2
                    local b = (math.sin(time + 4.189) + 1) / 2
                    character:SetMaterialColorParameter("Tint", Color(r, g, b))
                end
            end, 50)
        end
    },
    {
        id = "color_glow",
        name = "Glowing Skin",
        description = "Emit a powerful glow",
        price = 3000,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Emissive", Color(0.5, 1, 1) * 3)
            character:SetMaterialColorParameter("Tint", Color(0.3, 0.8, 1))
        end
    },
    {
        id = "color_shadow",
        name = "Shadow Skin",
        description = "Embrace the darkness",
        price = 2500,
        category = "color",
        apply = function(character)
            character:SetMaterialColorParameter("Tint", Color(0.1, 0.1, 0.2))
            character:SetMaterialColorParameter("Emissive", Color(0.2, 0, 0.4))
        end
    },

    -- SPECIAL EFFECTS
    {
        id = "effect_particles",
        name = "Particle Trail",
        description = "Leave a trail of particles wherever you go",
        price = 7500,
        category = "effect",
        apply = function(character)
            local particle = Particle(
                Vector(0, 0, 0),
                Rotator(0, 0, 0),
                "nanos-world::P_Smoke",
                false,
                true
            )
            particle:SetParameterColor("Color", Color.Random())
            particle:AttachTo(character, AttachmentRule.SnapToTarget, "", 0)
            return particle
        end
    },
    {
        id = "effect_aura",
        name = "Energy Aura",
        description = "Surround yourself with energy rings",
        price = 10000,
        category = "effect",
        apply = function(character)
            local rings = {}
            for i = 1, 3 do
                local ring = StaticMesh(
                    Vector(0, 0, 50 + i * 30),
                    Rotator(90, 0, i * 30),
                    "nanos-world::SM_Ring"
                )
                ring:SetScale(Vector(0.5 + i * 0.1, 0.5 + i * 0.1, 0.05))
                ring:SetMaterialColorParameter("Tint", Color(0.2, 0.8, 1))
                ring:SetMaterialColorParameter("Emissive", Color(0.2, 0.8, 1) * 3)
                ring:SetMaterialScalarParameter("Opacity", 0.5)
                
                -- Rotate rings
                local rotation_speed = 2 * i
                Timer.SetInterval(function()
                    if ring:IsValid() then
                        local current_rot = ring:GetRelativeRotation()
                        ring:SetRelativeRotation(current_rot + Rotator(0, rotation_speed, rotation_speed * 0.5))
                    end
                end, 50)
                
                ring:AttachTo(character, AttachmentRule.SnapToTarget, "", 0)
                table.insert(rings, ring)
            end
            return rings
        end
    },
    {
        id = "effect_size_boost",
        name = "Giant Mode",
        description = "Permanently increase your character size!",
        price = 15000,
        category = "effect",
        apply = function(character)
            character:SetScale(Vector(1.5, 1.5, 1.5))
        end
    },
}

-- Helper function to get item by ID
function GetItemById(item_id)
    for _, item in pairs(ShopItems) do
        if item.id == item_id then
            return item
        end
    end
    return nil
end

-- Helper function to get items by category
function GetItemsByCategory(category)
    local items = {}
    for _, item in pairs(ShopItems) do
        if item.category == category then
            table.insert(items, item)
        end
    end
    return items
end

