os.loadAPI("disk/crowsdata.lua")
os.loadAPI("disk/storage_utils.lua")

local chest_file = fs.open("chest.lua", "r")
local local_chest_name = chest_file.readLine()
chest_file.close()


inv_manager = peripheral.wrap("bottom")
speaker = peripheral.wrap("top")
local_chest = peripheral.wrap(local_chest_name)

ticket_chests = {peripheral.find("ironchest:gold_chest")}
dirty_chests  = {peripheral.find("ironchest:diamond_chest")}
money_chests  = {peripheral.find("ironchest:obsidian_chest")}

exchange = {
    ["libraryferret:iron_coins_jtl"] = 0.5,
    ["libraryferret:gold_coins_jtl"] = 0.5,
    ["libraryferret:emerald_coins_jtl"] = 1,
    ["libraryferret:diamond_coins_jtl"] = 3,
    ["libraryferret:netherite_coins_jtl"] = 9
}


function valid_hash(hash)
    local db = crowsdata.load_data("disk/database/ticket_database")
    return db[hash] ~= nil
end


function valid_ticket(hash)
    local db = crowsdata.load_data("disk/database/ticket_database")

    if valid_hash(hash) and db[hash][2] == false then
        return true
    end
    
    return false
end


function get_user_tickets()
    local db = crowsdata.load_data("disk/database/ticket_database")
    local inv_owner = inv_manager.getOwner()
    local items = inv_manager.getItems()

    local tickets = {}
    for i,s in ipairs(items) do
        if s.name == "computercraft:printed_page" and s.nbt.Title == "Ticket" then
            local ticket = {}
            ticket.slot = s.slot
            ticket.owner = inv_owner
            ticket.hash = s.nbt.Text19
            ticket.valid = valid_ticket(s.nbt.Text19)
            ticket.title = s.nbt.Title
            tickets[#tickets+1] = ticket
        end
    end
    return tickets
end


function get_valid_tickets()
    local tickets = get_user_tickets()
    local out = {}

    for i,t in ipairs(tickets) do
        if t.valid then
            out[#out+1] = t
        end
    end
    return out
end


function pull_invalid()
    local all_tickets = get_user_tickets()

    for i,p in ipairs(all_tickets) do
        if not p.valid then
            storage_utils.move_from_player_slot(inv_manager, local_chest, p.slot, 1, storage_utils.space_available(dirty_chests))
        end
    end
end


function get_stored_coins()
    local total_value = 0
    
    local temp = {}
    for i,c in ipairs(money_chests) do
        local items = c.list()

        for s,i in pairs(items) do
            if exchange[i.name] ~= nil then
                if temp[i.name] == nil then
                    temp[i.name] = {value=exchange[i.name], count=i.count}
                else
                    temp[i.name].count = temp[i.name].count + i.count
                end
            end
            total_value = total_value + exchange[i.name] * i.count
        end
    end
    
    local coins = {}
    for k,v in pairs(temp) do
        coins[#coins+1] = {name=k, value=v.value, count=v.count}
    end

    table.sort(coins, function(a,b) return a.value > b.value end)
    return {total_value=total_value, coins=coins}
end


function get_coins()
    local items = inv_manager.getItems()
    local total_value = 0
    
    local temp = {}
    for i,s in ipairs(items) do 
        if exchange[s.name] ~= nil then
            if temp[s.name] == nil then
                temp[s.name] = {value=exchange[s.name], count=s.count}
            else
                temp[s.name].count = temp[s.name].count + s.count
            end
            total_value = total_value + exchange[s.name] * s.count
        end
    end

    local coins = {}
    for k,v in pairs(temp) do 
        coins[#coins+1] = {name=k, value=v.value, count=v.count}
    end

    table.sort(coins, function (a, b) return a.value > b.value end)

    return {total_value=total_value, coins=coins}
end


function get_payment(value, coins, precise)
    local coins = coins or get_coins().coins 
    local precise = precise or false
    local new_value = value
    local spend = {}

    for i,coin in ipairs(coins) do
        local amount = math.floor(new_value / coin.value)
        amount = math.min(amount, coin.count)
        
        if amount > 0 then
            spend[coin.name] = amount
            new_value = new_value - coin.value * amount
            coins[i].count = coins[i].count - amount
        end
        
        if new_value == 0 then
            return {spend=spend, excess=0}
        end
    end

    -- Cannot fit exactly, so return nil
    if precise then 
        return nil
    end

    -- Don't have exact fit, so excessive coins will be used
    for i=1, #coins do
        local coin = coins[#coins+1-i]

        if coin.count > 0 and coin.value >= new_value then
            spend[coin.name] = (spend[coin.name] or 0) + 1
            new_value = new_value - coin.value
        end

        if new_value <= 0 then
            return {spend=spend, excess=math.abs(new_value)}
        end
    end

    return nil
end


function give_item(chests, item, amount) 
    for i,c in ipairs(chests) do
        local has_item = storage_utils.has_item(c, item)
        if has_item == true then
            storage_utils.move_to_player(inv_manager, local_chest, c, amount, item)
            return
        end
    end
end


function take_tickets(amount)
    local tickets = get_valid_tickets()
    if #tickets < amount then
        return false
    end
    local db = crowsdata.load_data("disk/database/ticket_database")

    for i,t in ipairs(tickets) do
        local ticket_chest = storage_utils.space_available(ticket_chests)
        db[t.hash] = {db[t.hash][1], true}
        storage_utils.move_from_player_slot(inv_manager, local_chest, t.slot, 1, ticket_chest)

        if i  == amount then
            crowsdata.save_data(db, "disk/database/ticket_database")
            return true
        end
    end

    -- Should never get here, but just in case
    return false
end


function give_tickets(amount)
    for i=1, amount do 
        give_item(ticket_chests, "computercraft:printed_page", 1)
    end
    local new_tickets = get_user_tickets()
    local db = crowsdata.load_data("disk/database/ticket_database")
    for i,t in ipairs(new_tickets) do
        db[t.hash] = {db[t.hash][1], false}
    end
    crowsdata.save_data(db, "disk/database/ticket_database")
end


function pay(amount)
    local player_coins = get_coins()
    local store_coins = get_stored_coins()

    if player_coins.total_value < amount then
        return false
    end

    local payment = get_payment(amount, player_coins.coins)

    local change = nil
    if payment.excess > 0 then
        change = get_payment(payment.excess, store_coins.coins)
        if change == nil then
            return false
        end
    end

    for k,v in pairs(payment.spend) do
        local free_chest = storage_utils.space_available(money_chests)
        storage_utils.move_from_player(inv_manager, local_chest, k, v, free_chest)
    end

    if change ~= nil then
        for k,v in pairs(change.spend) do
            give_item(money_chests, k, v)
        end
    end

    return {paid=amount, change=payment.excess}
end 