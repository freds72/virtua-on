pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- ocean
local track_data={
	{-26.65,0,-0.19},{-23.34,0,-0.19},
	{-26.72,0,2.8},{-23.61,0,2.8},
	{-26.6,0,6.06},{-23.6,0,6.06},
	{-26.6,0,10.06},{-23.6,0,10.06},
	{-26.6,0,14.06},{-23.6,0,14.06},
	{-26.6,0,18.06},{-23.6,0,18.06},
	{-26.6,0,22.06},{-23.6,0,22.06},
	{-26.6,0,26.06},{-23.6,0,26.06},
	{-26.6,0,30.06},{-23.6,0,30.06},
	{-26.6,0,34.06},{-23.6,0,34.06},
	{-26.6,0,38.06},{-23.6,0,38.06},
	{-26.6,0,42.06},{-23.6,0,42.06},
	{-26.6,0,46.06},{-23.6,0,46.06},
	{-26.6,0,50.06},{-23.6,0,50.06},
	{-26.6,0,54.06},{-23.6,0,54.06},
	{-26.6,0,58.06},{-23.6,0,58.06},
	{-26.6,0,62.06},{-23.6,0,62.06},
	{-26.61,0,65.3},{-23.61,0,65.3},
	{-26.7,0,68.29},{-23.45,0,68.25},
	{-26.66,0,70.82},{-23.43,0,70.58},
	{-26.46,0,73.25},{-23.29,0,72.61},
	{-25.94,0,75.75},{-22.9,0,74.64},
	{-25.3,0,77.44},{-22.43,0,75.99},
	{-24.38,0,79.12},{-21.74,0,77.29},
	{-23.21,0,80.66},{-20.86,0,78.47},
	{-21.82,0,81.96},{-19.81,0,79.45},
	{-20.26,0,83.0},{-18.63,0,80.23},
	{-18.57,0,83.78},{-17.36,0,80.8},
	{-16.82,0,84.32},{-16.06,0,81.19},
	{-14.18,0,84.67},{-14.07,0,81.45},
	{-11.46,0,84.58},{-11.78,0,81.36},
	{-8.53,0,84.14},{-8.89,0,81.16},
	{-5.75,0,83.58},{-6.59,0,80.72},
	{-3.02,0,82.64},{-4.38,0,80.0},
	{-0.52,0,81.25},{-2.27,0,78.84},
	{0.94,0,80.12},{-1.0,0,77.84},
	{2.83,0,78.2},{0.65,0,76.16},
	{4.52,0,76.16},{2.14,0,74.34},
	{5.98,0,74.12},{3.57,0,72.34},
	{7.29,0,72.02},{4.49,0,70.4},
	{8.37,0,69.79},{5.46,0,68.44},
	{9.15,0,68.52},{6.57,0,66.68},
	{10.2,0,67.46},{8.23,0,64.99},
	{11.43,0,66.69},{10.19,0,63.77},
	{12.74,0,66.22},{12.04,0,63.09},
	{14.44,0,65.7},{13.55,0,62.63},
	{16.33,0,64.83},{14.79,0,62.05},
	{18.07,0,63.47},{15.9,0,61.14},
	{19.52,0,61.68},{16.85,0,59.95},
	{20.5,0,59.82},{17.5,0,58.67},
	{21.0,0,58.18},{17.84,0,57.51},
	{21.27,0,55.93},{18.03,0,55.81},
	{21.28,0,53.46},{18.03,0,53.46},
	{21.41,0,50.88},{17.91,0,50.88},
	{21.41,0,47.88},{17.91,0,47.88},
	{21.41,0,44.88},{17.91,0,44.88},
	{21.41,0,41.88},{17.91,0,41.88},
	{21.41,0,38.88},{17.91,0,38.88},
	{21.41,0,35.88},{17.91,0,35.88},
	{21.41,0,31.88},{17.91,0,31.88},
	{21.41,0,28.88},{17.91,0,28.88},
	{21.41,0,25.88},{17.91,0,25.88},
	{21.41,0,22.88},{17.91,0,22.88},
	{21.41,0,19.88},{17.91,0,19.88},
	{21.41,0,16.88},{17.91,0,16.88},
	{21.41,0,13.88},{17.91,0,13.88},
	{21.29,0,10.88},{18.04,0,10.88},
	{21.29,0,7.9},{18.04,0,7.89},
	{21.31,0,5.14},{18.07,0,4.98},
	{21.5,0,2.74},{18.33,0,2.16},
	{21.86,0,1.36},{18.83,0,0.31},
	{22.5,0,0.11},{19.72,0,-1.48},
	{23.42,0,-1.02},{20.98,0,-3.15},
	{24.49,0,-2.07},{22.41,0,-4.61},
	{26.48,0,-3.58},{24.78,0,-6.41},
	{28.97,0,-5.06},{27.36,0,-7.92},
	{31.58,0,-6.54},{29.95,0,-9.37},
	{34.12,0,-8.1},{32.29,0,-10.77},
	{36.52,0,-10.0},{34.31,0,-12.34},
	{38.66,0,-12.54},{36.02,0,-14.33},
	{39.86,0,-14.59},{36.95,0,-15.86},
	{40.69,0,-16.77},{37.58,0,-17.5},
	{41.06,0,-19.0},{37.71,0,-19.22},
	{41.07,0,-21.31},{37.39,0,-20.96},
	{40.79,0,-23.61},{36.78,0,-22.71},
	{40.0,0,-26.69},{35.53,0,-25.27},
	{35.74,0,-28.48},{34.2,0,-27.98},
	{34.49,0,-31.23},{33.01,0,-30.77},
	{33.43,0,-34.04},{32.01,0,-33.59},
	{33.1,0,-35.52},{31.55,0,-35.03},
	{32.64,0,-36.96},{31.09,0,-36.48},
	{31.73,0,-39.84},{30.18,0,-39.38},
	{30.88,0,-42.86},{29.29,0,-42.55},
	{30.28,0,-46.05},{28.67,0,-45.93},
	{30.0,0,-49.18},{28.38,0,-49.16},
	{29.93,0,-52.18},{28.3,0,-52.16},
	{29.91,0,-54.43},{28.29,0,-54.36},
	{29.69,0,-56.55},{28.05,0,-56.07},
	{29.23,0,-57.98},{27.62,0,-57.12},
	{28.09,0,-59.52},{26.86,0,-58.14},
	{27.03,0,-60.34},{25.99,0,-58.89},
	{25.41,0,-61.06},{24.81,0,-59.5},
	{23.04,0,-61.56},{22.93,0,-59.94},
	{20.72,0,-61.64},{20.72,0,-59.98},
	{17.72,0,-61.65},{17.72,0,-60.04},
	{14.72,0,-64.39},{14.72,0,-60.3},
	{11.72,0,-64.39},{11.72,0,-60.77},
	{8.78,0,-64.38},{8.83,0,-61.24},
	{7.12,0,-64.29},{7.47,0,-61.36},
	{5.58,0,-63.9},{6.48,0,-61.27},
	{4.08,0,-63.09},{5.58,0,-60.97},
	{2.84,0,-61.9},{4.75,0,-60.41},
	{1.98,0,-60.35},{3.96,0,-59.48},
	{1.04,0,-57.59},{2.87,0,-57.03},
	{0.18,0,-54.94},{1.95,0,-54.21},
	{-0.5,0,-53.62},{1.15,0,-52.44},
	{-1.55,0,-52.49},{-0.17,0,-50.86},
	{-2.93,0,-51.63},{-2.04,0,-49.59},
	{-4.54,0,-51.19},{-4.3,0,-48.91},
	{-6.25,0,-51.24},{-6.71,0,-49.0},
	{-7.86,0,-51.81},{-9.01,0,-49.82},
	{-9.07,0,-53.27},{-11.82,0,-51.86},
	{-9.37,0,-54.46},{-12.94,0,-52.95},
	{-11.34,0,-56.76},{-14.13,0,-56.02},
	{-12.93,0,-59.43},{-14.82,0,-58.94},
	{-13.75,0,-62.33},{-15.56,0,-61.88},
	{-14.47,0,-65.24},{-16.28,0,-64.79},
	{-15.2,0,-68.16},{-17.0,0,-67.68},
	{-16.04,0,-71.04},{-17.77,0,-70.36},
	{-16.91,0,-72.77},{-18.46,0,-71.79},
	{-18.12,0,-74.33},{-19.42,0,-72.9},
	{-19.7,0,-75.68},{-20.68,0,-73.73},
	{-21.7,0,-76.61},{-22.14,0,-74.16},
	{-23.92,0,-76.94},{-23.66,0,-74.19},
	{-26.05,0,-76.64},{-25.09,0,-73.93},
	{-27.96,0,-75.72},{-26.44,0,-73.37},
	{-29.6,0,-74.31},{-27.71,0,-72.43},
	{-30.95,0,-72.7},{-28.94,0,-71.07},
	{-32.6,0,-70.13},{-30.74,0,-68.7},
	{-34.01,0,-67.31},{-32.25,0,-66.35},
	{-34.96,0,-64.32},{-33.14,0,-63.96},
	{-35.21,0,-61.31},{-33.36,0,-61.46},
	{-34.8,0,-58.32},{-32.98,0,-58.78},
	{-34.05,0,-55.39},{-32.23,0,-55.89},
	{-33.6,0,-53.5},{-31.72,0,-54.06},
	{-32.94,0,-51.84},{-31.16,0,-52.66},
	{-31.99,0,-50.25},{-30.35,0,-51.34},
	{-30.75,0,-48.74},{-29.25,0,-49.77},
	{-28.84,0,-46.39},{-27.52,0,-47.32},
	{-27.12,0,-43.93},{-25.79,0,-44.88},
	{-25.39,0,-41.48},{-24.06,0,-42.42},
	{-23.89,0,-39.05},{-22.47,0,-39.82},
	{-23.15,0,-37.42},{-21.64,0,-38.0},
	{-22.6,0,-35.78},{-21.03,0,-36.18},
	{-22.27,0,-34.13},{-20.66,0,-34.34},
	{-22.18,0,-32.41},{-20.56,0,-32.47},
	{-22.16,0,-29.51},{-20.54,0,-29.52},
	{-22.14,0,-26.51},{-20.52,0,-26.52},
	{-22.12,0,-23.51},{-20.5,0,-23.52},
	{-22.14,0,-20.51},{-20.48,0,-20.52},
	{-22.34,0,-17.51},{-20.43,0,-17.52},
	{-22.47,0,-14.19},{-20.32,0,-14.19},
	{-22.68,0,-11.19},{-20.45,0,-11.19},
	{-23.25,0,-8.19},{-20.97,0,-8.19},
	{-26.61,0,-5.19},{-21.77,0,-5.19},
	{-26.61,0,-2.19},{-22.79,0,-2.19}}

