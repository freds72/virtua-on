pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- data cart for virtua racing on pico
local data=""
local mem=0x3100
for i=1,#data,2 do
    poke(mem,tonum("0x"..sub(data,i,i+1)))
    mem+=1
end
cstore()
__gfx__
68cc78b478f4780578157885683b684b7835686b7845688b689b786578757895181fc3681868386848685868686878688868c868d868e868f868096819682968
3968496859686968796889689968b968c968d968e968f9680a681a682a683a684a685a686a687a688a689a68aa68ba68ca68da68ea681b683b684b685b686b68
7b688b68ab68bb789578a578b578c56867687768d768e768f76808182fa16838686868786888689868a868b868f868796889689968a968e568b668c668d66867
68776887689768a768b768c768e768f76808183f6068b868d668f468a968c768e5184f3068d668e568f4186f3048cd48fc48fb187f70482a484c485c48fc480b
48cd48fb188f1248694879489948a948b9482a483a484a485a486a487a488a489a48aa48ca48da480b481b482b483b484b485b486b487b488b489b48ab48bb48
fb483c484c485c48fc189fa2483848484858486848784888489848a848b848c84849485948694879488948c948d948e948f9480a481a484a485a489a48aa48ba
48ca48da48ea48fa481b48bb48d448f4480648464856486648c748d748e748f718af7248584878488848c848e848f84809481948294839480a481a48d448e448
f448054835484548554865480648464856486648c648d648e648f6480748174827483748474857486748774887489748a718bfa04886489648a648b648e44805
48154825489748a708eea298a198b198d198f198d298e298f298039813983398539863987398b398d398e398f398049814982498349844985498649874988498
c498d498e498f49805981598259835984598559865987598169836985698761030e0c0d141200431046630351491040914b61491040914590475040914550474
040914ba14c50455348a14c5047e244814c50423244814c50423348ae34a0423348ae34a04232448e34a047e2448e34a0455348af3a90400f3b5f3a904f8f3ea
046604f80425046604f8f3eaf3a9f317f3ea0466f317042504660400f3b50466f317f3eaf3a9f317042504660400045af3a90400045af3a904f80425f30804cc
e3cbf34d14a7e389040804cce3cb04d404ed04db040004843409e32b043ae36904a80412044314e4043ae369e3ed045bf3491422045bf349e3ed0412f349f367
04120443f3f904ed044304e11429f398f368045df398041604ed0443f32e1429f39804a7045df39804c214a7e389f33b04ed04db14220412f34904660400f3b5
046604f8f3eaf3a904f80425f3a904f8f3ea0466f317f3eaf3a9f3170425f3a90400f3b5f3a9f317f3ea0466f3170425f3a90400045a04660400045a046604f8
0425e3d1040004bd143e040004bde3d104002452143e0400245204d4042504e9f3680494f3d804a70494f3d8f33b042504e9e37e040914b6e37e04091459f39a
04091455f39b040914ba0400f33df36ff38df3aef3bff38d04610450040004d204a00482046104500482f3aef3bf0400f3cdf38ff30ef3eef3cff30e04210440
0400044204800402042104400402f3eef3cf040004ce040c0400042504e981305020103040301150607080301190a0b0c00011c225d100770222820077e19152
00775212e12000d2f1822220001252423220664252c2d1206662a272922066d1c182f13011a2c1e30400770282b120776292a1b22066b2b1a262206691a19272
307770a090803005a3b3d3c33011c272f3142055143525c2305034244454001125c1d12055c12535e33020e122040004ab048a6030007464c4d4040004b1f338
300064b415c4040004b1f3383000a494f405040004b1f33830008474d4e4040004b1f3383000b4a40515040004b1f33830009484e4f4040004b1f33830d11122
14e704091408a02055f2e283930408040004002050f21343e204000404f319205503734313f30804000400205583e223630408040004002055e24353230400f3
0cf319205533534373f308040004002050235333630400f30804002055633373830400f30c04f62050837303930400040404f62055930313f204000408040030
711122e32804091408a02055e08171d0f308040004002050e0d0310104000404f3192055f00131610408040004002055715111d0f308040004002055d0114131
0400f30cf3192055216131410408040004002050115121410400f30804002055517161210400f30c04f620507181f0610400040404f6205581e001f004000408
04003714c50455348a14c5047e244814c50423244814c50423348ae34a0423348ae34a04232448e34a047e2448e34a0455348a044e04eac309044e0409b3ea04
4e14fcb3ea044e14fcc309f3c114fcb3ea046e047ec309f3a1047ec309f3a11459b3ea046e1459b3ea046e1459c309f3a11459c309f3c114fcc309f3c10409b3
eaf3c104eac309046e047eb3eaf3a1047eb3eaf3a90400f3b5f3a904f8f3ea046604f80425046604f8f3eaf3a9f317f3ea0466f317042504660400f3b50466f3
17f3eaf3a9f317042504660400045af3a90400045af3a904f80425f30804cce3cbf34d14a7e389040804cce3cb04d404ed04db040004843409e32b043ae36904
a804120443040b0412d343f3050412d34314e4043ae369e3ed045bf34904c70426c360f3000429d38914e40412e3c8e32b0412e3c81422045bf349e3ed0412f3
49f36704120443f3f904ed044304e11429f398f368045df398f3fa041ad343f3000412d338f3480426c36014000429d389041604ed04430415041ad343f32e14
29f39804a7045df39804001423d3c604c214a7e389f33b04ed04db14220412f349040004b9b30f14000412d33804660400f3b5046604f8f3eaf3a904f80425f3
a904f8f3ea0466f317f3eaf3a9f3170425f3a90400f3b5f3a9f317f3ea0466f3170425f3a90400045a04660400045a046604f80425f3a90400f3b5f3a904f8f3
ea046604f80425046604f8f3eaf3a9f317f3ea0466f317042504660400f3b50466f317f3eaf3a9f317042504660400045af3a90400045af3a904f80425046604
00f3b5046604f8f3eaf3a904f80425f3a904f8f3ea0466f317f3eaf3a9f3170425f3a90400f3b5f3a9f317f3ea0466f3170425f3a90400045a04660400045a04
6604f80425e3d10400b3bd143e0400b3bde3d10400d352143e0400d352e3d1040004bd143e040004bde3d104002452143e04002452c230111020304030115060
7080308890a0b0c0308841d051613082e07181f03077011121310066f3723400114482920077e243e30077a252730082c364a3008803c2f32066e2d374232066
235443e22066a2f25333206633b313a200610364c32077a213a352007773f2a2200054b2e3432000f273635320666373449220008314930420669282e3b22088
a313b3d20082f364030088a3d2c32055c3d2c2032088c274d3f32055931482440077e2e372207772f3d3e2006652a362008224a364008264f324207783046234
0088346224206634721483008824f33420665262049300882462a33077306050403005c6d6f6e6300507173727403071d122e3280409c308a0205555f5e545f3
080400040020505545a57504000404f31920556575a5d50408040004002055e5c58545f3080400040020554585b5a50400f30cf319205595d5a5b50408040004
00205085c595b50400f30804002055c5e5d5950400f30c04f62050e5f565d50400040404f62055f555756504000408040030d1112214e704091408a020559484
2535040804000400205094b4e48404000404f3192055a415e4b4f3080400040020552584c405040804000400205584e4f4c40400f30cf3192055d4f4e415f308
040004002050c4f4d4050400f3080400205505d415250400f30c04f620502515a4350400040404f6205535a4b49404000408040030d1d12214e70409c308a020
551606a6b604080400040020501636660604000404f319205526966636f308040004002055a60646860408040004002055066676460400f30cf3192055567666
96f308040004002050467656860400f30804002055865696a60400f30c04f62050a69626b60400040404f62055b626361604000408040030711122e328040914
08a02055a1423291f308040004002050a191f1c104000404f3192055b1c1f12204080400040020553212d191f30804000400205591d102f10400f30cf3192055
e122f1020408040004002050d112e1020400f30804002055123222e10400f30c04f620503242b1220400040404f6205542a1c1b104000408040055e3d1f33fb3
bd143ef33fb3bde3d1f33fd352143ef33fd352e3d1f33f04bd143ef33f04bde3d1f33f2452143ef33f245214c50422348a14c5047d244814c504222448e34a04
22348ae34a04222448e34a047d2448044e04e9c309044e0408b3ea044e14ebb3ea044e14ebc309f3c114ebb3ea046e046dc309f3a1046dc309f3a11448b3ea04
6e1448b3ea046e1448c309f3a11448c309f3c114ebc309f3c10408b3eaf3c104e9c309046e046db3eaf3a1046db3eaf3a90400f3b5f3a904f80400046604f804
00f3a9f31704000466f317040004660400f3b504660400045af3a90400045af368045cf39804001428f39804a7045cf39804d404ec04db040004833409e3ed04
4af34904a804010443040b0401d343f3050401d3431422044af349040004b8b30ff3000428d38914220401f349e3ed0401f349f36704010443f3f904ec0443f3
fa0409d343f3000401d33814000428d389041604ec044304150409d343f33b04ec04db14000401d33804660400f3b5046604f80400f3a904f804000466f31704
00f3a9f3170400f3a90400f3b5f3a90400045a04660400045af3a90400f3b5f3a904f80400046604f80400f3a9f31704000466f317040004660400f3b5046604
00045af3a90400045a04660400f3b5046604f80400f3a904f804000466f3170400f3a9f3170400f3a90400f3b5f3a90400045a04660400045ae1300510204030
300550608070101190a0b01011c0d0e03088f00111213088a131b1c1308241d1e1513077617181910066b392820011c3a2b20077c27263008813e2b320660393
d3332066438323c22077c2237372200033d2a3032000c263534320665363c3b200008292722066b2a2a3d22088732383f2008873f2132088e2d393b320557292
a2c3007703a392207792b3930300667273820082827313008213b3823077b0d0c090403071d122e3280408c308203055c4b464d40400f30804003055a4847494
04000400f30830d1112214e7040814082030554434e3540400040804003055042414f304000400f30830d1d12214e70408c3082030554535e455040004080400
3055052515f404000400f30830711122e328040814082030555242f1620400f308040030553212022204000400f3080000000000000000000000000000000000
