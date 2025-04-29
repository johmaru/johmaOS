.PHONY: all build install clean

all: install

build:
	zig build

install: build
	@echo Copying EFI files to WSL share ...
	@robocopy zig-out\bin\EFI "\\wsl.localhost\Ubuntu\home\johmaru\mnt\EFI" /MIR /NFL /NDL /NP /NJH /NJS \
		&& (exit 0) || (set ec=%ERRORLEVEL% & echo robocopy failed with %ec% & exit /b %ec%)

clean:
	@rmdir /S /Q zig-out 2>NUL || exit 0