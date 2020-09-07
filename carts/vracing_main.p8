pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- virtua racing
-- ▤@freds72 ♪@rubyred ♪@mavica

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
	return pack(unpack(v))
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
	return d*sqrt(x*x+y*y+z*z)
end
function v_normz(v)
	local x,y,z=v[1],v[2],v[3]
	local d=x*x+y*y+z*z
	if d>0.001 then
		d=sqrt(d)
		return {x/d,y/d,z/d}
	end
	return v
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
	return {-scale*a[3],0,scale*a[1]}
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
	local x,y,z,w=unpack(q)
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
	local a11,a21,a31,_,a12,a22,a32,_,a13,a23,a33,_,a14,a24,a34=unpack(a)
	local b11,b21,b31,_,b12,b22,b32,_,b13,b23,b33,_,b14,b24,b34=unpack(b)

	return {
			a11*b11+a12*b21+a13*b31,a21*b11+a22*b21+a23*b31,a31*b11+a32*b21+a33*b31,0,
			a11*b12+a12*b22+a13*b32,a21*b12+a22*b22+a23*b32,a31*b12+a32*b22+a33*b32,0,
			a11*b13+a12*b23+a13*b33,a21*b13+a22*b23+a23*b33,a31*b13+a32*b23+a33*b33,0,
			a11*b14+a12*b24+a13*b34+a14,a21*b14+a22*b24+a23*b34+a24,a31*b14+a32*b24+a33*b34+a34,1
		}
end
function m_clone(m)
	return pack(unpack(m))
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
	local right=v_normz(v_cross(up,fwd))
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

-- sort
-- https://github.com/morgan3d/misc/tree/master/p8sort
-- 
function sort(data)
	local n = #data 
	if(n<2) return
	
	-- form a max heap
	for i = n\2+1, 1, -1 do
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
local z_near,dfar=1,1

-- fonts
local xlfont={
 width=10
}
for i=0,9 do
	xlfont[tostr(i)]=i
end

-- music tracks
local start_music=0
local extended_time_music=8
-- same music
local best_lap_music=8
local goal_music=9
local gameover_music=10

-- voxel helpers
function to_tile_coords(v)
	local x,y=(v[1]>>3)+16,(v[3]>>3)+16
	-- slightly faster than flr
	return x\1,y\1,x,y
end

-- camera
function make_cam()
	-- pov switching future
	local switching_async

	-- 0: far
	-- 1: close
	-- 2: cockpit
	local view_mode,is_locked=0
	-- view offset/angle/lag
	local view_pov={
		{z=-1.65,y=1.125,lag=0.2,znear=1,dist=2.1},
		{z=-0.7,y=0.3,lag=0.1,znear=0.25,dist=1},
		{z=-0.03,y=0.12,lag=0.6,znear=0.05,dist=2.1}
	}

	local current_pov=view_pov[view_mode+1]
	local pov_z,pov_y,pov_lag,max_dist=current_pov.z,current_pov.y,current_pov.lag,current_pov.dist
	-- set current znear
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
		get_pov=function() return view_mode end,
		shake=function(self,u,v,pow)
			shkx=min(4,shkx+pow*u)
			shky=min(4,shky+pow*v)
		end,
		lock_pov=function(self,lock) is_locked=lock end,
		switch_pov=function(self,next_mode)
			-- nothing to do?
			if(next_mode==view_mode) return
			local next_pov=view_pov[next_mode+1]
			local next_pov_z,next_pov_y,next_pov_lag,next_znear,next_dist=next_pov.z,next_pov.y,next_pov.lag,next_pov.znear,next_pov.dist
			switching_async=cocreate(function()
				for i=0,30 do
					-- todo: token optimize!
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
		end,
		update=function(self)
			if switching_async then
				switching_async=corun(switching_async)
			elseif btn(3) and not is_locked then
				self:switch_pov((view_mode+1)%#view_pov)
			end

			-- screen shake
			shkx*=-0.7-rnd(0.2)
			shky*=-0.7-rnd(0.2)
			if abs(shkx)<0.5 and abs(shky)<0.5 then
				shkx,shky=0,0
			end
			camera(shkx-64,shky-64)
		end,
		track=function(self,pos,a,u)
   			-- lerp angle
			self.angle=lerp(self.angle,a,pov_lag)
			-- lerp orientation
			up=v_normz(v_lerp(up,u,pov_lag))

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
			local tiles,angle,max_dist,dfar={[x0|y0<<5]=0},self.angle,max_dist\1,dfar
   
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

				for dist=0,dfar do
					if distx<disty then
						distx+=ddx
						mapx+=mapdx
					else
						disty+=ddy
						mapy+=mapdy
					end
					-- non solid visible tiles
					if (mapx|mapy)&0xffe0==0 then
						tiles[mapx|mapy<<5]=dist
					end
				end				
			end	
			return tiles
	 end
	}
end

-- skidmarks factory
function make_skidmarks()
	local t,skidmarks,width=0,{},0.01
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
					local fwd=v_normz(make_v(start_pos,pos))
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
function make_car(model_name,lod_id,p,angle,track)
	-- last contact face
	local oldf

	local velocity,angularv={0,0,0},0
	local forces,torque={0,0,0},0

	local max_rpm,steering_angle,total_r=0.6,0,0

	-- model for skidmarks (if any)
	local model=lod_id and all_models[model_name].lods[lod_id]

	-- front + rear wheels + slide flags
	local front_emitters,rear_emitters,front_slide,rear_slide={
		lfw=skidmarks:make_emitter(),
		rfw=skidmarks:make_emitter()},{
		rrw=skidmarks:make_emitter(),
		lrw=skidmarks:make_emitter()}

	local do_skidmarks=function(self,emitters)
		-- no 3d model?
		if(not model) return
		if(not oldf) return
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
		-- 3d model reference
		model=all_models[model_name],
		track=track,
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
			angularv*=0.8
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
			if(front_slide==true) do_skidmarks(self,front_emitters)
			if(rear_slide==true) do_skidmarks(self,rear_emitters)
		end,
		get_speed=function(self)
			return 250*3.6*v_len(velocity)
		end,
		steer=function(self,steering_dt,rpm,braking,npc)
			if npc then
				steering_angle=mid(steering_dt,-0.15,0.15)
			else
				steering_angle=mid(steering_angle+steering_dt,-0.15,0.15)
			end
			-- slip angle (front tire grip)			
			-- slipping?
			local steer={cos(angle-steering_angle),0,sin(angle-steering_angle)}
			local sa=v_dot(steer,velocity)
			front_slide=abs(sa)>0.22
			-- map to 0-1
			sa=1-min(abs(sa),0.2)/0.8

			local right,fwd=m_right(self.m),m_fwd(self.m)

			-- slip ratio (overall car grip)

			-- kill lateral velocity (less rally)			
			local drag=v_dot(fwd,velocity)
			drag=lerp(0.003,0.008,drag*drag/0.12)
			local sr=mid(v_dot(right,velocity),-drag,drag)
			if drag>0.001 then
				velocity=v_add(velocity,right,-sr)
			end
			
			local effective_rps=30*v_dot(fwd,velocity)/0.2638
			local rps=30*rpm*2
			if rps>10 then
				-- scale forward force according to grip ratio
				rpm*=lerp(0.63,1,effective_rps/rps)
			end

			if braking then
				-- todo: take into account sr
				-- npc are braking a bit harder
				v_scale(velocity,npc and 0.92 or 0.95)
			end
			v_scale(fwd,rpm)			
			self:apply_force_and_torque(fwd,-0.72*sa*steering_angle)

			-- rear wheels sliding?
			rear_slide=not full_slide and rps>10 and effective_rps/rps<0.6

			return min(rpm,max_rpm)
		end,
		update_contacts=function(self,actors)
			local fwd=m_fwd(self.m)
			local pos=self.pos
			for _,actor in pairs(actors) do
				if actor!=self and v_len(make_v(pos,actor.pos))<2 then
					local actorv=actor:get_velocity()
					-- 2 colliders
					for _,offset in pairs({0.250,-0.250}) do
						-- position and absolute velocity
						local axis=make_v(actor.pos,v_add(pos,fwd,offset))
						-- todo: normz and check function?
						-- in range?
						local depth=v_len(axis)
						if depth<0.312 then
							local relv=make_v(actor.get_velocity(),v_add(self:get_velocity(),v2_ortho({0,0,offset},angularv)))	
							-- separating?
							if v_dot(axis,relv)<0 then							
								-- add(debug_vectors,{f=axis,p=pos,c=4,scale=(0.5-depth)/0.5})
								-- silly scale - to fix
								v_scale(axis,5)
								-- silly torque - to fix
								self:apply_force_and_torque(axis,-2*depth*v2_cross({0,0,offset},axis))
								-- hit sound
								sfx(53)
							end
						end
					end
					-- assumes only 1 actor in range
					break
				end
			end
		end,
		update=function(self)
			-- back to neutral
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
			if oldf and oldf.flags&0x4==0 then
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

			-- update track coordinates
			track:update(self.pos)

			-- update car parts (orientations)
			local fwd=m_fwd(self.m)
			total_r+=v_dot(fwd,velocity)/0.2638
			self:update_parts(total_r,steering_angle,front_slide or rear_slide)
		end,
		angle_to=function(self,tgt)
			local a=(atan2(tgt[1]-self.pos[1],tgt[3]-self.pos[3])-angle)%1
			if(a<0.5) a=1-a
			return a
		end
	}	
