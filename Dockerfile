FROM nfnty/arch-mini:latest
MAINTAINER arcnmx

RUN ["pacman", "-Sy", "--noconfirm"]
RUN pacman -Su --noconfirm lz4 base-devel abs \
	&& find /var/cache/pacman/pkg -mindepth 1 -delete

RUN pacman -S --noconfirm mingw-w64-binutils mingw-w64-crt mingw-w64-headers mingw-w64-winpthreads \
	&& find /var/cache/pacman/pkg -mindepth 1 -delete
RUN echo MAKEFLAGS=-j4 >> /etc/makepkg.conf

ADD mingw-w64-gcc-dwarf.patch /root/mingw-w64-gcc.patch
RUN abs community/mingw-w64-gcc \
	&& cd /var/abs/community/mingw-w64-gcc \
	&& patch PKGBUILD /root/mingw-w64-gcc.patch \
	&& env EUID=1 makepkg -cid --noconfirm --noprogressbar \
	&& rm -rf /var/abs/community/mingw-w64-gcc

RUN mkdir /root/rust && cd /root/rust \
	&& curl -fsSL https://aur.archlinux.org/cgit/aur.git/snapshot/rust-nightly-bin.tar.gz | tar xz --strip-components=1 \
	&& env EUID=1 makepkg -cis --noconfirm --noprogressbar \
	&& mv PKGBUILD /root/rust-nightly-bin \
	&& rm -rf /root/rust

ADD rust-std-nightly-windows /root/rust-std-nightly-windows/PKGBUILD.template
RUN cd /root/rust-std-nightly-windows \
	&& (grep ^_date= /root/rust-nightly-bin; grep ^pkgver= /root/rust-nightly-bin; cat PKGBUILD.template) > PKGBUILD \
	&& env EUID=1 makepkg -cis --noconfirm --noprogressbar && rm -rf /root/rust-std-nightly-windows
