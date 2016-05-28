FROM nfnty/arch-mini:latest
MAINTAINER arcnmx

RUN ["pacman", "-Syu", "--noconfirm"]
RUN ["pacman", "-S", "--noconfirm", "base-devel", "mingw-w64-toolchain"]
RUN ["find", "/var/cache/pacman/pkg", "-mindepth", "1", "-delete"]
