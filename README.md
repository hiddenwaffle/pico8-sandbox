# pico-8-sandbox

Stash for random PICO-8 stuff

## Notes

Using VS Code, add these settings:
```
"pico8vscodeeditor.pico8fullpath": "/Applications/PICO-8.app/Contents/MacOS/pico8",
"pico8vscodeeditor.pico8additionalParameters": "-width 1000 -height 1000 -volume 32 -home '<source-root>/shared'"
```
Underneath the home path, PICO-8 will create its directory structure (i.e., backup, bbs, cdata, etc...) alongside the carts directory. On exit, PICO-8 will update the home/config.txt paths to reflect the command line option.

## Goals

- Sandbox Physics
- 2D and 3D Effects
- AI

## TODO

- 2048 challenge
