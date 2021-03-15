# GuiCompletion for PowerShell

This enables a GUI-style tab-completion menu for PowerShell. It integrates with
PSReadLine which comes installed in PowerShell by default, and the GUI code is
lifted straight from PowerTab.

This repository clones and continues the original [PS-GuiCompletion](https://github.com/cspotcode/PS-GuiCompletion) by [@cspotcode](https://github.com/cspotcode).
The published module is the same [GuiCompletion](https://www.powershellgallery.com/packages/GuiCompletion).
It is developed here starting from v0.9.0 (coming soon).

**Screenshots**

[q1]: docs/q1.png "Command completion"
[q2]: docs/q2.png "Parameter completion"
[q3]: docs/q3.png "Path completion"

| ![command][q1] | ![parameter][q2] | ![path][q3] |
|-|-|-|

## Installation

Install from the PowerShell Gallery. ([GuiCompletion's Gallery page](https://www.powershellgallery.com/packages/GuiCompletion))

    Install-Module -Name GuiCompletion -Scope CurrentUser

*You can omit `-Scope` but I use it to avoid requiring Administrator permissions.*

## Usage

Register it with the default Ctrl+Spacebar key shortcut:

    Install-GuiCompletion

...or with another key shortcut:

    Install-GuiCompletion -Key Tab

`Install-GuiCompletion` is a one-line helper that wrap PSReadLine's [`Set-PSReadLineKeyHandler` cmdlet](https://github.com/lzybkr/PSReadLine#usage).  For more advanced scenarios, you can call the relevant PSReadLine commands directly:

    Set-PSReadlineKeyHandler -Key Alt+Spacebar -ScriptBlock { Invoke-GuiCompletion }

You'll want to add these configuration commands to your PowerShell profile.  Otherwise your configuration will not be applied to new PowerShell sessions.

## See also

- [GuiCompletion Release Notes](https://github.com/nightroman/PS-GuiCompletion/blob/main/Release-Notes.md)
