pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- vector & tools
function lerp(a,b,t)
	return a*(1-t)+b*t
end

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
function v_normz(v)
	local d=v_dot(v,v)
	if d>0.001 then
		d=d^.5
		v[1]/=d
		v[2]/=d
		v[3]/=d
	end
	return d
end
function v_lerp(a,b,t)
	return {
		lerp(a[1],b[1],t),
		lerp(a[2],b[2],t),
		lerp(a[3],b[3],t)
	}
end

local v_up={0,1,0}

-- quaternion
function make_q(v,angle)
	angle/=2
	-- fix pico sin
	local s=-sin(angle)
	return {v[1]*s,
	        v[2]*s,
	        v[3]*s,
	        cos(angle)}
end
function q_clone(q)
	return {q[1],q[2],q[3],q[4]}
end

function q_x_q(a,b)
	local qax,qay,qaz,qaw=a[1],a[2],a[3],a[4]
	local qbx,qby,qbz,qbw=b[1],b[2],b[3],b[4]
        
	a[1]=qax*qbw+qaw*qbx+qay*qbz-qaz*qby
	a[2]=qay*qbw+qaw*qby+qaz*qbx-qax*qbz
	a[3]=qaz*qbw+qaw*qbz+qax*qby-qay*qbx
	a[4]=qaw*qbw-qax*qbx-qay*qby-qaz*qbz
end
function m_from_q(q)
	local x,y,z,w=q[1],q[2],q[3],q[4]
	local x2,y2,z2=x+x,y+y,z+z
	local xx,xy,xz=x*x2,x*y2,x*z2
	local yy,yz,zz=y*y2,y*z2,z*z2
	local wx,wy,wz=w*x2,w*y2,w*z2

	return {
		1-(yy+zz),xy+wz,xz-wy,0,
		xy-wz,1-(xx+zz),yz+wx,0,
		xz+wy,yz-wx,1-(xx+yy),0,
		0,0,0,1}
