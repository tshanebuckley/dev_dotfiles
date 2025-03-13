# dev_dotfiles

Dotfiles I use for my development environment.

Common tools used across operating systems are:
- [rio](https://rioterm.com/)
- [neovim](https://neovim.io/)
- some form of tiling window manager
- an application launcher
- some key-based screen search utility

Rio was chosen as it was the most feature-complete emulator I found across Windows, Mac, and Linux though I began with trying out [ghostty](https://ghostty.org/) through WSLg. GlazeWM at the time did not play nicely with WSLg apps, so I switched to rio as it runs natively on Windows. I have left the code related to ghostty here in case something in the future persuaded me to choose ghostty over rio.

# WSL

I typically just use Ubuntu for this. NOTE: This is not fully tested to be working on a new install, but should mostly work out of the box. It is not easy to keep windows installs purely scripted so my goal was just something to get me most of the way there.

For Windows machines using WSL, we use [GlazeWM](https://github.com/glzr-io/glazewm) as our tiling window manager and it is configured to start our dev environment through the rio terminal emulator. 

Because of this, WSL must be activated for your machine and the current user must be allowed to execute scripts. You may allow the user to run scripts by executing the following command:

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

As part of the setup for wsl, follow the linux steps from here.

You will likely need to do your base configuring of [Fluent Search](https://fluentsearch.net/), which we use as our application launcher and for the screen search functionality.

After this, it is recommended that you restart your computer.

# Linux (TODO)

Install [flox](https://flox.dev/docs/install-flox/) and set `LC_ALL=C` `LANG=en_US.UTF-8` in your `.bashrc` file (or whichever variables suit your needs, these are mainly to avoid perl warnings).

Clone the [dev_env](https://github.com/tshanebuckley/dev_env) repo. Export the `DOTFILES_URL` environment variable to this repo and run `bootstrap.sh`. 

## NOTE

Later, I intend to adapt this to work on a pure linux system instead of wsl. Most of the current setup should remain unchanged as I can just install rio natively and use gnu stow to set the config file (which can have platform specific configuration). I will likely just target NixOS for this, but realistically, any system where you can install flox should work. I would use NixOS mainly to allow system-wide configuration (hardware drivers, users, etc), while flox will be the tool I'd use for my user space.

# Mac

I do no intend to focus on macs unless work requires me to use a mac, but the abstractions already implented leave this option open.
