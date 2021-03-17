@{
	RootModule = 'GuiCompletion.psm1'
	ModuleVersion = '0.10.0'
	GUID = 'ad14a77f-27b3-4c8e-a54e-d603b15adcb8'
	Author = 'Roman Kuzmin'
	Description = 'GUI-style tab-completion menu for PowerShell.'

	RequiredAssemblies = @('System.Drawing')
	FunctionsToExport = @('Install-GuiCompletion', 'Invoke-GuiCompletion')
	CmdletsToExport = @()
	VariablesToExport = @('GuiCompletionConfig')
	AliasesToExport = @()

	PrivateData = @{
		PSData = @{
			Tags = @('TabExpansion')
			ProjectUri = 'https://github.com/nightroman/PS-GuiCompletion'
			LicenseUri = 'https://github.com/nightroman/PS-GuiCompletion/blob/main/LICENSE'
			ReleaseNotes = 'https://github.com/nightroman/PS-GuiCompletion/blob/main/Release-Notes.md'
		}
	}
}
