
# KRYPTA OS — Development Roadmap

> A pocket-sized Linux cybersecurity laboratory.

**Project type:** Personal embedded Linux / ARM64 distribution project  
**Target device:** Xiaomi 11 Lite 5G NE (`lisa`)  
**Target architecture:** ARM64 / AArch64  
**Build host:** Ubuntu Server 24.04 LTS (AMD64, VirtualBox on Windows 11)
**Base distribution:** Alpine Linux / postmarketOS ecosystem  
**Status:** Hardware preparation complete; bootloader unlocking and native Linux support pending

---

## Project Vision

KRYPTA OS aims to transform an unused Android smartphone into a portable, headless Linux computer designed for:

- Authorized cybersecurity experiments.
- Network diagnostics and troubleshooting.
- Linux system administration.
- Embedded Linux development.
- Remote access from a tablet or laptop.
- Learning kernel development, cross-compilation and hardware integration.

The initial target is Xiaomi `lisa`. Support for additional ARM64 devices may be considered later.

### Definition of Success — v1.0

The project will be considered successful when:

- [ ] Native Linux boots reliably on the target phone.
- [ ] The device can operate without Android running.
- [ ] A persistent Linux root filesystem is available.
- [ ] Network connectivity is functional.
- [ ] SSH access works from a second device.
- [ ] The system can be administered without a local graphical desktop.
- [ ] Essential cybersecurity and diagnostic tools are available.
- [ ] The build process is documented and repeatable.
- [ ] A recovery procedure has been tested or otherwise verified.
- [ ] The project can be demonstrated as a portfolio case study.

**Important:** Native Wi-Fi, hotspot, USB and other hardware features depend on actual kernel, firmware and device support.

---

## Development Updates

### 2026-11-18

- Replaced the damaged Xiaomi `lisa` SIM-reader flex cable.
- Verified SIM detection, mobile connectivity, Wi-Fi, USB charging, ADB,
  Fastboot, cold boot, Android reboot and basic post-repair stability.
- Completed M4.1 — Hardware Repair.
- Identified the USB reconnection workaround required for Fastboot on Windows.
- Preserved locked bootloader and unverified native Linux support as active blockers.
- Synchronized the Windows and Ubuntu repositories using Git bundles.
- Revalidated the development environment and ARM64 cross-compilation.
- Installed QEMU User Mode 8.2.2.
- Successfully executed the ARM64 test binary on the x86_64 build host.
- Verified the ARM64 glibc runtime and successful process exit code.
- Encountered the Xiaomi bootloader unlock application quota limit.
- Automated ARM64 runtime verification through `make arm64-runtime-check`.
- Added QEMU to development environment diagnostics.
- Verified automatic binary rebuilding after manual artifact removal.
- Passed ShellCheck and Git whitespace validation.

---

# M0 — Foundation

**Status:** DONE
**Goal:** Establish a clean and documented development environment.

## M0.1 — Hardware Identification

- [x] Identify the target phone model.
- [x] Confirm device codename: `lisa`.
- [x] Identify the Snapdragon 778G platform.
- [x] Confirm ARM64 target architecture.
- [x] Verify Android ADB connectivity.
- [x] Verify Fastboot connectivity.
- [x] Check bootloader lock status.
- [x] Identify the active A/B boot slot.
- [x] Create `docs/hardware.md`.
- [x] Record current firmware and Android version.
- [x] Record available RAM and storage capacity.
- [x] Record hardware limitations and damaged components.
- [x] Document relevant device partitions without modifying them.

## M0.2 — Development Environment

- [x] Set up Ubuntu Server 24.04 LTS (AMD64) in VirtualBox on Windows 11.
- [x] Configure the VM with 4 vCPUs, 6 GB RAM, a 70 GB disk and NAT networking.
- [x] Enable OpenSSH Server and configure VirtualBox NAT port forwarding.
- [x] Verify SSH from Windows and a VS Code Remote - SSH terminal.
- [x] Keep GitHub authentication on Windows; use Git bundles to transfer history.
- [x] Verify the repository exists at `~/krypta-os`.
- [x] Verify base development tools with `make check` in the Ubuntu VM.
- [x] Document environment setup in `docs/setup.md`.

## M0.3 — Repository Initialization

