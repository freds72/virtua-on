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
	return {
		v[1]+scale*dv[1],
		v[2]+scale*dv[2],
		v[3]+scale*dv[3]}
end
-- safe vector length
function v_len(v)
	local x,y,z=v[1],v[2],v[3]
	local d=max(max(abs(x),abs(y)),abs(z))
	if(d<0.001) return 0
	x/=d
	y/=d
	z/=d
	return d*(x*x+y*y+z*z)^0.5
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
function v_cross(a,b)
	local ax,ay,az=a[1],a[2],a[3]
	local bx,by,bz=b[1],b[2],b[3]
	return {ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx}
end

function v_lerp(a,b,t)
	return {
		lerp(a[1],b[1],t),
		lerp(a[2],b[2],t),
		lerp(a[3],b[3],t)
	}
end
function v_cross(a,b)
	local ax,ay,az=a[1],a[2],a[3]
	local bx,by,bz=b[1],b[2],b[3]
	return {ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx}
end

function v2_cross(a,b)
	return a[1]*b[3]-a[3]*b[1]
end

-- x/z orthogonal vector
function v2_ortho(a,scale)
	return {-scale*a[1],0,scale*a[3]}
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
	return {m[1]*x+m[5]*y+m[9]*z+m[13],m[2]*x+m[6]*y+m[10]*z+m[14],m[3]*x+m[7]*y+m[11]*z+m[15]}
end
-- optimized 4x4 matrix mulitply
function m_x_m(a,b)
	local a11,a12,a13,a21,a22,a23,a31,a32,a33=a[1],a[5],a[9],a[2],a[6],a[10],a[3],a[7],a[11]
	local b11,b12,b13,b14,b21,b22,b23,b24,b31,b32,b33,b34=b[1],b[5],b[9],b[13],b[2],b[6],b[10],b[14],b[3],b[7],b[11],b[15]

	return {
			a11*b11+a12*b21+a13*b31,a21*b11+a22*b21+a23*b31,a31*b11+a32*b21+a33*b31,0,
			a11*b12+a12*b22+a13*b32,a21*b12+a22*b22+a23*b32,a31*b12+a32*b22+a33*b32,0,
			a11*b13+a12*b23+a13*b33,a21*b13+a22*b23+a23*b33,a31*b13+a32*b23+a33*b33,0,
			a11*b14+a12*b24+a13*b34+a[13],a21*b14+a22*b24+a23*b34+a[14],a31*b14+a32*b24+a33*b34+a[15],1
		}
end
function m_clone(m)
	return {
		m[1],m[2],m[3],0,
		m[5],m[6],m[7],0,
		m[9],m[10],m[11],0,
		m[13],m[14],m[15],1
	}
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
function make_m_from_v_angle(up,angle)
	local fwd={-sin(angle),0,cos(angle)}
	local right=v_cross(up,fwd)
	v_normz(right)
	fwd=v_cross(right,up)
	return {
		right[1],right[2],right[3],0,
		up[1],up[2],up[3],0,
		fwd[1],fwd[2],fwd[3],0,
		0,0,0,1
	}
end
-- inline matrix vector multiply invert
-- inc. position
function m_inv_x_v(m,v)
	local x,y,z=v[1]-m[13],v[2]-m[14],v[3]-m[15]
	return {m[1]*x+m[2]*y+m[3]*z,m[5]*x+m[6]*y+m[7]*z,m[9]*x+m[10]*y+m[11]*z}
end

function m_set_pos(m,v)
	m[13]=v[1]
	m[14]=v[2]
	m[15]=v[3]
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

-- coroutine helper
function corun(f)
	local cs=costatus(f)
	if cs=="suspended" then
		assert(coresume(f))
		return f
	end
	return nil
end

-- radix sort
-- base code: https://twitter.com/jamesedge
function sort(_data)  
	local _len,buffer1,buffer2,idx=#_data,_data,{},{}

	-- radix shift
	for shift=0,8,8 do
		-- faster than for each/zeroing count array
		memset(0x4300,0,256)

		for i,b in pairs(buffer1) do
			local c=bor(0x4300,band(shr(b.key,shift),255))
			poke(c,peek(c)+1)
			idx[i]=c
		end
				
		-- shifting array
		local c0=peek(0x4300)
		for mem=0x4301,0x43ff do
			local c1=peek(mem)+c0
			poke(mem,c1)
			c0=c1
		end

		for i=_len,1,-1 do
			local c=peek(idx[i])
			buffer2[c]=buffer1[i]
			poke(idx[i],c-1)
		end

		buffer1,buffer2=buffer2,buffer1
	end
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
-- global vars
local track,plyr,cam
local all_models={}
local npcs={}
local actors={}

local sessionid=0
local k_far,k_near=0,2
local k_right,k_left=4,8
local z_near=1

-- fonts
local xlfont={
 width=10
}
for i=0,9 do
	xlfont[tostr(i)]=i
end

-- music tracks
-- TODO: assign correct ID
local extended_time_music=0
local best_lap_music=1
local gameover_music=2
local goal_music=3

-- voxel helpers
function to_tile_coords(v)
	local x,y=shr(v[1],3)+16,shr(v[3],3)+16
	-- slightly faster than flr
	return band(0xffff,x),band(0xffff,y),x,y
end

