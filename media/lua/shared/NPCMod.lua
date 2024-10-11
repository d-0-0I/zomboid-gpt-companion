-- NPC Mod with ChatGPT Integration

if not NPCMod then NPCMod = {} end


NPCMod.SpawnDistance = 5
NPCMod.FollowInterval = 3 -- Time interval in seconds for following the player
NPCMod.timer = 0 -- Initialize a timer for controlling the follow frequency

-- Function called when the game starts
NPCMod.OnGameStart = function()
    print("[NPC Mod] Game started, mod loaded successfully")
end

-- Function to spawn the NPC as a zombie
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

    print("[NPC Mod] Spawning at coordinates: x=" .. x .. ", y=" .. y .. ", z=" .. z)
    local npc = createZombie(x, y, z, nil, 0, IsoDirections.S)
    if npc ~= nil then
        npc:setUseless(true) -- Make the zombie harmless
        npc:DoZombieStats() -- Apply zombie stats
        npc:setDir(IsoDirections.S) -- Set initial direction
        print("[NPC Mod] NPC spawned successfully at " .. x .. ", " .. y .. ", " .. z)
        NPCMod.npc = npc -- Store reference to the spawned NPC
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

    print(string.format("[NPC Mod] NPC position relative to player: dx=%.2f, dy=%.2f, distance=%.2f", dx, dy, distance))

    -- Only follow if the player is more than a certain distance away
    if distance > 1 then
        npc:pathToCharacter(player)
    end
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

-- Function to handle submitted input
NPCMod.OnInputSubmitted = function(target, button, text)
    local player = getSpecificPlayer(0)
    --     print("modlog2", target, button, button.parent.entry:getText(), containerObj)
    -- player:Say( button.parent.entry:getText())
    local text = button.parent.entry:getText()
    if text ~= "" then
        player:Say(text)
    end
end


-- Function to handle chat input
NPCMod.OnKeyPressed = function(key)
    local player = getSpecificPlayer(0)

    -- local function onSubmit(target, button, containerObj)
    --     print("modlog2", target, button, button.parent.entry:getText(), containerObj)

    --     player:Say( button.parent.entry:getText())
    -- end
    
    if key == Keyboard.KEY_TAB then
        local player = getSpecificPlayer(0)
        if not player or not NPCMod.npc then return end

        -- Create a simple input box using UIManager to get user input

        -- local modal =      ISTextBox:new(0, 0, 280, 150, label, name,nil, onRename, playerObj:getPlayerNum(), containerObj)
        local inputModal = ISTextBox:new(0, 0, 280, 180, "Enter your message to the NPC:", "", nil, NPCMod.OnInputSubmitted, player:getPlayerNum())
        inputModal:initialise()
        inputModal:addToUIManager()
    end
end

-- Function to get response from ChatGPT API
NPCMod.GetChatGPTResponse = function(userInput, callback)
    -- Placeholder for API call, assuming an asynchronous HTTP request
    -- Replace with actual API request code as needed
    print("[NPC Mod] Sending request to ChatGPT API with user input: " .. userInput)
    -- Simulate an asynchronous response with a delay
    local simulatedResponse = "This is a response from ChatGPT to: " .. userInput
    callback(simulatedResponse)
end

-- Function to display chat bubble above NPC
NPCMod.DisplayChatBubble = function(npc, text)
    if not npc then return end
    -- Placeholder function for displaying chat bubble above the NPC
    print("[NPC Mod] Displaying chat bubble: " .. text)
    -- Add actual code to create a visual chat bubble in the game
end

-- Register events
Events.OnGameStart.Add(NPCMod.OnGameStart)
Events.OnTick.Add(NPCMod.OnTick)
Events.OnKeyPressed.Add(NPCMod.OnKeyPressed)

print("[NPC Mod] Script file loaded")