- [x] Choose the project name: KRYPTA OS.
- [x] Create the private GitHub repository `krypta-os`.
- [x] Initialize the local Git repository.
- [x] Create the initial directory structure.
- [x] Finalize `.gitignore`.
- [x] Finalize `README.md`.
- [x] Create and maintain `ROADMAP.md`.
- [x] Configure Git commit identity.
- [x] Create the first Git commit.
- [x] Transfer the initial commit to GitHub from Windows.

## M0.4 — Developer Tooling

- [x] Implement `scripts/check-env.sh`.
- [x] Make the environment script executable.
- [x] Add `make help`.
- [x] Add `make check`.
- [x] Validate the Makefile.
- [x] Verify the environment script reports missing tools.
- [x] Add ShellCheck for Bash static analysis.
- [x] Document developer commands in README.

### M0 Exit Criteria

- [x] Local repository contains complete foundation files.
- [x] `make check` completes successfully in the Ubuntu Server VM.
- [x] Basic setup instructions are documented.
- [x] The first commit exists on GitHub.
- [x] A VM snapshot exists before advanced experiments.

---

# M1 — ARM64 Toolchain

**Status:** In progress
**Goal:** Build ARM64 binaries from an x86-64 Ubuntu host.

## M1.1 — Build Dependencies

- [ ] Install Clang.
- [ ] Install LLVM utilities.
- [ ] Install LLD linker.
- [x] Install GNU Make and other required build tools.
- [x] Install GCC cross-compiler for AArch64, if needed.
- [x] Install QEMU User Mode for AArch64 execution.
- [ ] Install Device Tree Compiler (`dtc`).
- [ ] Install kernel build dependencies.
- [ ] Install archive and compression utilities.
- [ ] Verify installed tool versions.

## M1.2 — Cross-Compilation

- [x] Understand host, build and target architectures.
- [x] Create a minimal C test program.
- [x] Cross-compile the program for AArch64.
- [x] Inspect the resulting binary with `file`.
- [x] Inspect ELF headers using `readelf`.
- [x] Verify the generated architecture is AArch64.
- [x] Document the compilation command.
- [x] Execute the ARM64 test program using QEMU User Mode.
- [x] Verify successful program output and exit code.
- [ ] Create `scripts/test-toolchain.sh`.

## M1.3 — Build Automation

- [ ] Add `make toolchain-check`.
- [x] Add a directory for generated outputs.
- [x] Add automatic output-directory creation.
- [x] Prevent generated binaries from entering Git.
- [x] Add `make arm64-runtime-check`.
- [x] Include QEMU in development environment diagnostics.
- [ ] Record selected compiler versions.
- [ ] Document the toolchain configuration.

### M1 Exit Criteria

- [x] AArch64 binaries can be built reproducibly.
- [x] Toolchain diagnostics pass.
- [x] Generated files remain outside version control.
- [ ] Build dependencies and versions are documented.

---

# M2 — Hardware Research & Kernel

**Status:** Not started  
**Goal:** Determine a viable Linux kernel and boot strategy for Xiaomi `lisa`.

## M2.1 — Hardware Research

- [ ] Research Qualcomm Snapdragon 778G Linux support.
- [ ] Identify relevant Qualcomm platform identifiers.
- [ ] Review publicly available Linux support for `lisa`.
- [ ] Research existing device ports.
- [ ] Review Linux kernel Device Tree support.
- [ ] Identify storage and UFS dependencies.
- [ ] Identify USB controller requirements.
- [ ] Identify Wi-Fi chipset and firmware requirements.
- [ ] Identify power-management requirements.
- [ ] Record unsupported or uncertain hardware.

## M2.2 — Kernel Strategy

- [ ] Compare mainline and downstream kernel approaches.
- [ ] Evaluate existing postmarketOS device support.
- [ ] Select an initial kernel source and version.
- [ ] Record the upstream repository and commit.
- [ ] Document known limitations of the selected kernel.
- [ ] Determine required device-specific patches.
- [ ] Determine the appropriate kernel configuration.
- [ ] Identify required Device Tree sources.

## M2.3 — Kernel Build

