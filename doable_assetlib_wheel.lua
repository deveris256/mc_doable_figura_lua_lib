--[[
Doable Assetlib Action Wheel

|| CreateActionWheelPage() returns a page
|| with Doable Assets.

]]

local clothPage = action_wheel:newPage()
local no_outfit = "_"

local M = {}
function M.CreateActionWheelPage()
    for outfit_id, outfit in pairs(DoableAssetManager.Assets) do
        clothPage:newAction()
            :setItem(outfit.display_item)
            :hoverColor(1, 0, 1)
            :setTitle(outfit.display_text)
            :setOnLeftClick(function(self)
                local slot = DoableSlotManager.Slots[outfit.slot_name]
                if slot.asset ~= outfit_id then
                    if host:isHost() then
                        slot.force_update = true
                        pings.SyncAllSlots(outfit.slot_name .. "\0" .. outfit_id, 1)

                        if outfit.save == true then
                            DoableSlotManager:saveSlotToConfig(outfit.slot_name, outfit_id)
                        end
                    end
                end
            end)

            :setOnRightClick(function(self)
                local slot = DoableSlotManager.Slots[outfit.slot_name]
                if slot.asset ~= nil then
                    if host:isHost() then
                        slot.force_update = true
                        pings.SyncAllSlots(outfit.slot_name .. "\0" .. no_outfit, 1)

                        if outfit.save == true then
                            DoableSlotManager:saveSlotToConfig(outfit.slot_name, no_outfit)
                        end
                    end
                end
            end)
    end

    return clothPage
end

return M
