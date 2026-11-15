
# Development Setup

## Requirements

- Linux x86-64 (Ubuntu 24.04 LTS recommended)
- Git
- GNU Make
- GCC
- Python 3
- curl and wget
- ShellCheck
- Visual Studio Code (optional)

KRYPTA OS targets ARM64/AArch64. The development machine uses an x86-64 Linux environment for cross-compilation.

## Environment

The initial development environment uses Ubuntu 24.04 LTS running in VirtualBox.

Recommended VM configuration:

| Resource | Configuration |
|---|---|
| CPU | 4 vCPUs |
| RAM | 6 GB |
| Storage | 70 GB |
| Network | NAT |

A native Linux installation can also be used.

## Install Dependencies

Update the system:

```bash
sudo apt update
sudo apt upgrade
```

Install base development tools:

```bash
sudo apt install git curl wget make build-essential python3 python3-pip ca-certificates shellcheck
```

Before installing unfamiliar packages, inspect their sources and dependencies:

```bash
apt policy <package>
apt show <package>
apt install --simulate <package>
```

## Editor

Visual Studio Code can be installed from:

https://code.visualstudio.com/download

Recommended extensions:

- C/C++ — `ms-vscode.cpptools`
- CMake Tools — `ms-vscode.cmake-tools`

ShellCheck can be used directly from the terminal.

## Project Setup

Clone the repository or initialize a local working copy.

From the repository root, validate the development environment:

```bash
make check
```

Run static analysis on shell scripts:

```bash
shellcheck scripts/*.sh
```

The environment check verifies the availability of essential development tools and reports the host architecture.

## Git Workflow

Development takes place locally in Linux.

GitHub authentication is handled separately on a trusted host machine. The Linux build environment does not require GitHub credentials.

### Local Commits

From the repository root:

```bash
git status
git add -A
git diff --cached --check
git diff --cached
git commit -m "describe changes"
```

Review staged changes before committing, especially when using `git add -A`.

### Export Changes

Create a Git bundle containing the `main` branch history:

```bash
git bundle create ../krypta-os.bundle main
git bundle verify ../krypta-os.bundle
```

Transfer the bundle to the trusted host.

### Import Changes

In an existing Git repository, import commits from the transferred bundle:

```bash
git fetch /path/to/krypta-os.bundle main
git merge --ff-only FETCH_HEAD
```

Run the commands on the branch being updated, with a clean working tree.

On the trusted host, publish imported changes:

```bash
git push origin main
```

To synchronize in the opposite direction, fetch changes from GitHub on the trusted host, export an updated bundle and import it into Linux.

Fast-forward merges require compatible commit histories. Diverged histories must be resolved separately.