end

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
-- 
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
function make_cam()
	local angle,angles=0,{}
	for i=0,15 do
		add(angles,atan2(7.5,i-7.5))
	end
	return {
		pos={0,0,0},
		track=function(self,pos,a,m)
   			pos=v_clone(pos)
   			-- height
			v_add(pos,m_fwd(m),-0.8)
   			pos[2]+=0.2
			angle=a
			-- inverse view matrix
			m=make_m_from_euler(0,a,0)
		   	m_inv(m)
		   	m_set_pos(m,{-pos[1],-pos[2],-pos[3]})
			self.pos,self.m=pos,m
		end,
		project_poly=function(self,p,c)
			local p0,p1=p[1],p[2]
			-- magic constants = 89.4% vs. 90.9%
			-- shl = 79.7% vs. 80.6%
			local x0,y0=63.5+flr(shl(p0[1]/p0[3],6)),63.5-flr(shl(p0[2]/p0[3],6))
			local x1,y1=63.5+flr(shl(p1[1]/p1[3],6)),63.5-flr(shl(p1[2]/p1[3],6))
			for i=3,#p do
				local p2=p[i]
				local x2,y2=63.5+flr(shl(p2[1]/p2[3],6)),63.5-flr(shl(p2[2]/p2[3],6))
				trifill(x0,y0,x1,y1,x2,y2,c)
				x1,y1=x2,y2
			end
		end,
		visible_tiles=function(self)
  			local x,y=shr(self.pos[1],3)+16,shr(self.pos[3],3)+16
   			local x0,y0=flr(x),flr(y)
   			local tiles={[x0+shl(y0,5)]=0} 
   
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
				for dist=0,1 do
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

function make_plyr(p,angle)
	local pos=v_clone(p)
	local oldf
	local velocity=0
	local vangle=0
	return {
		get_pos=function()
	 		return pos,angle,m_from_q(make_q(oldf and oldf.n or v_up,angle))
		 end,
		handle_input=function()
			local dx,dy=0,0
			if(btn(2)) dx=1
			if(btn(3)) dx=-1
			if(btn(0)) dy=-1
			if(btn(1)) dy=1
		
			vangle+=dy
			-- if(oldf) dx/=8
			velocity+=0.33*dx
		end,
		update=function()
  			vangle*=0.8
  			velocity*=0.8

			angle+=vangle/512

			-- update orientation matrix
			local m=make_m_from_euler(0,angle,0)
			-- backup current position
			local p0=v_clone(pos)
			v_add(pos,m_fwd(m),velocity/4)
			v_add(pos,v_up,-0.4)

			local f1=find_face(pos,oldf)
			-- invalid move?
			if not f1 then
				-- split until valid
				for i=4,1,-1 do
					local p2=v_lerp(p0,pos,i/4)
					f1=find_face(p2,oldf)
					if(f1) pos=p2 break
				end
			end

			-- find ground
			local newf,newpos=find_face(pos,oldf)
			if newf then		
				pos[2]=max(pos[2],newpos[2])
				oldf=newf
			end
			-- above 0
			pos[2]=max(pos[2])
			-- collision
			if oldf and oldf.borders then
				local hit,force=face_collide(oldf,pos,0.25)
				if hit then
					v_add(pos,force)
				end
			end
		end
	}
end

local cam=make_cam(63.5,63.5,63.5)
local plyr=make_plyr({-24,0,-6},0)
local plane=make_plane(8)
local time_t=0
local all_models={}

local track

local dither_pat={0xffff,0x7fff,0x7fdf,0x5fdf,0x5f5f,0x5b5f,0x5b5e,0x5a5e,0x5a5a,0x1a5a,0x1a4a,0x0a4a,0x0a0a,0x020a,0x0208,0x0000}


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
	local faces=track.ground[x+32*z]
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
function face_collide(f,p,r)
	local force,hit={0,0,0}
	for _,b in pairs(f.borders) do
		local pv=make_v(b.v,p)
		local dist=v_dot(pv,b.n)
		if dist<r then
			hit=true
			v_add(force,b.n,r-dist)
		end
	end
	return hit,force
end

function _init()
	track=all_models["track"]	
end

function _update()
	time_t+=1

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
	local n=#out+1
	for _,face in pairs(faces) do
		-- avoid overdraw for shared faces
		if face.session!=sessionid and (band(face.flags,1)>0 or v_dot(face.n,cam_pos)>face.cp) then
			local z,y,outcode,verts,is_clipped=0,0,0xffff,{},0
			-- project vertices
			for ki,vi in pairs(face.vi) do
				local a=v_cache(vi)
				y+=a[2]
				z+=a[3]
				outcode=band(outcode,a.outcode)
				-- behind near plane?
				is_clipped+=band(a.outcode,2)
				verts[ki]=a
			end
			-- mix of near/far verts?
			if outcode==0 then
	   			-- average before changing verts
				y/=#verts
				z/=#verts
				-- mix of near+far vertices?
				if(is_clipped>0) verts=z_poly_clip(z_near,verts)
				if #verts>2 then
					out[n]={key=1/(y*y+z*z),f=face,v=verts,clipped=is_clipped>0 or nil,dist=dist}
				 	-- 0.1% faster vs [#out+1]
				 	n+=1
				end
			end
			face.session=sessionid	
		end
	end
end

function collect_model_faces(model,m,out)
	-- cam pos in object space
	local p,cm={},cam.m
	local cx,cy,cz=cm[13],cm[14],cm[15]
	local x,y,z=-cx-m[13],-cy-m[14],-cz-m[15]
	local cam_pos={m[1]*x+m[2]*y+m[3]*z,m[5]*x+m[6]*y+m[7]*z,m[9]*x+m[10]*y+m[11]*z}
	
	local function v_cache(k)
		local a=p[k]
		if not a then
			a=v_clone(model.v[k])
			-- relative to world
			m_x_v(m,a)
			-- world to cam
			local ax,ay,az=a[1]+cx,a[2]+cy,a[3]+cz
			a={cm[1]*ax+cm[5]*ay+cm[9]*az,cm[2]*ax+cm[6]*ay+cm[10]*az,cm[3]*ax+cm[7]*ay+cm[11]*az,outcode=0}
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
		cam:project_poly(d.v,d.f.c)
		-- details?
		if d.f.inner and d.dist<2 then					
			for _,face in pairs(d.f.inner) do
				local verts={}
				for ki,vi in pairs(face.vi) do
					verts[ki]=v_cache(vi)
				end
				if(d.clipped) verts=z_poly_clip(z_near,verts)
				if(#verts>2) cam:project_poly(verts,face.c)
			end
		end
	end
	fillp()
end

function _draw()
	sessionid+=1

	local pos,angle=plyr:get_pos()

	-- background
 	cls(3)
	local x0=-(angle*128)%128
 	map(0,0,x0,0,16,8)
 	if x0>0 then
 		x0-=128
	 	map(0,0,x0,0,16,8)
 	end

	local p,m={},cam.m
	local cx,cy,cz=m[13],m[14],m[15]
	local function v_cache(k)
		local a=p[k]
		if not a then
			-- world to cam
			local v=track.v[k]
			local x,y,z=v[1]+cx,v[2]+cy,v[3]+cz
			a={m[1]*x+m[5]*y+m[9]*z,m[2]*x+m[6]*y+m[10]*z,m[3]*x+m[7]*y+m[11]*z}

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

	--[[
	for k,dist in pairs(tiles) do
		local faces=track.voxels[k]
		if faces then
			for _,f in pairs(faces) do
				if f.borders then
					for _,b in pairs(f.borders) do
						local x,y,z=b.v[1]+cx,b.v[2]+cy,b.v[3]+cz
						a={m[1]*x+m[5]*y+m[9]*z,m[2]*x+m[6]*y+m[10]*z,m[3]*x+m[7]*y+m[11]*z}
						-- cam to screen
						local w0=64/a[3]
						if w0>0 then
							local x0,y0=64+a[1]*w0,64-a[2]*w0
							circ(x0,y0,2,8)
						end
					end
				end
			end
		end
	end
	]]

	-- clear vertex cache
	out={}
	local pos,angle,m=plyr:get_pos()
	-- m=make_m_from_euler(0,time()/16,0)
	m_set_pos(m,pos)
	-- car
	local model=all_models["car"].lods[2]
	total_faces=#model.f
	collect_model_faces(model,m,out)
 	sort(out)
	draw_polys(out)
	
	local cpu=flr(1000*stat(1))/10
	local mem=flr(100*stat(0))/10
	cpu=cpu.."%\n"..mem.."kb\n█:"..#out.."/"..total_faces--.."\n"..cam.pos[1].."/"..cam.pos[3]
	printb(cpu,2,2,6,5)

 printb("lap time\n"..time_tostr(time_t),90,2,7,0)
	printb("time",52,2,7,0)
 printxl(tostr(flr(time())),64,9)	
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
				add(f.inner,df)
			end)
		end
		-- collision planes?
		local borders=band(shr(f.flags,5),0x7)		
		if borders>0 then
			f.borders={}
			local bi=unpack_int()
			for i=0,borders-1 do
				-- vertex index
				local v0=band(shr(bi,i*4),0xf)
				local v1=(v0+1)%#f.vi
				-- get border vectors
				v0,v1=model.v[f.vi[v0+1]],model.v[f.vi[v1+1]]
				-- make a 2d plane vector
				local bn=make_v(v1,v0)
				bn[2]=0
				v_normz(bn)
				add(f.borders,{v=v0,n={bn[3],0,-bn[1]}})
			end
		end
		-- normal
		f.n={unpack_double(),unpack_double(),unpack_double()}
		-- viz check
		f.cp=v_dot(f.n,model.v[f.vi[1]])

		add(model.f,f)
	end)
end
function unpack_models()
	mem=0x0
	-- for all models
	unpack_array(function()
		local model,name,scale={lods={},lod_dist={}},unpack_string(),1/unpack_int()
		scale*=0.75
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
	local model,name,scale={v={},f={},n={},cp={},voxels={},ground={}},unpack_string(),1/unpack_int()
	-- vertices + faces + normal data
	unpack_model(model)

	-- voxels: collision and rendering optimization
	unpack_array(function()
		local id,faces,solid_faces=unpack_variant(),{},{}
		unpack_array(function()
			local f=model.f[unpack_variant()]
			add(faces,f)
			-- is face solid?
			if(band(f.flags,16)>0) add(solid_faces,f)
		end)
		-- list of faces per voxel
		model.voxels[id]=faces
		-- list of ground faces per voxel
		model.ground[id]=#solid_faces>0 and solid_faces
	end)
	-- index by name
	all_models[name]=model
end

-- first track data cart
reload(0,0,0x4300,"track_0.p8")
unpack_track()
-- 3d models cart
reload(0,0,0x4300,"track_models.p8")
-- load regular 3d models
unpack_models()
-- restore
reload()

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
function z_poly_clip(znear,v)
	local res={}
	local v0,v1,d1,t,r=v[#v]
	local d0=-znear+v0[3]
 	-- use local closure
 	local clip_line=function()
 		local r,t=make_v(v0,v1),d0/(d0-d1)
 		v_scale(r,t)
 		v_add(r,v0)
 		res[#res+1]=r
 	end
	for i=1,#v do
		v1=v[i]
		d1=-znear+v1[3]
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

-->8
-- print helpers
function padding(n)
	n=tostr(flr(min(n,99)))
	return sub("00",1,2-#n)..n
end

function time_tostr(t)
	if(t==32000) return "--"
	-- frames per sec
	local s=padding(flr(t/30)%60).."''"..padding(flr(10*t/3)%100)
	-- more than a minute?
	if(t>1800) s=padding(flr(t/1800)).."'"..s
	return s
end

function printb(s,x,y,c1,c2)
	?s,x,y+1,c2 or 1
	?s,x,y,c1
end

local xlfont={
 ["0"]=0x2000,
 ["1"]=0x2d00,
 ["2"]=0x3a00,
 ["3"]=0x4700,
 ["4"]=0x5400,
 ["5"]=0x6100,
 ["6"]=0x6e00,
 ["7"]=0x2010,
 ["8"]=0x2d10,
 ["9"]=0x3a10
}

function printxl(s,x,y)
	palt(14,true)
	palt(0,false)
	x-=#s*6.5
	for i=1,#s do
		local f=xlfont[sub(s,i,i)]
		local sx,sy=shr(f,8),band(f,0xff)
		sspr(sx,sy,13,16,x,y)		
		x+=13
	end
	
	palt()
end

__gfx__
00000000ccccccccccccccccccccccccee000000000eeeeee00000eeeeee000000000eeee000000000eeeeeeeee0000000000000000000ee000000000ee00000
00000000cccccc7777cccccccccccccce0aaaaaaaaa0eeee0aaa90eeeee0aaaaaaaaa0ee0aaaaaaaaa0eeeeeee0aaaa900aaaaaaaaaa90e0aaaaaaaaa0e00000
00000000ccccc7777777cccccccccccc0aaaaaaaaaa90ee0aaaa90eeee0aaaaaaaaaa900aaaaaaaaaa90eeeee0aaaaa900aaaaaaaaaa900aaaaaaaaaa9000000
00000000cccc777777777ccccccccccc0aa999999aa90ee0aaaa90eeee0aa99999aaa900aa999999aa90eeee0aaa9aa900aa99999999900aa999999aa9000000
00000000cc777777777777cccccccccc0aa900000aa90ee099aa90eeee0aa90000aaa900aa900000aa90eee0aaa90aa900aa90000000000aa900000aa9000000
00000000c7777777777777cccccccccc0aa90eee0aa90ee000aa90eeee09990e0aaaa9009990eee0aa90ee0aaa900aa900aa90eeeeeeee0aa90eee0999000000
00000000c77777777777777ccccccccc0aa90eee0aa90eeee0aa90eeee000000aaaa90e000000000aa90e0aaa90e0aa900aa90000000ee0aa900000000000000
000000007777777777777777cccccccc0aa90eee0aa90eeee0aa90eeeeeeee0aaaa90eeeeee0aaaaa90e0aaa90ee0aa900aaaaaaaaa90e0aaaaaaaaa90e00000
0000000077777777cccccccc000000000aa90eee0aa90eeee0aa90eeeeeee0aaaa90eeeeeee09999a90e0aa90eee0aa90099999999aa900aa999999aa9000000
0000000077777777cccccccc000000000aa90eee0aa90eeee0aa90eeeeee0aaaa90eeeee00000000aa900aa900000aa90000000000aa900aa900000aa9000000
000000007777777777777777000000000aa90eee0aa90eeee0aa90eeeee0aaaa90eeeee0aa90eee0aa900aaaaaaaaaa900aa90eee0aa900aa90eee0aa9000000
000000007777777777777777000000000aa900000aa90ee000aa9000ee0aaaa000000000aa900000aa900aaaaaaaaaa900aa900000aa900aa900000aa9000000
000000007777777777777777777700000aaaaaaaaaa90ee0aaaaaa90ee0aaaaaaaaaa900aaaaaaaaaa90099999999aa900aaaaaaaaaa900aaaaaaaaaa9000000
0000000077777777777777777777770009aaaaaaaa990ee0aaaaaa90ee0aaaaaaaaaa9009aaaaaaaa990000000000aa9009aaaaaaaa99009aaaaaaaa99000000
00000000777777777777777777777770e09999999990eee099999990ee0999999999990e09999999990eeeeeeeee09990e09999999990ee09999999990e00000
00000000777777777777777777777777ee000000000eeee000000000ee0000000000000ee000000000eeeeeeeeee00000ee000000000eeee000000000ee00000
000000006666666633333333000000000000000000000ee000000000eeee000000000ee000000000000000000000000000000000000000000000000000000000
000000006d6d6d6d33333333000000000aaaaaaaaaa90e0aaaaaaaaa0ee0aaaaaaaaa0e000000000000000000000000000000000000000000000000000000000
000000003636363633333333000000000aaaaaaaaaa900aaaaaaaaaa900aaaaaaaaaa90000000000000000000000000000000000000000000000000000000000
000000003333333333333333000000000aa999999aa900aa999999aa900aa999999aa90000000000000000000000000000000000000000000000000000000000
000000003333333333333333000000000aa900000aa900aa900000aa900aa900000aa90000000000000000000000000000000000000000000000000000000000
0000000033333333333333330000000009990eee0aa900aa90eee0aa900aa90eee0aa90000000000000000000000000000000000000000000000000000000000
0000000033333333333333330000000000000ee0aaa900aa900000aa900aa900000aa90000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000eeeeee0aaa90ee0aaaaaaaa90e09aaaaaaaaa90000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeeee0aaa90eee0a999999a90ee09999999aa90000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee0aaa90eee0aa900000aa90000000000aa90000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee0aa90eeee0aa90eee0aa900aa90eee0aa90000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee0aa90eeee0aa900000aa900aa900000aa90000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee0aa90eeee0aaaaaaaaaa900aaaaaaaaaa90000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee0aa90eeee0aaaaaaaaa99009aaaaaaaa990000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee09990eeeee09999999990ee09999999990e000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000eeee00000eeeeee000000000eeee000000000ee000000000000000000000000000000000000000000000000000000000
__map__
0303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030301020303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0301020111110203030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111111111111102010203030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111102030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111020102011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121212121212121212121212121212100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
