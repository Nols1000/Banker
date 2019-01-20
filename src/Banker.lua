local LAM = LibStub("LibAddonMenu-2.0")
local LibInventory = LibStub("LibInventory")

Banker.isBankOpen = false

Banker.KeybindStripDescriptor = {
	{
		name = GetString("SI_BANKER_KB_SYNC_ITEMS"),
		keybind = "SYNC_INVENTORY",
		callback = function() Banker:stashItems() end,
		visible = function() return Banker.isBankOpen end,
	},
	{
		name = GetString("SI_BANKER_KB_SAFE_MONEY"),
		keybind = "AUTO_DEPOSIT_MONEY",
		callback = function() Banker:safeMoney() end,
		visible = function() return Banker.isBankOpen end,
	},
	alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

function Banker:initUI()
	self:onInventoryUpdate()

	LAM:RegisterAddonPanel("BankerSettings", self.menu.panel)
	LAM:RegisterOptionControls("BankerSettings", self.menu.settings)
end

function Banker:onLoaded(event, name)
	if name ~= "Banker" then return end

	self.variables.saved = ZO_SavedVars:New("BankerVariables", self.variables.version, nil, self.variables.defaults)
	self.variables.saved.lang = GetCVar("language.2") or "en"

	if self:getConfigValue("lang") ~= "en" or self:getConfigValue("lang") ~= "de" or self:getConfigValue("lang") ~= "fr" then
		self:mDebug("%s is not supported. Banker will use standard language (en).", self:getConfigValue("lang"))
	end

	self:initUI()
end

function Banker:onOpenBank()
	self:toggleSyncBinding()

	if self:getConfigValue("items") then
		self:stashItems()
	end

	if self:getConfigValue("money") then
		self:safeMoney()
	end
end

function Banker:onCloseBank()
	self:toggleSyncBinding()
end

function Banker:GetPotentialFreeBagSlots(sourceBagId, targetBagId)
	local freeable = 0

	local sourceBagItems = LibInventory:GetAllItems(sourceBagId)
	local targetBagItems = LibInventory:GetAllItems(targetBagId)

	local typeSettings = self:getConfigValue("iTypes")

	for i = 0, #sourceBagItems, 1 do
		for k = 0, #targetBagItems, 1 do
			if sourceBagItems[i].id == targetBagItems[k].id then
				if typeSettings[sourceBagItems[i].itemType] then
					local sStackSize = GetSlotStackSize(sourceBagId, sourceBagItems[i].slotId)
					local tStackSize, maxStackSize = GetSlotStackSize(targetBagId, targetBagItems[k].slotId)
					
					local stack      = (sStackSize + tStackSize) - maxStackSize

					if stack <= 0 then
						freeable = freeable + 1
					end
				end
			end
		end
	end

	return freeable
end

function Banker:stashItems() 
	self:stackItems(BAG_BACKPACK, BAG_BANK)
	if IsESOPlusSubscriber() then
		self:stackItems(BAG_BACKPACK, BAG_SUBSCRIBER_BANK)
	end
end

function Banker:stackItems(backpackBagId, bankBagId)
	local bankItems = LibInventory:GetAllItems(bankBagId)
	local backpackItems = LibInventory:GetAllItems(backpackBagId)

	local typeSettings = self:getConfigValue("iTypes")

	for i = 0, #backpackItems, 1 do
		for k = 0, #bankItems, 1 do
			if backpackItems[i].id == bankItems[k].id then
				if typeSettings[backpackItems[i].itemType] then
					self:stack(BAG_BACKPACK, BAG_BANK, backpackItems[i].slotId, bankItems[k].slotId)
				end
			end
		end
	end
end

function Banker:stack(fromBag, toBag, fromSlot, toSlot)
	local link = GetItemLink(fromBag, fromSlot)

	local amount = LibInventory:Stack(fromBag, toBag, fromSlot, toSlot)

	if amount > 0 then 
		self:msg("%s x [%s] was added to the bank.", amount, link)
	else
		self:msg("%s wasn't added to the bank.", link)
	end
end

function Banker:safeMoney()
	local bankMoney = GetBankedMoney()
	local playerMoney = GetCurrentMoney()

	local mMin = self:getConfigValue("mMin")
	local mStep = self:getConfigValue("mStep")

	if playerMoney > mMin then
		local n = math.floor((playerMoney - mMin) / mStep )

		if n > 0 then
			local tMoney = n * mStep

			DepositMoneyIntoBank(tMoney)
			self:msg("%s |t16:16:EsoUI/Art/currency/currency_gold.dds|t were transferd to your bank.", tMoney)
		end
	end
end

function Banker:toggleSyncBinding()
	self.isBankOpen = not self.isBankOpen
	
	if self:getConfigValue("keymenu") then
		if self.isBankOpen then
			KEYBIND_STRIP:AddKeybindButtonGroup(self.KeybindStripDescriptor)
			KEYBIND_STRIP:UpdateKeybindButtonGroup(self.KeybindStripDescriptor)
		else
			KEYBIND_STRIP:RemoveKeybindButtonGroup(self.KeybindStripDescriptor)
		end
	end
end

function Banker:onInventoryUpdate()
	local bankUsedSlots = GetNumBagUsedSlots(BAG_BANK)
	local bankUseableSize = GetBagUseableSize(BAG_BANK)

	if IsESOPlusSubscriber() then
		bankUsedSlots = bankUsedSlots + GetNumBagUsedSlots(BAG_SUBSCRIBER_BANK)
		bankUseableSize = bankUseableSize + GetBagUseableSize(BAG_SUBSCRIBER_BANK)
	end

	if bankUsedSlots < bankUseableSize then
		BankSpaceViewLabel:SetText(string.format("%s/%s", bankUsedSlots, bankUseableSize))
	else
		BankSpaceViewLabel:SetText(string.format("|cFF0000%s/%s|r", bankUsedSlots, bankUseableSize))
	end

	local backpackUsedSlots = GetNumBagUsedSlots(BAG_BACKPACK)
	local backpackUseableSize = GetBagUseableSize(BAG_BACKPACK)

	local potentialFreeBackpackSlots = self:GetPotentialFreeBagSlots(BAG_BACKPACK, BAG_BANK)

	if potentialFreeBackpackSlots > 0 then
		BackpackSpaceViewLabel:SetText(string.format("%s (|c00FF00-%s|r)/%s", backpackUsedSlots, potentialFreeBackpackSlots, backpackUseableSize))
	else
		BackpackSpaceViewLabel:SetText(string.format("%s/%s", backpackUsedSlots, backpackUseableSize))
	end

	GoldViewLabel:SetText(string.format("|cFFD700%s|r - |cFFD700%s|r", GetBankedMoney(), GetCurrentMoney()))
end

EVENT_MANAGER:RegisterForEvent("BankerOnInventoryFullUpdate", EVENT_INVENTORY_FULL_UPDATE, function() Banker:onInventoryUpdate() end)
EVENT_MANAGER:RegisterForEvent("BankerOnInventorySingleSlotUpdate", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function() Banker:onInventoryUpdate() end)
EVENT_MANAGER:RegisterForEvent("BankerOnBankOpen", EVENT_OPEN_BANK, function() Banker:onOpenBank() end)
EVENT_MANAGER:RegisterForEvent("BankerOnBankClose", EVENT_CLOSE_BANK, function() Banker:onCloseBank() end)
EVENT_MANAGER:RegisterForEvent("BankerOnLoad", EVENT_ADD_ON_LOADED, function(event, name) Banker:onLoaded(event, name) end)