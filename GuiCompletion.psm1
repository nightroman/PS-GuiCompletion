$ErrorActionPreference = 'Stop'
$UI = $Host.UI.RawUI

. $PSScriptRoot\scripts\ConsoleLib.ps1
. $PSScriptRoot\scripts\GuiCompletionConfig.ps1

function Install-GuiCompletion($Key = 'Ctrl+Spacebar') {
	Set-PSReadLineKeyHandler -Key $Key -ScriptBlock {
		Invoke-GuiCompletion
	}
}

function Invoke-GuiCompletion {
	for() {
		# get input buffer state
		$buffer = ''
		$cursorPosition = 0
		[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursorPosition)
		if (!$cursorPosition) {
			return
		}

		# get completion items
		try {
			$completion = TabExpansion2 $buffer $cursorPosition
		}
		catch {
			return
		}
		if (!$completion.CompletionMatches) {
			return
		}

		# show the menu
		$Repeat = $false
		$replacement = Get-ConsoleList -Content $completion.CompletionMatches -Repeat ([ref]$Repeat)

		# apply the completion
		if ($replacement) {
			[Microsoft.PowerShell.PSConsoleReadLine]::Replace($completion.ReplacementIndex, $completion.ReplacementLength, $replacement)
		}
		if (!$Repeat) {
			break
		}
	}
}

Export-ModuleMember -Function Install-GuiCompletion, Invoke-GuiCompletion -Variable GuiCompletionConfig
