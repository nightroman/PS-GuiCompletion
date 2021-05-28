# Design notes

## Parse-List

    function Parse-List(
        [System.Drawing.Size]$Size
        ,
        [switch]$NoScroll
    )

Calculates and returns the list property table:

    TopX
    TopY
    ListHeight
    ListWidth
    MaxItems

depending on the caret and window size.

### `[System.Drawing.Size]$Size`

The content size obtained by `Get-ContentSize`.
Height is the number of items.
Width is the maximum text length, with `$GuiCompletionConfig.MinimumTextWidth` included.

### `[switch]$NoScroll`

It is set when the `ScrollDisplayDown` mode scrolls and calls `Parse-List` again recursively.
In theory, in this case the list should be shown below the caret and new scrolling is not needed.

But we use the switch to avoid potential infinite recursion.
If scrolling does not work for some reason we show the list as is.

### `ScrollDisplayDown` mode

In theory this should do the trick:

    [Microsoft.PowerShell.PSConsoleReadLine]::ScrollDisplayDownLine($null, $CursorOffset - $Center)

But it does not work if the caret is at the bottom of the buffer.
In a way, there is nowhere to scroll.

So we force scrolling by inserting several new lines and then undoing the change.

The number of lines to scroll:

    $nScroll = [Math]::Min($CursorOffset - $Center, $ListHeight - $CursorOffsetBottom + 1)

Why `Min`. If we use just `$CursorOffset - $Center` then the caret line is scrolled to the center.
This is not effective if the completion list is small.

The number of new lines to insert:

    $CursorOffsetBottom + $nScroll

`$CursorOffsetBottom` inserts lines to reach the window bottom, so scrolling happens at this point.
`$nScroll` inserts lines with actual scrolling.
