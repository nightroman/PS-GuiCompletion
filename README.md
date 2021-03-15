# GuiCompletion for PowerShell
<!-- Remember that description section must render correctly as plain text because it's copy-pasted into the module manifest. -->
<!--BEGIN DESCRIPTION-->
This enables a GUI-style tab-completion menu for PowerShell.  It integrates with PSReadLine which comes installed in PowerShell by default, and the GUI code is lifted straight from PowerTab.
<!--END DESCRIPTION-->

This repository clones and continues the original [PS-GuiCompletion](https://github.com/cspotcode/PS-GuiCompletion) by [@cspotcode](https://github.com/cspotcode).
The published module is the same [GuiCompletion](https://www.powershellgallery.com/packages/GuiCompletion).
It is developed here starting from v0.9.0 (coming soon).

***

<!-- TODO add screenshot -->
![Animated example](docs/example.gif)

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
