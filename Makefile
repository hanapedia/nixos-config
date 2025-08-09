SUDO := sudo
FLAKE := $(shell hostname)

rebuild:
	$(SUDO) nixos-rebuild switch --flake .#$(FLAKE)
