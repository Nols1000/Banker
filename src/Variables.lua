-- Initalize Banker to use as table to store the addon in it.
if Banker == nil then Banker = {} end

-- Addons Variables
Banker.variables = {
    version = 200,
    defaults = {
        items = true,
        money = true,
        debug = true,
        msg = true,
        mStep = 50,
        mMin = 500,
        updated = false,
        iTypes = {},
    },
    saved = {},
}

for i = 1, #LIB_INVENTORY_ITEMTYPES, 1 do
    Banker.variables.defaults.iTypes[LIB_INVENTORY_ITEMTYPES[i]] = true
end