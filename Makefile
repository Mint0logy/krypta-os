.PHONY: help check

help:
	@echo "KRYPTA OS - Development commands"
	@echo
	@echo "  make check    Check development environment"

check:
	@bash scripts/check-env.sh