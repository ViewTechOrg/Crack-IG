# version 0.0.1
# created by : Team ViewTech
# date       : 2025-06-05 | 08.47 WIB
# developer  : Xenzi & Polygon (pejuang kentang)
########################################

# Daftar package
PACKAGEBASH := curl python bc ncurses-utils file ossp-uuid uuid-utils less zsh boxes figlet ruby clang tree jq ripgrep coreutils xz-utils fzf gum silversearcher-ag file brotli mpv pv neofetch binutils html2text
PACKAGEPY := xonsh requests rich rich-cli
TERMUX_PATH := /data/data/com.termux/files/usr/bin/bash
PYTHON_VERSION := $(shell python -V | sed 's/[[:space:]]//g' | cut -c 1-10 | tr '[:upper:]' '[:lower:]')

# =======================[ CEK ]=======================
detectCLI:
	@echo "[?] Mengecek lingkungan termux..."
	@if [ -f "$(TERMUX_PATH)" ]; then \
		echo "[✓] Termux terdeteksi!"; \
	else \
		echo "[!] Path Termux tidak ditemukan!"; \
		echo "[!] Mohon gunakan Termux untuk menjalankan skrip ini."; \
		exit 1; \
	fi

# =======================[ INSTALL PACKAGE BASH ]======================
install-system: detectCLI
	@echo "[?] Menginstall package dari bash..."
	@for pkg in $(PACKAGEBASH); do \
		echo "[>] Menginstall $$pkg..."; \
		apt-get install $$pkg -y >/dev/null 2>&1; \
		if test -z "$$(command -v $$pkg >/dev/null 2>&1)"; then \
			echo "[✓] Berhasil menginstall $$pkg"; \
		else \
			echo "[✗] Gagal menginstall $$pkg"; \
			echo "[!] Jalankan manual: pkg install $$pkg"; \
		fi; \
	done

# =======================[ INSTALL PACKAGE PYTHON ]=====================
install-py: detectCLI
	@if command -v python >/dev/null 2>&1; then \
		echo "[✓] Python ditemukan"; \
		echo "[>] Menginstall Python package: $(PACKAGEPY)..."; \
		for install in $(PACKAGEPY); do \
			pip install $$install; \
		done \
	else \
		echo "[✗] Python tidak ditemukan! Silakan install terlebih dahulu."; \
	fi
	@echo "[!] Jalankan perintah: xonsh setup.xsh install";
	
update: detectCLI
	@echo "[>] Melakukan update ..";sleep 1
	@git pull

install: install-system install-py

fix:
	pip uninstall urllib3 -y
	pip install urllib3==1.26.16
	pip install six
	rm -rf $$PREFIX/lib/$(PYTHON_VERSION)/site-packages/requests
	pip uninstall requests -y
	pip uninstall psutil -y
	pip install requests
	
all: install

.PHONY: detectCLI install-system install-py
