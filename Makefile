SHELL := /bin/bash

.DEFAULT_GOAL := confirm-and-switch

check-untracked:
	@UNTRACKED=$$(git ls-files --others --exclude-standard '*.nix'); \
	if [ -n "$$UNTRACKED" ]; then \
		echo "Found untracked .nix files:"; \
		echo "$$UNTRACKED" | sed 's/^/  /'; \
		echo ""; \
		read -p "Add these files with --intent-to-add? [y/N] " -n 1 -r; \
		echo; \
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
			echo "$$UNTRACKED" | xargs git add --intent-to-add; \
			echo "Files added with --intent-to-add"; \
		else \
			echo "Warning: Builds may fail if these files are referenced"; \
		fi; \
	fi

confirm-and-switch: check-untracked
	@echo "Building configuration..."
	@nix run nixpkgs#home-manager build -- --flake .#reinoud@mindy
	@echo ""
	@CURRENT=$$(nix run nixpkgs#home-manager generations -- --flake .#reinoud@mindy | head -1 | awk '{print $$7}'); \
	if [ "$$(readlink -f $$CURRENT)" = "$$(readlink -f ./result)" ]; then \
		echo "No changes detected."; \
	else \
		echo "Changes:"; \
		nix run nixpkgs#nvd -- diff $$CURRENT ./result || true; \
		echo ""; \
		read -p "Apply these changes? [y/N] " -n 1 -r; \
		echo; \
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
			echo "Activating..."; \
			./result/activate; \
		else \
			echo "Cancelled."; \
		fi; \
	fi

switch: check-untracked
	@echo "Building configuration..."
	@nix run nixpkgs#home-manager build -- --flake .#reinoud@mindy
	@echo ""
	@CURRENT=$$(nix run nixpkgs#home-manager generations -- --flake .#reinoud@mindy | head -1 | awk '{print $$7}'); \
	if [ "$$(readlink -f $$CURRENT)" = "$$(readlink -f ./result)" ]; then \
		echo "No changes detected."; \
	else \
		echo "Changes:"; \
		nix run nixpkgs#nvd -- diff $$CURRENT ./result || true; \
		echo ""; \
		./result/activate; \
	fi
