local isMountedBro = false

function InitializeAddon(self)
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED") -- Fired when the player mounts or dismounts
end

function OnEventReceived(self, event, ...)
    print(isMountedBro)
    if ( event == "PLAYER_MOUNT_DISPLAY_CHANGED" ) then
        print("PLAYER_MOUNT_DISPLAY_CHANGED")
	end
end