- [ ] Obtain kernel sources from a verified source.
- [ ] Configure an out-of-tree build directory.
- [ ] Generate an appropriate ARM64 kernel configuration.
- [ ] Compile the ARM64 kernel.
- [ ] Compile the Device Tree blobs.
- [ ] Inspect generated build artifacts.
- [ ] Record kernel build warnings and errors.
- [ ] Implement `make kernel` or an equivalent build command.
- [ ] Document reproducible build instructions.

## M2.4 — Firmware and Boot Requirements

- [ ] Identify required non-free firmware, if any.
- [ ] Document firmware licensing and redistribution constraints.
- [ ] Research the device boot chain.
- [ ] Determine Android boot image requirements.
- [ ] Investigate boot, vendor_boot and related partitions.
- [ ] Determine verified boot constraints.
- [ ] Research A/B slot implications.
- [ ] Document recovery and rollback considerations.
- [ ] Identify a safe first-boot strategy.

### M2 Exit Criteria

- [ ] Kernel sources and configuration are documented.
- [ ] ARM64 kernel compilation succeeds.
- [ ] Required Device Tree artifacts compile.
- [ ] Hardware dependencies are documented.
- [ ] Boot image requirements are understood sufficiently for controlled testing.

**Note:** A successful kernel build does not guarantee that it will boot on the target hardware.

---

# M3 — Minimal Root Filesystem

**Status:** Not started  
**Goal:** Create a lightweight ARM64 Linux userspace.

## M3.1 — Base System Selection

- [ ] Evaluate Alpine Linux rootfs tooling.
- [ ] Evaluate postmarketOS `pmbootstrap`.
- [ ] Select the root filesystem build approach.
- [ ] Determine target package architecture.
- [ ] Identify required base packages.
- [ ] Document repository and package trust assumptions.

## M3.2 — Rootfs Creation

- [ ] Build a minimal AArch64 root filesystem.
- [ ] Configure an init system.
- [ ] Configure basic filesystem mounts.
- [ ] Configure hostname and user accounts.
- [ ] Configure permissions and privilege escalation.
- [ ] Configure logging.
- [ ] Configure persistent storage where supported.
- [ ] Verify essential userspace binaries.
- [ ] Document the rootfs directory layout.

## M3.3 — Essential Services

- [ ] Configure OpenSSH.
- [ ] Configure an unprivileged administrative user.
- [ ] Configure SSH public-key authentication.
- [ ] Disable unnecessary services.
- [ ] Define secure defaults for remote administration.
- [ ] Configure basic networking.
- [ ] Add diagnostic utilities.

## M3.4 — Rootfs Validation

- [ ] Validate filesystem structure.
- [ ] Inspect executable architectures.
- [ ] Check required libraries and dependencies.
- [ ] Test the userspace in an appropriate emulator where practical.
- [ ] Verify init and service configuration.
- [ ] Document limitations of emulator-based testing.
- [ ] Package the root filesystem for later device integration.

### M3 Exit Criteria

- [ ] A minimal ARM64 root filesystem builds successfully.
- [ ] Essential configuration files are validated.
- [ ] SSH is configured for eventual device use.
- [ ] The userspace build is reproducible.

---

# M4 — Device Preparation & First Boot

**Status:** Hardware preparation complete; blocked by bootloader unlocking
**Goal:** Safely boot native Linux on the Xiaomi `lisa`.

## M4.1 — Hardware Repair

**Status:** Completed — 2026-11-18

- [x] Identify the damaged SIM-reader flex connection.
- [x] Replace the damaged SIM-reader assembly.
- [x] Verify SIM detection.
- [x] Verify mobile network connectivity.
- [x] Confirm USB connectivity remains functional.
- [x] Confirm device stability before unlocking.

## M4.2 — Bootloader Preparation

- [x] Confirm the bootloader is locked.
- [ ] Complete official Xiaomi unlocking requirements.
- [ ] Associate the Xiaomi account with the device.
- [ ] Complete any required waiting period.
- [ ] Unlock the bootloader through the official process.
- [ ] Verify the unlocked state.
- [ ] Document the procedure and consequences.

## M4.3 — Recovery Preparation

