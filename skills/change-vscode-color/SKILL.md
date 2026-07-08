---
name: change-vscode-color
description: Manual-only skill. Use to set or adjust a workspace-scoped VS Code window color.
---

# VS Code Window Color

Use this skill to change the current workspace's VS Code window chrome without tinting editor content, the left Activity Bar, the Side Bar, or panels.

## Workflow

1. Confirm the target is the current workspace unless the user gives another path.
2. Read the nearest `AGENTS.md` when present, then inspect `.vscode/settings.json` if it exists.
3. Create or update `.vscode/settings.json` as JSON. Preserve unrelated settings and unrelated `workbench.colorCustomizations` keys.
4. Set only title/status/window-border keys unless the user explicitly asks for other UI regions.
5. Validate JSON after editing.

## Default Key Set

Use a mellow base color with matching active and inactive background colors, so the window chrome does not darken when focus moves elsewhere. Keep inactive foreground text darker than active foreground text. Prefer this key set:

```json
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "#7B5EA7",
    "titleBar.activeForeground": "#F8F5FF",
    "titleBar.inactiveBackground": "#7B5EA7",
    "titleBar.inactiveForeground": "#D8CCE8",
    "statusBar.background": "#60497F",
    "statusBar.foreground": "#F8F5FF",
    "statusBar.debuggingBackground": "#6E5A8A",
    "statusBar.debuggingForeground": "#F8F5FF",
    "statusBar.noFolderBackground": "#60497F",
    "statusBarItem.hoverBackground": "#735A95",
    "window.activeBorder": "#7B5EA7",
    "window.inactiveBorder": "#7B5EA7"
  }
}
```

When the user provides a color, replace the purple values with the requested palette while keeping this same scope. Keep inactive background and border values matched to the active equivalents unless the user explicitly asks for separate inactive colors.

## Scope Guardrails

- Do not set `activityBar.*`, `activityBarBadge.*`, `sideBar.*`, `sideBarSectionHeader.*`, `panel.*`, or editor color keys unless explicitly requested.
- Do not add `peacock.color` unless the user explicitly asks for Peacock. Peacock may tint more UI regions than plain VS Code window chrome settings.
- Do not edit global user settings unless the user explicitly asks for a global change. Prefer workspace-local `.vscode/settings.json`.
- If the user expects an outer window border and cannot see one, mention that VS Code may require `window.titleBarStyle: custom` on macOS/Linux for border colors to be visible, but do not change that setting without asking.

## Verification

Run one of:

```bash
jq empty .vscode/settings.json
python3 -m json.tool .vscode/settings.json >/dev/null
```

Then inspect the final key list and confirm no Activity Bar, Side Bar, panel, editor, or Peacock keys were introduced.
