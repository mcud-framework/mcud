FROM archlinux:base-devel

RUN pacman -Sy --noconfirm wget && \
	wget \
	https://github.com/seeseemelk/gcc-pkgbuild/releases/download/v12.0.0-1/gcc-12.0.0-1-x86_64.pkg.tar.zst \
	https://github.com/seeseemelk/gcc-pkgbuild/releases/download/v12.0.0-1/gcc-d-12.0.0-1-x86_64.pkg.tar.zst \
	https://github.com/seeseemelk/gcc-pkgbuild/releases/download/v12.0.0-1/gcc-libs-12.0.0-1-x86_64.pkg.tar.zst && \
	pacman -U --noconfirm *.pkg.* && \
	rm *.pkg.* && \
	pacman -Scc --noconfirm
