function pxy
    set -l BRAVE_FLAGS "$HOME/.config/brave-flags.conf"
    set -l CHROME_FLAGS "$HOME/.config/chrome-flags.conf"
    set -l PROXY_HOST ""
    set -l PROXY_PORT "PORT"

    switch "$argv[1]"
        case 1
            set PROXY_HOST "IP"
        case 2
            set PROXY_HOST "IP"
        case 0 off
            set PROXY_HOST ""
        case status ""
            if test -n "$http_proxy"
                echo "Proxy is currently ON: $http_proxy"
            else
                echo "Proxy is currently OFF"
            end
            return 0
        case '*'
            echo "Usage: pxy {1|2|off|status}"
            return 1
    end

    if test -n "$PROXY_HOST"
        set -l PROXY_URL "http://$PROXY_HOST:$PROXY_PORT"

        # 1. Export terminal environment variables universally
        set -Ux http_proxy $PROXY_URL
        set -Ux https_proxy $PROXY_URL
        set -Ux ftp_proxy $PROXY_URL
        set -Ux all_proxy $PROXY_URL
        set -Ux HTTP_PROXY $PROXY_URL
        set -Ux HTTPS_PROXY $PROXY_URL
        set -Ux FTP_PROXY $PROXY_URL
        set -Ux ALL_PROXY $PROXY_URL
        set -Ux no_proxy "localhost,127.0.0.1,::1,localaddress,.localdomain.com"
        set -Ux NO_PROXY "localhost,127.0.0.1,::1,localaddress,.localdomain.com"

        # 2. Linux System Settings
        if type -q gsettings
            gsettings set org.gnome.system.proxy mode 'manual'
            gsettings set org.gnome.system.proxy.http host $PROXY_HOST
            gsettings set org.gnome.system.proxy.http port $PROXY_PORT
            gsettings set org.gnome.system.proxy.https host $PROXY_HOST
            gsettings set org.gnome.system.proxy.https port $PROXY_PORT
        end

        # 3. Git Configuration
        git config --global http.proxy $PROXY_URL
        git config --global https.proxy $PROXY_URL

        # 4. Brave / Chrome Config Flags
        mkdir -p "$HOME/.config"
        for conf in $BRAVE_FLAGS $CHROME_FLAGS
            touch $conf
            sed -i '/--proxy-server/d' $conf
            sed -i '/--disable-quic/d' $conf
            echo "--proxy-server=$PROXY_URL" >> $conf
            echo "--disable-quic" >> $conf
        end

        echo "✓ Switched to Proxy $argv[1] ($PROXY_URL) [Persisted Globally]"
    else
        # Clear terminal environment variables universally
        set -e http_proxy https_proxy ftp_proxy all_proxy
        set -e HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY
        set -e no_proxy NO_PROXY

        # Reset Linux System Settings
        if type -q gsettings
            gsettings set org.gnome.system.proxy mode 'none'
        end

        # Reset Git
        git config --global --unset http.proxy 2>/dev/null
        git config --global --unset https.proxy 2>/dev/null

        # Remove Brave / Chrome Flags
        for conf in $BRAVE_FLAGS $CHROME_FLAGS
            if test -f $conf
                sed -i '/--proxy-server/d' $conf
                sed -i '/--disable-quic/d' $conf
            end
        end

        echo "✓ Proxy turned OFF [Persisted Globally]"
    end
end
