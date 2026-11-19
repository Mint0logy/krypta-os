# KRYPTA OS — Development Roadmap

**Updated:** 2026-11-19 · **Target:** Xiaomi `lisa` / SM7325 / AArch64

`[x]` = completed or documented decision/research, not proof of untested hardware. `[ ]` = remaining work. The latest supplied repository roadmap and documented test results are the progress baseline.

## Milestones

| ID | Milestone | State |
|---|---|---|
| M0 | Foundation | Complete |
| M1 | ARM64 Toolchain | In progress |
| M2 | Hardware Research & Kernel | Research started |
| M3 | Minimal Root Filesystem & Yocto | Planned |
| M4 | Device Preparation & First Boot | Repair complete; unlock blocked |
| M5 | Networking & Headless Access | Planned |
| M6 | Cybersecurity Laboratory & KRYPTA Core | Planned |
| M7 | Build Quality & Automation | Baseline checks done; full scope pending |

**Critical path:** M1 + M2 → M3 Alpine bring-up + M4 recovery/boot → P0 hardware and SSH (M5) → M3 Yocto migration → M6 → M7 release validation. Bootloader authorization (M4.2) can proceed in parallel; recovery planning (M4.3) must precede unlocking and flashing.

## M0 — Foundation

- [x] Identify model, codename, SoC and ARM64 architecture.
- [x] Inspect Android firmware, A/B slot, lock state, RAM, `/data` capacity and hardware limitations.
- [x] Record partition mappings without modifying the device.
- [x] Verify ADB and Fastboot communication.
- [x] Create hardware and development setup documentation.
- [x] Configure Ubuntu Server VM, resources, NAT and SSH forwarding; verify VS Code Remote SSH.
- [x] Configure Git identity, repository structure, `.gitignore`, initial commit and GitHub push.
- [x] Create README and ROADMAP; establish public personal portfolio repository.
- [x] Transfer committed history between Ubuntu and Windows with Git bundles; keep GitHub credentials on Windows.
- [x] Implement executable `scripts/check-env.sh`, including missing-tool detection and `make help` / `make check`.
- [x] Verify Makefile and base tools; add ShellCheck and document commands.
- [x] Create a VM snapshot.

Exact raw UFS capacity remains unverified; the recorded `/data` filesystem capacity is not the physical drive size.

## M1 — ARM64 Toolchain

- [x] Install GNU Make, GCC AArch64 cross-compiler, binutils and basic tools.
- [x] Create and cross-compile the ARM64 C smoke test; document the compilation command.
- [x] Verify ELF64/AArch64 architecture with `file` and `readelf`.
- [x] Install QEMU user mode (8.2.2); validate ARM64 glibc runtime, output and exit status.
- [x] Automate the test with `make arm64-runtime-check`; add QEMU to environment diagnostics.
- [x] Automatically create/rebuild generated output and keep it out of Git.
- [ ] Install and verify Clang, LLVM, LLD, DTC, kernel build and archive/compression dependencies.
- [ ] Record exact toolchain versions and complete toolchain documentation.
- [ ] Decide whether a separate `scripts/test-toolchain.sh` / `make toolchain-check` is useful beyond the existing runtime target.

## M2 — Hardware Research & Kernel

### M2.1 — Research

- [x] Identify SM7325/Kodiak platform and research upstream subsystem support.
- [x] Locate public `lisa` Device Tree work and Linux 7.4 integration evidence.
- [x] Research P0/P1/P2 dependencies and document source-backed preliminary support in [kernel-support.md](docs/kernel-support.md).
- [x] Identify WCN6750/ath11k as a candidate with STA/AP support and an upstream monitor-mode limitation.
- [ ] Confirm device-specific hardware IDs, DT nodes, firmware filenames, board data and dependencies from selected sources/Android inspection.
- [ ] Compare upstream and downstream/Android kernels and existing device ports; use downstream as reference where necessary.

### M2.2 — Kernel strategy

