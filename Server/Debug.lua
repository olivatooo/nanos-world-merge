Events.SubscribeRemote("ReloadPackages", function()
  Console.Log("Reloading Packages")
  Events.BroadcastRemote("ServerLog", "Start reloading packages", "blue")
  for k, v in pairs(Server.GetPackages(true)) do
    Console.Log("Reloading Package: " .. v.name)
    Chat.BroadcastMessage("Reloading Package: " .. v.name)
    Server.ReloadPackage(v.name)
  end
end)
