function get_item(chest, item)
    local items = chest.list()

    for s, i in pairs(items) do
        if i.name == item then
            return {slot=s, item=i}
        end
    end
end


function has_item(chest, item)
    local items = chest.list()

    for s, i in pairs(items) do 
        if i["name"] == item then
            return true
        end
    end
    return false
end


function space_available(chests)
    for i,v in ipairs(chests) do
        local size = v.size()
        local items = v.list()
        if size > #items then 
            return v
        end
    end
end


function move_slot(from, to, slot, amount)
    if amount > 64 then
        error("Cannot move more than 64 at a time")
    end
    to.pullItems(peripheral.getName(from), slot, amount)
end


function move(from, to, item_name, amount)
    local item = get_item(from, item_name)
    if amount > 64 then
        error("Cannot move more than 64 at a time")
    end
    to.pullItems(peripheral.getName(from), item.slot, amount)
end


function get_player_slot(inv_manager, slot) 
    local items = inv_manager.getItems()

    for _,i in ipairs(items) do
        if i.slot == slot then
            return i
        end
    end
end


function move_from_player_slot(inv_manager, local_chest, slot, amount, chest)
    if amount > 64 then
        error("Cannot move more than 64 at a time")
    end
    local item = get_player_slot(inv_manager, slot)
    inv_manager.removeItemFromPlayer("down", {name=item.name, fromSlot=slot, count=amount})
    move(local_chest, chest, item.name, amount)
end


function move_from_player(inv_manager, local_chest, item_name, amount, chest)
    if amount > 64 then
        error("Cannot move more than 64 at a time")
    end
    inv_manager.removeItemFromPlayer("down", {name=item_name, count=amount})
    move(local_chest, chest, item_name, amount)
end


function move_to_player(inv_manager, local_chest, from_chest, amount, item_name)
    if amount > 64 then
        error("Cannot move more than 64 at a time")
    end
    move(from_chest, local_chest, item_name, amount)
    inv_manager.addItemToPlayer("down", {name=item_name, count=amount})
end