-- camera
function make_cam()
	-- views
	local switching_async
	-- 0: far
	-- 1: close
	-- 2: cockpit
	local view_mode=0
	-- view offset/angle/lag
	local view_pov={
		{z=-1.65,y=1.125,lag=0.2,znear=1,dist=2.1},
		{z=-0.7,y=0.3,lag=0.1,znear=0.25,dist=1},
		{z=-0.01,y=0.1,lag=0.6,znear=0.05,dist=2.1}
	}

	local current_pov=view_pov[view_mode+1]
	local pov_z,pov_y,pov_lag,max_dist=current_pov.z,current_pov.y,current_pov.lag,current_pov.dist
	z_near=current_pov.znear
	--
	local up={0,1,0}

	-- raycasting constants
	local angles={}
	for i=0,15 do
		add(angles,atan2(7.5,i-7.5))
	end

	-- screen shake
	local shkx,shky=0,0
	camera(-64,-64)
	
	return {
		pos={0,0,0},
		angle=0,
		shake=function(self,u,v,pow)
			shkx=min(4,shkx+pow*u)
			shky=min(4,shky+pow*v)
		end,
		update=function(self)
			if switching_async then
				switching_async=corun(switching_async)
			elseif btn(3) then
				local next_mode=(view_mode+1)%#view_pov
				local next_pov=view_pov[next_mode+1]
				local next_pov_z,next_pov_y,next_pov_lag,next_znear,next_dist=next_pov.z,next_pov.y,next_pov.lag,next_pov.znear,next_pov.dist
				switching_async=cocreate(function()
					for i=0,30 do
						local t=0.22
						pov_z=lerp(pov_z,next_pov_z,t)
						pov_y=lerp(pov_y,next_pov_y,t)
						pov_lag=lerp(pov_lag,next_pov_lag,t)
						z_near=lerp(z_near,next_znear,t)
						max_dist=lerp(max_dist,next_dist,t)
						yield()
					end
					-- commit change
					view_mode=next_mode
				end)
			end

			shkx*=-0.7-rnd(0.2)
			shky*=-0.7-rnd(0.2)
			if abs(shkx)<0.5 and abs(shky)<0.5 then
				shkx,shky=0,0
			end
			camera(shkx-64,shky-64)
		end,
		track=function(self,pos,a,u)
   			pos=v_clone(pos)
   			-- lerp angle
			self.angle=lerp(self.angle,a,pov_lag)
			-- lerp orientation
			up=v_lerp(up,u,pov_lag)
			v_normz(up)

			-- shift cam position			
			local m=make_m_from_v_angle(up,self.angle)
			pos=v_add(v_add(pos,m_fwd(m),pov_z),m_up(m),pov_y)
			
			-- inverse view matrix
			-- only invert orientation part
			m[2],m[5]=m[5],m[2]
			m[3],m[9]=m[9],m[3]
			m[7],m[10]=m[10],m[7]

			self.m=m_x_m(m,{
				1,0,0,0,
				0,1,0,0,
				0,0,1,0,
				-pos[1],-pos[2],-pos[3],1
			})
			
			self.pos=pos
		end,
		visible_tiles=function(self)
			local x0,y0,x,y=to_tile_coords(self.pos)
			local tiles,angle,max_dist={[x0+shl(y0,5)]=0},self.angle,flr(max_dist)
   
   			for i,a in pairs(angles) do
				local v,u=cos(a+angle),-sin(a+angle)
				
				local mapx,mapy,ddx,ddy,mapdx,mapdy,distx,disty=x0,y0,1/u,1/v,1,1
				if u<0 then
					mapdx=-1
					ddx=-ddx
					distx=(x-mapx)*ddx
				else
					distx=(mapx+1-x)*ddx
				end
				if v<0 then
					mapdy=-1
					ddy=-ddy
					disty=(y-mapy)*ddy
				else
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
						tiles[mapx+shl(mapy,5)]=dist
					end
				end				
			end	
			return tiles
	 end
	}
end

