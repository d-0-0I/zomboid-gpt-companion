-- print("[NPC Mod] Script file loaded")

-- -- Rest of your existing script here...

-- -- NPC Spawn and Follow Script

-- local NPC = {}
-- NPC.spawnDistance = 5 -- Distance from player to spawn NPC

-- -- Debug function
-- local function debugLog(message)
--     print("[NPC Mod] " .. message)
-- end

-- -- Function to spawn NPC near player
-- function NPC.spawn(player)
--     debugLog("Attempting to spawn NPC")
--     local x = player:getX() + ZombRand(-NPC.spawnDistance, NPC.spawnDistance)
--     local y = player:getY() + ZombRand(-NPC.spawnDistance, NPC.spawnDistance)
--     local z = player:getZ()
    
--     local npc = addNPC("Bob", nil, nil, nil, x, y, z, nil)
--     if npc then
--         debugLog("NPC spawned successfully at " .. x .. ", " .. y .. ", " .. z)
--         npc:setInvincible(true) -- Make NPC invincible for now
--     else
--         debugLog("Failed to spawn NPC")
--     end
--     return npc
-- end

-- -- Function to make NPC follow player
-- function NPC.follow(npc, player)
--     if not npc or not player then
--         debugLog("NPC or player is nil in follow function")
--         return
--     end
--     local playerX, playerY = player:getX(), player:getY()
--     local npcX, npcY = npc:getX(), npc:getY()
    
--     local dx = playerX - npcX
--     local dy = playerY - npcY
    
--     -- Simple follow logic (can be improved)
--     if math.abs(dx) > 2 or math.abs(dy) > 2 then
--         npc:setPath2(playerX, playerY, player:getZ())
--     else
--         npc:StopAllActionQueue()
--     end
-- end

-- -- Initialization function
-- local function initNPCMod()
--     debugLog("Initializing NPC Mod")
    
--     -- Event to spawn NPC when player spawns
--     Events.OnPlayerSpawn.Add(function(playerIndex, player)
--         debugLog("Player spawn event triggered")
--         NPC.instance = NPC.spawn(player)
--     end)

--     -- Event to make NPC follow player (called every game tick)
--     Events.OnTick.Add(function()
--         local player = getSpecificPlayer(0)
--         if player and NPC.instance then
--             NPC.follow(NPC.instance, player)
--         end
--     end)
    
--     debugLog("NPC Mod initialized successfully")
-- end

-- -- Call initialization function
-- initNPCMod()


if not NPCMod then NPCMod = {} end

NPCMod.SpawnDistance = 5

NPCMod.OnGameStart = function()
    print("[NPC Mod] Game started, mod loaded successfully")
end

NPCMod.SpawnNPC = function()
    print("[NPC Mod] Attempting to spawn NPC")
    local player = getSpecificPlayer(0)
    if not player then
        print("[NPC Mod] Player not found")
        return
    end

    local x = player:getX() + ZombRand(-NPCMod.SpawnDistance, NPCMod.SpawnDistance)
    local y = player:getY() + ZombRand(-NPCMod.SpawnDistance, NPCMod.SpawnDistance)
    local z = player:getZ()

    local npc = IsoPlayer.new(getWorld():getCell(), nil, x, y, z)
    if npc then
        npc:setSceneCulled(false)
        npc:setBlockMovement(true)
        npc:setNPC(true)
        print("[NPC Mod] NPC spawned successfully at " .. x .. ", " .. y .. ", " .. z)
    else
        print("[NPC Mod] Failed to spawn NPC")
    end
    return npc
end

NPCMod.FollowPlayer = function()
    if not NPCMod.npc or not getSpecificPlayer(0) then return end

    local player = getSpecificPlayer(0)
    local npc = NPCMod.npc

    local dx = player:getX() - npc:getX()
    local dy = player:getY() - npc:getY()

    if math.abs(dx) > 2 or math.abs(dy) > 2 then
        npc:setX(npc:getX() + dx * 0.1)
        npc:setY(npc:getY() + dy * 0.1)
    end
end

NPCMod.OnTick = function()
    if not NPCMod.npc then
        NPCMod.npc = NPCMod.SpawnNPC()
    else
        NPCMod.FollowPlayer()
    end
end

Events.OnGameStart.Add(NPCMod.OnGameStart)
Events.OnTick.Add(NPCMod.OnTick)

print("[NPC Mod] Script file loaded")