- [ ] Back up personal data.
- [ ] Record the exact firmware version.
- [ ] Obtain compatible recovery firmware.
- [ ] Verify firmware source and integrity.
- [ ] Document device-specific recovery procedures.
- [ ] Verify access to Fastboot after unlocking.
- [ ] Determine a safe rollback strategy.
- [ ] Avoid modifying partitions until recovery planning is complete.

## M4.4 — Image Preparation

- [ ] Confirm correct boot image format.
- [ ] Confirm the correct partition and slot strategy.
- [ ] Integrate kernel and rootfs as required.
- [ ] Validate image metadata.
- [ ] Review bootloader and verified-boot constraints.
- [ ] Verify compatibility with the exact device variant.
- [ ] Record image checksums.
- [ ] Prepare a controlled boot test plan.

## M4.5 — First Boot

- [ ] Attempt a non-persistent boot if supported and verified.
- [ ] Otherwise use a documented, device-compatible boot strategy.
- [ ] Capture boot logs where possible.
- [ ] Diagnose kernel or init failures.
- [ ] Confirm kernel startup.
- [ ] Confirm userspace startup.
- [ ] Confirm basic shell or remote access.
- [ ] Document the first successful boot.
- [ ] Record hardware components that do not work.

### M4 Exit Criteria

- [ ] Native Linux successfully boots.
- [ ] Userspace starts.
- [ ] Boot logs are captured.
- [ ] A recovery procedure is documented.
- [ ] Hardware limitations are recorded.

---

# M5 — Networking & Headless Access

**Status:** Not started  
**Goal:** Operate the phone as an independent remote Linux device.

## M5.1 — Network Interfaces

- [ ] Identify available network interfaces.
- [ ] Validate USB networking where supported.
- [ ] Investigate Wi-Fi driver initialization.
- [ ] Identify required wireless firmware.
- [ ] Bring up a supported network interface.
- [ ] Test DHCP or static IP configuration.
- [ ] Verify DNS and basic connectivity.

## M5.2 — SSH Access

- [ ] Start the SSH service.
- [ ] Connect from an authorized client.
- [ ] Configure SSH key authentication.
- [ ] Restrict direct root login.
- [ ] Disable password authentication when appropriate.
- [ ] Configure firewall rules.
- [ ] Test reconnection after reboot.
- [ ] Document remote administration.

## M5.3 — Portable Networking

- [ ] Investigate Wi-Fi access-point support.
- [ ] Test hotspot mode if supported.
- [ ] Configure private lab network addressing.
- [ ] Configure DHCP for connected clients if needed.
- [ ] Verify network isolation settings.
- [ ] Test access from the Samsung tablet.
- [ ] Document connectivity limitations.

## M5.4 — Reliability

- [ ] Monitor CPU and memory usage.
- [ ] Monitor battery and temperature where supported.
- [ ] Test network stability.
- [ ] Test SSH session stability.
- [ ] Test reboot and service recovery.
- [ ] Document power consumption.
- [ ] Identify thermal or power-management issues.

### M5 Exit Criteria

- [ ] The device has stable network connectivity.
- [ ] SSH administration works from another device.
- [ ] Security settings are documented.
- [ ] Networking limitations are understood.

---

# M6 — Cybersecurity Laboratory

**Status:** Not started  
**Goal:** Build a practical and authorized security testing environment.

## M6.1 — Core Tools

- [ ] Define the minimal security toolset.
- [ ] Add network inspection utilities.
- [ ] Add DNS troubleshooting utilities.
- [ ] Add packet capture tools where supported.
- [ ] Add TLS and certificate inspection tools.
- [ ] Add system auditing utilities.
- [ ] Document tool versions and purposes.
- [ ] Keep unnecessary services disabled.

## M6.2 — System Hardening

- [ ] Apply least-privilege principles.
- [ ] Review user and group permissions.
- [ ] Configure safe SSH defaults.
- [ ] Configure basic firewall rules.
- [ ] Review listening services.
- [ ] Audit installed packages.
- [ ] Establish a system update procedure.
- [ ] Document security assumptions and threat model.

## M6.3 — Lab Workflows

- [ ] Create a lab setup script.
- [ ] Create a network diagnostics script.
- [ ] Create a system health script.
- [ ] Define authorized testing scenarios.
- [ ] Build reproducible lab exercises.
- [ ] Document expected outputs.
- [ ] Document cleanup and reset procedures.

