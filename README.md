# pico-8-sandbox

Stash for random PICO-8 stuff

## Notes

Using VS Code, add these settings:
```
"pico8vscodeeditor.pico8fullpath": "/Applications/PICO-8.app/Contents/MacOS/pico8",
"pico8vscodeeditor.pico8additionalParameters": "-windowed 1 -width 1000 -height 1000 -volume 32 -home '<path-to-cart>'"

```
Underneath the home path, PICO-8 will create its directory structure (i.e., backup, bbs, cdata, etc...) alongside the carts directory. On exit, PICO-8 will update the home/config.txt paths to reflect the command line option.

__If changing these parameters__, except for -home, you may have to delete the config.txt first to get it to stick.

## Goals

- Sandbox Physics
- 2D and 3D Effects
- AI

## TODO

- 2048 challenge
- Flappy Bird coding challenge #38 I think, then #100 to program the AI for it
