function InitializeAddon(self)
    self:RegisterEvent("ADDON_LOADED")
end

function OnEventReceived(self, event, msg, author, ...)
    if (event == "ADDON_LOADED" and msg == "DynamicFlightHUD") then
        print("DynamicFlightHUD loaded")
        self:UnregisterEvent("ADDON_LOADED")
    end
end