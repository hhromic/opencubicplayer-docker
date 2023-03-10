# opencubicplayer-docker

This repository contains files for building Docker images for the
[Unix fork of Open Cubic Player](https://github.com/mywave82/opencubicplayer).

> UNIX port of Open Cubic Player, which is a text-based player with some few
> graphical views. Visual output can be done through nCurses, Linux console
> (VCSA + FrameBuffer), X11 or SDL/SDL2. It can be compiled on various different
> unix based operating systems.

Two image targets are available in the provided [Dockerfile](Dockerfile):

* `ocp`: Produces an image containing Open Cubic Player and `libpulse0`.
* `ocp-midi`: Produces an `ocp` image with MIDI playback support.

The `libpulse0` library provides support for
[PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) servers
when using the SDL2 playback driver in Open Cubic Player. This provides out of
the box support for audio in WSL2 and [WSLg](https://github.com/microsoft/wslg).

All images are based on the official
[openSUSE Tumbleweed image](https://hub.docker.com/r/opensuse/tumbleweed).
This base image was chosen for the following reasons: (1) the openSUSE
Tumbleweed package repositories contain an up-to-date version of Open Cubic
Player and (2) the base image is very small.

For MIDI playback support, the `ocp-midi` target pre-configures Timidity and
bundles [Shan's GM Soundfont](https://archive.org/details/SGM-V2.01). This
Soundfont provides high quality MIDI audio rendering. Other Soundfont files can
be used as well.

Refer to the [usage](#usage) section for more details.

## Usage

Ready to use images are available in the
[GitHub Container Registry](https://github.com/hhromic?tab=packages&repo_name=opencubicplayer-docker).

To run Open Cubic Player in WSL2 with WSLg (graphical mode):
```
docker run --rm -it \
  -v /path/to/media:/media:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /mnt/wslg:/mnt/wslg \
  -e DISPLAY -e PULSE_SERVER \
  ghcr.io/hhromic/opencubicplayer:latest \
  ocp-sdl2 -spdevpSDL2
```

To run Open Cubic Player in WSL2 with WSLg (ncurses mode):
```
docker run --rm -it \
  -v /path/to/media:/media:ro \
  -v /mnt/wslg:/mnt/wslg \
  -e PULSE_SERVER \
  ghcr.io/hhromic/opencubicplayer:latest \
  ocp-curses -spdevpSDL2
```

Use `opencubicplayer-midi:latest` to run the image with MIDI playback support.

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

Similar invocations should also work under Linux and macOS. Ensure to mount the
correct audio devices into the container for Open Cubic Player to use.

## Building

To build the `opencubicplayer:latest` image locally:
```
docker buildx build --tag opencubicplayer:latest --target ocp .
```

To build the `opencubicplayer-midi:latest` image locally:
```
docker buildx build --tag opencubicplayer-midi:latest --target ocp-midi .
```

## Licenses

This project is licensed under the [Apache License Version 2.0](LICENSE).

Open Cubic Player (Unix fork) is licensed under the
[GNU General Public License v2.0](https://github.com/mywave82/opencubicplayer/blob/master/COPYING).

The bundled SGM Soundfont is under
[Copyright (c) 2002-2004 David Shan](https://aur.archlinux.org/cgit/aur.git/tree/license.txt?h=soundfont-sgm).
