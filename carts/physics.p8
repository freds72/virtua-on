pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

local track_data={
	{-30.45,0,-48.38},{-21.31,0,-48.38},
	{-30.45,0,-44.44},{-21.31,0,-44.44},
	{-30.45,0,-40.5},{-21.31,0,-40.5},
	{-30.45,0,-36.56},{-21.31,0,-36.56},
	{-30.44,0,-32.6},{-21.31,0,-32.6},
	{-30.44,0,-28.66},{-21.31,0,-28.66},
	{-30.44,0,-24.72},{-21.31,0,-24.72},
	{-30.44,0,-20.79},{-21.31,0,-20.79},
	{-30.44,0,-16.85},{-21.31,0,-16.85},
	{-29.88,0,-12.91},{-21.31,0,-12.91},
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
	{-28.13,0,-56.42},{-21.3,0,-56.31},
	{-29.82,0,-52.25},{-21.31,0,-52.25}}

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

local cam=make_cam(6)
function make_skidmarks()
	local skidmarks={}
	local t=0
	return {
		make_emitter=function()
			local emit_t=0
			local last_skidmark
			return function(pos)
				-- broken skidmark?
				if emit_t!=t then
					last_skidmark=nil
				end
				if(not last_skidmark) last_skidmark=add(skidmarks,{head=v_clone(pos),tail=v_clone(pos),ttl=0})
 				-- next expected update
				emit_t=t+1
				if emit_t>0 and emit_t%10==0 then
					last_skidmark=add(skidmarks,{head=v_clone(pos),tail=last_skidmark.head,ttl=0})
				else
					last_skidmark.head=v_clone(pos)
				end
			end
		end,
		update=function(self)
			t+=1
			for s in all(skidmarks) do
				s.ttl+=1
				if(s.ttl>60) del(skidmarks,s)
			end
		end,
		draw=function(self)
			for _,s in pairs(skidmarks) do
				local x0,y0=cam:project(s.head)
				local x1,y1=cam:project(s.tail)
				line(x0,y0,x1,y1,5)
			end
		end
	}
end
local skidmarks=make_skidmarks()

