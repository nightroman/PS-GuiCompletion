$ErrorActionPreference = 'Stop'
$NestedPromptLevel++
Import-Module .\GuiCompletion.psd1

Install-GuiCompletion

function global:prompt {
	' PS> '
}
