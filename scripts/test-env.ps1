<#
.Synopsis
	Starts vanilla powershell session with GuiCompletion.
#>

powershell -NoProfile -NoExit {
	$ErrorActionPreference = 'Stop'
	Set-StrictMode -Version 2

	Import-Module GuiCompletion
	Install-GuiCompletion Tab

	# simple prompt with leading space suitable for screenshots
	function global:prompt {
		' PS> '
	}

	# skip one line
	''
}
