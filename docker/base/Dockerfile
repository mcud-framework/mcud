FROM archlinux

RUN \
	echo [mcud] >> /etc/pacman.conf && \
	echo SigLevel = Never >> /etc/pacman.conf && \
	echo Server = http://172.17.0.1:8080 >> /etc/pacman.conf && \
	pacman -Sy --noconfirm make && \
	pacman -Scc --noconfirm
