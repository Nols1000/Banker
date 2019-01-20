-- Initalize Banker to use as table to store the addon in it.
if Banker == nil then Banker = {} end

-- Reset SavedVariables to default
function Banker:resetAddonMenu()
  self.variables.saved = self.variables.defaults
end

-- Get SavedVariable by key
function Banker:getConfigValue(key)
  return self.variables.saved[key]
end

-- Get SavedVariable default value by key
function Banker:getDefaultConfigValue(key)
  return self.variables.defaults[key]
end

-- Set SavedVariable to value by key
function Banker:setConfigValue(key, value)
  self.variables.saved[key] = value
end