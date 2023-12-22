function Get-ConsoleList(
	[Parameter(Position=0)]
	$Content
	,
	[ref]
	$Repeat
)
{
	# auto return single item without menu
	if ($Content.Count -eq 1 -and $GuiCompletionConfig.AutoReturnSingle) {
		$Content | .{process{$_.CompletionText}}
		return
	}

	# create console list
	$Prefix = Get-CommonPrefix $Content
	$Filter = ''
	$Colors = $GuiCompletionConfig.Colors
	$ListHandle = New-ConsoleList $Content $Colors.BorderColor $Colors.BorderBackColor $Colors.TextColor $Colors.BackColor

	function Set-Status {
		# filter buffer (header) shows the current filter after the last word
		$FilterBuffer = New-BufferCellArray " $Prefix[$Filter] " $Colors.FilterColor $Colors.BorderBackColor
		$FilterPosition = $ListHandle.Position
		$FilterPosition.X += 2
		$FilterHandle = New-Buffer $FilterPosition $FilterBuffer

		# status buffer (footer) shows selected item number, visible items number range, total item count
		$StatusBuffer = New-StatusBufferCellArray $ListHandle
		$StatusPosition = $ListHandle.Position
		$StatusPosition.X += 2
		$StatusPosition.Y += $listHandle.ListConfig.ListHeight - 1
		$StatusHandle = New-Buffer $StatusPosition $StatusBuffer
	}
	. Set-Status

	# select the first item
	$SelectedItem = 0
	Set-Selection 1 ($SelectedItem + 1) ($ListHandle.ListConfig.ListWidth - 3) $Colors.SelectedTextColor $Colors.SelectedBackColor

	### Keys
	:loop while(($Key = $UI.ReadKey('NoEcho,IncludeKeyDown,AllowCtrlC')).VirtualKeyCode -ne 27) {
		$ShiftPressed = 0x10 -band [int]$Key.ControlKeyState
		switch($Key.VirtualKeyCode) {
			### Tab
			9 {
				# in Visual Studio, Tab acts like Enter
				if ($GuiCompletionConfig.VisualStudioTabBehavior) {
					# out selected
					$ListHandle.Items[$ListHandle.SelectedItem].CompletionText
					break loop
				}
				elseif ($ShiftPressed) {
					# Up
					Move-Selection -1
				}
				else {
					# Down
					Move-Selection 1
				}
				break
			}
			### Up Arrow
			38 {
				if ($ShiftPressed) {
					# fast scroll selected
					if ($GuiCompletionConfig.FastScrollItemCount -gt ($ListHandle.Items.Count - 1)) {
						$Count = $ListHandle.Items.Count - 1
					}
					else {
						$Count = $GuiCompletionConfig.FastScrollItemCount
					}
					Move-Selection (-$Count)
				}
				else {
					Move-Selection -1
				}
				break
			}
			### Down Arrow
			40 {
				if ($ShiftPressed) {
					# fast scroll selected
					if ($GuiCompletionConfig.FastScrollItemCount -gt ($ListHandle.Items.Count - 1)) {
						$Count = $ListHandle.Items.Count - 1
					}
					else {
						$Count = $GuiCompletionConfig.FastScrollItemCount
					}
					Move-Selection $Count
				}
				else {
					Move-Selection 1
				}
				break
			}
			### Page Up
			33 {
				$Count = $ListHandle.Items.Count
				if ($Count -gt $ListHandle.MaxItems) {
					$Count = $ListHandle.MaxItems
				}
				Move-Selection (1 - $Count)
				break
			}
			### Page Down
			34 {
				$Count = $ListHandle.Items.Count
				if ($Count -gt $ListHandle.MaxItems) {
					$Count = $ListHandle.MaxItems
				}
				Move-Selection ($Count - 1)
				break
			}
			### Period
			190 {
				if ($GuiCompletionConfig.DotComplete) {
					if ($GuiCompletionConfig.AutoExpandOnDot) {
						$Repeat.Value = $true
					}
					# out selected + period
					$ListHandle.Items[$ListHandle.SelectedItem].CompletionText + '.'
					break loop
				}
			}
			### Enter
			13 {
				# out selected
				$ListHandle.Items[$ListHandle.SelectedItem].CompletionText
				break loop
			}
			### Slash
			{$GuiCompletionConfig.BackSlashComplete -and '\/'.Contains($Key.Character)} {
				if ($GuiCompletionConfig.AutoExpandOnBackSlash) {
					$Repeat.Value = $true
				}
				# out selected + char
				$ListHandle.Items[$ListHandle.SelectedItem].CompletionText + $Key.Character
				break loop
			}
			### Custom
			{$GuiCompletionConfig.CustomComplete -and $GuiCompletionConfig.CustomCompletionChars.Contains($Key.Character)} {
				# out selected + char
				$Item = $ListHandle.Items[$ListHandle.SelectedItem].CompletionText
				if ($Item.EndsWith($Key.Character)) {$Item} else {$Item + $Key.Character}
				break loop
			}
			### Character/Backspace
			{$Key.Character} {
				# update filter
				$oldFilter = $Filter
				if ($Key.Character -eq 8) {
					if ($Filter) {
						$Filter = $Filter.Substring(0, $Filter.Length - 1)
					}
					else {
						break
					}
				}
				else {
					# add char
					$Filter += $Key.Character
				}
				# get new items
				$Items = @(Select-Item $Content $Prefix $Filter)
				if (!$Items) {
					# new filter gives no items, undo
					$Filter = $oldFilter
				}
				elseif ($Items.Count -ne $ListHandle.Items.Count) {
					# items changed, update
					$ListHandle.Clear()
					$ListHandle = New-ConsoleList $Items $Colors.BorderColor $Colors.BorderBackColor $Colors.TextColor $Colors.BackColor
					# update status buffer
					. Set-Status
					# select first item
					$SelectedItem = 0
					Set-Selection 1 ($SelectedItem + 1) ($ListHandle.ListConfig.ListWidth - 3) $Colors.SelectedTextColor $Colors.SelectedBackColor
				}
				else {
					# update status buffer
					. Set-Status
				}
				break
			}
		}
	}

	$ListHandle.Clear()
}

