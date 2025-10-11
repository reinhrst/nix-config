SHELL := /bin/bash

confirm-and-switch:
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

switch:
	nix run nixpkgs#home-manager switch -- --flake .#reinoud@mindy
