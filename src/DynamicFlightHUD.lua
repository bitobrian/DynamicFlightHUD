local isDevelopment = true
local maxBuffCount = 20
local dynamicFlightMountDb = {}
local isDbLoaded = false
local isMounted = false

function InitializeAddon(self)
    self:RegisterEvent("ADDON_LOADED")
end

function OnEventReceived(self, event, ...)
    if ( event == "ADDON_LOADED" ) then
        local arg1 = ...
        if ( arg1 == "DynamicFlightHUD" ) then
            Log(arg1)
            self:UnregisterEvent("ADDON_LOADED")
            self:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")

            -- Initialize the database
            if not dynamicFlightMountDb then
                dynamicFlightMountDb = {}
            end

            GetDynamicFlightMounts()
        end
    end
end

function OnMountEventReceived(self, event, ...)
    if ( event == "PLAYER_MOUNT_DISPLAY_CHANGED" ) then
        print("PLAYER_MOUNT_DISPLAY_CHANGED")
        isMounted = true
        IsDragonridingMount()
    end
end

-- Functions

function GetDynamicFlightMounts()
    local mountIds = C_MountJournal.GetMountIDs()

    Log("======== MOUNT COUNT ============")
    Log(#mountIds)

    -- check if mountIds is empty or nil
    if not mountIds then
        Log("No mounts found")
    end

    local count = 0

    for i = 1, #mountIds do
        local _, _, _, _, _, _, _, _, _, _, _, _, isForDragonriding = C_MountJournal.GetMountInfoByID(mountIds[i])

        if isForDragonriding then
            count = count + 1
            local mountName = C_MountJournal.GetMountInfoByID(mountIds[i])
            dynamicFlightMountDb[mountName] = true
        end
    end

    Log("======== DYNAMIC MOUNT COUNT ============")
    Log(count)

    isDbLoaded = true
    Log("Dynamic flight mount database loaded.")
end

function IsDragonridingMount()
    local currentMount = GetCurrentMountedMount()
    Log(currentMount)
    if currentMount then
        Log("Dynamic flight mount: " .. currentMount)
    else
        Log("Not a dynamic flight mount.")
    end
end

function GetCurrentMountedMount()
    local playerBuffs = {}

    -- Collect all buffs on the player
    for i = 1, maxBuffCount do
        local name, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if name then
            playerBuffs[spellID] = name
        end
    end

    -- print the buffs
    if isDevelopment then
        Log("======== PLAYER BUFFS ============")
        for k, v in pairs(playerBuffs) do
            print(k, v)
        end
    end

    -- Check if any of the buffs match our mount database
    for k, v in pairs(playerBuffs) do
        if dynamicFlightMountDb[v] then
            return v
        end
    end

    return nil -- No mount found
end

function Log(var)
    if isDevelopment then
        print(var)
    end
end