function New-Box(
	[System.Drawing.Size]$Size
	,
	[System.ConsoleColor]$ForegroundColor = $UI.ForegroundColor
	,
	[System.ConsoleColor]$BackgroundColor = $UI.BackgroundColor
)
{
	$HorizontalDouble = [string][char]9552
	$VerticalDouble = [string][char]9553
	$TopLeftDouble = [string][char]9556
	$TopRightDouble = [string][char]9559
	$BottomLeftDouble = [string][char]9562
	$BottomRightDouble = [string][char]9565
	$Horizontal = [string][char]9472
	$Vertical = [string][char]9474
	$TopLeft = [string][char]9484
	$TopRight = [string][char]9488
	$BottomLeft = [string][char]9492
	$BottomRight = [string][char]9496
	$TopLeftDoubleSingle = [string][char]9554
	$TopRightDoubleSingle = [string][char]9557
	$BottomLeftDoubleSingle = [string][char]9560
	$BottomRightDoubleSingle = [string][char]9563

	if ($GuiCompletionConfig.DoubleBorder) {
		# double box
		$LineTop = $TopLeftDouble + $HorizontalDouble * ($Size.width - 2) + $TopRightDouble
		$LineField = $VerticalDouble + ' ' * ($Size.width - 2) + $VerticalDouble
		$LineBottom = $BottomLeftDouble + $HorizontalDouble * ($Size.width - 2) + $BottomRightDouble
	}
	else {
		# single box
		$LineTop = $TopLeft + $Horizontal * ($Size.width - 2) + $TopRight
		$LineField = $Vertical + ' ' * ($Size.width - 2) + $Vertical
		$LineBottom = $BottomLeft + $Horizontal * ($Size.width - 2) + $BottomRight
	}
	$Box = $(
		$LineTop
		1..($Size.Height - 2) | .{process{$LineField}}
		$LineBottom
	)
	$BoxBuffer = $UI.NewBufferCellArray($Box, $ForegroundColor, $BackgroundColor)
	, $BoxBuffer
}

function Get-ContentSize(
	[object[]]$Content
)
{
	$maxWidth = $GuiCompletionConfig.MinimumTextWidth
	$end = $Content.Length - 1
	for($$ = 0; $$ -le $end; ++$$) {
		$item = $Content[$$]
		$text = $_.ListItemText
		if (($$ -gt 0 -and $text -eq $Content[$$ - 1].ListItemText) -or ($$ -lt $end -and $text -eq $Content[$$ + 1].ListItemText)) {
			$w = $item.CompletionText.Length
		}
		else {
			$w = $item.ListItemText.Length
		}
		if ($maxWidth -lt $w) {
			$maxWidth = $w
		}
	}
	New-Object System.Drawing.Size $maxWidth, $Content.Length
}

