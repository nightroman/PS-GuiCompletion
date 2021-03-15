$ErrorActionPreference = 'Stop'
$UI = $Host.UI.RawUI

. $PSScriptRoot\powertab\default-config.ps1
. $PSScriptRoot\powertab\ConsoleLib.ps1

function Install-GuiCompletion($Key = 'Ctrl+Spacebar') {
	Set-PSReadLineKeyHandler -Key $Key -ScriptBlock {
		Invoke-GuiCompletion
	}
}

function Invoke-GuiCompletion {
	for() {
		# get input buffer state from PSReadLine
		$buffer = ''
		$cursorPosition = 0
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
		if (!$cursorPosition) {
			return
		}

		# get list of completion items
		$completion = TabExpansion2 $buffer $cursorPosition
		if (!$completion.CompletionMatches) {
			return
		}

		# show the menu
		$recurse = $false
		$replacement = Get-ConsoleList -Content $completion.CompletionMatches -Recurse ([ref]$recurse)

		# based on return value, apply the completion to the buffer state
		if ($replacement) {
			[Microsoft.PowerShell.PSConsoleReadLine]::Replace($completion.ReplacementIndex, $completion.ReplacementLength, $replacement)
		}
		if (!$recurse) {
			break
		}
	}
}

Export-ModuleMember -Function Install-GuiCompletion, Invoke-GuiCompletion -Variable GuiCompletionConfig
