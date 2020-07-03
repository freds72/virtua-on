pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- main engine
local raz
local mode=0

local razz

function _init()
 razz={
		--edge_rasterizer,
		--poly_rasterizer,
		--trifill_rasterizer,
		--hybrid_rasterizer,
		convex_rasterizer,
		poke_rasterizer
		--convex_zbuf_rasterizer
	}
 --raz=edge_rasterizer()
 --raz=poly_rasterizer()
 --raz=trifill_rasterizer()
 raz=razz[1]()
end

local angle=0
local colors={
1 ,1 ,14,1, 1,
1 ,15,7 ,13,1,
2 ,7 ,7 ,7, 12,
1 ,9 ,7 ,11,1,
1 ,1 ,10,1, 1}

function _update() 
	
	if btnp(4) then
	 mode=(mode+1)%#razz
	 raz=razz[mode+1]()
	end
	 
	angle+=0.001
	local cc,ss=cos(angle),-sin(angle)
	local scale=0.8
	local function rotate(x,y)
		x-=64
		y-=64
		return 64+scale*(x*ss-y*cc),64+scale*(x*cc+y*ss)
	end

	-- back
	for i=1,20 do
		cc,ss=cos(angle+i*0.12),-sin(angle+i*0.12)
		local x0,y0=rotate(24,24)
		local x1,y1=rotate(96,24)
		local x2,y2=rotate(96,112)
		local x3,y3=rotate(24,112)
		raz:add({{x0,y0},{x1,y1},{x2,y2},{x3,y3}},i%15+1,i)
	end
	
end

function _draw()
 cls(6)
 raz:draw()
 local cpu=flr(1000*stat(1))/10
 rectfill(0,0,127,6,8)
 print(raz.name..": "..cpu.."%",2,1,7)
end

-->8
-->8
-- #putaflipinit
function cflip() if(slowflip)flip()
end
ospr=spr
function spr(...)
ospr(...)
cflip()
end
osspr=sspr
function sspr(...)
osspr(...)
cflip()
end
omap=map
function map(...)
omap(...)
cflip()
end
orect=rect
function rect(...)
orect(...)
cflip()
end
orectfill=rectfill
function rectfill(...)
orectfill(...)
cflip()
end
ocircfill=circfill
function circfill(...)
ocircfill(...)
cflip()
end
ocirc=circ
function circ(...)
ocirc(...)
cflip()
end
oline=line
function line(...)
oline(...)
cflip()
end
opset=pset
psetctr=0
function pset(...)
opset(...)
psetctr+=1
if(slowflip and psetctr%4==0)flip()
end
odraw=_draw
function _draw()
if(slowflip)extcmd("rec")
odraw()
if(slowflip)for i=0,99 do flip() end extcmd("video")cls()stop("gif saved")
end
menuitem(1,"put a flip in it!",function() slowflip=not slowflip end)

