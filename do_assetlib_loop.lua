local timer = 5.7 * 20
local max = 6 * 20 - 1
local no_outfit = "_"
local outfit_sep = "\0"

if host:isHost() then
    events.ENTITY_INIT:register(function()
        DoableSlotManager:LoadAllFromConfig()

        events.TICK:register(function()
            if timer >= max then
                local outfit_slot_ids = {}

                for slot_name in pairs(DoableSlotManager.Slots) do
                    outfit_slot_ids[#outfit_slot_ids + 1] = slot_name
                    outfit_slot_ids[#outfit_slot_ids + 1] = DoableSlotManager.Slots[tostring(slot_name)].asset or
                        no_outfit
                end

                if #outfit_slot_ids == 0 then return end

                pings.SyncAllSlots(
                    table.concat(outfit_slot_ids, outfit_sep, 1, #outfit_slot_ids),
                    #outfit_slot_ids * 0.5
                )

                timer = 1
            else
                timer = timer + 1
            end
        end)
    end)
end

--- this synchronizes all slots
function pings.SyncAllSlots(outfit_slot_bytes, count)
    local outfit_slot_names = string.gmatch(outfit_slot_bytes, "([^" .. outfit_sep .. "]+)")

    local slot_outfit_names = {}

    for _ = 1, count do
        local slot_name = tostring(outfit_slot_names())
        local outfit_name = tostring(outfit_slot_names())
        slot_outfit_names[slot_name] = outfit_name
    end

    for slot_name, outfit_name in pairs(slot_outfit_names) do
        if outfit_name == no_outfit then
            outfit_name = nil
        end

        local slot = DoableSlotManager.Slots[slot_name]

        local old_asset = DoableAssetManager.Assets[slot.asset]
        local new_asset = DoableAssetManager.Assets[outfit_name]

        if (slot.force_update == true) or (slot.asset ~= outfit_name) then
            -- applying slot
            if old_asset ~= nil then
                -- disable model parts
                if old_asset.model_parts ~= nil then
                    for _, model_part in ipairs(old_asset.model_parts) do
                        model_part:setVisible(false)
                    end
                end

                -- disable persistent animations
                if old_asset.persistent_animations ~= nil then
                    for _, anim in ipairs(old_asset.persistent_animations) do
                        anim:setPlaying(false)
                        anim:stop()
                    end
                end
                local callback = old_asset.callbacks["on_toggle"]
                if callback ~= nil then
                    pcall(callback, old_asset, false)
                end
            end

            if new_asset ~= nil then
                if new_asset.model_parts ~= nil then
                    for _, model_part in ipairs(new_asset.model_parts) do
                        model_part:setVisible(true)
                    end
                end

                -- enable persistent animations
                if new_asset.persistent_animations ~= nil then
                    for _, anim in ipairs(new_asset.persistent_animations) do
                        if anim:isPlaying() == false then
                            anim:play()
                        end
                    end
                end

                local callback = new_asset.callbacks["on_toggle"]
                if callback ~= nil then
                    pcall(callback, new_asset, true)
                end
            end

            slot.force_update = false

            slot.asset = outfit_name
        end
    end
end
