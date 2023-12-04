# Crowsui

- [Loading](#loading)
- [Terminology](#terminology)
- [Objects](#objects)
    - [Button](#button)
- [Functions](#functions)
    - [clear](#clear)
    - [fill](#fill)
    - [button](#button-1)
    - [draw_button](#draw_button)
    - [draw_buttons](#draw_buttons)
    - [handle_click](#handle_click)
    - [get_button_by_id](#get_button_by_id)

## Loading

`os.loadAPI("disk/crowsui.lua")`

## Terminology

- Pos
    - `{x, y}`
    - A table with x, y positions
- Size
    - `{w, h}`
    - A table with width, height

___

## Objects

- [button](#button)

### Button

`crowsui.button(. . .)`

- `button.callback`   
    - Callback function when button is clicked
- `button.text_align` 
    - Which side of the button the text is rendered (left, center, right)
- `button.text`       
    - Button text
- `button.fg`         
    - Button text color
- `button.bg`         
    - Button color
- `button.id`
    - Button backend id
- `button.pos`        
    - Button pos
- `button.width`      
    - Button Size

___

## Functions

- [clear](#clear)
- [fill](#fill)
- [button](#button-1)
- [draw_button](#draw_button)
- [draw_buttons](#draw_buttons)
- [handle_click](#handle_click)
- [get_button_by_id](#get_button_by_id)
- [cprint](#cprint)

### Clear

`crowsui.clear()`

> Clears screen

### fill

`crowsui.fill(Pos, Size, Color)`

> Fills a rectengular box starting from `Pos`, for `Size` rows/columns

- `pos` 
    - [Pos object](#terminology)
- `size`
    - [Size object](#terminology)

### button

`crowsui.button(pos, Size, text, text_align, callback, text_color, button_color`

> Create a button object

Returns: [Button object](#button)

- `pos` 
    - [Pos object](#terminology)
- `size`
    - [Size object](#terminology)
- `text`
    - String text for button
- `text_align`
    - Which side of the button to render the text
    - (left, center, right)
- `callback`
    - A callback function
    - Always calls with [button object](#button)
- `text_color`
    - Color for button text color
- `button_color`
    - Background color for button

### draw_button

`crowsui.draw_button(btn)`

> Draws button to screen

- `btn`
    - [Button object](#button)

### draw_buttons

`crowsui.draw_buttons(table)`

> Draw all buttons within table

- `table`
   - Table / Array with buttons 
   - If `nil`, all buttons will be drawn

### handle_click

`crowsui.handle_click(x, y)`

> Handles click event for `x`,`y`

- `x`
    - Click x position
- `y`
    - Click y position

### get_button_by_id

`crowsui.get_button_by_id(id)`

> Get button by ID

- `id`
    - Backend ID  for button

### cprint

`crowsui.cprint(text, fg_color, bg_color, pos)`

> Prints text with colors

- `text`
    - String text
-  `fg_color`
    - Text color
- `bg_color`
    - Background color
- `pos`
    - Position to print tex