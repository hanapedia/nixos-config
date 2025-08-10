SUDO := sudo
FLAKE := $(shell hostname)
REGISTRY_DIR := /srv/registry
REGISTRY_CONFIG := $(REGISTRY_DIR)/config.yaml
REGISTRY_SRC := pkg/registry/config.yaml

.PHONY: rebuild
rebuild:
	$(SUDO) nixos-rebuild switch --flake .#$(FLAKE)


.PHONY: registry
registry:
	@echo "Preparing local registry directory at $(REGISTRY_DIR)..."
	@(SUDO) mkdir -p $(REGISTRY_DIR)
	@$(SUDO) chmod 755 $(REGISTRY_DIR)
	@if [ -f "$(REGISTRY_CONFIG)" ]; then \
		echo "Config already exists at $(REGISTRY_CONFIG) — skipping copy."; \
	else \
		echo "Installing default registry config from $(REGISTRY_SRC)"; \
		$(SUDO) cp $(REGISTRY_SRC) $(REGISTRY_CONFIG); \
		$(SUDO) chmod 644 $(REGISTRY_CONFIG); \
	fi
	@echo "Registry directory ready."

CLIENT_REG_DIR   ?= /etc/containers
CLIENT_REG_CONF  ?= $(CLIENT_REG_DIR)/registries.conf
CLIENT_REG_SRC   ?= pkg/registry/registries.conf
SUDO             ?= sudo

.PHONY: client-registry
client-registry:
	@echo "Preparing client registry config at $(CLIENT_REG_CONF)..."
	@$(SUDO) mkdir -p $(CLIENT_REG_DIR)
	@if [ -f "$(CLIENT_REG_CONF)" ]; then \
		echo "Existing $(CLIENT_REG_CONF) found."; \
		if cmp -s "$(CLIENT_REG_SRC)" "$(CLIENT_REG_CONF)"; then \
			echo "Config is up to date — skipping copy."; \
		else \
			BK="$(CLIENT_REG_CONF).$$(date -u +%Y%m%dT%H%M%SZ).bak"; \
			echo "Config differs — backing up to $$BK and updating."; \
			$(SUDO) cp "$(CLIENT_REG_CONF)" "$$BK"; \
			$(SUDO) install -m 0644 -D "$(CLIENT_REG_SRC)" "$(CLIENT_REG_CONF)"; \
		fi \
	else \
		echo "Installing new config from $(CLIENT_REG_SRC)."; \
		$(SUDO) install -m 0644 -D "$(CLIENT_REG_SRC)" "$(CLIENT_REG_CONF)"; \
	fi
	@echo "Client registry config ready."
