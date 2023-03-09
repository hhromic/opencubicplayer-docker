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

## Building

To build the standard `ocp` image:
```
docker buildx build --tag ocp --target ocp .
```

To build the `ocp-midi` image with MIDI playback support:
```
docker buildx build --tag ocp-midi --target ocp-midi .
```

## Usage

To run Open Cubic Player in WSL2 with WSLg (graphical mode):
```
docker run --rm -it \
  -v /path/to/media:/media:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /mnt/wslg:/mnt/wslg \
  -e DISPLAY -e PULSE_SERVER \
  ocp ocp-sdl2 -spdevpSDL2
```

To run Open Cubic Player in WSL2 with WSLg (ncurses mode):
```
docker run --rm -it \
  -v /path/to/media:/media:ro \
  -v /mnt/wslg:/mnt/wslg \
  -e PULSE_SERVER \
  ocp ocp-curses -spdevpSDL2
```

Replace `ocp` with `ocp-midi` to run the image with MIDI playback support.

To use a custom Soundfont file for MIDI playback:
```
docker run --rm -it \
  -v /path/to/media:/media:ro \
  -v /path/to/soundfont.sf2:/usr/share/soundfonts/default.sf2:ro \
  -v /mnt/wslg:/mnt/wslg \
  -e PULSE_SERVER \
  ocp-midi ocp-curses -spdevpSDL2
```
