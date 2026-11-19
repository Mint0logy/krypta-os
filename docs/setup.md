# Development Setup

## Build environment

| Component | Configuration |
|---|---|
| Host | Windows 11, VirtualBox 7.2.22 |
| Guest | Ubuntu Server 24.04 LTS (x86_64), headless |
| VM | 4 vCPUs, 6 GB RAM, 70 GB virtual disk |
| Networking | NAT; `127.0.0.1:2222` → guest `22` |
| Editor | VS Code for Windows + Remote - SSH |
| Ubuntu repository | `~/krypta-os` |
| Windows repository | `%USERPROFILE%\krypta-os` (example; use your actual clone path) |

No graphical desktop or Guest Additions are required. The VM snapshot and SSH workflow are complete according to the supplied roadmap. GitHub authentication stays on Windows even though the repository is public.

## Connect to Ubuntu

On Ubuntu, verify the SSH service (install/enable `openssh-server` if needed):

```bash
systemctl is-enabled ssh
systemctl is-active ssh
```

In Windows CMD, replace `linux-user` with the VM account:

```cmd
ssh -p 2222 linux-user@127.0.0.1
```

Use the same connection in VS Code Remote - SSH and open `~/krypta-os`. To shut down the VM safely, run `sudo shutdown -h now` in Ubuntu; closing Remote SSH alone does not shut down the VM.

## Toolchain and validation

Install missing baseline packages from Ubuntu's official repositories:

```bash
sudo apt update
sudo apt install git make gcc python3 curl wget \
  gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu \
  file shellcheck qemu-user
```

From the repository root:

```bash
make help
make check
make arm64-runtime-check
shellcheck scripts/check-env.sh
git diff --check
```

Verified on 2026-11-18: environment checks, AArch64 GCC cross-compilation, ELF header inspection, QEMU user mode 8.2.2, successful glibc test execution/exit, automatic artifact rebuild, ShellCheck and whitespace checks. Build outputs are ignored by Git.

The historical smoke test compiles `tests/arm64/hello-check.c` into `build/hello-arm64`:

```bash
aarch64-linux-gnu-gcc -Wall -Wextra -Werror \
  tests/arm64/hello-check.c -o build/hello-arm64
file build/hello-arm64
aarch64-linux-gnu-readelf -h build/hello-arm64
```

The verified test binary uses AArch64 glibc; it does not validate Alpine musl, a complete Linux system, or the phone. Remaining Clang/LLVM/LLD/DTC and kernel dependencies are tracked in M1. Record exact tool versions when completing that milestone.

## Git workflow

Use Windows CMD for GitHub operations and Bash on Ubuntu. Bundles transfer committed history only. Before each import/export, verify `git status --short` is empty and the relevant branch is `main`. Stop if histories diverge; never force-push. Replace example account/path values as needed.

### Windows → Ubuntu

Windows CMD:

```cmd
cd /d "%USERPROFILE%\krypta-os"
git status --short
git pull --ff-only origin main
git bundle create "%USERPROFILE%\krypta-os.bundle" main
scp -P 2222 "%USERPROFILE%\krypta-os.bundle" linux-user@127.0.0.1:~/
```

Ubuntu, first clone only (if directory does not exist):

```bash
git clone -b main ~/krypta-os.bundle ~/krypta-os
```

For an existing clone instead:

```bash
cd ~/krypta-os
git status --short
git bundle verify ~/krypta-os.bundle
git fetch ~/krypta-os.bundle main
git merge --ff-only FETCH_HEAD
```

### Ubuntu → Windows

Commit changes on Ubuntu, then:

```bash
cd ~/krypta-os
git status --short
git bundle create ~/krypta-os-to-windows.bundle main
git bundle verify ~/krypta-os-to-windows.bundle
```

Windows CMD:

```cmd
scp -P 2222 linux-user@127.0.0.1:~/krypta-os-to-windows.bundle "%USERPROFILE%\krypta-os-to-windows.bundle"
cd /d "%USERPROFILE%\krypta-os"
git status --short
git bundle verify "%USERPROFILE%\krypta-os-to-windows.bundle"
git fetch "%USERPROFILE%\krypta-os-to-windows.bundle" main
git merge --ff-only FETCH_HEAD
git push origin main
```

Keep credentials, device identifiers, restricted firmware and generated images outside the public repository. Review staged changes before committing.

## Later: Yocto build environment

Yocto/OpenEmbedded and BitBake are not installed or validated yet. The present VM is the verified environment for initial cross-compilation, not a qualified Yocto builder. The [Yocto host requirements](https://docs.yoctoproject.org/current/ref-manual/system-requirements.html) give an example of at least 140 GB **free** disk space for `core-image-sato` on `qemux86-64`; actual needs depend on release, image and cache. The current 70 GB virtual disk is below that example. Before migration, select a supported release, review its host dependencies and increase build storage as needed (a planning target of 200 GB free is reasonable, not a universal minimum). Review memory and parallelism against available host resources. Keep source revisions pinned and downloads, build output and shared-state cache untracked.