pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- track data
local track_data={
    0.003423452377319336,-0.8233218193054199,
    -0.00750182569026947,1.408806562423706,
    -0.015942636877298355,7.273656845092773,
    -0.02266291156411171,16.05294418334961,
    -0.028426576405763626,27.028385162353516,
    -0.033997561782598495,39.48169708251953,
    -0.04013979807496071,52.6945915222168,
    -0.04761721193790436,65.94879150390625,
    -0.057193733751773834,78.5260009765625,
    -0.06963329017162323,89.70794677734375,
    -0.08569981157779694,98.7763442993164,
    -0.10615722835063934,105.01290130615234,
    -0.13176947832107544,107.69934844970703,
    -0.14917249977588654,108.08627319335938,
    -0.16799107193946838,108.51656341552734,
    -0.18442633748054504,108.98794555664062,
    -0.19467942416667938,109.49815368652344,
    -0.19495145976543427,110.04491424560547,
    -0.18144357204437256,110.62596130371094,
    -0.15035690367221832,111.23902893066406,
    -0.09789258986711502,111.88184356689453,
    -0.02025175839662552,112.55213928222656,
    0.08636445552110672,113.24764251708984,
    0.22575491666793823,113.9660873413086,
    0.40171849727630615,114.70520782470703,
    0.5919525027275085,115.29144287109375,
    0.8592574000358582,115.88920593261719,
    1.2015643119812012,116.49186706542969,
    1.6168042421340942,117.09281158447266,
    2.1029083728790283,117.68540954589844,
    2.6578075885772705,118.26303100585938,
    3.279433250427246,118.81906127929688,
    3.9657163619995117,119.34686279296875,
    4.714587688446045,119.8398208618164,
    5.5239787101745605,120.29130554199219,
    6.391820430755615,120.69469451904297,
    7.316043853759766,121.04335021972656,
    8.49157428741455,121.39641571044922,
    9.653693199157715,121.67179870605469,
    10.787847518920898,121.87805938720703,
    11.87948226928711,122.02375793457031,
    12.914044380187988,122.11744689941406,
    13.87697982788086,122.16767883300781,
    14.753734588623047,122.18301391601562,
    15.529754638671875,122.17200469970703,
    16.190486907958984,122.1432113647461,
    16.721376419067383,122.10518646240234,
    17.10787010192871,122.06649017333984,
    17.335412979125977,122.0356674194336,
    17.33541488647461,122.03568267822266,
    18.644695281982422,121.79000854492188,
    20.922693252563477,121.33577728271484,
    23.96539306640625,120.71621704101562,
    27.568782806396484,119.97455596923828,
    31.52884864807129,119.1540298461914,
    35.641578674316406,118.29785919189453,
    39.70295715332031,117.44927978515625,
    43.50897216796875,116.65151977539062,
    46.85560989379883,115.94780731201172,
    49.538856506347656,115.3813705444336,
    51.354698181152344,114.99543762207031,
    52.09912109375,114.83324432373047,
    52.09911346435547,114.8332290649414,
    52.79449462890625,114.63095092773438,
    53.44546127319336,114.3951644897461,
    54.049957275390625,114.1334228515625,
    54.605934143066406,113.85328674316406,
    55.1113395690918,113.56230163574219,
    55.56412124633789,113.26802825927734,
    55.96222686767578,112.97801208496094,
    56.30360412597656,112.69981384277344,
    56.58620071411133,112.44097900390625,
    56.80796432495117,112.20906829833984,
    56.96684646606445,112.01162719726562,
    57.060791015625,111.85621643066406,
    57.06078338623047,111.8562240600586,
    57.37055587768555,111.15308380126953,
    57.665096282958984,110.4271011352539,
    57.94255065917969,109.69190979003906,
    58.201072692871094,108.96113586425781,
    58.43880844116211,108.2484130859375,
    58.653907775878906,107.56737518310547,
    58.84452438354492,106.93165588378906,
    59.00880432128906,106.3548812866211,
    59.1448974609375,105.8506851196289,
    59.250953674316406,105.43270111083984,
    59.32512283325195,105.11455535888672,
    59.36555862426758,104.9098892211914,
    59.500308990478516,104.05921936035156,
    59.623382568359375,103.26617431640625,
    59.73515319824219,102.53150177001953,
    59.83599090576172,101.8559341430664,
    59.92626953125,101.2402114868164,
    60.00636291503906,100.68506622314453,
    60.07664108276367,100.19124603271484,
    60.13747787475586,99.75948333740234,
    60.189247131347656,99.39051818847656,
    60.23231887817383,99.08509063720703,
    60.26707077026367,98.84393310546875,
    60.29387283325195,98.66778564453125,
    60.50858688354492,97.45680236816406,
    60.85136032104492,95.66230773925781,
    61.29228210449219,93.40426635742188,
    61.80144500732422,90.80264282226562,
    62.348941802978516,87.97740173339844,
    62.90486145019531,85.04850006103516,
    63.43929672241211,82.13590240478516,
    63.922340393066406,79.35957336425781,
    64.32408142089844,76.8394775390625,
    64.61461639404297,74.6955795288086,
    64.76403045654297,73.04783630371094,
    64.74241638183594,72.01622009277344,
    64.74241638183594,72.0162353515625,
    64.3806381225586,70.82390594482422,
    63.64656066894531,69.08358001708984,
    62.61602783203125,66.9173355102539,
    61.364891052246094,64.44725799560547,
    59.968997955322266,61.7954216003418,
    58.50419616699219,59.08390808105469,
    57.04633712768555,56.43479537963867,
    55.671268463134766,53.97016525268555,
    54.45484161376953,51.812095642089844,
    53.472900390625,50.08266830444336,
    52.801300048828125,48.903961181640625,
    52.51588821411133,48.39805603027344,
    52.017948150634766,47.48622131347656,
    51.494407653808594,46.601436614990234,
    50.95597457885742,45.743797302246094,
    50.413352966308594,44.91339111328125,
    49.87725067138672,44.110313415527344,
    49.358375549316406,43.33465576171875,
    48.867435455322266,42.58651351928711,
    48.41513442993164,41.86597442626953,
    48.012176513671875,41.173133850097656,
    47.669273376464844,40.50808334350586,
    47.397125244140625,39.870914459228516,
    47.20643997192383,39.26171875,
    46.95207977294922,38.245086669921875,
    46.71001434326172,37.27741241455078,
    46.49042892456055,36.3458251953125,
    46.30350875854492,35.43744659423828,
    46.15943908691406,34.53940963745117,
    46.06840515136719,33.63883590698242,
    46.04059600830078,32.72285461425781,
    46.08619689941406,31.77859115600586,
    46.215396881103516,30.793174743652344,
    46.43838119506836,29.75373077392578,
    46.76533508300781,28.647384643554688,
    47.20643997192383,27.46126365661621,
    47.875755310058594,25.88836669921875,
    48.797584533691406,23.816814422607422,
    49.91316604614258,21.3653621673584,
    51.163734436035156,18.65276527404785,
    52.49052810668945,15.797779083251953,
    53.834781646728516,12.919158935546875,
    55.13772964477539,10.135660171508789,
    56.34061050415039,7.566038131713867,
    57.38465881347656,5.329048156738281,
    58.21110916137695,3.5434460639953613,
    58.761199951171875,2.3279871940612793,
    58.976165771484375,1.801426887512207,
    58.976165771484375,1.8014230728149414,
    59.0841064453125,0.9956315159797668,
    59.09437942504883,0.23840004205703735,
    59.022193908691406,-0.4679507613182068,
    58.88275146484375,-1.1211004257202148,
    58.691261291503906,-1.7187283039093018,
    58.462928771972656,-2.2585136890411377,
    58.21295928955078,-2.7381362915039062,
    57.95655822753906,-3.155275344848633,
    57.70893096923828,-3.507610321044922,
    57.485286712646484,-3.792820453643799,
    57.30082702636719,-4.008585453033447,
    57.17076110839844,-4.152584552764893,
    57.170753479003906,-4.152584552764893,
    56.34944534301758,-5.045573711395264,
    55.499839782714844,-5.9410247802734375,
    54.61917495727539,-6.824410915374756,
    53.70469284057617,-7.681206703186035,
    52.75363540649414,-8.496885299682617,
    51.763240814208984,-9.25692081451416,
    50.73074722290039,-9.94678783416748,
    49.65339660644531,-10.551959037780762,
    48.52842712402344,-11.05790901184082,
    47.35307693481445,-11.450111389160156,
    46.12458801269531,-11.714040756225586,
    44.84020233154297,-11.83517074584961,
    44.84020233154297,-11.835173606872559,
    43.10118103027344,-11.852635383605957,
    41.588645935058594,-11.777039527893066,
    40.2765998840332,-11.607239723205566,
    39.1390495300293,-11.342089653015137,
    38.14999771118164,-10.98044204711914,
    37.283451080322266,-10.521151542663574,
    36.5134162902832,-9.9630708694458,
    35.81389617919922,-9.3050537109375,
    35.158897399902344,-8.545953750610352,
    34.522422790527344,-7.684624671936035,
    33.87847900390625,-6.719919681549072,
    33.201072692871094,-5.650691986083984,
    33.201080322265625,-5.650691986083984,
    32.501522064208984,-4.692358493804932,
    31.686267852783203,-3.8524506092071533,
    30.76951789855957,-3.133220911026001,
    29.765470504760742,-2.5369224548339844,
    28.688325881958008,-2.0658082962036133,
    27.552284240722656,-1.722131371498108,
    26.371543884277344,-1.5081446170806885,
    25.160303115844727,-1.4261009693145752,
    23.932762145996094,-1.4782533645629883,
    22.703121185302734,-1.666854739189148,
    21.485578536987305,-1.9941580295562744,
    20.29433250427246,-2.462416410446167,
    19.29560089111328,-3.1080594062805176,
    18.469558715820312,-4.018702507019043,
    17.801021575927734,-5.1585774421691895,
    17.274810791015625,-6.491916656494141,
    16.875741958618164,-7.98295259475708,
    16.588634490966797,-9.595916748046875,
    16.398305892944336,-11.295042037963867,
    16.289575576782227,-13.044560432434082,
    16.24726104736328,-14.808704376220703,
    16.256179809570312,-16.551706314086914,
    16.301151275634766,-18.237796783447266,
    16.366992950439453,-19.83121109008789,
    16.463245391845703,-21.006418228149414,
    16.624893188476562,-22.142587661743164,
    16.82807159423828,-23.251192092895508,
    17.048919677734375,-24.34370231628418,
    17.263572692871094,-25.43159294128418,
    17.448169708251953,-26.526334762573242,
    17.578847885131836,-27.639400482177734,
    17.631744384765625,-28.782262802124023,
    17.58299446105957,-29.966394424438477,
    17.408737182617188,-31.20326805114746,
    17.08510971069336,-32.504356384277344,
    16.5882511138916,-33.88113021850586,
    15.892364501953125,-35.30707931518555,
    15.113983154296875,-36.48367691040039,
    14.268040657043457,-37.433345794677734,
    13.369471549987793,-38.17850875854492,
    12.433209419250488,-38.741580963134766,
    11.474189758300781,-39.14498519897461,
    10.507346153259277,-39.41114044189453,
    9.547613143920898,-39.562469482421875,
    8.60992431640625,-39.62139129638672,
    7.70921516418457,-39.61032485961914,
    6.860419273376465,-39.55168914794922,
    6.0784711837768555,-39.4679069519043,
    4.536423683166504,-39.18889617919922,
    3.2466373443603516,-38.76240921020508,
    2.1851110458374023,-38.20315170288086,
    1.3278437852859497,-37.52583312988281,
    0.6508342623710632,-36.74515914916992,
    0.13008135557174683,-35.87583541870117,
    -0.2584161162376404,-34.93257141113281,
    -0.5386593341827393,-33.93007278442383,
    -0.7346494197845459,-32.88304901123047,
    -0.8703875541687012,-31.80620574951172,
    -0.969874918460846,-30.714252471923828,
    -1.057112693786621,-29.62189483642578,
    -1.0571155548095703,-29.62190055847168,
    -1.1406508684158325,-28.30164909362793,
    -1.1857151985168457,-26.90623664855957,
    -1.1977847814559937,-25.453792572021484,
    -1.1823358535766602,-23.96244239807129,
    -1.144844651222229,-22.4503116607666,
    -1.090787410736084,-20.935529708862305,
    -1.0256404876708984,-19.436222076416016,
    -0.9548799991607666,-17.970516204833984,
    -0.883982241153717,-16.55653953552246,
    -0.8184234499931335,-15.212418556213379,
    -0.7636798620223999,-13.956280708312988,
    -0.7252277731895447,-12.806253433227539,
    -0.68132084608078,-11.504036903381348,
    -0.6198762059211731,-10.191423416137695,
    -0.5452380776405334,-8.888093948364258,
    -0.4617505967617035,-7.613729476928711,
    -0.3737579584121704,-6.388011932373047,
    -0.2856043577194214,-5.230622291564941,
    -0.20163396000862122,-4.16124153137207,
    -0.12619096040725708,-3.199551582336426,
    -0.06361953169107437,-2.3652331829071045,
    -0.01826385036110878,-1.6779677867889404,
    0.0055319033563137054,-1.1574366092681885,
    0.003423549234867096,-0.8233208656311035
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
		end
	}
