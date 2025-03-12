# add the extras bucket
scoop install git
scoop bucket add extras
# install Ueli Launcher
scoop install extras/ueli
# install Zebar
scoop install extras/zebar
# install GlazeWM for managing windows
scoop install extras/glazewm
# install Rio as our terminal emulator
scoop install extras/rio
# install AutoHotKey to override the windows keys
scoop install extras/autohotkey

# Create a symlink for GlazeWM to have it start on login
# Find the path to the GlazeWM executable installed via Scoop
$glazeWmPath = "$env:USERPROFILE\scoop\apps\glazewm\current\glazewm.exe"

# Verify the path exists
if (!(Test-Path $glazeWmPath)) {
    Write-Host "GlazeWM executable not found at expected path: $glazeWmPath"
    Write-Host "Please check your Scoop installation path and update the script accordingly."
    exit
}

# Get the path to the Startup folder for the current user
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Create the shortcut for GlazeWM to activate on login
$shortcutPath = "$startupFolder\GlazeWM.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $glazeWmPath
$Shortcut.Save()

Write-Host "GlazeWM shortcut has been created in your startup folder."
Write-Host "GlazeWM will now start automatically when you log in."

# Create an AutoHotkey script to disable Windows key default behavior
$ahkScriptPath = "$env:USERPROFILE\Documents\WindowKeyRedirect.ahk"
$ahkScript = @"
#UseHook True
#SingleInstance Force

; Block Windows key from opening Start menu
~LWin Up:: {
    ; Only block default behavior if pressed alone (no other key)
    if (A_PriorKey = "LWin")
        return
    return
}
~RWin Up:: {
    ; Only block default behavior if pressed alone (no other key)
    if (A_PriorKey = "RWin")
        return
    return
}
    
; Plus the companion key - Windows OS won't intercept these combos
LWin & a::SendInput("{Blind}{LWin Down}a{LWin Up}")
LWin & b::SendInput("{Blind}{LWin Down}b{LWin Up}")
LWin & c::SendInput("{Blind}{LWin Down}c{LWin Up}")
LWin & d::SendInput("{Blind}{LWin Down}d{LWin Up}")
LWin & e::SendInput("{Blind}{LWin Down}e{LWin Up}")
LWin & f::SendInput("{Blind}{LWin Down}f{LWin Up}")
LWin & g::SendInput("{Blind}{LWin Down}g{LWin Up}")
LWin & h::SendInput("{Blind}{LWin Down}h{LWin Up}")
LWin & i::SendInput("{Blind}{LWin Down}i{LWin Up}")
LWin & j::SendInput("{Blind}{LWin Down}j{LWin Up}")
LWin & k::SendInput("{Blind}{LWin Down}k{LWin Up}")
LWin & l::SendInput("{Blind}{LWin Down}l{LWin Up}")
LWin & m::SendInput("{Blind}{LWin Down}m{LWin Up}")
LWin & n::SendInput("{Blind}{LWin Down}n{LWin Up}")
LWin & o::SendInput("{Blind}{LWin Down}o{LWin Up}")
LWin & p::SendInput("{Blind}{LWin Down}p{LWin Up}")
LWin & q::SendInput("{Blind}{LWin Down}q{LWin Up}")
LWin & r::SendInput("{Blind}{LWin Down}r{LWin Up}")
LWin & s::SendInput("{Blind}{LWin Down}s{LWin Up}")
LWin & t::SendInput("{Blind}{LWin Down}t{LWin Up}")
LWin & u::SendInput("{Blind}{LWin Down}u{LWin Up}")
LWin & v::SendInput("{Blind}{LWin Down}v{LWin Up}")
LWin & w::SendInput("{Blind}{LWin Down}w{LWin Up}")
LWin & x::SendInput("{Blind}{LWin Down}x{LWin Up}")
LWin & y::SendInput("{Blind}{LWin Down}y{LWin Up}")
LWin & z::SendInput("{Blind}{LWin Down}z{LWin Up}")

; Number keys
LWin & 1::SendInput("{Blind}{LWin Down}1{LWin Up}")
LWin & 2::SendInput("{Blind}{LWin Down}2{LWin Up}")
LWin & 3::SendInput("{Blind}{LWin Down}3{LWin Up}")
LWin & 4::SendInput("{Blind}{LWin Down}4{LWin Up}")
LWin & 5::SendInput("{Blind}{LWin Down}5{LWin Up}")
LWin & 6::SendInput("{Blind}{LWin Down}6{LWin Up}")
LWin & 7::SendInput("{Blind}{LWin Down}7{LWin Up}")
LWin & 8::SendInput("{Blind}{LWin Down}8{LWin Up}")
LWin & 9::SendInput("{Blind}{LWin Down}9{LWin Up}")
LWin & 0::SendInput("{Blind}{LWin Down}0{LWin Up}")

