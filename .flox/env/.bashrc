# get the script directory
#SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/.variables
# activate starship
eval "$(starship init bash)"
# start ghostty if this is the first started env
if [[ "$TERM" -ne "xterm-ghostty" ]]; then
    ghostty
fi