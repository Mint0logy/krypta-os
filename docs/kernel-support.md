# Linux Kernel — Hardware Support Matrix

**Research snapshot:** 2026-11-19 · **Device:** Xiaomi `lisa` / Qualcomm SM7325 (Kodiak)

The matrix distinguishes available kernel infrastructure, external device-port claims and actual verification. **No native Linux feature has been validated on our phone yet.** The Android repair results are recorded separately in [hardware.md](hardware.md).

## Evidence legend

| Mark | Meaning |
|---|---|
| 🟢 Upstream | Relevant upstream subsystem/driver exists; device integration still needs testing. |
| 🔵 Board | Device-specific DTS or port evidence exists; not an independent functional test. |
| 🟡 Unverified | Partial/platform-level support or unresolved device/firmware compatibility. |
| 🔴 Limitation | Documented driver limitation or no confirmed complete solution. |

`P0` = boot and safe operation; `P1` = connectivity and required lab functions; `P2` = optional enhancements. These are priorities, not completion states. The final column contains proposed educational exercises, not production-driver commitments. Use emulation or isolated test modules for low-level experiments; do not replace charging, power or thermal protections with unvalidated code.

## Kernel baseline

Linux `v7.4-rc3` was released on 2026-11-15 and is the selected initial candidate, not a built or pinned revision [1]. Initial `lisa` support was submitted as a v3 DTS series on 2026-07-17 [2]; subsequent Linux 7.4 Device Tree pull and merge evidence includes `sm7325-xiaomi-lisa.dts` [3]. A kernel-tree mirror also contains the board file [4]. This is stronger evidence than an unmerged patch alone, but the exact `v7.4-rc3` file and its dependencies must still be checked in our source checkout. The direct tag-file request was unavailable during this review. Kodiak platform support [5] covers multiple boards, not necessarily our phone.

## P0–P2 support matrix

