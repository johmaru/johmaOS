SHELL       := cmd
.SHELLFLAGS := /C

.PHONY: all build install clean

# Linux 側コピー先
WSL_DST        := /home/johmaru/mnt/EFI
# Windows 側ビルド成果物を Linux パスに変換
WIN_SRC_ABS    := $(CURDIR)/zig-out/bin/EFI
WSL_SRC_ABS    := $(shell wsl wslpath -u "$(WIN_SRC_ABS)")

all: install

build:
	zig build

install: build
	@echo WSLにファイルを移動中 ...
	@wsl sh -c "rm -rf $(WSL_DST) && mkdir -p $(WSL_DST) && cp -aT $(WSL_SRC_ABS) $(WSL_DST)"

clean:
	@rmdir /S /Q zig-out 2>NUL || exit 0