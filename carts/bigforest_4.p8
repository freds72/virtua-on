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
b50466f317f3eaf3a9f317042504660400045af3a90400045af3a904f80425f30804cce3cbf34d14a7e389040804cce3cb04d404ed04db040004843409e32b04
3ae36904a804120443040b0412d343f3050412d34314e4043ae369e3ed045bf34904c70426c360f3000429d38914e40412e3c8e32b0412e3c81422045bf349e3
ed0412f349f36704120443f3f904ed044304e11429f398f368045df398f3fa041ad343f3000412d338f3480426c36014000429d389041604ed04430415041ad3
43f32e1429f39804a7045df39804001423d3c604c214a7e389f33b04ed04db14220412f349040004b9b30f14000412d33804660400f3b5046604f8f3eaf3a904
f80425f3a904f8f3ea0466f317f3eaf3a9f3170425f3a90400f3b5f3a9f317f3ea0466f3170425f3a90400045a04660400045a046604f80425f3a90400f3b5f3
a904f8f3ea046604f80425046604f8f3eaf3a9f317f3ea0466f317042504660400f3b50466f317f3eaf3a9f317042504660400045af3a90400045af3a904f804
2504660400f3b5046604f8f3eaf3a904f80425f3a904f8f3ea0466f317f3eaf3a9f3170425f3a90400f3b5f3a9f317f3ea0466f3170425f3a90400045a046604
00045a046604f80425e3d10400b3bd143e0400b3bde3d10400d352143e0400d352e3d1040004bd143e040004bde3d104002452143e04002452c2301110203040
301150607080308890a0b0c0308841d051613082e07181f03077011121310066f3723400114482920077e243e30077a252730082c364a3008803c2f32066e2d3
74232066235443e22066a2f25333206633b313a200610364c32077a213a352007773f2a2200054b2e3432000f273635320666373449220008314930420669282
e3b22088a313b3d20082f364030088a3d2c32055c3d2c2032088c274d3f32055931482440077e2e372207772f3d3e2006652a362008224a364008264f3242077
830462340088346224206634721483008824f33420665262049300882462a33077306050403005c6d6f6e63005071737274030711122e32804091408a02055a1
423291f308040004002050a191f1c104000404f3192055b1c1f12204080400040020553212d191f30804000400205591d102f10400f30cf3192055e122f10204
08040004002050d112e1020400f30804002055123222e10400f30c04f620503242b1220400040404f6205542a1c1b10400040804003071d122e3280409c308a0
205555f5e545f3080400040020505545a57504000404f31920556575a5d50408040004002055e5c58545f3080400040020554585b5a50400f30cf319205595d5
a5b5040804000400205085c595b50400f30804002055c5e5d5950400f30c04f62050e5f565d50400040404f62055f555756504000408040030d1d12214e70409
c308a020551606a6b604080400040020501636660604000404f319205526966636f308040004002055a60646860408040004002055066676460400f30cf31920
5556766696f308040004002050467656860400f30804002055865696a60400f30c04f62050a69626b60400040404f62055b626361604000408040030d1112214
e704091408a0205594842535040804000400205094b4e48404000404f3192055a415e4b4f3080400040020552584c405040804000400205584e4f4c40400f30c
f3192055d4f4e415f308040004002050c4f4d4050400f3080400205505d415250400f30c04f620502515a4350400040404f6205535a4b49404000408040055e3
d1f33fb3bd143ef33fb3bde3d1f33fd352143ef33fd352e3d1f33f04bd143ef33f04bde3d1f33f2452143ef33f245214c50422348a14c5047d244814c5042224
48e34a0422348ae34a04222448e34a047d2448044e04e9c309044e0408b3ea044e14ebb3ea044e14ebc309f3c114ebb3ea046e046dc309f3a1046dc309f3a114
48b3ea046e1448b3ea046e1448c309f3a11448c309f3c114ebc309f3c10408b3eaf3c104e9c309046e046db3eaf3a1046db3eaf3a90400f3b5f3a904f8040004
6604f80400f3a9f31704000466f317040004660400f3b504660400045af3a90400045af368045cf39804001428f39804a7045cf39804d404ec04db0400048334
09e3ed044af34904a804010443040b0401d343f3050401d3431422044af349040004b8b30ff3000428d38914220401f349e3ed0401f349f36704010443f3f904
ec0443f3fa0409d343f3000401d33814000428d389041604ec044304150409d343f33b04ec04db14000401d33804660400f3b5046604f80400f3a904f8040004
66f3170400f3a9f3170400f3a90400f3b5f3a90400045a04660400045af3a90400f3b5f3a904f80400046604f80400f3a9f31704000466f317040004660400f3
b504660400045af3a90400045a04660400f3b5046604f80400f3a904f804000466f3170400f3a9f3170400f3a90400f3b5f3a90400045a04660400045ae13005
10204030300550608070101190a0b01011c0d0e03088f00111213088a131b1c1308241d1e1513077617181910066b392820011c3a2b20077c27263008813e2b3
20660393d3332066438323c22077c2237372200033d2a3032000c263534320665363c3b200008292722066b2a2a3d22088732383f2008873f2132088e2d393b3
20557292a2c3007703a392207792b3930300667273820082827313008213b3823077b0d0c0904030711122e328040814082030555242f1620400f30804003055
3212022204000400f3083071d122e3280408c308203055c4b464d40400f30804003055a484749404000400f30830d1d12214e70408c3082030554535e4550400
040804003055052515f404000400f30830d1112214e7040814082030554434e3540400040804003055042414f304000400f30860e0c0d110c041412004310466
2015e3d1f33fb3bd143ef33fb3bde3d1f33fd352143ef33fd352e3d1f33f04bd143ef33f04bde3d1f33f2452143ef33f245214c50422348a14c5047d244814c5
04222448e34a0422348ae34a04222448e34a047d2448044e04e9c309044e0408b3ea044e14ebb3ea044e14ebc309f3c114ebb3eaf3a11448b3ea046e1448b3ea
046e1448c309f3a11448c309f3c114ebc309f3c10408b3eaf3c104e9c309e3c10400f3b5e3c104f80400e37e04f80400e3c1f3170400e37ef3170400e37e0400
f3b5e37e0400045ae3c10400045af368045cf39804001428f39804a7045cf39804d404ec04db040004833409e3ed044af34904a804010443040b0401d343f305
0401d3431422044af349040004b8b30ff3000428d38914220401f349e3ed0401f349f36704010443f3f904ec0443f3fa0409d343f3000401d33814000428d389
041604ec044304150409d343f33b04ec04db14000401d338144e0400f3b5144e04f80400149104f80400144ef31704001491f317040014910400f3b514910400
045a144e0400045ae3c10400f3b5e3c104f80400e37e04f80400e3c1f3170400e37ef3170400e37e0400f3b5e37e0400045ae3c10400045a144e0400f3b5144e
04f80400149104f80400144ef31704001491f317040014910400f3b514910400045a144e0400045ae1300510204030300550608070003390a0b00033c0d0e020
33f00111212033813191a120bb4151617100bb73524200bb83627200338232230033d2a2732066c25393f220660343e282203382e233322000f29263c2200082
2313032066132383720066425232206672626392203333e243b20055d2b2a2003333b2d22033a29353732055325262830033c263522033527353c200bb323342
00bb4233d200bbd2734220bbb0d0c09020201122040004081408c02050c1b102d104000416f3ca2055b1e1f1020400f3f9f3ca2050e12212f10400f3f9044520
5522c1d1120400041604452055c304e3f3f308040004002050b3c3f3a304000416f3ca2055d102f1120408040004002055a3f3e3d30400f3f9f3ca2050d3e304
140400f3f9044520551404c3b30400041604452055b3a3d3140408040004002055c122e1b1f3080400040020d12204000408c308c0205534945424f308040004
002055447464840408040004002055b4a4d41504080400040020503424744404000416f3ca2055c405e4f4f308040004002055245464740400f3f9f3ca205054
9484640400f3f904452055943444840400041604452050b4c4f4a404000416f3ca2055a4f4e4d40400f3f9f3ca2050d4e405150400f3f9044520551505c4b404
00041604452414c50422348a14c504222448e34a0422348ae34a04222448044e04e9c309044e0408b3ea044e14ebb3ea044e14ebc309f3c114ebb3eaf3a11448
b3ea046e1448b3ea046e1448c309f3a11448c309f3c114ebc309f3c10408b3eaf3c104e9c309e3c1040804bde3c114f01408e37e14f01408e3c1f31f1408e37e
f31f1408e37e040804bde37e04082452e3c1040824520400045cf39804001428f398041604ec0443040004833409e3ed044af34904a804010443040b0401d343
f3050401d3431422044af349040004b8b30ff3000428d38914220401f349e3ed0401f349f36704010443f3f904ec0443f3000401d33814000428d38914000401
d338144e040804bd144e14f01408149114f01408144ef31f14081491f31f14081491040804bd149104082452144e04082452e3c10408b3bde3c114f0c308e37e
14f0c308e3c1f31fc308e37ef31fc308e37e0408b3bde37e0408d352e3c10408d352144e0408b3bd144e14f0c308149114f0c308144ef31fc3081491f31fc308
14910408b3bd14910408d352144e0408d352c12033506070802033e090f00120bba0b0c0d0300003b2231330008333a39300bb72b1c10033d1917220661292a2
422066528232d12033d1322291200042e1b1122000d172625200666272c10066c1b1e120332232820200552202f12033f1a29222005591b172003312b1912033
9122921200bb9122a120bb204030103000d3c3e3f33000611181713000d2c2e2f2300031214151300053436373300004b3241400000000000000000000000000
