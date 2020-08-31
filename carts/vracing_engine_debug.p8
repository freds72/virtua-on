pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- vector & tools
function lerp(a,b,t)
	return a*(1-t)+b*t
end

function smoothstep(t)
	t=mid(t,0,1)
	return t*t*(3-2*t)
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
	return {m[1]*x+m[5]*y+m[9]*z+m[13],m[2]*x+m[6]*y+m[10]*z+m[14],m[3]*x+m[7]*y+m[11]*z+m[15]}
end
function m_x_m(a,b)
	local a11,a12,a13,a14=a[1],a[5],a[9],a[13]
	local a21,a22,a23,a24=a[2],a[6],a[10],a[14]
	local a31,a32,a33,a34=a[3],a[7],a[11],a[15]

	local b11,b12,b13,b14=b[1],b[5],b[9],b[13]
	local b21,b22,b23,b24=b[2],b[6],b[10],b[14]
	local b31,b32,b33,b34=b[3],b[7],b[11],b[15]

	return {
			a11*b11+a12*b21+a13*b31,a21*b11+a22*b21+a23*b31,a31*b11+a32*b21+a33*b31,0,
			a11*b12+a12*b22+a13*b32,a21*b12+a22*b22+a23*b32,a31*b12+a32*b22+a33*b32,0,
			a11*b13+a12*b23+a13*b33,a21*b13+a22*b23+a23*b33,a31*b13+a32*b23+a33*b33,0,
			a11*b14+a12*b24+a13*b34+a14,a21*b14+a22*b24+a23*b34+a24,a31*b14+a32*b24+a33*b34+a34,1
		}
end
function m_clone(m)
	local c={}
	for k,v in pairs(m) do
		c[k]=v
	end
	return c
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
-- only invert 3x3 part
function m_inv(m)
	m[2],m[5]=m[5],m[2]
	m[3],m[9]=m[9],m[3]
	m[7],m[10]=m[10],m[7]
