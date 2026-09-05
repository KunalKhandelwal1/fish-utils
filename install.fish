#!/usr/bin/env fish

set -l function_dir "$HOME/.config/fish/functions"

mkdir -p "$function_dir"

for file in functions/*.fish
    cp "$file" "$function_dir/"
end

echo "Fish utilities installed successfully!"
echo "Restart Fish or run:"
echo "source ~/.config/fish/config.fish"
