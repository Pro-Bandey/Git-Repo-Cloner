import subprocess
import sys
import os
import re

# Cross-platform ANSI Color Definitions
RESET = "\x1b[0m"
WHITE = "\x1b[97m"
GREEN = "\x1b[92m"         # Success
RED = "\x1b[91m"           # Failures / Errors
CYAN = "\x1b[96m"          # Processes / Status updates
PURPLE = "\x1b[95m"        # ASCII Art / Headings
GOLDEN = "\x1b[38;5;220m"   # Warm Golden for numbers
GIT_ORANGE = "\x1b[38;5;202m" # Git Brand Red-Orange

def init_terminal():
    """Enables ANSI escape sequences natively on modern Windows platforms."""
    if os.name == 'nt':
        try:
            import ctypes
            kernel32 = ctypes.windll.kernel32
            h_stdout = kernel32.GetStdHandle(-11) # STD_OUTPUT_HANDLE
            mode = ctypes.c_ulong()
            if kernel32.GetConsoleMode(h_stdout, ctypes.byref(mode)):
                # Enable ENABLE_VIRTUAL_TERMINAL_PROCESSING (0x0004)
                kernel32.SetConsoleMode(h_stdout, mode.value | 0x0004)
        except Exception:
            # Degrades gracefully if Virtual Terminal flags fail to initialize
            pass

def format_numbers(text, default_color=WHITE):
    """Processes text to color digits in GOLDEN without breaking ANSI escape codes."""
    # Pattern matches standard ANSI escape sequences
    ansi_pattern = re.compile(r'(\x1b\[[0-9;]*[a-zA-Z])')
    parts = ansi_pattern.split(text)
    
    new_parts = []
    for part in parts:
        if ansi_pattern.match(part):
            new_parts.append(part)
        else:
            # Safe replacement of digit sequences with Golden formatting
            colored_part = re.sub(r'(\d+)', f"{GOLDEN}\\1{default_color}", part)
            new_parts.append(colored_part)
            
    return f"{default_color}{''.join(new_parts)}{RESET}"

def cprint(text, default_color=WHITE, end="\n"):
    """Helper to print formatted text with custom defaults."""
    formatted = format_numbers(str(text), default_color)
    sys.stdout.write(formatted + end)
    sys.stdout.flush()

def cinput(prompt_text, default_color=WHITE):
    """Helper to prompt for user input with custom formatted text."""
    formatted = format_numbers(prompt_text, default_color)
    return input(formatted)

def load_ascii_art(filename="GitRepoCloner.txt"):
    """Safely loads ASCII art."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, filename)

    if os.path.exists(file_path):
        try:
            with open(file_path, "r", encoding="utf-8") as file:
                return file.read()
        except IOError:
            pass
    return "=== Git Repo Cloner ==="

def clone_repo(repo_url, local_name=None, target_dir=None):
    """Clones the repository into the specified target directory."""
    try:
        cprint(f"🔄 Cloning {repo_url}...", default_color=CYAN)
        
        command = ["git", "clone", repo_url]
        if local_name:
            command.append(local_name)

        subprocess.run(command, check=True, cwd=target_dir)
        
        destination = local_name if local_name else "The Default Directory"
        cprint(f"✅ Successfully Cloned to {destination}\n", default_color=GREEN)
    except subprocess.CalledProcessError:
        cprint(f"❌ Failed To Clone: {repo_url}\n", default_color=RED)
    except FileNotFoundError:
        cprint("❌ Git is not installed or not found in PATH.", default_color=RED)
        sys.exit(1)

def resolve_directory(path):
    """Checks if a directory exists, and optionally creates it if it doesn't."""
    target_path = os.path.abspath(path)
    if not os.path.exists(target_path):
        create = cinput(f"Directory '{target_path}' does not exist. Create it? (y/n): ", default_color=CYAN).strip().lower()
        if create in ('y', 'yes'):
            try:
                os.makedirs(target_path, exist_ok=True)
                cprint(f"✅ Created Directory: {target_path}\n", default_color=GREEN)
                return target_path
            except Exception as e:
                cprint(f"❌ Could Not Create Directory: {e}\n", default_color=RED)
                return None
        else:
            cprint("❌ Directory Change Canceled.\n", default_color=RED)
            return None
    return target_path

def main():
    # Initialize cross-platform color handling
    init_terminal()
    
    art = load_ascii_art()
    # Print ASCII art in Git red-orange (or purple if 256-color is restricted)
    print(f"{GIT_ORANGE}{art}{RESET}")
    
    # Set default cloning directory to the current working directory
    clone_dir = os.getcwd()
    cprint(f"Current Directory: {clone_dir}", default_color=WHITE)
    
    # Prompt user to change cloning directory at startup
    change_dir = cinput("Enter Directory Path Or Press 'Enter' To Skip For Current: ", default_color=WHITE).strip()
    if change_dir:
        resolved = resolve_directory(change_dir)
        if resolved:
            clone_dir = resolved

    cprint("\n--- Active Session ---", default_color=CYAN)
    cprint(f"Target Directory: {clone_dir}", default_color=CYAN)
    cprint("Enter a GitHub repository URL: <url> [optional_local repo_name]", default_color=WHITE)
    cprint("Type 'cd <path>' to change the destination folder.", default_color=WHITE)
    cprint("Type 'exit', 'q' or CTRL+C to stop.\n", default_color=WHITE)

    while True:
        try:
            # Display target directory within the prompt
            prompt = f"Clone To ({os.path.basename(clone_dir)}) URL: "
            user_input = cinput(prompt, default_color=CYAN).strip()

            if not user_input:
                continue

            if user_input.lower() in ("exit", "q"):
                cprint("Goodbye!", default_color=WHITE)
                break

            # Handle directory change command during runtime
            if user_input.lower().startswith("cd "):
                new_path = user_input[3:].strip()
                resolved = resolve_directory(new_path)
                if resolved:
                    clone_dir = resolved
                    cprint(f"Target Directory Updated To: {clone_dir}\n", default_color=CYAN)
                continue

            # Split the input into URL and optional local name
            parts = user_input.split(maxsplit=1)
            repo_url = parts[0]
            local_name = parts[1] if len(parts) > 1 else None

            # Simple URL validation
            if not (repo_url.startswith("http://") or 
                    repo_url.startswith("https://") or 
                    repo_url.startswith("git@") or 
                    repo_url.startswith("ssh://")):
                cprint("⚠️ Please enter a valid Git URL (HTTP/HTTPS/SSH) or use 'cd <path>'.\n", default_color=RED)
                continue

            clone_repo(repo_url, local_name, target_dir=clone_dir)

        except KeyboardInterrupt:
            cprint("\nExiting...", default_color=RED)
            break

if __name__ == "__main__":
    main()