function New-Position(
	[int]$X
	,
	[int]$Y
)
{
	$Position = $UI.WindowPosition
	$Position.X += $X
	$Position.Y += $Y
	$Position
}

function New-Buffer(
	[System.Management.Automation.Host.Coordinates]
	$Position
	,
	[System.Management.Automation.Host.BufferCell[,]]
	$Buffer
)
{
	$BufferBottom = $BufferTop = $Position
	$BufferBottom.X += ($Buffer.GetUpperBound(1))
	$BufferBottom.Y += ($Buffer.GetUpperBound(0))

	$OldTop = New-Object System.Management.Automation.Host.Coordinates 0, $BufferTop.Y
	$OldBottom = New-Object System.Management.Automation.Host.Coordinates ($UI.BufferSize.Width - 1), $BufferBottom.Y
	$OldBuffer = $UI.GetBufferContents((New-Object System.Management.Automation.Host.Rectangle $OldTop, $OldBottom))

	$UI.SetBufferContents($BufferTop, $Buffer)
	$Handle = New-Object System.Management.Automation.PSObject -Property @{
		Content = $Buffer
		OldContent = $OldBuffer
		Location = $BufferTop
		OldLocation = $OldTop
	}
	Add-Member -InputObject $Handle -MemberType ScriptMethod -Name Clear -Value {$UI.SetBufferContents($this.OldLocation, $this.OldContent)}
	Add-Member -InputObject $Handle -MemberType ScriptMethod -Name Show -Value {$UI.SetBufferContents($this.Location, $this.Content)}
	$Handle
}

function New-StatusBufferCellArray(
	$ListHandle
)
{
	, (New-BufferCellArray " $($ListHandle.SelectedItem + 1) / $($ListHandle.FirstItem + 1)-$($ListHandle.LastItem + 1) / $($ListHandle.Items.Count) " $Colors.BorderTextColor $Colors.BorderBackColor)
}

function New-BufferCellArray(
	[string[]]$Content
	,
	[System.ConsoleColor]$ForegroundColor = $UI.ForegroundColor
	,
	[System.ConsoleColor]$BackgroundColor = $UI.BackgroundColor
)
{
	, $UI.NewBufferCellArray($Content, $ForegroundColor, $BackgroundColor)
}

function Parse-List(
	[System.Drawing.Size]$Size
	,
	[switch]$NoScroll
)
{
	$WindowPosition = $UI.WindowPosition
	$WindowSize = $UI.WindowSize
	$Cursor = $UI.CursorPosition
	$Center = [int]($WindowSize.Height / 2)
	$CursorOffset = $Cursor.Y - $WindowPosition.Y
	$CursorOffsetBottom = $WindowSize.Height - $CursorOffset

	# vertical size and placement
	$ListHeight = $Size.Height + 2
	$Above = ($CursorOffset -gt $Center) -and ($ListHeight -ge $CursorOffsetBottom)
	if ($Above) {
		if (!$NoScroll -and $GuiCompletionConfig.ScrollDisplayDown) {
			$nScroll = [Math]::Min($CursorOffset - $Center, $ListHeight - $CursorOffsetBottom + 1)
			[Microsoft.PowerShell.PSConsoleReadLine]::Insert("`n" * ($CursorOffsetBottom + $nScroll))
			[Microsoft.PowerShell.PSConsoleReadLine]::Undo()
			return Parse-List $Size -NoScroll
		}
		$MaxListHeight = $CursorOffset - 1
		if ($MaxListHeight -lt $ListHeight) {$ListHeight = $MaxListHeight}
		$Y = $CursorOffset - $ListHeight
	}
	else {
		$MaxListHeight = $CursorOffsetBottom - 2
		if ($MaxListHeight -lt $ListHeight) {$ListHeight = $MaxListHeight}
		$Y = $CursorOffSet + 1
	}
	$MaxItems = $MaxListHeight - 2

	# horizontal
	$ListWidth = $Size.Width + 4
	if ($ListWidth -gt $WindowSize.Width) {$ListWidth = $Windowsize.Width}
	$Max = $ListWidth
	if (($Cursor.X + $Max) -lt ($WindowSize.Width - 2)) {
		$X = $Cursor.X
	}
	else {
		if (($Cursor.X - $Max) -gt 0) {
			$X = $Cursor.X - $Max
		}
		else {
			$X = $windowSize.Width - $Max
		}
	}

	# output
	@{
		TopX = $X
		TopY = $Y
		ListHeight = $ListHeight
		ListWidth = $ListWidth
		MaxItems = $MaxItems
	}
}