| Priority / component | Available support and evidence | Required KRYPTA OS work | Optional educational implementation |
|---|---|---|---|
| **P0 — CPU** | 🟢 ARM64 boot/SMP and Kodiak CPU support [5, 6] | Verify all cores, topology, clocks and stability | Toy scheduler in an isolated mini-kernel / QEMU |
| **P0 — RAM** | 🟢 ARM64 memory infrastructure; board reserved-memory definitions [4, 6] | Verify RAM mapping, reservations and integrity | Toy memory allocator |
| **P0 — Interrupts** | 🟢 ARM GIC/IRQ infrastructure [6] | Confirm platform interrupt routing, diagnose device IRQs | IRQ exercise using a virtual test device |
| **P0 — UFS storage** | 🔵 Board DTS/port evidence; Kodiak UFS driver support [2–5] | Verify enumeration, reads, then integrity on disposable test storage | RAM-backed virtual block device |
| **P0 — PMIC** | 🔵 Board regulator definitions, existing Qualcomm PMIC support [2, 4, 5] | Validate power rails, clocks and firmware dependencies | Read-only diagnostic module |
| **P0 — Battery monitoring** | 🟡 `qcom_battmgr` exists; device protocol/telemetry unknown [7, 8] | Verify power-supply interface, units, capacity and temperature readings | Virtual battery / telemetry service |
| **P0 — Battery charging** | 🟡 No qualified `lisa` charging solution; Kodiak charge-control RFC indicates ongoing work [8] | Establish safe firmware-managed charging and protection; validate under supervision | Charger simulator only |
| **P0 — Thermal sensors** | 🔵 Board thermal-sensor support reported; Kodiak TSENS available [2, 5] | Validate sensor readings and mapping | Sensor monitoring module |
| **P0 — Thermal protection** | 🟡 Generic Linux thermal framework exists; complete device safeguards unverified [5, 9] | Verify trip points, cooling, throttling and emergency shutdown without defeating protection | Thermal policy simulator |
| **P0 — CPU frequency / idle** | 🟢 Kodiak CPUFreq/CPUIdle support [5, 10] | Verify policies, power draw, idle and thermal interaction | Experimental policy on a suitable virtual or simulated platform |
| **P0 — Shutdown / reboot** | 🟡 ARM64/platform infrastructure exists; reliable device power-off/reset not established [4–6] | Verify shutdown, restart and recovery behavior | System-management service |
| **P1 — Wi-Fi client** | 🔵 Board port reports WLAN; WCN6750 `ath11k` offers STA [2, 4, 11, 12] | Confirm chipset, firmware/board data, regulatory settings and connectivity | Network-management service |
| **P1 — Wi-Fi AP** | 🟢 WCN6750 driver advertises AP [11, 12]; phone not tested | Validate hotspot, isolation, supported concurrency and stability | Hotspot manager |
| **P1 — Monitor mode** | 🔴 Inspected WCN6750 driver has monitor support disabled [12] | Assess exact selected driver/firmware; qualify USB fallback if necessary | Receive-only capture analysis on approved lab traffic |
| **P1 — Packet injection** | 🔴 No verified built-in solution; STA/AP does not establish raw-frame TX capability [11, 12] | Validate separate capability in an authorized lab; fall back to suitable USB adapter | Offline frame-format/parser experiments |
| **P1 — USB-C controller** | 🔵 Board DTS declares high-speed (USB 2.0) and dual-role Type-C configuration [4] | Validate enumeration, role switching and power behavior | Virtual USB device experiment |
| **P1 — USB Host / OTG** | 🟡 Kodiak OTG support and board role declarations [4, 5] | Test host role, external devices and safe VBUS/power budget | Driver for an isolated simple USB test device |
| **P1 — USB Gadget** | 🟢 Linux gadget/configfs framework exists [13] | Verify usable device controller and required functions | Custom test gadget function |
| **P1 — Ethernet / RJ45 adapter** | 🟢 Existing USB Ethernet drivers, e.g. `r8152` [14] | Match driver to adapter, verify USB host role, link and power | Virtual network device |
| **P1 — Ethernet / USB Gadget** | 🟢 Linux CDC ECM and RNDIS gadget functions exist [13, 15] | Select host-compatible function, confirm addressing and SSH | Isolated USB data-protocol exercise |
| **P2 — LTE modem** | 🟡 Kodiak remoteproc/IPA and QRTR modem userspace paths exist [5, 16] | Integrate device firmware, modem interfaces, QMI/QRTR and data path; test with authorized SIM | Modem status/monitoring service |
| **P2 — 5G modem** | 🟡 Android 5G verified; native Linux 5G session not confirmed [16; hardware log] | Verify actual 5G registration/data once LTE path works | Read-only modem diagnostics |
| **P2 — Bluetooth** | 🔵 Board port reports support and DTS includes WCN6750 Bluetooth [2, 4] | Integrate firmware and BlueZ, verify controller and transfers | Virtual HCI test device |

## Engineering conclusions

