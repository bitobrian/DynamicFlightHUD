local isDevelopment = true
local maxBuffCount = 20
local dynamicFlightMountDb = {}

-- Init

function InitializeAddon(self)
    self:RegisterEvent("ADDON_LOADED")
end

-- Events

function OnEventReceived(self, event, ...)
    if ( event == "ADDON_LOADED" ) then
        local arg1 = ...
        if ( arg1 == "DynamicFlightHUD" ) then
            Log("Dynamic Flight HUD loaded.")
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

    Log("Dynamic flight mount database loaded.")
end

function IsDragonridingMount()
    local currentMount = GetCurrentMountedMount()
    if currentMount then
        Log("Dynamic flight mount: " .. currentMount)
    else
        Log("Non-Dynamic flight mount")
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

    -- Check if any of the buffs match our mount database
    for k, v in pairs(playerBuffs) do
        if dynamicFlightMountDb[v] then
            return v
        end
    end

    return nil
end

function Log(var)
    if isDevelopment then
        print(var)
    end
end