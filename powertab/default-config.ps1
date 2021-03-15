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

	DoubleBorder = $true
	MinimumTextWidth = 25
	FastScrollItemCount = 10
	AutoReturnSingle = $true

	DotComplete = $true
	AutoExpandOnDot = $true

	BackSlashComplete = $true
	AutoExpandOnBackSlash = $true

	CustomComplete = $true
	CustomCompletionChars = '()[]:'

	SpaceComplete = $true
}
