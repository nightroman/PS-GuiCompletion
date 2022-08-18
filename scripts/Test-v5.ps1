<#
.Synopsis
	Starts vanilla powershell with GuiCompletion.
#>

powershell -NoProfile -NoExit {
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
