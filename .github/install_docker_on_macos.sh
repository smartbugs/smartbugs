#/bin/sh
# From https://github.com/actions/runner/issues/1456
HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask docker
sudo /Applications/Docker.app/Contents/MacOS/Docker --unattended --install-privileged-components
open -a /Applications/Docker.app --args --unattended --accept-license
echo "We are waiting for Docker to be up and running. It can take over 2 minutes..."
while ! /Applications/Docker.app/Contents/Resources/bin/docker info &>/dev/null; do sleep 1; done


