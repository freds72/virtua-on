pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- vector & tools
function make_v(a,b)
	return {
		b[1]-a[1],
		b[2]-a[2],
		b[3]-a[3]}
end
function v_clone(v)
	return {v[1],v[2],v[3]}
end
function v_dot(a,b)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
end
function v_scale(v,scale)
	v[1]*=scale
	v[2]*=scale
	v[3]*=scale
end
function v_add(v,dv,scale)
	scale=scale or 1
	v[1]+=scale*dv[1]
	v[2]+=scale*dv[2]
	v[3]+=scale*dv[3]
end
function v_min(a,b)
	return {min(a[1],b[1]),min(a[2],b[2]),min(a[3],b[3])}
end
function v_max(a,b)
	return {max(a[1],b[1]),max(a[2],b[2]),max(a[3],b[3])}
end

local v_up={0,1,0}

-- matrix functions
function m_x_v(m,v)
	local x,y,z=v[1],v[2],v[3]
	v[1],v[2],v[3]=m[1]*x+m[5]*y+m[9]*z+m[13],m[2]*x+m[6]*y+m[10]*z+m[14],m[3]*x+m[7]*y+m[11]*z+m[15]
end

function make_m_from_euler(x,y,z)
		local a,b = cos(x),-sin(x)
		local c,d = cos(y),-sin(y)
		local e,f = cos(z),-sin(z)
  
  -- yxz order
  local ce,cf,de,df=c*e,c*f,d*e,d*f
	 return {
	  ce+df*b,a*f,cf*b-de,0,
	  de*b-cf,a*e,df+ce*b,0,
	  a*d,-b,a*c,0,
	  0,0,0,1}
end
-- only invert 3x3 part
function m_inv(m)
	m[2],m[5]=m[5],m[2]
	m[3],m[9]=m[9],m[3]
	m[7],m[10]=m[10],m[7]
end
function m_set_pos(m,v)
	m[13],m[14],m[15]=v[1],v[2],v[3]
end
-- returns basis vectors from matrix
function m_right(m)
	return {m[1],m[2],m[3]}
end
function m_up(m)
	return {m[5],m[6],m[7]}
end
function m_fwd(m)
	return {m[9],m[10],m[11]}
end

function make_plane(width)
	return {
		{0,0,0},
		{width,0,0},
		{width,0,width},
		{0,0,width}
	}
end

-- sort
-- https://github.com/morgan3d/misc/tree/master/p8sort
function sort(data)
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

-->8
-- main engine
function make_cam(x0,y0,focal)
	local angle,angles=0,{}
	for i=0,15 do
		add(angles,atan2(7.5,i-7.5))
	end
	return {
		pos={0,0,0},
		track=function(self,pos,a,m)
   			self.pos=v_clone(pos)
   			-- height
			v_add(self.pos,m_fwd(m),-0.5)
   			self.pos[2]+=0.1
			angle=a
			-- inverse view matrix
		   	m_inv(m)
   			self.m=m
  		end,
	 	project2d=function(self,x,y)
	 		return x*8,128-y*8
	 	end,
	 	project=function(self,v)
	  		-- view to screen
   			local w=focal/v[3]
   			return x0+ceil(v[1]*w),y0-ceil(v[2]*w),w
	 	end,
	visible_tiles=function(self)
  	local x,y=self.pos[1]/8+16,self.pos[3]/8+16
   local x0,y0=flr(x),flr(y)
   local tiles={
    [x0+32*y0]=0
   } 
   
   for i=1,16 do
   	
   	local a=angles[i]+angle
   	local v,u=cos(a),-sin(a)
   	
    local mapx,mapy=x0,y0
   
    local ddx,ddy=abs(1/u),abs(1/v)
    local mapdx,distx
    if u<0 then
    	mapdx=-1
     distx=(x-mapx)*ddx
    else
    	mapdx=1
     distx=(mapx+1-x)*ddx
    end
   	local mapdy,disty
    if v<0 then
    	mapdy=-1
     disty=(y-mapy)*ddy
    else
    	mapdy=1
     disty=(mapy+1-y)*ddy
    end	
    for dist=0,2 do
   		if distx<disty then
   			distx+=ddx
   			mapx+=mapdx
   		else
   			disty+=ddy
   			mapy+=mapdy
   		end
   		-- non solid visible tiles
   		if band(bor(mapx,mapy),0xffe0)==0 then
   			tiles[mapx+32*mapy]=dist
   		end
   	end				
  	end	
  	return tiles
	 end
	}
end