end

local cam=make_cam(2)

function make_skidmarks()
	local t,skidmarks=0,{}
	return {
		add=function(self,pos)
			if t==0 then
			 t=20
				if #skidmarks>=20 then
				 for i=2,#skidmarks do
				 	skidmarks[i-1]=skidmarks[i]
				 end
				 skidmarks[20]=nil
				end
				add(skidmarks,v_clone(pos))
			end
		end,
		update=function(self)
			t-=1			
		end,
		draw=function(self)
			if(#skidmarks<2) return
			local x0,y0=cam:project(skidmarks[1])
			
			for i=2,#skidmarks do
				local x1,y1=cam:project(skidmarks[i])
				line(x0,y0,x1,y1,5)
				x0,y0=x1,y1
			end
		end
	}
end

function make_track(segments)
	-- "close" track
	-- add(segments,segments[1])
	-- add(segments,segments[2])
	assert(#segments%2==0,"invalid number of track coordinates")
	local n=#segments/2
	-- active index
	local checkpoint=0
	function to_v(i)
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
			for i=0,n-1 do
				local x,y=cam:project(to_v(i))
				pset(x,y,11)
			end
			local x,y=cam:project(to_v(checkpoint))
			circfill(x,y,1,8)
		end
	}
end
 
function make_plyr(p,a,density)
	local steering_angle,angle,angularv,rpm,max_rpm=0,a,0,0,96	
	local skidmarks={
		make_skidmarks(),
		make_skidmarks()
	}
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

	local add_tireforce=function(self,offset,right,fwd,brake,id,rpm)		
		-- application point (world space)
		local pos,slide=v_clone(self.pos),false
		v_add(pos,m_fwd(self.m),offset)
		
		-- point velocity
		local relv=self:pt_velocity(pos)
		local relv_len=v_dot(relv,relv)
		-- avoid noise
		if relv_len>0.01 then
			local sa=v_dot(relv,right)
			v_scale(right,sa)
			-- slide
			if abs(sa)>3 then
				slide=true
			end
			self:apply_impulse(right,pos)			
		end

		if rpm then
			-- slide?
			if v_dot(relv,fwd)<0.8 then
				slide=true
			end
			v_scale(fwd,10*rpm)
			self:apply_force(fwd,pos)
		end
	
		if slide==true then
		 --
			skidmarks[id]:add(pos)
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
		draw_vector=function(self,f,p,c)
			local x0,y0=cam:project(p)
			p=v_clone(p)
			v_add(p,f)
			local x1,y1=cam:project(p)
			line(x0,y0,x1,y1,c)
			flip()
		end,	
		draw=function(self)	
			for _,s in pairs(skidmarks) do
				s:draw()
			end

			
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
			local steering=1-0.1*steering_angle

			-- front wheels
			local c,s=cos(steering),sin(steering)
			self:draw_vector(m_x_v(self.m,{s,0,c}),self.pos,9)
			add_tireforce(self,1,m_x_v(self.m,{c,0,-s}),m_x_v(self.m,{s,0,c}),1,1)
			-- rear wheels
			add_tireforce(self,-1.2,m_right(self.m),m_fwd(self.m),1,2,rpm)
			
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
			v_add(velocity,f,inv_mass)
			angularv+=inv_i*v2_cross(make_v(self.pos,p),f)
			angularv=mid(angularv,-1,1)
		end,
		integrate_forces=function(self,dt)
			v_add(velocity,forces,inv_mass*dt*0.5)
			angularv+=torque*inv_i*dt*0.5
			-- apply some damping
			angularv*=0.92
			rpm*=0.97
			-- some friction
			v_add(velocity,velocity,-0.02*v_dot(velocity,velocity))
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
			for _,s in pairs(skidmarks) do
				s:update()
			end
		end
	}
