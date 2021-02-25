#!/bin/bash
set -o errexit -o pipefail -o nounset

# symlink CNB directories into C:
mkdir -p         $HOME/.wine/drive_c/
ln -s /cnb       $HOME/.wine/drive_c/
ln -s /layers    $HOME/.wine/drive_c/
ln -s /platform  $HOME/.wine/drive_c/
ln -s /cache     $HOME/.wine/drive_c/
ln -s /workspace $HOME/.wine/drive_c/

# remove debug messages
export WINEDEBUG=fixme-all,-ole,+msgbox    # suppress non-fatal messages: "fixme:", "err:ole"; log all "invisible" msgbox messages & Structured Error Handling failures
export WINEDLLOVERRIDES="mscoree,mshtml="  # suppress wine-gecko messages

# start background Xvfb for wine X11 dependency
export DISPLAY=:0.0
nohup Xvfb :0 -screen 0 1024x768x16 -nolisten unix &

# start background socat to proxy between /var/run/docker.sock and tcp://localhost:2375, and override default //./pipe/docker_engine
socat TCP-LISTEN:2375,reuseaddr,fork,bind=127.0.0.1 UNIX-CLIENT:/var/run/docker.sock &
export DOCKER_HOST=tcp://localhost:2375

# run wine once before running lifecycle to isolate setup errors
if ! wine cmd /c exit 0 > /tmp/wine-build-init.log 2>&1; then
    echo "Wine stack wrapper failed to initialize:"
    cat /tmp/wine-build-init.log
    exit 1
fi

exec wine64 $0.exe $*
