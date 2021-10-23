FROM archlinux:base-devel

RUN \
	pacman -Sy --noconfirm wget && \
	wget https://github.com/seeseemelk/xtensa-esp32-elf-gdc-pkgbuild/releases/download/v12.0.0-1/xtensa-esp32-elf-gcc-12.0.0-1-x86_64.pkg.tar.zst && \
	wget https://github.com/seeseemelk/xtensa-esp32-elf-binutils-pkgbuild/releases/download/v2.35-1/xtensa-esp32-elf-binutils-2.35-1-x86_64.pkg.tar.zst && \
	wget https://github.com/seeseemelk/xtensa-esp32-elf-newlib-pkgbuild/releases/download/v3.0.0-2/xtensa-esp32-elf-newlib-3.0.0-2-x86_64.pkg.tar.zst && \
	pacman -U --noconfirm *.pkg.* && \
	rm *.pkg.* && \
	pacman -Scc --noconfirm
