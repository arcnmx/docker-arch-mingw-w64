FROM nfnty/arch-mini:latest

RUN ["pacman", "-Syu", "--noconfirm"]
RUN ["pacman", "-S", "--noconfirm", "base-devel", "mingw-w64-toolchain"]
RUN ["pacman", "-Scc", "--noconfirm"]
