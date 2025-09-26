.PHONY: install switch update check clean help

# Get the current username
USERNAME := $(shell whoami)
CONFIG_DIR := $(shell pwd)

help: ## Show this help message
	@echo "Home Manager Configuration Management"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install home-manager for the first time
	@echo "🏠 Installing Home Manager..."
	@./install.sh

switch: ## Apply configuration changes
	@echo "🔄 Switching to new configuration..."
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager switch --flake $(CONFIG_DIR); \
	else \
		nix run nixpkgs#home-manager -- switch --flake $(CONFIG_DIR); \
	fi

update: ## Update flake inputs and apply
	@echo "📦 Updating flake inputs..."
	@nix flake update
	@echo "🔄 Applying updated configuration..."
	@if command -v home-manager >/dev/null 2>&1; then \
		home-manager switch --flake $(CONFIG_DIR); \
	else \
		nix run nixpkgs#home-manager -- switch --flake $(CONFIG_DIR); \
	fi

check: ## Check configuration without building
	@echo "✅ Checking configuration..."
	@nix flake check --no-build

build: ## Build configuration without switching
	@echo "🔨 Building configuration..."
	@nix build .#homeConfigurations.$(USERNAME).activationPackage

generations: ## List all generations
	@echo "📚 Home Manager generations:"
	@home-manager generations

rollback: ## Rollback to previous generation
	@echo "⏪ Rolling back to previous generation..."
	@home-manager rollback

clean: ## Clean up old generations
	@echo "🧹 Cleaning up old generations..."
	@home-manager expire-generations "-30 days"
	@nix-collect-garbage

# Information targets
info: ## Show system information
	@echo "System Information:"
	@echo "  User: $(USERNAME)"
	@echo "  Config Dir: $(CONFIG_DIR)"
	@echo "  Nix Version: $(shell nix --version 2>/dev/null || echo 'Not installed')"
	@echo "  Home Manager: $(shell home-manager --version 2>/dev/null || echo 'Not installed')"
	@echo "  Platform: $(shell uname -s -m)"

validate: ## Validate all nix files
	@echo "🔍 Validating nix files..."
	@find . -name "*.nix" -exec nix-instantiate --parse {} \; > /dev/null
	@echo "✅ All nix files are valid"