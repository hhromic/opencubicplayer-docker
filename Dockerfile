FROM opensuse/tumbleweed:latest AS ocp

# Configure image labels
LABEL org.opencontainers.image.source=https://github.com/hhromic/opencubicplayer-docker \
      org.opencontainers.image.description="Docker images for running the Unix fork of Open Cubic Player." \
      org.opencontainers.image.licenses="Apache-2.0 GPL-2.0"

# Configure default command for the image
CMD ["ocp-curses"]

# Configure default environment for the image
ENV LANG="C.UTF-8" \
    XDG_CONFIG_HOME=/xdg/config \
    XDG_CACHE_HOME=/xdg/cache \
    XDG_DATA_HOME=/xdg/data \
    XDG_STATE_HOME=/xdg/state

# Install required packages
RUN zypper --non-interactive install \
        glibc-gconv-modules-extra \
        libpulse0 \
        ocp \
    && zypper clean --all

# Create an audio system group for ALSA compatibility
RUN groupadd --system audio

# Start a new stage for MIDI playback support
FROM ocp AS ocp-midi

# Download and install a soundfont for MIDI playback
ARG SOUNDFONT_URL=http://sourceforge.net/projects/androidframe/files/soundfonts/SGM-V2.01.sf2
RUN mkdir -p /etc/timidity /usr/share/soundfonts \
    && curl -L "$SOUNDFONT_URL" -o /usr/share/soundfonts/default.sf2 \
    && echo "soundfont /usr/share/soundfonts/default.sf2" > /etc/timidity/timidity.cfg
