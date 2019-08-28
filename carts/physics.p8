pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- track data
local checkpoint_data={
	12.8904,68.4766,1.7400,
	32.6227,-38.1831,2.1600,
	-23.3340,-48.8301,1.9200
}

local track_data={
	-22.9956,-50.1532,
	-23.0217,-33.2769,
	-23.0392,3.3647,
	-23.0687,40.3781,
	-23.1308,58.3695,
	-23.1834,59.6581,
	-23.1805,61.2961,
	-23.0193,63.2223,
	-22.5973,65.3753,
	-22.5973,65.3753,
	-21.7975,67.1620,
	-20.3412,68.9332,
	-18.2844,70.5099,
	-15.6830,71.7135,
	-12.2112,72.5482,
	-9.1220,72.8378,
	-6.8085,72.8133,
	-5.6636,72.7058,
	0.9664,71.3863,
	12.6426,68.9680,
	23.8566,66.6179,
	29.1001,65.5033,
	31.0509,64.8036,
	32.5651,63.9382,
	33.5872,63.1111,
	34.0618,62.5263,
	34.9435,60.3620,
	35.6549,58.2375,
	36.1459,56.5208,
	36.3665,55.5800,
	36.7361,53.2016,
	37.0073,51.3552,
	37.1902,50.0606,
	37.2949,49.3379,
	38.2933,44.0744,
	39.9058,35.7186,
	41.3251,27.5096,
	41.7434,22.6864,
	39.6170,17.5875,
	35.5052,9.7540,
	31.4558,2.4822,
	29.5169,-0.9318,
	27.9569,-3.5861,
	26.3594,-5.9952,
	25.0132,-8.1567,
	24.2074,-10.0682,
	23.4914,-12.9841,
	23.0694,-15.6910,
	23.2164,-18.5367,
	24.2074,-21.8686,
	26.9141,-27.9645,
	30.8358,-36.4107,
	34.3856,-44.0008,
	35.9771,-47.5285,
	35.9771,-47.5285,
	36.0232,-49.7978,
	35.4639,-51.5884,
	34.7099,-52.8375,
	34.1717,-53.4825,
	31.6202,-56.1543,
	28.7642,-58.5868,
	25.5294,-60.3878,
	21.8412,-61.1651,
	17.2776,-60.9371,
	14.2844,-59.8510,
	12.1599,-57.8758,
	10.2021,-54.9806,
	7.7705,-52.4631,
	4.5533,-51.0520,
	0.9337,-50.8081,
	-2.7047,-51.7923,
	-2.7047,-51.7923,
	-5.1980,-54.4885,
	-6.4104,-58.9258,
	-6.7518,-64.1386,
	-6.6320,-69.1611,
	-6.1709,-72.5811,
	-5.5509,-75.8562,
	-5.4160,-79.2963,
	-6.4108,-83.2110,
	-8.7310,-86.7632,
	-11.5248,-88.4749,
	-14.3891,-88.9513,
	-16.9206,-88.7978,
	-20.8139,-87.5330,
	-22.8689,-85.2057,
	-23.7337,-82.2129,
	-24.0561,-78.9518,
	-24.0561,-78.9518,
	-24.1968,-74.7837,
	-24.0898,-70.2654,
	-23.8830,-65.8864,
	-23.7242,-62.1361,
	-23.7242,-62.1361,
	-23.5443,-58.2180,
	-23.2846,-54.5605,
	-23.0626,-51.6951,
	-22.9956,-50.1532
}

-->8
-- game
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
function v_clamp(v,l)	
	local d=v_dot(v,v)
	if d>l*l then
		v_scale(v,l/sqrt(d))
	end
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
function v_dist(a,b)
	local d=make_v(a,b)
	return v_dot(d,d)
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
	local pos={0,0,0}
	return {
		track=function(self,p)
			pos=v_clone(p)
		end,
		project=function(self,v)
			return 64+scale*(v[1]-pos[1]),64-scale*(v[3]-pos[3])
		end,
		project_radius=function(self,r)
			return r*scale
		end
	}
end

local cam=make_cam(3)
function make_skidmarks()
	local skidmarks={}
	local t=0
	return {
		make_emitter=function()
			local emit_t=0
			local start_pos
			return function(pos)
				-- broken skidmark?
				if emit_t!=t then
					start_pos=nil
				end
				if(not start_pos) start_pos=v_clone(pos)
				-- next expected update
				emit_t=t+1
				if emit_t>0 and emit_t%10==0 then
					local end_pos=v_clone(pos)
					add(skidmarks,{start_pos,end_pos,0})
					start_pos=end_pos
				end
			end
		end,
		update=function(self)
			t+=1
			for s in all(skidmarks) do
				s[3]+=1
				if(s[3]>60) del(skidmarks,s)
			end
		end,
		draw=function(self)
			for _,s in pairs(skidmarks) do
				local x0,y0=cam:project(s[1])
				local x1,y1=cam:project(s[2])
				line(x0,y0,x1,y1,5)
			end
		end
	}
