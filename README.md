# opencubicplayer-docker

This repository contains files for building Docker images for the
[Unix fork of Open Cubic Player](https://github.com/mywave82/opencubicplayer).

> UNIX port of Open Cubic Player, which is a text-based player with some few
> graphical views. Visual output can be done through nCurses, Linux console
> (VCSA + FrameBuffer), X11 or SDL/SDL2. It can be compiled on various different
> unix based operating systems.

Two image targets are available in the provided [Dockerfile](Dockerfile):

* `ocp`: Produces an image containing Open Cubic Player.
* `ocp-midi`: Produces an `ocp` image with MIDI playback support.

All images are based on the official
[Debian Bookworm](https://hub.docker.com/_/debian) image.

For MIDI playback support, the `ocp-midi` target pre-configures Timidity and
bundles [Shan's GM Soundfont](https://archive.org/details/SGM-V2.01). This
Soundfont provides high quality MIDI audio rendering. Other Soundfont files can
be used as well.

Refer to the [usage](#usage) section for more details.

## Usage

Ready to use images are available in the
[GitHub Container Registry](https://github.com/hhromic?tab=packages&repo_name=opencubicplayer-docker).

> [!NOTE]
> Use the `opencubicplayer-midi:latest` image/tag for MIDI playback support.

### Linux

The images can be used in Linux with ALSA (without audio servers) or PulseAudio.

Two versions of Docker are available for Linux:
* [Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux-install/)
  (limited as it uses virtualization)
* [Docker Engine](https://docs.docker.com/engine/install/) (the recommended version)

When using graphical mode in Linux, access to X11 must be granted to `root` by running:
```
xhost +local:root
```

> [!WARNING]
> The above access grant is lost when the X11 server is restarted.

#### Using ALSA

To run Open Cubic Player in Linux using ALSA (ncurses mode):
```
docker run --rm -it \
    --device /dev/snd
    -v /path/to/media:/media:ro \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-curses
```

To run Open Cubic Player in Linux using ALSA (graphical mode):
```
docker run --rm -it \
    --device /dev/snd
    -v /path/to/media:/media:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-sdl2
```

#### Using PulseAudio

> [!NOTE]
> The examples below are for Debian/Ubuntu desktops.
> Please review the paths in other distributions.

To run Open Cubic Player in Linux using PulseAudio (ncurses mode):
```
docker run --rm -it \
    -v /path/to/media:/media:ro \
    -v /run/user/$(id -u):/run/user/$(id -u) \
    -v $HOME/.config/pulse:/root/.config/pulse:ro \
    -e PULSE_SERVER=/run/user/$(id -u)/pulse/native \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-curses -spdevpSDL2
```

To run Open Cubic Player in Linux using PulseAudio (graphical mode):
```
docker run --rm -it \
    -v /path/to/media:/media:ro \
    -v /run/user/$(id -u):/run/user/$(id -u) \
    -v $HOME/.config/pulse:/root/.config/pulse:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e PULSE_SERVER=/run/user/$(id -u)/pulse/native \
    -e DISPLAY \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-sdl2 -spdevpSDL2
```

### Windows Subsystem for Linux (WSL2)

The images can be used in [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
with [WSLg](https://github.com/microsoft/wslg) and
[Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
in Windows 10/11.

WSLg provides support for PulseAudio and graphical mode via X11.

To run Open Cubic Player in WSL2 with WSLg (ncurses mode):
```
docker run --rm -it \
    -v /path/to/media:/media:ro \
    -v /mnt/wslg:/mnt/wslg \
    -e PULSE_SERVER \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-curses -spdevpSDL2
```

To run Open Cubic Player in WSL2 with WSLg (graphical mode):
```
docker run --rm -it \
    -v /path/to/media:/media:ro \
    -v /mnt/wslg:/mnt/wslg \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e PULSE_SERVER \
    -e DISPLAY \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-sdl2 -spdevpSDL2
```

### Custom MIDI Soundfont

To use a custom Soundfont file for MIDI playback (ncurses mode):
```
docker run --rm -it \
    -v /path/to/media:/media:ro \
    -v /path/to/soundfont.sf2:/usr/share/soundfonts/default.sf2:ro \
    -v /mnt/wslg:/mnt/wslg \
    -e PULSE_SERVER \
    ghcr.io/hhromic/opencubicplayer-midi:latest \
    ocp-curses -spdevpSDL2
```

### Data Persistence

Open Cubic Player fully conforms to the
[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)
for storing user configuration and data.

To simplify data persistence, the images are pre-configured with the following XDG base directories:

* `XDG_CONFIG_HOME` set to `/xdg/config`.
* `XDG_CACHE_HOME` set to `/xdg/cache`.
* `XDG_DATA_HOME` set to `/xdg/data`.
* `XDG_STATE_HOME` set to `/xdg/state`.

This configuration allows to use [Docker volumes](https://docs.docker.com/engine/storage/volumes/)
easily for data persistence.

To mount a local `/path/to/ocp-data` path for data persistence of the container:
```
docker run --rm -it \
    -v /path/to/ocp-data:/xdg \
    -v /path/to/media:/media:ro \
    -v /mnt/wslg:/mnt/wslg \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e PULSE_SERVER \
    -e DISPLAY \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-sdl2 -spdevpSDL2
```

For easier management, it is recommended to use
[named volumes](https://docs.docker.com/engine/storage/volumes/#named-and-anonymous-volumes):
```
docker volume create ocp-data
docker run --rm -it \
    -v ocp-data:/xdg \
    -v /path/to/media:/media:ro \
    -v /mnt/wslg:/mnt/wslg \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e PULSE_SERVER \
    -e DISPLAY \
    ghcr.io/hhromic/opencubicplayer:latest \
    ocp-sdl2 -spdevpSDL2
docker volume rm ocp-data
```

## Building

To build the images locally, use [Docker Build Bake](https://docs.docker.com/build/bake/):
```
docker buildx bake
```

## Licenses

This project is licensed under the [Apache License Version 2.0](LICENSE).

Open Cubic Player (Unix fork) is licensed under the
[GNU General Public License v2.0](https://github.com/mywave82/opencubicplayer/blob/master/COPYING).

The bundled SGM Soundfont is under
[Copyright (c) 2002-2004 David Shan](https://aur.archlinux.org/cgit/aur.git/tree/license.txt?h=soundfont-sgm).
