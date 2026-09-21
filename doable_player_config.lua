--[[
Doable Player Config

|| Player configuration
|| for the doable suite.

]] --

local M = {}

M.DoableConfig = {
    --- Auto-generated Basename of the config for this specific model.
    --- Doable modules will append the module name to the config.
    --- E.g. for doable asset lib, it will become
    --- "DoableAssetLib_that_one_" if the avatar is named That One.
    config_basename = avatar:getName():lower():gsub("[^%w]+", "_"),
}

return M
