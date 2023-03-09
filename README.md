# opencubicplayer-docker

## Build

To build the image:
```
docker buildx build --tag ocp --target ocp .
```

To build the image with MIDI playback support:
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
