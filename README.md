# GuiCompletion for PowerShell

GUI-style tab-completion menu for PowerShell. It integrates with PSReadLine
which comes installed in PowerShell, and the GUI code is lifted from PowerTab.

This repository clones and continues the original [PS-GuiCompletion](https://github.com/cspotcode/PS-GuiCompletion)
created by [@cspotcode](https://github.com/cspotcode).
The same module [GuiCompletion](https://www.powershellgallery.com/packages/GuiCompletion)
is developed here starting from v0.9.0.

**Screenshots**

[q1]: docs/q1.png "Command completion"
[q2]: docs/q2.png "Parameter completion"
[q3]: docs/q3.png "Path completion"

| ![command][q1] | ![parameter][q2] | ![path][q3] |
|-|-|-|

## Installation

Install from the PowerShell Gallery ([GuiCompletion Gallery page](https://www.powershellgallery.com/packages/GuiCompletion)):

    Install-Module -Name GuiCompletion -Scope CurrentUser

Omit `-Scope` to install for all users if you have administrator permissions.

## Usage

Use with the default <kbd>Ctrl+Spacebar</kbd> key shortcut:

    Install-GuiCompletion

or with another key shortcut:

    Install-GuiCompletion -Key Tab

`Install-GuiCompletion` wraps PSReadLine's [Set-PSReadLineKeyHandler](https://github.com/lzybkr/PSReadLine#usage).
For more advanced scenarios, you can call the relevant PSReadLine commands directly:

    Set-PSReadlineKeyHandler -Key Alt+Spacebar -ScriptBlock { Invoke-GuiCompletion }

Add these configuration commands to your PowerShell profile.
Otherwise your configuration will not be applied to new PowerShell sessions.

## Options

The exported variable `$GuiCompletionConfig` provides the following default
console colors and options. They may be changed in a profile or interactively.

```
Colors                : @{TextColor=DarkMagenta;
                        BackColor=White;
                        SelectedTextColor=White;
                        SelectedBackColor=DarkMagenta;
                        BorderTextColor=DarkMagenta;
                        BorderBackColor=White;
                        BorderColor=DarkMagenta;
                        FilterColor=DarkMagenta}
DoubleBorder          : True
MinimumTextWidth      : 25
FastScrollItemCount   : 10
AutoReturnSingle      : True
ScrollDisplayDown     : True
DotComplete           : True
AutoExpandOnDot       : True
BackSlashComplete     : True
AutoExpandOnBackSlash : True
CustomComplete        : True
CustomCompletionChars :  ()[]:
```

`ScrollDisplayDown` tells to scroll the display if necessary in order to show
the list below the caret. This works around redrawing issues after the list
shown above the caret in some terminals.

## See also

- [GuiCompletion Release Notes](https://github.com/nightroman/PS-GuiCompletion/blob/main/Release-Notes.md)