function make_plyr(p)
	local pos,angle=v_clone(p),0
	local oldf
	local velocity=0
	return {
		get_pos=function()
	 		return pos,angle,make_m_from_euler(0.0,angle,0)
		 end,
		handle_input=function()
			local dx,dy=0,0
			if(btn(2)) dx=1
			if(btn(3)) dx=-1
			if(btn(0)) dy=-1
			if(btn(1)) dy=1
		
			angle+=dy/64
			-- if(oldf) dx/=8
			velocity+=0.25*dx
		end,
		update=function()
  			velocity*=0.8

			-- update orientation matrix
			local m=make_m_from_euler(0,angle,0)
			v_add(pos,m_fwd(m),velocity/4)
			v_add(pos,v_up,-0.4)
			-- find ground
			local newf,newpos=find_face(pos,oldf)
			if newf then		
				pos[2]=max(pos[2],newpos[2])
				oldf=newf
			end
			-- above 0
			pos[2]=max(pos[2])+0.15
		end
	}
end

local cam=make_cam(63.5,63.5,63.5)
local plyr=make_plyr({0,0,69.73})
local plane=make_plane(8)
local all_models={}

local track

local dither_pat={0xffff,0x7fff,0x7fdf,0x5fdf,0x5f5f,0x5b5f,0x5b5e,0x5a5e,0x5a5a,0x1a5a,0x1a4a,0x0a4a,0x0a0a,0x020a,0x0208,0x0000}

function project_poly(p,c,scale)
	if #p>2 then
		local x0,y0=cam:project(p[1])
		local x1,y1=cam:project(p[2])
		for i=3,#p do
			local x2,y2=cam:project(p[i])
		 	trifill(x0,y0,x1,y1,x2,y2,c)
			x1,y1=x2,y2
		end
	end
end

