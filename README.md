# A Neovim terminal plugin on crack!

Open a process or a shell easily as a:

- [x] float
- [x] splits
- [ ] new tab

That can use:

- [x] Neovim's default built in windows
- [x] Zellij's built-in windows
- [x] Tmux's built-in windows
- [ ] Kitty's built-in windows
- [ ] wezterm's built-in windows

## setup:

Using lazy.nvim:

```lua
{
    "ingenarel/smart-term.nvim",
    config = {
        floatHeightPercentage = 70, --optional for floating windows height percentage
        floatWidthPercentage = 80, --optional for floating windows width percentage

        splitHeightPercentage = 33, --optional for split panes height percentage
        splitWidthPercentage = 33, --optional for split panes width percentage

        floatNeovimXoffset = -2, --optional for floating neovim panes X offset by chars
        floatNeovimYoffset = -2, --optional for floating neovim panes Y offset by chars

        floatTmuxXoffset = -2, --optional for floating tmux panes X offset by chars
        floatTmuxYoffset = -2, --optional for floating tmux panes Y offset by chars

        floatZellijXoffset = -2, --optional for floating zellij panes X offset by chars
        floatZellijYoffset = 2, --optional for floating zellij panes Y offset by chars
    },
}
```

## Using:

### Open a floating terminal, depending on your enviroment:

```lua
require("smart-term").openFloaTerm{
    "btop", -- optional command, if not specified, opens the current $SHELL instead
    -- command = "btop", -- you can also use command="command", instead of using the first item as a command
    closeOnExit = true, -- if true, close the pane when the command exists,
    heightPercentage = 70, --optional height percentage
    widthPercentage = 70, --optional width percentage
    xOffset = -2, --optional for floating panes X offset by chars
    yOffset = -2, --optional for floating panes Y offset by chars
    stopVim = false, --optional if you want to stop nvim when the pane is running (works only for tmux and zellij)
}
```

This function, in turn, calls either `openNeovimFloaTerm()` or `openTmuxFloaTerm()` or `openZellijFloaTerm()` function

Examples: 

Automatically use tmux's display-popup feature
![tmux](pictures/tmux.png)

Automatically use Zellij's --floating feature
![zellij](pictures/zellij.png)

Automatically use Neovim's built-in floating windows
![nvim](pictures/nvim.png)

### Open a floating terminal, using Neovim's built-in terminal:

```lua
require("smart-term").openNeovimFloaTerm {
    "btop", -- optional command, if not specified, opens the current $SHELL instead
    -- command = "btop", -- you can also use command="command", instead of using the first item as a command
    closeOnExit = true, -- if true, close the pane when the command exists, default is true
    heightPercentage = 70, --optional height percentage, default is 70
    widthPercentage = 80, --optional width percentage, default is 80
    xOffset = -2, --optional for floating neovim panes X offset by chars, default is -2
    yOffset = -2, --optional for floating neovim panes Y offset by chars, default is -2
}
```
