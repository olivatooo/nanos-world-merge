GameState = {
	TimePassed = 0,
	Points = 0,
	CurrentFloorMaterial = "PM_Grass", -- Default floor material
	CurrentWeather = "Clear",         -- Default weather
	PlayerNames = {},                 -- List of connected player names
}

ChampionGameState = {
	TimePassed = 0,
	Points = 0,
	CurrentFloorMaterial = "PM_Grass", -- Default floor material
	CurrentWeather = "Clear",         -- Default weather
	PlayerNames = {},                 -- List of connected player names
}

BallToSpawn = 1

Package.Require("Merge.lua")
Package.Require("SpecialEvents.lua")
Package.Require("Shop.lua")

Offset = 3500
function CreateScaledCube(center, scale)
	-- Left wall
	plane = StaticMesh(
		center - Vector(0, Offset, 0),
		Rotator(0, 0, 90),
		"nanos-world::SM_Plane"
	)
	plane:SetScale(scale)
	plane:SetVisibility(false)
	plane:SetCollision(CollisionType.Normal)

	-- Right wall
	plane = StaticMesh(
		center + Vector(0, Offset, 0),
		Rotator(0, 0, 90),
		"nanos-world::SM_Plane"
	)
	plane:SetScale(scale)
	plane:SetVisibility(false)
	plane:SetCollision(CollisionType.Normal)

	-- Front wall
	plane = StaticMesh(
		center - Vector(Offset, 0, 0),
		Rotator(90, 0, 0),
		"nanos-world::SM_Plane"
	)
	plane:SetScale(scale)
	plane:SetVisibility(false)
	plane:SetCollision(CollisionType.Normal)

	-- Back wall
	plane = StaticMesh(
		center + Vector(Offset, 0, 0),
		Rotator(90, 0, 0),
		"nanos-world::SM_Plane"
	)
	plane:SetScale(scale)
	plane:SetVisibility(false)
	plane:SetCollision(CollisionType.Normal)

	local plane = StaticMesh(
		center - Vector(0, 0, -Offset),
		Rotator(0, 0, 0),
		"nanos-world::SM_Plane"
	)
	plane:SetScale(scale)
	plane:SetVisibility(false)
	plane:SetCollision(CollisionType.Normal)

	local plane = StaticMesh(
		center - Vector(0, 0, Offset),
		Rotator(0, 0, 0),
		"nanos-world::SM_Plane"
	)
	plane:SetScale(scale)
	plane:SetCollision(CollisionType.Normal)

	return plane
end

ARENA_POSITION = Vector(1000000, 10000, 10000)
function ConfigCamera(position)
	-- Set all players' camera location to cube position
	for _, player in pairs(Player.GetAll()) do
		player:SetCameraLocation(position)
		player:SetCameraRotation(Rotator(0, 0, 0))
	end
end

function SpawnCharacter(pos, player)
	local character = Character(pos, Rotator(0, 0, 180))
	character:SetInvulnerable(true)
	character:SetMaxHealth(100000000)
	character:SetHealth(100000000)
	character:SetFallDamageTaken(0)
	character:SetImpactDamageTaken(0)
	Timer.SetInterval(function(_character)
		if not _character then return false end
		if _character:GetLocation().Z < ARENA_POSITION.Z - 30000 then
			_character:SetLocation(ARENA_POSITION)
		end
	end, 10000, character)
	player:Possess(character)
end

function GetColorFromNumber(number)
	-- Use sine waves to create smooth color transitions
	local phase = (number - 1) * 0.01 -- Much slower color changes

	-- Offset sine waves to create smooth RGB transitions
	local r = (math.sin(phase) + 1) / 2
	local g = (math.sin(phase + 2.094) + 1) / 2 -- 2.094 is 2π/3
	local b = (math.sin(phase + 4.189) + 1) / 2 -- 4.189 is 4π/3

	return Color(r, g, b)
end