-- big forest
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

local cam=make_cam(12)
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

			local ll,rr=v_lerp(l0,l1,d),v_lerp(r0,r1,d)
			local v=make_v(ll,rr)
			track_v=v_dot(v,make_v(ll,pos))/v_dot(v,v)
			if correct then
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
		if btn(4) then
			rpm+=0.1
		end

		rpm=self:steer(da/8,rpm,btn(5))
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

function make_npc(p,angle,track,ai)	
	local body=make_car(p,angle,track)
	local rpm=0.6
	local pid=make_pid()

	local body_draw,body_update=body.draw,body.update
	body.draw=function(self)

		local x0,y0=cam:project(self.pos)

		--[[
		local lookahead,tgt=1
		local curve=0
		while lookahead<6 do
			local n1,l1,r1=track:get_next(lookahead)
			local n2,l2,r2=track:get_next(lookahead+1)
			local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
			curve+=abs(1-len1/len2)
			-- find track target point based on curvature		
			tgt=v_lerp(l2,r2,mid(0.5*len1/len2,0.2,0.8))
			
			-- intersect?
			n1=make_v(r1,l1)
			local v=v_normz(make_v(self.pos,tgt))
			local t=v2_cross(make_v(self.pos,l1),v)/v2_cross(n1,v)

			local x1,y1=cam:project(tgt)
			if t>0.8 or t<0.2 then
				line(x0,y0,x1,y1,8)
				break
			end
			line(x0,y0,x1,y1,11)

			lookahead+=1
		end
		]]

		local s=ai.."\n"..rpm
		if self.curve then
			s=s.."\nc:"..self.curve
		end
		print(s,x0+3,y0,5)

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
		local lookahead,tgt=1
		local curve=0
		while lookahead<5 do
			local n1,l1,r1=track:get_next(lookahead)
			local n2,l2,r2=track:get_next(lookahead+1)
			local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
			-- accumulate "curvature"
			curve+=abs(1-len1/len2)
			-- find track target point based on curvature		
			tgt=v_lerp(l2,r2,mid(0.5*len1/len2,0.2,0.8))
			
			-- intersect?
			n1=make_v(r1,l1)
			local v=v_normz(make_v(self.pos,tgt))
			local t=v2_cross(make_v(self.pos,l1),v)/v2_cross(n1,v)
			if t>0.8 or t<0.2 then
				break
			end
			lookahead+=1
		end
		
		-- default: steer to track
		--local target=inv_apply(self,tgt)
		local target_angle=self:angle_to(tgt)--atan2(target[1],target[3])
		-- ortho angle + pid
		target_angle=pid(0,0.75-target_angle,1/30)
		self.target_angle=target_angle

		local brake
		--[[
		if abs(target_angle)>lerp(0.08,0.005,curve/2) then
			brake=true
			-- rpm=0.1
			-- rpm=max(0.2,rpm-0.05)
		else
			-- accelerate
		end
		]]
		if ai==1 then			
			if abs(target_angle)>0.12 then
				brake=true
			end
			rpm=0.6--*lerp(0.8,1,lookahead/5)
		elseif ai==2 then
			if abs(target_angle)>0.18 then
				brake=true
			end
			rpm=0.6*abs(1-curve/2)*lerp(0.8,1,lookahead/5)
		elseif ai==3 then
			curve=0
			for i=1,3 do
				local n1,l1,r1=track:get_next(i)
				local n2,l2,r2=track:get_next(i+1)
				local len1,len2=v_len(make_v(l1,l2)),v_len(make_v(r1,r2))
				-- accumulate "curvature"
				curve+=abs(1-len1/len2)
			end
			self.curve=curve
		
			if abs(target_angle)>0.2 or curve>1.6 then
				brake=true
			else
				rpm=0.6
			end
		elseif ai==4 then
			self.curve=curve
			if abs(target_angle)>0.12 then
				brake=true
			else
				rpm=0.6*lerp(0.8,1,1-curve/1.2)
			end
		end

		-- heavy curve ahead?
		--[[
		if abs(len1/len2)<0.8 or abs(len1/len2)>1.2 then
			len1,len2=0,0
			for i=lookahead,lookahead+5 do
				local n1,l1,r1=track:get_next(i)
				local n2,l2,r2=track:get_next(i+1)
				len1+=v_len(make_v(l1,l2))
				len2+=v_len(make_v(r1,r2))
			end
			if abs(len1/len2)<0.8 or abs(len1/len2)>1.2 then
				brake=true
				rpm=max(0.1,rpm-0.05)
			end
		end
		]]


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

		
		-- self.tgt_angle=pid(0,target_angle,1/30)
		rpm=self:steer(target_angle,rpm,brake)
	end
	body.update=function(self)
		body_update(self)
		rpm*=0.92
	end
	return body
