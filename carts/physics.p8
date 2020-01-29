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
	{-25.13,0,-48.38},{-21.31,0,-48.38},
	{-25.13,0,-44.44},{-21.31,0,-44.44},
	{-25.13,0,-40.5},{-21.31,0,-40.5},
	{-25.13,0,-36.56},{-21.31,0,-36.56},
	{-25.12,0,-32.6},{-21.31,0,-32.6},
	{-25.12,0,-28.66},{-21.31,0,-28.66},
	{-25.12,0,-24.72},{-21.31,0,-24.72},
	{-25.12,0,-20.79},{-21.31,0,-20.79},
	{-25.12,0,-16.85},{-21.31,0,-16.85},
	{-25.12,0,-12.91},{-21.31,0,-12.91},
	{-29.47,0,-8.97},{-21.31,0,-8.97},
	{-29.08,0,-4.89},{-21.31,0,-4.89},
	{-28.65,0,-0.77},{-21.31,0,-0.77},
	{-26.95,0,3.36},{-21.31,0,3.36},
	{-25.31,0,7.41},{-21.43,0,7.41},
	{-25.31,0,11.16},{-21.43,0,11.16},
	{-25.31,0,14.91},{-21.43,0,14.91},
	{-25.31,0,18.66},{-21.43,0,18.66},
	{-25.31,0,22.41},{-21.43,0,22.41},
	{-25.31,0,26.16},{-21.43,0,26.16},
	{-25.31,0,29.91},{-21.43,0,29.91},
	{-25.31,0,33.66},{-21.43,0,33.66},
	{-25.31,0,37.41},{-21.43,0,37.41},
	{-25.31,0,41.16},{-21.43,0,41.16},
	{-25.31,0,44.91},{-21.43,0,44.91},
	{-25.18,0,48.66},{-21.45,0,48.66},
	{-25.18,0,52.39},{-21.45,0,52.39},
	{-25.18,0,56.16},{-21.45,0,56.16},
	{-25.18,0,59.89},{-21.46,0,59.89},
	{-24.95,0,63.9},{-21.31,0,63.35},
	{-23.59,0,67.96},{-20.38,0,66.2},
	{-21.25,0,71.07},{-18.65,0,68.46},
	{-17.99,0,73.34},{-16.39,0,70.03},
	{-14.34,0,74.54},{-13.58,0,70.94},
	{-10.48,0,74.77},{-10.69,0,71.07},
	{-6.91,0,74.31},{-7.54,0,70.64},
	{-3.44,0,73.67},{-4.19,0,70.02},
	{-0.26,0,73.02},{-0.98,0,69.36},
	{3.07,0,72.33},{2.34,0,68.68},
	{6.48,0,71.62},{5.73,0,67.98},
	{9.71,0,70.96},{8.98,0,67.31},
	{13.05,0,70.41},{12.33,0,66.61},
	{16.41,0,69.72},{15.63,0,65.93},
	{19.73,0,69.04},{18.95,0,65.25},
	{23.03,0,68.36},{22.25,0,64.57},
	{26.34,0,67.68},{25.58,0,63.88},
	{29.66,0,66.96},{28.87,0,63.19},
	{33.31,0,65.64},{31.48,0,62.29},
	{36.48,0,62.98},{33.41,0,60.77},
	{38.02,0,60.0},{34.25,0,59.13},
	{38.61,0,57.84},{34.54,0,57.14},
	{39.47,0,52.93},{35.4,0,52.24},
	{40.05,0,49.58},{35.98,0,48.84},
	{40.61,0,46.26},{36.55,0,45.51},
	{41.19,0,42.93},{37.14,0,42.15},
	{41.77,0,39.6},{37.72,0,38.83},
	{42.36,0,36.27},{38.29,0,35.5},
	{42.93,0,32.93},{38.88,0,32.14},
	{43.52,0,29.61},{39.46,0,28.82},
	{44.12,0,26.15},{40.04,0,25.58},
	{44.12,0,22.22},{40.04,0,22.8},
	{42.73,0,18.43},{39.05,0,20.3},
	{41.07,0,15.45},{37.41,0,17.37},
	{39.41,0,12.49},{35.76,0,14.42},
	{37.76,0,9.54},{34.1,0,11.46},
	{36.12,0,6.63},{32.43,0,8.48},
	{34.43,0,3.62},{30.77,0,5.54},
	{32.75,0,0.64},{29.1,0,2.57},
	{31.11,0,-2.29},{27.45,0,-0.37},
	{29.45,0,-5.25},{25.79,0,-3.33},
	{27.81,0,-8.22},{24.14,0,-6.28},
	{26.18,0,-11.14},{22.5,0,-9.28},
	{25.22,0,-13.53},{21.12,0,-13.1},
	{25.12,0,-16.02},{20.96,0,-16.02},
	{25.3,0,-19.53},{21.5,0,-20.48},
	{26.59,0,-22.1},{23.09,0,-24.02},
	{28.17,0,-25.09},{24.67,0,-27.04},
	{29.74,0,-28.07},{26.27,0,-30.04},
	{31.33,0,-31.07},{27.82,0,-33.0},
	{32.92,0,-34.05},{29.45,0,-36.02},
	{34.6,0,-37.11},{30.77,0,-38.88},
	{36.16,0,-39.72},{32.68,0,-42.22},
	{38.02,0,-42.94},{34.27,0,-44.87},
	{39.36,0,-46.46},{35.38,0,-47.56},
	{39.55,0,-50.69},{35.5,0,-50.05},
	{38.08,0,-54.57},{34.56,0,-52.43},
	{35.64,0,-57.58},{32.66,0,-54.61},
	{32.98,0,-59.96},{30.18,0,-56.75},
	{30.16,0,-62.15},{27.65,0,-58.75},
	{26.87,0,-64.0},{25.12,0,-60.25},
	{22.63,0,-64.79},{22.69,0,-60.68},
	{18.62,0,-64.02},{20.06,0,-60.11},
	{15.12,0,-61.81},{17.93,0,-58.72},
	{12.61,0,-59.02},{15.96,0,-56.39},
	{10.62,0,-56.38},{13.91,0,-53.66},
	{8.64,0,-53.97},{11.48,0,-50.92},
	{6.45,0,-52.5},{8.02,0,-48.71},
	{4.02,0,-52.02},{3.87,0,-47.88},
	{1.37,0,-52.51},{-0.11,0,-48.67},
	{-0.84,0,-53.84},{-3.67,0,-50.88},
	{-2.26,0,-55.83},{-6.08,0,-54.28},
	{-2.9,0,-58.55},{-7.09,0,-58.21},
	{-3.03,0,-61.72},{-7.28,0,-61.71},
	{-3.03,0,-64.97},{-7.28,0,-64.97},
	{-3.03,0,-68.35},{-7.28,0,-68.35},
	{-3.03,0,-71.74},{-7.28,0,-71.74},
	{-3.03,0,-75.13},{-7.28,0,-75.13},
	{-3.02,0,-78.71},{-7.25,0,-78.42},
	{-3.51,0,-82.71},{-7.38,0,-80.92},
	{-4.85,0,-86.25},{-8.04,0,-83.28},
	{-7.49,0,-89.25},{-9.56,0,-85.52},
	{-11.03,0,-91.12},{-11.88,0,-87.0},
	{-15.13,0,-91.52},{-14.71,0,-87.44},
	{-19.27,0,-90.16},{-17.58,0,-86.45},
	{-22.66,0,-87.28},{-19.79,0,-84.29},
	{-24.66,0,-83.67},{-20.86,0,-81.68},
	{-25.39,0,-80.41},{-21.2,0,-79.54},
	{-25.54,0,-76.71},{-21.27,0,-76.46},
	{-25.54,0,-73.29},{-21.29,0,-73.3},
	{-25.53,0,-69.86},{-21.29,0,-69.86},
	{-26.64,0,-66.45},{-21.27,0,-66.46},
	{-27.59,0,-63.09},{-21.28,0,-63.09},
	{-27.59,0,-59.8},{-21.3,0,-59.8},
	{-25.14,0,-56.38},{-21.3,0,-56.31},
	{-25.14,0,-52.25},{-21.31,0,-52.25}}


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
	return v
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
	scale=scale or 1
	return {-scale*a[3],0,scale*a[1]}
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