end
-- inline matrix vector multiply invert
-- inc. position
function m_inv_x_v(m,v)
	local x,y,z=v[1]-m[13],v[2]-m[14],v[3]-m[15]
	return {m[1]*x+m[2]*y+m[3]*z,m[5]*x+m[6]*y+m[7]*z,m[9]*x+m[10]*y+m[11]*z}
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
local z_near=0.05

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
	return flr(x),flr(y),x,y
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
		{-1.65,1.125,0.2},
		{-0.7,0.3,0.1},
		{-0.01,0.1,0.6}
	}
	local current_pov=v_clone(view_pov[view_mode+1])

	--
	local up={0,1,0}

	-- raycasting constants
	local angles={}
	for i=0,15 do
		add(angles,atan2(7.5,i-7.5))
	end

	-- screen shake
	local shkx,shky=0,0
	camera()
	
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
			elseif btnp(4) then
				local next_mode=(view_mode+1)%#view_pov
				local next_pov=v_clone(view_pov[next_mode+1])
				switching_async=cocreate(function()
					for i=0,29 do
						local t=smoothstep(i/30)
						current_pov=v_lerp(view_pov[view_mode+1],next_pov,t)
						yield()
					end
					-- avoid drift
					current_pov,view_mode=next_pov,next_mode
				end)
			end

			shkx*=-0.7-rnd(0.2)
			shky*=-0.7-rnd(0.2)
			if abs(shkx)<0.5 and abs(shky)<0.5 then
				shkx,shky=0,0
			end
			camera(shkx,shky)
		end,
		track=function(self,pos,a,u)
   			pos=v_clone(pos)
   			-- lerp angle
			self.angle=lerp(self.angle,a,current_pov[3])
			-- lerp orientation
			up=v_lerp(up,u,current_pov[3])
			v_normz(up)

			-- shift cam position			
			pos[2]+=15
			local m=make_m_from_euler(0.25,self.angle,0) -- make_m_from_v_angle(up,self.angle)
			--v_add(pos,m_fwd(m),current_pov[1])
			--v_add(pos,m_up(m),current_pov[2])
			
			-- inverse view matrix
			m_inv(m)
			self.m=m_x_m(m,{
				1,0,0,0,
				0,1,0,0,
				0,0,1,0,
				-pos[1],-pos[2],-pos[3],1
			})
			
			self.pos=pos
		end,
		project_poly=function(self,p,c)
			if cam.mode=="line" then
				local p0=p[1]
				local x0,y0=63.5+flr(shl(p0[1],2)),63.5-flr(shl(p0[2],2))
				for i=1,#p do
					local p1=p[i]
					local x1,y1=63.5+flr(shl(p1[1],2)),63.5-flr(shl(p1[2],2))
					line(x0,y0,x1,y1,c)
					x0,y0=x1,y1
				end
			else
				local p0,p1=p[1],p[2]
				-- magic constants = 89.4% vs. 90.9%
				-- shl = 79.7% vs. 80.6%
				local x0,y0=63.5+flr(shl(p0[1],2)),63.5-flr(shl(p0[2],2))
				local x1,y1=63.5+flr(shl(p1[1],2)),63.5-flr(shl(p1[2],2))
				for i=3,#p do
					local p2=p[i]
					local x2,y2=63.5+flr(shl(p2[1],2)),63.5-flr(shl(p2[2],2))
					trifill(x0,y0,x1,y1,x2,y2,c)
					x1,y1=x2,y2
				end
			end
		end,
		visible_tiles=function(self)
			local x0,y0,x,y=to_tile_coords(self.pos)
			local tiles={[x0+shl(y0,5)]=0} 
   
   			for i=1,16 do   	
				local a=angles[i]+self.angle
				local v,u=cos(a),-sin(a)
				
				local mapx,mapy=x0,y0
			
				local ddx,ddy=1/u,1/v
				local mapdx,distx
				if u<0 then
					mapdx,ddx=-1,-ddx
					distx=(x-mapx)*ddx
				else
					mapdx=1
					distx=(mapx+1-x)*ddx
				end
				local mapdy,disty
				if v<0 then
					mapdy,ddy=-1,-ddy
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
					local a,b,c,d=v_clone(pos),v_clone(pos),v_clone(start_pos),v_clone(start_pos)
					v_add(a,current_right,-width)
					v_add(b,current_right,width)
					v_add(c,current_right,width)
					v_add(d,current_right,-width)
					oldf.skidmarks=oldf.skidmarks or {}
					current_skidmarks=add(oldf.skidmarks,add(skidmarks,{a,b,c,d,ttl=0,f=oldf}))
					start_pos,oldf=v_clone(pos),newf
				elseif current_right then
					local a,b=v_clone(pos),v_clone(pos)
					v_add(a,current_right,width)
					v_add(b,current_right,-width)
					current_skidmarks[1]=a
					current_skidmarks[2]=b
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
	local sliding_t=0

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

	local do_skidmarks=function(self,emitters)
		if(self!=plyr) return
		for k,emitter in pairs(emitters) do
			-- world position
			local vgroup_offset=model.vgroups[k].offset
			local ground_pos=m_x_v(self.m,vgroup_offset)
			v_add(ground_pos,self.pos)
			-- stick to ground
			v_add(ground_pos,oldf.n,-vgroup_offset[2])
			emitter(ground_pos,oldf)
		end
	end

	return {
		pos=v_clone(p),
		m=make_m_from_euler(0,a,0),
		get_sliding_t=function(self)
			return sliding_t
		end,
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

			v_add(forces,f)
			torque+=t
		end,
		prepare=function(self)
			-- update velocities
			v_add(velocity,forces,0.5/30)
			angularv+=torque*0.5/30

			-- apply some damping
			angularv*=0.86
			v_scale(velocity,0.97)
			-- some friction
			-- v_add(velocity,velocity,-0.02*v_dot(velocity,velocity))
		end,
		integrate=function(self)
		 	-- update pos & orientation
			v_add(self.pos,velocity)
			-- fix
			angularv=mid(angularv,-1,1)
			angle+=angularv			
			self.m=make_m_from_euler(0,angle,0)

			-- reset
			forces,torque={0,0,0},0
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
			local full_slide
			if abs(sr)>0.12 then
				sliding_t+=1
				full_slide=true
				do_skidmarks(self,front_emitters)
				do_skidmarks(self,rear_emitters)
			else
				-- not sliding
				sliding_t=0
			end
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
			if not full_slide and rps>10 and effective_rps/rps<0.6 then
				do_skidmarks(self,rear_emitters)
			end

			return min(rpm,max_rpm)
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
			pos[2]=max(pos[2])
			-- collision
			if oldf and oldf.borders then
				local hit,force,hit_n=face_collide(oldf,pos,0.25)
				if hit then
					v_add(pos,force)
					--simulate sliding contact (no impact on velocity) vs. direct hit (massive slowdown)
					local friction=v_dot(velocity,hit_n)
					-- non separating?
					if(friction<-0.01) v_scale(velocity,1+friction)
				end
			end

			-- update car parts (orientations)
			local fwd=m_fwd(self.m)
			total_r+=v_dot(fwd,velocity)/0.2638
			local wheel_m=make_m_from_euler(total_r,0,0)
			self.rrw=wheel_m
			self.lrw=wheel_m
			wheel_m=make_m_from_euler(total_r,-steering_angle/8,0)
			self.lfw=wheel_m
			self.rfw=wheel_m
			self.sw=m_from_q(make_q({0,0.2144,-0.9767},-steering_angle/2))
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
		if btn(2) then
			rpm=rpm+0.1
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
	-- wrapper
	return body
end

function make_track(segments)
	local n=#segments
	-- active index
	local checkpoint=0
	local function to_v(i)
		return segments[i+1]
	end
	return {	
		-- returns next location
		get_next=function(self)
			return to_v(checkpoint)
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
	local body=make_car(all_models["car"].lods[2],p,angle)

	-- return world position p in local space (2d)
	function inv_apply(self,target)
		p=make_v(self.pos,target)
		local x,y,z,m=p[1],p[2],p[3],self.m
		return {m[1]*x+m[2]*y+m[3]*z,0,m[7]*x+m[8]*y+m[9]*z}
	end

	-- todo: switch to npc car model
	body.model=all_models["car"]

	body.control=function(self)
		-- lookahead
		local fwd=m_fwd(self.m)
		-- force application point
		local p=v_clone(self.pos)
		v_add(p,fwd,3)
		
		local rpm=0.6
		-- default: steer to track
		local target=inv_apply(self,track:update(p,24))
		local target_angle=atan2(target[1],target[3])

		-- avoid collisions
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
		
		-- shortest angle
		if(target_angle<0.5) target_angle=1-target_angle
		target_angle=0.75-target_angle
		self:steer(target_angle,rpm*lerp(1,0.5,min(abs(target_angle)/0.17,1)))

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
-- reports hit result + correcting force + border normal
function face_collide(f,p,r)
	local force,hit,n={0,0,0}
	for _,b in pairs(f.borders) do
		local pv=make_v(b.v,p)
		local dist=v_dot(pv,b.n)
		if dist<r then
			hit,n=true,b.n
			v_add(force,b.n,r-dist)
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
	--[[
	for i=1,4 do
		local npc_track=make_track(track.npc_path)
		local p=v_clone(npc_track:get_next())
		--p[1]+=(1-rnd(2))
		p[3]+=i/8
		add(actors,add(npcs, make_npc(p,0,npc_track)))
	end
	]]

	local ttl=90 -- 3*30

	return 
		-- draw
		function()
			local sx=flr(ttl/30)*12
			printxl(sx,32,12,16,50)

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
		return 96+0.3*(cc*x-ss*y),64-0.3*(ss*x+cc*y)
	end
		
	return
		-- draw
		function()
			printb("lap time",90,2,7,0)
			printb("time",56,2,7,0)
			printf(tostr(ceil(remaining_t/30)),nil,9,xlfont)
			
			-- speed
			printf(tostr(flr(plyr:get_speed())),31,114,xlfont)
			printr("km/h",32,121,10,9)

			-- blink go!
			if(go_ttl>0 and go_ttl%4<2) printxl(0,48,36,16,50)

			-- extend time message
			if(extend_time_t>0 and extend_time_t%30<15) printr("extend time",nil,28,10,4)
			local y=9
			for i=1,#laps do
				printb(i,90,y,9,0)
				printb(laps[i],98,y,best_i==i and 9 or 7,0)
				y+=7
			end
			printb(#laps+1,90,y,9,0)
			printb(time_tostr(lap_t),98,y,7,0)
			
			-- track map
			local pos,angle=plyr:get_pos()
			local cc,ss=cos(angle),-sin(angle)
			-- draw npc path
			local x0,y0=track_project(track.npc_path[#track.npc_path],pos,cc,ss)
			for i=1,#track.npc_path,2 do
				local x1,y1=track_project(track.npc_path[i],pos,cc,ss)
				line(x0,y0,x1,y1,0x1000)
				x0,y0=x1,y1
			end
			-- draw other cars
			for _,npc in pairs(npcs) do
				x0,y0=track_project(npc:get_pos(),pos,cc,ss)
				circfill(x0,y0,1.5,0x4)
			end
			circfill(96,64,1,0x8)
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
					if(lap_t<best_t) then
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
				print3d(32,0,65,16,50,angle)
			else
				print3d(39,32,57,32,50,angle)
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
	local track_name=stat(6)
	if track_name=="" then
		-- starting without context
		cls(1)
		track_name="bigforest"
	end
	track=unpack_track(track_name)
	-- load regular 3d models
	unpack_models()
	-- restore
	reload()

	-- init state machine
	next_state(start_state)
end

function _update()
	-- basic state mgt
	update_state()

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
		-- inline: local a=m_x_v(t.m,t.v[k]) 
		local v,m=t.v[k],t.m
		local x,y,z=v[1],v[2],v[3]
		local ax,az=m[1]*x+m[5]*y+m[9]*z+m[13],m[3]*x+m[7]*y+m[11]*z+m[15]
	
		local outcode=az>z_near and k_far or k_near
		if ax>az then outcode+=k_right
		elseif -ax>az then outcode+=k_left
		end	

		t[k]={ax,m[2]*x+m[6]*y+m[10]*z+m[14],az,outcode=outcode}
		return t[k]
	end
}

function collect_faces(faces,cam_pos,v_cache,out,dist)
	local n=#out+1
	for _,face in pairs(faces) do
		-- avoid overdraw for shared faces
		if face.session!=sessionid and (band(face.flags,1)>0 or v_dot(face.n,cam_pos)>face.cp) then
			local z,y,outcode,verts,is_clipped=0,0,0xffff,{},0
			-- project vertices
			for ki=1,face.ni do
				local a=v_cache[face[ki]]
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
					out[n]={key=1/(y*y+z*z),f=face,v=verts,dist=dist,center=center}
				 	-- 0.1% faster vs [#out+1]
				 	n+=1
				end
			end
			face.session=sessionid	
		end
	end
end

function collect_model_faces(model,m,parts,out)
	-- all models reuses the same faces!!
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
	
	model=model.lods[min(lodid,#model.lods-1)+1]

	-- object to world
	-- world to cam
	m=m_x_m(cam.m,m)

	-- vertex cache (and model context)
	local p={m=m,v=model.v}
	
	setmetatable(p,v_cache_cls)

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
		p.m=m_x_m(m_base,vgm)

	 	collect_faces(vgroup.f,vg_cam_pos,p,out)
	end
end

function draw_faces(faces,v_cache)
	for i=1,#faces do
		local d=faces[i]
		cam:project_poly(d.v,d.f.c)
		-- details?
		if d.key>0.0200 then
			-- face details
			if d.f.inner then -- d.dist<2 then					
				for _,face in pairs(d.f.inner) do
					local verts,outcode,is_clipped={},0xffff,0
					for ki=1,face.ni do
						local a=v_cache[face[ki]]
						outcode=band(outcode,a.outcode)
						-- behind near plane?
						is_clipped+=band(a.outcode,2)
						verts[ki]=a
					end
					if outcode==0 then
						if(is_clipped>0) verts=z_poly_clip(z_near,verts)
						if(#verts>2) cam:project_poly(verts,face.c)
					end
				end
			end
			-- face skidmarks
			if d.f.skidmarks then
				local m=v_cache.m
				for _,skids in pairs(d.f.skidmarks) do
					local verts,outcode,is_clipped={},0xffff,0
					for i=1,4 do
						-- world to cam
						local a=m_x_v(m,skids[i])
						local ax,az=a[1],a[3]
						local aout=az>z_near and k_far or k_near
						if ax>az then aout+=k_right
						elseif -ax>az then aout+=k_left
						end
						-- behind near plane?
						is_clipped+=band(aout,2)
						outcode=band(outcode,aout)
						verts[i]={ax,a[2],az}
					end
					if outcode==0 then
						-- mix of near+far vertices?
						if(is_clipped>0) verts=z_poly_clip(z_near,verts)
						if(#verts>2) cam:project_poly(verts,0)
					end
				end
			end
		end
	end
end

function make_plane(width)
	return {
		{0,0,0},
		{width,0,0},
		{width,0,width},
		{0,0,width}
	}
end

local plane=make_plane(8)

function _draw()
	sessionid+=1

	-- background
	cls()

	-- track
	local v_cache={m=cam.m,v=track.v}
	setmetatable(v_cache,v_cache_cls)

	local tiles=cam:visible_tiles()

	cam.mode=nil
	function draw_voxel_plane(k,c)
		local i,j=k%32,flr(k/32)
 		local offset={8*i-128,0,8*j-128}
		local verts={}
		for vi,v in pairs(plane) do			
			v=v_clone(v)
			v_add(v,offset)
			verts[vi]=m_x_v(cam.m,v)
		end
		local faces=track.voxels[k]
		if faces then
			fillp() 
		else
			fillp(0xa5a5)
		end
		verts=z_poly_clip(z_near,verts)
		cam:project_poly(verts,c)
	end

 	for k,_ in pairs(tiles) do
	 	draw_voxel_plane(k,0x21)
		--if(faces) print(#faces,x0,y0-8,7)
	end
	fillp()	
	cam.mode="line"

	local out={}
	-- get visible voxels
	for k,dist in pairs(tiles) do
	--for k,_ in pairs(track.voxels) do
		local faces=track.voxels[k]
		if faces then
			collect_faces(faces,cam.pos,v_cache,out,dist)
		end 
	end

	sort(out)
	draw_faces(out,v_cache)
 
	-- clear vertex cache
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

	local cpu=flr(1000*stat(1))/10
	local mem=ceil(stat(0))
	cpu=cpu.."%\n"..mem.."kb\n"--.."\n"..cam.pos[1].."/"..cam.pos[3]
	printb(cpu,2,2,7,2)
end

-->8
-- unpack data & models
local cart_id,cart_name,mem=1,"track"
local cart_progress=0
function mpeek()
	if mem==0x4300 then
		cart_progress=0
		reload(0,0,0x4300,cart_name.."_"..cart_id..".p8")
		cart_id += 1
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
	local f={flags=unpack_int(),c=unpack_int()}
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
	-- for all models
	unpack_array(function()
		local model,name,scale={lods={},lod_dist={}},unpack_string(),1/unpack_int()
		scale=1/32
		printh(name..": "..scale)

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
function unpack_track(name)
	cart_name,mem=name,0
	reload(0,0,0x4300,cart_name.."_0.p8")
	local id=unpack_int()
	local model={
		id=id,
		map=16*id,
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
-- trifill & clipping
-- by @p01
function p01_trapeze_h(l,r,lt,rt,y0,y1)
  lt,rt=(lt-l)/(y1-y0),(rt-r)/(y1-y0)
  if(y0<0)l,r,y0=l-y0*lt,r-y0*rt,0
  for y0=y0,min(y1,128) do
   rectfill(l,y0,r,y0)
   l+=lt
   r+=rt
  end
end
function p01_trapeze_w(t,b,tt,bt,x0,x1)
 tt,bt=(tt-t)/(x1-x0),(bt-b)/(x1-x0)
 if(x0<0)t,b,x0=t-x0*tt,b-x0*bt,0
 for x0=x0,min(x1,128) do
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
	x=x or 64-shl(#s,1)
	?s,x,y+1,c2 or 1
	?s,x,y,c1
end

-- raised print
function printr(s,x,y,c,c2)
	x=x or 64-shl(#s,1)
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
		x=64-shr(#s*w,1)
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

 sspr(sx,sy,sw,sh,64-sw/2,dy)
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
 		sspr(sx,sy+u/w0,sw,1,63.5-w0,y,2*w0,1)
  		u+=du
  		w0+=dw
 	end
	palt()
end

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
111111116666666633333333cccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee333333333333333300000000
c1c1c1c16d6d6d6d33333333cccccc33eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee333333333333333300000000
111111113636363633333333ccccc333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee333333333333333300000000
111111113333333333333333cccc3333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee333333333333333300000000
111c111c3333333333333333cc333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee3b3b3b3b3333333300000000
111111113333333333333333c3333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeb3b3b3b33333333300000000
111111113333333333333333c3333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee666666663333333300000000
11111c11333333333333333333333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee777777773333333300000000
1111111111111111c1c1c1c1cccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee33ffffffcccccccc00000000
11c11111111111111c1c1c1c3bcccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffcccccccc00000000
1c1c111111111111c1c1c1c133bbcccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffffffffffcccff00000000
11111111111111111c1c1c1c3bbbbccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7a7a7a7a7aaaaaaa00000000
1111111111111111c1c1c1c133bb3bcceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7777777777aaaaa700000000
11111111111111111c1c1c1c3333bbcceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1c1c1c1c1c1c1c1c00000000
11111c1111111111c1c1c1c13b3333bceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeec1c1c1c1c1c1c1c100000000
1111c1c1111111111c1c1c1c3333333beeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1c1c1c1c1c1c1c1c00000000
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
0303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030301020303030303030303030303030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0301020111110203030303030303030303030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111111111111102010203030303030303030303030303030303030303030303030303030303030303030303032333030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111102030303030103030303030303030303030303030303030323330303030303030303232e2e330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111111111111111102010201110303030303030303030303030303030333232e2e33030323330303232e2e2e2e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21212121212121212121212121212121101010101010101010101010101010102d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222232323232323232323232323232323232323232323232323232323232323232320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222220202020202020202020202020202020202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222222222222222222222222222222231313131313131313131313131313131313131313131313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010002201501b750131500415004150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010002281301d720211301c250231501c2501b2500d1501f2500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002b05033000220002800000000000002200000000000000000000000000000000023000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900002d0502d0502d0502d0502d05029400233000f400000000940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000025050300503005025050000002e00031000000003a00030000000002e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