end

function make_plyr(p,angle,track)
	local rpm,body=0,make_car("car",2,p,angle,track)
	
	-- backup parent methods
	local body_update=body.update

	-- start engine sfx
	sfx(48)
	
	body.control=function(self)	
		local da=0
		if(btn(0)) da=1
		if(btn(1)) da=-1

		-- accelerate
		if btn(4) then
			rpm+=0.1
		end
		-- brake (sort of)
		if btn(5) then
			rpm=0
		end

		rpm=self:steer(da/32,rpm)
	end
	
	body.update=function(self)
		body_update(self)
		rpm*=0.97

		local vol=self:get_speed()/400
		local rpmvol=flr(32*vol)&0x3f
		-- sfx 0
		local addr=0x3200+68*48
		-- adjust pitch
		poke(addr,bor(peek(addr)&0xc0,rpmvol))
		-- base engine
		rpmvol=max(8,rpmvol-2)
		addr+=2
		poke(addr,bor(peek(addr)&0xc0,rpmvol))
		-- ensure engine sound is playing
		local fix_engine=true
		for i=16,19 do
			if(stat(i)==0) fix_engine=nil break
		end
		if(fix_engine) sfx(48)

		-- rough terrain?
		local ground=self:get_ground()		
		if ground and ground.flags&0x4==0 then
			local shake_force=self:get_speed()/200
			cam:shake(rnd(shake_force),rnd(shake_force),1)
			-- random noise (avoid noise if not rolling)
			if(shake_force>0.2) sfx(55+flr(rnd(2)))
		end
	end
	body.update_parts=function(self,total_r,steering_angle,sliding)
		local wheel_m=make_m_from_euler(total_r,0,0)
		self.rrw=wheel_m
		self.lrw=wheel_m
		wheel_m=make_m_from_euler(total_r,-steering_angle/8,0)
		self.lfw=wheel_m
		self.rfw=wheel_m
		self.sw=m_from_q(make_q({0,0.2144,-0.9767},-steering_angle/2))
		-- tire screetch!
		if(sliding) sfx(49)
	end
	-- wrapper
	return body
end