; With tab, space, and enter
LWin & Tab::SendInput("{Blind}{LWin Down}{Tab}{LWin Up}")
LWin & Space::SendInput("{Blind}{LWin Down}{Space}{LWin Up}")
LWin & Enter::SendInput("{Blind}{LWin Down}{Enter}{LWin Up}")

; Plus the companion key - Windows OS won't intercept these combos
RWin & a::SendInput("{Blind}{RWin Down}a{RWin Up}")
RWin & b::SendInput("{Blind}{RWin Down}b{RWin Up}")
RWin & c::SendInput("{Blind}{RWin Down}c{RWin Up}")
RWin & d::SendInput("{Blind}{RWin Down}d{RWin Up}")
RWin & e::SendInput("{Blind}{RWin Down}e{RWin Up}")
RWin & f::SendInput("{Blind}{RWin Down}f{RWin Up}")
RWin & g::SendInput("{Blind}{RWin Down}g{RWin Up}")
RWin & h::SendInput("{Blind}{RWin Down}h{RWin Up}")
RWin & i::SendInput("{Blind}{RWin Down}i{RWin Up}")
RWin & j::SendInput("{Blind}{RWin Down}j{RWin Up}")
RWin & k::SendInput("{Blind}{RWin Down}k{RWin Up}")
RWin & l::SendInput("{Blind}{RWin Down}l{RWin Up}")
RWin & m::SendInput("{Blind}{RWin Down}m{RWin Up}")
RWin & n::SendInput("{Blind}{RWin Down}n{RWin Up}")
RWin & o::SendInput("{Blind}{RWin Down}o{RWin Up}")
RWin & p::SendInput("{Blind}{RWin Down}p{RWin Up}")
RWin & q::SendInput("{Blind}{RWin Down}q{RWin Up}")
RWin & r::SendInput("{Blind}{RWin Down}r{RWin Up}")
RWin & s::SendInput("{Blind}{RWin Down}s{RWin Up}")
RWin & t::SendInput("{Blind}{RWin Down}t{RWin Up}")
RWin & u::SendInput("{Blind}{RWin Down}u{RWin Up}")
RWin & v::SendInput("{Blind}{RWin Down}v{RWin Up}")
RWin & w::SendInput("{Blind}{RWin Down}w{RWin Up}")
RWin & x::SendInput("{Blind}{RWin Down}x{RWin Up}")
RWin & y::SendInput("{Blind}{RWin Down}y{RWin Up}")
RWin & z::SendInput("{Blind}{RWin Down}z{RWin Up}")

; Number keys
RWin & 1::SendInput("{Blind}{RWin Down}1{RWin Up}")
RWin & 2::SendInput("{Blind}{RWin Down}2{RWin Up}")
RWin & 3::SendInput("{Blind}{RWin Down}3{RWin Up}")
RWin & 4::SendInput("{Blind}{RWin Down}4{RWin Up}")
RWin & 5::SendInput("{Blind}{RWin Down}5{RWin Up}")
RWin & 6::SendInput("{Blind}{RWin Down}6{RWin Up}")
RWin & 7::SendInput("{Blind}{RWin Down}7{RWin Up}")
RWin & 8::SendInput("{Blind}{RWin Down}8{RWin Up}")
RWin & 9::SendInput("{Blind}{RWin Down}9{RWin Up}")
RWin & 0::SendInput("{Blind}{RWin Down}0{RWin Up}")

; With tab, space, and enter
RWin & Tab::SendInput("{Blind}{RWin Down}{Tab}{RWin Up}")
RWin & Space::SendInput("{Blind}{RWin Down}{Space}{RWin Up}")
RWin & Enter::SendInput("{Blind}{RWin Down}{Enter}{RWin Up}")
"@

# Create the AHK script file
New-Item -Path $ahkScriptPath -Value $ahkScript -Force

# Create the shortcut for AutoHotKey to activate on login
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = "$startupFolder\WindowKeyRedirect.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $ahkScriptPath
$Shortcut.Save()

# Start AutoHotKey
AutoHotKey $ahkScriptPath

# Create registry entries to disable Windows keyboard shortcuts, window snapping, hide taskbar, and disable minimize/maximize
$explorerAdvancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$explorerStuckRectsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
$dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
$windowMetricsPath = "HKCU:\Control Panel\Desktop\WindowMetrics"

