SUDO := sudo
FLAKE := $(shell hostname)

.PHONY: rebuild
rebuild:
	$(SUDO) nixos-rebuild switch --flake .#$(FLAKE)

# ---------- Local registry prep ---------------------------------------------
REG_DIR        ?= /srv/registry
REG_CERTS      := $(REG_DIR)/certs
REG_CFG_SRC    ?= pkg/registry/config.yaml   # your repo copy (rename from .yaml if needed)
REG_CFG_DEST   := $(REG_DIR)/config.yaml

REG_HOST       ?= nixos-server-r596             # DNS name used by clients
REG_IP         ?= 192.168.1.100                          # optional: e.g. 192.168.1.10
REG_DAYS_CA    ?= 3650
REG_DAYS_CERT  ?= 1825

.PHONY: registry-prepare
registry-prepare:
	@set -euo pipefail; \
	mkdir -p "$(REG_CERTS)"; \
	# Copy registry config if not present
	if [ -f "$(REG_CFG_SRC)" ] && [ ! -f "$(REG_CFG_DEST)" ]; then \
	  install -m0644 -D "$(REG_CFG_SRC)" "$(REG_CFG_DEST)"; \
	  echo "Installed $(REG_CFG_DEST)"; \
	else \
	  echo "Keeping existing $(REG_CFG_DEST) (or source missing)"; \
	fi; \
	# Create CA (once)
	if [ ! -f "$(REG_CERTS)/ca.crt" ]; then \
	  echo "Generating CA ..."; \
	  openssl req -x509 -nodes -newkey rsa:4096 -days $(REG_DAYS_CA) \
	    -keyout "$(REG_CERTS)/ca.key" \
	    -out    "$(REG_CERTS)/ca.crt" \
	    -subj "/CN=local-registry-CA"; \
	fi; \
	# Build SANs list
	SAN="DNS:$(REG_HOST)"; \
	if [ -n "$(REG_IP)" ]; then SAN="$$SAN,IP:$(REG_IP)"; fi; \
	# Create server cert if missing (with SANs)
	if [ ! -f "$(REG_CERTS)/registry.crt" ] || [ ! -f "$(REG_CERTS)/registry.key" ]; then \
	  echo "Generating server key/cert for $(REG_HOST) $(REG_IP) ..."; \
	  openssl req -nodes -newkey rsa:4096 \
	    -keyout "$(REG_CERTS)/registry.key" \
	    -out    "$(REG_CERTS)/registry.csr" \
	    -subj "/CN=$(REG_HOST)" \
	    -addext "subjectAltName=$$SAN"; \
	  tmp=$$(mktemp); \
	  printf "subjectAltName=$$SAN\nbasicConstraints=CA:FALSE\nkeyUsage=digitalSignature,keyEncipherment\nextendedKeyUsage=serverAuth\n" > $$tmp; \
	  openssl x509 -req -in "$(REG_CERTS)/registry.csr" \
	    -CA "$(REG_CERTS)/ca.crt" -CAkey "$(REG_CERTS)/ca.key" -CAcreateserial \
	    -out "$(REG_CERTS)/registry.crt" -days $(REG_DAYS_CERT) \
	    -extfile $$tmp; \
	  rm -f "$$tmp" "$(REG_CERTS)/registry.csr"; \
	fi; \
	chmod 600 "$(REG_CERTS)/ca.key" "$(REG_CERTS)/registry.key" || true; \
	chmod 644 "$(REG_CERTS)/ca.crt" "$(REG_CERTS)/registry.crt" || true; \
	echo "Registry certs ready in $(REG_CERTS)"
