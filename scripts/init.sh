#!/usr/bin/env sh

# Check if the blog.kanishkk.me directory exists if the os is Linux and if not, clone it from GitHub.
if [ "$(uname)" == "Linux" ]; then
    if [ -d "$HOME/Projects/blog.kanishkk.me" ]; then
        echo "Directory $HOME/Projects/blog.kanishkk.me exists."
    else
        echo "Directory $HOME/Projects/blog.kanishkk.me does not exist."
        echo "Creating directory $HOME/Projects/blog.kanishkk.me via cloning from GitHub https://github.com/Mr-Sunglasses/blog.kanishkk.me."
        mkdir -p "$HOME/Projects"
        git clone https://github.com/Mr-Sunglasses/blog.kanishkk.me "$HOME/Projects/blog.kanishkk.me"
        echo "Directory created successfully."
    fi
else
    echo "This script is intended to run on Linux systems only."
fi

# Check if the kanishkvault directory exists if the os is Linux and if not, clone it from GitHub.
if [ "$(uname)" == "Linux" ]; then
    if [ -d "$HOME/kanishkvault" ]; then
        echo "Directory $HOME/kanishkvault exists."
    else
        echo "Directory $HOME/kanishkvault does not exist."
        echo "Creating directory $HOME/kanishkvault via cloning from GitHub https://github.com/Mr-Sunglasses/kanishkvault."
        git clone https://github.com/Mr-Sunglasses/kanishkvault "$HOME/kanishkvault"
        echo "Directory created successfully."
    fi
else
    echo "This script is intended to run on Linux systems only."
fi

# check if alias exists in shell config file in linux and if not, add it
if [ "$(uname)" == "Linux" ]; then
    USER_SHELL=$(basename "$SHELL")
    CONFIG_FILE="$HOME/.${USER_SHELL}rc"
    ALIAS_ONE="alias syncblog='rsync -av --delete \"$HOME/kanishkvault/blog/\" \"$HOME/Projects/blog.kanishkk.me/content/posts/\"'"

    if ! grep -qF "$ALIAS_ONE" "$CONFIG_FILE"; then
        echo "Adding alias to $CONFIG_FILE"
        echo "$ALIAS_ONE" >>"$CONFIG_FILE"
    else
        echo "Alias $ALIAS_ONE already exists in $CONFIG_FILE"
    fi

    ALIAS_TWO="alias syncimage='python3 \"$HOME/Projects/blog.kanishkk.me/scripts/images.py\"'"
    if ! grep -qF "$ALIAS_TWO" "$CONFIG_FILE"; then
        echo "Adding alias to $CONFIG_FILE"
        echo "$ALIAS_TWO" >>"$CONFIG_FILE"
    else
        echo "Alias $ALIAS_TWO already exists in $CONFIG_FILE"
    fi
    echo "Aliases $ALIAS_ONE and $ALIAS_TWO added successfully."
else
    echo "This script is intended to run on Linux systems only."
fi
