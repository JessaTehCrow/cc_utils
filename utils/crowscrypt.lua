local function string_value(str)
    val = 0
    for x=1, #string do
        val = val + string.byte(str:sub(x,x))
    end
    return val + #str
end


function tohash(item)
    local seed = nil
    if type(item) == "string" then
        seed = string_value(seed)
    elseif type(item) == "number" then
        seed = item
    else 
        return nil
    end

    local hash_chars = "abcedfg123456789"
    local length = 25
    local output = ""

    math.randomseed(seed)
    math.random()

    for x=1, length do
        local index = math.random(1, #hash_chars)
        output = output .. hash_chars:sub(index, index)
    end

    return output
end