# Disable Windows keyboard shortcuts
$hotkeyName = "DisableHotkeys"
$hotkeyValue = 1

# Disable window snapping features
$snapAssistName = "EnableSnapAssistFlyout"
$snapLayoutName = "SnapAssist"
$snapFillName = "SnapFill"
$snapValue = 0

# Check if the registry keys exist, if not create them
if (!(Test-Path $explorerAdvancedPath)) {
    New-Item -Path $explorerAdvancedPath -Force | Out-Null
}

if (!(Test-Path $dwmPath)) {
    New-Item -Path $dwmPath -Force | Out-Null
}

if (!(Test-Path $windowMetricsPath)) {
    New-Item -Path $windowMetricsPath -Force | Out-Null
}

# Set the registry values for hotkeys and snapping
New-ItemProperty -Path $explorerAdvancedPath -Name $hotkeyName -Value $hotkeyValue -PropertyType DWORD -Force
New-ItemProperty -Path $explorerAdvancedPath -Name $snapAssistName -Value $snapValue -PropertyType DWORD -Force
New-ItemProperty -Path $explorerAdvancedPath -Name $snapLayoutName -Value $snapValue -PropertyType DWORD -Force
New-ItemProperty -Path $explorerAdvancedPath -Name $snapFillName -Value $snapValue -PropertyType DWORD -Force

# Disable minimize and maximize buttons in window title bars
New-ItemProperty -Path $dwmPath -Name "MinimizeButtonState" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path $dwmPath -Name "MaximizeButtonState" -Value 1 -PropertyType DWORD -Force

# Disable minimize and maximize animations
New-ItemProperty -Path $windowMetricsPath -Name "MinAnimate" -Value 0 -PropertyType STRING -Force
New-ItemProperty -Path $windowMetricsPath -Name "MaxAnimate" -Value 0 -PropertyType STRING -Force

# Hide the taskbar by modifying the binary StuckRects3 data
if (Test-Path $explorerStuckRectsPath) {
    try {
        # Get the current StuckRects3 data
        $stuckRects = (Get-ItemProperty -Path $explorerStuckRectsPath -Name Settings).Settings
        
        # Auto-hide taskbar by modifying the 9th byte (setting to 3)
        # 1 = show taskbar, 3 = hide taskbar
        $stuckRects[8] = 3
        
        # Write the modified data back to registry
        Set-ItemProperty -Path $explorerStuckRectsPath -Name Settings -Value $stuckRects
    }
    catch {
        Write-Host "Error modifying taskbar settings: $_"
    }
}

# Create policies to disable minimize and maximize functions
$policyPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
if (!(Test-Path $policyPath)) {
    New-Item -Path $policyPath -Force | Out-Null
}
New-ItemProperty -Path $policyPath -Name "NoMinimizeWindow" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path $policyPath -Name "NoMaximizeWindow" -Value 1 -PropertyType DWORD -Force

# Block Alt+Tab functionality
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "AltTabSettings" -Value 1 -PropertyType DWORD -Force

# Disable Aero Shake to minimize other windows
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisallowShaking" -Value 1 -PropertyType DWORD -Force

# Disable Windows Key Shortcuts
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$registryName = "NoWinKeys"
$registryValue = 1

# Ensure the registry path exists
If (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value to disable Windows key shortcuts
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWORD -Force

# Disable Task Switcher (Alt+Tab)
$registryPath2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$registryName2 = "DisableTaskSwitching"
$registryValue2 = 1

If (!(Test-Path $registryPath2)) {
    New-Item -Path $registryPath2 -Force | Out-Null
}

Set-ItemProperty -Path $registryPath2 -Name $registryName2 -Value $registryValue2 -Type DWORD -Force

# Disable Sticky Keys and Filter Keys shortcuts
$registryPath3 = "HKCU:\Control Panel\Accessibility\StickyKeys"
Set-ItemProperty -Path $registryPath3 -Name "Flags" -Value 506
$registryPath4 = "HKCU:\Control Panel\Accessibility\Keyboard Response"
Set-ItemProperty -Path $registryPath4 -Name "Flags" -Value 122

# Stop and restart explorer process to apply changes immediately
Stop-Process -Name explorer -Force
Start-Process explorer

# Notify user
Write-Host "Windows keyboard shortcuts and window snapping features have been disabled."
Write-Host "Taskbar has been hidden."
Write-Host "Minimize and maximize functionality have been disabled where possible."
Write-Host "Settings have been applied automatically by restarting explorer."