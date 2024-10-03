-- NPC Mod

if not NPCMod then NPCMod = {} end

NPCMod.SpawnDistance = 5
NPCMod.FollowInterval = 3 -- Time interval in seconds for following the player
NPCMod.timer = 0 -- Initialize a timer for controlling the follow frequency

-- Function called when the game starts
NPCMod.OnGameStart = function()
    print("[NPC Mod] Game started, mod loaded successfully")
end

-- Function to spawn the NPC
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
        npc:getInventory():AddItem("Base.Tshirt_Rock")
        print("[NPC Mod] NPC spawned successfully at " .. x .. ", " .. y .. ", " .. z)
    else
        print("[NPC Mod] Failed to spawn NPC")
    end
    return npc
end

-- Function to make NPC follow the player
NPCMod.FollowPlayer = function()
    if not NPCMod.npc or not getSpecificPlayer(0) then return end

    local player = getSpecificPlayer(0)
    local npc = NPCMod.npc

    local dx = player:getX() - npc:getX()
    local dy = player:getY() - npc:getY()


    local distance = math.sqrt(dx * dx + dy * dy)

    print("[NPC Mod] NPC position relative to player: " .. dx .. "," .. dy .. "," .. distance)

    -- Only follow if the player is more than a certain distance away
    if distance > 1 then
        -- Check if NPC is not already moving
        print("PLAYER", player)
        print("NPC", npc)


        if not npc:getPathFindBehavior2():isTargetLocation(player:getX(), player:getY(), player:getZ()) then
            print("SHOULD DO SOMETHING RIGHT")
            npc:getPathFindBehavior2():pathToLocation(player:getX(), player:getY(), player:getZ())
        end
    else
        -- Stop moving when close enough
        npc:getPathFindBehavior2():cancel()
    end

    print("STOP BANANA TIME")


    -- Make NPC face the player
    local angle = math.atan2(dy, dx)
    local angleInDegrees = math.deg(angle)
    if angleInDegrees < 0 then
        angleInDegrees = angleInDegrees + 360
    end

    local direction = nil

    if angleInDegrees >= 337.5 or angleInDegrees < 22.5 then
        direction = IsoDirections.E
    elseif angleInDegrees >= 22.5 and angleInDegrees < 67.5 then
        direction = IsoDirections.SE
    elseif angleInDegrees >= 67.5 and angleInDegrees < 112.5 then
        direction = IsoDirections.S
    elseif angleInDegrees >= 112.5 and angleInDegrees < 157.5 then
        direction = IsoDirections.SW
    elseif angleInDegrees >= 157.5 and angleInDegrees < 202.5 then
        direction = IsoDirections.W
    elseif angleInDegrees >= 202.5 and angleInDegrees < 247.5 then
        direction = IsoDirections.NW
    elseif angleInDegrees >= 247.5 and angleInDegrees < 292.5 then
        direction = IsoDirections.N
    elseif angleInDegrees >= 292.5 and angleInDegrees < 337.5 then
        direction = IsoDirections.NE
    end

    npc:setDir(direction)
end

-- Function called every game tick
NPCMod.OnTick = function()
    -- Timer management to trigger follow logic every 3 seconds
    NPCMod.timer = NPCMod.timer + getGameTime():getMultiplier()
    if NPCMod.timer >= NPCMod.FollowInterval then
        NPCMod.timer = 0 -- Reset the timer

        if not NPCMod.npc then
            -- Spawn NPC if it doesn't exist
            NPCMod.npc = NPCMod.SpawnNPC()
        else
            -- Make NPC follow the player
            NPCMod.FollowPlayer()
        end
    end
end

-- Register events
Events.OnGameStart.Add(NPCMod.OnGameStart)
Events.OnTick.Add(NPCMod.OnTick)

print("[NPC Mod] Script file loaded")
