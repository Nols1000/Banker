-- Register LibInventory with LibStub
local MAJOR, MINOR = "LibInventory", 1
local libInventory, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not libInventory then return end -- the same or new version of this lib is already loaded

local function NewItem(iBagId, iSlotId, iType, iId, iQuantity, iIcon)
    return {
		bagId    = iBagId,
		slotId   = iSlotId,
		itemType = iType,
        id       = iId,
        quantity = iQuantity,
		icon     = iIcon,
	}
end

function libInventory:GetAllItems(bagId)
    local items = {}
    local i = 0

    for slotId = 0, GetBagSize(bagId), 1 do
        local icon, stack, _, _, _, _ = GetItemInfo(bagId, slotId)
        local type, _ = GetItemType(bagId, slotId)
        local id = GetItemId(bagId, slotId)

        if id > 0 then
            items[i] = NewItem(bagId, slotId, type, id, stack, icon)
            i = i + 1
        end
    end

    return items
end

function libInventory:MoveItem(sourceBag, targetBag, sourceSlot, targetSlot, quantity)
    if GetItemId(sourceBag, sourceSlot) == 0 or GetItemId(targetBag, targetSlot) == 0 or quantity == 0 then
        return false
    end
    
    local result = true
    -- clear the cursor to later pickup a item by the cursor
    ClearCursor()
    -- pickup quantity amount of the item from the bag sourceBag and slot sourceSlot
    result = CallSecureProtected("PickupInventoryItem", sourceBag, sourceSlot, quantity)
    -- if the pickup was successful
    if result then
        -- drop the item into the bag targetBag and slot targetSlot
        result = CallSecureProtected("PlaceInInventory", targetBag, targetSlot)
    end
    -- clear the cursor after to avoid undefined behaivior
    ClearCursor()
    -- return if the the move was successful
    return result
end


function libInventory:Stack(sourceBag, targetBag, sourceSlot, targetSlot)
    local sStackSize = GetSlotStackSize(sourceBag, sourceSlot)
	local tStackSize, maxStackSize = GetSlotStackSize(targetBag, targetSlot)
	
	local stack      = (sStackSize + tStackSize) - maxStackSize

    if stack <= 0 and sStackSize > 0 then
        -- if stack is lower than 0 the full sources stack size fits the targets onto the target
        if self:MoveItem(sourceBag, targetBag, sourceSlot, targetSlot, sStackSize) then
            return sStackSize
        end
    elseif sStackSize > 0 then
        -- else if the sources stack size is greater than 0 the possible amount of items to complete the targets stack is calculated
        sStackSize = sStackSize - stack
        -- and if greater than 0 is moved onto the target
		if sStackSize > 0 then
            if self:MoveItem(sourceBag, targetBag, sourceSlot, targetSlot, sStackSize) then
                return sStackSize              
            end
		end
    end

    return 0
end