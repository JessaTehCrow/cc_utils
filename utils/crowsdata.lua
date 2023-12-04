function save_data(data, filename)
    local file = fs.open(filename, "w")
    file.write(textutils.serialize(data))
    file.close()
end


function load_data(filename)
    if fs.exists(filename) == false then
        save_data({}, filename)
    end

    local file = fs.open(filename,"r")
    local data = file.readAll()
    file.close()
    return textutils.unserialize(data)
end