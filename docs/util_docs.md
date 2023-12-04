# utils

## Loading

`os.loadAPI("disk/crowsutils.lua")`

## Functions

- [take_ticket](#take_ticket)
- [get_leaderboard](#get_leaderboard)
- [save_leaderboard](#save_leaderboard)
- [table_len](#table_len)
- [is_array](#is_array)
- [dump_table](#dump_table)
- [startup](#startup)

### take_ticket

`crowsutils.take_ticket(amount)`

> Takes tickets from player

> Returns false if it user did not have enough tickets
> Returns true if it succeeded

- `amount`
    - Amount of tickets in int

### get_leaderboard

`crowsutils.get_leaderboard(game_name)`

> Loads leaderboard from database

> Returns false if a leaderboard it doesn't exist

- `game_name`
    - Name of the game to get the leaderboards for

### save_leaderboard

`crowsutils.save_leaderboard(leaderboard, game_name)`

> Saves leaderboard to database

- `leaderboard`
    - A table of values for leaderboard

- `game_name`
    - Name of the game to save the leaderboards for

### table_len

`crowsutils.table_len(table)`

> Get length of named table

- `table`
    - Named table

### is_array

`crowsutils.is_array(table)`

> Checks if table is named or iterative

> Returns false if it has named values

- `table`
    - Table to test

### dump_table

`crowsutils.dump_table(table)`

> Prints full table to the display

- `table`
    - Table to display

### startup

`crowsutils.startup(file, exit_sequence="quit")`

> Makes a program run, with no chance of getting out without the exit_sequence

> Exit sequence is "quit" by default

- `file`
    - Sartup file to run
- `exit_sequence`
    - Any string