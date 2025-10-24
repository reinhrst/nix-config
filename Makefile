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

build-config: check-untracked
	@echo "Building configuration..."
	@nix run nixpkgs#home-manager build -- --flake .#reinoud@mindy --show-trace
	@echo ""

activate-config:
	@CURRENT_GEN=$$(nix run nixpkgs#home-manager generations -- --flake .#reinoud@mindy | head -1 | awk '{print $$7}'); \
	RESULT_PATH=$$(readlink -f ./result); \
	if [ "$$(readlink -f $$CURRENT_GEN)" = "$$RESULT_PATH" ]; then \
		echo "No changes detected."; \
	else \
		echo "Changes:"; \
		nix run nixpkgs#nvd -- diff $$CURRENT_GEN $$RESULT_PATH || true; \
		echo ""; \
		if [ "$(PROMPT)" = "yes" ]; then \
			read -p "Apply these changes? [y/N] " -n 1 -r; \
			echo; \
			if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
				echo "Activating..."; \
				$$RESULT_PATH/activate; \
			else \
				echo "Cancelled."; \
			fi; \
		else \
			$$RESULT_PATH/activate; \
		fi; \
	fi

confirm-and-switch: build-config
	$(MAKE) activate-config PROMPT=yes

switch: build-config
	$(MAKE) activate-config PROMPT=no
