--[[
Doable Utils
|| Contains utils used by some
|| of other Doable modules.


]] --

function Class()
    local cls = {}
    cls.__index = cls

    function cls:new(...)
        local i = {}
        if cls.init then cls.init(i, ...) end
        return setmetatable(i, cls)
    end

    return cls;
end