function New-ConsoleList(
	[object[]]$Content
	,
	[System.ConsoleColor]$BorderForegroundColor
	,
	[System.ConsoleColor]$BorderBackgroundColor
	,
	[System.ConsoleColor]$ContentForegroundColor
	,
	[System.ConsoleColor]$ContentBackgroundColor
)
{
	$size = Get-ContentSize $Content
	$minWidth = ([string]$Content.Count).Length * 4 + 7
	if ($size.Width -lt $minWidth) {$size.Width = $minWidth}
	$lines = @(
		$end = $Content.Length - 1
		for($$ = 0; $$ -le $end; ++$$) {
			$item = $Content[$$]
			$text = $item.ListItemText
			if (($$ -gt 0 -and $text -eq $Content[$$ - 1].ListItemText) -or ($$ -lt $end -and $text -eq $Content[$$ + 1].ListItemText)) {
				$text = $item.CompletionText
			}
			"$text ".PadRight($size.Width + 2)
		}
	)
	$listConfig = Parse-List $size
	$boxSize = New-Object System.Drawing.Size $listConfig.ListWidth, $listConfig.ListHeight
	$box = New-Box $boxSize $BorderForegroundColor $BorderBackgroundColor

	$pos = New-Position $listConfig.TopX $listConfig.TopY
	$BoxHandle = New-Buffer $pos $box

	# place content
	$pos.X += 1
	$pos.Y += 1
	$contentBuffer = New-BufferCellArray ($lines[0..($listConfig.ListHeight - 3)]) $ContentForegroundColor $ContentBackgroundColor
	$contentHandle = New-Buffer $pos $contentBuffer
	$handle = New-Object System.Management.Automation.PSObject -Property @{
		Position = New-Position $listConfig.TopX $listConfig.TopY
		ListConfig = $listConfig
		ContentSize = $size
		BoxSize = $boxSize
		Box = $BoxHandle
		Content = $contentHandle
		SelectedItem = 0
		SelectedLine = 1
		Items = $Content
		Lines = $lines
		FirstItem = 0
		LastItem = $listConfig.ListHeight - 3
		MaxItems = $listConfig.MaxItems
	}
	Add-Member -InputObject $handle -MemberType ScriptMethod -Name Clear -Value {$this.Box.Clear()}
	Add-Member -InputObject $handle -MemberType ScriptMethod -Name Show -Value {$this.Box.Show(); $this.Content.Show()}
	$handle
}

function Move-List(
	[int]$X
	,
	[int]$Y
	,
	[int]$Width
	,
	[int]$Height
	,
	[int]$Offset
)
{
	$Position = $ListHandle.Position
	$Position.X += $X
	$Position.Y += $Y
	$Rectangle = New-Object System.Management.Automation.Host.Rectangle $Position.X, $Position.Y, ($Position.X + $Width), ($Position.Y + $Height - 1)
	$Position.Y += $OffSet
	$BufferCell = New-Object System.Management.Automation.Host.BufferCell
	$BufferCell.BackgroundColor = $GuiCompletionConfig.Colors.BackColor
	$UI.ScrollBufferContents($Rectangle, $Position, $Rectangle, $BufferCell)
}

function Set-Selection(
	[int]$X
	,
	[int]$Y
	,
	[int]$Width
	,
	[System.ConsoleColor]$ForegroundColor
	,
	[System.ConsoleColor]$BackgroundColor
)
{
	$Position = $ListHandle.Position
	$Position.X += $X
	$Position.Y += $Y
	$Rectangle = New-Object System.Management.Automation.Host.Rectangle $Position.X, $Position.Y, ($Position.X + $Width), $Position.Y
	$LineBuffer = $UI.GetBufferContents($Rectangle)
	$LineBuffer = $UI.NewBufferCellArray(
		@([string]::Join("", ($LineBuffer | .{process{$_.Character}}))),
		$ForegroundColor,
		$BackgroundColor
	)
	$UI.SetBufferContents($Position, $LineBuffer)
}

