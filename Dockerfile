# syntax=docker/dockerfile:1
FROM debian:bookworm-slim AS base

# Start a new stage for building the application
FROM base AS builder

# Install required packages
RUN --mount=type=cache,id=builder-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=builder-apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get update --assume-yes \
    && apt-get install --no-install-recommends --assume-yes \
        bsdextrautils \
        build-essential \
        fonts-unifont \
        gzip \
        libancient-dev \
        libbz2-dev \
        libcjson-dev \
        libdiscid-dev \
        libflac-dev \
        libfreetype-dev \
        libgme-dev \
        libjpeg-dev \
        libmad0-dev \
        libncurses-dev \
        libogg-dev \
        libpng-dev \
        libsdl2-dev \
        libvorbis-dev \
        libxpm-dev \
        pkgconf \
        tar \
        unzip \
        xa65 \
        zlib1g-dev

# Set a well-known building directory
WORKDIR /build

# Download and build Open Cubic Player
ARG OCP_URL=https://stian.cubic.org/ocp/ocp-3.1.3.tar.gz
ADD "${OCP_URL}" ocp.tar.gz
RUN tar zxf ocp.tar.gz --one-top-level=ocp/ --strip-components=1 \
    && cd ocp \
    && ./configure --prefix=/usr \
        --without-desktop_file_install \
        --without-oss \
        --without-update-desktop-database \
        --without-update-mime-database \
    && make -j"$(nproc)" \
    && make install DESTDIR=/build/install \
    && rm -rf /build/install/usr/share/{doc,man}

# Download and prepare image and animation asset files
ARG OCP_IMG_URL=https://stian.cubic.org/mirror/ftp.cubic.org/pub/player/gfx/opencp25image1.zip \
    OCP_ANI_URL=https://stian.cubic.org/mirror/ftp.cubic.org/pub/player/gfx/opencp25ani1.zip
ADD "${OCP_IMG_URL}" ocp-img.zip
ADD "${OCP_ANI_URL}" ocp-ani.zip
RUN unzip ocp-img.zip -d ocp-img \
    && unzip ocp-ani.zip -d ocp-ani \
    && cp -pv ocp-img/CPPIC*.TGA ocp-ani/CPANI*.DAT install/usr/share/ocp/data/

# Start a new stage for the application image
FROM base AS ocp

# Configure image labels
LABEL org.opencontainers.image.description="Unix port of Open Cubic Player, which is a text-based player with some few graphical views." \
      org.opencontainers.image.licenses="Apache-2.0 GPL-2.0" \
      org.opencontainers.image.source="https://github.com/hhromic/opencubicplayer-docker" \
      org.opencontainers.image.title="Open Cubic Player (Unix port)" \
      org.opencontainers.image.url="https://github.com/hhromic/opencubicplayer-docker" \
      org.opencontainers.image.vendor="https://github.com/hhromic" \
      org.opencontainers.image.version="3.1.3"

# Configure default command for the image
CMD ["ocp-curses"]

# Configure default environment for the image
ENV LANG="C.UTF-8" \
    XDG_CONFIG_HOME=/xdg/config \
    XDG_CACHE_HOME=/xdg/cache \
    XDG_DATA_HOME=/xdg/data \
    XDG_STATE_HOME=/xdg/state

# Install required packages
RUN --mount=type=cache,id=ocp-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=ocp-apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get update --assume-yes \
    && apt-get install --no-install-recommends --assume-yes \
        ca-certificates \
        curl \
        fonts-unifont \
        libancient2 \
        libbz2-1.0 \
        libcjson1 \
        libdiscid0 \
        libflac12 \
        libfreetype6 \
        libgme0 \
        libjpeg62-turbo \
        libmad0 \
        libncurses6 \
        libncursesw6 \
        libogg0 \
        libpng16-16 \
        libsdl2-2.0-0 \
        libvorbis0a \
        libvorbisfile3 \
        libxpm4 \
        libxxf86vm1

# Copy installation files from builder stage
COPY --from=builder /build/install/ /

# Start a new stage for MIDI playback support
FROM ocp AS ocp-midi

# Download and install a soundfont for MIDI playback
ARG SOUNDFONT_URL=https://github.com/mrbumpy409/GeneralUser-GS/raw/refs/heads/main/GeneralUser-GS.sf2
ADD --chmod=644 "${SOUNDFONT_URL}" /usr/share/soundfonts/default.sf2
RUN mkdir -p /etc/timidity \
    && echo "soundfont /usr/share/soundfonts/default.sf2" > /etc/timidity/timidity.cfg
