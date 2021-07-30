FROM archlinux

RUN \
	echo [mcud] >> /etc/pacman.conf && \
	echo SigLevel = Never >> /etc/pacman.conf && \
	echo Server = https://seeseemelk.github.io/mcud-tools >> /etc/pacman.conf && \
	pacman -Syu --noconfirm && \
	pacman -S --noconfirm make && \
	pacman -Scc --noconfirm
