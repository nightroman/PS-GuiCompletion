$PowerTabConfig = @{
    Colors = @{
        # This is the default cmd menus theme
        TextColor = 'DarkMagenta'
        BackColor = 'White'
        SelectedTextColor = 'White'
        SelectedBackColor = 'DarkMagenta'

        BorderTextColor = 'DarkMagenta'
        BorderBackColor = 'White'
        BorderColor = 'DarkMagenta'
        FilterColor = 'DarkMagenta'
    }
    MinimumListItems = 2
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

# Expose globally to allow customization
$GuiCompletionConfig = $PowerTabConfig