local cam=make_cam(2)
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

function make_track(segments,checkpoint)
	-- "close" track
	-- add(segments,segments[1])
	-- add(segments,segments[2])
	assert(#segments%2==0,"invalid number of track coordinates")
	local n=#segments/2
	-- active index
	checkpoint=checkpoint or 0
	local function to_v(i)
		i=i%n
		local l,r=segments[2*i+1],segments[2*i+2]
		-- center
		local c=v_clone(l)
		v_add(c,r)
		v_scale(c,0.5)
		-- normal
		return c,v2_ortho(make_v(l,r)),l,r
	end
	return {	
		-- returns any location after checkpoint
		-- +1: next boundary
		get_next=function(self,offset)
			offset=offset or 0
			return to_v(checkpoint+offset)
		end,
		-- current track segment
		get_current=function(self)
			return to_v(checkpoint)
		end,
		get_chkpoint=function(self)
			return checkpoint
		end,
		update=function(self,pos,dist)
			-- have we past end of current segment?
			local p,pn,l,r=to_v(checkpoint+1)
			if v_dot(make_v(l,pos),pn)>0 then
				checkpoint=(checkpoint+1)%n
			end
			return to_v(checkpoint)
		end,
		draw=function(self)
			local track_data=track_data
			for i=1,#track_data,2 do
				local l,r=track_data[i],track_data[i+1]
				local x0,y0=cam:project(l)
				local x1,y1=cam:project(r)
				local k=(i-1)/2
				color(checkpoint+1==k and 9 or 11)
				line(x0,y0,x1,y1)
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
	local rpm=0.6

	local body_draw,body_update=body.draw,body.update
	body.draw=function(self)
		local lookahead=rpm/0.6

		local v1,n1,l1,r1=track:get_next(flr(4*lookahead))
		local v2,n2,l2,r2=track:get_next(flr(4*lookahead)+1)
		local tgt=v_clone(l2)
		v_add(tgt,r2)
		v_scale(tgt,0.5)

		local x,y=cam:project(tgt)
		circfill(x,y,1,8)

		--[[
		local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))

		

		local x,y=cam:project(v2)
		circfill(x,y,1,8)

		local d1=v_dot(make_v(self.pos,v1),n1)
		local d2=v_dot(make_v(self.pos,v2),n2)
		local d=d1/(d1-d2)

		local ll=v_lerp(l1,l2,d)
		local rr=v_lerp(r1,r2,d)

		local lr=make_v(ll,rr)
		local ll1=v_clone(ll)
		v_add(ll1,lr,0)
		local x,y=cam:project(ll1)
		pset(x,y,8)
		
		v_add(ll,lr,1)
		local x,y=cam:project(ll)
		pset(x,y,2)	

		--print((len1/len2).."\n"..flr(4*(rpm/0.6)).."\n"..rpm.."\n"..track:get_chkpoint(),x+3,y,5)
		local dist=v_dist(self.pos,v2)
		local dot=v_dot(make_v(l2,self.pos),n2)
		]]
		local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
	
		local x,y=cam:project(self.pos)
		print(rpm.."\n"..(len1/len2),x+3,y,5)

		body_draw(self)
	end

	-- return world position p in local space (2d)
	function inv_apply(self,target)
		p=make_v(self.pos,target)
		local x,y,z,m=p[1],p[2],p[3],self.m
		return {m[1]*x+m[2]*y+m[3]*z,0,m[7]*x+m[8]*y+m[9]*z}
	end

	body.control=function(self)
		--[[
		local dx,dy=0,0
		if (btn(0)) dx=-1
		if (btn(1)) dx=1
		if (btn(2)) dy=1
		if (btn(3)) dy=-1
		local p=self.pos
		p[1]+=dx/4
		p[3]+=dy/4

		track:update(p,24)
		]]

		-- lookahead
		local fwd=m_fwd(self.m)
		-- force application point
		local p=v_clone(self.pos)
		v_add(p,fwd,3)

		-- curve: slow down
		local lookahead=rpm/0.6

		local v1,n1,l1,r1=track:get_next(flr(4*lookahead))
		local v2,n2,l2,r2=track:get_next(flr(4*lookahead)+1)
		local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
		if len1/len2<0.8 or len1/len2>1.2 then
			rpm=0.2
		else
			-- accelerate
			rpm+=0.1
		end
		
		-- default: steer to track
		local tgt=v_clone(l2)
		v_add(tgt,r2)
		v_scale(tgt,0.5)
		local target=inv_apply(self,tgt)
		local target_angle=atan2(target[1],target[3])

		-- shortest angle
		if(target_angle<0.5) target_angle=1-target_angle
		target_angle=0.75-target_angle
		rpm=self:steer(target_angle,rpm)
	end
	body.update=function(self)
		body_update(self)
		-- update track segment
		track:update(self.pos,24)
		rpm*=0.97
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
	for _,p in pairs(v) do
		v_scale(p,0.2)
	end

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
			steering_angle+=mid(steering_dt,-0.2,0.2)

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


local plyr--=make_plyr({-28,0,-33},0)

-- only for display
local static_track=make_track(track_data)
-- local static_track

function _init()
	add(actors,plyr)

	for i=1,12 do
		local npc_track=make_track(track_data,4*i)
		if(not static_track) static_track=npc_track
		local p=v_clone(npc_track:get_next(4*i))
		--p[1]+=(1-rnd(2))
		--p[3]+=(1-rnd(2))
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

	static_track:draw(npcs[1].pos)

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
