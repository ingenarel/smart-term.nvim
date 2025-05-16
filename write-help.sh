#!/usr/bin/env bash

paraBreak="$(for ((i = 0; i < 78; i++)); do echo -n "="; done)"

#@formatter:off

# echo "$paraBreak"

echo "$(
    echo -en "*smart-term.nvim.txt*			    "
    sed -E "
        s/<!--.+//g;
        s/#\s*(\s*Neovim\s*terminal\s*.+)/\1\n$paraBreak/I;
        s/##\s*(setup):/$paraBreak\n\1                                                    *smart-term.nvim-setup*/I;
        /##\s*(using):/Id;
        /<summary>\s*floating\s*panes\s*<\/summary>/Id;
        /<summary>\s*split\s*panes\s*<\/summary>/Id;
        /<summary>\s*Images\s*<\/summary>/Id;
        /<summary>\s*automatically\s*use.+\s*<\/summary>/Id;
        /!\[.+\]\(.+\)/Id;
        s/\`\`\`(.+)/>\1/g;
        s/\`\`\`/</g;
        /<\/?details>/d;
        s/\s*<summary>\s*(.+)\s*<\/summary>/$paraBreak\n\1/I;
        s/(open.+floating\s*terminal.+environment)/                                                      *smart-term.nvim-floating*\n\n\1/I;
        s/(open.+floating\s*terminal.+neovim)/*smart-term.nvim-neovim-floating*                *smart-term.nvim-floating-neovim*\n\n\1/I;
        s/(open.+floating\s*terminal.+tmux)/*smart-term.nvim-tmux-floating*                    *smart-term.nvim-floating-tmux*\n\n\1/I;
        s/(open.+floating\s*terminal.+zellij)/*smart-term.nvim-zellij-floating*                *smart-term.nvim-floating-zellij*\n\n\1/I;
        s/(open.+split\s*terminal.+environment)/                                                         *smart-term.nvim-split*\n\n\1/I;
        s/(open.+split\s*terminal.+neovim)/*smart-term.nvim-neovim-split*                      *smart-term.nvim-split-neovim*\n\n\1/I;
        s/(open.+split\s*terminal.+tmux)/*smart-term.nvim-tmux-split*                          *smart-term.nvim-split-tmux*\n\n\1/I;
        s/(open.+split\s*terminal.+zellij)/*smart-term.nvim-zellij-split*                      *smart-term.nvim-split-zellij*\n\n\1/I;
        " README.md
        echo -e "\n\nvim:tw=78:ts=8:noet:ft=help:norl:"
    )" > ./doc/smart-term.nvim.txt
