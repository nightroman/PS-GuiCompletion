<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

Set-StrictMode -Version 2
$ModuleName = 'GuiCompletion'

# Synopsis: Remove temporary items.
task clean {
	remove z, *.nupkg
}

# Synopsis: Set $script:Version from Release-Notes.
task version {
	($script:Version = switch -Regex -File Release-Notes.md {'##\s+v(\d+\.\d+\.\d+)\s*(.*)' {$Matches[1]; break}})
	$psd1 = Invoke-Expression (Get-Content GuiCompletion.psd1 -Raw)
	equals $script:Version $psd1.ModuleVersion
	if ($$ = $Matches[2]) {Write-Warning $$}
}

# Synopsis: Make the module folder.
task module version, {
	remove z
	$null = mkdir z\$ModuleName\scripts
	Copy-Item -Destination z\$ModuleName $(
		'README.md'
		'GuiCompletion.psd1'
		'GuiCompletion.psm1'
		'LICENSE'
	)
	Copy-Item -Destination z\$ModuleName\scripts $(
		'scripts\ConsoleLib.ps1'
		'scripts\GuiCompletionConfig.ps1'
	)
}

# Synopsis: Push with a version tag.
task pushRelease version, {
	$changes = exec { git status --short }
	assert (!$changes) "Please commit changes."

	exec { git push }
	exec { git tag -a "v$script:Version" -m "v$script:Version" }
	exec { git push origin "v$script:Version" }
}

# Synopsis: Push PSGallery package.
task pushPSGallery module, {
	$NuGetApiKey = Read-Host NuGetApiKey
	Publish-Module -Path z\$ModuleName -NuGetApiKey $NuGetApiKey
},
clean

# Synopsis: The default task.
task . version, clean