function Move-Selection(
	[int]$Count
)
{
	$Colors = $GuiCompletionConfig.Colors
	$SelectedItem = $ListHandle.SelectedItem
	$Line = $ListHandle.SelectedLine
	if ($Count -ge 0) {
		## Down in list
		if ($SelectedItem -eq ($ListHandle.Items.Count - 1)) {
			return
		}
		$One = 1
		if ($SelectedItem + $Count -gt $ListHandle.Items.Count - 1) {$Count = $ListHandle.Items.Count - 1 - $SelectedItem}
		if ($SelectedItem -eq $ListHandle.LastItem) {
			$Move = $true
		}
		else {
			$Move = $false
			if (($ListHandle.MaxItems - $Line) -lt $Count) {$Count = $ListHandle.MaxItems - $Line}
		}
	}
	else {
		if ($SelectedItem -eq 0) {
			return
		}
		$One = -1
		if ($SelectedItem -eq $ListHandle.FirstItem) {
			$Move = $true
			if ($SelectedItem + $Count -lt 0) {$Count = - $SelectedItem}
		}
		else {
			$Move = $false
			if ($Line + $Count -lt 1) {$Count = 1 - $Line}
		}
	}

	if ($Move) {
		Set-Selection 1 $Line ($ListHandle.ListConfig.ListWidth - 3) $Colors.TextColor $Colors.BackColor
		Move-List 1 1 ($ListHandle.ListConfig.ListWidth - 3) ($ListHandle.ListConfig.ListHeight - 2) ( - $Count)
		$SelectedItem += $Count
		$ListHandle.FirstItem += $Count
		$ListHandle.LastItem += $Count

		$LinePosition = $ListHandle.Position
		$LinePosition.X += 1
		if ($One -eq 1) {
			$LinePosition.Y += $Line - ($Count - $One)
			$ItemLines = $ListHandle.Lines[($SelectedItem - ($Count - $One)) .. $SelectedItem]
		}
		else {
			$LinePosition.Y += 1
			$ItemLines = $ListHandle.Lines[($SelectedItem..($SelectedItem - ($Count - $One)))]
		}
		$null = New-Buffer $LinePosition (New-BufferCellArray $ItemLines $Colors.TextColor $Colors.BackColor)
		Set-Selection 1 $Line ($ListHandle.ListConfig.ListWidth - 3) $Colors.SelectedTextColor $Colors.SelectedBackColor
	}
	else {
		Set-Selection 1 $Line ($ListHandle.ListConfig.ListWidth - 3) $Colors.TextColor $Colors.BackColor
		$SelectedItem += $Count
		$Line += $Count
		Set-Selection 1 $Line ($ListHandle.ListConfig.ListWidth - 3) $Colors.SelectedTextColor $Colors.SelectedBackColor
	}
	$ListHandle.SelectedItem = $SelectedItem
	$ListHandle.SelectedLine = $Line

	# new status buffer
	$StatusHandle.Clear()
	$StatusBuffer = New-StatusBufferCellArray $ListHandle
	$StatusHandle = New-Buffer $StatusHandle.Location $StatusBuffer
}

function Select-Item(
	$Content
	,
	$Prefix
	,
	$Filter
)
{
	$pattern = '^' + [regex]::Escape($Prefix) + '.*?'
	foreach($c in $Filter.ToCharArray()) {
		$pattern += [regex]::Escape($c) + '.*?'
	}
	$Prefix += $Filter
	foreach($_ in $Content) {
		if ($_.ListItemText.StartsWith($Prefix, [StringComparison]::OrdinalIgnoreCase)) {
			$_
		}
	}
	foreach($_ in $Content) {
		$s = $_.ListItemText
		if (!$s.StartsWith($Prefix, [StringComparison]::OrdinalIgnoreCase) -and $s -match $pattern) {
			$_
		}
	}
}

function Get-CommonPrefix(
	$Content
)
{
	$prefix = $Content[-1].ListItemText
	for($i = $Content.Count - 2; $i -ge 0 -and $prefix; --$i) {
		$text = $Content[$i].ListItemText
		while($prefix -and !$text.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
			$prefix = $prefix.Substring(0, $prefix.Length - 1)
		}
	}
	$prefix
}