function make_skidmarks()
	local t,skidmarks=0,{}
	local width=0.01
	return {
		make_emitter=function()
			local emit_t,start_pos,oldf=0
			local current_right,current_skidmarks
			return function(pos,newf)
				-- broken skidmark?
				if emit_t!=t then
					start_pos,oldf,current_right,current_skidmarks=nil
				end
				if not start_pos then
					start_pos,oldf=v_clone(pos),newf
				end
				-- next expected update
				emit_t=t+1
				-- find face
				if emit_t%10==0 or oldf!=newf then
					local fwd=make_v(start_pos,pos)
					v_normz(fwd)
					current_right=v_cross(fwd,oldf.n)
					-- skidmarks corners
					oldf.skidmarks=oldf.skidmarks or {}
					current_skidmarks=add(oldf.skidmarks,add(skidmarks,{
						v_add(pos,current_right,-width),
						v_add(pos,current_right,width),
						v_add(pos,current_right,width),
						v_add(pos,current_right,-width),
						ttl=0,
						f=oldf}))
					start_pos,oldf=v_clone(pos),newf
				elseif current_right then
					current_skidmarks[1]=v_add(pos,current_right,width)
					current_skidmarks[2]=v_add(pos,current_right,-width)
				end 
			end
		end,
		update=function(self)
			t+=1
			for s in all(skidmarks) do
				s.ttl+=1
				if s.ttl>60 then
					del(skidmarks,s)
					del(s.f.skidmarks,s)
					-- clear empty tables
					if(#s.f.skidmarks==0) s.f.skidmarks=nil
				end
			end
		end
	}
end
local skidmarks=make_skidmarks()

-- "physic body" for simple car
function make_car(model,p,angle)
	-- last contact face
	local oldf

	local velocity,angularv={0,0,0},0
	local forces,torque={0,0,0},0

	local is_braking=false
	local max_rpm=0.6
	local steering_angle=0

	local total_r=0
	
	-- front wheels
	local front_emitters={
		lfw=skidmarks:make_emitter(),
		rfw=skidmarks:make_emitter()
	}
	-- rear wheels
	local rear_emitters={
		rrw=skidmarks:make_emitter(),
		lrw=skidmarks:make_emitter()
	}

	local full_slide,rear_slide
	local do_skidmarks=function(self,emitters)
		-- no 3d model?
		if(not model) return
		for k,emitter in pairs(emitters) do
			-- world position
			local vgroup_offset=model.vgroups[k].offset
			local ground_pos=v_add(m_x_v(self.m,vgroup_offset),self.pos)
			-- stick to ground
			v_add(ground_pos,oldf.n,-vgroup_offset[2])
			emitter(ground_pos,oldf)
		end
	end

	return {
		pos=v_clone(p),
		m=make_m_from_euler(0,a,0),
		get_pos=function(self)
	 		return self.pos,angle
		end,
		get_orient=function()
			return make_m_from_v_angle(oldf and oldf.n or v_up,angle)
		end,
		get_up=function()
			return oldf and oldf.n or v_up
		end,
		-- contact face
		get_ground=function()
			return oldf
		end,
		get_velocity=function() return velocity end,	
		apply_force_and_torque=function(self,f,t)
			-- add(debug_vectors,{f=f,p=p,c=11,scale=t})

			forces=v_add(forces,f)
			torque+=t
		end,
		prepare=function(self)
			-- update velocities
			velocity=v_add(velocity,forces,0.5/30)
			angularv+=torque*0.5/30

			-- apply some damping
			angularv*=0.86
			v_scale(velocity,0.97)
			-- some friction
			-- v_add(velocity,velocity,-0.02*v_dot(velocity,velocity))
		end,
		integrate=function(self)
		 	-- update pos & orientation
			self.pos=v_add(self.pos,velocity)
			-- fix
			angularv=mid(angularv,-1,1)
			angle+=angularv			
			self.m=make_m_from_euler(0,angle,0)

			-- reset
			forces,torque={0,0,0},0

			-- skidmarks
			if full_slide==true then
				do_skidmarks(self,front_emitters)
				do_skidmarks(self,rear_emitters)
			elseif rear_slide==true then
				do_skidmarks(self,rear_emitters)
			end
		end,
		get_speed=function(self)
			return 300*3.6*(v_dot(velocity,velocity)^0.5)
		end,
		steer=function(self,steering_dt,rpm)
			is_braking=rpm<0
			steering_angle+=mid(steering_dt,-0.15,0.15)

			-- longitudinal slip ratio
			local right=m_right(self.m)
			local sr=v_dot(right,velocity)
			full_slide=abs(sr)>0.12 

			-- max "grip"
			sr=mid(sr,-0.10,0.10)
			sr=1-abs(sr)/0.40
			steering_angle*=sr

			local fwd=m_fwd(self.m)
			local effective_rps=30*v_dot(fwd,velocity)/0.2638
			local rps=30*rpm*2
			if rps>10 then
				rpm*=lerp(0.9,1,effective_rps/rps)
			end

			v_scale(fwd,rpm*sr)			

			self:apply_force_and_torque(fwd,-steering_angle*lerp(0,0.25,rpm/max_rpm))

			-- rear wheels sliding?
			rear_slide=not full_slide and rps>10 and effective_rps/rps<0.6		

			return min(rpm,max_rpm)
		end,
		update_contacts=function(self,actors)
			local fwd=m_fwd(self.m)
			for _,offset in pairs({0.250,-0.250}) do
				local pos=v_add(self.pos,fwd,offset)
				local velocity=v_add(self:get_velocity(),v2_ortho({0,0,offset},angularv))
				for _,actor in pairs(actors) do
					if actor!=self then
						local axis=make_v(actor.pos,pos)
						-- todo: normz and check function?
						-- in range?
						local depth=v_len(axis)
						if depth<0.5 then
							local relv=make_v(actor.get_velocity(),velocity)	
							-- separating?
							local sep=v_dot(axis,relv)
							if sep<0 then							
								-- add(debug_vectors,{f=axis,p=pos,c=4,scale=(0.5-depth)/0.5})
								-- silly sacle - to fix
								v_scale(axis,5)
								-- silly torque - to fix
								self:apply_force_and_torque(axis,-2*depth*v2_cross({0,0,offset},axis))
							end
						end
					end
				end
			end
		end,
		update=function(self)
			steering_angle*=0.8

			-- find ground
			local pos=self.pos			
			local newf,newpos=find_face(pos,oldf)
			if newf then		
				pos[2]=newpos[2]
				oldf=newf
			end
			-- on ground: limit max speed
			max_rpm=0.6		
			if oldf and band(oldf.flags,0x4)==0 then
				max_rpm=0.4
			end
			-- above 0
			-- should never happen actually
			pos[2]=max(pos[2])

			-- collision
			if oldf and oldf.borders then
				local hit,force,hit_n=face_collide(oldf,pos,0.25)
				if hit then
					self.pos=v_add(pos,force)
					--simulate sliding contact (no impact on velocity) vs. direct hit (massive slowdown)
					local friction=v_dot(velocity,hit_n)
					-- non separating?
					if(friction<-0.01) v_scale(velocity,1+friction)
				end
			end
			-- update car parts (orientations)
			local fwd=m_fwd(self.m)
			total_r+=v_dot(fwd,velocity)/0.2638
			self:update_parts(total_r,steering_angle)
		end
	}	
end

function make_plyr(p,angle)
	local rpm=0
	local body=make_car(all_models["car"].lods[2],p,angle)
	
	-- backup parent methods
	local body_update=body.update

	sfx(0)
	
	body.model=all_models["car"]
	body.control=function(self)	
		local da=0
		if(btn(0)) da=1
		if(btn(1)) da=-1

		-- accelerate
		if btn(4) then
			rpm+=0.1
		end
		-- brake
		if btn(5) then
			rpm=0
		end

		rpm=self:steer(da/8,rpm)
	end
	
	body.update=function(self)
		body_update(self)
		rpm*=0.97

		local vol=self:get_speed()/400
		local rpmvol=band(0x3f,flr(32*vol))
		-- sfx 0
		local addr=0x3200+68*0
		-- adjust pitch
		poke(addr,bor(band(peek(addr),0xc0),rpmvol))
		-- base engine
		rpmvol=max(8,rpmvol-8)
		addr+=2
		poke(addr,bor(band(peek(addr),0xc0),rpmvol))

		-- rough terrain?
		local ground=self:get_ground()		
		if ground and band(ground.flags,0x4)==0 then
			local shake_force=self:get_speed()/200
			cam:shake(rnd(shake_force),rnd(shake_force),1)
		end
	end
	body.update_parts=function(self,total_r,steering_angle)
		local wheel_m=make_m_from_euler(total_r,0,0)
		self.rrw=wheel_m
		self.lrw=wheel_m
		wheel_m=make_m_from_euler(total_r,-steering_angle/8,0)
		self.lfw=wheel_m
		self.rfw=wheel_m
		self.sw=m_from_q(make_q({0,0.2144,-0.9767},-steering_angle/2))
	end
	-- wrapper
	return body
end

function make_track(segments,checkpoint)
	local n=#segments
	-- active index
	checkpoint=checkpoint or 0
	local function to_v(i)
		return segments[i+1]
	end
	return {	
		-- returns next location
		get_next=function(self,offset)
			offset=offset or 0
			return to_v(checkpoint+offset)
		end,
		update=function(self,pos,dist)
			local p=to_v(checkpoint)
			if v_len(make_v(pos,p))<dist then
				checkpoint+=1
				checkpoint%=n
			end
			return to_v(checkpoint)
		end
	}
end

function make_npc(p,angle,track)	
	local body=make_car(nil,p,angle)

	-- return world position p in local space (2d)
	function inv_apply(self,target)
		p=make_v(self.pos,target)
		local x,y,z,m=p[1],p[2],p[3],self.m
		return {m[1]*x+m[2]*y+m[3]*z,0,m[7]*x+m[8]*y+m[9]*z}
	end

	-- todo: switch to npc car model
	body.model=all_models["car_ai"]

	body.control=function(self)
		-- lookahead
		local fwd=m_fwd(self.m)
		-- force application point
		local p=v_add(self.pos,fwd,3)
		
		local rpm=0.6
		-- default: steer to track
		local target=inv_apply(self,track:update(p,24))
		local target_angle=atan2(target[1],target[3])

		-- avoid collisions
		--[[
		local velocity=self.get_velocity()
		for _,actor in pairs(actors) do
			if actor!=self then
				local axis=make_v(actor.pos,self.pos)
				-- todo: normz and check function?
				-- in range?
				if v_len(axis)<16 then
					local axis_bck=v_clone(axis)
					v_normz(axis)
					local relv=make_v(actor.get_velocity(),velocity)					
					-- separating?
					local sep=v_dot(axis,relv)
					if sep<0 then
						
						local local_pos=inv_apply(self,actor.pos)
						-- in front?
						-- in path?
						if local_pos[3]>0 and abs(local_pos[1])<2 then							
							local x=local_pos[1]
							local escape_axis=v2_ortho(axis,1)
							local_pos[1]+=1/v_dot(relv,escape_axis)
							target_angle=atan2(local_pos[1],local_pos[3])
							rpm/=2
							break
						end
					end
				end
			end
		end
		]]

		-- shortest angle
		if(target_angle<0.5) target_angle=1-target_angle
		target_angle=0.75-target_angle
		rpm=self:steer(target_angle,rpm)

	end
	body.update_parts=function(self,total_r,steering_angle)
		local wheel_m=make_m_from_euler(total_r,0,0)
		self.rw=wheel_m
		self.fw=wheel_m
	end
	-- wrapper
	return body
end

function is_inside(p,f)
	local v=track.v
	local p0=v[f[f.ni]]
	for i=1,f.ni do
		local p1=v[f[i]]
		if((p0[3]-p1[3])*(p[1]-p0[1])+(p1[1]-p0[1])*(p[3]-p0[3])<0) return
		p0=p1
	end
	-- intersection point
	local t=-v_dot(make_v(v[f[1]],p),f.n)/f.n[2]
	p=v_clone(p)
	p[2]+=t
	return f,p
end

function find_face(p,oldf)	
	-- same face as previous hit
	if oldf then
		local newf,newp=is_inside(p,oldf)
		if(newf) return newf,newp
	end
	-- voxel?
	local x,z=flr(shr(p[1],3)+16),flr(shr(p[3],3)+16)
	local faces=track.ground[x+shl(z,5)]
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
-- reports hit result + correcting force + border normal
function face_collide(f,p,r)
	local force,hit,n={0,0,0}
	for _,b in pairs(f.borders) do
		local pv=make_v(b.v,p)
		local dist=v_dot(pv,b.n)
		if dist<r then
			hit,n=true,b.n
			force=v_add(force,b.n,r-dist)
		end
	end
	return hit,force,n
end

-- game states
-- transition to next state
function next_state(state,...)
	draw_state,update_state=state(...)
end

function start_state()
	-- reset arrays & counters
	time_t=0

	-- start over
	actors,npcs={},{}

	-- create player in correct direction
	plyr=add(actors,make_plyr(track.start_pos,0))

	-- reset cam	
	cam=make_cam()

	-- npcs
	for i=0,3 do
		local npc_track=make_track(track.npc_path,i)
		local p=v_clone(npc_track:get_next())
		add(actors,add(npcs, make_npc(p,0,npc_track)))
	end

	local ttl=90 -- 3*30

	return 
		-- draw
		function()
			local sx=flr(ttl/30)*12
			printxl(sx,32,12,16,-14)

			-- todo: allow acceleration during "go"
			-- todo: boost if acceleration is at frame 15
		end,
		-- update
		function()
			if(ttl%30==0) sfx(2)
			ttl-=1
			if(ttl<0) sfx(3) next_state(play_state)
		end
end


function play_state()
	-- active index
	local checkpoint,segments=0,track.checkpoints
	local n=#segments/3
	-- active index
	local checkpoint=0
	local function to_v(i)
		return {segments[3*i+1],0,segments[3*i+2]},segments[3*i+3]
	end

	-- previous laps
	local laps={}

	-- remaining time before game over (+ some buffer time)
	local lap_t,total_t,remaining_t,best_t,best_i=0,0,30*65,32000,1
	local extend_time_t=0

	-- go display
	local go_ttl=30

	local function track_project(v,pos,cc,ss)
		local x,y=v[1]-pos[1],v[3]-pos[3]
		return 44+0.3*(cc*x-ss*y),-0.3*(ss*x+cc*y)
	end
		
	return
		-- draw
		function()
			printb("lap time",26,-62,7,0)
			printb("time",nil,-62,7,0)
			printf(tostr(ceil(remaining_t/30)),nil,-55,xlfont)
			
			-- speed
			printf(tostr(flr(plyr:get_speed())),-33,50,xlfont)
			printr("km/h",-32,57,10,9)

			-- blink go!
			if(go_ttl>0 and go_ttl%4<2) printxl(0,48,36,16,-14)

			-- extend time message
			if(extend_time_t>0 and extend_time_t%30<15) printr("extend time",nil,-36,10,4)
			
			-- previous times
			local y=-55
			for i=1,#laps do
				printb(i,26,y,9,0)
				printb(laps[i],34,y,best_i==i and 9 or 7,0)
				y+=7
			end
			printb(#laps+1,26,y,9,0)
			printb(time_tostr(lap_t),34,y,7,0)
			
			-- track map
			local pos,angle=plyr:get_pos()
			local cc,ss,track_outline=cos(angle),-sin(angle),track.npc_path
			-- draw npc path
			local x0,y0=track_project(track_outline[#track_outline],pos,cc,ss)
			color(0)
			for i=1,#track_outline do
				local x1,y1=track_project(track_outline[i],pos,cc,ss)
				line(x0,y0,x1,y1)
				x0,y0=x1,y1
			end
			-- draw other cars
			for _,npc in pairs(npcs) do
				local x0,y0=track_project(npc:get_pos(),pos,cc,ss)
				circfill(x0,y0,1.5,0x99)
			end
			-- player
			circfill(44,0,1,0x88)
		end,
		-- update
		function()
			total_t+=1
			remaining_t-=1
			go_ttl-=1
			extend_time_t-=1
			if remaining_t==0 then
				next_state(gameover_state,false,total_t)
				return
			end
			lap_t+=1
			local p,r=to_v(checkpoint)
			if v_len(make_v({plyr.pos[1],0,plyr.pos[3]},p))<r then
				checkpoint+=1
				remaining_t+=30*10
				extend_time_t=30*5

				-- time extension!
				music(extended_time_music)
				-- placeholder
				sfx(4)
				
				-- closed lap?
				if checkpoint%n==0 then
					checkpoint=0
					-- record time
					add(laps,time_tostr(lap_t))
					if lap_t<best_t then
						best_t=lap_t
						best_i=#laps

						-- best lap music
						music(best_lap_music)
					end
					-- done?
					if #laps==3 then
						next_state(goal_state,true,total_t)
					end
					-- next lap
					lap_t=0
				end
			end

			cam:update()
			plyr:control()	
		end
end

function gameover_state(win,total_t)
	local ttl=900
	local angle=-0.5

	music(gameover_music)

	return 
		-- draw
		function()
			-- rotating game over/goal
			if win then 
				print3d(32,0,65,16,-14,angle)
			else
				print3d(39,32,57,32,-14,angle)
			end

			-- total time
			printb(time_tostr(total_t).." total time",nil,72,9,0)

			-- 
			if(ttl%32<16) printb("❎ select track",34,120,9,0) printr("🅾️ start over",37,110,10,4) 
		end,
		-- update
		function()
			ttl-=1
			angle+=0.01
			if btnp(4) or ttl<0 then
				next_state(start_state)
			elseif btnp(5) then
				-- back to selection title
				load("title.p8")
			end
		end
end

function _init()
	-- integrated fillp/color
	poke(0x5f34,1)

	-- track name (from params)
	local track_id=stat(6)
	if track_id=="" then
		-- starting without context
		cls(1)
		-- bigforest
		track_id=0
	end
	
	-- load regular 3d models
	unpack_models()

	-- track data
	track=unpack_track(track_id)

	-- restore
	reload()

	-- init state machine
	next_state(start_state)
end

function _update()
	-- basic state mgt
	update_state()

	plyr:update_contacts(npcs)
	plyr:prepare()
	plyr:integrate()	
	plyr:update()

	for _,npc in pairs(npcs) do
		npc:control()
		npc:prepare()
		npc:integrate()	
		npc:update()
	end

	if plyr then
		-- cam:track(npcs[1]:get_pos())
		local pos,a=plyr:get_pos()
		cam:track(pos,a,plyr:get_up())
	end

	skidmarks:update()
end

-- vertex cache class
-- uses m (matrix) and v (vertices) from self
-- saves the 'if not ...' in inner loop
local v_cache_cls={
	__index=function(t,k)
		if(not k) return
		-- inline: local a=m_x_v(t.m,t.v[k]) 
		local v,m=t.v[k],t.m
		local x,y,z=v[1],v[2],v[3]
		local ax,ay,az=m[1]*x+m[5]*y+m[9]*z+m[13],m[2]*x+m[6]*y+m[10]*z+m[14],m[3]*x+m[7]*y+m[11]*z+m[15]
	
		local outcode=k_near
		if(az>z_near) outcode=k_far
		if(ax>az) outcode+=k_right
		if(-ax>az) outcode+=k_left
		
		-- assume vertex is visible, compute 2d coords
		local a={ax,ay,az,outcode=outcode,clipcode=band(outcode,2),x=shl(ax/az,6),y=-shl(ay/az,6)} 
		t[k]=a
		return a
	end
}

function collect_faces(faces,cam_pos,v_cache,out)
	local sessionid=sessionid
	for _,face in pairs(faces) do
		-- avoid overdraw for shared faces
		if face.session!=sessionid and (band(face.flags,1)>0 or v_dot(face.n,cam_pos)>face.cp) then
			-- project vertices
			local v0,v1,v2,v3=v_cache[face[1]],v_cache[face[2]],v_cache[face[3]],v_cache[face[4]]			
			-- mix of near/far verts?
			if band(v0.outcode,band(v1.outcode,band(v2.outcode,v3 and v3.outcode or 0xffff)))==0 then
				local verts={v0,v1,v2,v3}

				local ni,is_clipped,y,z=9,v0.clipcode+v1.clipcode+v2.clipcode,v0[2]+v1[2]+v2[2],v0[3]+v1[3]+v2[3]
				if v3 then
					is_clipped+=v3.clipcode
					y+=v3[2]
					z+=v3[3]
					ni=16
				end
				-- mix of near+far vertices?
				if(is_clipped>0) verts=z_poly_clip(z_near,verts)
				if #verts>2 then
					verts.f=face
					verts.key=ni/(y*y+z*z)
					out[#out+1]=verts
				end
			end
			face.session=sessionid	
		end
	end
end

function collect_model_faces(model,m,parts,out)
	-- all models reuses the same faces!!
	-- artificially bump the session
	sessionid+=1
	
	-- cam pos in object space
	local cam_pos=m_inv_x_v(m,cam.pos)
	
	-- select lod
	local d=v_dot(cam_pos,cam_pos)
	
	-- lod selection
	local lodid=0
	for i=1,#model.lod_dist do
		if(d>model.lod_dist[i]) lodid+=1
	end
	-- cap to max lod if too far away
	model=model.lods[min(lodid,#model.lods-1)+1]

	-- object to world
	-- world to cam
	m=m_x_m(cam.m,m)

	-- vertex cache (and model context)
	local p=setmetatable({m=m,v=model.v},v_cache_cls)

	-- main model
	collect_faces(model.f,cam_pos,p,out)
	-- sub models
	local m_orig,m_base=m_clone(m),m_clone(m) 
	
	for name,vgroup in pairs(model.vgroups) do
		
		-- lookup vertex group orientation from parts
		local vgm=parts[name]
		-- cam to vgroup space
		-- note: cam_pos is already in object space
		local vg_cam_pos=m_inv_x_v(vgm,make_v(vgroup.offset,cam_pos))

		-- full vertex group vertex to cam transformation
		m_set_pos(m_base,m_x_v(m_orig,vgroup.offset))
		-- use the same vertex cache
		p.m=m_x_m(m_base,vgm)

		collect_faces(vgroup.f,vg_cam_pos,p,out)
	end
end

-- draw face
-- handles clipping as needed
function draw_face(v0,v1,v2,v3,col)
	if band(v0.outcode,band(v1.outcode,band(v2.outcode,v3 and v3.outcode or 0xffff)))==0 then
		local verts={v0,v1,v2,v3}
		if(v0.clipcode+v1.clipcode+v2.clipcode+(v3 and v3.clipcode or 0)>0) verts=z_poly_clip(z_near,verts)
		if(#verts>2) polyfill(verts,col)
	end
end

function draw_faces(faces,v_cache)
	for i=1,#faces do
		local d=faces[i]
		local main_face=d.f
		polyfill(d,main_face.c)
		-- details?
		if d.key>0.0200 then
			-- face details
			if main_face.inner then -- d.dist<2 then
				-- reuse array
				for _,face in pairs(main_face.inner) do
					draw_face(v_cache[face[1]],v_cache[face[2]],v_cache[face[3]],v_cache[face[4]],face.c)
				end
			end
			-- face skidmarks
			if main_face.skidmarks then
				local m=v_cache.m
				for _,skids in pairs(main_face.skidmarks) do
					local s_cache=setmetatable({m=v_cache.m,v=skids},v_cache_cls)
					draw_face(s_cache[1],s_cache[2],s_cache[3],s_cache[4],0)
				end
			end
		end
	end
end

function _draw()
	sessionid+=1

	-- background
	rectfill(-64,-64,64,63,track.sky_color)
	rectfill(-64,0,63,63,track.ground_color)
	local x0=-shl(cam.angle,7)%128
 	map(track.map,0,x0-64,-64,16,16)
 	if x0>0 then
	 	map(track.map,0,x0-192,-64,16,16)
 	end

	-- track
	local v_cache=setmetatable({m=cam.m,v=track.v},v_cache_cls)

	local out,tiles,cam_pos={},cam:visible_tiles(),cam.pos
	
	for k,dist in pairs(tiles) do
		local faces=track.voxels[k]
		if faces then
			collect_faces(faces,cam_pos,v_cache,out)
		end 
	end

	sort(out)

	draw_faces(out,v_cache)
	
	-- clear vertex 
	out={}

	for _,actor in pairs(actors) do
		local pos,angle=actor:get_pos()
		-- is model visible?
		-- (e.g. voxel tile is visible)
		local x0,y0=to_tile_coords(pos)
		if tiles[x0+shl(y0,5)] then
			local m=actor:get_orient()
			m_set_pos(m,pos)
			-- car
			collect_model_faces(actor.model,m,actor,out)
		end
	end
	
	sort(out)
	
	draw_faces(out)

	-- hud and game state display
	draw_state()
	
	local y=-64

	print(stat(1).."\n"..stat(0).."b",-62,y+2,0)

	-- dark green
	pal(14,128,1)
	-- dark blue
	pal(15,131,1)
end

-->8
-- unpack data & models
local cart_id,mem
local cart_progress=0
function mpeek()
	if mem==0x4300 then
		cart_progress=0
		cart_id+=1
		reload(0,0,0x4300,"tracks_"..cart_id..".p8")
		mem=0
	end
	local v=peek(mem)
	if mem%779==0 then
		cart_progress+=1
		rectfill(0,120,shl(cart_progress,4),127,cart_id%2==0 and 1 or 7)
		flip()
	end
	mem+=1
	return v
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
	local n=unpack_variant()
	for i=1,n do
		fn(i)
	end
end
-- unpack a vector
function unpack_v(scale)
	return {unpack_double(scale),unpack_double(scale),unpack_double(scale)}
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

function unpack_face()
	local f={flags=unpack_int(),c=unpack_int(),session=0xffff}
	if(f.c==0x50) f.c=0x0150
	f.c+=0x1000.a5a5

	f.ni=band(f.flags,2)>0 and 4 or 3
	-- vertex indices
	-- quad?
	for i=1,f.ni do
		-- using the face itself saves more than 500KB!
		f[i]=unpack_variant()
	end
	return f
end

function unpack_model(model,scale)
	-- vertices
	local v=model.v
	unpack_array(function()
		add(v,unpack_v(scale))
	end)

	-- faces
	unpack_array(function()
		local f=unpack_face()
		-- inner faces?
		if band(f.flags,8)>0 then
			f.inner={}
			unpack_array(function()
				add(f.inner,unpack_face())
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
				local v1=(v0+1)%f.ni
				-- get border vectors
				v0,v1=model.v[f[v0+1]],model.v[f[v1+1]]
				-- make a 2d plane vector
				local bn=make_v(v1,v0)
				bn[2]=0
				v_normz(bn)
				add(f.borders,{v=v0,n={bn[3],0,-bn[1]}})
			end
		end
		-- normal
		f.n=v_cross(make_v(v[f[1]],v[f[f.ni]]),make_v(v[f[1]],v[f[2]]))
		v_normz(f.n)
		-- viz check
		f.cp=v_dot(f.n,model.v[f[1]])

		add(model.f,f)
	end)
end
function unpack_models()
	-- cars are in first data cart
	reload(0,0,0x4300,"tracks_0.p8")
	cart_id,mem=0,0
	-- for all models
	unpack_array(function()
		local model,name,scale={lods={},lod_dist={}},unpack_string(),1/unpack_int()
		scale=1/32
		unpack_array(function()
			local d=unpack_double()
			assert(d<127,"lod distance too large:"..d)
			-- store square distance
			add(model.lod_dist,d*d)
		end)
  
		-- level of details models
		unpack_array(function()
			local lod={v={},f={},vgroups={}}
			unpack_model(lod,scale)
			-- unpack vertex groups (as sub model)
			unpack_array(function()				
				local name=unpack_string()
				local vgroup={offset=unpack_v(scale),f={}}
				-- faces
				unpack_array(function()
					local f=unpack_face()
					-- normal
					f.n=unpack_v()
					-- viz check
					f.cp=v_dot(f.n,lod.v[f[1]])

					add(vgroup.f,f)
				end)				
				lod.vgroups[name]=vgroup
			end)
		
			add(model.lods,lod)
		end)

		-- index by name
		all_models[name]=model
	end)
end

-- unpack multi-cart track
function unpack_track(id)
	-- assume we are not at cart boundary!!
	mem+=id*3
	-- read track offsets
	cart_id,mem=unpack_int(),unpack_int(2)

	reload(0,0,0x4300,"tracks_"..cart_id..".p8")

	local id,colors=unpack_int(),unpack_int()
	local ground_color,sky_color=band(0xf,colors),shr(band(0xf0,colors),4)
	local model={
		id=id,
		map=16*id,
		-- convert to fillp-compatible color
		ground_color=ground_color+16*ground_color,
		sky_color=sky_color+16*sky_color,
		v={},
		f={},
		n={},
		cp={},
		voxels={},
		ground={},
		start_pos=unpack_v(),
		checkpoints={},
		npc_path={}}
	-- checkpoints
	unpack_array(function()
		-- coords
		add(model.checkpoints,unpack_double())
		add(model.checkpoints,unpack_double())
		-- radius
		add(model.checkpoints,unpack_double())
	end)

	-- npc path
	unpack_array(function()
		add(model.npc_path,{unpack_double(),0,unpack_double()})
	end)
	
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
	return model	
end

-->8
-- edge rasterizer
function polyfill(p,col)
	color(col)
	local p0,nodes=p[#p],{}
	-- band vs. flr: -0.20%
	local x0,y0=p0.x,p0.y

	for i=1,#p do
		local p1=p[i]
		local x1,y1=p1.x,p1.y
		-- backup before any swap
		local _x1,_y1=x1,y1
		if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
		-- exact slope
		local dx=(x1-x0)/(y1-y0)
		if(y0<-64) x0-=(y0+64)*dx y0=-64
		-- subpixel shifting (after clipping)
		local cy0=ceil(y0)
		x0+=(cy0-y0)*dx
		for y=cy0,min(ceil(y1)-1,63) do
			local x=nodes[y]
			if x then
				rectfill(x,y,x0,y)
			else
				nodes[y]=x0
			end
			x0+=dx
		end
		-- next vertex
		x0,y0=_x1,_y1
	end
end

-->8
-- clipping
function z_poly_clip(znear,v)
	local res,v0={},v[#v]
	local d0=v0[3]-znear
	for i=1,#v do
		local v1=v[i]
		local d1=v1[3]-znear
		if d1>0 then
			if d0<=0 then
				local nv=v_lerp(v0,v1,d0/(d0-d1)) 
				nv.x=shl(nv[1]/nv[3],6)
				nv.y=-shl(nv[2]/nv[3],6) 
				res[#res+1]=nv
			end
			res[#res+1]=v1
		elseif d0>0 then
			local nv=v_lerp(v0,v1,d0/(d0-d1)) 
			nv.x=shl(nv[1]/nv[3],6)
			nv.y=-shl(nv[2]/nv[3],6) 
			res[#res+1]=nv
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
	x=x or -shl(#s,1)
	?s,x,y+1,c2 or 1
	?s,x,y,c1
end

-- raised print
function printr(s,x,y,c,c2)
	x=x or -shl(#s,1)
	local sy=c2 and -2 or -1
	for i=-1,1 do
        for j=sy,1 do
            print(s,x+i,y+j,0)
        end
    end
	if(c2) print(s,x,y,c2) y-=1
    print(s,x,y,c)
end


-- print string s from bitmap font
function printf(s,x,y,font)
	palt(14,true)
	palt(0,false)
	local w=font.width
	if x then
		-- left aligned
		x-=#s*w
	else
		-- centered
		x=-shr(#s*w,1)
	end
	for i=1,#s do
		local sx=font[sub(s,i,i)]*w
		sspr(sx,64,w,13,x,y)		
		x+=w
	end
	
	palt()
	return x
end

-- big font
function printxl(sx,sy,sw,sh,dy)
	palt(14,true)
	palt(0,false)

 sspr(sx,sy,sw,sh,-sw/2,dy)
 palt()	
end

-- print sprite sx/sy at y on screen
-- x centered
-- perspective correct rotation by angle
function print3d(sx,sy,sw,sh,y,angle)
	local cc,ss=cos(angle),-sin(angle)
	local z0,z1=2+cc,2-cc
	-- projection
 	local y0,y1,w0,w1=-sh*ss/z0,sh*ss/z1,sw/z0,sw/z1
 	if(y0>y1)y0,y1,w0,w1=y1,y0,w1,w0
 	local len=y1-y0
	-- perspective correct mapping
	palt(14,true)
	palt(0,false)
 	local u,du,dw=0,sh*w1/len,(w1-w0)/len
 	for y=y+y0,y+y1-0.5 do
 		sspr(sx,sy+u/w0,sw,1,-w0,y,2*w0,1)
  		u+=du
  		w0+=dw
 	end
	palt()
end

--[[
local odraw,oupdate,omake_plyr=_draw,_update,make_plyr
local _cpu,_ttl,_bench=0,2*30,10*30
function make_plyr(_,angle)
	-- fix position
	local p=omake_plyr({-23.7,1.25,-9.80},angle)
	local rpm=0
	p.control=function(self)	
		rpm=rpm+0.1
		rpm=self:steer(0,rpm)
	end
	return p
end

function _update()
	_bench-=1
	if(_bench<0) extcmd("video") stop()
	oupdate()
end
function _draw()
	camera(-64,-64)
	odraw()
	local cpu=stat(1)
	camera()

	rectfill(0,121,127,127,0x11)
	_cpu=max(_cpu,cpu)
	-- refresh max every 5s
	_ttl-=1
	if(_ttl<0) _cpu=cpu _ttl=2*30
	
	local s=tostr(flr(1000*_cpu)/10)
	s="2020: "..s..sub("00.00",#s+1,5).."%"
	print(s,66,122,7)
end
]]

__gfx__
00000000cccccccccccccccccccccccceeeee00000ee0eeeeeeee00000eeeeeeeeeeeee0eeeeeeee000000eeeeeeee00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000cccccc7777cccccccccccccceeee0888880080eeeee008888800eeeeeeeeee080eeeeee08888880eeeeee0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000ccccc7777777cccccccccccceee08800008880eeee08800000880eeeeeeee0880eeeeeee008800eeeeeee0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000cccc777777777cccccccccccee0800eeee0880eee0880eeeee0880eeeeeee08880eeeeeee0880eeeeeeee0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000cc777777777777cccccccccce0880eeeeee080eee0880eeeee0880eeeeee080880eeeeeee0880eeeeeeee0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000c7777777777777cccccccccce080eeeeeeee0eee0880eeeeeee0880eeeee0800880eeeeee0880eeeeeeee0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000c77777777777777ccccccccc0880eeeee000000e0880eeeeeee0880eeeee0800880eeeeee0880eeeeeeee0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
000000007777777777777777cccccccc0880eeee088888800880eeeeeee0880eeee080e0880eeeeee0880eeeeeeee080eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
cccccccc77777777cccccccc000000000880eeeee008800e0880eeeeeee0880eeee080000880eeeee0880eeeeeeee080eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
cccccccc77777777cccccccc000000000880eeeeee0880ee0880eeeeeee0880eee0888888880eeeee0880eeeeeeee080eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
cccccccc7777777777777777000000000880eeeeee0880ee0880eeeeeee0880eee0800000880eeeee0880eeeeee0e080eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
cccccccc777777777777777700000000e0880eeeee0880eee0880eeeee0880eee080eeeee0880eeee0880eeeee080e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
c6c6c6c6777777777777777777770000e08880eeee0880eee0880eeeee0880eee080eeeee0880eeee0880eeee0880e00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
6c6c6c6c777777777777777777777700ee088800008880eeee08800000880eee0880eeeee08880ee008800000880e0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
66666666777777777777777777777770eee0088888800eeeeee008888800eee088880eee08888800888888888880e0880eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
77777777777777777777777777777777eeeee000000eeeeeeeeee00000eeeeee0000eeeee00000ee00000000000eee00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
111111111111111133333333cccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeedddddddd33333333cccccccc
c1c1c1c1ffffffff33333333cccccc33eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4949494933333333cccccc43
11111111f3f3f3f333333333ccccc333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeea4a4a4a433333333cccc4434
111111113f3f3f3f33333333cccc3333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebbbbbbbb33333333ccc44443
111c111c3333333333333333cc333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc33333333cc434434
111111113333333333333333c3333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebcbcbcbc33333333cc444343
111111113333333333333333c3333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc33333333c4343433
11111c11333333333333333333333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccc3333333343433333
1111111111111111c1c1c1c1cccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee33ffffffcccccccccccccccc
11c11111111111111c1c1c1c3bcccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffcccccccc77777777
1c1c111111111111c1c1c1c133bbcccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffffffffffcccff66666666
11111111111111111c1c1c1c3bbbbccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7a7a7a7a7aaaaaaacccccccc
1111111111111111c1c1c1c133bb3bcceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7777777777aaaaa7cccccccc
11111111111111111c1c1c1c3333bbcceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1c1c1c1c1c1c1c1ccccccccc
11111c1111111111c1c1c1c1333333bceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeec1c1c1c1c1c1c1c1cccccccc
1111c1c1111111111c1c1c1c3333333beeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1c1c1c1c1c1c1c1ccccccccc
eeeee00eeeeeeeee0000eeeeeeee0000eeeeeeeeeeee0000eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000
eee00770eeeeeee077770eeeeee077770eeeeeeeeee0777700070eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000
ee077770eeeeee07777770eeee07007770eeeeeeee07700007770eeeee000000eeeeee00ee00e0000eeeeeee00000eee00000000000000000000000000000000
ee000770eeeee0770007770ee070ee0770eeeeeee0700eeee0770eeee07777770eeee0770077077770eeeee0777770ee00000000000000000000000000000000
eeee0770eeeee070eee0770eee0eee0770eeeeee0770eeeeee070eee0700007770ee077777777007770eee070007770e00000000000000000000000000000000
eeee0770eeeeee0eeee0770eeeeee0070eeeeeee070eeeeeeee0eee0770eee0770eee077000770e0770ee070eee0770e00000000000000000000000000000000
eeee0770eeeeeeeeeee0770eeeee07700eeeeee0770eeeee000000e0770eee0770eee0770e0770e0770e07700000777000000000000000000000000000000000
eeee0770eeeeeeeeeee070eeeee0777770eeeee0770eeee07777770e00e0007770eee0770e0770e0770e07777777777000000000000000000000000000000000
eeee0770eeeeeeeeee070eeeeeee007770eeeee0770eeeee007700eee007770770eee0770e0770e0770e07700000000e00000000000000000000000000000000
eeee0770eeeeeeeeee070eeeeeeeee07770eeee0770eeeeee0770eee0777000770eee0770e0770e0770e0770eeeeee0e00000000000000000000000000000000
eeee0770eeeeeeeee070eeeeeeeeeee0770eeee0770eeeeee0770ee07700ee0770eee0770e0770e0770e0770eeeee07000000000000000000000000000000000
eeee0770eeeeeeee070eee0eeeeeeee0770eeeee0770eeeee0770ee0770eee0770eee0770e0770e0770e07770eeee07000000000000000000000000000000000
eeee0770eeeeeee070000070ee00eee070eeeeee07770eeee0770ee0770eee07700ee0770e0770e0770ee0777000070e00000000000000000000000000000000
eee007700eeeee0777777770e077000770eeeeeee077700007770ee0777000707070e0770e0770e0770eee077777770e00000000000000000000000000000000
ee07777770eee0777777770ee07777700eeeeeeeee0077777700eeee0777770e770e0777707770077770eee0777700ee00000000000000000000000000000000
ee00000000eee000000000eeee00000eeeeeeeeeeeee000000eeeeeee00000ee00ee000000000ee0000eeeee0000eeee00000000000000000000000000000000
eeeee0000eee0eeeeeeee00000eeeeeee00eeeeeeeee00000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00e00000000000000000000000000000000
eeee0777700070eeeee007777700eeee0770eeeeee007777700eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee077000000000000000000000000000000000
eee07700007770eeee07700000770eee0770eeeee07700000770eee00000eee0000eeeee00000eeeeee00ee000ee077000000000000000000000000000000000
ee0700eeee0770eee0770eeeee0770ee0770eeee0770eeeee0770e0777770e077770eee0777770eee0077007770e077000000000000000000000000000000000
e0770eeeeee070eee0770eeeee0770ee0770eeee0770eeeee0770ee07770eee0700eee070007770e07777770770e077000000000000000000000000000000000
e070eeeeeeee0eee0770eeeeeee0770e0770eee0770eeeeeee0770ee0770eee070eee070eee0770ee007700e00ee077000000000000000000000000000000000
0770eeeee000000e0770eeeeeee0770e0770eee0770eeeeeee0770ee0770eee070ee077000007770ee0770eeeeee077000000000000000000000000000000000
0770eeee077777700770eeeeeee0770e070eeee0770eeeeeee0770eee0770e070eee077777777770ee0770eeeeee070e00000000000000000000000000000000
0770eeeee007700e0770eeeeeee0770e070eeee0770eeeeeee0770eee0770e070eee07700000000eee0770eeeeee070e00000000000000000000000000000000
0770eeeeee0770ee0770eeeeeee0770e070eeee0770eeeeeee0770eee0770070eeee0770eeeeee0eee0770eeeeee070e00000000000000000000000000000000
0770eeeeee0770ee0770eeeeeee0770e070eeee0770eeeeeee0770eeee077070eeee0770eeeee070ee0770eeeeee070e00000000000000000000000000000000
e0770eeeee0770eee0770eeeee0770eee0eeeeee0770eeeee0770eeeee077070eeee07770eeee070ee0770eeeeeee0ee00000000000000000000000000000000
e07770eeee0770eee0770eeeee0770eee00eeeee0770eeeee0770eeeeee0770eeeeee0777000070eee0770eeeeeee00e00000000000000000000000000000000
ee077700007770eeee07700000770eee0770eeeee07700000770eeeeeee0770eeeeeee077777770ee007700eeeee077000000000000000000000000000000000
eee0077777700eeeeee007777700eeee0770eeeeee007777700eeeeeeee0770eeeeeeee0777700ee07777770eeee077000000000000000000000000000000000
eeeee000000eeeeeeeeee00000eeeeeee00eeeeeeeee00000eeeeeeeeeee00eeeeeeeeee0000eeee00000000eeeee00e00000000000000000000000000000000
ee000000eeeee0000eeeee000000eeee000000eeeeeee000000000000000ee000000ee0000000000ee000000eeee000000ee0000000000000000000000000000
e0aaaaaa0eee0aa90eeee0aaaaaa0ee0aaaaaa0eeeee0aaa900aaaaaaa90e0aaaaaa0e0aaaaaaa90e0aaaaaa0ee0aaaaaa0e0000000000000000000000000000
0a99999a90e0aaa90eee0a99999a900a99999a90eee0aaaa900a999999900a99999a900a99999a900a99999a900a99999a900000000000000000000000000000
0a90000a90e0aaa90eee0a90000a900a90000a90ee0aa99a900a900000000a900009900a90000a900a90000a900a90000a900000000000000000000000000000
0a90ee0a90e099a90eee0990e0aa900990ee0a90e0aa900a900a900000ee0a9000000e0990e0aa900a90ee0a900a90ee0a900000000000000000000000000000
0a90ee0a90e000a90eeee0000aa90ee000000a900aa90e0a900aaaaaa90e0aaaaaa90e000e0aa90e0a90000a900a90000a900000000000000000000000000000
0a90ee0a90eee0a90eeeeee0aa90eeeee0aaa90e0a90ee0a900999999a900a99999a90eee0aa90eee0aaaaa90e09aaaaaa900000000000000000000000000000
0a90ee0a90eee0a90eeeee0aa90eeee000999a900a90000a90e000000a900a90000a90eee0a90eee0a99999a90e099999a900000000000000000000000000000
0a90ee0a90eee0a90eeee0aa90eeee0a90000a900aaaaaaa900a90ee0a900a90ee0a90eee0a90eee0a90000a90e000000a900000000000000000000000000000
0a90000a90e000a9000e0aa00000000a90000a900999999a900a90000a900a90000a90eee0a90eee0a90000a900a90000a900000000000000000000000000000
09aaaaa990e0aaaaa90e0aaaaaaa9009aaaaa9900000000a9009aaaaa99009aaaaa990eee0a90eee09aaaaa99009aaaaaa900000000000000000000000000000
e09999990ee09999990e0999999990e09999990eeeeeee0990e09999990ee09999990eeee0990eeee09999990ee09999990e0000000000000000000000000000
ee000000eee00000000e0000000000ee000000eeeeeeee0000ee000000eeee000000eeeee0000eeeee000000eeee000000ee0000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001020111110200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111111111111102010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111111111111110200000000010000000000000000000000000000000000002f3300000000000000002f2233000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111020102011110101010101010101010101010101010002f2e2e33000023330000232e2e2e330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21212121212121212121212121212121323232323232323232323232323232323f2d2d2d2d3f3f2d2d3f3f2d2d2d2d2d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010002201501b750131500415004150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010002281301d720211301c250231501c2501b2500d1501f2500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002b05033000220002800000000000002200000000000000000000000000000000023000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900002d0502d0502d0502d0502d05029400233000f400000000940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000025050300503005025050000002e00031000000003a00030000000002e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
