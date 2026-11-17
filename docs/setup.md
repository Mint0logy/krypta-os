# Development Setup

## Architecture

The development environment uses a headless Ubuntu Server VM on a Windows 11
host. VS Code runs on Windows and connects to the VM with the Microsoft
Remote - SSH extension. GitHub authentication stays on Windows; committed
history is transferred between Windows and Ubuntu with Git bundles over SSH.

| Component | Configuration |
|---|---|
| Host | Windows 11 |
| VirtualBox | Oracle VirtualBox 7.2.22 |
| Editor | VS Code on Windows with Microsoft Remote - SSH |
| Guest | Ubuntu Server 24.04 LTS, AMD64/x86_64 |
| Guest identity | Use the hostname and Linux account configured for your VM |
| VM resources | 4 vCPUs, 6 GB RAM, 70 GB virtual disk |
| Network | NAT |
| SSH forwarding | Host loopback port `2222` to guest port `22` |
| Project path in Ubuntu | `~/krypta-os` |
| Windows repository | `%USERPROFILE%\krypta-os` |

The guest has no graphical desktop. VirtualBox Guest Additions are not
required.

## Confirmed

- Ubuntu Server is used in place of the former Ubuntu Desktop VM.
- OpenSSH Server is running and enabled at boot.
- VirtualBox NAT forwards host loopback port `2222` to guest port `22`.
- SSH from Windows and a VS Code Remote - SSH terminal have been tested.
- Git and GitHub authentication are handled on Windows; use your configured
  Windows repository path.

The repository clone at `~/krypta-os`, base development tools, and
ARM64 cross-compilers have not been confirmed. Verify them before relying on
them; SSH connectivity does not establish that the repository or toolchain is
ready.

## VirtualBox and SSH

Configure the VM with the resources and NAT network shown above. In the
VirtualBox NAT port-forwarding rules, bind host port `2222` to the host's
loopback interface and forward it to guest port `22`. Install and enable
OpenSSH Server in Ubuntu if it is not already present.

To check the guest service from its Ubuntu terminal:

```bash
hostname
systemctl is-enabled ssh
systemctl is-active ssh
```

In Windows CMD, replace `linux-user` with the account configured in the guest,
then test the forwarded connection:

```cmd
ssh -p 2222 linux-user@localhost
```

In VS Code on Windows, install Microsoft Remote - SSH, connect to
`ssh -p 2222 linux-user@localhost` (using the guest account), and open
`~/krypta-os` on the remote host. The SSH connection and remote
terminal are already confirmed; check that the project directory exists before
opening it.

## Ubuntu Development Tools and Repository

The following tools are required by `scripts/check-env.sh`. Their presence in
the new VM has not yet been verified. In an Ubuntu terminal, install any
missing base packages from Ubuntu's package repositories:

```bash
sudo apt update
sudo apt install git make gcc python3 curl wget
```

The ARM64 cross-compilation toolchain is a separate, unverified M1 task. Do not
assume it is installed. Once the repository is available in the VM, check the
base environment from its root:

```bash
make check
```

### Initial Clone

First transfer the current `main` branch from Windows using the workflow below.
In Ubuntu, clone only if `~/krypta-os` does not already exist:

```bash
git clone -b main ~/krypta-os.bundle ~/krypta-os
```

For an existing clone, fetch and fast-forward from the transferred bundle as
described below. Do not clone over an existing directory.

## Git Workflow

GitHub is private and GitHub authentication is not configured in Ubuntu. Run
`git pull` and `git push` on Windows in CMD. Transfer committed history to and
from the Ubuntu VM with bundles and `scp`.

Before creating or importing a bundle, check `git status --short` and make sure
the working tree is clean. Commit changes on the branch being transferred;
bundles transfer commits, not uncommitted files. Do not proceed with an import
when there are uncommitted changes. A fetch does not replace working files,
and `--ff-only` prevents merging divergent history.

### Windows to Ubuntu

In Windows CMD, update and export `main`, then copy the bundle to the VM:

```cmd
cd /d "%USERPROFILE%\krypta-os"
git status --short
git pull --ff-only origin main
git bundle create "%USERPROFILE%\krypta-os.bundle" main
scp -P 2222 "%USERPROFILE%\krypta-os.bundle" linux-user@localhost:~/
```

On the Ubuntu VM, if the project directory does not yet exist, use the initial
clone command above. For an existing clone, verify it is clean and update it
with a fast-forward:

```bash
cd ~/krypta-os
git status --short
git fetch ~/krypta-os.bundle main
git merge --ff-only FETCH_HEAD
```

### Ubuntu to Windows

On Ubuntu, commit the changes on `main`, confirm the working tree is clean, and
create a bundle:

```bash
cd ~/krypta-os
git status --short
git bundle create ~/krypta-os-to-windows.bundle main
git bundle verify ~/krypta-os-to-windows.bundle
```

In Windows CMD, download the bundle from the VM, then fetch and fast-forward
the Windows repository. Do not continue if the working tree is not clean:

```cmd
scp -P 2222 linux-user@localhost:~/krypta-os-to-windows.bundle "%USERPROFILE%\krypta-os-to-windows.bundle"
cd /d "%USERPROFILE%\krypta-os"
git status --short
git fetch "%USERPROFILE%\krypta-os-to-windows.bundle" main
git merge --ff-only FETCH_HEAD
git push origin main
```

If an import is not a fast-forward, stop and resolve the branch history rather
than forcing an update. Keep credentials and private keys out of bundles and
the repository.
