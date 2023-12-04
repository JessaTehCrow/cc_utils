local buttons = {}

local function len(table)
    local count = 0
    for _,_ in pairs(table) do
        count = count + 1
    end
    return count
end


function clear()
    term.clear()
    term.setCursorPos(1,1)
end


function cprint(text, fg, bg, pos)
    local old_bg = term.getBackgroundColor()
    local old_fg = term.getTextColor()
    local old_x,old_y = term.getCursorPos()
    local fg = fg or old_fg
    local bg = bg or old_bg

    term.setCursorPos(pos[1], pos[2])
    term.setBackgroundColor(bg)
    term.setTextColor(fg)
    print(text)
    term.setBackgroundColor(old_bg)
    term.setTextColor(old_fg)
    term.setCursorPos(old_x, old_y)
end


function fill(pos, width, color)
    local old_bg = term.getBackgroundColor()
    local cx, cy = term.getCursorPos()
    local sx, sy = term.getSize()

    if width[1] == -1 then
        width[1] = sx - pos[1] + 1
    end
    if width[2] == -1 then
        width[2] = sy - pos[2] + 1
    end

    local endx = pos[1] + width[1]-1
    local endy = pos[2] + width[2]-1
    paintutils.drawFilledBox(pos[1], pos[2], endx, endy, color)

    term.setBackgroundColor(old_bg)
    term.setCursorPos(cx, cy)
end


function button(pos, width, text, text_align, callback, text_color, button_color)
    text = text or ""
    text_color = text_color or colors.white
    button_color = button_color or colors.gray

    local button = {}
    local id = #buttons + 1
    
    button.callback = callback
    button.text_align = text_align
    button.text = text
    button.fg = text_color
    button.bg = button_color
    button.id = id
    button.pos = pos
    button.width = width

    buttons[id] = button
    return button
end


function draw_button(btn) 
    local old_bg = term.getBackgroundColor()
    local old_fg = term.getTextColor()

    fill(btn.pos, btn.width, btn.bg)
    term.setTextColor(btn.fg)
    term.setBackgroundColor(btn.bg)

    local xpos = 0
    local ypos = 0

    if btn.text_align == "center" then
        xpos = math.floor((btn.width[1] / 2) - (#btn.text / 2))
        ypos = math.floor(btn.width[2] / 2)
    elseif btn.text_align == "right" then
        xpos = btn.width[1] - #btn.text
        ypos = btn.width[2]
    end

    term.setCursorPos(btn.pos[1] + xpos, btn.pos[2] + ypos)
    print(btn.text)
    term.setBackgroundColor(old_bg)
    term.setTextColor(old_fg)
end


function draw_buttons(table)
    if table == nil then 
        table = buttons
    end

    for i,btn in ipairs(table) do
        draw_button(btn)
    end
end


function handle_click(x, y)    
    for i, btn in ipairs(buttons) do
        if x - btn.pos[1] <= btn.width[1] and y - btn.pos[2] <= btn.width[2] then
            if btn.callback ~= nil then
                btn.callback(btn)
            end
            break
        end
    end
end


function get_button_by_id(id)
    return buttons[id]
end