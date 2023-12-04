os.loadAPI("disk/ticket_utils.lua")
os.loadAPI("disk/crowsdata.lua")

function take_ticket(amount)
    local take = take_tickets(amount)
    return take
end


function get_leaderboard(game_name)
    if not fs.exists("disk2/" .. game_name) then
        return false
    end

    local lb = crowsdata.load_data("disk2/" .. game_name)
    return lb
end

function save_leaderboard(new_leaderboard, game_name)
    crowsdata.save_data(new_leaderboard, "disk2/" .. game_name)
end


function table_len(table)
    local count = 0
    for _,_ in pairs(table) do
        count = count + 1
    end
    return count
end


function is_array(var) 
    local x = 1
    for _ in pairs(var) do
        if var[x] == nil then 
            return false
        end
        x = x + 1
    end
    return true
end


function dump_table(table, depth)
    local depth = depth or 0
    for k,v in pairs(table) do
        if type(v) == "table" then
            print(string.rep("  ", depth), k, "{")
            dump_table(v, depth+1)
            print(string.rep("  ", depth), "}")
        else
            print(string.rep("  ", depth), k, v)
        end
    end
end


function startup(file, debug_sequence)
    local debug_sequence = debug_sequence or "QUIT"
    debug_sequence = string.upper(debug_sequence)

    local function a()
        while true do
            os.run({}, file)
        end
    end

    local function b()
        local sequence = ""

        while true do
            local event, key, is_held = os.pullEventRaw("key", "terminate")
            if event == "key" and pcall(string.char,key) then
                local offset = math.max(#sequence+1 - #debug_sequence, 0)
                sequence = sequence:sub(1 + offset, #debug_sequence)
                sequence = sequence .. string.char(key)

                if sequence == debug_sequence then
                    term.clear()
                    return
                end
            end
        end
    end

    parallel.waitForAny(b,a)
end