
# KRYPTA OS

**A pocket-sized Linux cybersecurity laboratory.**

KRYPTA OS is a personal embedded Linux project focused on transforming Android smartphones into portable ARM64 cybersecurity laboratories.

> **Status:** Early development. The system has not yet booted on the target device.

## Project Goals

- Run native Linux on a repurposed smartphone.
- Build a minimal ARM64 root filesystem.
- Enable remote access through SSH.
- Configure Wi-Fi networking.
- Create a reproducible build process.
- Learn embedded Linux and cybersecurity.

## Target Hardware

| Component | Specification |
|---|---|
| Device | Xiaomi 11 Lite 5G NE |
| Codename | `lisa` |
| SoC | Snapdragon 778G |
| Architecture | ARM64 / AArch64 |
| Build host | Ubuntu 24.04 LTS |

## Technology Stack

| Layer | Technology |
|---|---|
| Kernel | Linux |
| Base system | Alpine Linux / postmarketOS tooling |
| Build tools | Bash, GNU Make, ARM64 toolchain |
| Remote access | OpenSSH |
| Version control | Git |

## Planned Architecture

```text
KRYPTA OS
├── Device support
│   ├── ARM64 Linux kernel
│   ├── Device Tree
│   └── Hardware configuration
├── Root filesystem
│   ├── Alpine Linux base
│   ├── System services
│   └── Networking and SSH
├── Security laboratory
│   ├── Network diagnostics
│   └── Security tools
└── Build system
    ├── Environment checks
    └── Build scripts
```

## Development

Run the environment validation:

```bash
make check
```

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the development checklist.

## Disclaimer

KRYPTA OS is an experimental educational project for authorized cybersecurity research. Hardware support is not guaranteed.
