pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
end

function _update60()
end

function _draw()
  cls(1)
  fillp(32768 + 8192 + 1024 + 256 + 128 + 32 + 4 + 1)
  rectfill(32, 32, 96, 96, 0x3b)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000aaaaaaa0000000001111111000000000eeeeeee0000000008888888000000000000000000000000000000000000000000000000000000000000
000000000000aaaaaaaaa00000001111111110000000eeeeeeeee000000088888888800000000044444400000000000000000000000000000000000000000000
000000000000aaafffffa00000001114444410000000eee77777e0000000888fffff80000000044fffff40000000000000000000000000000000000000000000
00000000000aaaffcfcfa0000001114404041000000eee778787e000000888ffbfbf8000000004ff5f5f40000000000000000000000000000000000000000000
00000000000aaaffcfcfa0000001114404041000000eee778787e000000888ffbfbf8000000004ff5f5f40000000000000000000000000000000000000000000
00000000000aaaafffffa0000001111444441000000eeee77777e0000008888fffff80000000044fffff00000000000000000000000000000000000000000000
000000000000aaaaffaa000000001111441100000000eeee77ee000000008888ff88000000000004ff4000000000000000000000000000000000000000000000
000000000000aaa777fa00000000111bbb4100000000eeeddd7e00000000888111f8000000000066666000000000000000000000000000000000000000000000
000000000000aaf777f000000000114bbb4000000000ee7ddd700000000088f111f00000000000f666f000000000000000000000000000000000000000000000
00000000000000f777f000000000004bbb4000000000007ddd700000000000f111f00000000000f666f000000000000000000000000000000000000000000000
0000000000000008880000000000000ccc00000000000002220000000000000ddd0000000000000ccc0000000000000000000000000000000000000000000000
0000000000000008880000000000000ccc00000000000002220000000000000ddd0000000000000ccc0000000000000000000000000000000000000000000000
0000000000000008880000000000000ccc00000000000002220000000000000ddd0000000000000ccc0000000000000000000000000000000000000000000000
0000000000000008880000000000000ccc00000000000002220000000000000ddd0000000000000ccc0000000000000000000000000000000000000000000000
0000000000000007877000000000000bcbb000000000000f2ff0000000000001d110000000000006c66000000000000000000000000000000000000000000000
