.DEFAULT_GOAL := help

ARM64_CC := aarch64-linux-gnu-gcc
ARM64_READELF := aarch64-linux-gnu-readelf
ARM64_OUTPUT := build/hello-arm64
ARM64_QEMU := qemu-aarch64
ARM64_SYSROOT := /usr/aarch64-linux-gnu

.PHONY: help check arm64-hello-check arm64-runtime-check

help:
	@echo "KRYPTA OS - Development commands"
	@echo ""
	@echo "  make help                  Show available commands"
	@echo "  make check                 Check development environment"
	@echo "  make arm64-hello-check     Build and verify ARM64 hello world"
	@echo "  make arm64-runtime-check   Build and execute ARM64 binary"

check:
	@bash scripts/check-env.sh

arm64-hello-check:
	@mkdir -p build
	$(ARM64_CC) -Wall -Wextra -Werror tests/arm64/hello-check.c -o $(ARM64_OUTPUT)
	@file $(ARM64_OUTPUT)
	@$(ARM64_READELF) -h $(ARM64_OUTPUT) | grep -E 'Class:|Machine:'
	@$(ARM64_READELF) -h $(ARM64_OUTPUT) | grep -q 'Machine:.*AArch64'
	@echo "[SUCCESS] ARM64 binary built and verified."

arm64-runtime-check: arm64-hello-check
	$(ARM64_QEMU) -L $(ARM64_SYSROOT) $(ARM64_OUTPUT)
	@echo "[SUCCESS] ARM64 runtime verified."