end
local skidmarks=make_skidmarks()

function make_track(segments)
	-- "close" track
	-- add(segments,segments[1])
	-- add(segments,segments[2])
	assert(#segments%2==0,"invalid number of track coordinates")
	local n=#segments/2
	-- active index
	local checkpoint=0
	local function to_v(i)
		return {segments[2*i+1],0,segments[2*i+2]}
	end
	return {	
		-- returns next location
		get_next=function(self)
			return to_v(checkpoint)
		end,
		update=function(self,pos,dist)
			local p=to_v(checkpoint)
			if v_dist(pos,p)<dist then
				checkpoint+=1
				checkpoint%=n
			end
			return to_v(checkpoint)
		end,
		draw=function(self)
			local x0,y0=cam:project(to_v(0))
			local x1,y1=cam:project(to_v(1))
			line(x0,y0,x1,y1,11)
			for i=2,n-1 do
				local x,y=cam:project(to_v(i))
				line(x,y)
			end
		end
	}
end

function make_checkpoints(segments)
	assert(#segments%3==0,"invalid number of track coordinates")
	-- active index
	local checkpoint=0
	local n=#segments/3
	-- active index
	local checkpoint=0
	local function to_v(i)
		return {segments[3*i+1],0,segments[3*i+2]},segments[3*i+3]
	end

	-- previous laps
	local laps={}

	-- remaining time before game over (+ some buffer time)
	local lap_t,remaining_t,best_t,best_i=0,30*30,32000,1
	return {	
		get_next=function(self)
			return to_v(checkpoint)
		end,
		update=function(self,pos)
			remaining_t-=1
			if remaining_t==0 then
				-- next_state(gameover_state)
				return
			end
			lap_t+=1
			local p,r=to_v(checkpoint)
			if v_dist(pos,p)<r*r then
				checkpoint+=1
				remaining_t+=30*30
				-- closed lap?
				if checkpoint%n==0 then
					checkpoint=0
					-- record time
					add(laps,time_tostr(lap_t))
					if(lap_t<best_t) then
						best_t=lap_t
						best_i=#laps						
					end
					-- next lap
					lap_t=0
				end
			end
		end,
		draw=function(self)
			-- draw checkpoints
			for i=0,n-1 do
				local p,r=to_v(i)
				r=cam:project_radius(r)
				local x0,y0=cam:project(p)
				circ(x0,y0,r,checkpoint==i and 10 or 1)
			end

			print("time",56,2,7)
			print(ceil(remaining_t/30),60,10,10)

			print("lap time: ",96,2,7)
			local y=8
			for i=1,#laps do
				print(i,96,y,9)
				print(laps[i],102,y,best_i==i and 9 or 7)
				y+=6
			end
			print(#laps+1,96,y,9)
			print(time_tostr(lap_t),102,y,7)
		end
	}
end

local debug_vectors={}
function draw_vector(f,p,c,v)
	local x0,y0=cam:project(p)
	p=v_clone(p)
	v_add(p,f)
	local x1,y1=cam:project(p)
	line(x0,y0,x1,y1,c)
	if v then
		print(v,x1+3,y1,c)
	end
end

function draw_debug_vectors()
	for _,dv in pairs(debug_vectors) do
		draw_vector(dv.f,dv.p,dv.c or 1,dv.scale)
	end
end

function make_plyr(p,a)
	local rpm=0

	local body=make_car(p,a)
	
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
	local body_update=body.update
	body.update=function(self)
		body_update(self)
		rpm*=0.97		
	end
	-- wrapper
	return body
end

local npcs={}
local actors={}

function make_npc(p,angle,track)	
	local body=make_car(p,angle)

	local body_draw=body.draw
	body.draw=function(self)
		local x,y=cam:project(track:get_next())
		circfill(x,y,1,8)

		body_draw(self)
	end

	-- return world position p in local space (2d)
	function inv_apply(self,target)
		p=make_v(self.pos,target)
		local x,y,z,m=p[1],p[2],p[3],self.m
		return {m[1]*x+m[2]*y+m[3]*z,0,m[7]*x+m[8]*y+m[9]*z}
	end

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
						add(debug_vectors,{f=axis_bck,p=self.pos,c=4,scale=sep})

						local local_pos=inv_apply(self,actor.pos)
						-- in front?
						-- in path?
						if local_pos[3]>0 and abs(local_pos[1])<2 then							
							local x=local_pos[1]
							local escape_axis=v2_ortho(axis,1)
							local_pos[1]+=1/v_dot(relv,escape_axis)
							target_angle=atan2(local_pos[1],local_pos[3])
							rpm/=2

							add(debug_vectors,{f=make_v(self.pos,self:apply(local_pos)),p=self.pos,c=8,scale=target_angle})
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
	return body
end

local checkpoints=make_checkpoints(checkpoint_data)

function make_car(p,angle)
	local velocity,angularv={0,0,0},0
	local forces,torque={0,0,0},0

	local is_braking=false
	local max_rpm=0.55
	local steering_angle=0
	local sliding_t=0

	local v={
		{-0.5,0,2},
		{0.5,0,2},
		{1,0,-2},
		{-1,0,-2}
	}

	local skidmark_emitters={
		skidmarks:make_emitter(),
		skidmarks:make_emitter(),
		skidmarks:make_emitter(),
		skidmarks:make_emitter()
	}

	return {
		pos=v_clone(p),
		m=make_m_from_euler(0,a,0),
		-- obj to world space
		apply=function(self,p)
			p=m_x_v(self.m,p)
			v_add(p,self.pos)
			return p
		end,
		get_velocity=function() return velocity end,
		draw=function(self)	
			color(is_braking==false and 7 or 8)
			local x0,y0=cam:project(self:apply(v[#v]))
			for i=1,#v do
				local x1,y1=cam:project(self:apply(v[i]))
				line(x0,y0,x1,y1)
				x0,y0=x1,y1			
			end

			-- target in local space
			--[[
			local target=make_v(self.pos,checkpoints:get_next())
			local x,y,z=target[1],target[2],target[3]
			local m=self.m
			target={m[1]*x+m[2]*y+m[3]*z,m[4]*x+m[5]*y+m[6]*z,m[7]*x+m[8]*y+m[9]*z}
			x0,y0=cam:project(checkpoints:get_next())			
			local target_angle=atan2(target[1],target[3])
			print(target_angle,x0+3,y0,2)
			target_angle+=angle
			target={cos(target_angle),0,sin(target_angle)}
			v_add(target,self.pos)
			x0,y0=cam:project(self.pos)
			local x1,y1=cam:project(target)
			line(x0,y0,x1,y1,8)
			]]

		end,		
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
			v_scale(velocity,lerp(0.97,0.8,min(sliding_t,30)/30))
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
			steering_angle+=mid(steering_dt,-0.1,0.1)

			-- longitudinal slip ratio
			local right=m_right(self.m)
			local sr=v_dot(right,velocity)
			local last_sliding_t=sliding_t
			local full_slide
			if abs(sr)>0.12 then
				sliding_t+=1
				full_slide=true
				for i=1,#v do
					skidmark_emitters[i](self:apply(v[i]))
				end		
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
				skidmark_emitters[3](self:apply(v[3]))
				skidmark_emitters[4](self:apply(v[4]))
			end

			return min(rpm,max_rpm)
		end,
		update=function(self)
			steering_angle*=0.8
		end
	}	
end


local plyr=make_plyr({-28,0,-33},0)

-- only for display
local static_track=make_track(track_data)

function _init()
	add(actors,plyr)

	for i=1,4 do
		local npc_track=make_track(track_data)
		local p=v_clone(npc_track:get_next())
		p[1]+=(1-rnd(2))
		p[3]+=(1-rnd(2))
		add(actors,add(npcs, make_npc(p,0,npc_track)))
	end
end

function _update()
	debug_vectors={}

	if plyr then
		plyr:control()
		plyr:prepare()
		plyr:integrate()	
		plyr:update()

		checkpoints:update(plyr.pos)
	end

	for _,npc in pairs(npcs) do
		npc:control()
		npc:prepare()
		npc:integrate()	
		npc:update()
	end

	skidmarks:update()
end

function _draw()
	cls()

	if(plyr) plyr:draw()	

	cam:track(plyr and plyr.pos or npcs[1].pos)

	static_track:draw()

	skidmarks:draw()

	for _,npc in pairs(npcs) do
		npc:draw()
	end

	draw_debug_vectors()

	checkpoints:draw()

	if(plyr) print(plyr:get_speed().."km/h",2,2,7)

	local cpu=flr(1000*stat(1))/10
	print(cpu.."%",2,118,2)
end

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