-->8
-- edge rasterizer
-- 
function edge_rasterizer()
	local ymin,ymax=32000,-32000	
	local edges={}
	
 return {
 name="edge",
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
			local apl,nearest,xmin={}
			-- get new active edges
			local el=edges[y]
			if el then
				for _,e in pairs(el) do
					aet[#aet+1]=e
				end
			end

			-- @impbox
			-- https://www.lexaloffle.com/bbs/?tid=2477
			-- sort by x
			for i=1,#aet do
				while i>1 and aet[i-1].x>aet[i].x do
					aet[i],aet[i-1]=aet[i-1],aet[i]
					i-=1
				end
			end			

			-- iterate over active edges
			for e in all(aet) do
				--local e=aet[i]
				if y>e.ymax then
					-- end of active edge
					del(aet,e)					
				else
					-- 
					local p=e.poly
					if (y!=e.ymax) p.winding+=1
					-- entering?
					if p.winding==1 then
						-- register into apl
						apl[#apl+1]=p
						-- nearest poly?
						if nearest then							
							-- leaving nearest poly?
							if nearest.z<p.z then		
								-- draw previous nearest
								if(e.x>xmin)rectfill(xmin,y,e.x-1,y,nearest.c)
								-- record nearest x
								xmin,nearest=e.x,p
							end
						else
							nearest,xmin=p,e.x
						end
					elseif p.winding==2 then
						-- only convex polygons
						-- assert(p.winding==2)
						-- unregister poly
						del(apl,p)
						p.winding=0
						-- leaving?
						if nearest==p then
							-- pset(e.x,y,7)
							-- draw nearest
							if(e.x>xmin)rectfill(xmin,y,e.x-1,y,p.c)
							-- record nearest x
							xmin,nearest=e.x,p
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
		end
		-- reset
		ymin,ymax=32000,-32000
		edges={}
 	end
	}
end

-->8
-- trifill rasterizer
function trifill_rasterizer()
	local polys={}
	local function sort(data)
	 local n = #data 
	 if(n<2) return
	 
	 -- form a max heap
	 for i = flr(n / 2) + 1, 1, -1 do
	  -- m is the index of the max child
	  local parent, value, m = i, data[i], i + i
	  local key = value.key 
	  
	  while m <= n do
	   -- find the max child
	   if ((m < n) and (data[m + 1].key > data[m].key)) m += 1
	   local mval = data[m]
	   if (key > mval.key) break
	   data[parent] = mval
	   parent = m
	   m += m
	  end
	  data[parent] = value
	 end 
	
	 -- read out the values,
	 -- restoring the heap property
	 -- after each step
	 for i = n, 2, -1 do
	  -- swap root with last
	  local value = data[i]
	  data[i], data[1] = data[1], value
	
	  -- restore the heap
	  local parent, terminate, m = 1, i - 1, 2
	  local key = value.key 
	  
	  while m <= terminate do
	   local mval = data[m]
	   local mkey = mval.key
	   if (m < terminate) and (data[m + 1].key > mkey) then
	    m += 1
	    mval = data[m]
	    mkey = mval.key
	   end
	   if (key > mkey) break
	   data[parent] = mval
	   parent = m
	   m += m
	  end  
	  
	  data[parent] = value
	 end
 end
 return {
  name="trifill",
  add=function(self,verts,c,z)
  	add(polys,{v=verts,key=z,c=c})
  end,
  draw=function()
  	sort(polys)
  	for i=1,#polys do
  		local v=polys[i].v
  		local v0,v1=v[1],v[2]
  		for k=3,#v do
  			local v2=v[k]
	  		trifill(
 	 			v0[1],v0[2],
  	 		v1[1],v1[2],
						v2[1],v2[2],polys[i].c)
					v1=v2
				end
	 	end
  	polys={}
  end
 }
end


-- trifill & clipping
-- by @p01
function p01_trapeze_h(l,r,lt,rt,y0,y1)
  lt,rt=(lt-l)/(y1-y0),(rt-r)/(y1-y0)
  if(y0<0)l,r,y0=l-y0*lt,r-y0*rt,0
  for y0=y0,min(y1,127) do
   rectfill(l,y0,r,y0)
   l+=lt
   r+=rt
  end
end
function p01_trapeze_w(t,b,tt,bt,x0,x1)
 tt,bt=(tt-t)/(x1-x0),(bt-b)/(x1-x0)
 if(x0<0)t,b,x0=t-x0*tt,b-x0*bt,0
 for x0=x0,min(x1,127) do
  rectfill(x0,t,x0,b)
  t+=tt
  b+=bt
 end
end

function trifill(x0,y0,x1,y1,x2,y2,col)
 color(col)
 if(y1<y0)x0,x1,y0,y1=x1,x0,y1,y0
 if(y2<y0)x0,x2,y0,y2=x2,x0,y2,y0
 if(y2<y1)x1,x2,y1,y2=x2,x1,y2,y1
 if max(x2,max(x1,x0))-min(x2,min(x1,x0)) > y2-y0 then
  col=x0+(x2-x0)/(y2-y0)*(y1-y0)
  p01_trapeze_h(x0,x0,x1,col,y0,y1)
  p01_trapeze_h(x1,col,x2,x2,y1,y2)
 else
  if(x1<x0)x0,x1,y0,y1=x1,x0,y1,y0
  if(x2<x0)x0,x2,y0,y2=x2,x0,y2,y0
  if(x2<x1)x1,x2,y1,y2=x2,x1,y2,y1
  col=y0+(y2-y0)/(x2-x0)*(x1-x0)
  p01_trapeze_w(y0,y0,y1,col,x0,x1)
  p01_trapeze_w(y1,col,y2,y2,x1,x2)
 end
end

-->8
-- poly rasterizer
function poly_rasterizer()
	local poly={}
	return {
	name="poly",
	-- add edge
	add=function(self,verts,c,z)
		add(poly,{v=verts,c=c})
	end,
 draw=function(self)
  for k=1,#poly do
   local v=poly[k].v
   color(poly[k].c)
 	 for y=0,127 do
 	  local nodes={}
 	  local v0=v[#v]
 	  local y0=v0[2]
 	  for i=1,#v do
 	   local v1=v[i]
 	   local y1=v1[2]
 	   if (y0>y and y1<=y) or (y1>y and y0<=y) then
 	    nodes[#nodes+1]=v0[1]+(y-y0)*(v1[1]-v0[1])/(y1-y0)
 	   end
 	   v0,y0=v1,y1
 	  end
 	  
			--[[
 	  if #nodes>1 then
 	  	rectfill(nodes[1],y,nodes[2],y)
 	  end
 	  ]]
 	  for i=1,#nodes,2 do
 	  	rectfill(nodes[i],y,nodes[i+1],y)
 	  end
 	 end
  end
  poly={}
 end
 }
end

-->8
-- hybrid rasterizer
function hybrid_rasterizer()
	local poly={}

	return {
	name="hybrid",
	-- add edge
	add=function(self,verts,c,z)
		local v0=verts[#verts]
		local ymin,ymax=v0[2],v0[2]
		for i=1,#verts do
			local v1=verts[i]
			local y=v1[2]
			ymin=min(ymin,y)
			ymax=max(ymax,y)
			-- edge building
			-- target
		 v0[3]=y
		 -- dx
		 v0[4]=(v1[1]-v0[1])/(y-v0[2])
			--end
			v0=v1
		end
		add(poly,{v=verts,c=c,ymin=ymin,ymax=ymax})
	end,
 draw=function(self)
	 for k=1,#poly do
		local p=poly[k]
		local v=p.v
  	color(p.c)
   -- todo:
   -- mix with edge
   -- use xmin/x to draw rectfills
   for y=p.ymin,p.ymax do
	   local xmin
 	  for v0 in all(v) do
 	  	local y0,y1=v0[2],v0[3]
 	   if (y0>y and y1<=y) or (y1>y and y0<=y) then
 	    local x=v0[1]+(y-y0)*v0[4]
 	    if xmin then
 	     rectfill(xmin,y,x,y)
 	    else
 	    	xmin=x
 	    end
 	   end
 	  end
 	 end
  end
  poly={}
 end
 }
end

-->8
-- hybrid rasterizer
function convex_rasterizer()
	local poly={}
	
	local cache_cls={
		__index=function(t,k)
			local f=function(a)
				t[k]=function(b)
					rectfill(a,k,b,k)
				end
			end  
			--t[k]=f
			return f
		end
	}
	return {
	name="edge+sub-pix",
	-- add edge
	add=function(self,verts,c,z)
		add(poly,{v=verts,c=c})
	end,
 draw=function(self)
	for k=1,#poly do
		local p=poly[k]
		local v=p.v
  		color(p.c)

		local v0,nodes=v[#v],{} -- setmetatable({},cache_cls)
		local x0,y0=v0[1],v0[2]
		for i=1,#v do
			local v1=v[i]
			local x1,y1=v1[1],v1[2]
			local _x1,_y1=x1,y1
			if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
			local cy0,cy1,dx=y0\1+1,y1\1,(x1-x0)/(y1-y0)
			if(y0<0) x0-=y0*dx y0=0
   		x0+=(-y0+cy0)*dx
			for y=cy0,min(cy1,127) do
				local x=nodes[y]
				if x then
				 rectfill(x,y,x0,y)
				else
				 nodes[y]=x0
				end
				x0+=dx					
			end			
			--break
			x0,y0=_x1,_y1
		end
  	end
  	poly={}
end
}
end

-->8
-- poke-based2 rasterizer
function poke_rasterizer()
	local poly={}
	
	local cache_cls={
		__index=function(t,k)
			local f=function(a)
				t[k]=function(b)
					rectfill(a,k,b,k)
				end
			end  
			--t[k]=f
			return f
		end
	}
	return {
	name="memset",
	-- add edge
	add=function(self,verts,c,z)
		add(poly,{v=verts,c=c})
	end,
 draw=function(self)
	for k=1,#poly do
		local p=poly[k]
		local v,c=p.v,p.c

		local v0,nodes=v[#v],{} -- setmetatable({},cache_cls)
		local x0,y0=v0[1],v0[2]
		for i=1,#v do
			local v1=v[i]
			local x1,y1=v1[1],v1[2]
			local _x1,_y1=x1,y1
			if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
			local cy0,cy1,dx=y0\1+1,y1\1,(x1-x0)/(y1-y0)
			if(y0<0) x0-=y0*dx y0=0
   		x0+=(-y0+cy0)*dx
			for y=cy0,min(cy1,127) do
				local x=nodes[y]
				if x then
					local x0,x1=x\1,x0\1
					if(x0>x1) x0,x1=x1,x0 
					-- odd boundary?
					local m=0x6000|y<<6
					local m0,c=m|x0\2,c*0x11
					if(x0&1==1) poke(m0,@m0&0xf|c<<4) m0+=1
					memset(m0,c,(x1-x0-1)\2)
					-- remaining 0-4 pixels
					if(x1&1==1) m|=((x1)\2) poke(m,@m&0xf|c<<4)
					
					--pset(x1,y,8)
				else
				 nodes[y]=x0
				end
				x0+=dx					
			end			
			--break
			x0,y0=_x1,_y1
		end
  	end
  	poly={}
end
}
end

function sort(_data)  
	local _len,buffer1,buffer2,idx=#_data,_data,{},{}

	-- radix shift
	for shift=0,5,5 do
		-- faster than for each/zeroing count array
		memset(0x4300,0,32)

		for i,b in pairs(buffer1) do
			local c=0x4300+((b.x>>shift)&31)
			poke(c,@c+1)
			idx[i]=c
		end
				
		-- shifting array
		local c0=peek(0x4300)
		for mem=0x4301,0x431f do
			local c1=@mem+c0
			poke(mem,c1)
			c0=c1
		end

		for i=_len,1,-1 do
			local c=@idx[i]
			buffer2[c] = buffer1[i]
			poke(idx[i],c-1)
		end

		buffer1, buffer2 = buffer2, buffer1
	end
end
-- ref:
-- https://www.phatcode.net/res/224/files/html/ch67/67-03.html

function convex_zbuf_rasterizer()
	local poly={}
	
	local screen_cls={
		__index=function(t,k)
			-- head of stack
			local head={x=-32000}
			t[k]=head
			return head
		end
	}
	-- all spans
	local screen=setmetatable({},screen_cls)

	local function insert(spans,span)
		local x0,mini=span.x,1
		for i=1,#spans do
			mini=i
			if(x0>spans[i].x) break
		end
		-- shift right
		for i=#spans,mini,-1 do
			spans[i+1]=spans[i]
		end
		-- insert
		spans[mini]=span
	end
	
	return {
	name="edge+sub-pix+zbuf",
	-- add edge
	add=function(self,v,c,z)
		local v0,spans,screen=v[#v],{},screen
		local x0,y0=v0[1],v0[2]
		for i=1,#v do
			local v1=v[i]
			local x1,y1=v1[1],v1[2]
			local _x1,_y1=x1,y1
			if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
			local cy0,dx=ceil(y0),(x1-x0)/(y1-y0)
			if(y0<0) x0-=y0*dx y0=0
   		x0+=(cy0-y0)*dx
			for y=cy0,min(ceil(y1)-1,127) do
				local span=spans[y]
				if span then
					local x0,x1=x0,span.x
					if(x0>x1) x0,x1=x1,x0
					-- get start of linked list
					local head=screen[y]
					local prev=head
					while head and head.x<x0 do
						prev,head=head,head.next
					end
					-- insert start of span
					head={x=x0,x1=x1,c=c,z=z,next=prev.next}
					prev.next,prev=head,head
					-- insert end of span
					while head and head.x<x1 do
						prev,head=head,head.next
					end
					prev.next={x=x1,x0=x0,c=c,z=z,next=prev.next}
				else
					spans[y]={x=x0}
				end
				x0+=dx					
			end			
			x0,y0=_x1,_y1
		end
	end,
	 draw=function(self)
		for y,spans in pairs(screen) do
			local head,start=spans.next
			while head do
				if not start then
					start=head
				else
					-- 'pair' event
					if head.z>start.z then
						-- new "foreground" span
						rectfill(start.x,y,head.x,y,start.c)
						start=head
					elseif head.z==start.z then
						-- end of self
						rectfill(start.x,y,head.x,y,start.c)
						-- find foremost 'background' span (if any)
						local x,z,maxz,maxspan=head.x,start.z,-32000
						local bck=spans.next
						while bck do
							if bck.z<z and
								bck.z>maxz and
								bck.x1 and 
								bck.x1>x and
								bck.x<x then
									maxz,maxspan=bck.z,bck
							end
							bck=bck.next
						end
						start=maxspan
						if(start) start.x=x
					end
				end
				head=head.next
			end
		end
		-- reset screen buffer
		screen=setmetatable({},screen_cls)
	end
}
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007700077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007700077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