ARENA = CreateScaledCube(ARENA_POSITION, Vector(75))
Timer.SetInterval(function()
	if #Player.GetAll() > 0 then
		SpawnProp(math.random(1, BallToSpawn),
			ARENA_POSITION + Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
		-- SpawnProp(16, ARENA_POSITION + Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
		GameState.Points = GameState.Points + 1
		ARENA:SetMaterialColorParameter("Tint", GetColorFromNumber(GameState.Points))
	end
end, 200)


Timer.SetInterval(function()
	if #Player.GetAll() > 0 then
		GameState.TimePassed = GameState.TimePassed + 1
		Events.BroadcastRemote("SetGameState", GameState)
		if GameState.TimePassed % 600 == 0 then
			local event = GoodSpecialEvents[math.random(1, #GoodSpecialEvents)]
			Events.BroadcastRemote("UpdateMotivation", event.name)
			event.func()
		end
		if GameState.TimePassed % 700 == 0 then
			local event = NonSenseSpecialEvents[math.random(1, #NonSenseSpecialEvents)]
			Events.BroadcastRemote("UpdateMotivation", event.name)
			event.func()
		end
	end
end, 1000)

ConfigCamera(ARENA_POSITION)

-- Spawns and possess a Character when a Player joins the server
Player.Subscribe("Spawn", function(player)
	PlayerSpawn(player)
end)

function PlayerSpawn(player)
	SpawnCharacter(ARENA_POSITION, player)
	-- Add player to game state if not already present
	if not GameState.Players then
		GameState.Players = {}
	end

	local playerName = player:GetAccountName()
	local playerIcon = player:GetAccountIconURL()

	-- Check if player already exists in game state
	local playerExists = false
	for _, p in ipairs(GameState.Players) do
		if p.name == playerName then
			playerExists = true
			break
		end
	end

	-- Add player if they don't exist
	if not playerExists then
		table.insert(GameState.Players, {
			name = playerName,
			icon = playerIcon
		})
	end
end

function SaveData()
	local my_file = File("GameState.json", true)
	local data = {
		Points = GameState.Points,
		TimePassed = GameState.TimePassed,
		Players = GameState.Players
	}
	my_file:Write(JSON.stringify(data))

	-- Also save to ChampionGameState if current points are higher
	if GameState.Points > ChampionGameState.Points then
		ChampionGameState.Points = GameState.Points
		ChampionGameState.TimePassed = GameState.TimePassed
		ChampionGameState.Players = GameState.Players
	end
end

function LoadData()
	local my_file = File("GameState.json", false)
	local data = JSON.parse(my_file:Read())
	local tempGameState = {
		Points = data.Points,
		TimePassed = data.TimePassed,
		Players = data.Players
	}

	-- Update ChampionGameState if loaded points are higher
	if data.Points > ChampionGameState.Points then
		ChampionGameState.Points = data.Points
		ChampionGameState.TimePassed = data.TimePassed
		ChampionGameState.Players = data.Players
	end

	return tempGameState
end

function CompareAndSaveGameState()
	local my_file = File("GameState.json", false)
	if my_file then
		local loadedState = LoadData()
		-- Compare points between current and loaded state
		if GameState.Points > loadedState.Points then
			-- Current state has more points, save it
			SaveData()
		else
			-- Loaded state has more points, restore it
			GameState.Points = loadedState.Points
			GameState.TimePassed = loadedState.TimePassed
			GameState.Players = loadedState.Players
		end
	else
		-- If no save file exists, create one with current state
		SaveData()
	end
end

Player.Subscribe("Destroy", function(player)
	local character = player:GetControlledCharacter()
	if (character) then
		character:Destroy()
	end
	if #Player.GetAll() == 0 then
		CompareAndSaveGameState()
		Timer.SetTimeout(function()
			if #Player.GetAll() == 0 then
				-- Clean up all props
				for _, prop in pairs(Prop.GetAll()) do
					prop:Destroy()
				end
				-- Clean up all triggers
				for _, trigger in pairs(Trigger.GetAll()) do
					trigger:Destroy()
				end
				-- Reset game state
				SaveData()
				GameState = {
					Points = 0,
					TimePassed = 0,
					Players = {}
				}
			end
		end, 5 * 60 * 1000) -- 5 minutes in milliseconds
	end
end)

Events.SubscribeRemote("ReloadPackages", function()
	Console.Log("Reloading Packages")
	Events.BroadcastRemote("ServerLog", "Start reloading packages", "blue")
	for k, v in pairs(Server.GetPackages(true)) do
		Console.Log("Reloading Package: " .. v.name)
		Chat.BroadcastMessage("Reloading Package: " .. v.name)
		Server.ReloadPackage(v.name)
	end
	Timer.SetTimeout(function()
			for k, v in pairs(Player.GetAll()) do
				PlayerSpawn(v)
			end
		end,
		2000)
end)

Package.Require("Decorations.lua")
Package.Require("Debug.lua")