end

function make_npc(p,angle,density,track)
	local velocity,angularv={0,0,0},0
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
		draw_vector=function(self,f,p,c)
			local x0,y0=cam:project(p)
			p=v_clone(p)
			v_add(p,f)
			local x1,y1=cam:project(p)
			line(x0,y0,x1,y1,c)
			flip()
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
		end,		
		apply_force=function(self,f,p)
			local x0,y0=cam:project(p)
			circfill(x0,y0,2,12)
			vf=v_clone(p)
			v_add(vf,f)
			local x1,y1=cam:project(vf)
			line(x0,y0,x1,y1,12)
			flip()

			v_add(forces,f)
			torque+=v2_cross(make_v(self.pos,p),f)
		end,
		apply_impulse=function(self,f,p)
			v_add(velocity,f,inv_mass)
			angularv+=inv_i*v2_cross(make_v(self.pos,p),f)
			angularv=mid(angularv,-1,1)
		end,
		integrate_forces=function(self,dt)
			v_add(velocity,forces,inv_mass*dt*0.5)
			angularv+=torque*inv_i*dt*0.5
			-- apply some damping
			angularv*=0.92
			-- some friction
			v_add(velocity,velocity,-0.02*v_dot(velocity,velocity))
		end,
		integrate_v=function(self,dt)
		 	-- update pos & orientation
			v_add(self.pos,velocity,dt)
			angle+=dt*angularv			
			self.m=make_m_from_euler(0,angle,0)

			self:integrate_forces(dt)
		end,
		reset=function(self)
			forces,torque={0,0,0},0
		end,	
		update=function(self)
			-- force application point
			local p=v_clone(self.pos)
			v_add(p,m_fwd(self.m),1)

			-- get target point
			local target=track:update(p,4)
			local f=make_v(p,target)
			v_scale(f,8)
			-- todo: clamp


			-- steer toward track
			self:apply_impulse(f,p)			
		end
	}
end

local plyr=make_plyr({0,0,0},0,2)
local npc_track
local npcs={}

function _init()
	npc_track=make_track(track_data)
	add(npcs, make_npc(npc_track:get_next(),0,2,npc_track))
end

function _update()
	--[[
	plyr:control()
	plyr:integrate_v(1/30)
	plyr:reset()	
	plyr:update()
	]]

	for _,npc in pairs(npcs) do
		npc:update()
		npc:integrate_v(1/30)
		npc:reset()	
	end
end

function _draw()
	cls()
	--[[
		plyr:draw()	
	]]

	cam:track(npcs[1].pos)

	npc_track:draw()
	for _,npc in pairs(npcs) do
		npc:draw()
	end

	local cpu=flr(1000*stat(1))/10
	print(cpu.."%",2,118,2)
end

