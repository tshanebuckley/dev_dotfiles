SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ARCH=$(uname -m)
TAG="+3"
VERSION="1.1.2"
GHOSTTY_USER="${SCRIPT_DIR}/.flox/lib/${USER}"
GHOSTTY_LOCAL="${GHOSTTY_USER}/.local"
GHOSTTY_BIN="${GHOSTTY_LOCAL}/bin"
GHOSTTY_DIR="${GHOSTTY_BIN}/ghostty"

# make sure that the build output directory exists
# NOTE: we still manally ensure that these exist so we can idependenty re-install ghostty.
mkdir -p "$GHOSTTY_USER"
mkdir -p "$GHOSTTY_LOCAL"
mkdir -p "$GHOSTTY_BIN"

# directory to download the app image into
GHOSTTY="${SCRIPT_DIR}/ghostty_app"
# Make the download directory
mkdir -p "$GHOSTTY"
GHOSTTY_APP="${GHOSTTY}/Ghostty-${VERSION}-${ARCH}.AppImage"
# install ghostty if not installed
if [ ! -f "$GHOSTTY_APP" ]; then
    
    # Download the latest AppImage package from releases
    wget -O "${GHOSTTY_APP}" "https://github.com/psadi/ghostty-appimage/releases/download/v${VERSION}${TAG}/Ghostty-${VERSION}-${ARCH}.AppImage"

    # Make the AppImage executable
    chmod +x "${GHOSTTY_APP}"

    # Without sudo, XDG base spec mandate to install ghostty into the venv
    install "${GHOSTTY_APP}" $GHOSTTY_DIR
fi