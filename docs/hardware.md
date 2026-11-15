
# Target Hardware — Xiaomi 11 Lite 5G NE

## Device

| Property | Value |
|---|---|
| Model | Xiaomi 11 Lite 5G NE (`2109119DG`) |
| Codename | `lisa` |
| SoC | Qualcomm Snapdragon 778G |
| CPU architecture | ARM64 / AArch64 |
| RAM | 8 GB variant (7.04 GiB reported by `/proc/meminfo`) |
| Internal storage | Likely 128 GB variant; total UFS capacity not independently verified |
| `/data` filesystem | 105 GiB total, 12 GiB used, 93 GiB available |
| Android | 14 (HyperOS) |
| Firmware | `V816.0.12.0.UKOEUOR` |
| Baseband | `4.3CPL2-gl-0210_0203_e418bd70ab1` |


## Confirmed device state

| Check | Result |
|---|---|
| ADB over USB | Working |
| Fastboot over USB | Working |
| `fastboot getvar product` | `lisa` |
| `fastboot getvar unlocked` | `no` |
| `fastboot getvar current-slot` | `b` at initial inspection |
| Android SIM state | `ABSENT,ABSENT` |
| Wi-Fi under Android | Working |

The SIM-reader flex cable is severed, and the rear cover is missing. The SIM connection needs repair before attempting the official Xiaomi bootloader-unlocking procedure. Avoid exposed contacts and mechanical pressure on the battery.

The bootloader is **locked**. No KRYPTA OS image has been booted or flashed. Slot, firmware and device state must be checked again before any bootloader or partition operation.

## Partition Layout

Partition names and block-device mappings were inspected using
`adb shell ls -l /dev/block/by-name`.

The device uses an A/B boot scheme. The active slot was `b` at the time of the initial Fastboot inspection.

| Partition | Block device |
|---|---|
| `boot_a` / `boot_b` | `sde11` / `sde35` |
| `vendor_boot_a` / `vendor_boot_b` | `sde22` / `sde46` |
| `dtbo_a` / `dtbo_b` | `sde15` / `sde39` |
| `vbmeta_a` / `vbmeta_b` | `sde14` / `sde38` |
| `vbmeta_system_a` / `vbmeta_system_b` | `sda21` / `sda22` |
| `super` | `sda20` |
| `userdata` | `sda33` |
| `metadata` | `sda24` |
| `persist` | `sda8` |
| `modemst1` / `modemst2` | `sdf2` / `sdf3` |

The partition layout was inspected without modifying any block devices.

Partition mappings may change with firmware updates and must be reverified before any boot or flashing operation.

## Linux support

Linux boot, UFS, USB, Wi-Fi, hotspot, charging and power management on this device are **not yet verified**. Android functionality does not confirm support in a custom Linux kernel.

The intended first boot is a minimal **headless ARM64 Linux system**. Kernel source, device tree, firmware dependencies, boot image layout and a device-specific recovery procedure must be established before any flashing.
