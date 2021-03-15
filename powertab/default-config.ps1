$GuiCompletionConfig = @{
	Colors = @{
		TextColor = 'DarkMagenta'
		BackColor = 'White'
		SelectedTextColor = 'White'
		SelectedBackColor = 'DarkMagenta'

		BorderTextColor = 'DarkMagenta'
		BorderBackColor = 'White'
		BorderColor = 'DarkMagenta'
		FilterColor = 'DarkMagenta'
	}

	AutoReturnSingle = $true
	MinimumTextWidth = 25
	FastScrollItemCount = 10
	DotComplete = $true
	AutoExpandOnDot = $true
	BackSlashComplete = $true
	AutoExpandOnBackSlash = $true
	SpaceComplete = $true
	CustomCompletionChars = ']:)'
	CustomComplete = $true

	DoubleBorder = $true
}