function make_track(segments,checkpoint)
	local n=#segments/3
	-- active index
	checkpoint=checkpoint or 0
	-- track coordinates
	-- track_u: absolute distance on track
	-- track_v: dot product on track segment
	local track_u,track_v=checkpoint,0

	local function to_v(i)
		i=i%n
		return segments[3*i+1],segments[3*i+2],segments[3*i+3]
	end
	-- starting quad
	local n0,l0,r0=to_v(checkpoint)
	local n1,l1,r1=to_v(checkpoint+1)
	local prev_pos
	local function next()
		checkpoint+=1
		n0,l0,r0=n1,l1,r1
		n1,l1,r1=to_v(checkpoint+1)	
		-- 'flat segment'
		if (abs(v_dot(make_v(l0,l1),n0))<0.001 or abs(v_dot(make_v(l0,r1),n0))<0.001) next()
	end
	local function prev()
		-- going backward!!
		checkpoint-=1
		n1,l1,r1=n0,l0,r0
		n0,l0,r0=to_v(checkpoint)
		-- 'flat segment'
		if (abs(v_dot(make_v(l0,l1),n0))<0.001 or abs(v_dot(make_v(l0,r1),n0))<0.001) prev()
	end
	local function get_d(pos)
		local d0=v_dot(make_v(pos,l0),n0)
		return d0/(d0-v_dot(make_v(pos,l1),n1))
	end

	local function draw_border(offset)
		local segments=segments
		local t0=segments[#segments+offset-1]
		local x0,y0=cam:project(t0)
		for i=1,#segments,3 do
			local t1=segments[i+offset+1]
			local x1,y1=cam:project(t1)
			local k=(i-1)/3
			color((checkpoint+1)%n==k and 9 or 11)
			line(x0,y0,x1,y1)
			x0,y0=x1,y1
		end
	end

	return {
		-- have we past given segment index
		gt=function(self,laps,i)
			return track_u>laps*n+i
		end,	
		-- returns location after checkpoint
		-- 0: current checkpoint
		-- +1: next boundary
		get_next=function(self,offset)
			offset=offset or 0
			return to_v(checkpoint+offset)
		end,
		update=function(self,pos,fwd,correct)
			-- have we past end of current segment?
			local d,segment=get_d(pos),checkpoint
			local forward
			if d>1 then
				next()
				forward=true
			elseif d<0 then
				prev()
			end
			-- refresh d
			d=get_d(pos)
			track_u=checkpoint+(d%1)

			if correct then
				local ll,rr=v_lerp(l0,l1,d),v_lerp(r0,r1,d)
				local v=make_v(ll,rr)
				track_v=v_dot(v,make_v(ll,pos))/v_dot(v,v)
				-- invalid position & discontinuity
				if (track_v<0 or track_v>1) and abs(segment-checkpoint)>1 then
					-- back to 'safe' place
					local n,l,r
					if forward then
						prev()
						n,l,r=n1,l1,r1
					else
						next()
						n,l,r=n0,l0,r0
					end
					-- line intersection
					local t=-v_dot(make_v(l,prev_pos),n)/v_dot(fwd,n)
					local fixed_pos=v_add(prev_pos,fwd,0.95*t)
					pos[1],pos[3]=fixed_pos[1],fixed_pos[3]

					-- side pos
					d=get_d(pos)
					local ll,rr=v_lerp(l0,l1,d),v_lerp(r0,r1,d)			
					local v=make_v(ll,rr)
					track_v=v_dot(v,make_v(ll,pos))/v_dot(v,v)
				end
				-- keep within track
				if track_v>1 then
					pos[1],pos[3]=rr[1],rr[3]
				elseif track_v<0 then
					pos[1],pos[3]=ll[1],ll[3]
				end
				-- for collision
				prev_pos=pos
			end

			-- refresh d
			d=get_d(pos)
			track_u=checkpoint+(d%1)
			
			return to_v(checkpoint),checkpoint
		end,
		-- mod: modulo or not
		get_u=function(self,mod)
			return mod and track_u%n or track_u
		end,
		get_v=function(self)
			return track_v
		end,
		draw=function(self)
			draw_border(0)
			draw_border(1)

			if prev_pos then
				local x0,y0=cam:project(prev_pos)
				circfill(x0,y0,2,11)
			end
		end
	}
end

function make_checkpoints(checkpoints,track)
	-- active index
	local checkpoint,n=0,#checkpoints
	
	-- previous laps
	local laps={}

	-- remaining time before game over (+ some buffer time)
	local lap_t,remaining_t,best_t,best_i=0,30*30,32000,1
	return {	
		update=function(self,pos,fwd)
			remaining_t-=1
			if remaining_t==0 then
				-- next_state(gameover_state)
				return
			end
			lap_t+=1
			if track:gt(#laps,checkpoints[checkpoint+1]) then
				checkpoint+=1
				remaining_t+=30*30
				-- closed lap?
				if checkpoint==#checkpoints then
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
			local u0,u1=flr(track:get_u()),#laps*125+checkpoints[checkpoint+1]
			if u0==u1 then
				local _,l,r=track:get_next()
				local x0,y0=cam:project(l)
				local x1,y1=cam:project(r)
				line(x0,y0,x1,y1,8)
			end

			print("time",56,2,7)
			print(ceil(remaining_t/30).."\n"..u0..">"..u1.."\n"..checkpoint.."/"..#checkpoints,60,10,10)

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
	local x1,y1=cam:project(v_add(p,f))
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

function make_plyr(p,a,track)
	local rpm=0

	local body=make_car(p,a,track,true)
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
	local _update=body.update
	body.update=function(self)
		_update(self)
		rpm*=0.97		
	end
	-- wrapper
	return body
end

local npcs={}
local actors={}

function make_npc(p,angle,track)	
	local body=make_car(p,angle,track)
	local rpm=0.6

	local body_draw,body_update=body.draw,body.update
	body.draw=function(self)
		local lookahead=rpm/0.6

		local n1,l1,r1=track:get_next(flr(1*lookahead))
		local n2,l2,r2=track:get_next(flr(1*lookahead)+1)
		local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
		local tgt=v_lerp(l2,r2,mid(0.5*len1/len2,0.2,0.8))

		local x,y=cam:project(tgt)
		circfill(x,y,1,8)

		local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
	
		local x,y=cam:project(self.pos)
		print(rpm.."\n"..track:get_u(),x+3,y,5)

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

		local fwd=m_fwd(self.m)
		-- lookahead
		-- curve: slow down
		-- 5 ok
		local lookahead=flr(2*rpm/0.6)+1

		local n1,l1,r1=track:get_next(lookahead)
		local n2,l2,r2=track:get_next(lookahead+1)
		local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
		-- find track target point based on curvature		
		local tgt=v_lerp(l2,r2,mid(0.5*len1/len2,0.2,0.8))
		local curve=v_dot(fwd,v_normz(make_v(self.pos,v_lerp(l2,r2,mid(0.5*len1/len2,0.2,0.8)))))
		if curve<0.95 then
			rpm=max(0.1,rpm-0.01)
		else
			-- accelerate
			rpm+=0.05
		end
		
		-- default: steer to track
		local target=inv_apply(self,tgt)
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
						add(debug_vectors,{f=axis_bck,p=self.pos,c=4,scale=sep})

						local local_pos=inv_apply(self,actor.pos)
						-- in front?
						-- in path?
						if local_pos[3]>0 and abs(local_pos[1])<2 then
							local escape_axis=v2_ortho(axis,1)
							local_pos[1]+=1/v_dot(relv,escape_axis)
							target_angle=atan2(local_pos[1],local_pos[3])
							rpm=max(0.1,rpm-0.01)

							add(debug_vectors,{f=make_v(self.pos,self:apply(local_pos)),p=self.pos,c=8,scale=target_angle})
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
		rpm=self:steer(4*target_angle,rpm)
	end
	body.update=function(self)
		body_update(self)
		rpm*=0.86
	end
	return body
end

function make_car(p,angle,track,fix_pos)
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

	local full_slide,rear_slide=false,false
	local skidmark_emitters={
		skidmarks:make_emitter(),
		skidmarks:make_emitter(),
		skidmarks:make_emitter(),
		skidmarks:make_emitter()
	}

	local contact_offsets={0.250,-0.250}
	return {
		pos=v_clone(p),
		m=make_m_from_euler(0,a,0),
		-- obj to world space
		apply=function(self,p)
			return v_add(m_x_v(self.m,p),self.pos)
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
			for _,offset in pairs(contact_offsets) do
				local x0,y0=cam:project(self:apply({0,0,offset}))
				circfill(x0,y0,2,8)
			end
		end,		
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
			v_scale(velocity,lerp(0.97,0.8,min(sliding_t,30)/30))
			-- some friction
			-- v_add(velocity,velocity,-0.02*v_dot(velocity,velocity))
		end,
		update_contacts=function(self,actors)
			local fwd=m_fwd(self.m)
			for _,offset in pairs(contact_offsets) do
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
								add(debug_vectors,{f=axis,p=pos,c=4,scale=(0.5-depth)/0.5})
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
				for i,a in pairs(v) do
					skidmark_emitters[i](self:apply(a))
				end	
			elseif rear_slide==true then
				skidmark_emitters[3](self:apply(v[3]))
				skidmark_emitters[4](self:apply(v[4]))			
			end
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
			-- slipping?
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
		update=function(self)
			steering_angle*=0.8
			-- correct position
			track:update(self.pos,m_fwd(self.m),fix_pos)
		end
	}	
end


-- only for display
local static_track
-- local static_track

local plyr_track
local checkpoints

local plyr

function _init()
	local fixed_tracks={}
	-- caclulate normals
	for i=1,#track_data,2 do
		local l0,r0=track_data[i],track_data[i+1]
		local n=v_normz(v2_ortho(make_v(l0,r0)))
		printh(n[1]..","..n[2]..","..n[3])
		add(fixed_tracks,n)
		add(fixed_tracks,l0)
		add(fixed_tracks,r0)
	end
	
	-- only for display
	static_track=make_track(fixed_tracks)
	-- local static_track

	plyr_track=make_track(fixed_tracks,2)
	checkpoints=make_checkpoints({48,90,125},plyr_track)

	local n,l,r=plyr_track:get_next()
	l=v_add(l,r)
	v_scale(l,0.5)
	plyr=make_plyr(l,0,plyr_track)

	add(actors,plyr)

	for i=1,8 do
		local npc_track=make_track(fixed_tracks,2*i)
		if(not static_track) static_track=npc_track
		local _,l,r=npc_track:get_next()
		l=v_add(l,r)
		v_scale(l,0.5)
		--p[1]+=(1-rnd(2))
		--p[3]+=(1-rnd(2))
		add(actors,add(npcs, make_npc(l,0,npc_track)))
	end
end

function _update()
	debug_vectors={}

	if plyr then
		plyr:control()
		plyr:update_contacts(npcs)
		plyr:prepare()
		plyr:integrate()	
		plyr:update()

		checkpoints:update()
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

	plyr_track:draw()

	skidmarks:draw()

	for _,npc in pairs(npcs) do
		npc:draw()
	end

	draw_debug_vectors()

	checkpoints:draw()

	if(plyr) print(plyr:get_speed().."km/h",2,2,7)
	local v=plyr_track:get_u()
	print(v,2,8,7)

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
