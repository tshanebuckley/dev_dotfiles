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
# To accomplish this, the "GHOSTTY_DIR" directory in the bin must be removed before re-
# executing this script.
mkdir -p "$GHOSTTY_USER"
mkdir -p "$GHOSTTY_LOCAL"
mkdir -p "$GHOSTTY_BIN"

# install ghostty if not installed
if [ ! -f "$GHOSTTY_DIR" ]; then
    # Create a directory to install the app image into and cd there
    GHOSTTY="${SCRIPT_DIR}/ghostty"
    mkdir -p "$GHOSTTY"
    cd $GHOSTTY

    # Download the latest AppImage package from releases
    wget -O https://github.com/psadi/ghostty-appimage/releases/download/v${VERSION}${TAG}/Ghostty-${VERSION}-${ARCH}.AppImage

    # Make the AppImage executable
    chmod +x Ghostty-${VERSION}-${ARCH}.AppImage

    # Without sudo, XDG base spec mandate to install ghostty into the venv
    install ./Ghostty-${VERSION}-${ARCH}.AppImage $GHOSTTY_DIR

    # return to the script's directory
    cd $SCRIPT_DIR
fi