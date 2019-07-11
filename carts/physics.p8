pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--
local k_small=0.001
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

function v2_cross(a,b)
	return a[1]*b[3]-a[3]*b[1]
end

function v2_ortho(a,scale)
	return {-scale*a[1],0,scale*a[3]}
end


local v_up={0,1,0}
local v_right={1,0,0}
local v_fwd={0,0,1}

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
 return {m[1]*x+m[4]*y+m[7]*z,m[2]*x+m[5]*y+m[8]*z,m[3]*x+m[6]*y+m[9]*z}
end

function make_m_from_euler(x,y,z)
		local a,b = cos(x),-sin(x)
		local c,d = cos(y),-sin(y)
		local e,f = cos(z),-sin(z)
  
  -- yxz order
  local ce,cf,de,df=c*e,c*f,d*e,d*f
	 return {
	  ce+df*b,a*f,cf*b-de,
	  de*b-cf,a*e,df+ce*b,
	  a*d,-b,a*c}
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
	return {m[4],m[5],m[6]}
end
function m_fwd(m)
	return {m[7],m[8],m[9]}
end

function make_cam(scale)
	return {
		project=function(self,v)
			return 64+scale*v[1],64-scale*v[3]
		end
	}
end

local cam=make_cam(5)

function make_plyr(p,a,density)
	local steering_angle,angle,angularv,rpm,max_rpm=0,a,0,0,96
	local velocity={0,0,0}
	local forces,torque={0,0,0},0

	local area=0
	local i=0
	local inv3=1/3
	
	local v={
		{-1,0,2},
		{1,0,2},
		{1,0,-2},
		{-1,0,-2}
	}
	for k=0,#v-1 do
		-- triangle vertices, third vertex implied as (0, 0)
		local v1,v2=v[k%#v+1],v[(k+1)%#v+1]
		local d=-v2_cross(v1,v2)
		local tarea=0.5*d
		area+=tarea
		
		local x,z=v1[1]*v1[1]+v2[1]*v1[1]+v2[1]*v2[1],v1[3]*v1[3]+v2[3]*v1[3]+v2[3]*v2[3]
		i+=0.25*inv3*d*(x+z)
	end
	
	-- physic body
	local mass=density*area
	local inv_mass=1/mass
	i*=density
	local inv_i=1/i

	local add_tireforce=function(self,offset,right,fwd,brake,rpm)
		-- force to world
		right=m_x_v(self.m,right)
		fwd=m_x_v(self.m,fwd)
		
		-- application point (world space)
		local pos,slide=v_clone(self.pos),false
		v_add(pos,m_fwd(self.m),offset)
		
		-- point velocity
		local relv=self:pt_velocity(pos)
		local relv_len=v_dot(relv,relv)
		-- avoid noise
		if relv_len>0.1 then
			local sa=v_dot(relv,right)
			v_scale(right,sa)
			self:apply_impulse(right,pos)
		end

		if rpm then
			v_scale(fwd,rpm)
			self:apply_force(fwd,pos)
		end
	
		if slide then
		--
		end
	end
	return {
		pos=v_clone(p),
		m=make_m_from_euler(0,a,0),
		-- obj to world space
		apply=function(self,p)
				p=m_x_v(self.m,p)
			 v_add(p,self.pos)
			return p
		end,
		pt_velocity=function(self,p)
			local relv=v_clone(velocity)
			v_add(relv,v2_ortho(make_v(self.pos,p),angularv))
			v_scale(relv,-1)
		 return relv
		end,		
		draw=function(self)	
			local v0=v[#v]
			local x0,y0=cam:project(self:apply(v0))
			for i=1,#v do
				local v1=v[i]
				local x1,y1=cam:project(self:apply(v1))
				line(x0,y0,x1,y1,7)
				x0,y0=x1,y1
			end
			
			print(rpm,2,2,7)
			
			print("i:"..inv_i.."\ninv_mass:"..inv_mass.."\n"..velocity[1].."/"..velocity[3],2,8,1)
		end,		
		control=function(self)
			local da=0
			if(btn(0)) da=1
			if(btn(1)) da=-1

			-- accelerate
			if btn(2) then
				rpm=min(rpm+6,max_rpm)
			end
			--[[
			local fwd=m_fwd(self.m)
			local accelerate=v_clone(fwd)
			v_scale(accelerate,rpm/12)
			v_add(fwd,m_right(self.m),0.5)
			v_add(fwd,self.pos)
			self:apply_impulse(accelerate,fwd)
   ]]
   
			-- steering angle
			steering_angle+=da/8
			local steering=1-0.05*steering_angle

			-- front wheels
			local c,s=cos(steering),sin(steering)
			add_tireforce(self,1,{c,0,-s},{s,0,c},1)
			-- rear wheels
			add_tireforce(self,-1.2,v_right,v_fwd,1,rpm)
			
		end,
		apply_force=function(self,f,p)
			--[[
			local x0,y0=cam:project(p)
			circfill(x0,y0,2,12)
			vf=v_clone(p)
			v_add(vf,f)
			local x1,y1=cam:project(vf)
			line(x0,y0,x1,y1,12)
			flip()
			]]
			v_add(forces,f)
			torque+=v2_cross(make_v(self.pos,p),f)
		end,
		apply_impulse=function(self,f,p)
			local x0,y0=cam:project(p)
			circfill(x0,y0,2,8)
			vf=v_clone(p)
			v_add(vf,f)
			local x1,y1=cam:project(vf)
			line(x0,y0,x1,y1,8)
			flip()

			v_add(velocity,f,inv_mass)
			angularv+=mid(inv_i*v2_cross(make_v(self.pos,p),f),-1,1)
			
		end,
		integrate_forces=function(self,dt)
			v_add(velocity,forces,inv_mass*dt*0.5)
			angularv+=torque*inv_i*dt*0.5
			-- apply some damping
			angularv*=0.92
			rpm*=0.97
			-- some friction
			v_scale(velocity,0.92)
		end,
		integrate_v=function(self,dt)
		 	-- update pos & orientation
			v_add(self.pos,velocity,dt)
			angle+=dt*angularv			
			self.m=make_m_from_euler(0,angle,0)

			self:integrate_forces(dt)

			steering_angle*=0.8
		end,
		reset=function(self)
			forces,torque={0,0,0},0
		end,	
		update=function(self)
		end
	}
end

local plyr=make_plyr({0,0,0},0,0.5)

function _update()
	plyr:control()
	plyr:integrate_forces(1/30)

	-- todo: apply impulses

	plyr:integrate_v(1/30)
	plyr:reset()
end

function _draw()
	cls()
	plyr:draw()	
	
	print(stat(1),2,118,2)
end
