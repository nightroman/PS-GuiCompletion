# GuiCompletion Release Notes

## v1.0.1

Use `CompletionText` instead of `ListItemText` if adjacent items are same.
E.g. on completing `[file` instead of two items `File` show these items:
`System.Net.WebRequestMethods+File` and `System.IO.File`.

## v1.0.0

Fix occasional garbage on paging and scrolling in some terminals.

## v0.11.1

`ScrollDisplayDown` default is true, to make GuiCompletion working in more terminals.
To turn this feature off, use

    $GuiCompletionConfig.ScrollDisplayDown = $false

## v0.11.0

Add the option `ScrollDisplayDown` to work around [#5](https://github.com/nightroman/PS-GuiCompletion/issues/5).

## v0.10.1

[#3](https://github.com/nightroman/PS-GuiCompletion/issues/3)
Catch and ignore errors in `TabExpansion2`. Errors are still collected in `$Error`.

## v0.10.0

The exported variable `$GuiCompletionConfig` is read only (you can change its
properties but cannot set the variable) and represented by a custom object
instead of hashtable. This reduces chances of misusing.

Retired the `SpaceComplete` option. The space character is included to
`CustomCompletionChars` by default.

Minor performance tweaks.

## v0.9.0

This release contains changes made long time ago, now difficult to explain in
user friendly form. Most prominent: performance improvements, inferred common
prefix, fuzzy filter.

**Part1**

- Use top and bottom margins
- Rework `Out-ConsoleList` as `Get-ConsoleList` without pipeline (faster)
- Rework `New-TabItem` without pipeline input
- Cache and use `$Host.UI.RawUI` as module scope `$UI`
- Replace `ForEach-Object` with faster loops
- Replace `New-Box` property bag with variables, comment out not used
- Remove not used `$HasChild` and fix not initialized error
- Fix `Right Arrow` wrong index and out-of-range
- Fix strict mode failures
- Use `ShiftPressed` flag, remove not used `Get-KeyState`
- Cache `$Colors` for faster access and shorter code
- Use `MinimumTextWidth` and rework `Get-ContentSize`
- Use `CompletionResult` as is, retire `New-TabItem`

**Part2**

- Use `ListItemText` for list, remove some preview stuff
- Retire `CloseListOnEmptyFilter`, `Right/Left Arrow`
- Remove `LastWord` from `Select-Item`
- Fix `Backspace`, remove not used `$OldFilter`
- Retire `ReturnWord`, `LastWord`
- Show the current item count in status
- Remove not used `$PowerTabFileSystemMode`
- Fix `Page Down` / `Page Up` with not first / last selected, review `Move-Selection`
- Use `AllowCtrlC` in `ReadKey` to avoid fatal breaks
- Infer and use common prefix
- Add spaces to filter and status
- Use one `ReadKey`
- Simplify `Above` / `Below`
- Remove not used `TabExpansionUtil.ps1`
- Remove `HelpInfoURI` from the manifest, problem for `Update-Help`
- Settings: replace `MinimumListItems` with `AutoReturnSingle`
- Use fuzzy filter with exact matches followed by fuzzy

## v0.8.1

- Fixes broken publication of v0.8.0

## v0.8.0

- Switches to Windows default menu color scheme ([#5](https://github.com/cspotcode/PS-GuiCompletion/issues/5), [@nightroman](https://github.com/nightroman))
  - If you want to use the old theme or customize colors, modify the `$GuiCompletionConfig.Colors` global variable.
- Fixes rendering glitch where some vertical lines could be left over after the menu closes ([#6](https://github.com/cspotcode/PS-GuiCompletion/issues/6), [@nightroman](https://github.com/nightroman))
- Switches to `TabExpansion2` for computing completions, which allows other modules to plugin custom completions ([#7](https://github.com/cspotcode/PS-GuiCompletion/issues/7), [@nightroman](https://github.com/nightroman))
