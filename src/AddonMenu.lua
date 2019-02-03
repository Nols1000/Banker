-- Initalize Banker to use as table to store the addon in it.
if Banker == nil then Banker = {} end

Banker.menu = {
	
	panel = {
		type =               "panel",
		name =                Banker.Addon.displayName,
		author =              Banker.Addon.author,
		version =      	      Banker.Addon.version,
		slashCommand =        Banker.Addon.command,
		registerForRefresh =  true,
		registerForDefaults = true
	},
	
	settings = {
		
		[1] = {
			type = "header",
			name = GetString(SI_BANKER_HEADER_SETTINGS),
		},

		[2] = {
			type = "description",
			name = GetString(SI_BANKER_DESC_MAIN_TITLE),
			text = GetString(SI_BANKER_DESC_MAIN),
		},

		[3] = {
			type = "header",
			name = GetString(SI_BANKER_COMMON_TITLE),
		},

		[4] = {
			type  = "description",
			text  = GetString(SI_BANKER_COMMON_DESC),
		},

		[5] = {
			type = "checkbox",
			name = GetString(SI_BANKER_EITEMS_TITLE),
			tooltip = "",
			getFunc = function() return Banker:getConfigValue("items") end,
			setFunc = function(bool) Banker:setConfigValue("items", bool) end,
			default = function() return Banker:getDefaultConfigValue("items") end,
		},

		[6] = {
			type = "checkbox",
			name = GetString(SI_BANKER_MSG_TITLE),
			tooltip = "",
			getFunc = function() return Banker:getConfigValue("msg") end,
			setFunc = function(bool) Banker:setConfigValue("msg", bool) end,
			default = function() return Banker:getDefaultConfigValue("msg") end,
		},

		[7] = {
			type = "checkbox",
			name = GetString(SI_BANKER_DEBUG_TITLE),
			tooltip = "",
			getFunc = function() return Banker:getConfigValue("debug") end,
			setFunc = function(bool) Banker:setConfigValue("debug", bool) end,
			default = function() return Banker:getDefaultConfigValue("debug") end,
		},

		[8] = {
			type = "checkbox",
			name = GetString(SI_BANKER_KB_TITLE),
			tooltip = "",
			getFunc = function() return Banker:getConfigValue("keymenu") end,
			setFunc = function(bool) Banker:setConfigValue("keymenu", bool) end,
			default = function() return Banker:getDefaultConfigValue("keymenu") end,
		},

		[9] = {
			type = "slider",
			name = GetString(SI_BANKER_STEP_TITLE),
			max  = 1000,
			min  = 5,
			tooltip = "",
			getFunc = function() return Banker:getConfigValue("mStep") end,
			setFunc = function(bool) Banker:setConfigValue("mStep", bool) end,
			default = function() return Banker:getDefaultConfigValue("mStep") end,
		},

		[10] = {
			type = "slider",
			name = GetString(SI_BANKER_MIN_TITLE),
			max  = 10000,
			min  = 500,
			tooltip = "",
			getFunc = function() return Banker:getConfigValue("mMin") end,
			setFunc = function(bool) Banker:setConfigValue("mMin", bool) end,
			default = function() return Banker:getDefaultConfigValue("mMin") end,
		},

		[11] = {
			type = "header",
			name = GetString(SI_BANKER_ITEMTYPE_TITLE),
		},
		
		[12] = {
			type  = "description",
			text  = GetString(SI_BANKER_ITEMTYPE_DESC),
		},
	},
}

for i = 1, #LIB_INVENTORY_ITEMTYPES, 1 do
	Banker.menu.settings[#Banker.menu.settings + 1] = {
		type = "checkbox",
		name = GetString("SI_ITEMTYPE", LIB_INVENTORY_ITEMTYPES[i]),
		tooltip = "",
		getFunc = function()
			return Banker.variables.saved.iTypes[LIB_INVENTORY_ITEMTYPES[i]]
		end,
		setFunc = function(bool)
			Banker.variables.saved.iTypes[LIB_INVENTORY_ITEMTYPES[i]] = bool
		end,
		default = function()
			return Banker.variables.defaults.iTypes[LIB_INVENTORY_ITEMTYPES[i]]
		end
	}
end