end

function make_car(p,angle,track,fix_pos)
	local velocity,angularv={0,0,0},0
	local forces,torque={0,0,0},0

	local is_braking=false
	local max_rpm=0.6
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
		track=track,
		pos=v_clone(p),
		m=make_m_from_euler(0,a,0),
		-- obj to world space
		apply=function(self,p)
			return v_add(m_x_v(self.m,p),self.pos)
		end,
		get_velocity=function() return velocity end,
		draw=function(self)	
			color(is_braking==true and 8 or 7)
			local x0,y0=cam:project(self:apply(v[#v]))
			for i=1,#v do
				local x1,y1=cam:project(self:apply(v[i]))
				line(x0,y0,x1,y1)
				x0,y0=x1,y1			
			end
			--[[
			for _,offset in pairs(contact_offsets) do
				local x0,y0=cam:project(self:apply({0,0,offset}))
				circfill(x0,y0,2,8)
			end
			]]
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
		steer=function(self,steering_dt,rpm,brake)
			is_braking=brake==true
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
			--[[
			-- ???
			if rps>10 then
				rpm*=lerp(0.9,1,effective_rps/rps)
			end
			]]
			
			if is_braking then
				v_scale(velocity,0.9)
				--fwd=v_add(fwd,fwd,-0.9*v_dot(fwd,fwd))
			end
			v_scale(fwd,rpm*sr)		
			
			self:apply_force_and_torque(fwd,-steering_angle*lerp(0,1,rpm/max_rpm))

			-- rear wheels sliding?
			rear_slide=not full_slide and rps>10 and effective_rps/rps<0.6

			return min(rpm,max_rpm)
		end,
		update=function(self)
			steering_angle*=0.8
			-- correct position
			track:update(self.pos,m_fwd(self.m),fix_pos)
		end,
		angle_to=function(self,tgt)
			local a=(atan2(tgt[1]-self.pos[1],tgt[3]-self.pos[3])-angle)%1
			if(a<0.5) a=1-a
			return a
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

	for i=1,4 do
		local npc_track=make_track(fixed_tracks,1)
		if(not static_track) static_track=npc_track
		local _,l,r=npc_track:get_next()
		l=v_add(l,r)
		v_scale(l,0.5)
		add(actors,add(npcs, make_npc(l,0,npc_track,i)))
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
