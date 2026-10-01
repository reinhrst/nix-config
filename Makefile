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
	@darwin-rebuild build --flake .#trc --show-trace
	@echo ""

activate-config:
	@RESULT_PATH=$$(readlink -f ./result); \
	if [ "$$(readlink -f /run/current-system)" = "$$RESULT_PATH" ]; then \
		echo "No changes detected."; \
	else \
		echo "Changes:"; \
		nix run nixpkgs#nvd -- diff /run/current-system $$RESULT_PATH || true; \
		echo ""; \
		if [ "$(PROMPT)" = "yes" ]; then \
			read -p "Apply these changes? [y/N] " -n 1 -r; echo; \
			[[ $$REPLY =~ ^[Yy]$$ ]] || { echo "Cancelled."; exit 0; }; \
		fi; \
		echo "Activating (darwin-rebuild switch, rolls back on failure)..."; \
		sudo darwin-rebuild switch --flake .#trc; \
	fi

confirm-and-switch: build-config

	$(MAKE) activate-config PROMPT=yes

switch: build-config
	$(MAKE) activate-config PROMPT=no

build-docker: check-untracked
	./build-docker-image.sh

update:
	./update-nixpackages.sh

update-even-if-locked-version-is-old:
	MAX_AGE_H=$$((24*365)) ./update-nixpackages.sh
