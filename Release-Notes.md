# GuiCompletion Release Notes

## v0.9.0 (coming soon)

This release contains many performance improvements and design changes made
long time ago, difficult to explain in user friendly form. Commit summaries:

**Part1**

- Use top and bottom margins
- Rework `Out-ConsoleList` as `Get-ConsoleList` without pipeline (faster)
- Rework `New-TabItem` without pipeline input
- Cache and use `$Host.UI.RawUI` as module scope `$UI`
- Replace `ForEach-Object` with faster loops
- Replace `New-Box` property bag with variables, comment out not used
- Remove not used `$HasChild` and fix not initialized error
- Fix `Right Arrow` wrong index and out-of-range
- Treat `*` and `?` in filter as wildcards
- Fix strict mode failures
- Use `ShiftPressed` flag, remove not used `Get-KeyState`
- Cache `$Colors` for faster access and shorter code
- Use `MinimumTextWidth` and rework `Get-ContentSize`
- Use `CompletionResult` as is, retire `New-TabItem`

**Part2**

- Use `ListItemText` for list, remove some preview stuff, use different filter
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

## v0.8.1

- Fixes broken publication of v0.8.0

## v0.8.0

- Switches to Windows default menu color scheme ([#5](https://github.com/cspotcode/PS-GuiCompletion/issues/5), [@nightroman](https://github.com/nightroman))
  - If you want to use the old theme or customize colors, modify the `$GuiCompletionConfig.Colors` global variable.
- Fixes rendering glitch where some vertical lines could be left over after the menu closes ([#6](https://github.com/cspotcode/PS-GuiCompletion/issues/6), [@nightroman](https://github.com/nightroman))
- Switches to `TabExpansion2` for computing completions, which allows other modules to plugin custom completions ([#7](https://github.com/cspotcode/PS-GuiCompletion/issues/7), [@nightroman](https://github.com/nightroman))
