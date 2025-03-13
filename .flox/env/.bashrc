# get the script directory
if [[ -v SCRIPT_DIR ]]; then
    source $SCRIPT_DIR/.variables
    # we will always recopy the .env file here to ensure
    # that it is up to date for the started session
    cp "${DOTFILES}/.env" "${VENV_HOME}/.env"
else
    source .variables
fi
# source the .env variables
source .env
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
