UI = WebUI(
    "Awesome UI",          
    "file://UI/Index.html"
)

Sky.Spawn()

Input.Subscribe("KeyDown", function(key_name)
  if key_name == "P" then
    Events.CallRemote("ReloadPackages")
  end
  if key_name == "Tab" then
    UI:CallEvent("Shop")
  end
end)

function RandomFloat(min, max)
  return min + math.random() * (max - min)
end

 
Events.SubscribeRemote("PlayPop", function(location)
  Sound(location, "package://merge/Client/SFX/pop.ogg", false, true, SoundType.SFX, RandomFloat(0.8, 1.0), RandomFloat(0.7, 1.2))
end)

function ConvertToHourMinute(number)
  local hours = math.floor(number / 60)
  local minutes = number % 60
  -- Handle 24-hour rollover and start at 9 AM
  hours = (hours + 9) % 24
  return hours, minutes
end

function ConvertToWeather(number)
  local weather_types = {
    WeatherType.ClearSkies,
    WeatherType.Cloudy, 
    WeatherType.Foggy,
    WeatherType.Overcast,
    WeatherType.PartlyCloudy,
    WeatherType.Rain,
    WeatherType.RainLight,
    WeatherType.RainThunderstorm,
    WeatherType.SandDustCalm,
    WeatherType.SandDustStorm,
    WeatherType.Snow,
    WeatherType.SnowBlizzard,
    WeatherType.SnowLight
  }
  
  local weather_index = math.floor(number / 600) % #weather_types + 1
  local weather = weather_types[weather_index]
  return weather
end


Events.SubscribeRemote("SetGameState", function(game_state)
  local time_passed = game_state.TimePassed
  local points = game_state.Points
  local hour, minute = ConvertToHourMinute(time_passed)
  Sky.SetTimeOfDay(hour, minute)
  if time_passed % 600 == 0 then
    Sky.ChangeWeather(ConvertToWeather(time_passed), 20.0)
  end
  local hours = math.floor(time_passed / 3600)
  local minutes = math.floor((time_passed % 3600) / 60)
  local seconds = time_passed % 60
  local time_str = string.format("%02d:%02d:%02d", hours, minutes, seconds)
  UI:CallEvent("UpdateGameStats", time_str, #Player.GetAll(), points)
end)

Timer.SetInterval(function()
  local players = Player.GetAll()
  local player_list = {}
  for _, player in pairs(players) do
    table.insert(player_list, {
      name = player:GetAccountName(),
      icon = player:GetAccountIconURL()
    })
  end
  UI:CallEvent("UpdatePlayerList", #players, player_list)
end, 1000)


Prop.Subscribe("Grab", function(self, character)
  local local_character = Client.GetLocalPlayer():GetControlledCharacter()
  if local_character == character then
    local name = self:GetValue("Name")
    local description = self:GetValue("Description") 
    local propId = self:GetValue("PropId")
    UI:CallEvent("ShowPropInfo", name, description, tostring(propId^2) .. " $")
  end
end)

Events.SubscribeRemote("UpdateMotivation", function(message)
  Sound(Vector(), "package://merge/Client/SFX/upgrade.ogg", true, true, SoundType.SFX, 0.5)
  UI:CallEvent("UpdateMotivation", message)
end)


Events.SubscribeRemote("PlaySound", function(sfx)
  Sound(Vector(), "package://merge/Client/SFX/" .. sfx, true, true, SoundType.SFX, 0.5)
end)