- **Reuse upstream first.** A board DTS is available in kernel-tree evidence, so start by checking the selected tag and adapting its configuration, firmware and boot integration instead of rewriting drivers blindly.
- **Treat power as a hard gate.** The existence of a battery telemetry driver, thermal sensors or regulator nodes is not evidence of safe charging or effective thermal shutdown. Do not bypass hardware/firmware safeguards.
- **Wireless audit modes are a real risk.** The inspected `ath11k/core.c` WCN6750 hardware entry advertises station and AP modes but explicitly sets `supports_monitor = false`. This is a driver-code observation, not proof of permanent silicon inability. Injection is independently unverified. Both capabilities are required for v1.0; internal Wi-Fi is preferred, a validated USB adapter is accepted. Do not assume AP/monitor concurrency, or that flipping a flag is sufficient.
- **USB is a fallback, not a guarantee.** Host and gadget use opposite USB roles. Validate the available controller, adapter compatibility and power before relying on either. USB gadget networking may provide an early SSH path even before Wi-Fi is ready.
- **Yocto comes after P0 and SSH.** Build a minimal Alpine ARM64 bring-up first; use Yocto recipes, a native package backend and trusted feeds for the final OS. The [Yocto package manual](https://docs.yoctoproject.org/current/dev-manual/packages.html) explains runtime package management; the format and init remain open decisions.

## Sources

Reviewed 2026-11-19. Versioned links are preferred for repeatability; moving documentation/source branches must be checked again when a revision is pinned. Some mailing-list and mirror pages were available through indexed excerpts rather than full-page retrieval. No external test claim is treated as our own result.

| Ref | Source | Evidence scope |
|---|---|---|
| 1 | [Kernel.org releases](https://cdn.kernel.org/); [Linux 7.4-rc3 announcement](https://lkml.iu.edu/2611.1/24313.html) | Release existence/date |
| 2 | [Initial lisa DTS v3 series, 2026-07-17](https://lists.openwall.net/linux-kernel/2026/07/17/1553); [v3 board patch](https://lkml.iu.edu/hypermail/linux/kernel/2607.2/03676.html) | Port author's initial hardware scope; indexed excerpts |
| 3 | [SoC Device Tree pull for 7.4](https://lists.openwall.net/linux-kernel/2026/10/22/700); [merge commit 7b9a0e857b42 (mirror)](https://git.zx2c4.com/wireguard-linux/commit/?id=7b9a0e857b427cdda5a08b662dbea7321e6bb470) | Inclusion of board DTS in 7.4 merge evidence; indexed excerpts |
| 4 | [lisa DTS in kernel tree, at merge commit (mirror)](https://git.zx2c4.com/wireguard-linux/tree/arch/arm64/boot/dts/qcom/sm7325-xiaomi-lisa.dts?id=7b9a0e857b427cdda5a08b662dbea7321e6bb470); [kernel-tree copy](https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/%2B/refs/heads/master/arch/arm64/boot/dts/qcom/sm7325-xiaomi-lisa.dts) | Board declaration evidence, not board tests |
| 5 | [Qualcomm mainline status — Kodiak](https://linux-msm.github.io/mainline-status/soc/kodiak) | Platform subsystems and tested boards; not a lisa certification |
| 6 | [Linux — Booting AArch64](https://docs.kernel.org/arch/arm64/booting.html) | ARM64 boot, memory and interrupt requirements |
| 7 | [Upstream qcom_battmgr.c](https://github.com/torvalds/linux/blob/master/drivers/power/supply/qcom_battmgr.c) | Qualcomm battery-manager code |
| 8 | [Kodiak battery charge-control RFC, 2026-10-18](https://lists.openwall.net/linux-kernel/2026/10/18/439) | Ongoing charge-control development; not proof of safe charging |
| 9 | [Linux thermal framework](https://docs.kernel.org/driver-api/thermal/sysfs-api.html) | Thermal zones, cooling devices and trip points |
| 10 | [Linux CPUFreq](https://docs.kernel.org/admin-guide/pm/cpufreq.html) | Frequency scaling infrastructure |
| 11 | [WCN6750 support submission](https://lists.infradead.org/pipermail/ath11k/2022-April/003031.html); [ath11k documentation](https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11k.html) | Driver support scope |
| 12 | [Upstream ath11k/core.c](https://github.com/torvalds/linux/blob/master/drivers/net/wireless/ath/ath11k/core.c) | Inspected WCN6750 hardware entry, STA/AP and monitor flag |
| 13 | [Linux USB gadget configfs](https://docs.kernel.org/usb/gadget_configfs.html); [gadget testing](https://docs.kernel.org/usb/gadget-testing.html) | Generic gadget setup/functions |
| 14 | [Upstream r8152 USB Ethernet driver](https://github.com/torvalds/linux/blob/master/drivers/net/usb/r8152.c) | Example adapter driver, not a tested adapter |
| 15 | [Linux multifunction gadget](https://docs.kernel.org/usb/gadget_multi.html) | ECM/RNDIS functions |
| 16 | [ModemManager — WWAN device types](https://modemmanager.org/docs/modemmanager/wwan-device-types/) | Qualcomm modem architecture, QRTR/QMI and IPA integration |