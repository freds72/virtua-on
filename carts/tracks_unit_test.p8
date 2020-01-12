pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
	reload(0,0,0x4300,"acropolis_0.p8")
	print(tostr(peek4(0x0),true))
	reload(0,0,0x4300,"tracks_4.p8")
	print(tostr(peek4(7272/2),true))
end
		
-->8