## M6.4 — Usability

- [ ] Improve shell configuration.
- [ ] Customize login banner or MOTD.
- [ ] Add useful command aliases.
- [ ] Improve command-line diagnostics.
- [ ] Create clear help and usage documentation.
- [ ] Verify usability on a tablet-based terminal client.

### M6 Exit Criteria

- [ ] Core diagnostics and security utilities work.
- [ ] The lab configuration is repeatable.
- [ ] The system is usable over SSH.
- [ ] Experiments are documented.

---

# M7 — Build Quality & Automation

**Status:** Not started  
**Goal:** Make KRYPTA OS maintainable and reproducible.

## M7.1 — Code Quality

- [ ] Lint Bash scripts with ShellCheck.
- [ ] Add consistent formatting conventions.
- [ ] Validate configuration files.
- [ ] Define error-handling conventions.
- [ ] Add basic automated tests.
- [ ] Review scripts for unsafe operations.

## M7.2 — Reproducibility

- [ ] Pin relevant upstream source revisions.
- [ ] Record toolchain versions.
- [ ] Document firmware dependencies.
- [ ] Document rootfs package versions where appropriate.
- [ ] Separate source files from build outputs.
- [ ] Add clean and rebuild commands.
- [ ] Verify a clean build from documented instructions.

## M7.3 — Automation

- [ ] Add local automated validation.
- [ ] Evaluate GitHub Actions for non-sensitive checks.
- [ ] Add workflow configuration if useful.
- [ ] Avoid uploading private firmware or credentials.
- [ ] Add build artifact verification.
- [ ] Document the limits of automated hardware testing.

### M7 Exit Criteria

- [ ] Build instructions work on a clean environment.
- [ ] Automated checks validate core project files.
- [ ] Important dependencies and versions are documented.

---

## Active Blockers

| Blocker | Impact | Planned Resolution |
|---|---|---|
| Xiaomi bootloader unlock application quota | Prevents obtaining unlock authorization | Retry through the official Xiaomi Community application |
| Locked bootloader | Prevents custom device boot | Official Xiaomi unlocking procedure |
| Unverified Linux device support | Kernel may not boot or initialize required peripherals | Research and test kernel and Device Tree support |
| Unverified Wi-Fi/AP support | May prevent the planned standalone hotspot | Test drivers, firmware and fallback network modes |

**Known Fastboot limitation:** Windows does not immediately recognize the device
after `adb reboot bootloader`. Disconnecting and reconnecting the USB-C cable
before using `fastboot devices` restores communication; this is documented as a
USB re-enumeration or Windows driver limitation until the root cause is confirmed.

---


# Safety Rules

- Do not run unreviewed scripts with `sudo`.
- Prefer verified upstream sources and official package repositories.
- Keep GitHub credentials outside the experimental VM.
- Never commit private credentials or sensitive device data.
- Do not commit large generated images to Git.
- Create VM snapshots before risky experiments.
- Do not flash images without device-specific compatibility checks.
- Do not assume that compiling a kernel proves it can boot.
- Record recovery information before changing device partitions.
- Perform security testing only on authorized systems.

---

# Progress Tracking Rules

1. Mark a checkbox `[x]` only after verifying the task is complete.
2. Keep `[ ]` for planned, blocked or unverified work.
3. Update the active milestone after each meaningful development session.
4. Document important problems and engineering decisions.
5. Commit roadmap updates alongside the related code changes.
6. Do not claim support for hardware or features that have not been tested.
7. Prefer working, measurable milestones over arbitrary deadlines.

---

## Project Status Summary

| Milestone | Name | Status |
|---|---|---|
| M0 | Foundation | Completed |
| M1 | ARM64 Toolchain | In progress |
| M2 | Hardware Research & Kernel | Not started |
| M3 | Minimal Root Filesystem | Not started |
| M4 | Device Preparation & First Boot | Hardware preparation complete; bootloader unlocking pending |
| M5 | Networking & Headless Access | Not started |
| M6 | Cybersecurity Laboratory | Not started |
| M7 | Build Quality & Automation | Not started |

**Next device-related objective:** M4.2 — Bootloader Preparation.
**Next major objective:** Complete M4.2 and preserve a safe recovery path before
native Linux image preparation.