FROM nfnty/arch-mini:latest
MAINTAINER arcnmx

RUN ["pacman", "-Sy", "--noconfirm"]
RUN pacman -Su --noconfirm lz4 base-devel abs && find /var/cache/pacman/pkg -mindepth 1 -delete
RUN pacman -S --noconfirm mingw-w64-binutils mingw-w64-crt mingw-w64-headers mingw-w64-winpthreads && find /var/cache/pacman/pkg -mindepth 1 -delete
ADD mingw-w64-gcc-dwarf.patch /root/mingw-w64-gcc.patch
RUN abs community/mingw-w64-gcc && cd /var/abs/community/mingw-w64-gcc && patch PKGBUILD /root/mingw-w64-gcc.patch && env EUID=1 makepkg -cid --noconfirm --noprogressbar && rm -rf /var/abs/community/mingw-w64-gcc
