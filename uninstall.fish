#!/usr/bin/env fish

set -l function_dir "$HOME/.config/fish/functions"

for file in functions/*.fish
    set -l name (basename "$file")
    rm -f "$function_dir/$name"
end

echo "Fish utilities removed."
