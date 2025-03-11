# run any platform-specific bootstrap processes
if  [[ "$WSL" == "true" ]]; then # on windows using WSL
    source "./dotfiles/bootstrap/windows/bootstrap_windows.sh"
#else
    # ensure that ghostty is installed as our terminal emulator
    #source "./dotfiles/install_ghostty.sh"
fi
