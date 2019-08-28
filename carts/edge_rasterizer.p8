pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function edge_rasterizer()
	local ymin,ymax=32000,-32000	
	local edges={}

	-- @impbox
	-- https://www.lexaloffle.com/bbs/?tid=2477
	local function sort(a)
		for i=1,#a do
		-- reuse i!!!
			local j=i
			while j>1 and a[j-1].x>a[j].x do
			a[j],a[j-1]=a[j-1],a[j]
			j-=1
			end
		end
	end

 return {
	-- add edge
	add=function(self,verts,c,z)
		local v0=verts[#verts]
		-- polygon
		local p={z=z,c=c}
		for i=1,#verts do
			local v1=verts[i]
			-- edge building
			local x0,y0,x1,y1=v0[1],flr(v0[2]),v1[1],flr(v1[2])
 			-- flat edge case?
 			if y0!=y1 then
			 	-- top/down ordering
 				if(y0>y1)x0,y0,x1,y1=x1,y1,x0,y0

		 		edges[y0]=edges[y0] or {}
 				add(edges[y0],{ymax=y1,poly=p,x=x0,dx=(x1-x0)/(y1-y0)})
 	 			ymin,ymax=min(ymin,y0),max(ymax,flr(y1))
			end
			v0=v1
		end
	end,
 	draw=function(self)			 
 		color(7)
		-- active edge table
		local aet={}
		for y=ymin,ymax do
			local span=edges[y]
			-- new edges at y?
			if span then
				for i=1,#span do
					aet[#aet+1]=span[i]
				end
				print(#aet,2,y,1)
			end
			-- order spans
			sort(aet)

			-- draw spans
			for i=1,#aet-1 do
				local e0,e1=aet[i],aet[i+1]
				rectfill(e0.x,y,e1.x,y,i)
				--pset(e0.x,y)
			end

			-- prepare next
			for _,e in pairs(aet) do
				-- edge done?
				if y>=e.ymax then
					del(aet,e)
				else
					-- step
					e.x+=e.dx
				end
			end
		end

		-- reset
		ymin,ymax=32000,-32000
		edges={}
 	end
	}
end


-->8
-- main engine
local raz=edge_rasterizer()

local angle=0
function _update()
	angle+=0.001
	local cc,ss=cos(angle),-sin(angle)
	local function rotate(x,y)
		x-=64
		y-=64
		return 64+x*ss-y*cc,64+x*cc+y*ss
	end
	local x0,y0=rotate(24,24)
	local x1,y1=rotate(96,48)
	local x2,y2=rotate(48,112)
	raz:add({{x0,y0},{x1,y1},{x2,y2}},8,0)
end

function _draw()
 cls()
 raz:draw()
 print(stat(1),2,112,1)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
