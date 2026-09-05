function web
    switch $argv[1]
        case youtube yt
            setsid xdg-open "https://youtube.com" >/dev/null 2>&1 &

        case github gh
            setsid xdg-open "https://github.com" >/dev/null 2>&1 &

        case codeforces cf
            setsid xdg-open "https://codeforces.com" >/dev/null 2>&1 &

        case chatgpt chat
            setsid xdg-open "https://chatgpt.com" >/dev/null 2>&1 &

        case gmail mail
            setsid xdg-open "https://mail.google.com" >/dev/null 2>&1 &

        case reddit
            setsid xdg-open "https://reddit.com" >/dev/null 2>&1 &

        case bash-commands bashcmd
            setsid xdg-open "https://github.com/RehanSaeed/Bash-Cheat-Sheet/tree/main?search=1" >/dev/null 2>&1 &

        case google
            if test (count $argv) -gt 1
                set query (string join "+" $argv[2..-1])
                setsid xdg-open "https://www.google.com/search?q=$query" >/dev/null 2>&1 &
            else
                setsid xdg-open "https://google.com" >/dev/null 2>&1 &
            end

        case youtube-search ys
            if test (count $argv) -gt 1
                set query (string join "+" $argv[2..-1])
                setsid xdg-open "https://www.youtube.com/results?search_query=$query" >/dev/null 2>&1 &
            else
                setsid xdg-open "https://youtube.com" >/dev/null 2>&1 &
            end

        case classroom clr 
            setsid xdg-open "https://classroom.google.com/" >/dev/null 2>&1 &

        case brave bv
            setsid xdg-open "https://brave.com/" >/dev/null 2>&1 &
        case '*'
            echo "Unknown website: $argv[1]"
            echo ""
            echo "Available:"
            echo "  web youtube (yt)"
            echo "  web github (gh)"
            echo "  web bash-commands (bashcmd)" | lolcat
            echo "  web codeforces (cf)" | lolcat
            echo "  web chatgpt (chat)"
            echo "  web gmail (mail)"
            echo "  web reddit"
            echo "  web google <search>"
            echo "  web youtube-search <search> (ys)"
            echo "  web google-classroom (clr)"
            echo "  web brave (bv)"
      
    end
end
