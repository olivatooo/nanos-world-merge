-- Shop.lua - Server-side shop logic
Package.Require("Items.lua")

-- Store for player purchases and applied items
PlayerShopData = {}
PlayerAppliedItems = {} -- Stores references to attached items for cleanup

-- Initialize player shop data
function InitializePlayerShopData(player)
    local steam_id = player:GetAccountID()
    if not PlayerShopData[steam_id] then
        PlayerShopData[steam_id] = {
            purchased_items = {},
            points = 0
        }
    end
end

-- Save player shop data to file
function SavePlayerShopData(player)
    local steam_id = player:GetAccountID()
    if not PlayerShopData[steam_id] then return end

    local filename = "PlayerShop_" .. steam_id .. ".json"
    local file = File(filename, true)

    local data = {
        purchased_items = PlayerShopData[steam_id].purchased_items,
        points = PlayerShopData[steam_id].points
    }

    file:Write(JSON.stringify(data))
    Console.Log("Saved shop data for player: " .. player:GetAccountName())
end

-- Load player shop data from file
function LoadPlayerShopData(player)
    local steam_id = player:GetAccountID()
    local filename = "PlayerShop_" .. steam_id .. ".json"

    -- Initialize default data first
    InitializePlayerShopData(player)

    -- Try to load existing data
    -- local file = File(filename, false)
    -- if file then
    --     local content = file:Read()
    --     if content and content ~= "" then
    --         local success, data = pcall(function() return JSON.parse(content) end)
    --         if success and data then
    --             PlayerShopData[steam_id].purchased_items = data.purchased_items or {}
    --             PlayerShopData[steam_id].points = data.points or 0
    --             for _, item_id in pairs(PlayerShopData[steam_id].purchased_items) do
    --                 PurchaseItem(player, item_id)
    --             end
    --             Console.Log("Loaded shop data for player: " .. player:GetAccountName())
    --             return true
    --         end
    --     end
    -- end

    Console.Log("No existing shop data for player: " .. player:GetAccountName())
    return false
end

-- Check if player owns an item
function PlayerOwnsItem(player, item_id)
    local steam_id = player:GetAccountID()
    if not PlayerShopData[steam_id] then return false end

    for _, owned_id in pairs(PlayerShopData[steam_id].purchased_items) do
        if owned_id == item_id then
            return true
        end
    end
    return false
end

-- Get player's current points
function GetPlayerPoints(player)
    local steam_id = player:GetAccountID()
    if not PlayerShopData[steam_id] then
        InitializePlayerShopData(player)
    end
    return PlayerShopData[steam_id].points or 0
end

-- Award points to a player
function AwardPlayerPoints(player, points)
    local steam_id = player:GetAccountID()
    if not PlayerShopData[steam_id] then
        InitializePlayerShopData(player)
    end
    PlayerShopData[steam_id].points = PlayerShopData[steam_id].points + points
    -- Notify the client of updated points
    Events.CallRemote("UpdatePoints", player, PlayerShopData[steam_id].points)
end

-- Award points to all players
function AwardAllPlayersPoints(points)
    for _, player in pairs(Player.GetAll()) do
        AwardPlayerPoints(player, points)
    end
end

-- Purchase an item
function PurchaseItem(player, item_id)
    local steam_id = player:GetAccountID()
    local item = GetItemById(item_id)

    if not item then
        Events.CallRemote("ShopMessage", player, "Item not found!", "error")
        return false
    end

    -- Check if already owned
    if PlayerOwnsItem(player, item_id) then
        Events.CallRemote("ShopMessage", player, "You already own this item!", "warning")
        return false
    end

    -- Check if player has enough points
    local points = GetPlayerPoints(player)
    if points < item.price then
        Events.CallRemote("ShopMessage", player, "Not enough points! Need " .. item.price .. ", have " .. points, "error")
        return false
    end

    -- Deduct points from player's individual balance
    PlayerShopData[steam_id].points = PlayerShopData[steam_id].points - item.price

    -- Add item to player's inventory
    table.insert(PlayerShopData[steam_id].purchased_items, item_id)

    -- Apply the item
    local character = player:GetControlledCharacter()
    if character then
        ApplyItem(player, character, item)
    end

    -- Save data
    SavePlayerShopData(player)

    -- Update client
    Events.CallRemote("ShopMessage", player, "Successfully purchased " .. item.name .. "!", "success")
    Events.CallRemote("UpdatePoints", player, PlayerShopData[steam_id].points)

    -- Broadcast to all players
    Chat.BroadcastMessage(player:GetAccountName() .. " purchased " .. item.name .. "!")

    Console.Log(player:GetAccountName() .. " purchased " .. item.name)
    return true
