
# VirtualBox Troubleshooting

> **Final outcome:** The Ubuntu Desktop VM problems were not resolved. Work
> moved to Ubuntu Server without a graphical interface; no single definitive
> cause for all of the freezes was established. This document is a historical
> record of the unresolved Ubuntu Desktop issues.

## Environment

| Component | Configuration |
|---|---|
| Host OS | Windows 11 |
| Hypervisor | Oracle VirtualBox 7.2.22 r175245 |
| Guest OS | Ubuntu 24.04.5 LTS (x86_64) |
| Guest kernel | 7.0.0-43-generic |
| CPU | 4 vCPUs |
| RAM | 6 GB |
| Graphics | VBoxSVGA, 128 MB VRAM, 3D disabled |
| Desktop | GNOME (X11) |

## Problem

Ubuntu experiences intermittent graphical startup failures, black screens, severe desktop lag and occasional system freezes.

Observed symptoms:

- Graphical login sometimes fails to appear.
- GNOME may freeze during or after login.
- The boot splash screen can become unresponsive.
- Switching to TTY3 (`Right Ctrl + F3`) sometimes restores access.
- In some cases, the VM stops responding to ACPI shutdown.
- Desktop performance is poor at higher resolutions.

The Foundation snapshot was restored to recover access to the system.

## Investigation

### Graphics

Two VirtualBox graphics controllers were tested.

**VMSVGA**

- Kernel driver: `vmwgfx`
- Reported an unsupported hypervisor configuration.
- Kernel logs included `soft lockup` errors affecting `gnome-shell`.

**VBoxSVGA**

- Kernel driver: `vboxvideo`
- Allowed graphical login during some attempts.
- Reported the following errors:

```text
vboxvideo: vbva_enable failed
vboxvideo: hgsmi_get_mode_hints failed: -5
```

OpenGL diagnostics:

```text
OpenGL renderer string: llvmpipe (LLVM 20.1.2, 256 bits)
Accelerated: no
```

Rendering is software-based rather than GPU-accelerated.

Reducing the display resolution from 2560 × 955 to 1600 × 900 noticeably improved responsiveness, but did not eliminate the problem.

### System resources

Resource usage during diagnostics:

- RAM: approximately 1.3 GiB of 5.8 GiB used.
- Available RAM: approximately 4.5 GiB.
- Swap usage: 0.
- CPU: approximately 86% idle during measurement.

No sustained resource exhaustion was observed.

### Guest Additions

Two Guest Additions installations are present:

| Component | Version |
|---|---|
| Ubuntu packages (`virtualbox-guest-utils`, `virtualbox-guest-x11`) | 7.0.16 |
| Oracle Guest Additions (`/opt/VBoxGuestAdditions-7.2.22/`) | 7.2.22 |
| VirtualBox host | 7.2.22 |

The Oracle installer built kernel modules for `7.0.0-43-generic` and updated the initramfs.

The installation log also reported systemd transaction conflicts while attempting to start Guest Additions services.

Diagnostics confirmed:

```text
modinfo -F version vboxguest
7.2.22 r175245

modinfo -n vboxguest
/lib/modules/7.0.0-43-generic/misc/vboxguest.ko
```

The executable `/usr/sbin/VBoxService` also reports version `7.2.22`, despite the Ubuntu packages still being installed.

Service status:

| Service | Status |
|---|---|
| `vboxadd.service` | Completed successfully |
| `vboxadd-service.service` | Failed |
| `virtualbox-guest-utils.service` | Running when last checked |

Additional diagnostics:

```text
rcvboxadd status-kernel
VirtualBox Guest Additions: kernel modules 7.2.22 are loaded

rcvboxadd status-user
VirtualBox Guest Additions: user-land services 7.2.22 are not running
```

Guest-to-host communication works when `VBoxControl` is executed with root privileges:

```text
sudo VBoxControl guestproperty get /VirtualBox/HostInfo/VBoxVer
Value: 7.2.22
```

The overlapping Guest Additions installations may be contributing to service conflicts. This has not yet been confirmed as the root cause of the graphical failures.

## Status at the time

**Unresolved — investigation ongoing.**

- Foundation snapshot restored.
- Ubuntu accessible through TTY3.
- Graphical startup remains unreliable.
- Oracle Guest Additions kernel modules 7.2.22 are loaded.
- Oracle Guest Additions user-land service is not running correctly.
- No further package removal or graphics configuration changes had been performed.

## Planned investigation at the time

1. Test whether stopping `virtualbox-guest-utils.service` allows `vboxadd-service.service` to start.
2. Verify which Guest Additions processes and services are active.
3. Resolve overlapping Guest Additions installations.
4. Verify graphical startup stability and rendering performance.
5. Resume KRYPTA OS development after stabilizing the VM.

## Useful commands

```bash
# System and kernel
uname -r
systemctl is-system-running
systemctl --failed --no-pager

# Graphics
lspci -nnk | grep -A 4 -Ei 'VGA|Display'
glxinfo -B
journalctl -k -b --no-pager | grep -Ei 'vmwgfx|vboxvideo|soft lockup|drm'

# Guest Additions
VBoxControl --version
modinfo -F version vboxguest
sudo rcvboxadd status-kernel
sudo rcvboxadd status-user
systemctl status vboxadd.service vboxadd-service.service --no-pager

# Recovery
# Switch to TTY3: Right Ctrl + F3
sudo systemctl restart gdm3
```

**Note:** Restarting GDM has temporarily restored the graphical login during some attempts, but is not a confirmed permanent fix.
