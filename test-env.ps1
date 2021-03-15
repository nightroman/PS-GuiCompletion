$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

Import-Module $PSScriptRoot\GuiCompletion.psd1

Install-GuiCompletion Tab

# simple prompt with leading space sutable for screenshots
function global:prompt {
	' PS> '
}