end

-- Apply an item to a character
function ApplyItem(player, character, item)
    if not character or not character:IsValid() then return end

    local steam_id = player:GetAccountID()

    -- Initialize storage if needed
    if not PlayerAppliedItems[steam_id] then
        PlayerAppliedItems[steam_id] = {}
    end

    -- Clean up old items of the same category (except effects which can stack)
    if item.category ~= "effect" then
        CleanupItemsByCategory(player, item.category)
    end

    -- Apply the item's function
    local applied_objects = item.apply(character)

    -- Store reference for cleanup (handle both single objects and arrays)
    if applied_objects then
        if not PlayerAppliedItems[steam_id][item.category] then
            PlayerAppliedItems[steam_id][item.category] = {}
        end

        if type(applied_objects) == "table" and #applied_objects > 0 then
            -- Array of objects
            for _, obj in pairs(applied_objects) do
                table.insert(PlayerAppliedItems[steam_id][item.category], obj)
            end
        else
            -- Single object or nil (for color changes)
            table.insert(PlayerAppliedItems[steam_id][item.category], applied_objects)
        end
    end
end

-- Clean up items by category
function CleanupItemsByCategory(player, category)
    local steam_id = player:GetAccountID()
    if not PlayerAppliedItems[steam_id] or not PlayerAppliedItems[steam_id][category] then
        return
    end

    for _, item_obj in pairs(PlayerAppliedItems[steam_id][category]) do
        if item_obj and type(item_obj) == "userdata" and item_obj.IsValid and item_obj:IsValid() then
            item_obj:Destroy()
        end
    end

    PlayerAppliedItems[steam_id][category] = {}
end

-- Restore all purchased items for a player
function RestorePlayerItems(player)
    local steam_id = player:GetAccountID()
    if not PlayerShopData[steam_id] then return end

    local character = player:GetControlledCharacter()
    if not character then return end

    -- Wait a moment for character to be fully spawned
    Timer.SetTimeout(function()
        character = player:GetControlledCharacter()
        if not character then return end

        Console.Log("Restoring " .. #PlayerShopData[steam_id].purchased_items .. " items for " .. player:GetAccountName())

        for _, item_id in pairs(PlayerShopData[steam_id].purchased_items) do
            local item = GetItemById(item_id)
            if item then
                ApplyItem(player, character, item)
            end
        end
    end, 500)
end

-- Handle shop open request
Events.SubscribeRemote("OpenShop", function(player)
    InitializePlayerShopData(player)
    local points = GetPlayerPoints(player)

    -- Send shop data to client
    local shop_data = {
        items = ShopItems,
        player_points = points,
        owned_items = PlayerShopData[player:GetAccountID()].purchased_items
    }

    Events.CallRemote("ReceiveShopData", player, JSON.stringify(shop_data))
end)

-- Handle purchase request
Events.SubscribeRemote("PurchaseItem", function(player, item_id)
    PurchaseItem(player, item_id)

    -- Send updated shop data
    local points = GetPlayerPoints(player)
    local shop_data = {
        items = ShopItems,
        player_points = points,
        owned_items = PlayerShopData[player:GetAccountID()].purchased_items
    }
    Events.CallRemote("ReceiveShopData", player, JSON.stringify(shop_data))
end)

-- Handle player spawn - restore items
Player.Subscribe("Spawn", function(player)
    LoadPlayerShopData(player)
    RestorePlayerItems(player)
    -- Send initial points to player
    Timer.SetTimeout(function()
        local points = GetPlayerPoints(player)
        Events.CallRemote("UpdatePoints", player, points)
    end, 1000)
end)

-- Save data when player leaves
Player.Subscribe("Destroy", function(player)
    SavePlayerShopData(player)

    -- Cleanup applied items
    local steam_id = player:GetAccountID()
    if PlayerAppliedItems[steam_id] then
        for category, items in pairs(PlayerAppliedItems[steam_id]) do
            for _, item_obj in pairs(items) do
                if item_obj and type(item_obj) == "userdata" and item_obj.IsValid and item_obj:IsValid() then
                    item_obj:Destroy()
                end
            end
        end
        PlayerAppliedItems[steam_id] = nil
    end
end)

Console.Log("Shop system loaded successfully!")
