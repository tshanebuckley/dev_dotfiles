# dev_dotfiles

Dotfiles I use for my development environment.

# WSL

For Windows machines using WSL, we use [GlazeWM](https://github.com/glzr-io/glazewm) as our tiling window manager and it is configured to start our dev
environment through the ghostty terminal emulator.

Because of this, WSL must be activated for your machine and the current user must be allowed to execute scripts. You
may allow the user to run scripts by executing the following command:

`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`
