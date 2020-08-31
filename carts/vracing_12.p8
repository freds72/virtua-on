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
d4593969b4306569b46984595a69f4303569445929698469b4206659595949596a598a20655957594759495959303559695957595959c9303659c95959598a59
79333559a95989599959b930333559ba59aa598959a930306559c959a959b959693066597959ba59a959c97166592a69e4699459687166593859aa599a591af1
d659685938591a592a20307759c759d9591b59e9307759f959e7592b590a306669c4593a59f869d43036593a59eb594a59f82065598a596a597a59fb30355979
598a59fb59ca3335591c599a59aa59ba30306559ca591c59ba59797166593b594b69e4592a7166591a599a590f59cdf166592a591a59cd593b30307759e9591b
593d592d3077590a592b596d595d307759da59ea59fa590b3067595b596b597b598b3055599b59ab59bb59cb306559ae59db593a69c4303559db598e59eb593a
206659fb597a59ee59de303659ca59fb59de590c3335591f590f599a591c303066590c591f591c59ca3055592c593c594c595c3067596c597c598c599c716669
45598d594b593b716669a569b5598d69457166599d59ad592f59bd716659cd590f59ad599df1666945599d59bd69a530307759ec594d595f59fc3077590d597d
596f591d307759ac59bc59cc59dcf1d6593b59cd599d6945203077592d593d594d59ec3077595d596d597d590d305559dd59ed59fd590e3067591e592e593e59
4e3055599e595e59db59ae30656975596e595e599e3066595e597e598e59db3035596e6930597e595e2066594f59be59ce6980206559de59ee59be594f306559
3f59fe591f590c30666970696059fe593f333559fe59ad590f591f3033356960592f59ad59fe303036593f594f698069703035590c59de594f593f7166693169
d569b569a5716659bd592f69116901f1d669a559bd69016931203077591d596f597f598f307759fc595f69e069d03055599f59af59bf59cf306759df59ef59ff
6900306569c16910596e69753035691069206930596e2065698059ce69f1694030656950692269606970333569226911592f6960303035697069806940695071
66690669c569d5693171666901691169126921f166693169016921690630307769d069e0694269323077598f597f696269f03077699069a069b069c030556941
69516961697130676981699169a169b1306669536923691069c13036692369d1692069102066694069f169636993306669836902692269503335690269126911
69223030366950694069936983716669b269c369c56906716669216912699269a2f1d66906692169a269b220307769f0696269726982307769326942695278d3
305569c269d269e269f2306669d369b369236953303669b3788469d16923333569e169c569c36933303035694369d3695369163065691669e169336943203669
93696378a469e3303669a3697369026983333569736992691269023030336983699369e369a371666974693469f369143036694469a469246904716669646954
693469743335595a699469e46905303035693569c469d469f43335690569e4594b6915303066692559ae69c4693533356955598d69b569953033356915594b59
8d69553030656985599e59ae6925306669656975599e69853335699569b569d569e530306669f569c169756965333569e569d569c569e13030356916695369c1
69f5087b28ca1208e8080908b908c9080a081a082a084a085a087a08ba08ca08da080b081b084b085b086b088b08cb08db08eb08fb080c081c082c084c085c08
8c089c08dc08ec08fc28c071103090e0f098d298e2980398d398e398f398049814983498549884989498e498f4980598159835985528d071203060c0d098c298
d2980398239843986398839824983498449864987498a498b498c498d49825984528daf108f80809089908a908d908e908f9083a086a087a088a089a08aa08ea
08fa082b083b087b088b08bb08db08fb080c082c083c085c086c087c08ac08bc08cc281131382638363844384638a838e838f838093827383538453837386738
773887389738a7382938062821143818382838383848386838783888389838a838c838d8380938293889389938a938b938c938d9385a3844385438a438e438f4
3805381538253845385538653875388538a538b538c538d538e538f538063816383638463856386638763886389638a638b638c638d638e638f6380738173827
383738473857387738a738e738f7380828315238c838d8383938493859386938793889389938a938b938c938d9385a386a38ba38ca382b386b387b388b385c38
6c38a4385d386d387538853895387d381638563847385738b738c738d7284170385c386c387e385d386d387d388b28514038df386c387d387e28611038df28c2
6110307080b0e0f00121617181a1d1e1f1125272a2b2985528d26120304050a0c0d0112131415191b1c10212326282929845281340384538b338443835282352
383338433853386338733883389338a338b338c338d338e338f3380438143824383438443854386438743884389438a438b438c438d438e438f4380538153825
38453855386538753885283350389538a438853873387518902078c878c918b0d278187828783878487858786878787888789878a878b878d878e878f8780978
197829783978497859786978797889789978a978b978d978e9782a783a784a785a786a78ba78ca78da78ea78fa780b781b782b785778677877788718c0e0781a
7858785a786a786c787c78dc78fc783978f97877788778f7780828c422f1124272a2b2c2e213235363738393a3b3c3e3f32434445464d4e4f4152545c5f50628
d402021222628292d2e2f20333437393a3c3d3f30414748494a4b4c4053545b5d5e518d021682a685c686a687c688c689a68aa689c68c878dc78ec680b681b68
2b783778f978f7780a28151038b3282523980c985c988a989a98aa98da98ea98fa980b981b982b3823383338433853386338733883389338a338b338c338d338
e3987b988b989b98ab98bb98cb98db98eb98fb983b981c982c983c984c984b986c987c988c989c985b986d987d986b988d989d98ac283540989b983c98ea3873
18e05368686878688868a868c868096829683968d968e968f9680a681a682a683a684a685a68ca68da68ea68fa680b683b684b685b686b687b688b689b68ab68
bb68cb68db68eb68fb680c681c682c683c684c685c686c687c688c68ac68bc68cc68dc68ec68fc680d681d987518da53883b884b885b886b887b888b88ab88bb
88cb882c883c884c885c886c887c888c889c88ac88bc88cc88dc88ec88fc884d885d886d887d888d889d88ad88bd88cd88dd88ed88fd880e881e885e886e887e
888e889e88ae88be88ce88fe880f881f882f883f884f889f88af18f0a0684a68a268c268e2680d6829686368736883687b1801a36850686068706880689068a0
68b068c068d068e068f0680168116821683168416851686168716881689168a168b168c168d168e168f1680268126822683268426852686268726882689268a2
68b268c268d268e268f26803681368236833684368536863588f589f58af58bf58df58ef58ff680018119168c068f058fc580d58dd58ed580e581e582e583e58
4e585e586e58be58ce58ee58fe580f581f582f588f58af58ef58ff680028c66125458595a5c5f5061636768696b6e6f6072787c7f7080818214258f9580a581a
582a583a584a585a586a587a588a587b588b589b58ab58bb58cb58db58eb58fb580c581c582c583c584c58ec58fc580d583d584d585d586d587d580e582e584e
586e28270398789888989898c898d898e898f89809981998499859986998799889989998a998b998c998d998e998f9980a981a982a983a984a985a986a987a98
8a989a98aa98ba98ca98da98ea98fa980b981b982b980d981d982d983d984d985d986d987d183124581858285838584858585809583958c158e158e958025812
58f9580a581a582a583a584a585a586a58a258b2587a588a583358535863587358a358b358c358d358e358f358045814582458345844585458db580c589458a4
58b458e4587558a558b558c558d558f5583758475857586758775887589758a758b758c758d758e758f7580818510158645874589258d258e258f25803581358
2358d458055815582558355845585518c6b2885888a888b888c888d888e888f888098843887388f38804882488448874889488b488c488d488e488f488058815
88258835884588558865887588858895888688a688c688178827883788478857886788778887889708c84078d378f3785378f128d88108280838084808580888
08a808b808f808090819082908390879089908a9083a1727374797a7d7e728d6613545556575b5d5e52636465666a6c6d6172757a7d7e7282972981898289838
98489858986898789888989898a898b898c898d898e898f89809981998299839981a98ec98fc980d981d98569866988698d698f69807983798479867989798b7
98d798e798f79808283930982898d898f6283f50289e385138323850386018d8928858886888498859886988798889889988a988b988c988d988e988f9880a88
1a882a883a884a885a886a887a888a880b881b882b883b884b885b886b887b888b889b88ab88bb88cb881c882c889c88ac88cc18d2718830884068c888216869
68796889689968a968b968c988d1682a686a687a688a689a68aa68ba78dc78ec784e78df08ba3078e27875788308caf0781478e278f378437853786378737883
7891780478b378c378d378f1780208daf0783278427852786078c078d078e07853789178b378c378d378e178f1780208ea4078e078c078d07860282b53384238
5238623872389238a238b238c238d238e238f23803381398bc98cc98dc989598a598b598c598d598e598f5980698169826983698469856986698769886989698
a698b698c698d698e698f6980798179827983798479857986798779887989798a798b798c798d7283b40389298e698e598f628ac40081f082e08af08fd28bc50
081f082e083f08af08fd287c10082f288c40081e082f080f080e289c70081e082e080f081f08af08fd080e08ac6078267836784678f67807782708bc6178e278
f278037883783578457855787578a578b578e578f57806781678267836784678b678c678d678f6780728cc71086b088b08ab08cb088c089c080d082d086d087d
088d08ad08dd08ed083e085e088e089e08be08ee08fe083f089f28dc61087b088b089b08bb086c087c081d082d083d084d085d089d08bd08cd084e085e086e08
7e08ae08ce08de088f08ecf0682e686e687e688e786078c078d078e0684f685f686f688f689f68af680e08dcd378107820783078407850786078707880789078
a078b078c078d078e078f0780178117821783178417851786178717881789178a178b178c178d17812782278327862788278c27823789378a378b378e3784468
0e686e689e68be68ce68de68ee68fe680f684f685f686f687f688f68bf68cf68df68ef68ff7800281d30281e282e3811282d43381038203850386038c038d038
e038f0380138113821383138413851386138713881389138a138b138c138d138e138f1380238123822383238423852386238723882389238a238b238c238d238
e238f2380338139885281e282e285f286f288f28bf28df28ef3800083d2058ea580b084d2058fa580b283d503892385138323850386018d66488188828883888
488858886888788888889888198829883988598879889988a988c988e9883a884a886a888a881b88f3880488148824883488448854886488748884889488a488
d488e488f4887588a588c588d588e588f5880688168826883688468856886688768886889688b688c688d688e688f6880788178857889788a788b788c788d788
e788f78808287e3018c0082f08cf288e70081e18b018c0080f082f08cf080e089e1078c808ae907826784678b878c878d878f67807782778d708be6278187828
786878787888789878a878b878d878e878a578b57806781678267846786678767886789678b678c678d678e678f67807781778477857786778777887789778a7
78b778c778d778e708ced17861787178c278d27893789478c478d478f47805781578257885789578a578b578c578d578067816785678767886789678a6787778
8778f7780808de7278407850786178717881781278c27893685c687c688c689c78b4682d684d685d686d788568dd68ed68fd680e681e686e689e68ae68be68de
68ee680f681f682f683f684f685f686f7837688f78f708ee32687b685c686c687c688c68ac68bc68cc68dc68ec68fc680d681d683d684d687d688d689d68ad68
bd68cd68ed68fd680e682e683e684e685e686e687e688e684f685f686f688f08fe20687b680d080fc06810682068306840689068516871689158af58bf58cf58
df081f41682068306840587e588e589e58ae58ce58de580d582d583f584f585f586f587f58af58cf58ed58fd082fb1586a589a58aa58ca581c582c585c586c58
7c588c589c58ac58bc58cc58dc580d581d582d583d588d589d58ad58bd58cd588e589e58ae083f2258185878588858a858b858c8580958195839584958595869
58795889589958a958b958c958d9586a589a58aa58ba58ca58da58ea580b581b582b583b584b585b586b5808084fd158685878589858a858d858e858f8582958
39584958fa580b58745884581558355855589558165826583658465856586658765886589658a65808085f5058155835584558555874086f3058455855586518
5d21381e4812385e386e387e48d148034841385f386f4851487138bf38cf38df48e148f1480238b24018a6183518d318b638702018c008cf38803018c018b008
cf38901018b018a07078b878c878d8780b78b978c978d938b0901880189018c218d018d2083f183508bf18d338c032189018a018d018e0180118211851186118
b118c118d118e118f11812182218421852186218b218c218d218031813182318331843185318b318c318d31804180518251835083f38d0d118f0180118111831
184118711881189118a1180218121832184218721882189218a218e218f218031813186318731883189318a318d418e418f438e0502811182f280118ff28f038
f0b02814282428c228d228d428f028012811182f18ff28023801532818282828382858286828782888289828b828c828d828e828f8288928a928d928e9280228
0a281a282a283a284a28c228d2285b288b2814282428a428d428f528062816285628662876289628a628b628c628d628e628f6280728172827283728b728d728
e728f728083811432838284828782888289828a8280928192829283928492859286928792889289928a928b928c928d928e9281a283a285a286a287a288a289a
28aa28da28ea28fa280b285b288b289b28ab28bb28cb280c281c282c28ac28bc28cc28dc28ec281728272837284728b7382151281c282c283c28dd286e287e28
8e289e28ac28bc28cc28dc28ec28fc280d281d282d283d28cb28db280c383110289e184142583958d258e258f258435853588358935874588458c458d458e458
f45815583558555885589558a558b558e5580658265886589658a658b658c658d658e658f6580758175827580818e2c268186828683868486858687868886898
68a868b868c868d868e868f8680968196829683968496859686968a968b968c9682a687a688a68ba68d568f56816683668e66817682768376847685768676877
6887689768a768e7186140582358455855586538f222289028a028b028c028d028e028f02801281128612871288128d128e128f1280228122822283228822892
28b228d228e228532863288328f3180f182f185f18cf18ef18ff3803d428282838289828f12802283228a228b228d228e228f228032813282328332843285328
6328732883289328a328b328c328d328e328f32804283428442854286428742884289428a428b428c428e428f428052815282528352845285528652875288528
9528a528b528c528d528e528f528062816282628362846285628662876288628962817282728372857286728772887289728a728b728c718921078c918a24078
b978c978d9780b18b23378b978d9782a783a784a785a786a787a788a789a78aa78ba78ca78da78ea78fa780b781b782b783b784b785b786b787b788b789b78ab
78bb78cb78db78fb780c781c782c784c789c78ac78bc78cc783d784d785d786d789d78ad78fd780e781e782e783e781f38c24218131833185318b318d318e318
f31804181418241854186418741884189418a418051815182518351845185518651875188518b518c518d518e518f5180618761886189618a618b638d2c21859
188918a918e218131873189318a3183418441854186418b418c418d418e418f4189518a518b518c518e518061816182618361846185618661876188618b618c6
18d618f618071817183718771887189718a718b718c738e2412811188c18ac18ad18fa180d28f0182d183d182f185f186f18cf1889280118a918b918c718ef18
ff18f273681968296849686368736883689368a368b368d368e368f368146854686468746884689468a468b468c468d468e468f4680568156825683568556865
68756885689568a568b568c568d568e568f56806681668266836684668766886689668a668b668e668176847689768a768b71803616803681368236833684368
53686368a368b368c368d368e368f36804681468246834684468646815683568553813c02834283828862884289828b42817282728372819282928b718333358
3058405850586058705880589058a0584158615871588158a158b158c158d158e158f158025812582258325842585258625872588258f758a258b258c2583358
53586358735814582458345844585448de48ee48fe480f481f482f483f58c748df48ff58001843a15810582058c058d058e058f058515861589158d258e258f2
584358535883589358c458d4485f486f489f48af48bf48cf48ef48ff18539158b058e058f05801581158215831589258d258e258f258035813582358d448dd48
fd480e481e483e484f487f488f489f48cf186340481e58215831582318c2728840887088d1785a786a788a78eb78fb780c782c783c785c786c787c788c78dc78
fc780d781d782d783d784d787d788d78bd78cd78dd78ed784e785e78fe781f782f784f785f786f787f788f78ef28c8810818083808680878089808c808d808e8
0809084908590869088908b908c9084a07276777b7c7f7080838b45018a61835182818d318b638c4a018281876188618a618b6183518c518d318e5180638d4c3
18181828183818481858186818781888189818a818b818c818d818e818f8180918191829183918491859186918791889189918a918c918d918e918f9180a181a
182a183a184a18aa180b182b18c518e518061876188618b618c618d618e618f61817182718371847185718671887189718d718e718f7180818e4d06836685668
c668e668f66867687768a968c768d768e768f7680808d850785378d3785278e178f13805c02832284228522862287228f328b2289328c328d328e328f1183512
5880589058a0486b487b488b489b48ab48bb48cb480c481c482c486d487d488d489d48ad48bd48cd488e48ae48be48de48ee48fe480f481f482f483f48df48ff
580018453358105820489a48aa48ba48ca48ea482b484b485b48db48eb48fb480c481c482c483c484c485c486c487c488c489c48ac48bc48cc48dc48ec48fc48
0d481d482d483d484d485d48ed482e484e485e486e489e48ae48ce485f486f489f48af48bf48cf48ef48ff1855b0481e483e487e48ba48ca489f48cf48dd48eb
48fd480e186510481e38f4e228102820283028402850286028702880289028a028b028c028d028e028212831284128512881289128a128b128c128f128322842
28522862287228b228f318bc180f181f183f184f185f187f188f189f18af18bf18cf18df18ef280038b63018a618b6182838c63018a618b6182838d660181818
2818b6180b182b18e938e69018bc18cc18dc18ec180b181b182b18af18e938f66018bc18dc18ec184f18af18bf1837524848486848784888489848d848094829
48494859486948794889489948a948b9482a483a484a485a486a487a488a48fa486b487b488b489b48ab48bb48cb480c481c482c48ad48bd48cd184713481848
2848384848485848a848b848e848f848094819482948394849486948c948d948f9480a481a483a484a489a48aa48ba48ca48da48ea48fa480b481b483b484b48
eb480c481c482c986548e648f64817483748a748b748c748d748e748f748081857b048a848b848c848ba48ca48174837484748eb48e948f9289e80081e082e18
b0080f081f08af08fd080e28ae40081f082e08af08fd28be80082e188018d0081f083f08af08bf08fd28ce511810083e1830085e1860187018d008ee08fe18e0
18011821083f1851086f087f1861089f08df08ff18f118b860889a880d88db88eb88fb880c18c861885888a888b888c888d888e888f88809880a889a88aa88ba
88ca88da88ea88fa88eb880c889c881d882d883d38d820182b18e938e84018ec182b18dc18e938f82018dc18ec1839d048484868487848884898480748274865
4885489548a548b548c518498248184838484848a848b848a348c348e3481448444825483548454855486548754885489548a548b548c5483648764886489648
a648b648c648d648e648f64807481748374857486748774887489748081859f148a848b848c848634873488348c348e348044814486448744884489448a448b4
48c4487548d548e548f54806481648264836484648564866481748374847186930481648744883280fa0281a282a283a28d8284b285b288b28e928f9280a281f
4238112879289928e928f9281a283a28ba28ca28da28ea281b282b283b284b285b286b287b288b28eb28fb280c281c284c285c286c287c288c289c28ad28cd28
fd281e282e283e285e18cae0882e883e884e889c88de88ee88fe881d882d883d885f886f887f88cd282f2438103820383038403850386038703880389038a038
b03811384138513802383228db280c281c283c282d284d285d286d287d288d289d28ad28bd28cd28dd28ed28fd280e281e282e283e284e285e286e287e288e28
9e28ae28be28ce28de28ee28fe280f281f282f283f284f285f286f287f288f289f28af28bf28cf28df28ef28ff3800181b10383b182b20383c383b183b80383c
__map__
83d283b384588459845a845b845c81b4278413841484158416841784188419841a841b841c84288429842a842b842e842f84328433843484358439843a843b843c843e843f84418442844384448445845584588459845a845b845c83f483fa81b538840184028403840484058406840784088409840a840b840c840d840e840f
841084118412841484158417841d841f84208421842284238424842584268427842a842b842c842d84308431843684378438843b843c843d843e8440844184468447844d844e844f8450845183fe83ff840081b604842184388447842081f41583e183c283c583e583e683e783e883ea83eb83cd83ce83d083d583d683d783d8
83d983da83db83dc83f5814b1487e187e287e387e687e787e887f087f187f387d4881587d68816881787f987da87fb87fc87fa87e0814c598801880288048805880688078808880a880b880c880d880e880f88118813881488158816881788188819881a881b881c881d881e881f88208821882288238824882588268827882a
882b882c882d882e882f883088328833883488358836883788388839883a883b883c883e88408842884488478849884c884e8850885388568858885987d487e687e787e987ea87eb87ec87ed87ee87ef87f087f187f287f387f487f587f687f787f887f987fe87ff880081cc2089018902890389058906890789088909890a89
0b890c890d890e890f89118912891789188919891a891b89208921892288ed88ee88ef88f588f688f788fb88fd81cd218904890e890f891089128913891489158916891b891c891d891e891f88e788e888e988ea88eb88ec88ef88f088f188f288f388f488f888fa88fc88fd88fe88ff8900814d218803880488058806880888
098810881286978698869a881d88288829882d882e882f88308831883d883e8840884288448845884688478849884a884e885a885b886381d10483a983b383a783a881d20b83c383a483a783a883a983aa83b083b183b383b483b581d31983b083b183b383b583be83bf83c183c383c483cc83cd83ce83cf83d083d183d283d3
83d483e083e283e383e483f783f883f981d42c8413841484158416841784188419841a841b841c83cc83cd83ce83cf83d083dd83de83df83e083e183e283e383e483e583e683e783e983ea83eb83ec83ed83ee83ef83f083f183f283f383f483f583f683f783f883f983fa834e67820182028203820482058206820782088187
81888189818a818f81908196819781988199819a819b819d819e81a481a581a681a781a881a981aa81ab81ac81ad81ae81af81b081b181b281b381b481b581b681b781b881b981ba81bb81bc81bd81be81bf81c081c181c281c381c481c581c681c781c881c981cb81cc81cf81d181d381d481d581d681d781d881d981da81db
81dc81dd81de81df81e081e181e281e381e481e581e681e781e881e981ea81eb81ec81ed81ee81ef81f181f581f681f781f881f981fa81fc81fe820081d603842183fd8420814f0d8663866486658666866c866d866e866f86708652865386548655827304898d899e899f89ae81500386438655865382ed13810280e480e581
048105812080ec80ed810f81108111811380f480f5811480f880fe80ff810081ec16891a891b892089218922892389248929892a892b892d892e892f89308933893a893b893c893d893e893f894081ed16891b891c891d891e891f89248925892689278928892c892d893089318932893389348935893689378938893981f10b
83a783a883a9838a838e838f8390839283738377837981f21a83848385838683878389838a838b838d839083918392839e839f83a083a183a283a483a583a783a883a983aa83b083b18373837781f325838d839f83a083a183a283a383a583a683ad83ae83af83b083b183b283b783b983ba83bb83bc83bd83be83bf83c083c1
83c283c583c783c883c983ca83cb83cd83ce83d083d583d683d780cc31870f87138714871687178719871a871b871d872787288729872a872b872c872d872e872f873087318732873387388739873a873b873e874187428743874487458746874787488749874a874c874d874e874f8750875287558756875a875b8760876181
f50983e1842183e583e683e783f583d783fc83fd81f602842183fd80a69523951d952e9514952f954f300b2f315a80b380ec7e81368114811381328169816281b181ae818d81ad81fb822b8243820382658245828e82be82ae82d282fb82f9831483108316830d8312830e8343833b8342833c836c836e836d83698385838683
a683af83a783a483a883b183d583d2841e83d38481848584ba848984bb84c384e984c284e8852b8521852385298522856e85a385f085f885f685f985f785fa86138615862f8632863086398650864e8651864d865286ac86b186ab86ef86f186f486f286f687138715872687348723963f95689643959996459598964995aa96
4e95a995b495f095d895da965b95f2965d9611965c9621963c962987578750875487568772878c87b9878d87b887bb87ba87cb87d387cc87d587d287f887f1880c87f3880a8807884a8848886a886788ab88a388a788a9890f890d895b8954895c89568959895a8982898489c689ca89fc8a1689fb8a178a948a5d8aa98aa88a
ad8ac48ac58ac68af58af38b4f8b4e8ba58b868ba38bcb8bc68bca8bc88bc58bf88bf48bf98bf58c7b8c768c7a8cc38d128cc28d178d158d338d628d638d898d818d7f8dbc8db98dbd8dea8ddc8dba8dde8de88de08de68e088e118e0a8e228e418e448e3f8e3e8e408e438e708e758e738eb98eb88eb58ee78eeb8ee88eea8f
4e8f518f838f508fd78fda8fd88fd9901a901c9033901b9032904b904e904c907390709072907790749075908c909290ad908f90af90ab90eb90ed910190ec9121910391379123914e91509165916991ab916891ae920191d4920091d29255921e924f921d924e92aa92c492eb92ec92ea930b930d930c933493129331933993
3093329381937e937b937d938093a993bb93aa93d993da93ed93dd93eb93ec94149431944e94689490948b952294a803305880a600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
