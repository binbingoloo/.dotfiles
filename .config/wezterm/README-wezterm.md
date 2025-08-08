# WezTerm Custom Config Complete User Guide

## 📸 Screenshots

<details>
<summary>🖼️ Main UI</summary>

<img width="1512" alt="WezTerm Main UI" src="https://github.com/user-attachments/assets/44317f5d-f726-435b-b754-97a011312c6b" />

</details>

<details>
<summary>📋 Copy Mode</summary>

<img width="1013" alt="Copy Mode View 1" src="https://github.com/user-attachments/assets/60125ea4-9362-4dbf-b120-7c85e4a655d2" />

<img width="1013" alt="Copy Mode View 2" src="https://github.com/user-attachments/assets/955229ea-834a-4145-95a1-229df7b56e21" />

</details>

<details>
<summary>🔍 Search Mode</summary>

<img width="1013" alt="Search Mode" src="https://github.com/user-attachments/assets/2562be7a-5a2d-4d98-83c3-734f5fc2e7ea" />

</details>

more...

## Table of Contents

### 🚀 Quick Start

- [1. Basic Concepts](#1-basic-concepts)

### ⌨️ Basic Keyboard Operations

- [2. Application Control](#2-application-control)
- [3. Copy and Paste Operations](#3-copy-and-paste-operations)
- [4. Font and Display Control](#4-font-and-display-control)

### 📂 Workspace Management

- [5. Basic Workspace Operations](#5-basic-workspace-operations)
- [6. Custom Workspace Configuration](#6-custom-workspace-configuration)

### 📑 Tab Management

- [7. Basic Tab Operations](#7-basic-tab-operations)

### 🔲 Pane Management

- [8. Pane Split Operations](#8-pane-split-operations)
- [9. Pane Navigation](#9-pane-navigation)
- [10. Pane Adjustment and Management](#10-pane-adjustment-and-management)

### 🎯 Modal Operating System

- [11. Copy Mode (`Leader + y`)](#11-copy-mode-leader--y)
- [12. Open Mode (`Leader + o`)](#12-open-mode-leader--o)
- [13. Move Mode (`Leader + m`)](#13-move-mode-leader--m)
- [14. Resize Mode (`Leader + r`)](#14-resize-mode-leader--r)

### 🔍 Advanced Features

- [15. Search and Selection](#15-search-and-selection)
- [16. Scrolling Operations](#16-scrolling-operations)
- [17. Command Palette and Tools](#17-command-palette-and-tools)
- [18. Help System](#18-help-system)

### 🔧 Custom Configuration

- [19. Launch Menu Customization](#19-launch-menu-customization)
- [20. Workspace Preset Configuration](#20-workspace-preset-configuration)

## 🚀 Quick Start

### 1. Basic Concepts

- **Terminal**: The WezTerm application itself
- **Window**: A WezTerm instance
- **Workspace**: Logical grouping of projects, can contain multiple tabs
- **Tab**: Different sessions within a workspace
- **Pane**: Split areas within a tab
- **Leader Key**: `Ctrl + a`, used to activate special function modes

## ⌨️ Basic Keyboard Operations

### 2. Application Control

| Shortcut  | Function               | Use Case               |
| --------- | ---------------------- | ---------------------- |
| `Cmd + q` | Quit WezTerm           | Completely close app   |
| `Cmd + K` | Clear screen and flash | Clear terminal history |
| `Cmd + /` | Search current content | Find specific text     |

### 3. Copy and Paste Operations

| Operation    | Shortcut/Method                     | Description             |
| ------------ | ----------------------------------- | ----------------------- |
| Copy         | `Cmd + C` or double-click           | Copy selected text      |
| Paste        | `Cmd + V` or right-click            | Paste clipboard content |
| Triple-click | Mouse triple-click                  | Select entire line      |
| Auto-copy    | Auto-copy after double/triple-click | No manual copy needed   |

### 4. Font and Display Control

| Shortcut  | Function        | Adjustment      |
| --------- | --------------- | --------------- |
| `Cmd + =` | Increase font   | Increment       |
| `Cmd + -` | Decrease font   | Decrement       |
| `Cmd + 0` | Reset font size | Back to default |

---

## 📂 Workspace Management

### 5. Basic Workspace Operations

| Shortcut             | Function                     | Use Case                   |
| -------------------- | ---------------------------- | -------------------------- |
| `Leader + s`         | Workspace selector           | Switch to other workspaces |
| `Leader + l`         | Switch to last workspace     | Quick toggle between two   |
| `Cmd + Opt + [`      | Switch to previous workspace | Browse workspaces in order |
| `Cmd + Opt + ]`      | Switch to next workspace     | Browse workspaces in order |
| `Leader + Shift + $` | Rename current workspace     | Customize workspace name   |

### 6. Custom Workspace Configuration

**Edit workspace configuration** (`utils/workspaces.lua`):

```lua
-- Add personal project workspaces
M.config = {
  default = "workspace",
  projects = {
    {
      name = "workspace",
      path = os.getenv("HOME"),
    },
    {
      name = "dotfiles",
      path = os.getenv("HOME") .. "/.dotfiles"
    },
    {
      name = "web-dev",
      path = os.getenv("HOME") .. "/Projects/web",
      tabs = { "frontend", "backend", "database" }
    }
  }
}
```

---

## 📑 Tab Management

### 7. Basic Tab Operations

| Shortcut          | Function               | Description                    |
| ----------------- | ---------------------- | ------------------------------ |
| `Cmd + T`         | New tab                | Create in current workspace    |
| `Cmd + W`         | Close current tab      | No confirmation prompt         |
| `Cmd + 1-9`       | Jump to specific tab   | Number corresponds to position |
| `Cmd + Shift + [` | Switch to previous tab | Cycle through                  |
| `Cmd + Shift + ]` | Switch to next tab     | Cycle through                  |
| `Leader + ,`      | Rename current tab     | Customize tab name             |
| `Leader + t`      | Tab selector           | Fuzzy search tabs              |

---

## 🔲 Pane Management

### 8. Pane Split Operations

| Shortcut     | Function         | Split Direction    |
| ------------ | ---------------- | ------------------ |
| `Leader + -` | Vertical split   | Top/bottom split   |
| `Leader + \` | Horizontal split | Left/right split   |
| `Leader + z` | Toggle pane zoom | Fullscreen/restore |

### 9. Pane Navigation

| Shortcut           | Function         | Use Case              |
| ------------------ | ---------------- | --------------------- |
| `CMD + Opt + ←→↑↓` | Arrow navigation | Quick pane switching  |
| `Leader + m` → `s` | Pane selector    | Visual pane selection |

### 10. Pane Adjustment and Management

| Mode        | Activate     | Operation Keys | Function             |
| ----------- | ------------ | -------------- | -------------------- |
| Resize mode | `Leader + r` | `←→↑↓`         | Resize pane          |
| Move mode   | `Leader + m` | `r`            | Rotate pane position |
| Move mode   | `Leader + m` | `Shift + ←→`   | Move tab position    |

---

## 🎯 Modal Operating System

### 11. Copy Mode (`Leader + y`)

| Key | Function           | Use Case                     |
| --- | ------------------ | ---------------------------- |
| `b` | Copy entire buffer | Save all history output      |
| `p` | Copy current page  | Copy visible content         |
| `l` | Smart line copy    | Copy lines with content      |
| `r` | Regex copy         | Copy IPs, emails, URLs, etc. |

**Supported Regex Patterns**:

- IPv4 address: `192.168.1.1`
- IPv6 address: `2001:db8::1`
- MAC address: `aa:bb:cc:dd:ee:ff`
- Email address: `user@domain.com`
- URL: `https://example.com`
- Git commit hash: `a1b2c3d`
- Container ID: `3f2504e0bb0c`
- Container image: `nginx:latest`

### 12. Open Mode (`Leader + o`)

| Key | Function     | Description                              |
| --- | ------------ | ---------------------------------------- |
| `p` | Open Finder  | Open file manager in current directory   |
| `c` | Open VS Code | Open current project with VS Code        |
| `u` | Open URL     | Select URL on screen and open in browser |

### 13. Move Mode (`Leader + m`)

| Key | Function      | Description                          |
| --- | ------------- | ------------------------------------ |
| `r` | Rotate panes  | Rotate pane layout counter-clockwise |
| `s` | Pane selector | Interactive pane selection           |

### 14. Resize Mode (`Leader + r`)

| Key         | Function     | Adjustment    |
| ----------- | ------------ | ------------- |
| `←`         | Expand left  | 1 char width  |
| `→`         | Expand right | 1 char width  |
| `↑`         | Expand up    | 1 line height |
| `↓`         | Expand down  | 1 line height |
| `Enter/Esc` | Exit mode    | -             |

---

## 🔍 Advanced Features

### 15. Search and Selection

| Feature      | Activation       | Usage                     |
| ------------ | ---------------- | ------------------------- |
| Text search  | `Cmd + /`        | Search in current content |
| Copy mode    | `Leader + v`     | Enter vim-style copy mode |
| Quick select | Use in copy mode | Smart text selection      |

### 16. Scrolling Operations

| Shortcut           | Function         | Scroll Amount |
| ------------------ | ---------------- | ------------- |
| `Shift + ↑↓`       | Line scroll      | 1 line        |
| `Cmd + Shift + ↑↓` | Page scroll      | 1 page        |
| `Cmd + Opt + ↑↓`   | Half Page scroll | 0.5 page      |
| `Cmd + ↑`          | Scroll to top    | -             |
| `Cmd + ↓`          | Scroll to bottom | -             |

### 17. Command Palette and Tools

| Shortcut     | Function        | Purpose                          |
| ------------ | --------------- | -------------------------------- |
| `Leader + h` | Command palette | Search and execute all commands  |
| `Leader + d` | Debug interface | View config and performance info |
| `Leader + c` | Launch menu     | Quick launch common apps         |

### 18. Help System

| Shortcut     | Function          | Description                                  |
| ------------ | ----------------- | -------------------------------------------- |
| `Leader + ?` | Cheatsheet viewer | View available cheatsheets for various tools |

**Available Cheatsheets**:

- `tmux` - Tmux keybindings and commands
- `wezterm` - WezTerm configuration reference
- `fzf` - Fuzzy finder shortcuts
- Custom cheatsheets in `~/.config/wezterm/cheatsheets/`

---

## 🔧 Custom Configuration

### 19. Launch Menu Customization

**Edit launch menu** (`config/launch.lua`):

```lua
-- Add custom launch items
{
  label = "Jupyter Notebook",
  args = { "jupyter", "notebook" },
},
{
  label = "Python REPL",
  args = { "python3" },
},
{
  label = "Node.js REPL",
  args = { "node" },
}
```

### 20. Workspace Preset Configuration

**Configure development environment** (`utils/workspaces.lua`):

```lua
-- Frontend development workspace
{
  name = "frontend",
  path = os.getenv("HOME") .. "/Projects/frontend",
  tabs = { "src", "build", "server" }
},
-- Backend development workspace
{
  name = "backend",
  path = os.getenv("HOME") .. "/Projects/backend",
  tabs = { "api", "database", "logs" }
},
-- DevOps workspace
{
  name = "devops",
  path = os.getenv("HOME") .. "/Infrastructure",
  tabs = { "terraform", "ansible", "monitoring" }
}
```
