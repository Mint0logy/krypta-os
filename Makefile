.DEFAULT_GOAL := help

.PHONY: help check

help:
	@echo "KRYPTA OS - Development commands"
	@echo
	@echo "  make help     Show available commands"
	@echo "  make check    Check development environment"

check:
	@bash scripts/check-env.sh