- [x] Decide on upstream Linux as the preferred base, one kernel and optional experimental modules.
- [x] Identify Linux `v7.4-rc3` (released 2026-11-15) as the initial candidate, subject to source validation.
- [ ] Verify the exact tag contents, `lisa` DTS, required drivers and full commit ID; pin the selected revision.
- [ ] Define monorepo layout for upstream references, configs, patches, BSP and later Yocto layers.
- [ ] Determine kernel configuration and minimal device-specific patches; document limitations.

### M2.3 — Build and boot dependencies

- [ ] Obtain verified upstream source and establish out-of-tree build automation.
- [ ] Compile ARM64 kernel and relevant DTBs; inspect artifacts and document warnings.
- [ ] Add a reproducible kernel build target and instructions.
- [ ] Identify firmware and redistribution constraints; do not commit restricted blobs.
- [ ] Validate boot-chain, image format, AVB and A/B implications using this device's actual firmware.
- [ ] Establish a safe first-boot strategy and required log capture.

## M3 — Minimal Root Filesystem & Yocto

### M3.1 — Temporary bring-up (Alpine)

- [x] Choose Alpine minimal AArch64 as the temporary userspace; Yocto is the final distribution build system.
- [ ] Select and verify an Alpine release/rootfs source (musl; distinct from the glibc smoke test).
- [ ] Configure init, mounts, users, privileges, logs, networking, SSH and diagnostics.
- [ ] Validate the rootfs and dependencies; test userspace in QEMU where suitable.
- [ ] Package the bring-up rootfs for M4; plan persistent storage without risking Android data.

### M3.2 — Final distribution (after M5 P0 + SSH validation)

- [ ] Review Yocto release/host requirements; provision sufficient storage and memory.
- [ ] Pin Yocto/OpenEmbedded/BitBake revisions; create distro, image and `lisa` machine/BSP layers.
- [ ] Integrate kernel, DT, firmware references, init, services and security defaults.
- [ ] Choose init and package format/backend; configure runtime package management and trusted package feeds.
- [ ] Build minimal ARM64 image and SDK; validate image, boot, persistent storage, networking and SSH on the phone.
- [ ] Reproduce P0 safety/reliability checks on the Yocto image.

## M4 — Device Preparation & First Boot

### M4.1 — Hardware repair (complete, 2026-11-18)

- [x] Identify damaged SIM-reader flex and install replacement.
- [x] Verify SIM detection, mobile connectivity and Wi-Fi under Android.
- [x] Verify USB charging, ADB, Fastboot and basic stability across restarts.
- [x] Document repair photos, battery diagnostics, network results and USB reconnection workaround.

### M4.2 — Bootloader preparation (blocked)

- [x] Confirm locked bootloader and identify official application quota as a blocker.
- [ ] Obtain official Xiaomi unlock authorization and complete account association/waiting requirements.
- [ ] Complete M4.3 pre-unlock requirements; perform official unlock and verify state.
- [ ] Confirm stable Fastboot after unlock and document procedure/consequences.

### M4.3 — Recovery preparation (before unlock/flash)

- [x] Record the inspected firmware version and existing A/B partition layout.
- [ ] Recheck exact variant, current firmware and slot; back up personal data.
- [ ] Obtain compatible recovery firmware, verify source/integrity and document restoration/rollback.
- [ ] Establish a credible recovery path and verify it as safely as possible before destructive operations.

### M4.4 — Image preparation and controlled boot

- [ ] Confirm image format, slot strategy, compatibility and verified-boot requirements.
- [ ] Assemble kernel, DT and temporary rootfs; inspect metadata and record checksums.
- [ ] Prefer a verified non-persistent boot method where supported; otherwise choose a reviewed device-specific strategy preserving Android during bring-up wherever possible.
- [ ] Capture logs, confirm kernel and userspace startup, secure shell access and document first boot.
- [ ] Record failed/unsupported hardware and verify recovery after testing.
- [ ] After validation of the final image, plan and execute the transition from Android to native Linux with persistent storage and a documented recovery route.

## M5 — Networking & Headless Access

### M5.1 — P0: essential hardware gate

- [ ] Verify all CPU cores, memory mapping/stability, IRQs and UFS integrity using safe test storage.
- [ ] Validate PMIC/regulators, battery telemetry, charging safety, thermal sensors and thermal protection.
- [ ] Verify CPU frequency/idle, energy use, stable reboot and safe shutdown.
- [ ] Record limitations and stop device testing if charging/thermal safety cannot be established.