function is_inside(p,f)
	local v,vi=track.v,f.vi
	local inside,p0=0,track.v[vi[#vi]]
	for i=1,#vi do
		local p1=v[vi[i]]
		if((p0[3]-p1[3])*(p[1]-p0[1])+(p1[1]-p0[1])*(p[3]-p0[3])>0) inside+=1
		p0=p1
	end
	if inside==#vi then
		-- intersection point
		local t=-v_dot(make_v(v[vi[1]],p),f.n)/f.n[2]
		p=v_clone(p)
		p[2]+=t
		return f,p
	end
end

function find_face(p,oldf)	
	-- same face as previous hit
	if oldf then
		local newf,newp=is_inside(p,oldf)
		if(newf) return newf,newp
	end
	-- voxel?
	local x,z=flr(p[1]/8+16),flr(p[3]/8+16)
	local faces=track.voxels[x+32*z]
	if faces then
		for _,f in pairs(faces) do
			if f!=oldf then
				local newf,newp=is_inside(p,f)
				if(newf) return newf,newp
			end
		end
	end
	-- not found
end

function _init()
	track=all_models["track"]	
end

function _update()
	plyr:handle_input()
	
	plyr:update()
	
	cam:track(plyr:get_pos())
end

local sessionid=0
local k_far,k_near=0,2
local k_right,k_left=4,8
local z_near=0.05
local current_face

function collect_faces(faces,cam_pos,v_cache,out,dist)
	for _,face in pairs(faces) do
		-- avoid overdraw for shared faces
		if face.session!=sessionid and (band(face.flags,1)>0 or v_dot(face.n,cam_pos)>face.cp) then
			local z,outcode,verts,is_clipped=0,0xffff,{},0
			-- project vertices
			for _,vi in pairs(face.vi) do
				local a=v_cache(vi)
				z+=a[3]
				outcode=band(outcode,a.outcode)
				-- behind near plane?
				is_clipped+=band(a.outcode,2)
				verts[#verts+1]=a
			end
			-- mix of near/far verts?
			if outcode==0 then
				-- mix of near+far vertices?
				if(is_clipped>0) verts=z_poly_clip(z_near,verts)
				if(#verts>2) out[#out+1]={key=#verts/z,f=face,v=verts,clipped=is_clipped>0 or nil,dist=dist}
			end
			face.session=sessionid	
		end
	end
end

function collect_model_faces(model,m,out)
	-- cam pos in object space
	local x,y,z=cam.pos[1],cam.pos[2],cam.pos[3]--cam.pos[1]-m[13],cam.pos[2]-m[14],cam.pos[3]-m[15]
	local cam_pos={m[1]*x+m[2]*y+m[3]*z,m[5]*x+m[6]*y+m[7]*z,m[9]*x+m[10]*y+m[11]*z}

	local p={}
	local function v_cache(k)
		local a=p[k]
		if not a then
			a=v_clone(model.v[k])
			-- relative to world
			m_x_v(m,a)
			-- world to cam
			v_add(a,cam.pos,-1)
			m_x_v(cam.m,a)

			local ax,az=a[1],a[3]
			local outcode=1--az>z_near and k_far or k_near
			--[[
			if az>z_near then
				outcode=k_far
				if ax>az then outcode+=k_right
				elseif -ax>az then outcode+=k_left
				end	
			end
			]]
			a.outcode=outcode
			p[k]=a
		end
		return a
	end

	collect_faces(model.f,cam_pos,v_cache,out)
end

function draw_polys(polys,v_cache)
	-- all poly are encoded with 2 colors
 	fillp(0xa5a5)
	for i=1,#polys do
		local d=polys[i]
		project_poly(d.v,d.f.c)
		-- details?
		if d.f.inner and d.dist<2 then					
			for _,face in pairs(d.f.inner) do
				local verts={}
				for _,vi in pairs(face.vi) do
					local a=v_cache(vi)
					verts[#verts+1]=a
				end
				if(d.clipped) verts=z_poly_clip(z_near,verts)
				project_poly(verts,face.c)
			end
		end
	end
	fillp()
end

function _draw()
	sessionid+=1
	--cls(12)
	rectfill(0,0,127,63,12)
	rectfill(0,64,127,127,3)

	local p={}
	local function v_cache(k)
		local a=p[k]
		if not a then
			-- world to cam
			a=make_v(cam.pos,track.v[k])
			m_x_v(cam.m,a)

			local ax,az=a[1],a[3]
			local outcode=az>z_near and k_far or k_near
			if ax>az then outcode+=k_right
			elseif -ax>az then outcode+=k_left
			end	
			a.outcode=outcode

			p[k]=a
		end
		return a
	end
 
	local tiles=cam:visible_tiles()

	--[[
	function draw_voxel_plane(k,c)
		local i,j=k%32,flr(k/32)
 		local offset={8*i-128,0,8*j-128}
		local verts={}
		for vi,v in pairs(plane) do			
 			v=v_clone(v)
 			v_add(v,offset)
 			v_add(v,cam.pos,-1)
	 		m_x_v(cam.m,v)
			verts[vi]=v
		end
		local faces=track.voxels[k]
		if faces then
			fillp() 
		else
			fillp(0xa5a5)
		end
		verts=z_poly_clip(z_near,verts)
		project_poly(verts,c)
	end

 	for k,_ in pairs(tiles) do
	 	draw_voxel_plane(k,0x21)
		--if(faces) print(#faces,x0,y0-8,7)
	end
	fillp()
	]]

	local out={}
	local total_faces=0
	-- get visible voxels
	for k,dist in pairs(tiles) do
	--for k,_ in pairs(track.voxels) do
		local faces=track.voxels[k]
		if faces then
			total_faces+=#faces
			collect_faces(faces,cam.pos,v_cache,out,dist)
		end 
	end
	
	-- track
 	sort(out)
	draw_polys(out,v_cache)

	-- car
	--[[
	out={}
	local pos,angle=plyr:get_pos()
	local m=make_m_from_euler(0,time()/5,0)
	m_set_pos(m,pos)
	collect_model_faces(all_models["car"].lods[1],m,out)
 	sort(out)
	draw_polys(out)
	]]

	local cpu=flr(1000*stat(1))/10
	cpu=cpu.." ▤"..stat(0).." █:"..#out.."/"..total_faces.."\n"..cam.pos[1].."/"..cam.pos[3]
	print(cpu,2,3,5)
	print(cpu,2,2,7)

end

-->8
-- unpack data & models
local cart_id,mem=1
function mpeek()
	if mem==0x4300 then
		printh("switching cart: "..cart_id)
		reload(0,0,0x4300,"track_"..cart_id..".p8")
		cart_id += 1
		mem=0
	end
	local v=peek(mem)
	mem+=1
	return v
end

-- unpack a list into an argument list
-- trick from: https://gist.github.com/josefnpat/bfe4aaa5bbb44f572cd0
function munpack(t, from, to)
 local from,to=from or 1,to or #t
 if(from<=to) return t[from], munpack(t, from+1, to)
end

-- w: number of bytes (1 or 2)
function unpack_int(w)
  	w=w or 1
	local i=w==1 and mpeek() or bor(shl(mpeek(),8),mpeek())
	return i
end
-- unpack 1 or 2 bytes
function unpack_variant()
	local h=mpeek()
	-- above 127?
	if band(h,0x80)>0 then
		h=bor(shl(band(h,0x7f),8),mpeek())
	end
	return h
end
-- unpack a float from 1 byte
function unpack_float(scale)
	local f=shr(unpack_int()-128,5)
	return f*(scale or 1)
end
-- unpack a double from 2 bytes
function unpack_double(scale)
	local f=(unpack_int(2)-16384)/128
	return f*(scale or 1)
end
-- unpack an array of bytes
function unpack_array(fn)
	for i=1,unpack_variant() do
		fn(i)
	end
end
-- valid chars for model names
local itoa='_0123456789abcdefghijklmnopqrstuvwxyz'
function unpack_string()
	local s=""
	unpack_array(function()
		local c=unpack_int()
		s=s..sub(itoa,c,c)
	end)
	return s
end

function unpack_model(model,scale)
	-- vertices
	unpack_array(function()
		local v={unpack_double(scale),unpack_double(scale),unpack_double(scale)}
		add(model.v,v)
	end)

	-- faces
	unpack_array(function()
		local f={vi={},flags=unpack_int(),c=unpack_int()}
		-- vertex indices
		-- quad?
		local n=band(f.flags,2)>0 and 4 or 3
		for i=1,n do
			add(f.vi,unpack_variant())
		end
		-- inner faces?
		if band(f.flags,8)>0 then
			f.inner={}
			unpack_array(function()
				local df={vi={},flags=unpack_int(),c=unpack_int()}
				-- vertex indices
				-- quad?
				local n=band(df.flags,2)>0 and 4 or 3
				for i=1,n do
					add(df.vi,unpack_variant())
				end
				-- reuse parent face normal
				add(f.inner,df)
			end)
		end
		-- normal?
		f.n={unpack_double(),unpack_double(),unpack_double()}
		f.cp=v_dot(f.n,model.v[f.vi[1]])

		add(model.f,f)
	end)
end
function unpack_models()
	mem=0x1000
	-- for all models
	unpack_array(function()
		local model,name,scale={lods={},lod_dist={}},unpack_string(),1/unpack_int()
				
		unpack_array(function()
			local d=unpack_double()
			assert(d<127,"lod distance too large:"..d)
			-- store square distance
			add(model.lod_dist,d*d)
		end)
  
		-- level of details models
		unpack_array(function()
			local lod={v={},f={},n={},cp={}}
			unpack_model(lod,scale)
			add(model.lods,lod)
		end)

		-- index by name
		all_models[name]=model
	end)
end

-- unpack multi-cart track
function unpack_track()
	mem=0
	local model,name,scale={v={},f={},n={},cp={},voxels={}},unpack_string(),1/unpack_int()
	-- vertices + faces + normal data
	unpack_model(model)

	-- voxels: collision and rendering optimization
	unpack_array(function()
		local id,faces=unpack_variant(),{}
		unpack_array(function()
			add(faces,model.f[unpack_variant()])
		end)
		model.voxels[id]=faces
	end)
	-- index by name
	all_models[name]=model
end

-- track
reload(0,0,0x4300,"track_0.p8")
unpack_track()
-- restore cart
reload()
-- load regular 3d models
unpack_models()

-->8
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

--[[
function trifill(x0,y0,x1,y1,x2,y2,col)
	line(x0,y0,x1,y1,col)
	line(x2,y2)
	line(x0,y0)
end
]]
-- clipping
function plane_poly_clip(n,v)
	local dist,allin={},0
	for i,a in pairs(v) do
		local d=n[4]-(a[1]*n[1]+a[2]*n[2]+a[3]*n[3])
		if(d>0) allin+=1
	 dist[i]=d
	end
 -- early exit
	if(allin==#v) return v
 if(allin==0) return {}

	local res={}
	local v0,d0,v1,d1,t,r=v[#v],dist[#v]
 -- use local closure
 local clip_line=function()
 	local r,t=make_v(v0,v1),d0/(d0-d1)
 	v_scale(r,t)
 	v_add(r,v0)
 	res[#res+1]=r
 end
	for i=1,#v do
		v1,d1=v[i],dist[i]
		if d1>0 then
			if(d0<=0) clip_line()
			res[#res+1]=v1
		elseif d0>0 then
   clip_line()
		end
		v0,d0=v1,d1
	end
	return res
end

function z_poly_clip(znear,v)
	local dist={}
	for i,a in pairs(v) do
		dist[#dist+1]=-znear+a[3]
	end

	local res={}
	local v0,d0,v1,d1,t,r=v[#v],dist[#v]
 -- use local closure
 local clip_line=function()
 	local r,t=make_v(v0,v1),d0/(d0-d1)
 	v_scale(r,t)
 	v_add(r,v0)
 	res[#res+1]=r
 end
	for i=1,#v do
		v1,d1=v[i],dist[i]
		if d1>0 then
			if(d0<=0) clip_line()
			res[#res+1]=v1
		elseif d0>0 then
   clip_line()
		end
		v0,d0=v1,d1
	end
	return res
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1030e0c0d11010050010800408f30804080408f308f308f308f308f308f308f308040804080408040804080408f308f3080408f308f308040804086020ff1020
30400400f308040020ff508070600400f308040020ff105060200400f308040020ff206070300400f308040020ff307080400400f308040020ff501040800400
f3080400