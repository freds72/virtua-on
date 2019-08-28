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
		local p={z=z,c=c,winding=0}
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
 		local aet={}
		for y=ymin,ymax do
			-- active polygons on scanline
			local apl={}
			local nearest,xmin
			-- get active edges
			local el=edges[y]
			if el then
				for _,e in pairs(el) do
					aet[#aet+1]=e
				end
			end
			-- sort by x
			sort(aet)
			--[[
			if y%10==0 then
				for i=1,#aet do
					local e=aet[i]
					print(i,e.x,y-2,1)
				end
			end
			]]
			-- iterate over active edges
			for i=1,#aet do
				local e=aet[i]
				if y>e.ymax then
					-- end of active edge
					-- del(aet,e)
					e.poly.winding=0
					aet[i]=nil
				else
					-- 
					local p=e.poly
					p.winding+=1
					-- entering?
					if p.winding==1 then
						-- register into apl
						add(apl,p)						
						-- pset(e.x,y,11)
						-- nearest poly?
						if nearest then							
							-- leaving nearest poly
							if nearest.z<p.z then		
								-- draw previous nearest
								rectfill(xmin,y,e.x,y,nearest.c)
								-- record nearest x
								xmin,nearest=e.x,p
							end
						else
							nearest,xmin=p,e.x							
						end
					else
						-- only convex polygons
						assert(p.winding==2)
						-- unregister poly
						del(apl,p)
						-- pset(e.x,y,8)
						p.winding=0
						-- leaving?
						if nearest==p then
							-- pset(e.x,y,7)
							-- draw nearest
							rectfill(xmin,y,e.x,y,p.c)
							-- record nearest x
							xmin,nearest=e.x
							-- search for new nearest
							local zmax=-32000
							for _,poly in pairs(apl) do
								if poly.z>zmax then
									nearest,zmax=poly,poly.z
								end
							end
						end
					end
					-- prep for next scanline
					e.x+=e.dx
				end
			end
			-- yuck
			local tmp={}
			for _,v in pairs(aet) do
				if(v)add(tmp,v)
			end
			aet=tmp
			--pset(127,y,y)
			--flip()		
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
	raz:add({{x0,y0},{x1,y1},{x2,y2}},7,1)

	cc,ss=cos(angle+0.5),-sin(angle+0.5)
	local x0,y0=rotate(24,24)
	local x1,y1=rotate(96,48)
	local x2,y2=rotate(48,112)
	raz:add({{x0,y0},{x1,y1},{x2,y2}},8,0)


	cc,ss=cos(angle+0.75),-sin(angle+0.75)
	local x0,y0=rotate(24,24)
	local x1,y1=rotate(96,48)
	local x2,y2=rotate(48,112)
	raz:add({{x0,y0},{x1,y1},{x2,y2}},9,3)
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
