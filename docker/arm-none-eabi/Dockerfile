FROM archlinux:base-devel

RUN \
	pacman -Sy --noconfirm arm-none-eabi-binutils arm-none-eabi-newlib && \
	curl -Lo gdc.pkg.tar.zst https://github.com/seeseemelk/arm-none-eabi-gdc-pkgbuild/releases/download/v11.2.0-3/arm-none-eabi-gdc-11.2.0-3-x86_64.pkg.tar.zst && \
	pacman -U --noconfirm gdc.pkg.tar.zst && \
	rm gdc.pkg.tar.zst && \
	pacman -Scc --noconfirm
