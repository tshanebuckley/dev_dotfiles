# get the script directory
if [[ -v SCRIPT_DIR ]]; then
    source $SCRIPT_DIR/.variables
else
    source .variables
fi
# activate starship
eval "$(starship init bash)"
# go to the HOME directory
cd $HOME
# start ghostty if this is the first started env
# if [[ ! -v GHOSTTY_BIN_DIR ]]; then
#     ghostty
# fi
if [[ -v SCRIPT_DIR ]]; then
   bash
fi