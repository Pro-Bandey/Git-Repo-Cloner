# GitHub Repo Cloner

```text
   ___ _ _   _  _      _      ___                  ___ _
  / __(_) |_| || |_  _| |__  | _ \___ _ __  ___   / __| |___ _ _  ___ _ _
 | (_ | |  _| __ | || | '_ \ |   / -_) '_ \/ _ \ | (__| / _ \ ' \/ -_) '_|
  \___|_|\__|_||_|\_,_|_.__/ |_|_\___| .__/\___/  \___|_\___/_||_\___|_|
                                     |_|
```

A lightweight, cross-platform CLI utility written in Python to clone Git repositories. The script features dynamic terminal color coding, input path resolution, and destination directory management.

---

## Features

- **Cross-Platform Color Coding:** Renders color outputs across Windows, macOS, and Linux without requiring external dependencies (like `colorama`).
- **Interactive Folder Management:** Choose your target cloning directory during startup, or change it on the fly using the `cd` command.
- **Smart Input Parsing:** Extract both the repository URL and an optional custom destination folder name from a single input line.
- **Clean Formatting Output:**
  - **Git Red-Orange:** Main application ASCII logo.
  - **Green:** Successful cloning actions.
  - **Red:** Process failures or execution errors.
  - **Cyan:** Ongoing processes and prompt instructions.
  - **Gold:** Automatic highlighting for digits and numbers.
  - **White:** Standard text and guidance.

---

## Prerequisites

1. **Python 3.x** installed.
2. **Git** installed and available in your system's `PATH`.

---

## Usage

### 1. Initial Setup & Launch

To start using the cloner, follow these steps:

**Download**

[https://gitfolderdownloader.github.io/?=https://github.com/Pro-Bandey/Git-Repo-Cloner](https://gitfolderdownloader.github.io/?=https://github.com/Pro-Bandey/Git-Repo-Cloner)

**Clone**

```
git clone https://github.com/Pro-Bandey/Git-Repo-Cloner Cloner
```

**Navigate to Folder:** Exract The Source from Zip File or run this command

```bash
cd Cloner
```

**Run the Script:** Run the starter script matching your terminal and operating system:

- **Windows (Command Prompt):** Double-click `Run.bat` / `Run.cmd` or run:

  ```cmd
  Run.bat
  ```

- **Windows (PowerShell):** Run:
  ```powershell
  PowerShell -ExecutionPolicy Bypass -File .\Run.ps1
  ```
- **Linux / macOS (Bash Script):** Give the script permissions, then execute it:

  ```bash
  chmod +x Run.sh
  ./Run.sh
  ```

- **macOS (Double-Click finder):** Give the script permissions once, then double-click `run.command`:

  ```bash
  chmod +x run.command
  ```

---

### 2. Setting Up Your Working Directory

Upon launch, the script displays your current directory.

- Press **Enter** to keep your current location as the download folder.
- Alternatively, enter any directory path (e.g., `D:\Projects` or `/home/user/repos`). If the directory does not exist, the script will offer to create it for you.

---

### 3. Cloning Repositories

In the URL prompt, you can use the standard format or designate a custom folder name.

- **Standard Clone:** (Uses the default repository name as the folder name)
  ```text
  Clone To (repos) URL: https://github.com/UserName/RepoName
  ```
- **Custom Folder Name:** (Appends a custom name after a space)
  ```text
  Clone To (repos) URL: https://github.com/UserName/RepoyName MyCustomFolder
  ```

---

### 4. Navigation and Commands

While the script is running, you can enter these commands directly into the prompt:

- **Change active cloning directory:**
  ```text
  Clone To (repos) URL: cd D:\AnotherFolder
  ```
- **Exit the script:**
  Type `q`, `exit`, or press `CTRL+C` to quit.