-- track segments
function make_track(segments,segment)
	-- segments layout:
	-- normal/left/right/len(left)/len(right)
	local n=#segments/5
	-- active index
	segment=segment or 0
	-- track local coordinates
	-- track_u: absolute distance on track
	-- track_v: left/right position ratio 
	local track_u,track_v=segment,0

	local function to_v(i)
		i=i%n
		return segments[5*i+1],segments[5*i+2],segments[5*i+3]
	end
	-- starting quad
	local n0,l0,r0=to_v(segment)
	local n1,l1,r1=to_v(segment+1)

	local function next()
		segment+=1
		n0,l0,r0=n1,l1,r1
		n1,l1,r1=to_v(segment+1)	
		-- 'flat segment'
		if (abs(v_dot(make_v(l0,l1),n0))<0.001 or abs(v_dot(make_v(l0,r1),n0))<0.001) next()
	end
	local function prev()
		-- going backward!!
		segment-=1
		n1,l1,r1=n0,l0,r0
		n0,l0,r0=to_v(segment)
		-- 'flat segment'
		if (abs(v_dot(make_v(l0,l1),n0))<0.001 or abs(v_dot(make_v(l0,r1),n0))<0.001) prev()
	end

	local function get_d(pos)
		local d0=v_dot(make_v(pos,l0),n0)
		return d0/(d0-v_dot(make_v(pos,l1),n1))
	end

	return {	
		-- have we past given segment index
		gt=function(self,laps,i)
			return track_u>laps*n+i
		end,
		-- returns location after segment
		-- 0: current segment
		-- +1: next boundary
		get_next=function(self,offset)
			offset=offset or 0
			return to_v(segment+offset)
		end,
		-- side lengths
		get_length=function(self,offset)
			local i=(segment+offset)%n
			return segments[5*i+4],segments[5*i+5]
		end,
		update=function(self,pos)
			-- have we past end of current segment?
			local d=get_d(pos)
			if d>1 then
				next()
			elseif d<0 then
				prev()
			end
			-- refresh d
			d=get_d(pos)
			track_u=segment+(d%1)

			-- left/right local position
			local ll,rr=v_lerp(l0,l1,d),v_lerp(r0,r1,d)
			local v=make_v(ll,rr)
			track_v=v_dot(v,make_v(ll,pos))/v_dot(v,v)
		end,
		-- mod: modulo or not
		get_u=function(self,mod)
			return mod and track_u%n or track_u
		end,
		get_v=function()
			return track_v
		end,
		-- debug
		get_segment=function()
			return segment
		end
	}
end

function make_pid(p,i,d)
	local i_err,prev_err
	p,i,d=p or 2,i or 1,d or 0.5
	return function(cur,tgt,dt)
		local err=tgt-cur
		--if(err>0.5) err=0.5-err
		--err=0.5-err
		-- fresh?
		prev_err=prev_err or err
		i_err=(1-dt)*(i_err or err)+dt*err
		local d_err=(err-prev_err)/dt
		prev_err=err
		return p*err+i*i_err+d*d_err
	end
end	

function make_npc(p,angle,track)	
	local body,pid=make_car("car_ai",nil,p,angle,track),make_pid()
	local rpm=0.6

	-- return world position p in local space (2d)
	local function inv_apply(self,target)
		local p=make_v(self.pos,target)
		local x,y,z,m=p[1],p[2],p[3],self.m
		return {m[1]*x+m[2]*y+m[3]*z,0,m[7]*x+m[8]*y+m[9]*z}
	end

	body.control=function(self)
		local lookahead,curve,tgt=1,0
		while lookahead<5 do
			local n1,l1,r1=track:get_next(lookahead)
			local n2,l2,r2=track:get_next(lookahead+1)
			local len1,len2=track:get_length(lookahead)

			-- accumulate "curvature"
			curve+=abs(1-len1/len2)
			-- find track target point based on curvature		
			tgt=v_lerp(l2,r2,mid(0.5*len1/len2,0.2,0.8))
			
			-- line of sight intersects track?
			local v=v_normz(make_v(self.pos,tgt))
			local t=v2_cross(make_v(self.pos,l1),v)/v2_cross(make_v(r1,l1),v)
			if t>0.8 or t<0.2 then
				break
			end
			lookahead+=1
		end
		
		-- default: steer to track
		local target_angle=pid(0,0.75-self:angle_to(tgt),1/30)

		rpm=self:steer(target_angle,0.7,abs(target_angle)>0.12,true)
	end
	body.update_parts=function(self,total_r,steering_angle)
		local wheel_m=make_m_from_euler(total_r,0,0)
		self.rw=wheel_m
		self.fw=wheel_m
	end
	local body_update=body.update
	body.update=function(self)
		body_update(self)
		rpm*=0.97
	end

	-- wrapper
	return body
end

function is_inside(p,f)
	local p0=f[f.ni]
	for i=1,f.ni do
		local p1=f[i]
		if((p0[3]-p1[3])*(p[1]-p0[1])+(p1[1]-p0[1])*(p[3]-p0[3])<0) return
		p0=p1
	end
	-- intersection point
	local t=-v_dot(make_v(f[1],p),f.n)/f.n[2]
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
	local x,z=((p[1]>>3)+16)\1,((p[3]>>3)+16)\1
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