### M5.2 — P1: connectivity & SSH

- [ ] Bring up working USB or Wi-Fi network; verify DHCP/static addressing, DNS and connectivity.
- [ ] Confirm SSH from laptop/tablet; implement key authentication, non-root administration and firewall rules.
- [ ] Verify automatic service startup and stable SSH/network reconnection after reboot.
- [ ] Validate built-in Wi-Fi STA and AP/hotspot, firmware and client isolation; document concurrency limits and fallback.
- [ ] Validate USB host/OTG, USB gadget networking and USB Ethernet adapter options, including power budget.
- [ ] Test stability and document access from the Samsung tablet.

P0 and SSH must pass before the Yocto migration; remaining P1 networking can be completed in parallel with or after migration.

### M5.3 — P2: optional connectivity

- [ ] Investigate LTE/5G data (remoteproc, IPA, QRTR, QMI, firmware) and Bluetooth/BlueZ; validate only where useful.

## M6 — Cybersecurity Laboratory & KRYPTA Core

### M6.1 — Native tools and wireless lab

- [ ] Define and package essential network, DNS, capture, TLS and system-audit tools using native Yocto recipes.
- [ ] Validate built-in monitor mode and packet injection separately in an authorized isolated lab; investigate feasible upstream improvements.
- [ ] If needed, qualify a compatible USB Wi-Fi adapter with both capabilities and ensure stable OTG/power operation. Both modes are required for v1.0 on at least one supported interface.
- [ ] Create reproducible authorized lab scenarios, expected outputs and cleanup/reset workflows.
- [ ] Evaluate an isolated optional Kali userspace/container if resources and kernel features allow; no Kali repositories mixed into native packages.

### M6.2 — KRYPTA Core

- [ ] Define Hardware API and stable interfaces for system monitoring and network management.
- [ ] Implement hardware capability detection, health/status reporting and network management.
- [ ] Implement permission boundaries and error handling; validate against actual device capabilities.
- [ ] Create isolated optional educational modules/experiments (see support matrix); keep existing safety-critical drivers authoritative.

### M6.3 — CLI/TUI and packages

- [ ] Design and implement shared CLI/TUI administration, lab management, help and diagnostics.
- [ ] Integrate an original package interface backed by the selected native manager; support search, install, remove, list and package metadata/refresh.
- [ ] Build and test a personal package feed with metadata, signatures/trust, dependency handling and compatible versions.
- [ ] Verify usability over tablet SSH and package operations on the final OS.
- [ ] Review least privilege, installed packages, listening services, secure defaults and threat model.

## M7 — Build Quality & Automation

- [x] Baseline automated environment/runtime checks, ShellCheck and Git whitespace validation passed (2026-11-18).
- [x] Separate the current smoke-test binaries from tracked sources.
- [ ] Define consistent formatting, error handling, config validation, automated tests and safe script review across new components.
- [ ] Pin upstream sources and documented firmware/package/toolchain versions; verify clean rebuilds and artifact separation.
- [ ] Automate image validation and checksums; evaluate GitHub Actions for non-sensitive checks.
- [ ] Version complete images and document manual image installation, backup/restore and rollback; no OTA system updater.
- [ ] Validate clean build, final hardware support, persistent rootfs, stable SSH, required wireless lab modes and recovery.
- [ ] Document a portfolio demonstration, known limitations and licensing/redistribution obligations; no public image distribution or community support commitment.

## Active blockers

| Blocker | Next action |
|---|---|
| Official Xiaomi unlock quota / locked bootloader | Retry official application; prepare recovery in parallel |
| Native Linux not yet tested | Complete M1–M3 bring-up prerequisites |
| Unknown power/thermal safety | Validate P0 before sustained device use |
| Built-in wireless audit capability not confirmed | Assess driver/firmware; qualify USB fallback |
| Current VM resources limited for Yocto | Review/expand storage and memory before migration |

See [hardware.md](docs/hardware.md) for Fastboot and physical limitations. Only update checkboxes after evidence; research or emulator success is not proof of on-device operation.