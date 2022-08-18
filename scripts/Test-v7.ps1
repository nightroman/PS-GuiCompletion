<#
.Synopsis
	Starts vanilla pwsh with GuiCompletion.
#>

pwsh -NoProfile -NoExit {
	$ErrorActionPreference = 'Stop'
	Set-StrictMode -Version Latest

	Import-Module GuiCompletion
	Install-GuiCompletion Tab

	# prompt suitable for screenshots
	function global:prompt {
		' PS> '
	}
	''
}