function play_state(checkpoints,cam_checkpoints)

	--***********
	-- start over
	actors,npcs={},{}

	-- reset player
	plyr=add(actors,make_plyr(track.start_pos,0,make_track(track.segments)))

	-- init npc's
	for i=0,6 do
		local npc_track=make_track(track.segments,8*i)
		local _,l,r=npc_track:get_next()
		l=v_add(l,r)
		v_scale(l,0.5)
		local npc=add(actors,add(npcs, make_npc(l,0,npc_track)))
		-- some color variety!
		local mem=52+shl(i%4,6)
		npc.colors={
			[0x1033.a5a5]=bor(0x1000.a5a5,peek(mem)),
			[0x10bb.a5a5]=bor(0x1000.a5a5,peek(mem+1))}
		npc.spr=37+(i%4)
	end

	-- reset cam	
	cam=make_cam()
	
	-- active index
	local checkpoint,n=0,#checkpoints

	-- previous laps
	local laps={}

	-- remaining time before game over (+ some buffer time)
	local lap_t,total_t,remaining_t,best_t,best_i=0,0,30*75,32000,1
	local extend_time_t=0

	-- go display
	local start_ttl,go_ttl=90,120

	local function track_project(v,pos,cc,ss)
		local x,y=v[1]-pos[1],v[3]-pos[3]
		return 44+0.3*(cc*x-ss*y),-0.3*(ss*x+cc*y)
	end
	
	local cam_checkpoint,cam_pov=0

	local prev_rank,ranks=1,{"st","nd","rd"}
	return
		-- draw
		function()
			printb("lap time",31,-62,7,0)
			printb("time",nil,-62,7,0)
			printf(tostr(ceil(remaining_t/30)),nil,-55,xlfont)
			
			-- speed
			printf(tostr(plyr:get_speed()\1),-33,50,xlfont)
			printr("km/h",-32,57,10,9)

			-- 1/2/3...
			if start_ttl>0 then
				local sx=flr(start_ttl/30)*12
				printxl(sx,32,12,16,-14)
			end

			-- blink go!
			if(go_ttl>0 and go_ttl<30 and go_ttl%4<2) printxl(0,48,36,16,-14)

			-- extend time message
			if(extend_time_t>0 and extend_time_t%30<15) printr("extend time",nil,-36,10,4)
			
			-- previous times
			local y=-55
			for i=1,#laps do
				printb(i,23,y,9,0)
				printb(laps[i],31,y,best_i==i and 9 or 7,0)
				y+=7
			end
			printb(#laps+1,23,y,9,0)
			printb(time_tostr(lap_t),31,y,7,0)
			
			-- ranking
			local rank,plyr_u=#npcs+1,plyr.track:get_u()
			for _,npc in pairs(npcs) do
				if plyr_u>npc.track:get_u() then
					rank-=1
				end
			end
			-- assume overtake!
			if prev_rank!=rank then
				sfx(54)
			end
			-- last rank
			prev_rank=rank
			printb("rank",-62,-62,7,0)
			local x0=printf(tostr(rank),-52,-55,xlfont)
			printr(ranks[rank] or "th",x0,-53,10,9)

			-- track map
			local pos,angle=plyr:get_pos()
			local cc,ss,track_outline=cos(angle),-sin(angle),track.segments
			-- draw npc path
			local x0,y0=track_project(track_outline[#track_outline-3],pos,cc,ss)
			color(0)
			for i=1,#track_outline,10 do
				local x1,y1=track_project(track_outline[i+1],pos,cc,ss)
				line(x0,y0,x1,y1)
				x0,y0=x1,y1
			end
			palt(14,true)
			palt(0,false)
			-- draw other cars
			for i,npc in pairs(npcs) do
				local x0,y0=track_project(npc.pos,pos,cc,ss)
				spr(npc.spr,x0-2,y0-2)
			end
			-- player
			-- circfill(44,0,1,0x88)
			spr(53,40,-4)
			palt()
		end,
		-- update
		function()
			go_ttl-=1
			extend_time_t-=1

			if start_ttl>0 then
				start_ttl-=1
				if start_ttl==0 then 
					sfx(51) 
					music(start_music,250,0b1110)
				elseif start_ttl%30==0 then
					sfx(50)
				end
			else
				total_t+=1
				remaining_t-=1
				lap_t+=1
			end

			if remaining_t==0 then
				next_state(gameover_state,false,total_t,prev_rank)
				return
			end

			-- auto_switch pov at some location (only for ocean)
			if cam_checkpoints then
				if plyr.track:gt(#laps,cam_checkpoints[cam_checkpoint+1]) then
					if cam_checkpoint==0 then
						-- backup current pov
						cam_pov=cam:get_pov()
						
						-- high pov?
						if(cam_pov==0) cam:switch_pov(1)
						cam:lock_pov(true)
					else
						cam:lock_pov()
						cam:switch_pov(cam_pov)
					end
					cam_checkpoint+=1
				end
			end

			if plyr.track:gt(#laps,checkpoints[checkpoint+1]) then
				checkpoint+=1
				remaining_t+=30*10
				extend_time_t=30*5

				-- time extension!
				-- avoid playing time extend music if start music is still playing
				if(stat(24)==-1) music(extended_time_music,0,0b1110)

				-- closed lap?
				if checkpoint==n then
					checkpoint,cam_checkpoint=0,0
					-- record time
					add(laps,time_tostr(lap_t))
					if lap_t<best_t then
						best_t=lap_t
						best_i=#laps

						-- best lap music
						music(best_lap_music,0,0b1110)
					end
					-- done?
					if #laps==3 then
						next_state(gameover_state,true,total_t,prev_rank)
					end
					-- next lap
					lap_t=0
				end
			end

			cam:update()
			if(start_ttl==0) plyr:control()	
		end
end

function gameover_state(win,total_t,rank)
	local ttl,angle,prev_best_t=900,-0.5,dget(track.id)	
	--  or record?
	local is_record=win and (total_t<prev_best_t or prev_best_t==0)
	if is_record then
		-- save new record
		dset(track.id,total_t)
	end
	-- record initial button state (avoid auto-skip screen)
	local last_btn,btn_press=btn(4),0

	music(win and goal_music or gameover_music,0,0b1111)

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
			printr(time_tostr(total_t).." total time",nil,8,9)
			if(is_record) printr("track record!",nil,17,8,2)

			-- 
			if ttl%32<16 then
				printr("❎ select track",nil,57,9,4)
			else			
				printr("🅾️ try again",nil,57,10,9)
			end
		end,
		-- update
		function()
			ttl-=1
			angle+=0.01

			if btn(4)!=last_btn then
				btn_press+=1
				last_btn=btn(4)
			end

			if btn_press>1 or ttl<0 then
				next_state(play_state,track.checkpoints,track.cam_checkpoints)
			elseif btnp(5) then
				-- back to selection title
				load("vracing_title.p8")
			end
		end
end

function high_draw_dist()
	dfar=2	
	menuitem(2, "draw dist: high",low_draw_dist)
end
function low_draw_dist()
	dfar=1	
	menuitem(2, "draw dist: low",high_draw_dist)
end

function _init()
	cartdata("freds72_vracing")
	menuitem(1, "reset records", function() for i=0,3 do dset(i,0) end end)
	-- set draw distance menu to high (yeah!)
	high_draw_dist()

	-- integrated fillp/color
	poke(0x5f34,1)

	-- dark green
	pal(14,128,1)
	-- dark blue
	pal(15,131,1)

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
	track=unpack_track(tonum(track_id))

	-- restore
	reload()

	-- init state machine
	next_state(play_state,track.checkpoints,track.cam_checkpoints)
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

	local pos,a=plyr:get_pos()
	cam:track(pos,a,plyr:get_up())

	skidmarks:update()
end

-- vertex cache class
-- uses m (matrix) and v (vertices) from self
-- saves the 'if not ...' in inner loop
local v_cache_cls={
	-- v is vertex reference
	__index=function(t,v)
		-- inline: local a=m_x_v(t.m,t.v[k]) 
		local m,x,y,z=t.m,v[1],v[2],v[3]
		local ax,ay,az=m[1]*x+m[5]*y+m[9]*z+m[13],m[2]*x+m[6]*y+m[10]*z+m[14],m[3]*x+m[7]*y+m[11]*z+m[15]
	
		local outcode=k_near
		if(az>z_near) outcode=k_far
		if(ax>az) outcode+=k_right
		if(-ax>az) outcode+=k_left

		-- not faster :/
		-- local bo=-(((az-z_near)>>31)<<17)-(((az-ax)>>31)<<18)-(((az+ax)>>31)<<19)
		-- assert(bo==outcode,"outcode:"..outcode.." bits:"..bo)

		-- assume vertex is visible, compute 2d coords
		local a={ax,ay,az,outcode=outcode,clipcode=outcode&2,x=(ax/az)<<6,y=-(ay/az)<<6} 
		t[v]=a
		return a
	end
}

function collect_faces(faces,cam_pos,v_cache,out,colors)
	local sessionid=sessionid
	for _,face in pairs(faces) do
		-- avoid overdraw for shared faces
		if face.session!=sessionid and (face.flags&0x1==0x1 or v_dot(face.n,cam_pos)>face.cp) then
			-- project vertices
			local v4=face[4]
			local v0,v1,v2,v3=v_cache[face[1]],v_cache[face[2]],v_cache[face[3]],v4 and v_cache[v4]			
			-- mix of near/far verts?
			if v0.outcode&v1.outcode&v2.outcode&(v3 and v3.outcode or 0xffff)==0 then
				local verts={v0,v1,v2,v3}

				local ni,is_clipped,y,z=9,v0.clipcode+v1.clipcode+v2.clipcode,v0[2]+v1[2]+v2[2],v0[3]+v1[3]+v2[3]
				if v3 then
					is_clipped+=v3.clipcode
					y+=v3[2]
					z+=v3[3]
					-- number of faces^2
					ni=16
				end
				-- mix of near+far vertices?
				if(is_clipped>0) verts=z_poly_clip(z_near,verts)
				if #verts>2 then
					verts.f=face
					-- color replace
					verts.c=colors and colors[face.c] or face.c
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
	local p=setmetatable({m=m},v_cache_cls)

	-- main model
	collect_faces(model.f,cam_pos,p,out,parts.colors)
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
	if v0.outcode&v1.outcode&v2.outcode&(v3 and v3.outcode or 0xffff)==0 then
		local verts={v0,v1,v2,v3}
		if(v0.clipcode+v1.clipcode+v2.clipcode+(v3 and v3.clipcode or 0)>0) verts=z_poly_clip(z_near,verts)
		if(#verts>2) polyfill(verts,col)
	end
end

function draw_faces(faces,v_cache)
	for i,d in ipairs(faces) do
		local main_face=d.f
		polyfill(d,d.c)
		-- details?
		if d.key>0.0200 then
			-- face details
			if main_face.inner then -- d.dist<2 then
				-- reuse array
				for _,face in pairs(main_face.inner) do
					local v4=face[4]
					draw_face(v_cache[face[1]],v_cache[face[2]],v_cache[face[3]],v4 and v_cache[v4],face.c)
				end
			end
			-- face skidmarks
			if main_face.skidmarks then
				local m=v_cache.m
				for _,skids in pairs(main_face.skidmarks) do
					local s_cache=setmetatable({m=m},v_cache_cls)
					draw_face(s_cache[skids[1]],s_cache[skids[2]],s_cache[skids[4]],s_cache[skids[3]],0x1150.a5a5)
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
	local v_cache=setmetatable({m=cam.m},v_cache_cls)

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
		local dist=tiles[x0|y0<<5]
		if dist and dist<2 then
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

	-- print(stat(1),-62,32+2,0)
end

-->8
-- unpack data & models
local cart_id,mem
local cart_progress=0
function mpeek()
	if mem==0x4300 then
		cart_progress=0
		cart_id+=1
		reload(0,0,0x4300,"vracing_"..cart_id..".p8")
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

function unpack_face(verts)
	local f={flags=unpack_int(),c=unpack_int(),session=0xffff}
	-- shadows
	if(f.c==0x50) f.c=0x0150
	f.c+=0x1000.a5a5

	f.ni=band(f.flags,2)>0 and 4 or 3
	-- vertex indices
	-- quad?
	-- using the face itself saves more than 500KB!
	for i=1,f.ni do
		-- direct reference to vertex
		f[i]=verts[unpack_variant()]
	end
	return f
end

function unpack_model(model,scale)
	-- vertices
	local verts={}
	unpack_array(function()
		add(verts,unpack_v(scale))
	end)

	-- faces
	unpack_array(function()
		local f=unpack_face(verts)
		-- inner faces?
		if band(f.flags,8)>0 then
			f.inner={}
			unpack_array(function()
				add(f.inner,unpack_face(verts))
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
				v0,v1=f[v0+1],f[v1+1]
				-- make a 2d plane vector
				local bn=make_v(v1,v0)
				bn[2]=0
				bn=v_normz(bn)
				add(f.borders,{v=v0,n={bn[3],0,-bn[1]}})
			end
		end
		-- normal
		f.n=v_normz(v_cross(make_v(f[1],f[f.ni]),make_v(f[1],f[2])))
		-- viz check
		f.cp=v_dot(f.n,f[1])

		add(model.f,f)
	end)
	return verts
end
function unpack_models()
	-- cars are in first data cart
	reload(0,0,0x4300,"vracing_0.p8")
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
			local lod={f={},vgroups={}}
			local verts=unpack_model(lod,scale)
			-- unpack vertex groups (as sub model)
			unpack_array(function()				
				local name=unpack_string()
				local vgroup={offset=unpack_v(scale),f={}}
				-- faces
				unpack_array(function()
					local f=unpack_face(verts)
					-- normal
					f.n=unpack_v()
					-- viz check
					f.cp=v_dot(f.n,f[1])

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
function unpack_track(track_id)
	-- assumes we are not at cart boundary!!
	mem+=track_id*3
	-- read start cart id + in-cart memory offset
	cart_id,mem=unpack_int(),unpack_int(2)

	-- jump to cart
	reload(0,0,0x4300,"vracing_"..cart_id..".p8")

	local id,colors=unpack_int(),unpack_int()
	local ground_color,sky_color=band(0xf,colors),shr(band(0xf0,colors),4)
	local model={
		id=id,
		map=16*id,
		-- convert to fillp-compatible color
		ground_color=bor(ground_color,16*ground_color),
		sky_color=bor(sky_color,16*sky_color),
		f={},
		n={},
		cp={},
		voxels={},
		ground={},
		start_pos=unpack_v(),
		checkpoints={},
		segments={},
		-- hardcoded cam checkpoints for ocean
		cam_checkpoints=track_id==2 and {27,41,512}}

	-- vertices + faces + normal data
	local verts=unpack_model(model)

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

	-- track segments
	local tmp={}
	unpack_array(function()
		local l,r=verts[unpack_variant()],verts[unpack_variant()]
		-- left
		add(tmp,l)
		-- right
		add(tmp,r)
	end)
	local segments=model.segments
	for i=0,#tmp-1,2 do
		local l0,r0=tmp[i+1],tmp[i+2]
		-- normal
		add(segments,v_normz(v2_ortho(make_v(l0,r0),1)))
		add(segments,l0)
		add(segments,r0)
		-- to avoid costly length compute at runtime
		local l1,r1=tmp[(i+2)%#tmp+1],tmp[(i+3)%#tmp+1]
		add(segments,v_len(make_v(l0,l1)))
		add(segments,v_len(make_v(r0,r1)))
	end
	-- checkpoints
	unpack_array(function()
		-- segment index
		add(model.checkpoints,unpack_variant())
	end)

	return model	
end

-->8
-- edge rasterizer
function polyfill(p,col)
	color(col)
	local p0,nodes=p[#p],{}
	local x0,y0=p0.x,p0.y

	for i=1,#p do
		local p1=p[i]
		local x1,y1=p1.x,p1.y
		-- backup before any swap
		local _x1,_y1=x1,y1
		if(y0>y1) x1=x0 y1=y0 x0=_x1 y0=_y1
		-- exact slope
		local dx=(x1-x0)/(y1-y0)
		if(y0<-64) x0-=(y0+64)*dx y0=-65
		-- subpixel shifting (after clipping)
		local cy0=y0\1+1
		x0+=(cy0-y0)*dx
		for y=cy0,min(y1\1,63) do
			local x=nodes[y]
			if x then
				rectfill(x,y,x0,y)
			else
				nodes[y]=x0
			end
			x0+=dx
		end
		-- next vertex
		x0=_x1
		y0=_y1
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
				nv.x=(nv[1]/nv[3])<<6
				nv.y=-(nv[2]/nv[3])<<6 
				res[#res+1]=nv
			end
			res[#res+1]=v1
		elseif d0>0 then
			local nv=v_lerp(v0,v1,d0/(d0-d1)) 
			nv.x=(nv[1]/nv[3])<<6
			nv.y=-(nv[2]/nv[3])<<6 
			res[#res+1]=nv
		end
		v0=v1
		d0=d1
	end
	return res
end

-->8
-- print helpers
function padding(n)
	n=tostr(min(n,99)\1)
	return sub("00",1,2-#n)..n
end

-- frames per sec to human time
function time_tostr(t)
	-- note: assume minutes doesn't go > 9
	return (t\1800).."'"..padding((t\30)%60).."''"..padding(flr(10*t/3)%100)
end

function printb(s,x,y,c1,c2)
	x=x or -(#s<<1)
	?s,x,y+1,c2 or 1
	?s,x,y,c1
end

-- raised print
function printr(s,x,y,c,c2)
	x=x or -(#s<<1)
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

__gfx__
00000000cccccccccccccccccccccccceeeee00000ee0eeeeeeee00000eeeeeeeeeeeee0eeeeeeee000000eeeeeeee00eeeeeeee33bb00000000000000000000
00000000cccccc7777cccccccccccccceeee0888880080eeeee008888800eeeeeeeeee080eeeeee08888880eeeeee0880eeeeeee228800000000000000000000
00000000ccccc7777777cccccccccccceee08800008880eeee08800000880eeeeeeee0880eeeeeee008800eeeeeee0880eeeeeee99aa00000000000000000000
00000000cccc777777777cccccccccccee0800eeee0880eee0880eeeee0880eeeeeee08880eeeeeee0880eeeeeeee0880eeeeeee11cc00000000000000000000
00000000cc777777777777cccccccccce0880eeeeee080eee0880eeeee0880eeeeee080880eeeeeee0880eeeeeeee0880eeeeeee000000000000000000000000
00000000c7777777777777cccccccccce080eeeeeeee0eee0880eeeeeee0880eeeee0800880eeeeee0880eeeeeeee0880eeeeeee000000000000000000000000
00000000c77777777777777ccccccccc0880eeeee000000e0880eeeeeee0880eeeee0800880eeeeee0880eeeeeeee0880eeeeeee000000000000000000000000
000000007777777777777777cccccccc0880eeee088888800880eeeeeee0880eeee080e0880eeeeee0880eeeeeeee080eeeeeeee000000000000000000000000
cccccccc77777777cccccccc000000000880eeeee008800e0880eeeeeee0880eeee080000880eeeee0880eeeeeeee080eeeeeeee000000000000000000000000
cccccccc77777777cccccccc000000000880eeeeee0880ee0880eeeeeee0880eee0888888880eeeee0880eeeeeeee080eeeeeeee000000000000000000000000
cccccccc7777777777777777000000000880eeeeee0880ee0880eeeeeee0880eee0800000880eeeee0880eeeeee0e080eeeeeeee000000000000000000000000
cccccccc777777777777777700000000e0880eeeee0880eee0880eeeee0880eee080eeeee0880eeee0880eeeee080e0eeeeeeeee000000000000000000000000
c6c6c6c6777777777777777777770000e08880eeee0880eee0880eeeee0880eee080eeeee0880eeee0880eeee0880e00eeeeeeee000000000000000000000000
6c6c6c6c777777777777777777777700ee088800008880eeee08800000880eee0880eeeee08880ee008800000880e0880eeeeeee000000000000000000000000
66666666777777777777777777777770eee0088888800eeeeee008888800eee088880eee08888800888888888880e0880eeeeeee000000000000000000000000
77777777777777777777777777777777eeeee000000eeeeeeeeee00000eeeeee0000eeeee00000ee00000000000eee00eeeeeeee000000000000000000000000
111111111111111133333333cccccccc00000000e00eeeeee00eeeeee00eeeeee00eeeee00000000000000000000000000000000dddddddd33333333cccccccc
c1c1c1c1ffffffff33333333cccccc33000000000330eeee0220eeee0990eeee0110eeee000000000000000000000000000000004949494933333333cccccc43
11111111f3f3f3f333333333ccccc333000000000330eeee0220eeee0990eeee0110eeee00000000000000000000000000000000a4a4a4a433333333cccc4434
111111113f3f3f3f33333333cccc333300000000e00eeeeee00eeeeee00eeeeee00eeeee00000000000000000000000000000000bbbbbbbb33333333ccc44443
111c111c3333333333333333cc33333300000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000cccccccc33333333cc434434
111111113333333333333333c333333300000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000bcbcbcbc33333333cc444343
111111113333333333333333c333333300000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000cccccccc33333333c4343433
11111c1133333333333333333333333300000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000cccccccc3333333343433333
1111111111111111c1c1c1c1cccccccc3b000000e0eee0ee0000000000000000000000000000000000000000000000000000000033ffffffcccccccccccccccc
11c11111111111111c1c1c1c3bcccccc28000000070e070e00000000000000000000000000000000000000000000000000000000ffffffffcccccccc77777777
1c1c111111111111c1c1c1c133bbcccc9a000000e07070ee00000000000000000000000000000000000000000000000000000000fffffffffffcccff66666666
11111111111111111c1c1c1c3bbbbccc1c000000ee0e0eee000000000000000000000000000000000000000000000000000000007a7a7a7a7aaaaaaacccccccc
1111111111111111c1c1c1c133bb3bcc00000000e07070ee000000000000000000000000000000000000000000000000000000007777777777aaaaa7cccccccc
11111111111111111c1c1c1c3333bbcc00000000070e070e000000000000000000000000000000000000000000000000000000001c1c1c1c1c1c1c1ccccccccc
11111c1111111111c1c1c1c1333333bc00000000e0eee0ee00000000000000000000000000000000000000000000000000000000c1c1c1c1c1c1c1c1cccccccc
1111c1c1111111111c1c1c1c3333333b00000000eeeeeeee000000000000000000000000000000000000000000000000000000001c1c1c1c1c1c1c1ccccccccc
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
010800000c0730c500070000500004000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200003c62500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400003c64524620246102461024600246002460018600186001860018600186000c6000c6000c6000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000024375183751867018660186601865018650186500c6400c6400c6400c6400c6300c6300c6200c6250c600003000030000300003000030000300003000030000300003000030000300003000030000300
010800080c7700c7700c7700c7700c7700c7700c7700c7700c7000c7000c7000c7000c7000c7000c7000c70000700007000070000700007000070000700007000070000700007000070000700007000070000700
010500041837418274181740c07418200182000c2000c200192000020300203002030020300203002030020300203002030020300203002030020300203002030020300203002030020300203002030020300203
010800040c4500c4500c4500c45000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000188700000018800000001880000000188700000018b00000001880000000186701867018660186501864018630186201861518600000001880000000248000cf00248001880018b000cf001880000000
010b00002c5302752025520205202c5302752025520205202c5302752025520205202c5302752025520205202c5302752025520205202c5302752025520205202c5302752025520205202c530275202552020520
010b00001e450193121e440193121d4401d4301b440143121b312143121d440193121d312193121e450143121e31214312204501431220312143121d440193121d312193121e450143121d4501d4401b45014312
010b00000ce500be000ce500be0005e5005e550be500be5504e0004e0005e5005e5500e0500e050ce500ce5500e0500e050be500be5500e0500e0504e5004e5500e0500e050be5008e5005e5005e550ce500ce55
010b0000188500cf50188500000018b500000018850000001895000000188500000018b500000018850000001895000000188500000018b50000001885000000189500cf50248501885018b500cf501885000000
010b00002a7302a7302a7302a7302a7302a7302a7302a7302a7302a7302a7302a7302a7302a7302a7302a73029730297302973029730297302973029730297302973029730297302973029730297302973029730
010b00001e450193121e450193121d4501d4401b440143121b312143121d440193121d312193121e450143121e312143122045020440204301431220312143121d2401e240202302223024240252502724029250
010b000001e500be0001e500be0005e5005e550ce500ce5504e0004e0005e5005e5500e0500e050ae500ae5500e0500e050ce500ce5500e0500e0505e5005e5500e0500e050ae0007e0004e0004e000be000be00
010b0000188500cf50248301885018b500000018920000001885000000189200000018b500000018900000001885000000189200000018b500000018850000001892000000248301885018b50000001885024600
010b00002873028730287302873028730287302873028730287302873028730287302873028730287302873027730277302773027730277302773027730277302571023710207101e7101c7151b7151971517715
010b00002a2522a2522a2422a2422a2322a2322a2222a2222a2122a21229250292402a2502a2402c2502c24027250292502924029230272502724025250252402521025200252502524027250272402825028240
010b000005e5005e5505e5505e550be500be5505e5005e5505e5005e4005e3005e250be500be5505e5005e5508e5008e4008e3008e250fe500fe5508e5008e5508e0008e0008e3008e250fe500fe550be500be40
010b00000000000000188500000018b5000000189500000018850000000cf501885018b500000018850000000000000000188500000018b50000001885000000188000cf00248301885018b50000001883000000
010b00001885000000188500cf5018b500000018850189001894000000188500cf5018b500000018850189001893000000188500cf5018b500000018b5018900000000000018b5518b7018850000001885000000
010b00002823228222272502724028250282402a2502a240252502725025250252402325023235232502324023232232222025020240232502324025250252102521525200272402723029240292302a2502a240
010b00000be300be2517e5017e550be500be5517e5017e55000000000017e5017e550be500be5501e5001e4001e3001e250de500de55000000000001e5001e45000000000001e5501e4501e5001e4001e3001e25
010b00002a7302a7302a7302a7302a7322a7322e7212e7222e7222e7222e7222e7322e7302e73029732297322973229732297322973229722297222571225712257122571225712257122f7373b7002f7353b700
011c00001413414130141301414114140141401415114150141521415214152141522575125750257522575225752257502575025750257412574225742257402573125730257322573025721257202571125715
010b00002a2522a2522a2422a2422a2322a2322a2222a2222a2122a21229250292402a2502a2402c2502c24027250292502924029230272502724025250252402521025200222502224025250252402725027240
010b000005e5005e5505e5505e550be500be5505e5005e5505e5005e4005e3005e250be500be5505e2005e2505e5005e4005e3005e250be500be5505e5005e5505e0005e0005e3005e250be500be5503e5003e40
011c00001403414030140301404114040140401405114050140501405014050140502005120050200502005020050200502005020041200402004020040200402003120030200302002120020200202002020015
011c00000803408030080300803108030080300803108030080300803008030080350b0510b0500b0500b0500b0500b0500b0500b0500b0410b0400b0400b0310b0300b7300b7300b7210b7200b7110b7100b715
010b00002725027250272502725027242272422724227242272422724227242272422723027230312403325033252332523325233252332423324233242332423324233242332001b20023251232552325123253
010b000003e3003e25102002a200000000000008e5008e4008e3008e250000000000000000000001e5001e4001e3001e250000000000000000000006e5006e4006e3006e2533242332420be500be550be500be55
011c00000803408030080300803108030080300803108030080300803008030080351b0001b0201b0501b0501b0521b0521b0521b0501b0501b0411b0421b0421b0421b0311b0301b0321b0211b0221b0111b015
0115000030620306102461018615246550000000000000000000000000000000000024655000000000030620306102461018615000002465500000000002463500000246350000018a2024655000000000000000
0115000008e5008e5008e4008e300be500be4008e500fe500fe420ee550de550be5508e550be5506e5508e5008e5008e5008e4008e300be500be4008e5006e402080006e5006e0008e5008e5008e4008e3008e20
01150000144501445014442144321745017442144501b4501b4421a45519455174551445517455124551445014450144501444214432174501744214450124401440012450124001445014450144401443214422
01150000188703061424610186152467518f7024940188701880000000249401887024675000002494018870306142461524940000002467500000249402464518f5024645249301887024655000002494000000
010d00003c6453c64518a500ca503c64518a500c033000533c64500a5000a50000331887000000000001887001e2001e2001e3001e3001e3001e2001e2001e201880000000000000000018800000000000000000
010d00000cc0000000246202461500000246202461500000246202461500000000001897024615000003c64524620246150000000000000000000000000000000000000000000000000000000000000000000000
010d000000700007000070000700007000070000700007001472516725197351b7352725227245272002525225252252522524225242252422524225232252250020000700007000070000700007000070000700
010d000018a000ca00004000040000400004000040000400004000040000400004002045622445224002044622446204462243620436224362043622426204150040000400004000040000400004000040000400
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100020a15008550131500415004150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002b740041402a740041402a740051402a740041402a7400315000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002b05033000220002800000000000002200000000000000000000000000000000023000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900002d0502d0502d0502d0302d01029400233000f4002a0002a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000025050300503005025050000002e00031000000003a00030000000002e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500000d65003630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000181401915019150191601b1601b16018160151601316011150101500e1400d1300c1300c1300b1200b1200a1200a1200a1200a1200a12009120091200912009120091200912009110091100911009110
000200000712003020081300602027000287002870028700287001a7002870028700297002970016700297002970029700157002a700000002a700000002a7002a7002a7002a7002a70014700147000000000000
000200000c120086300b1300962000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 4808084c
00 490a0b0c
00 490e0f0c
00 4d121310
00 51161714
00 4d1a1b14
04 581e1f15
00 41424344
04 61222324
00 28252627
04 191c1d20

