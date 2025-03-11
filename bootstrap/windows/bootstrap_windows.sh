# get the path to the windows user home
WIN_HOME="$(wslpath "$(powershell.exe -Command 'echo $env:USERPROFILE')" | tr -d '\r')"
# get the dotfiles path from linux
UNIX_SCRIPTS="${DOTFILES}/bootstrap/windows"
# convert the path to a linux path
WIN_SCRIPTS=$(wslpath -w $UNIX_SCRIPTS)
# copy config for glzr apps (GlazeWM and Zebar)
cp -r "${DOTFILES}/glzr/.glzr" "${WIN_HOME}/.glzr"
# copy the config for rio
cp -r "${DOTFILES}/rio/rio" "${WIN_HOME}/AppData/Local/rio"
# copy the config for ueli
cp -r "${DOTFILES}/ueli" "${WIN_HOME}/AppData/Roaming/ueli"
# scoop install script
SCOOP_INSTALL="${WIN_SCRIPTS}\\install_scoop.ps1"
# powershell bootstrap script
PS_BOOTSTRAP="${WIN_SCRIPTS}\\bootstrap_windows.ps1"
# ensure that scoop is installed
powershell.exe -ExecutionPolicy Bypass -FILE "${SCOOP_INSTALL}"
# run the bootstrap script to install our dependencies with scoop
powershell.exe -ExecutionPolicy Bypass -FILE "${PS_BOOTSTRAP}"