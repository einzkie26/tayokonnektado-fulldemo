º
YE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Utilities\UtcDateTimeConverter.cs
	namespace 	"
TayoKonnektado_project
  
.  !
	Utilities! *
{ 
public 

class  
UtcDateTimeConverter %
:& '
JsonConverter( 5
<5 6
DateTime6 >
>> ?
{ 
public 
override 
DateTime  
Read! %
(% &
ref& )
Utf8JsonReader* 8
reader9 ?
,? @
TypeA E
typeToConvertF S
,S T!
JsonSerializerOptionsU j
optionsk r
)r s
{ 	
var 
dt 
= 
reader 
. 
GetDateTime '
(' (
)( )
;) *
return 
DateTime 
. 
SpecifyKind '
(' (
dt( *
,* +
DateTimeKind, 8
.8 9
Utc9 <
)< =
;= >
} 	
public 
override 
void 
Write "
(" #
Utf8JsonWriter# 1
writer2 8
,8 9
DateTime: B
valueC H
,H I!
JsonSerializerOptionsJ _
options` g
)g h
{ 	
writer 
. 
WriteStringValue #
(# $
DateTime$ ,
., -
SpecifyKind- 8
(8 9
value9 >
,> ?
DateTimeKind@ L
.L M
UtcM P
)P Q
)Q R
;R S
} 	
} 
} ‹,
PE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\TokenService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{		 
public

 

class

 
TokenService

 
{ 
private 
readonly 
IConfiguration '
_configuration( 6
;6 7
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
public 
TokenService 
( 
IConfiguration *
configuration+ 8
,8 9 
ApplicationDbContext: N
contextO V
)V W
{ 	
_configuration 
= 
configuration *
;* +
_context 
= 
context 
; 
} 	
public 
async 
Task 
< 
string  
>  !
GenerateTokenAsync" 4
(4 5
string5 ;
email< A
,A B
stringC I
userIdJ P
,P Q
stringR X
?X Y
roleZ ^
=_ `
nulla e
)e f
{ 	
var 
jwtKey 
= 
Environment $
.$ %"
GetEnvironmentVariable% ;
(; <
$str< E
)E F
;F G
if 
( 
string 
. 
IsNullOrWhiteSpace )
() *
jwtKey* 0
)0 1
)1 2
throw 
new %
InvalidOperationException 3
(3 4
$str4 y
)y z
;z {
var 
key 
= 
new  
SymmetricSecurityKey .
(. /
Encoding/ 7
.7 8
UTF88 <
.< =
GetBytes= E
(E F
jwtKeyF L
)L M
)M N
;N O
var 
credentials 
= 
new !
SigningCredentials" 4
(4 5
key5 8
,8 9
SecurityAlgorithms: L
.L M

HmacSha256M W
)W X
;X Y
var 

claimsList 
= 
new  
List! %
<% &
Claim& +
>+ ,
{ 
new   
Claim   
(   

ClaimTypes   $
.  $ %
Email  % *
,  * +
email  , 1
)  1 2
,  2 3
new!! 
Claim!! 
(!! 

ClaimTypes!! $
.!!$ %
NameIdentifier!!% 3
,!!3 4
userId!!5 ;
)!!; <
,!!< =
new"" 
Claim"" 
("" #
JwtRegisteredClaimNames"" 1
.""1 2
Jti""2 5
,""5 6
Guid""7 ;
.""; <
NewGuid""< C
(""C D
)""D E
.""E F
ToString""F N
(""N O
)""O P
)""P Q
}## 
;## 
if%% 
(%% 
!%% 
string%% 
.%% 
IsNullOrEmpty%% %
(%%% &
role%%& *
)%%* +
)%%+ ,
{&& 

claimsList'' 
.'' 
Add'' 
('' 
new'' "
Claim''# (
(''( )

ClaimTypes'') 3
.''3 4
Role''4 8
,''8 9
role'': >
)''> ?
)''? @
;''@ A
}(( 
var** 
claims** 
=** 

claimsList** #
.**# $
ToArray**$ +
(**+ ,
)**, -
;**- .
var,, 
settings,, 
=,, 
await,,  
_context,,! )
.,,) *
SystemSettings,,* 8
.,,8 9
FirstOrDefaultAsync,,9 L
(,,L M
),,M N
;,,N O
var-- !
sessionTimeoutMinutes-- %
=--& '
settings--( 0
?--0 1
.--1 2
SessionTimeout--2 @
??--A C
$num--D F
;--F G
var// 
token// 
=// 
new// 
JwtSecurityToken// ,
(//, -
issuer00 
:00 
_configuration00 &
[00& '
$str00' 3
]003 4
,004 5
audience11 
:11 
_configuration11 (
[11( )
$str11) 7
]117 8
,118 9
claims22 
:22 
claims22 
,22 
expires33 
:33 
DateTime33 !
.33! "
UtcNow33" (
.33( )

AddMinutes33) 3
(333 4!
sessionTimeoutMinutes334 I
)33I J
,33J K
signingCredentials44 "
:44" #
credentials44$ /
)55 
;55 
return77 
new77 #
JwtSecurityTokenHandler77 .
(77. /
)77/ 0
.770 1

WriteToken771 ;
(77; <
token77< A
)77A B
;77B C
}88 	
public:: 
string:: 
GenerateToken:: #
(::# $
string::$ *
email::+ 0
,::0 1
string::2 8
userId::9 ?
,::? @
string::A G
?::G H
role::I M
=::N O
null::P T
)::T U
{;; 	
return<< 
GenerateTokenAsync<< %
(<<% &
email<<& +
,<<+ ,
userId<<- 3
,<<3 4
role<<5 9
)<<9 :
.<<: ;
Result<<; A
;<<A B
}== 	
}>> 
}?? Â"
^E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\SubscriptionEndDateService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class &
SubscriptionEndDateService +
:, -
BackgroundService. ?
{ 
private 
readonly 
IServiceProvider )
_serviceProvider* :
;: ;
private		 
readonly		 
ILogger		  
<		  !&
SubscriptionEndDateService		! ;
>		; <
_logger		= D
;		D E
public &
SubscriptionEndDateService )
() *
IServiceProvider* :
serviceProvider; J
,J K
ILoggerL S
<S T&
SubscriptionEndDateServiceT n
>n o
loggerp v
)v w
{ 	
_serviceProvider 
= 
serviceProvider .
;. /
_logger 
= 
logger 
; 
} 	
	protected 
override 
async  
Task! %
ExecuteAsync& 2
(2 3
CancellationToken3 D
stoppingTokenE R
)R S
{ 	
while 
( 
! 
stoppingToken !
.! "#
IsCancellationRequested" 9
)9 :
{ 
try 
{ 
using 
( 
var 
scope $
=% &
_serviceProvider' 7
.7 8
CreateScope8 C
(C D
)D E
)E F
{ 
var 
context #
=$ %
scope& +
.+ ,
ServiceProvider, ;
.; <
GetRequiredService< N
<N O 
ApplicationDbContextO c
>c d
(d e
)e f
;f g
var 
today !
=" #
DateTime$ ,
., -
UtcNow- 3
.3 4
Date4 8
;8 9
var %
subscriptionsToDeactivate 5
=6 7
await8 =
context> E
.E F
SubscriptionsF S
. 
Where "
(" #
s# $
=>% '
s( )
.) *
Status* 0
==1 3
$str4 <
&&= ?
s@ A
.A B
EndDateB I
.I J
HasValueJ R
&&S U
sV W
.W X
EndDateX _
._ `
Value` e
.e f
Datef j
<=k m
todayn s
)s t
. 
ToListAsync (
(( )
stoppingToken) 6
)6 7
;7 8
if   
(   %
subscriptionsToDeactivate   5
.  5 6
Any  6 9
(  9 :
)  : ;
)  ; <
{!! 
foreach"" #
(""$ %
var""% (
sub"") ,
in""- /%
subscriptionsToDeactivate""0 I
)""I J
{## 
sub$$  #
.$$# $
Status$$$ *
=$$+ ,
$str$$- 7
;$$7 8
}%% 
await&& !
context&&" )
.&&) *
SaveChangesAsync&&* :
(&&: ;
stoppingToken&&; H
)&&H I
;&&I J
_logger'' #
.''# $
LogInformation''$ 2
(''2 3
$"''3 5
$str''5 A
{''A B%
subscriptionsToDeactivate''B [
.''[ \
Count''\ a
}''a b
$str	''b à
"
''à â
)
''â ä
;
''ä ã
}(( 
})) 
}** 
catch++ 
(++ 
	Exception++  
ex++! #
)++# $
{,, 
_logger-- 
.-- 
LogError-- $
(--$ %
$"--% '
$str--' L
{--L M
ex--M O
.--O P
Message--P W
}--W X
"--X Y
)--Y Z
;--Z [
}.. 
await00 
Task00 
.00 
Delay00  
(00  !
TimeSpan00! )
.00) *
	FromHours00* 3
(003 4
$num004 5
)005 6
,006 7
stoppingToken008 E
)00E F
;00F G
}11 
}22 	
}33 
}44 ¡+
bE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Security\PasswordBreachService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Security* 2
{ 
public 

class !
PasswordBreachService &
{ 
private		 
readonly		 

HttpClient		 #
_httpClient		$ /
;		/ 0
public !
PasswordBreachService $
($ %

HttpClient% /

httpClient0 :
): ;
{ 	
_httpClient 
= 

httpClient $
;$ %
} 	
public 
async 
Task 
< 
bool 
> 
IsBreachedAsync  /
(/ 0
string0 6
password7 ?
,? @
CancellationTokenA R
cancellationTokenS d
=e f
defaultg n
)n o
{ 	
if 
( 
string 
. 
IsNullOrWhiteSpace )
() *
password* 2
)2 3
)3 4
return 
false 
; 
var 
hash 
= 
ComputeSha1 "
(" #
password# +
)+ ,
;, -
var 
prefix 
= 
hash 
[ 
..  
$num  !
]! "
;" #
var 
suffix 
= 
hash 
[ 
$num 
.. !
]! "
;" #
var 
request 
= 
new 
HttpRequestMessage 0
(0 1

HttpMethod1 ;
.; <
Get< ?
,? @
$"A C
$strC h
{h i
prefixi o
}o p
"p q
)q r
;r s
request 
. 
Headers 
. 
	UserAgent %
.% &
Add& )
() *
new* -"
ProductInfoHeaderValue. D
(D E
$strE U
,U V
$strW \
)\ ]
)] ^
;^ _
var 
response 
= 
await  
_httpClient! ,
., -
	SendAsync- 6
(6 7
request7 >
,> ?
cancellationToken@ Q
)Q R
;R S
if 
( 
! 
response 
. 
IsSuccessStatusCode -
)- .
return 
false 
; 
var   
body   
=   
await   
response   %
.  % &
Content  & -
.  - .
ReadAsStringAsync  . ?
(  ? @
cancellationToken  @ Q
)  Q R
;  R S
var!! 
lines!! 
=!! 
body!! 
.!! 
Split!! "
(!!" #
$char!!# '
,!!' (
StringSplitOptions!!) ;
.!!; <
RemoveEmptyEntries!!< N
)!!N O
;!!O P
foreach## 
(## 
var## 
line## 
in##  
lines##! &
)##& '
{$$ 
var%% 
parts%% 
=%% 
line%%  
.%%  !
Trim%%! %
(%%% &
)%%& '
.%%' (
Split%%( -
(%%- .
$char%%. 1
)%%1 2
;%%2 3
if&& 
(&& 
parts&& 
.&& 
Length&&  
<&&! "
$num&&# $
)&&$ %
continue&&& .
;&&. /
if'' 
('' 
string'' 
.'' 
Equals'' !
(''! "
parts''" '
[''' (
$num''( )
]'') *
,''* +
suffix'', 2
,''2 3
StringComparison''4 D
.''D E
OrdinalIgnoreCase''E V
)''V W
)''W X
return(( 
true(( 
;((  
})) 
return++ 
false++ 
;++ 
},, 	
private.. 
static.. 
string.. 
ComputeSha1.. )
(..) *
string..* 0
input..1 6
)..6 7
{// 	
using00 
var00 
sha100 
=00 
SHA100 !
.00! "
Create00" (
(00( )
)00) *
;00* +
var11 
bytes11 
=11 
sha111 
.11 
ComputeHash11 (
(11( )
Encoding11) 1
.111 2
UTF8112 6
.116 7
GetBytes117 ?
(11? @
input11@ E
)11E F
)11F G
;11G H
var22 
sb22 
=22 
new22 
StringBuilder22 &
(22& '
bytes22' ,
.22, -
Length22- 3
*224 5
$num226 7
)227 8
;228 9
foreach33 
(33 
var33 
b33 
in33 
bytes33 #
)33# $
sb44 
.44 
Append44 
(44 
b44 
.44 
ToString44 $
(44$ %
$str44% )
)44) *
)44* +
;44+ ,
return55 
sb55 
.55 
ToString55 
(55 
)55  
;55  !
}66 	
}77 
}88 ªT
fE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Security\IpDeviceReputationService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Security* 2
{ 
public 

class %
IpDeviceReputationService *
{ 
private		 
readonly		 
SecuritySettings		 )
	_settings		* 3
;		3 4
private

 
readonly

  
ConcurrentDictionary

 -
<

- .
string

. 4
,

4 5
FailureWindow

6 C
>

C D
_ipFailures

E P
=

Q R
new

S V
(

V W
)

W X
;

X Y
private 
readonly  
ConcurrentDictionary -
<- .
string. 4
,4 5
FailureWindow6 C
>C D
_deviceFailuresE T
=U V
newW Z
(Z [
)[ \
;\ ]
public %
IpDeviceReputationService (
(( )
IOptions) 1
<1 2
SecuritySettings2 B
>B C
optionsD K
)K L
{ 	
	_settings 
= 
options 
.  
Value  %
;% &
} 	
public 
bool 
	IsBlocked 
( 
string $
?$ %
ip& (
,( )
string* 0
?0 1
	userAgent2 ;
,; <
out= @
stringA G
reasonH N
)N O
{ 	
reason 
= 
string 
. 
Empty !
;! "
if 
( 
! 
string 
. 
IsNullOrWhiteSpace *
(* +
ip+ -
)- .
&&/ 1
	_settings2 ;
.; <

BlockedIPs< F
.F G
AnyG J
(J K
bK L
=>M O
stringP V
.V W
EqualsW ]
(] ^
b^ _
,_ `
ipa c
,c d
StringComparisone u
.u v
OrdinalIgnoreCase	v á
)
á à
)
à â
)
â ä
{ 
reason 
= 
$str %
;% &
return 
true 
; 
} 
if 
( 
! 
string 
. 
IsNullOrWhiteSpace *
(* +
	userAgent+ 4
)4 5
&&6 8
	_settings9 B
.B C
BlockedUserAgentsC T
.T U
AnyU X
(X Y
bY Z
=>[ ]
	userAgent^ g
.g h
Containsh p
(p q
bq r
,r s
StringComparison	t Ñ
.
Ñ Ö
OrdinalIgnoreCase
Ö ñ
)
ñ ó
)
ó ò
)
ò ô
{ 
reason 
= 
$str )
;) *
return 
true 
; 
}   
if"" 
("" 
!"" 
string"" 
."" 
IsNullOrWhiteSpace"" *
(""* +
ip""+ -
)""- .
&&""/ 1
_ipFailures""2 =
.""= >
TryGetValue""> I
(""I J
ip""J L
,""L M
out""N Q
var""R U
ipWindow""V ^
)""^ _
&&""` b
ipWindow""c k
.""k l
BlockedUntilUtc""l {
>""| }
DateTime	""~ Ü
.
""Ü á
UtcNow
""á ç
)
""ç é
{## 
reason$$ 
=$$ 
$str$$ 3
;$$3 4
return%% 
true%% 
;%% 
}&& 
var(( 
	deviceKey(( 
=(( 
BuildDeviceKey(( *
(((* +
ip((+ -
,((- .
	userAgent((/ 8
)((8 9
;((9 :
if)) 
()) 
!)) 
string)) 
.)) 
IsNullOrWhiteSpace)) *
())* +
	deviceKey))+ 4
)))4 5
&&))6 8
_deviceFailures))9 H
.))H I
TryGetValue))I T
())T U
	deviceKey))U ^
,))^ _
out))` c
var))d g
deviceWindow))h t
)))t u
&&))v x
deviceWindow	))y Ö
.
))Ö Ü
BlockedUntilUtc
))Ü ï
>
))ñ ó
DateTime
))ò †
.
))† °
UtcNow
))° ß
)
))ß ®
{** 
reason++ 
=++ 
$str++ 3
;++3 4
return,, 
true,, 
;,, 
}-- 
return// 
false// 
;// 
}00 	
public22 
void22 
RegisterFailure22 #
(22# $
string22$ *
?22* +
ip22, .
,22. /
string220 6
?226 7
	userAgent228 A
)22A B
{33 	
if44 
(44 
!44 
string44 
.44 
IsNullOrWhiteSpace44 *
(44* +
ip44+ -
)44- .
)44. /
{55 
var66 
window66 
=66 
_ipFailures66 (
.66( )
GetOrAdd66) 1
(661 2
ip662 4
,664 5
_666 7
=>668 :
new66; >
FailureWindow66? L
(66L M
)66M N
)66N O
;66O P
window77 
.77 
RegisterFailure77 &
(77& '
	_settings77' 0
.770 1"
MaxFailedAttemptsPerIp771 G
,77G H
TimeSpan77I Q
.77Q R
FromMinutes77R ]
(77] ^
	_settings77^ g
.77g h
BlockMinutes77h t
)77t u
)77u v
;77v w
}88 
var:: 
	deviceKey:: 
=:: 
BuildDeviceKey:: *
(::* +
ip::+ -
,::- .
	userAgent::/ 8
)::8 9
;::9 :
if;; 
(;; 
!;; 
string;; 
.;; 
IsNullOrWhiteSpace;; *
(;;* +
	deviceKey;;+ 4
);;4 5
);;5 6
{<< 
var== 
window== 
=== 
_deviceFailures== ,
.==, -
GetOrAdd==- 5
(==5 6
	deviceKey==6 ?
,==? @
_==A B
=>==C E
new==F I
FailureWindow==J W
(==W X
)==X Y
)==Y Z
;==Z [
window>> 
.>> 
RegisterFailure>> &
(>>& '
	_settings>>' 0
.>>0 1&
MaxFailedAttemptsPerDevice>>1 K
,>>K L
TimeSpan>>M U
.>>U V
FromMinutes>>V a
(>>a b
	_settings>>b k
.>>k l
BlockMinutes>>l x
)>>x y
)>>y z
;>>z {
}?? 
}@@ 	
publicBB 
voidBB 
RegisterSuccessBB #
(BB# $
stringBB$ *
?BB* +
ipBB, .
,BB. /
stringBB0 6
?BB6 7
	userAgentBB8 A
)BBA B
{CC 	
ifDD 
(DD 
!DD 
stringDD 
.DD 
IsNullOrWhiteSpaceDD *
(DD* +
ipDD+ -
)DD- .
)DD. /
_ipFailuresEE 
.EE 
	TryRemoveEE %
(EE% &
ipEE& (
,EE( )
outEE* -
_EE. /
)EE/ 0
;EE0 1
varGG 
	deviceKeyGG 
=GG 
BuildDeviceKeyGG *
(GG* +
ipGG+ -
,GG- .
	userAgentGG/ 8
)GG8 9
;GG9 :
ifHH 
(HH 
!HH 
stringHH 
.HH 
IsNullOrWhiteSpaceHH *
(HH* +
	deviceKeyHH+ 4
)HH4 5
)HH5 6
_deviceFailuresII 
.II  
	TryRemoveII  )
(II) *
	deviceKeyII* 3
,II3 4
outII5 8
_II9 :
)II: ;
;II; <
}JJ 	
privateLL 
staticLL 
stringLL 
BuildDeviceKeyLL ,
(LL, -
stringLL- 3
?LL3 4
ipLL5 7
,LL7 8
stringLL9 ?
?LL? @
	userAgentLLA J
)LLJ K
{MM 	
ifNN 
(NN 
stringNN 
.NN 
IsNullOrWhiteSpaceNN )
(NN) *
ipNN* ,
)NN, -
||NN. 0
stringNN1 7
.NN7 8
IsNullOrWhiteSpaceNN8 J
(NNJ K
	userAgentNNK T
)NNT U
)NNU V
returnOO 
stringOO 
.OO 
EmptyOO #
;OO# $
returnQQ 
$"QQ 
{QQ 
ipQQ 
}QQ 
$strQQ 
{QQ 
	userAgentQQ $
}QQ$ %
"QQ% &
.QQ& '
ToLowerInvariantQQ' 7
(QQ7 8
)QQ8 9
;QQ9 :
}RR 	
privateTT 
sealedTT 
classTT 
FailureWindowTT *
{UU 	
privateVV 
intVV 
_countVV 
;VV 
privateWW 
DateTimeWW 
_windowStartUtcWW ,
=WW- .
DateTimeWW/ 7
.WW7 8
UtcNowWW8 >
;WW> ?
publicXX 
DateTimeXX 
BlockedUntilUtcXX +
{XX, -
getXX. 1
;XX1 2
privateXX3 :
setXX; >
;XX> ?
}XX@ A
=XXB C
DateTimeXXD L
.XXL M
MinValueXXM U
;XXU V
publicZZ 
voidZZ 
RegisterFailureZZ '
(ZZ' (
intZZ( +
maxAttemptsZZ, 7
,ZZ7 8
TimeSpanZZ9 A
blockDurationZZB O
)ZZO P
{[[ 
var\\ 
now\\ 
=\\ 
DateTime\\ "
.\\" #
UtcNow\\# )
;\\) *
if^^ 
(^^ 
now^^ 
-^^ 
_windowStartUtc^^ )
>^^* +
TimeSpan^^, 4
.^^4 5
FromMinutes^^5 @
(^^@ A
$num^^A C
)^^C D
)^^D E
{__ 
_windowStartUtc`` #
=``$ %
now``& )
;``) *
_countaa 
=aa 
$numaa 
;aa 
}bb 
_countdd 
++dd 
;dd 
ifff 
(ff 
_countff 
>=ff 
maxAttemptsff )
)ff) *
{gg 
BlockedUntilUtchh #
=hh$ %
nowhh& )
.hh) *
Addhh* -
(hh- .
blockDurationhh. ;
)hh; <
;hh< =
}ii 
}jj 
}kk 	
}ll 
}mm ÿQ
WE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\PrepaidUsageService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 
PrepaidUsageService $
:% &
BackgroundService' 8
{ 
private 
readonly 
IServiceProvider )
_serviceProvider* :
;: ;
private 
readonly 
ILogger  
<  !
PrepaidUsageService! 4
>4 5
_logger6 =
;= >
private 
readonly 
Random 
_random  '
=( )
new* -
(- .
). /
;/ 0
private 
static 
readonly 
TimeSpan  (
Interval) 1
=2 3
TimeSpan4 <
.< =
FromMinutes= H
(H I
$numI J
)J K
;K L
private 
const 
double 
MinMBPerCycle *
=+ ,
$num- 0
;0 1
private 
const 
double 
MaxMBPerCycle *
=+ ,
$num- 1
;1 2
public 
PrepaidUsageService "
(" #
IServiceProvider# 3
serviceProvider4 C
,C D
ILoggerE L
<L M
PrepaidUsageServiceM `
>` a
loggerb h
)h i
{ 	
_serviceProvider 
= 
serviceProvider .
;. /
_logger 
= 
logger 
; 
} 	
	protected!! 
override!! 
async!!  
Task!!! %
ExecuteAsync!!& 2
(!!2 3
CancellationToken!!3 D
stoppingToken!!E R
)!!R S
{"" 	
await$$ 
Task$$ 
.$$ 
Delay$$ 
($$ 
TimeSpan$$ %
.$$% &
FromSeconds$$& 1
($$1 2
$num$$2 4
)$$4 5
,$$5 6
stoppingToken$$7 D
)$$D E
;$$E F
while&& 
(&& 
!&& 
stoppingToken&& !
.&&! "#
IsCancellationRequested&&" 9
)&&9 :
{'' 
try(( 
{)) 
using** 
var** 
scope** #
=**$ %
_serviceProvider**& 6
.**6 7
CreateScope**7 B
(**B C
)**C D
;**D E
var++ 
context++ 
=++  !
scope++" '
.++' (
ServiceProvider++( 7
.++7 8
GetRequiredService++8 J
<++J K 
ApplicationDbContext++K _
>++_ `
(++` a
)++a b
;++b c
await-- 
ExpirePromosAsync-- +
(--+ ,
context--, 3
,--3 4
stoppingToken--5 B
)--B C
;--C D
await.. 
ApplyUsageAsync.. )
(..) *
context..* 1
,..1 2
stoppingToken..3 @
)..@ A
;..A B
}// 
catch00 
(00 
	Exception00  
ex00! #
)00# $
{11 
_logger22 
.22 
LogError22 $
(22$ %
$"22% '
$str22' E
{22E F
ex22F H
.22H I
Message22I P
}22P Q
"22Q R
)22R S
;22S T
}33 
await55 
Task55 
.55 
Delay55  
(55  !
Interval55! )
,55) *
stoppingToken55+ 8
)558 9
;559 :
}66 
}77 	
private99 
async99 
Task99 
ExpirePromosAsync99 ,
(99, - 
ApplicationDbContext99- A
context99B I
,99I J
CancellationToken99K \
stoppingToken99] j
)99j k
{:: 	
var;; 
expiredPromos;; 
=;; 
await;;  %
context;;& -
.;;- .
PrepaidPromos;;. ;
.<< 
Where<< 
(<< 
p<< 
=><< 
p<< 
.<< 
Status<< $
==<<% '
$str<<( 0
&&<<1 3
p<<4 5
.<<5 6
	ExpiresAt<<6 ?
<=<<@ B
DateTime<<C K
.<<K L
UtcNow<<L R
)<<R S
.== 
ToListAsync== 
(== 
stoppingToken== *
)==* +
;==+ ,
foreach?? 
(?? 
var?? 
ep?? 
in?? 
expiredPromos?? ,
)??, -
{@@ 
epAA 
.AA 
StatusAA 
=AA 
$strAA %
;AA% &
_loggerBB 
.BB 
LogInformationBB &
(BB& '
$"BB' )
$strBB) 0
{BB0 1
epBB1 3
.BB3 4

PromoTitleBB4 >
}BB> ?
$strBB? C
{BBC D
epBBD F
.BBF G
PrepaidPromoIDBBG U
}BBU V
$strBBV `
"BB` a
)BBa b
;BBb c
}CC 
ifEE 
(EE 
expiredPromosEE 
.EE 
CountEE #
>EE$ %
$numEE& '
)EE' (
awaitFF 
contextFF 
.FF 
SaveChangesAsyncFF .
(FF. /
stoppingTokenFF/ <
)FF< =
;FF= >
}GG 	
privateII 
asyncII 
TaskII 
ApplyUsageAsyncII *
(II* + 
ApplicationDbContextII+ ?
contextII@ G
,IIG H
CancellationTokenIII Z
stoppingTokenII[ h
)IIh i
{JJ 	
varKK 
activePromosKK 
=KK 
awaitKK $
contextKK% ,
.KK, -
PrepaidPromosKK- :
.LL 
IncludeLL 
(LL 
pLL 
=>LL 
pLL 
.LL  
PrepaidLoadLL  +
)LL+ ,
.MM 
ThenIncludeMM  
(MM  !
plMM! #
=>MM$ &
plMM' )
.MM) *
ServiceAccountMM* 8
)MM8 9
.NN 
WhereNN 
(NN 
pNN 
=>NN 
pNN 
.NN 
StatusNN $
==NN% '
$strNN( 0
&&OO 
pOO 
.OO 
RemainingDataMBOO -
>OO. /
$numOO0 1
&&PP 
pPP 
.PP 
PrepaidLoadPP )
.PP) *
ServiceAccountPP* 8
.PP8 9
StatusPP9 ?
==PP@ B
$strPPC K
&&QQ 
pQQ 
.QQ 
PrepaidLoadQQ )
.QQ) *
ServiceAccountQQ* 8
.QQ8 9
ServiceTypeQQ9 D
==QQE G
$strQQH Q
)QQQ R
.RR 
ToListAsyncRR 
(RR 
stoppingTokenRR *
)RR* +
;RR+ ,
ifTT 
(TT 
activePromosTT 
.TT 
CountTT "
==TT# %
$numTT& '
)TT' (
returnUU 
;UU 
foreachWW 
(WW 
varWW 
groupWW 
inWW !
activePromosWW" .
.WW. /
GroupByWW/ 6
(WW6 7
pWW7 8
=>WW9 ;
pWW< =
.WW= >
PrepaidLoadIDWW> K
)WWK L
)WWL M
{XX 
DeductFromGroupYY 
(YY  
groupYY  %
)YY% &
;YY& '
}ZZ 
await\\ 
context\\ 
.\\ 
SaveChangesAsync\\ *
(\\* +
stoppingToken\\+ 8
)\\8 9
;\\9 :
_logger]] 
.]] 
LogInformation]] "
(]]" #
$"]]# %
$str]]% =
{]]= >
activePromos]]> J
.]]J K
Count]]K P
}]]P Q
$str]]Q b
"]]b c
)]]c d
;]]d e
}^^ 	
private`` 
void`` 
DeductFromGroup`` $
(``$ %
IEnumerable``% 0
<``0 1
PrepaidPromo``1 =
>``= >
group``? D
)``D E
{aa 	
varbb 
deductionMBbb 
=bb 
(bb 
decimalbb &
)bb& '
(bb' (
MinMBPerCyclebb( 5
+bb6 7
(bb8 9
_randombb9 @
.bb@ A

NextDoublebbA K
(bbK L
)bbL M
*bbN O
(bbP Q
MaxMBPerCyclebbQ ^
-bb_ `
MinMBPerCyclebba n
)bbn o
)bbo p
)bbp q
;bbq r
varcc 
	remainingcc 
=cc 
deductionMBcc '
;cc' (
foreachee 
(ee 
varee 
promoee 
inee !
groupee" '
.ee' (
OrderByee( /
(ee/ 0
pee0 1
=>ee2 4
pee5 6
.ee6 7
ActivatedAtee7 B
)eeB C
)eeC D
{ff 
ifgg 
(gg 
	remaininggg 
<=gg  
$numgg! "
)gg" #
breakgg$ )
;gg) *
varii 
	deductionii 
=ii 
Mathii  $
.ii$ %
Minii% (
(ii( )
	remainingii) 2
,ii2 3
promoii4 9
.ii9 :
RemainingDataMBii: I
)iiI J
;iiJ K
promojj 
.jj 
RemainingDataMBjj %
-=jj& (
	deductionjj) 2
;jj2 3
	remainingkk 
-=kk 
	deductionkk &
;kk& '
ifmm 
(mm 
promomm 
.mm 
RemainingDataMBmm )
<=mm* ,
$nummm- .
)mm. /
{nn 
promooo 
.oo 
RemainingDataMBoo )
=oo* +
$numoo, -
;oo- .
promopp 
.pp 
Statuspp  
=pp! "
$strpp# -
;pp- .
_loggerqq 
.qq 
LogInformationqq *
(qq* +
$"qq+ -
$strqq- 4
{qq4 5
promoqq5 :
.qq: ;

PromoTitleqq; E
}qqE F
$strqqF J
{qqJ K
promoqqK P
.qqP Q
PrepaidPromoIDqqQ _
}qq_ `
$strqq` p
"qqp q
)qqq r
;qqr s
}rr 
}ss 
}tt 	
}uu 
}vv Ÿ
NE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\PlanSeeder.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 

PlanSeeder 
{ 
public 
static 
async 
Task  
SeedPlansAsync! /
(/ 0 
ApplicationDbContext0 D
contextE L
)L M
{		 	
if

 
(

 
!

 
context

 
.

 
SubscriptionPlans

 *
.

* +
Any

+ .
(

. /
)

/ 0
)

0 1
{ 
context 
. 
SubscriptionPlans )
.) *
AddRange* 2
(2 3
new 
SubscriptionPlan (
{) *
PlanName+ 3
=4 5
$str6 D
,D E
	SpeedMbpsF O
=P Q
$numR X
,X Y
PriceZ _
=` a
$numb i
}j k
,k l
new 
SubscriptionPlan (
{) *
PlanName+ 3
=4 5
$str6 H
,H I
	SpeedMbpsJ S
=T U
$numV ]
,] ^
Price_ d
=e f
$numg o
}p q
,q r
new 
SubscriptionPlan (
{) *
PlanName+ 3
=4 5
$str6 G
,G H
	SpeedMbpsI R
=S T
$numU \
,\ ]
Price^ c
=d e
$numf n
}o p
,p q
new 
SubscriptionPlan (
{) *
PlanName+ 3
=4 5
$str6 E
,E F
	SpeedMbpsG P
=Q R
$numS Z
,Z [
Price\ a
=b c
$numd l
}m n
) 
; 
await 
context 
. 
SaveChangesAsync .
(. /
)/ 0
;0 1
} 
} 	
} 
} Ùß
SE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\PayMongoService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 
PayMongoService  
{ 
private 
readonly 

HttpClient #
_httpClient$ /
;/ 0
private		 
readonly		 
string		 

_secretKey		  *
;		* +
private

 
readonly

 
string

 
_appBaseUrl

  +
;

+ ,
public 
PayMongoService 
( 
IConfiguration -
configuration. ;
); <
{ 	
_httpClient 
= 
new 

HttpClient (
(( )
)) *
;* +

_secretKey 
= 
configuration &
[& '
$str' ;
]; <
!< =
;= >
_appBaseUrl 
= 
configuration '
[' (
$str( 4
]4 5
??6 8
$str9 P
;P Q
var 
	authToken 
= 
Convert #
.# $
ToBase64String$ 2
(2 3
Encoding3 ;
.; <
UTF8< @
.@ A
GetBytesA I
(I J
$"J L
{L M

_secretKeyM W
}W X
$strX Y
"Y Z
)Z [
)[ \
;\ ]
_httpClient 
. !
DefaultRequestHeaders -
.- .
Add. 1
(1 2
$str2 A
,A B
$"C E
$strE K
{K L
	authTokenL U
}U V
"V W
)W X
;X Y
} 	
public 
async 
Task 
< 
string  
>  !
CreatePaymentIntent" 5
(5 6
decimal6 =
amount> D
,D E
stringF L
descriptionM X
)X Y
{ 	
var 
payload 
= 
new 
{ 
data 
= 
new 
{ 

attributes 
=  
new! $
{ 
amount 
=  
(! "
int" %
)% &
(& '
amount' -
*. /
$num0 3
)3 4
,4 5"
payment_method_allowed .
=/ 0
new1 4
[4 5
]5 6
{7 8
$str9 ?
,? @
$strA H
}I J
,J K
currency  
=! "
$str# (
,( )
description   #
,  # $
capture_type!! $
=!!% &
$str!!' /
}"" 
}## 
}$$ 
;$$ 
var&& 
content&& 
=&& 
new&& 
StringContent&& +
(&&+ ,
JsonSerializer&&, :
.&&: ;
	Serialize&&; D
(&&D E
payload&&E L
)&&L M
,&&M N
Encoding&&O W
.&&W X
UTF8&&X \
,&&\ ]
$str&&^ p
)&&p q
;&&q r
var'' 
response'' 
='' 
await''  
_httpClient''! ,
.'', -
	PostAsync''- 6
(''6 7
$str''7 d
,''d e
content''f m
)''m n
;''n o
var(( 
result(( 
=(( 
await(( 
response(( '
.((' (
Content((( /
.((/ 0
ReadAsStringAsync((0 A
(((A B
)((B C
;((C D
Console** 
.** 
	WriteLine** 
(** 
$"**  
$str**  G
{**G H
result**H N
}**N O
"**O P
)**P Q
;**Q R
if,, 
(,, 
!,, 
response,, 
.,, 
IsSuccessStatusCode,, -
),,- .
{-- 
throw.. 
new.. 
	Exception.. #
(..# $
$"..$ &
$str..& :
{..: ;
result..; A
}..A B
"..B C
)..C D
;..D E
}// 
var11 
json11 
=11 
JsonDocument11 #
.11# $
Parse11$ )
(11) *
result11* 0
)110 1
;111 2
var22 
paymentIntentId22 
=22  !
json22" &
.22& '
RootElement22' 2
.222 3
GetProperty223 >
(22> ?
$str22? E
)22E F
.22F G
GetProperty22G R
(22R S
$str22S W
)22W X
.22X Y
	GetString22Y b
(22b c
)22c d
!22d e
;22e f
Console33 
.33 
	WriteLine33 
(33 
$"33  
$str33  8
{338 9
paymentIntentId339 H
}33H I
"33I J
)33J K
;33K L
return44 
paymentIntentId44 "
;44" #
}55 	
public77 
async77 
Task77 
<77 
string77  
>77  !
CreatePaymentMethod77" 5
(775 6
string776 <
type77= A
,77A B
PaymentDetails77C Q
details77R Y
)77Y Z
{88 	
object99 

attributes99 
;99 
if:: 
(:: 
type:: 
==:: 
$str:: 
):: 
{;; 

attributes<< 
=<< 
new<<  
{== 
type>> 
,>> 
details?? 
=?? 
new?? !
{@@ 
card_numberAA #
=AA$ %
detailsAA& -
.AA- .

CardNumberAA. 8
,AA8 9
	exp_monthBB !
=BB" #
detailsBB$ +
.BB+ ,
ExpMonthBB, 4
,BB4 5
exp_yearCC  
=CC! "
detailsCC# *
.CC* +
ExpYearCC+ 2
,CC2 3
cvcDD 
=DD 
detailsDD %
.DD% &
CvcDD& )
}EE 
}FF 
;FF 
}GG 
elseHH 
{II 

attributesJJ 
=JJ 
newJJ  
{JJ! "
typeJJ# '
}JJ( )
;JJ) *
}KK 
varMM 
payloadMM 
=MM 
newMM 
{MM 
dataMM  $
=MM% &
newMM' *
{MM+ ,

attributesMM- 7
}MM8 9
}MM: ;
;MM; <
varNN 
contentNN 
=NN 
newNN 
StringContentNN +
(NN+ ,
JsonSerializerNN, :
.NN: ;
	SerializeNN; D
(NND E
payloadNNE L
)NNL M
,NNM N
EncodingNNO W
.NNW X
UTF8NNX \
,NN\ ]
$strNN^ p
)NNp q
;NNq r
varOO 
responseOO 
=OO 
awaitOO  
_httpClientOO! ,
.OO, -
	PostAsyncOO- 6
(OO6 7
$strOO7 d
,OOd e
contentOOf m
)OOm n
;OOn o
varPP 
resultPP 
=PP 
awaitPP 
responsePP '
.PP' (
ContentPP( /
.PP/ 0
ReadAsStringAsyncPP0 A
(PPA B
)PPB C
;PPC D
ifRR 
(RR 
!RR 
responseRR 
.RR 
IsSuccessStatusCodeRR -
)RR- .
{SS 
throwTT 
newTT 
	ExceptionTT #
(TT# $
$"TT$ &
$strTT& :
{TT: ;
resultTT; A
}TTA B
"TTB C
)TTC D
;TTD E
}UU 
varWW 
jsonWW 
=WW 
JsonDocumentWW #
.WW# $
ParseWW$ )
(WW) *
resultWW* 0
)WW0 1
;WW1 2
ifXX 
(XX 
!XX 
jsonXX 
.XX 
RootElementXX !
.XX! "
TryGetPropertyXX" 0
(XX0 1
$strXX1 7
,XX7 8
outXX9 <
varXX= @
dataXXA E
)XXE F
)XXF G
{YY 
throwZZ 
newZZ 
	ExceptionZZ #
(ZZ# $
$"ZZ$ &
$strZZ& A
{ZZA B
resultZZB H
}ZZH I
"ZZI J
)ZZJ K
;ZZK L
}[[ 
return]] 
data]] 
.]] 
GetProperty]] #
(]]# $
$str]]$ (
)]]( )
.]]) *
	GetString]]* 3
(]]3 4
)]]4 5
!]]5 6
;]]6 7
}^^ 	
public`` 
async`` 
Task`` 
<`` 
string``  
>``  !
CreateGCashSource``" 3
(``3 4
decimal``4 ;
amount``< B
,``B C
string``D J
phoneNumber``K V
)``V W
{aa 	
varbb 
payloadbb 
=bb 
newbb 
{cc 
datadd 
=dd 
newdd 
{ee 

attributesff 
=ff  
newff! $
{gg 
amounthh 
=hh  
(hh! "
inthh" %
)hh% &
(hh& '
amounthh' -
*hh. /
$numhh0 3
)hh3 4
,hh4 5
redirectii  
=ii! "
newii# &
{jj 
successkk #
=kk$ %
$"kk& (
{kk( )
_appBaseUrlkk) 4
}kk4 5
$strkk5 ^
"kk^ _
,kk_ `
failedll "
=ll# $
$"ll% '
{ll' (
_appBaseUrlll( 3
}ll3 4
$strll4 \
"ll\ ]
}mm 
,mm 
typenn 
=nn 
$strnn &
,nn& '
currencyoo  
=oo! "
$stroo# (
}pp 
}qq 
}rr 
;rr 
vartt 
contenttt 
=tt 
newtt 
StringContenttt +
(tt+ ,
JsonSerializertt, :
.tt: ;
	Serializett; D
(ttD E
payloadttE L
)ttL M
,ttM N
EncodingttO W
.ttW X
UTF8ttX \
,tt\ ]
$strtt^ p
)ttp q
;ttq r
varuu 
responseuu 
=uu 
awaituu  
_httpClientuu! ,
.uu, -
	PostAsyncuu- 6
(uu6 7
$struu7 \
,uu\ ]
contentuu^ e
)uue f
;uuf g
varvv 
resultvv 
=vv 
awaitvv 
responsevv '
.vv' (
Contentvv( /
.vv/ 0
ReadAsStringAsyncvv0 A
(vvA B
)vvB C
;vvC D
ifxx 
(xx 
!xx 
responsexx 
.xx 
IsSuccessStatusCodexx -
)xx- .
{yy 
throwzz 
newzz 
	Exceptionzz #
(zz# $
$"zz$ &
$strzz& :
{zz: ;
resultzz; A
}zzA B
"zzB C
)zzC D
;zzD E
}{{ 
var}} 
json}} 
=}} 
JsonDocument}} #
.}}# $
Parse}}$ )
(}}) *
result}}* 0
)}}0 1
;}}1 2
var~~ 
data~~ 
=~~ 
json~~ 
.~~ 
RootElement~~ '
.~~' (
GetProperty~~( 3
(~~3 4
$str~~4 :
)~~: ;
;~~; <
var 
checkoutUrl 
= 
data "
." #
GetProperty# .
(. /
$str/ ;
); <
.< =
GetProperty= H
(H I
$strI S
)S T
.T U
GetPropertyU `
(` a
$stra o
)o p
.p q
	GetStringq z
(z {
){ |
;| }
return
ÅÅ 
checkoutUrl
ÅÅ 
!
ÅÅ 
;
ÅÅ  
}
ÇÇ 	
public
ÑÑ 
async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
string
ÑÑ  
>
ÑÑ  !$
GetPaymentIntentStatus
ÑÑ" 8
(
ÑÑ8 9
string
ÑÑ9 ?
paymentIntentId
ÑÑ@ O
)
ÑÑO P
{
ÖÖ 	
var
ÜÜ 
response
ÜÜ 
=
ÜÜ 
await
ÜÜ  
_httpClient
ÜÜ! ,
.
ÜÜ, -
GetAsync
ÜÜ- 5
(
ÜÜ5 6
$"
ÜÜ6 8
$str
ÜÜ8 d
{
ÜÜd e
paymentIntentId
ÜÜe t
}
ÜÜt u
"
ÜÜu v
)
ÜÜv w
;
ÜÜw x
var
áá 
result
áá 
=
áá 
await
áá 
response
áá '
.
áá' (
Content
áá( /
.
áá/ 0
ReadAsStringAsync
áá0 A
(
ááA B
)
ááB C
;
ááC D
Console
ââ 
.
ââ 
	WriteLine
ââ 
(
ââ 
$"
ââ  
$str
ââ  D
{
ââD E
result
ââE K
}
ââK L
"
ââL M
)
ââM N
;
ââN O
if
ãã 
(
ãã 
!
ãã 
response
ãã 
.
ãã !
IsSuccessStatusCode
ãã -
)
ãã- .
{
åå 
throw
çç 
new
çç 
	Exception
çç #
(
çç# $
$"
çç$ &
$str
çç& :
{
çç: ;
result
çç; A
}
ççA B
"
ççB C
)
ççC D
;
ççD E
}
éé 
var
êê 
json
êê 
=
êê 
JsonDocument
êê #
.
êê# $
Parse
êê$ )
(
êê) *
result
êê* 0
)
êê0 1
;
êê1 2
var
ëë 
status
ëë 
=
ëë 
json
ëë 
.
ëë 
RootElement
ëë )
.
ëë) *
GetProperty
ëë* 5
(
ëë5 6
$str
ëë6 <
)
ëë< =
.
ëë= >
GetProperty
ëë> I
(
ëëI J
$str
ëëJ V
)
ëëV W
.
ëëW X
GetProperty
ëëX c
(
ëëc d
$str
ëëd l
)
ëël m
.
ëëm n
	GetString
ëën w
(
ëëw x
)
ëëx y
;
ëëy z
return
íí 
status
íí 
!
íí 
;
íí 
}
ìì 	
public
ïï 
async
ïï 
Task
ïï 
<
ïï 
(
ïï 
bool
ïï 
success
ïï  '
,
ïï' (
string
ïï) /
?
ïï/ 0
checkoutUrl
ïï1 <
)
ïï< =
>
ïï= >!
AttachPaymentIntent
ïï? R
(
ïïR S
string
ïïS Y
paymentIntentId
ïïZ i
,
ïïi j
string
ïïk q
paymentMethodIdïïr Å
,ïïÅ Ç
stringïïÉ â
paymentTypeïïä ï
)ïïï ñ
{
ññ 	
var
óó 
payload
óó 
=
óó 
new
óó 
{
òò 
data
ôô 
=
ôô 
new
ôô 
{
öö 

attributes
õõ 
=
õõ  
new
õõ! $
{
úú 
payment_method
ùù &
=
ùù' (
paymentMethodId
ùù) 8
,
ùù8 9

return_url
ûû "
=
ûû# $
$"
ûû% '
{
ûû' (
_appBaseUrl
ûû( 3
}
ûû3 4
$str
ûû4 N
"
ûûN O
}
üü 
}
†† 
}
°° 
;
°° 
var
££ 
content
££ 
=
££ 
new
££ 
StringContent
££ +
(
££+ ,
JsonSerializer
££, :
.
££: ;
	Serialize
££; D
(
££D E
payload
££E L
)
££L M
,
££M N
Encoding
££O W
.
££W X
UTF8
££X \
,
££\ ]
$str
££^ p
)
££p q
;
££q r
var
§§ 
response
§§ 
=
§§ 
await
§§  
_httpClient
§§! ,
.
§§, -
	PostAsync
§§- 6
(
§§6 7
$"
§§7 9
$str
§§9 e
{
§§e f
paymentIntentId
§§f u
}
§§u v
$str
§§v }
"
§§} ~
,
§§~ 
content§§Ä á
)§§á à
;§§à â
var
•• 
result
•• 
=
•• 
await
•• 
response
•• '
.
••' (
Content
••( /
.
••/ 0
ReadAsStringAsync
••0 A
(
••A B
)
••B C
;
••C D
Console
ßß 
.
ßß 
	WriteLine
ßß 
(
ßß 
$"
ßß  
$str
ßß  G
{
ßßG H
result
ßßH N
}
ßßN O
"
ßßO P
)
ßßP Q
;
ßßQ R
if
©© 
(
©© 
!
©© 
response
©© 
.
©© !
IsSuccessStatusCode
©© -
)
©©- .
{
™™ 
Console
´´ 
.
´´ 
	WriteLine
´´ !
(
´´! "
$"
´´" $
$str
´´$ @
{
´´@ A
result
´´A G
}
´´G H
"
´´H I
)
´´I J
;
´´J K
return
¨¨ 
(
¨¨ 
false
¨¨ 
,
¨¨ 
null
¨¨ #
)
¨¨# $
;
¨¨$ %
}
≠≠ 
if
∞∞ 
(
∞∞ 
paymentType
∞∞ 
==
∞∞ 
$str
∞∞ &
)
∞∞& '
{
±± 
var
≤≤ 
json
≤≤ 
=
≤≤ 
JsonDocument
≤≤ '
.
≤≤' (
Parse
≤≤( -
(
≤≤- .
result
≤≤. 4
)
≤≤4 5
;
≤≤5 6
var
≥≥ 

attributes
≥≥ 
=
≥≥  
json
≥≥! %
.
≥≥% &
RootElement
≥≥& 1
.
≥≥1 2
GetProperty
≥≥2 =
(
≥≥= >
$str
≥≥> D
)
≥≥D E
.
≥≥E F
GetProperty
≥≥F Q
(
≥≥Q R
$str
≥≥R ^
)
≥≥^ _
;
≥≥_ `
if
µµ 
(
µµ 

attributes
µµ 
.
µµ 
TryGetProperty
µµ -
(
µµ- .
$str
µµ. ;
,
µµ; <
out
µµ= @
var
µµA D

nextAction
µµE O
)
µµO P
&&
µµQ S

nextAction
∂∂ 
.
∂∂ 
TryGetProperty
∂∂ -
(
∂∂- .
$str
∂∂. 8
,
∂∂8 9
out
∂∂: =
var
∂∂> A
redirect
∂∂B J
)
∂∂J K
&&
∂∂L N
redirect
∑∑ 
.
∑∑ 
TryGetProperty
∑∑ +
(
∑∑+ ,
$str
∑∑, 1
,
∑∑1 2
out
∑∑3 6
var
∑∑7 :
url
∑∑; >
)
∑∑> ?
)
∑∑? @
{
∏∏ 
var
ππ 
checkoutUrl
ππ #
=
ππ$ %
url
ππ& )
.
ππ) *
	GetString
ππ* 3
(
ππ3 4
)
ππ4 5
;
ππ5 6
Console
∫∫ 
.
∫∫ 
	WriteLine
∫∫ %
(
∫∫% &
$"
∫∫& (
$str
∫∫( <
{
∫∫< =
checkoutUrl
∫∫= H
}
∫∫H I
"
∫∫I J
)
∫∫J K
;
∫∫K L
return
ªª 
(
ªª 
true
ªª  
,
ªª  !
checkoutUrl
ªª" -
)
ªª- .
;
ªª. /
}
ºº 
}
ΩΩ 
return
øø 
(
øø 
true
øø 
,
øø 
null
øø 
)
øø 
;
øø  
}
¿¿ 	
public
¬¬ 
async
¬¬ 
Task
¬¬ 
<
¬¬ 
(
¬¬ 
string
¬¬ !
sourceId
¬¬" *
,
¬¬* +
string
¬¬, 2
checkoutUrl
¬¬3 >
)
¬¬> ?
>
¬¬? @
CreateSource
¬¬A M
(
¬¬M N
decimal
¬¬N U
amount
¬¬V \
,
¬¬\ ]
string
¬¬^ d
description
¬¬e p
)
¬¬p q
{
√√ 	
return
ƒƒ 
await
ƒƒ &
CreateSourceWithRedirect
ƒƒ 1
(
ƒƒ1 2
amount
ƒƒ2 8
,
ƒƒ8 9
description
ƒƒ: E
,
ƒƒE F
$"
≈≈ 
{
≈≈ 
_appBaseUrl
≈≈ 
}
≈≈ 
$str
≈≈ H
"
≈≈H I
,
≈≈I J
$"
∆∆ 
{
∆∆ 
_appBaseUrl
∆∆ 
}
∆∆ 
$str
∆∆ G
"
∆∆G H
)
∆∆H I
;
∆∆I J
}
«« 	
public
…… 
async
…… 
Task
…… 
<
…… 
(
…… 
string
…… !
sourceId
……" *
,
……* +
string
……, 2
checkoutUrl
……3 >
)
……> ?
>
……? @)
CreateSourceForPrepaidTopUp
……A \
(
……\ ]
decimal
……] d
amount
……e k
,
……k l
int
……m p
	prepaidId
……q z
,
……z {
string……| Ç
description……É é
)……é è
{
   	
return
ÀÀ 
await
ÀÀ &
CreateSourceWithRedirect
ÀÀ 1
(
ÀÀ1 2
amount
ÀÀ2 8
,
ÀÀ8 9
description
ÀÀ: E
,
ÀÀE F
$"
ÃÃ 
{
ÃÃ 
_appBaseUrl
ÃÃ 
}
ÃÃ 
$str
ÃÃ R
{
ÃÃR S
	prepaidId
ÃÃS \
}
ÃÃ\ ]
"
ÃÃ] ^
,
ÃÃ^ _
$"
ÕÕ 
{
ÕÕ 
_appBaseUrl
ÕÕ 
}
ÕÕ 
$str
ÕÕ Q
{
ÕÕQ R
	prepaidId
ÕÕR [
}
ÕÕ[ \
"
ÕÕ\ ]
)
ÕÕ] ^
;
ÕÕ^ _
}
ŒŒ 	
private
–– 
async
–– 
Task
–– 
<
–– 
(
–– 
string
–– "
sourceId
––# +
,
––+ ,
string
––- 3
checkoutUrl
––4 ?
)
––? @
>
––@ A&
CreateSourceWithRedirect
––B Z
(
––Z [
decimal
––[ b
amount
––c i
,
––i j
string
––k q
description
––r }
,
––} ~
string–– Ö

successUrl––Ü ê
,––ê ë
string––í ò
	failedUrl––ô ¢
)––¢ £
{
—— 	
var
““ 
payload
““ 
=
““ 
new
““ 
{
”” 
data
‘‘ 
=
‘‘ 
new
‘‘ 
{
’’ 

attributes
÷÷ 
=
÷÷  
new
÷÷! $
{
◊◊ 
amount
ÿÿ 
=
ÿÿ  
(
ÿÿ! "
int
ÿÿ" %
)
ÿÿ% &
(
ÿÿ& '
amount
ÿÿ' -
*
ÿÿ. /
$num
ÿÿ0 3
)
ÿÿ3 4
,
ÿÿ4 5
redirect
ŸŸ  
=
ŸŸ! "
new
ŸŸ# &
{
⁄⁄ 
success
€€ #
=
€€$ %

successUrl
€€& 0
,
€€0 1
failed
‹‹ "
=
‹‹# $
	failedUrl
‹‹% .
}
›› 
,
›› 
type
ﬁﬁ 
=
ﬁﬁ 
$str
ﬁﬁ &
,
ﬁﬁ& '
currency
ﬂﬂ  
=
ﬂﬂ! "
$str
ﬂﬂ# (
,
ﬂﬂ( )
description
‡‡ #
}
·· 
}
‚‚ 
}
„„ 
;
„„ 
var
ÂÂ 
content
ÂÂ 
=
ÂÂ 
new
ÂÂ 
StringContent
ÂÂ +
(
ÂÂ+ ,
JsonSerializer
ÂÂ, :
.
ÂÂ: ;
	Serialize
ÂÂ; D
(
ÂÂD E
payload
ÂÂE L
)
ÂÂL M
,
ÂÂM N
Encoding
ÂÂO W
.
ÂÂW X
UTF8
ÂÂX \
,
ÂÂ\ ]
$str
ÂÂ^ p
)
ÂÂp q
;
ÂÂq r
var
ÊÊ 
response
ÊÊ 
=
ÊÊ 
await
ÊÊ  
_httpClient
ÊÊ! ,
.
ÊÊ, -
	PostAsync
ÊÊ- 6
(
ÊÊ6 7
$str
ÊÊ7 \
,
ÊÊ\ ]
content
ÊÊ^ e
)
ÊÊe f
;
ÊÊf g
var
ÁÁ 
result
ÁÁ 
=
ÁÁ 
await
ÁÁ 
response
ÁÁ '
.
ÁÁ' (
Content
ÁÁ( /
.
ÁÁ/ 0
ReadAsStringAsync
ÁÁ0 A
(
ÁÁA B
)
ÁÁB C
;
ÁÁC D
Console
ÈÈ 
.
ÈÈ 
	WriteLine
ÈÈ 
(
ÈÈ 
$"
ÈÈ  
$str
ÈÈ  8
{
ÈÈ8 9
result
ÈÈ9 ?
}
ÈÈ? @
"
ÈÈ@ A
)
ÈÈA B
;
ÈÈB C
if
ÎÎ 
(
ÎÎ 
!
ÎÎ 
response
ÎÎ 
.
ÎÎ !
IsSuccessStatusCode
ÎÎ -
)
ÎÎ- .
{
ÏÏ 
throw
ÌÌ 
new
ÌÌ 
	Exception
ÌÌ #
(
ÌÌ# $
$"
ÌÌ$ &
$str
ÌÌ& :
{
ÌÌ: ;
result
ÌÌ; A
}
ÌÌA B
"
ÌÌB C
)
ÌÌC D
;
ÌÌD E
}
ÓÓ 
var
 
json
 
=
 
JsonDocument
 #
.
# $
Parse
$ )
(
) *
result
* 0
)
0 1
;
1 2
var
ÒÒ 
data
ÒÒ 
=
ÒÒ 
json
ÒÒ 
.
ÒÒ 
RootElement
ÒÒ '
.
ÒÒ' (
GetProperty
ÒÒ( 3
(
ÒÒ3 4
$str
ÒÒ4 :
)
ÒÒ: ;
;
ÒÒ; <
var
ÚÚ 
sourceId
ÚÚ 
=
ÚÚ 
data
ÚÚ 
.
ÚÚ  
GetProperty
ÚÚ  +
(
ÚÚ+ ,
$str
ÚÚ, 0
)
ÚÚ0 1
.
ÚÚ1 2
	GetString
ÚÚ2 ;
(
ÚÚ; <
)
ÚÚ< =
!
ÚÚ= >
;
ÚÚ> ?
var
ÙÙ 

attributes
ÙÙ 
=
ÙÙ 
data
ÙÙ !
.
ÙÙ! "
GetProperty
ÙÙ" -
(
ÙÙ- .
$str
ÙÙ. :
)
ÙÙ: ;
;
ÙÙ; <
string
ıı 
?
ıı 
checkoutUrl
ıı 
=
ıı  !
null
ıı" &
;
ıı& '
if
˜˜ 
(
˜˜ 

attributes
˜˜ 
.
˜˜ 
TryGetProperty
˜˜ )
(
˜˜) *
$str
˜˜* 4
,
˜˜4 5
out
˜˜6 9
var
˜˜: =
redirect
˜˜> F
)
˜˜F G
)
˜˜G H
{
¯¯ 
if
˘˘ 
(
˘˘ 
redirect
˘˘ 
.
˘˘ 
TryGetProperty
˘˘ +
(
˘˘+ ,
$str
˘˘, :
,
˘˘: ;
out
˘˘< ?
var
˘˘@ C
url
˘˘D G
)
˘˘G H
)
˘˘H I
{
˙˙ 
checkoutUrl
˚˚ 
=
˚˚  !
url
˚˚" %
.
˚˚% &
	GetString
˚˚& /
(
˚˚/ 0
)
˚˚0 1
;
˚˚1 2
}
¸¸ 
}
˝˝ 
if
ˇˇ 
(
ˇˇ 
string
ˇˇ 
.
ˇˇ 
IsNullOrEmpty
ˇˇ $
(
ˇˇ$ %
checkoutUrl
ˇˇ% 0
)
ˇˇ0 1
)
ˇˇ1 2
{
ÄÄ 
Console
ÅÅ 
.
ÅÅ 
	WriteLine
ÅÅ !
(
ÅÅ! "
$"
ÅÅ" $
$str
ÅÅ$ h
{
ÅÅh i
result
ÅÅi o
}
ÅÅo p
"
ÅÅp q
)
ÅÅq r
;
ÅÅr s
throw
ÇÇ 
new
ÇÇ 
	Exception
ÇÇ #
(
ÇÇ# $
$"
ÇÇ$ &
$str
ÇÇ& X
{
ÇÇX Y
result
ÇÇY _
}
ÇÇ_ `
"
ÇÇ` a
)
ÇÇa b
;
ÇÇb c
}
ÉÉ 
return
ÖÖ 
(
ÖÖ 
sourceId
ÖÖ 
,
ÖÖ 
checkoutUrl
ÖÖ )
)
ÖÖ) *
;
ÖÖ* +
}
ÜÜ 	
public
àà 
async
àà 
Task
àà 
<
àà 
string
àà  
>
àà  !
CreatePayment
àà" /
(
àà/ 0
string
àà0 6
sourceId
àà7 ?
,
àà? @
decimal
ààA H
amount
ààI O
,
ààO P
string
ààQ W
description
ààX c
)
ààc d
{
ââ 	
var
ää 
payload
ää 
=
ää 
new
ää 
{
ãã 
data
åå 
=
åå 
new
åå 
{
çç 

attributes
éé 
=
éé  
new
éé! $
{
èè 
amount
êê 
=
êê  
(
êê! "
int
êê" %
)
êê% &
(
êê& '
amount
êê' -
*
êê. /
$num
êê0 3
)
êê3 4
,
êê4 5
source
ëë 
=
ëë  
new
ëë! $
{
íí 
id
ìì 
=
ìì  
sourceId
ìì! )
,
ìì) *
type
îî  
=
îî! "
$str
îî# +
}
ïï 
,
ïï 
currency
ññ  
=
ññ! "
$str
ññ# (
,
ññ( )
description
óó #
}
òò 
}
ôô 
}
öö 
;
öö 
var
úú 
content
úú 
=
úú 
new
úú 
StringContent
úú +
(
úú+ ,
JsonSerializer
úú, :
.
úú: ;
	Serialize
úú; D
(
úúD E
payload
úúE L
)
úúL M
,
úúM N
Encoding
úúO W
.
úúW X
UTF8
úúX \
,
úú\ ]
$str
úú^ p
)
úúp q
;
úúq r
var
ùù 
response
ùù 
=
ùù 
await
ùù  
_httpClient
ùù! ,
.
ùù, -
	PostAsync
ùù- 6
(
ùù6 7
$str
ùù7 ]
,
ùù] ^
content
ùù_ f
)
ùùf g
;
ùùg h
var
ûû 
result
ûû 
=
ûû 
await
ûû 
response
ûû '
.
ûû' (
Content
ûû( /
.
ûû/ 0
ReadAsStringAsync
ûû0 A
(
ûûA B
)
ûûB C
;
ûûC D
Console
†† 
.
†† 
	WriteLine
†† 
(
†† 
$"
††  
$str
††  9
{
††9 :
result
††: @
}
††@ A
"
††A B
)
††B C
;
††C D
if
¢¢ 
(
¢¢ 
!
¢¢ 
response
¢¢ 
.
¢¢ !
IsSuccessStatusCode
¢¢ -
)
¢¢- .
{
££ 
throw
§§ 
new
§§ 
	Exception
§§ #
(
§§# $
$"
§§$ &
$str
§§& :
{
§§: ;
result
§§; A
}
§§A B
"
§§B C
)
§§C D
;
§§D E
}
•• 
var
ßß 
json
ßß 
=
ßß 
JsonDocument
ßß #
.
ßß# $
Parse
ßß$ )
(
ßß) *
result
ßß* 0
)
ßß0 1
;
ßß1 2
var
®® 
	paymentId
®® 
=
®® 
json
®®  
.
®®  !
RootElement
®®! ,
.
®®, -
GetProperty
®®- 8
(
®®8 9
$str
®®9 ?
)
®®? @
.
®®@ A
GetProperty
®®A L
(
®®L M
$str
®®M Q
)
®®Q R
.
®®R S
	GetString
®®S \
(
®®\ ]
)
®®] ^
!
®®^ _
;
®®_ `
return
©© 
	paymentId
©© 
;
©© 
}
™™ 	
public
¨¨ 
async
¨¨ 
Task
¨¨ 
<
¨¨ 
string
¨¨  
>
¨¨  !
GetSourceStatus
¨¨" 1
(
¨¨1 2
string
¨¨2 8
sourceId
¨¨9 A
)
¨¨A B
{
≠≠ 	
var
ÆÆ 
response
ÆÆ 
=
ÆÆ 
await
ÆÆ  
_httpClient
ÆÆ! ,
.
ÆÆ, -
GetAsync
ÆÆ- 5
(
ÆÆ5 6
$"
ÆÆ6 8
$str
ÆÆ8 \
{
ÆÆ\ ]
sourceId
ÆÆ] e
}
ÆÆe f
"
ÆÆf g
)
ÆÆg h
;
ÆÆh i
var
ØØ 
result
ØØ 
=
ØØ 
await
ØØ 
response
ØØ '
.
ØØ' (
Content
ØØ( /
.
ØØ/ 0
ReadAsStringAsync
ØØ0 A
(
ØØA B
)
ØØB C
;
ØØC D
if
±± 
(
±± 
!
±± 
response
±± 
.
±± !
IsSuccessStatusCode
±± -
)
±±- .
{
≤≤ 
throw
≥≥ 
new
≥≥ 
	Exception
≥≥ #
(
≥≥# $
$"
≥≥$ &
$str
≥≥& :
{
≥≥: ;
result
≥≥; A
}
≥≥A B
"
≥≥B C
)
≥≥C D
;
≥≥D E
}
¥¥ 
var
∂∂ 
json
∂∂ 
=
∂∂ 
JsonDocument
∂∂ #
.
∂∂# $
Parse
∂∂$ )
(
∂∂) *
result
∂∂* 0
)
∂∂0 1
;
∂∂1 2
var
∑∑ 
status
∑∑ 
=
∑∑ 
json
∑∑ 
.
∑∑ 
RootElement
∑∑ )
.
∑∑) *
GetProperty
∑∑* 5
(
∑∑5 6
$str
∑∑6 <
)
∑∑< =
.
∑∑= >
GetProperty
∑∑> I
(
∑∑I J
$str
∑∑J V
)
∑∑V W
.
∑∑W X
GetProperty
∑∑X c
(
∑∑c d
$str
∑∑d l
)
∑∑l m
.
∑∑m n
	GetString
∑∑n w
(
∑∑w x
)
∑∑x y
;
∑∑y z
return
∏∏ 
status
∏∏ 
!
∏∏ 
;
∏∏ 
}
ππ 	
public
ªª 
async
ªª 
Task
ªª 
<
ªª 
bool
ªª 
>
ªª "
CapturePaymentIntent
ªª  4
(
ªª4 5
string
ªª5 ;
paymentIntentId
ªª< K
)
ªªK L
{
ºº 	
var
ææ 
statusResponse
ææ 
=
ææ  
await
ææ! &
_httpClient
ææ' 2
.
ææ2 3
GetAsync
ææ3 ;
(
ææ; <
$"
ææ< >
$str
ææ> j
{
ææj k
paymentIntentId
ææk z
}
ææz {
"
ææ{ |
)
ææ| }
;
ææ} ~
var
øø 
statusResult
øø 
=
øø 
await
øø $
statusResponse
øø% 3
.
øø3 4
Content
øø4 ;
.
øø; <
ReadAsStringAsync
øø< M
(
øøM N
)
øøN O
;
øøO P
Console
¿¿ 
.
¿¿ 
	WriteLine
¿¿ 
(
¿¿ 
$"
¿¿  
$str
¿¿  .
{
¿¿. /
statusResult
¿¿/ ;
}
¿¿; <
"
¿¿< =
)
¿¿= >
;
¿¿> ?
if
¬¬ 
(
¬¬ 
statusResponse
¬¬ 
.
¬¬ !
IsSuccessStatusCode
¬¬ 2
)
¬¬2 3
{
√√ 
var
ƒƒ 
json
ƒƒ 
=
ƒƒ 
JsonDocument
ƒƒ '
.
ƒƒ' (
Parse
ƒƒ( -
(
ƒƒ- .
statusResult
ƒƒ. :
)
ƒƒ: ;
;
ƒƒ; <
var
≈≈ 
status
≈≈ 
=
≈≈ 
json
≈≈ !
.
≈≈! "
RootElement
≈≈" -
.
≈≈- .
GetProperty
≈≈. 9
(
≈≈9 :
$str
≈≈: @
)
≈≈@ A
.
≈≈A B
GetProperty
≈≈B M
(
≈≈M N
$str
≈≈N Z
)
≈≈Z [
.
≈≈[ \
GetProperty
≈≈\ g
(
≈≈g h
$str
≈≈h p
)
≈≈p q
.
≈≈q r
	GetString
≈≈r {
(
≈≈{ |
)
≈≈| }
;
≈≈} ~
Console
∆∆ 
.
∆∆ 
	WriteLine
∆∆ !
(
∆∆! "
$"
∆∆" $
$str
∆∆$ 4
{
∆∆4 5
status
∆∆5 ;
}
∆∆; <
"
∆∆< =
)
∆∆= >
;
∆∆> ?
if
…… 
(
…… 
status
…… 
==
…… 
$str
…… )
)
……) *
{
   
return
ÀÀ 
true
ÀÀ 
;
ÀÀ  
}
ÃÃ 
if
œœ 
(
œœ 
status
œœ 
==
œœ 
$str
œœ 0
)
œœ0 1
{
–– 
var
—— 
content
—— 
=
——  !
new
——" %
StringContent
——& 3
(
——3 4
$str
——4 8
,
——8 9
Encoding
——: B
.
——B C
UTF8
——C G
,
——G H
$str
——I [
)
——[ \
;
——\ ]
var
““ 
response
““  
=
““! "
await
““# (
_httpClient
““) 4
.
““4 5
	PostAsync
““5 >
(
““> ?
$"
““? A
$str
““A m
{
““m n
paymentIntentId
““n }
}
““} ~
$str““~ Ü
"““Ü á
,““á à
content““â ê
)““ê ë
;““ë í
var
”” 
result
”” 
=
””  
await
””! &
response
””' /
.
””/ 0
Content
””0 7
.
””7 8
ReadAsStringAsync
””8 I
(
””I J
)
””J K
;
””K L
Console
’’ 
.
’’ 
	WriteLine
’’ %
(
’’% &
$"
’’& (
$str
’’( :
{
’’: ;
result
’’; A
}
’’A B
"
’’B C
)
’’C D
;
’’D E
if
◊◊ 
(
◊◊ 
!
◊◊ 
response
◊◊ !
.
◊◊! "!
IsSuccessStatusCode
◊◊" 5
)
◊◊5 6
{
ÿÿ 
throw
ŸŸ 
new
ŸŸ !
	Exception
ŸŸ" +
(
ŸŸ+ ,
$"
ŸŸ, .
$str
ŸŸ. =
{
ŸŸ= >
result
ŸŸ> D
}
ŸŸD E
"
ŸŸE F
)
ŸŸF G
;
ŸŸG H
}
⁄⁄ 
return
‹‹ 
true
‹‹ 
;
‹‹  
}
›› 
}
ﬁﬁ 
return
‡‡ 
true
‡‡ 
;
‡‡ 
}
·· 	
}
‚‚ 
public
‰‰ 

class
‰‰ 
PaymentDetails
‰‰ 
{
ÂÂ 
public
ÊÊ 
string
ÊÊ 

CardNumber
ÊÊ  
{
ÊÊ! "
get
ÊÊ# &
;
ÊÊ& '
set
ÊÊ( +
;
ÊÊ+ ,
}
ÊÊ- .
=
ÊÊ/ 0
string
ÊÊ1 7
.
ÊÊ7 8
Empty
ÊÊ8 =
;
ÊÊ= >
public
ÁÁ 
int
ÁÁ 
ExpMonth
ÁÁ 
{
ÁÁ 
get
ÁÁ !
;
ÁÁ! "
set
ÁÁ# &
;
ÁÁ& '
}
ÁÁ( )
public
ËË 
int
ËË 
ExpYear
ËË 
{
ËË 
get
ËË  
;
ËË  !
set
ËË" %
;
ËË% &
}
ËË' (
public
ÈÈ 
string
ÈÈ 
Cvc
ÈÈ 
{
ÈÈ 
get
ÈÈ 
;
ÈÈ  
set
ÈÈ! $
;
ÈÈ$ %
}
ÈÈ& '
=
ÈÈ( )
string
ÈÈ* 0
.
ÈÈ0 1
Empty
ÈÈ1 6
;
ÈÈ6 7
}
ÍÍ 
}ÎÎ ÖH
WE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\LoginAttemptService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 
LoginAttemptService $
{ 
private		 
readonly		  
ApplicationDbContext		 -
_context		. 6
;		6 7
public 
LoginAttemptService "
(" # 
ApplicationDbContext# 7
context8 ?
)? @
{ 	
_context 
= 
context 
; 
} 	
public 
async 
Task 
< 
( 
bool 
isLocked  (
,( )
string* 0
?0 1
message2 9
,9 :
int; >
?> ?
remainingMinutes@ P
)P Q
>Q R"
CheckLoginAttemptAsyncS i
(i j
stringj p
userIdq w
)w x
{ 	
var 
attempt 
= 
await 
_context  (
.( )
LoginAttempts) 6
.6 7
FirstOrDefaultAsync7 J
(J K
laK M
=>N P
laQ S
.S T
UserIDT Z
==[ ]
userId^ d
)d e
;e f
if 
( 
attempt 
== 
null 
)  
return 
( 
false 
, 
null #
,# $
null% )
)) *
;* +
if 
( 
attempt 
. 
LockedUntil #
.# $
HasValue$ ,
&&- /
attempt0 7
.7 8
LockedUntil8 C
>D E
DateTimeF N
.N O
UtcNowO U
)U V
{ 
var 
remainingMinutes $
=% &
(' (
int( +
)+ ,
Math, 0
.0 1
Ceiling1 8
(8 9
(9 :
attempt: A
.A B
LockedUntilB M
.M N
ValueN S
-T U
DateTimeV ^
.^ _
UtcNow_ e
)e f
.f g
TotalMinutesg s
)s t
;t u
return 
( 
true 
, 
$"  
$str  =
{= >
remainingMinutes> N
}N O
$strO X
"X Y
,Y Z
remainingMinutes[ k
)k l
;l m
} 
if 
( 
attempt 
. 
LockedUntil #
.# $
HasValue$ ,
&&- /
attempt0 7
.7 8
LockedUntil8 C
<=D F
DateTimeG O
.O P
UtcNowP V
)V W
{ 
attempt 
. 
FailedAttempts &
=' (
$num) *
;* +
attempt   
.   
LockedUntil   #
=  $ %
null  & *
;  * +
attempt!! 
.!! 

LockReason!! "
=!!# $
null!!% )
;!!) *
await"" 
_context"" 
."" 
SaveChangesAsync"" /
(""/ 0
)""0 1
;""1 2
}## 
return%% 
(%% 
false%% 
,%% 
null%% 
,%%  
null%%! %
)%%% &
;%%& '
}&& 	
public(( 
async(( 
Task(( $
RecordFailedAttemptAsync(( 2
(((2 3
string((3 9
userId((: @
)((@ A
{)) 	
var** 
attempt** 
=** 
await** 
_context**  (
.**( )
LoginAttempts**) 6
.**6 7
FirstOrDefaultAsync**7 J
(**J K
la**K M
=>**N P
la**Q S
.**S T
UserID**T Z
==**[ ]
userId**^ d
)**d e
;**e f
if,, 
(,, 
attempt,, 
==,, 
null,, 
),,  
{-- 
attempt.. 
=.. 
new.. 
LoginAttempt.. *
{..+ ,
UserID..- 3
=..4 5
userId..6 <
,..< =
FailedAttempts..> L
=..M N
$num..O P
,..P Q
LastAttemptAt..R _
=..` a
DateTime..b j
...j k
UtcNow..k q
}..r s
;..s t
_context// 
.// 
LoginAttempts// &
.//& '
Add//' *
(//* +
attempt//+ 2
)//2 3
;//3 4
}00 
else11 
{22 
attempt33 
.33 
FailedAttempts33 &
++33& (
;33( )
attempt44 
.44 
LastAttemptAt44 %
=44& '
DateTime44( 0
.440 1
UtcNow441 7
;447 8
}55 
if88 
(88 
attempt88 
.88 
FailedAttempts88 &
==88' )
$num88* +
)88+ ,
{99 
attempt:: 
.:: 
LockedUntil:: #
=::$ %
DateTime::& .
.::. /
UtcNow::/ 5
.::5 6

AddMinutes::6 @
(::@ A
$num::A C
)::C D
;::D E
attempt;; 
.;; 

LockReason;; "
=;;# $
$str;;% .
;;;. /
}<< 
else== 
if== 
(== 
attempt== 
.== 
FailedAttempts== +
>===, .
$num==/ 0
&&==1 3
attempt==4 ;
.==; <
FailedAttempts==< J
<===K M
$num==N O
)==O P
{>> 
attempt?? 
.?? 
LockedUntil?? #
=??$ %
DateTime??& .
.??. /
UtcNow??/ 5
.??5 6
AddHours??6 >
(??> ?
$num??? @
)??@ A
;??A B
attempt@@ 
.@@ 

LockReason@@ "
=@@# $
$str@@% .
;@@. /
}AA 
elseBB 
ifBB 
(BB 
attemptBB 
.BB 
FailedAttemptsBB +
>=BB, .
$numBB/ 0
)BB0 1
{CC 
attemptDD 
.DD 
LockedUntilDD #
=DD$ %
DateTimeDD& .
.DD. /
UtcNowDD/ 5
.DD5 6
AddDaysDD6 =
(DD= >
$numDD> @
)DD@ A
;DDA B
attemptEE 
.EE 

LockReasonEE "
=EE# $
$strEE% .
;EE. /
}FF 
awaitHH 
_contextHH 
.HH 
SaveChangesAsyncHH +
(HH+ ,
)HH, -
;HH- .
}II 	
publicKK 
asyncKK 
TaskKK 
ResetAttemptsAsyncKK ,
(KK, -
stringKK- 3
userIdKK4 :
)KK: ;
{LL 	
varMM 
attemptMM 
=MM 
awaitMM 
_contextMM  (
.MM( )
LoginAttemptsMM) 6
.MM6 7
FirstOrDefaultAsyncMM7 J
(MMJ K
laMMK M
=>MMN P
laMMQ S
.MMS T
UserIDMMT Z
==MM[ ]
userIdMM^ d
)MMd e
;MMe f
ifNN 
(NN 
attemptNN 
!=NN 
nullNN 
)NN  
{OO 
attemptPP 
.PP 
FailedAttemptsPP &
=PP' (
$numPP) *
;PP* +
attemptQQ 
.QQ 
LockedUntilQQ #
=QQ$ %
nullQQ& *
;QQ* +
attemptRR 
.RR 

LockReasonRR "
=RR# $
nullRR% )
;RR) *
awaitSS 
_contextSS 
.SS 
SaveChangesAsyncSS /
(SS/ 0
)SS0 1
;SS1 2
}TT 
}UU 	
publicWW 
asyncWW 
TaskWW 
<WW 
ListWW 
<WW 
LoginAttemptWW +
>WW+ ,
>WW, -"
GetSuspendedUsersAsyncWW. D
(WWD E
)WWE F
{XX 	
returnYY 
awaitYY 
_contextYY !
.YY! "
LoginAttemptsYY" /
.ZZ 
WhereZZ 
(ZZ 
laZZ 
=>ZZ 
laZZ 
.ZZ  
LockedUntilZZ  +
.ZZ+ ,
HasValueZZ, 4
&&ZZ5 7
laZZ8 :
.ZZ: ;
LockedUntilZZ; F
>ZZG H
DateTimeZZI Q
.ZZQ R
UtcNowZZR X
)ZZX Y
.[[ 
Include[[ 
([[ 
la[[ 
=>[[ 
la[[ !
.[[! "
User[[" &
)[[& '
.\\ 
OrderByDescending\\ "
(\\" #
la\\# %
=>\\& (
la\\) +
.\\+ ,
LockedUntil\\, 7
)\\7 8
.]] 
ToListAsync]] 
(]] 
)]] 
;]] 
}^^ 	
}__ 
}`` €.
PE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\EmailService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 
EmailService 
{ 
private 
readonly 
IConfiguration '
_configuration( 6
;6 7
public

 
EmailService

 
(

 
IConfiguration

 *
configuration

+ 8
)

8 9
{ 	
_configuration 
= 
configuration *
;* +
} 	
public 
async 
Task %
SendVerificationCodeAsync 3
(3 4
string4 :
email; @
,@ A
stringB H
codeI M
)M N
{ 	
try 
{ 
var 

smtpClient 
=  
new! $

SmtpClient% /
(/ 0
$str0 @
)@ A
{ 
Port 
= 
$num 
, 
Credentials 
=  !
new" %
NetworkCredential& 7
(7 8
_configuration &
[& '
$str' 7
]7 8
,8 9
_configuration &
[& '
$str' 7
]7 8
) 
, 
	EnableSsl 
= 
true  $
} 
; 
var 
mailMessage 
=  !
new" %
MailMessage& 1
{ 
From 
= 
new 
MailAddress *
(* +
_configuration+ 9
[9 :
$str: J
]J K
!K L
)L M
,M N
Subject   
=   
$str   H
,  H I
Body!! 
=!! 
$@"!! 
$str!# >
{##> ?
code##? C
}##C D
$str#%D 
"%% 
,%% 

IsBodyHtml&& 
=&&  
true&&! %
}'' 
;'' 
mailMessage(( 
.(( 
To(( 
.(( 
Add(( "
(((" #
email((# (
)((( )
;(() *
await** 

smtpClient**  
.**  !
SendMailAsync**! .
(**. /
mailMessage**/ :
)**: ;
;**; <
}++ 
catch,, 
(,, 
	Exception,, 
ex,, 
),,  
{-- 
Console.. 
... 
	WriteLine.. !
(..! "
$".." $
$str..$ 7
{..7 8
ex..8 :
...: ;
Message..; B
}..B C
"..C D
)..D E
;..E F
throw// 
;// 
}00 
}11 	
public33 
async33 
Task33 
SendEmailAsync33 (
(33( )
string33) /
email330 5
,335 6
string337 =
subject33> E
,33E F
string33G M
body33N R
)33R S
{44 	
try55 
{66 
Console77 
.77 
	WriteLine77 !
(77! "
$"77" $
$str77$ B
{77B C
email77C H
}77H I
$str77I L
"77L M
)77M N
;77N O
var88 

smtpClient88 
=88  
new88! $

SmtpClient88% /
(88/ 0
$str880 @
)88@ A
{99 
Port:: 
=:: 
$num:: 
,:: 
Credentials;; 
=;;  !
new;;" %
NetworkCredential;;& 7
(;;7 8
_configuration<< &
[<<& '
$str<<' 7
]<<7 8
,<<8 9
_configuration== &
[==& '
$str==' 7
]==7 8
)>> 
,>> 
	EnableSsl?? 
=?? 
true??  $
}@@ 
;@@ 
varBB 
mailMessageBB 
=BB  !
newBB" %
MailMessageBB& 1
{CC 
FromDD 
=DD 
newDD 
MailAddressDD *
(DD* +
_configurationDD+ 9
[DD9 :
$strDD: J
]DDJ K
!DDK L
)DDL M
,DDM N
SubjectEE 
=EE 
subjectEE %
,EE% &
BodyFF 
=FF 
bodyFF 
,FF  

IsBodyHtmlGG 
=GG  
trueGG! %
}HH 
;HH 
mailMessageII 
.II 
ToII 
.II 
AddII "
(II" #
emailII# (
)II( )
;II) *
ConsoleKK 
.KK 
	WriteLineKK !
(KK! "
$"KK" $
$strKK$ 5
{KK5 6
emailKK6 ;
}KK; <
$strKK< ?
"KK? @
)KK@ A
;KKA B
awaitLL 

smtpClientLL  
.LL  !
SendMailAsyncLL! .
(LL. /
mailMessageLL/ :
)LL: ;
;LL; <
ConsoleMM 
.MM 
	WriteLineMM !
(MM! "
$"MM" $
$strMM$ ?
{MM? @
emailMM@ E
}MME F
"MMF G
)MMG H
;MMH I
}NN 
catchOO 
(OO 
	ExceptionOO 
exOO 
)OO  
{PP 
ConsoleQQ 
.QQ 
	WriteLineQQ !
(QQ! "
$"QQ" $
$strQQ$ 7
{QQ7 8
exQQ8 :
.QQ: ;
MessageQQ; B
}QQB C
"QQC D
)QQD E
;QQE F
ConsoleRR 
.RR 
	WriteLineRR !
(RR! "
$"RR" $
$strRR$ 1
{RR1 2
exRR2 4
.RR4 5

StackTraceRR5 ?
}RR? @
"RR@ A
)RRA B
;RRB C
throwSS 
;SS 
}TT 
}UU 	
}VV 
}WW ¸a
aE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\TicketManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class #
TicketManagementService (
{ 
private		 
readonly		  
ApplicationDbContext		 -
_context		. 6
;		6 7
private

 
readonly

 
EmailService

 %
_emailService

& 3
;

3 4
public #
TicketManagementService &
(& ' 
ApplicationDbContext' ;
context< C
,C D
EmailServiceE Q
emailServiceR ^
)^ _
{ 	
_context 
= 
context 
; 
_emailService 
= 
emailService (
;( )
} 	
public 
async 
Task 
< 
object  
>  !
GetAllTicketsAsync" 4
(4 5
)5 6
{ 	
return 
await 
_context !
.! "
SupportTickets" 0
. 
Include 
( 
t 
=> 
t 
.  
User  $
)$ %
. 
Select 
( 
t 
=> 
new  
{ 
t 
. 
TicketID 
, 
t 
. 
UserID 
, 
t 
. 
Subject 
, 
t 
. 
Description !
,! "
t 
. 
Category 
, 
t 
. 
Priority 
, 
t 
. 
AttachmentUrl #
,# $
t 
. 
Status 
, 
t   
.   
AssignedStaffID   %
,  % &
t!! 
.!! 
	CreatedAt!! 
,!!  
t"" 
."" 

IsArchived""  
,""  !
User## 
=## 
new## 
{$$ 
t%% 
.%% 
User%% 
.%% 
Email%% $
,%%$ %
t&& 
.&& 
User&& 
.&& 
	FirstName&& (
,&&( )
t'' 
.'' 
User'' 
.'' 
LastName'' '
}(( 
})) 
))) 
.** 
ToListAsync** 
(** 
)** 
;** 
}++ 	
public-- 
async-- 
Task-- 
<-- 
bool-- 
>-- 
UpdateTicketAsync--  1
(--1 2
int--2 5
id--6 8
,--8 9
string--: @
status--A G
,--G H
string--I O
?--O P
assignedStaffID--Q `
)--` a
{.. 	
var// 
ticket// 
=// 
await// 
_context// '
.//' (
SupportTickets//( 6
.//6 7
	FindAsync//7 @
(//@ A
id//A C
)//C D
;//D E
if00 
(00 
ticket00 
==00 
null00 
)00 
return00  &
false00' ,
;00, -
ticket22 
.22 
Status22 
=22 
status22 "
;22" #
ticket33 
.33 
AssignedStaffID33 "
=33# $
assignedStaffID33% 4
;334 5
await44 
_context44 
.44 
SaveChangesAsync44 +
(44+ ,
)44, -
;44- .
return55 
true55 
;55 
}66 	
public88 
async88 
Task88 
<88 
bool88 
>88 
ReplyToTicketAsync88  2
(882 3
int883 6
id887 9
,889 :
string88; A
userId88B H
,88H I
string88J P
message88Q X
)88X Y
{99 	
var:: 
ticket:: 
=:: 
await:: 
_context:: '
.::' (
SupportTickets::( 6
.;; 
Include;; 
(;; 
t;; 
=>;; 
t;; 
.;;  
User;;  $
);;$ %
.<< 
FirstOrDefaultAsync<< $
(<<$ %
t<<% &
=><<' )
t<<* +
.<<+ ,
TicketID<<, 4
==<<5 7
id<<8 :
)<<: ;
;<<; <
if== 
(== 
ticket== 
==== 
null== 
)== 
return==  &
false==' ,
;==, -
var?? 
reply?? 
=?? 
new?? 
TicketReply?? '
{@@ 
TicketIDAA 
=AA 
idAA 
,AA 
UserIDBB 
=BB 
userIdBB 
,BB  
MessageCC 
=CC 
messageCC !
,CC! "
IsAdminReplyDD 
=DD 
trueDD #
}EE 
;EE 
_contextFF 
.FF 
TicketRepliesFF "
.FF" #
AddFF# &
(FF& '
replyFF' ,
)FF, -
;FF- .
ticketHH 
.HH 
StatusHH 
=HH 
$strHH )
;HH) *
varJJ 
notificationJJ 
=JJ 
newJJ "
NotificationJJ# /
{KK 
UserIDLL 
=LL 
ticketLL 
.LL  
UserIDLL  &
,LL& '
MessageMM 
=MM 
$"MM 
$strMM :
{MM: ;
ticketMM; A
.MMA B
SubjectMMB I
}MMI J
"MMJ K
,MMK L
TypeNN 
=NN 
$strNN %
,NN% &
StatusOO 
=OO 
$strOO !
}PP 
;PP 
_contextQQ 
.QQ 
NotificationsQQ "
.QQ" #
AddQQ# &
(QQ& '
notificationQQ' 3
)QQ3 4
;QQ4 5
awaitSS 
_contextSS 
.SS 
SaveChangesAsyncSS +
(SS+ ,
)SS, -
;SS- .
awaitTT %
SendTicketReplyEmailAsyncTT +
(TT+ ,
ticketTT, 2
,TT2 3
messageTT4 ;
)TT; <
;TT< =
returnUU 
trueUU 
;UU 
}VV 	
publicXX 
asyncXX 
TaskXX 
<XX 
boolXX 
>XX 
ArchiveTicketAsyncXX  2
(XX2 3
intXX3 6
idXX7 9
)XX9 :
{YY 	
varZZ 
ticketZZ 
=ZZ 
awaitZZ 
_contextZZ '
.ZZ' (
SupportTicketsZZ( 6
.ZZ6 7
	FindAsyncZZ7 @
(ZZ@ A
idZZA C
)ZZC D
;ZZD E
if[[ 
([[ 
ticket[[ 
==[[ 
null[[ 
||[[ !
ticket[[" (
.[[( )
Status[[) /
!=[[0 2
$str[[3 ;
)[[; <
return[[= C
false[[D I
;[[I J
ticket]] 
.]] 

IsArchived]] 
=]] 
true]]  $
;]]$ %
await^^ 
_context^^ 
.^^ 
SaveChangesAsync^^ +
(^^+ ,
)^^, -
;^^- .
return__ 
true__ 
;__ 
}`` 	
publicbb 
asyncbb 
Taskbb 
<bb 
boolbb 
>bb  
UnarchiveTicketAsyncbb  4
(bb4 5
intbb5 8
idbb9 ;
)bb; <
{cc 	
vardd 
ticketdd 
=dd 
awaitdd 
_contextdd '
.dd' (
SupportTicketsdd( 6
.dd6 7
	FindAsyncdd7 @
(dd@ A
idddA C
)ddC D
;ddD E
ifee 
(ee 
ticketee 
==ee 
nullee 
)ee 
returnee  &
falseee' ,
;ee, -
ticketgg 
.gg 

IsArchivedgg 
=gg 
falsegg  %
;gg% &
awaithh 
_contexthh 
.hh 
SaveChangesAsynchh +
(hh+ ,
)hh, -
;hh- .
returnii 
trueii 
;ii 
}jj 	
publicll 
asyncll 
Taskll 
<ll 
boolll 
>ll 
DeleteTicketAsyncll  1
(ll1 2
intll2 5
idll6 8
)ll8 9
{mm 	
varnn 
ticketnn 
=nn 
awaitnn 
_contextnn '
.nn' (
SupportTicketsnn( 6
.nn6 7
Includenn7 >
(nn> ?
tnn? @
=>nnA C
tnnD E
.nnE F
RepliesnnF M
)nnM N
.nnN O
FirstOrDefaultAsyncnnO b
(nnb c
tnnc d
=>nne g
tnnh i
.nni j
TicketIDnnj r
==nns u
idnnv x
)nnx y
;nny z
ifoo 
(oo 
ticketoo 
==oo 
nulloo 
)oo 
returnoo  &
falseoo' ,
;oo, -
ifpp 
(pp 
ticketpp 
.pp 
Statuspp 
!=pp  
$strpp! )
)pp) *
returnpp+ 1
falsepp2 7
;pp7 8
ifrr 
(rr 
ticketrr 
.rr 
Repliesrr 
!=rr !
nullrr" &
&&rr' )
ticketrr* 0
.rr0 1
Repliesrr1 8
.rr8 9
Anyrr9 <
(rr< =
)rr= >
)rr> ?
_contextss 
.ss 
TicketRepliesss &
.ss& '
RemoveRangess' 2
(ss2 3
ticketss3 9
.ss9 :
Repliesss: A
)ssA B
;ssB C
_contextuu 
.uu 
SupportTicketsuu #
.uu# $
Removeuu$ *
(uu* +
ticketuu+ 1
)uu1 2
;uu2 3
awaitvv 
_contextvv 
.vv 
SaveChangesAsyncvv +
(vv+ ,
)vv, -
;vv- .
returnww 
trueww 
;ww 
}xx 	
privatezz 
asynczz 
Taskzz %
SendTicketReplyEmailAsynczz 4
(zz4 5
SupportTicketzz5 B
ticketzzC I
,zzI J
stringzzK Q
replyMessagezzR ^
)zz^ _
{{{ 	
try|| 
{}} 
var~~ 
	emailBody~~ 
=~~ 
$@"~~  #
$str	~ó# 
{
óó 
ticket
óó 
.
óó 
User
óó  
.
óó  !
	FirstName
óó! *
}
óó* +
$str
óó+ ,
{
óó, -
ticket
óó- 3
.
óó3 4
User
óó4 8
.
óó8 9
LastName
óó9 A
}
óóA B
$str
óúB $
{
úú$ %
ticket
úú% +
.
úú+ ,
TicketID
úú, 4
}
úú4 5
$str
úû5 #
{
ûû# $
ticket
ûû$ *
.
ûû* +
Subject
ûû+ 2
}
ûû2 3
$str
û†3 #
{
††# $
ticket
††$ *
.
††* +
Status
††+ 1
}
††1 2
$str
†•2 N
{
••N O
replyMessage
••O [
}
••[ \
$str
•∑\ 
"
∑∑ 
;
∑∑ 	
await
ππ 
_emailService
ππ #
.
ππ# $
SendEmailAsync
ππ$ 2
(
ππ2 3
ticket
∫∫ 
.
∫∫ 
User
∫∫ 
.
∫∫  
Email
∫∫  %
!
∫∫% &
,
∫∫& '
$"
ªª 
$str
ªª &
{
ªª& '
ticket
ªª' -
.
ªª- .
TicketID
ªª. 6
}
ªª6 7
$str
ªª7 C
"
ªªC D
,
ªªD E
	emailBody
ºº 
)
ΩΩ 
;
ΩΩ 
}
ææ 
catch
øø 
(
øø 
	Exception
øø 
ex
øø 
)
øø  
{
¿¿ 
Console
¡¡ 
.
¡¡ 
	WriteLine
¡¡ !
(
¡¡! "
$"
¡¡" $
$str
¡¡$ G
{
¡¡G H
ex
¡¡H J
.
¡¡J K
Message
¡¡K R
}
¡¡R S
"
¡¡S T
)
¡¡T U
;
¡¡U V
}
¬¬ 
}
√√ 	
}
ƒƒ 
}≈≈ ¿q
gE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\SubscriptionManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class )
SubscriptionManagementService .
{		 
private

 
readonly

  
ApplicationDbContext

 -
_context

. 6
;

6 7
private 
readonly 
EmailService %
_emailService& 3
;3 4
public )
SubscriptionManagementService ,
(, - 
ApplicationDbContext- A
contextB I
,I J
EmailServiceK W
emailServiceX d
)d e
{ 	
_context 
= 
context 
; 
_emailService 
= 
emailService (
;( )
} 	
public 
async 
Task 
< 
object  
>  !$
GetAllSubscriptionsAsync" :
(: ;
); <
{ 	
return 
await 
_context !
.! "
Subscriptions" /
. 
Include 
( 
s 
=> 
s 
.  
User  $
)$ %
. 
Include 
( 
s 
=> 
s 
.  
Plan  $
)$ %
. 
Select 
( 
s 
=> 
new  
{ 
s 
. 
SubscriptionID $
,$ %
s 
. 
UserID 
, 
s 
. 
PlanID 
, 
s 
. 
	StartDate 
,  
s 
. 
EndDate 
, 
s 
. 
Status 
, 
User   
=   
new   
{    
s  ! "
.  " #
User  # '
.  ' (
	FirstName  ( 1
,  1 2
s  3 4
.  4 5
User  5 9
.  9 :
LastName  : B
,  B C
s  D E
.  E F
User  F J
.  J K
Email  K P
}  Q R
,  R S
Plan!! 
=!! 
new!! 
{!!  
s!!! "
.!!" #
Plan!!# '
.!!' (
PlanName!!( 0
,!!0 1
s!!2 3
.!!3 4
Plan!!4 8
.!!8 9
	SpeedMbps!!9 B
,!!B C
Price!!D I
=!!J K
s!!L M
.!!M N
Plan!!N R
.!!R S
Price!!S X
}!!Y Z
}"" 
)"" 
.## 
ToListAsync## 
(## 
)## 
;## 
}$$ 	
public&& 
async&& 
Task&& 
<&& 
bool&& 
>&& #
UpdateSubscriptionAsync&&  7
(&&7 8
int&&8 ;
id&&< >
,&&> ?
string&&@ F
status&&G M
,&&M N
int&&O R
?&&R S
planId&&T Z
,&&Z [
string&&\ b
?&&b c
endDate&&d k
)&&k l
{'' 	
var(( 
subscription(( 
=(( 
await(( $
_context((% -
.((- .
Subscriptions((. ;
.)) 
Include)) 
()) 
s)) 
=>)) 
s)) 
.))  
Plan))  $
)))$ %
.** 
Include** 
(** 
s** 
=>** 
s** 
.**  
User**  $
)**$ %
.++ 
FirstOrDefaultAsync++ $
(++$ %
s++% &
=>++' )
s++* +
.+++ ,
SubscriptionID++, :
==++; =
id++> @
)++@ A
;++A B
if,, 
(,, 
subscription,, 
==,, 
null,,  $
),,$ %
return,,& ,
false,,- 2
;,,2 3
var.. 
	oldStatus.. 
=.. 
subscription.. (
...( )
Status..) /
;../ 0
var// 
wasNotActive// 
=// 
subscription// +
.//+ ,
Status//, 2
!=//3 5
$str//6 >
;//> ?
subscription00 
.00 
Status00 
=00  !
status00" (
;00( )
if11 
(11 
planId11 
.11 
HasValue11 
)11  
subscription11! -
.11- .
PlanID11. 4
=115 6
planId117 =
.11= >
Value11> C
;11C D
if33 
(33 
string33 
.33 
IsNullOrEmpty33 $
(33$ %
endDate33% ,
)33, -
)33- .
{44 
subscription55 
.55 
EndDate55 $
=55% &
null55' +
;55+ ,
Console66 
.66 
	WriteLine66 !
(66! "
$"66" $
$str66$ F
{66F G
id66G I
}66I J
"66J K
)66K L
;66L M
}77 
else88 
{99 
try:: 
{;; 
subscription<<  
.<<  !
EndDate<<! (
=<<) *
DateTime<<+ 3
.<<3 4
Parse<<4 9
(<<9 :
endDate<<: A
)<<A B
;<<B C
Console== 
.== 
	WriteLine== %
(==% &
$"==& (
$str==( ;
{==; <
subscription==< H
.==H I
EndDate==I P
}==P Q
$str==Q c
{==c d
id==d f
}==f g
"==g h
)==h i
;==i j
}>> 
catch?? 
{@@ 
}BB 
}CC 
awaitEE 
_contextEE 
.EE 
SaveChangesAsyncEE +
(EE+ ,
)EE, -
;EE- .
ConsoleFF 
.FF 
	WriteLineFF 
(FF 
$"FF  
$strFF  -
{FF- .
idFF. 0
}FF0 1
$strFF1 F
{FFF G
subscriptionFFG S
.FFS T
EndDateFFT [
}FF[ \
"FF\ ]
)FF] ^
;FF^ _
ifII 
(II 
	oldStatusII 
!=II 
statusII #
&&II$ &
subscriptionII' 3
.II3 4
UserII4 8
!=II9 ;
nullII< @
)II@ A
{JJ 
varKK 
planNameKK 
=KK 
subscriptionKK +
.KK+ ,
PlanKK, 0
?KK0 1
.KK1 2
PlanNameKK2 :
??KK; =
$strKK> Q
;KKQ R
varLL 
statusMessageLL !
=LL" #
statusLL$ *
switchLL+ 1
{MM 
$strNN 
=>NN 
$"NN  "
$strNN" 5
{NN5 6
planNameNN6 >
}NN> ?
$strNN? }
"NN} ~
,NN~ 
$strOO 
=>OO 
$"OO  "
$strOO" 5
{OO5 6
planNameOO6 >
}OO> ?
$str	OO? õ
"
OOõ ú
,
OOú ù
$strPP 
=>PP !
$"PP" $
$strPP$ 7
{PP7 8
planNamePP8 @
}PP@ A
$str	PPA É
"
PPÉ Ñ
,
PPÑ Ö
_QQ 
=>QQ 
$"QQ 
$strQQ .
{QQ. /
planNameQQ/ 7
}QQ7 8
$strQQ8 U
{QQU V
statusQQV \
}QQ\ ]
$strQQ] ^
"QQ^ _
}RR 
;RR 
varTT 
	emailBodyTT 
=TT 
$@"TT  #
$strTV# 
{VV 
subscriptionVV *
.VV* +
UserVV+ /
.VV/ 0
	FirstNameVV0 9
}VV9 :
$strVV: ;
{VV; <
subscriptionVV< H
.VVH I
UserVVI M
.VVM N
LastNameVVN V
}VVV W
$strVWW 
{WW 
statusMessageWW %
}WW% &
$strW[& 
"[[ 
;[[ 
try]] 
{^^ 
await__ 
_emailService__ '
.__' (
SendEmailAsync__( 6
(__6 7
subscription__7 C
.__C D
User__D H
.__H I
Email__I N
!__N O
,__O P
$str__Q ~
,__~ 
	emailBody
__Ä â
)
__â ä
;
__ä ã
}`` 
catchaa 
(aa 
	Exceptionaa  
exaa! #
)aa# $
{bb 
Consolecc 
.cc 
	WriteLinecc %
(cc% &
$"cc& (
$strcc( R
{ccR S
exccS U
.ccU V
MessageccV ]
}cc] ^
"cc^ _
)cc_ `
;cc` a
}dd 
}ee 
returngg 
truegg 
;gg 
}hh 	
publicjj 
asyncjj 
Taskjj 
<jj 
booljj 
>jj #
DeleteSubscriptionAsyncjj  7
(jj7 8
intjj8 ;
idjj< >
)jj> ?
{kk 	
tryll 
{mm 
varnn 
subscriptionnn  
=nn! "
awaitnn# (
_contextnn) 1
.nn1 2
Subscriptionsnn2 ?
.oo 
FirstOrDefaultAsyncoo (
(oo( )
soo) *
=>oo+ -
soo. /
.oo/ 0
SubscriptionIDoo0 >
==oo? A
idooB D
)ooD E
;ooE F
ifpp 
(pp 
subscriptionpp  
==pp! #
nullpp$ (
)pp( )
returnpp* 0
falsepp1 6
;pp6 7
varss 

invoiceIdsss 
=ss  
awaitss! &
_contextss' /
.ss/ 0
Invoicesss0 8
.tt 
Wherett 
(tt 
itt 
=>tt 
itt  !
.tt! "
SubscriptionIDtt" 0
==tt1 3
idtt4 6
)tt6 7
.uu 
Selectuu 
(uu 
iuu 
=>uu  
iuu! "
.uu" #
	InvoiceIDuu# ,
)uu, -
.vv 
ToListAsyncvv  
(vv  !
)vv! "
;vv" #
varxx 
paymentsxx 
=xx 
awaitxx $
_contextxx% -
.xx- .
Paymentsxx. 6
.yy 
Whereyy 
(yy 
pyy 
=>yy 

invoiceIdsyy  *
.yy* +
Containsyy+ 3
(yy3 4
pyy4 5
.yy5 6
	InvoiceIDyy6 ?
??yy@ B
$numyyC D
)yyD E
)yyE F
.zz 
ToListAsynczz  
(zz  !
)zz! "
;zz" #
_context{{ 
.{{ 
Payments{{ !
.{{! "
RemoveRange{{" -
({{- .
payments{{. 6
){{6 7
;{{7 8
var~~ 
invoices~~ 
=~~ 
await~~ $
_context~~% -
.~~- .
Invoices~~. 6
. 
Where 
( 
i 
=> 
i  !
.! "
SubscriptionID" 0
==1 3
id4 6
)6 7
.
ÄÄ 
ToListAsync
ÄÄ  
(
ÄÄ  !
)
ÄÄ! "
;
ÄÄ" #
_context
ÅÅ 
.
ÅÅ 
Invoices
ÅÅ !
.
ÅÅ! "
RemoveRange
ÅÅ" -
(
ÅÅ- .
invoices
ÅÅ. 6
)
ÅÅ6 7
;
ÅÅ7 8
_context
ÑÑ 
.
ÑÑ 
Subscriptions
ÑÑ &
.
ÑÑ& '
Remove
ÑÑ' -
(
ÑÑ- .
subscription
ÑÑ. :
)
ÑÑ: ;
;
ÑÑ; <
await
ÖÖ 
_context
ÖÖ 
.
ÖÖ 
SaveChangesAsync
ÖÖ /
(
ÖÖ/ 0
)
ÖÖ0 1
;
ÖÖ1 2
return
ÜÜ 
true
ÜÜ 
;
ÜÜ 
}
áá 
catch
àà 
(
àà 
DbUpdateException
àà $
ex
àà% '
)
àà' (
{
ââ 
Console
ää 
.
ää 
	WriteLine
ää !
(
ää! "
$"
ää" $
$str
ää$ 7
{
ää7 8
ex
ää8 :
.
ää: ;
Message
ää; B
}
ääB C
"
ääC D
)
ääD E
;
ääE F
Console
ãã 
.
ãã 
	WriteLine
ãã !
(
ãã! "
$"
ãã" $
$str
ãã$ 4
{
ãã4 5
ex
ãã5 7
.
ãã7 8
InnerException
ãã8 F
?
ããF G
.
ããG H
Message
ããH O
}
ããO P
"
ããP Q
)
ããQ R
;
ããR S
if
åå 
(
åå 
ex
åå 
.
åå 
InnerException
åå %
is
åå& (
SqlException
åå) 5
sqlEx
åå6 ;
)
åå; <
{
çç 
Console
éé 
.
éé 
	WriteLine
éé %
(
éé% &
$"
éé& (
$str
éé( 3
{
éé3 4
sqlEx
éé4 9
.
éé9 :
Message
éé: A
}
ééA B
"
ééB C
)
ééC D
;
ééD E
foreach
èè 
(
èè 
SqlError
èè %
error
èè& +
in
èè, .
sqlEx
èè/ 4
.
èè4 5
Errors
èè5 ;
)
èè; <
{
êê 
Console
ëë 
.
ëë  
	WriteLine
ëë  )
(
ëë) *
$"
ëë* ,
$str
ëë, :
{
ëë: ;
error
ëë; @
.
ëë@ A
Number
ëëA G
}
ëëG H
$str
ëëH S
{
ëëS T
error
ëëT Y
.
ëëY Z
Message
ëëZ a
}
ëëa b
"
ëëb c
)
ëëc d
;
ëëd e
}
íí 
}
ìì 
throw
îî 
;
îî 
}
ïï 
catch
ññ 
(
ññ 
	Exception
ññ 
ex
ññ 
)
ññ  
{
óó 
Console
òò 
.
òò 
	WriteLine
òò !
(
òò! "
$"
òò" $
$str
òò$ A
{
òòA B
ex
òòB D
.
òòD E
Message
òòE L
}
òòL M
$str
òòM O
{
òòO P
ex
òòP R
.
òòR S
InnerException
òòS a
?
òòa b
.
òòb c
Message
òòc j
}
òòj k
"
òòk l
)
òòl m
;
òòm n
throw
ôô 
;
ôô 
}
öö 
}
õõ 	
}
úú 
}ùù ÆE
`E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\StaffManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class "
StaffManagementService '
{ 
private		 
readonly		 
UserManager		 $
<		$ %
ApplicationUser		% 4
>		4 5
_userManager		6 B
;		B C
public "
StaffManagementService %
(% &
UserManager& 1
<1 2
ApplicationUser2 A
>A B
userManagerC N
)N O
{ 	
_userManager 
= 
userManager &
;& '
} 	
public 
async 
Task 
< 
object  
>  !
GetAllStaffAsync" 2
(2 3
)3 4
{ 	
return 
await 
_userManager %
.% &
Users& +
. 
Where 
( 
u 
=> 
u 
. 
Role "
==# %
$str& -
||. 0
u1 2
.2 3
Role3 7
==8 :
$str; B
)B C
. 
Select 
( 
u 
=> 
new  
{ 
u 
. 
Id 
, 
Name 
= 
u 
. 
	FirstName &
+' (
$str) ,
+- .
u/ 0
.0 1
LastName1 9
,9 :
u 
. 
Email 
, 
u 
. 
Role 
, 
u 
. 
Status 
, 
u 
. 
	CreatedAt 
} 
) 
. 
ToListAsync 
( 
) 
; 
} 	
public   
async   
Task   
<   
(   
bool   
success    '
,  ' (
string  ) /
message  0 7
)  7 8
>  8 9
CreateStaffAsync  : J
(  J K
string  K Q
email  R W
,  W X
string  Y _
	firstName  ` i
,  i j
string  k q
lastName  r z
,  z {
string	  | Ç
password
  É ã
,
  ã å
string
  ç ì
role
  î ò
)
  ò ô
{!! 	
var"" 
user"" 
="" 
new"" 
ApplicationUser"" *
{## 
UserName$$ 
=$$ 
email$$  
,$$  !
Email%% 
=%% 
email%% 
,%% 
	FirstName&& 
=&& 
	firstName&& %
,&&% &
LastName'' 
='' 
lastName'' #
,''# $
EmailConfirmed(( 
=((  
true((! %
,((% &
Status)) 
=)) 
$str)) !
,))! "
Role** 
=** 
role** 
}++ 
;++ 
var,, 
result,, 
=,, 
await,, 
_userManager,, +
.,,+ ,
CreateAsync,,, 7
(,,7 8
user,,8 <
,,,< =
password,,> F
),,F G
;,,G H
if-- 
(-- 
!-- 
result-- 
.-- 
	Succeeded-- !
)--! "
return--# )
(--* +
false--+ 0
,--0 1
string--2 8
.--8 9
Join--9 =
(--= >
$str--> B
,--B C
result--D J
.--J K
Errors--K Q
.--Q R
Select--R X
(--X Y
e--Y Z
=>--[ ]
e--^ _
.--_ `
Description--` k
)--k l
)--l m
)--m n
;--n o
var// 

roleResult// 
=// 
await// "
_userManager//# /
./// 0
AddToRoleAsync//0 >
(//> ?
user//? C
,//C D
role//E I
)//I J
;//J K
if00 
(00 
!00 

roleResult00 
.00 
	Succeeded00 %
)00% &
{11 
await22 
_userManager22 "
.22" #
DeleteAsync22# .
(22. /
user22/ 3
)223 4
;224 5
return33 
(33 
false33 
,33 
$"33 !
$str33! '
{33' (
role33( ,
}33, -
$str33- =
"33= >
)33> ?
;33? @
}44 
return66 
(66 
true66 
,66 
$str66 6
)666 7
;667 8
}77 	
public99 
async99 
Task99 
<99 
bool99 
>99 
UpdateStaffAsync99  0
(990 1
string991 7
id998 :
,99: ;
string99< B
	firstName99C L
,99L M
string99N T
lastName99U ]
,99] ^
string99_ e
status99f l
,99l m
string99n t
role99u y
,99y z
string	99{ Å
?
99Å Ç
password
99É ã
=
99å ç
null
99é í
)
99í ì
{:: 	
var;; 
user;; 
=;; 
await;; 
_userManager;; )
.;;) *
FindByIdAsync;;* 7
(;;7 8
id;;8 :
);;: ;
;;;; <
if<< 
(<< 
user<< 
==<< 
null<< 
)<< 
return<< $
false<<% *
;<<* +
user>> 
.>> 
	FirstName>> 
=>> 
	firstName>> &
;>>& '
user?? 
.?? 
LastName?? 
=?? 
lastName?? $
;??$ %
user@@ 
.@@ 
Status@@ 
=@@ 
status@@  
;@@  !
ifCC 
(CC 
!CC 
stringCC 
.CC 
IsNullOrWhiteSpaceCC *
(CC* +
passwordCC+ 3
)CC3 4
)CC4 5
{DD 
varEE 
tokenEE 
=EE 
awaitEE !
_userManagerEE" .
.EE. /+
GeneratePasswordResetTokenAsyncEE/ N
(EEN O
userEEO S
)EES T
;EET U
awaitFF 
_userManagerFF "
.FF" #
ResetPasswordAsyncFF# 5
(FF5 6
userFF6 :
,FF: ;
tokenFF< A
,FFA B
passwordFFC K
)FFK L
;FFL M
}GG 
ifJJ 
(JJ 
userJJ 
.JJ 
RoleJJ 
!=JJ 
roleJJ !
)JJ! "
{KK 
varLL 
currentRolesLL  
=LL! "
awaitLL# (
_userManagerLL) 5
.LL5 6
GetRolesAsyncLL6 C
(LLC D
userLLD H
)LLH I
;LLI J
ifMM 
(MM 
currentRolesMM  
.MM  !
AnyMM! $
(MM$ %
)MM% &
)MM& '
{NN 
awaitOO 
_userManagerOO &
.OO& ' 
RemoveFromRolesAsyncOO' ;
(OO; <
userOO< @
,OO@ A
currentRolesOOB N
)OON O
;OOO P
}PP 
userQQ 
.QQ 
RoleQQ 
=QQ 
roleQQ  
;QQ  !
awaitRR 
_userManagerRR "
.RR" #
AddToRoleAsyncRR# 1
(RR1 2
userRR2 6
,RR6 7
roleRR8 <
)RR< =
;RR= >
}SS 
awaitUU 
_userManagerUU 
.UU 
UpdateAsyncUU *
(UU* +
userUU+ /
)UU/ 0
;UU0 1
returnVV 
trueVV 
;VV 
}WW 	
publicYY 
asyncYY 
TaskYY 
<YY 
boolYY 
>YY 
DeleteStaffAsyncYY  0
(YY0 1
stringYY1 7
idYY8 :
)YY: ;
{ZZ 	
var[[ 
user[[ 
=[[ 
await[[ 
_userManager[[ )
.[[) *
FindByIdAsync[[* 7
([[7 8
id[[8 :
)[[: ;
;[[; <
if\\ 
(\\ 
user\\ 
==\\ 
null\\ 
)\\ 
return\\ $
false\\% *
;\\* +
await^^ 
_userManager^^ 
.^^ 
DeleteAsync^^ *
(^^* +
user^^+ /
)^^/ 0
;^^0 1
return__ 
true__ 
;__ 
}`` 	
}aa 
}bb Ò 
_E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\PlanManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class !
PlanManagementService &
{ 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
public

 !
PlanManagementService

 $
(

$ % 
ApplicationDbContext

% 9
context

: A
)

A B
{ 	
_context 
= 
context 
; 
} 	
public 
async 
Task 
< 
object  
>  !
GetAllPlansAsync" 2
(2 3
)3 4
{ 	
return 
await 
_context !
.! "
SubscriptionPlans" 3
. 
Select 
( 
p 
=> 
new  
{ 
p 
. 
PlanID 
, 
p 
. 
PlanName 
, 
p 
. 
	SpeedMbps 
,  
Price 
= 
p 
. 
Price #
,# $
Subscribers 
=  !
_context" *
.* +
Subscriptions+ 8
.8 9
Count9 >
(> ?
s? @
=>A C
sD E
.E F
PlanIDF L
==M O
pP Q
.Q R
PlanIDR X
&&Y [
s\ ]
.] ^
Status^ d
==e g
$strh p
)p q
} 
) 
. 
ToListAsync 
( 
) 
; 
} 	
public 
async 
Task 
< 
bool 
> 
UpdatePlanAsync  /
(/ 0
int0 3
id4 6
,6 7
string8 >
planName? G
,G H
decimalI P
	speedMbpsQ Z
,Z [
decimal\ c
priced i
)i j
{ 	
var 
plan 
= 
await 
_context %
.% &
SubscriptionPlans& 7
.7 8
	FindAsync8 A
(A B
idB D
)D E
;E F
if   
(   
plan   
==   
null   
)   
return   $
false  % *
;  * +
plan"" 
."" 
PlanName"" 
="" 
planName"" $
;""$ %
plan## 
.## 
	SpeedMbps## 
=## 
	speedMbps## &
;##& '
plan$$ 
.$$ 
Price$$ 
=$$ 
price$$ 
;$$ 
await%% 
_context%% 
.%% 
SaveChangesAsync%% +
(%%+ ,
)%%, -
;%%- .
return&& 
true&& 
;&& 
}'' 	
public)) 
async)) 
Task)) 
<)) 
bool)) 
>)) 
DeletePlanAsync))  /
())/ 0
int))0 3
id))4 6
)))6 7
{** 	
var++ 
plan++ 
=++ 
await++ 
_context++ %
.++% &
SubscriptionPlans++& 7
.++7 8
	FindAsync++8 A
(++A B
id++B D
)++D E
;++E F
if,, 
(,, 
plan,, 
==,, 
null,, 
),, 
return,, $
false,,% *
;,,* +
_context.. 
... 
SubscriptionPlans.. &
...& '
Remove..' -
(..- .
plan... 2
)..2 3
;..3 4
await// 
_context// 
.// 
SaveChangesAsync// +
(//+ ,
)//, -
;//- .
return00 
true00 
;00 
}11 	
}22 
}33 í¥
bE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\PaymentManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class $
PaymentManagementService )
{ 
private		 
readonly		  
ApplicationDbContext		 -
_context		. 6
;		6 7
private

 
readonly

 
PayMongoService

 (
_payMongoService

) 9
;

9 :
private 
readonly 
EmailService %
_emailService& 3
;3 4
public $
PaymentManagementService '
(' ( 
ApplicationDbContext( <
context= D
,D E
PayMongoServiceF U
payMongoServiceV e
,e f
EmailServiceg s
emailService	t Ä
)
Ä Å
{ 	
_context 
= 
context 
; 
_payMongoService 
= 
payMongoService .
;. /
_emailService 
= 
emailService (
;( )
} 	
public 
async 
Task 
< 
object  
>  !
GetAllPaymentsAsync" 5
(5 6
)6 7
{ 	
return 
await 
_context !
.! "
Payments" *
. 
Include 
( 
p 
=> 
p 
.  
User  $
)$ %
. 
Include 
( 
p 
=> 
p 
.  
Invoice  '
)' (
. 
OrderByDescending "
(" #
p# $
=>% '
p( )
.) *
PaymentDate* 5
)5 6
. 
Select 
( 
p 
=> 
new  
{ 
p 
. 
	PaymentID 
,  
p 
. 
	InvoiceID 
,  
p 
. 
UserID 
, 
p 
. 

AmountPaid  
,  !
p   
.   
PaymentMethod   #
,  # $
p!! 
.!! 
ReferenceNum!! "
,!!" #
p"" 
."" 
PaymentDate"" !
,""! "
p## 
.## 
Status## 
,## 
p$$ 
.$$ 

IsArchived$$  
,$$  !
User%% 
=%% 
new%% 
{&& 
p'' 
.'' 
User'' 
.'' 
Email'' $
,''$ %
p(( 
.(( 
User(( 
.(( 
	FirstName(( (
,((( )
p)) 
.)) 
User)) 
.)) 
LastName)) '
,))' (
p** 
.** 
User** 
.** 
Status** %
}++ 
},, 
),, 
.-- 
ToListAsync-- 
(-- 
)-- 
;-- 
}.. 	
public00 
async00 
Task00 
<00 
(00 
bool00 
success00  '
,00' (
string00) /
message000 7
)007 8
>008 9
ApprovePaymentAsync00: M
(00M N
int00N Q
id00R T
)00T U
{11 	
var22 
payment22 
=22 
await22 
_context22  (
.22( )
Payments22) 1
.33 
Include33 
(33 
p33 
=>33 
p33 
.33  
Invoice33  '
)33' (
.44 
Include44 
(44 
p44 
=>44 
p44 
.44  
User44  $
)44$ %
.55 
FirstOrDefaultAsync55 $
(55$ %
p55% &
=>55' )
p55* +
.55+ ,
	PaymentID55, 5
==556 8
id559 ;
)55; <
;55< =
if77 
(77 
payment77 
==77 
null77 
)77  
return77! '
(77( )
false77) .
,77. /
$str770 C
)77C D
;77D E
if88 
(88 
payment88 
.88 
Status88 
!=88 !
$str88" +
)88+ ,
return88- 3
(884 5
false885 :
,88: ;
$str88< T
)88T U
;88U V
if;; 
(;; 
!;; 
string;; 
.;; 
IsNullOrEmpty;; %
(;;% &
payment;;& -
.;;- .
ReferenceNum;;. :
);;: ;
&&;;< >
payment;;? F
.;;F G
ReferenceNum;;G S
.;;S T

StartsWith;;T ^
(;;^ _
$str;;_ e
);;e f
);;f g
{<< 
payment== 
.== 
Status== 
===  
$str==! ,
;==, -
if>> 
(>> 
payment>> 
.>> 
Invoice>> #
!=>>$ &
null>>' +
)>>+ ,
payment>>- 4
.>>4 5
Invoice>>5 <
.>>< =
Status>>= C
=>>D E
$str>>F Q
;>>Q R
await?? 
_context?? 
.?? 
SaveChangesAsync?? /
(??/ 0
)??0 1
;??1 2
awaitBB $
GenerateNextInvoiceAsyncBB .
(BB. /
paymentBB/ 6
)BB6 7
;BB7 8
awaitDD !
SendReceiptEmailAsyncDD +
(DD+ ,
paymentDD, 3
)DD3 4
;DD4 5
awaitEE #
CreateNotificationAsyncEE -
(EE- .
paymentEE. 5
)EE5 6
;EE6 7
returnFF 
(FF 
trueFF 
,FF 
$strFF 1
)FF1 2
;FF2 3
}GG 
ifJJ 
(JJ 
!JJ 
stringJJ 
.JJ 
IsNullOrEmptyJJ %
(JJ% &
paymentJJ& -
.JJ- .
ReferenceNumJJ. :
)JJ: ;
&&JJ< >
paymentJJ? F
.JJF G
ReferenceNumJJG S
.JJS T

StartsWithJJT ^
(JJ^ _
$strJJ_ e
)JJe f
)JJf g
{KK 
tryLL 
{MM 
varNN 
statusNN 
=NN  
awaitNN! &
_payMongoServiceNN' 7
.NN7 8
GetSourceStatusNN8 G
(NNG H
paymentNNH O
.NNO P
ReferenceNumNNP \
)NN\ ]
;NN] ^
ifPP 
(PP 
statusPP 
==PP !
$strPP" .
)PP. /
{QQ 
varRR 
descriptionRR '
=RR( )
paymentRR* 1
.RR1 2
	InvoiceIDRR2 ;
.RR; <
HasValueRR< D
?RRE F
$"RRG I
$strRRI R
{RRR S
paymentRRS Z
.RRZ [
	InvoiceIDRR[ d
}RRd e
"RRe f
:RRg h
$strRRi r
;RRr s
varSS 
	paymentIdSS %
=SS& '
awaitSS( -
_payMongoServiceSS. >
.SS> ?
CreatePaymentSS? L
(SSL M
paymentSSM T
.SST U
ReferenceNumSSU a
,SSa b
paymentSSc j
.SSj k

AmountPaidSSk u
,SSu v
description	SSw Ç
)
SSÇ É
;
SSÉ Ñ
paymentTT 
.TT  
ReferenceNumTT  ,
=TT- .
	paymentIdTT/ 8
;TT8 9
}UU 
elseWW 
ifWW 
(WW 
statusWW #
!=WW$ &
$strWW' 3
)WW3 4
{XX 
ConsoleYY 
.YY  
	WriteLineYY  )
(YY) *
$"YY* ,
$strYY, P
{YYP Q
statusYYQ W
}YYW X
$strYYX ~
"YY~ 
)	YY Ä
;
YYÄ Å
}ZZ 
}[[ 
catch\\ 
(\\ 
	Exception\\  
ex\\! #
)\\# $
{]] 
Console^^ 
.^^ 
	WriteLine^^ %
(^^% &
$"^^& (
$str^^( F
{^^F G
ex^^G I
.^^I J
Message^^J Q
}^^Q R
$str^^R x
"^^x y
)^^y z
;^^z {
}__ 
}`` 
paymentcc 
.cc 
Statuscc 
=cc 
$strcc (
;cc( )
ifdd 
(dd 
paymentdd 
.dd 
Invoicedd 
!=dd  "
nulldd# '
)dd' (
paymentdd) 0
.dd0 1
Invoicedd1 8
.dd8 9
Statusdd9 ?
=dd@ A
$strddB M
;ddM N
awaitee 
_contextee 
.ee 
SaveChangesAsyncee +
(ee+ ,
)ee, -
;ee- .
awaithh $
GenerateNextInvoiceAsynchh *
(hh* +
paymenthh+ 2
)hh2 3
;hh3 4
awaitjj !
SendReceiptEmailAsyncjj '
(jj' (
paymentjj( /
)jj/ 0
;jj0 1
awaitkk #
CreateNotificationAsynckk )
(kk) *
paymentkk* 1
)kk1 2
;kk2 3
returnll 
(ll 
truell 
,ll 
$strll -
)ll- .
;ll. /
}mm 	
publicoo 
asyncoo 
Taskoo 
<oo 
booloo 
>oo 
RejectPaymentAsyncoo  2
(oo2 3
intoo3 6
idoo7 9
)oo9 :
{pp 	
varqq 
paymentqq 
=qq 
awaitqq 
_contextqq  (
.qq( )
Paymentsqq) 1
.qq1 2
	FindAsyncqq2 ;
(qq; <
idqq< >
)qq> ?
;qq? @
ifrr 
(rr 
paymentrr 
==rr 
nullrr 
||rr  "
paymentrr# *
.rr* +
Statusrr+ 1
!=rr2 4
$strrr5 >
)rr> ?
returnrr@ F
falserrG L
;rrL M
paymenttt 
.tt 
Statustt 
=tt 
$strtt '
;tt' (
awaituu 
_contextuu 
.uu 
SaveChangesAsyncuu +
(uu+ ,
)uu, -
;uu- .
returnvv 
truevv 
;vv 
}ww 	
publicyy 
asyncyy 
Taskyy 
<yy 
boolyy 
>yy 
ArchivePaymentAsyncyy  3
(yy3 4
intyy4 7
idyy8 :
)yy: ;
{zz 	
var{{ 
payment{{ 
={{ 
await{{ 
_context{{  (
.{{( )
Payments{{) 1
.{{1 2
	FindAsync{{2 ;
({{; <
id{{< >
){{> ?
;{{? @
if|| 
(|| 
payment|| 
==|| 
null|| 
)||  
return||! '
false||( -
;||- .
payment~~ 
.~~ 

IsArchived~~ 
=~~  
true~~! %
;~~% &
await 
_context 
. 
SaveChangesAsync +
(+ ,
), -
;- .
return
ÄÄ 
true
ÄÄ 
;
ÄÄ 
}
ÅÅ 	
public
ÉÉ 
async
ÉÉ 
Task
ÉÉ 
<
ÉÉ 
bool
ÉÉ 
>
ÉÉ #
UnarchivePaymentAsync
ÉÉ  5
(
ÉÉ5 6
int
ÉÉ6 9
id
ÉÉ: <
)
ÉÉ< =
{
ÑÑ 	
var
ÖÖ 
payment
ÖÖ 
=
ÖÖ 
await
ÖÖ 
_context
ÖÖ  (
.
ÖÖ( )
Payments
ÖÖ) 1
.
ÖÖ1 2
	FindAsync
ÖÖ2 ;
(
ÖÖ; <
id
ÖÖ< >
)
ÖÖ> ?
;
ÖÖ? @
if
ÜÜ 
(
ÜÜ 
payment
ÜÜ 
==
ÜÜ 
null
ÜÜ 
)
ÜÜ  
return
ÜÜ! '
false
ÜÜ( -
;
ÜÜ- .
payment
àà 
.
àà 

IsArchived
àà 
=
àà  
false
àà! &
;
àà& '
await
ââ 
_context
ââ 
.
ââ 
SaveChangesAsync
ââ +
(
ââ+ ,
)
ââ, -
;
ââ- .
return
ää 
true
ää 
;
ää 
}
ãã 	
public
çç 
async
çç 
Task
çç 
<
çç 
bool
çç 
>
çç  
DeletePaymentAsync
çç  2
(
çç2 3
int
çç3 6
id
çç7 9
)
çç9 :
{
éé 	
var
èè 
payment
èè 
=
èè 
await
èè 
_context
èè  (
.
èè( )
Payments
èè) 1
.
èè1 2
	FindAsync
èè2 ;
(
èè; <
id
èè< >
)
èè> ?
;
èè? @
if
êê 
(
êê 
payment
êê 
==
êê 
null
êê 
||
êê  "
!
êê# $
payment
êê$ +
.
êê+ ,

IsArchived
êê, 6
)
êê6 7
return
êê8 >
false
êê? D
;
êêD E
_context
íí 
.
íí 
Payments
íí 
.
íí 
Remove
íí $
(
íí$ %
payment
íí% ,
)
íí, -
;
íí- .
await
ìì 
_context
ìì 
.
ìì 
SaveChangesAsync
ìì +
(
ìì+ ,
)
ìì, -
;
ìì- .
return
îî 
true
îî 
;
îî 
}
ïï 	
private
óó 
async
óó 
Task
óó &
GenerateNextInvoiceAsync
óó 3
(
óó3 4
Payment
óó4 ;
payment
óó< C
)
óóC D
{
òò 	
try
ôô 
{
öö 
if
õõ 
(
õõ 
payment
õõ 
.
õõ 
Invoice
õõ #
==
õõ$ &
null
õõ' +
)
õõ+ ,
return
õõ- 3
;
õõ3 4
var
ùù 
subscriptionId
ùù "
=
ùù# $
payment
ùù% ,
.
ùù, -
Invoice
ùù- 4
.
ùù4 5
SubscriptionID
ùù5 C
;
ùùC D
if
ûû 
(
ûû 
subscriptionId
ûû "
==
ûû# %
null
ûû& *
)
ûû* +
return
ûû, 2
;
ûû2 3
var
°° 
existingNext
°°  
=
°°! "
await
°°# (
_context
°°) 1
.
°°1 2
Invoices
°°2 :
.
¢¢ !
FirstOrDefaultAsync
¢¢ (
(
¢¢( )
i
¢¢) *
=>
¢¢+ -
i
¢¢. /
.
¢¢/ 0
SubscriptionID
¢¢0 >
==
¢¢? A
subscriptionId
¢¢B P
&&
¢¢Q S
i
¢¢T U
.
¢¢U V
Status
¢¢V \
==
¢¢] _
$str
¢¢` i
)
¢¢i j
;
¢¢j k
if
££ 
(
££ 
existingNext
££  
!=
££! #
null
££$ (
)
££( )
return
££* 0
;
££0 1
var
¶¶ 
subscription
¶¶  
=
¶¶! "
await
¶¶# (
_context
¶¶) 1
.
¶¶1 2
Subscriptions
¶¶2 ?
.
ßß 
Include
ßß 
(
ßß 
s
ßß 
=>
ßß !
s
ßß" #
.
ßß# $
Plan
ßß$ (
)
ßß( )
.
®® !
FirstOrDefaultAsync
®® (
(
®®( )
s
®®) *
=>
®®+ -
s
®®. /
.
®®/ 0
SubscriptionID
®®0 >
==
®®? A
subscriptionId
®®B P
&&
®®Q S
s
®®T U
.
®®U V
Status
®®V \
==
®®] _
$str
®®` h
)
®®h i
;
®®i j
if
©© 
(
©© 
subscription
©©  
==
©©! #
null
©©$ (
)
©©( )
return
©©* 0
;
©©0 1
var
´´ 
amount
´´ 
=
´´ 
subscription
´´ )
.
´´) *
Plan
´´* .
?
´´. /
.
´´/ 0
Price
´´0 5
??
´´6 8
payment
´´9 @
.
´´@ A

AmountPaid
´´A K
;
´´K L
var
¨¨ 
currentDueDate
¨¨ "
=
¨¨# $
payment
¨¨% ,
.
¨¨, -
Invoice
¨¨- 4
.
¨¨4 5
DueDate
¨¨5 <
??
¨¨= ?
DateTime
¨¨@ H
.
¨¨H I
UtcNow
¨¨I O
;
¨¨O P
var
≠≠ 
nextDueDate
≠≠ 
=
≠≠  !
currentDueDate
≠≠" 0
.
≠≠0 1
	AddMonths
≠≠1 :
(
≠≠: ;
$num
≠≠; <
)
≠≠< =
;
≠≠= >
var
ØØ 
nextInvoice
ØØ 
=
ØØ  !
new
ØØ" %
Invoice
ØØ& -
{
∞∞ 
SubscriptionID
±± "
=
±±# $
subscriptionId
±±% 3
,
±±3 4
UserID
≤≤ 
=
≤≤ 
payment
≤≤ $
.
≤≤$ %
UserID
≤≤% +
,
≤≤+ ,
Amount
≥≥ 
=
≥≥ 
amount
≥≥ #
,
≥≥# $
DueDate
¥¥ 
=
¥¥ 
nextDueDate
¥¥ )
,
¥¥) *
Status
µµ 
=
µµ 
$str
µµ &
}
∂∂ 
;
∂∂ 
_context
∑∑ 
.
∑∑ 
Invoices
∑∑ !
.
∑∑! "
Add
∑∑" %
(
∑∑% &
nextInvoice
∑∑& 1
)
∑∑1 2
;
∑∑2 3
await
∏∏ 
_context
∏∏ 
.
∏∏ 
SaveChangesAsync
∏∏ /
(
∏∏/ 0
)
∏∏0 1
;
∏∏1 2
Console
∫∫ 
.
∫∫ 
	WriteLine
∫∫ !
(
∫∫! "
$"
∫∫" $
$str
∫∫$ L
{
∫∫L M
subscriptionId
∫∫M [
}
∫∫[ \
$str
∫∫\ c
{
∫∫c d
nextDueDate
∫∫d o
:
∫∫o p
$str
∫∫p q
}
∫∫q r
"
∫∫r s
)
∫∫s t
;
∫∫t u
}
ªª 
catch
ºº 
(
ºº 
	Exception
ºº 
ex
ºº 
)
ºº  
{
ΩΩ 
Console
ææ 
.
ææ 
	WriteLine
ææ !
(
ææ! "
$"
ææ" $
$str
ææ$ E
{
ææE F
ex
ææF H
.
ææH I
Message
ææI P
}
ææP Q
"
ææQ R
)
ææR S
;
ææS T
}
øø 
}
¿¿ 	
private
¬¬ 
async
¬¬ 
Task
¬¬ #
SendReceiptEmailAsync
¬¬ 0
(
¬¬0 1
Payment
¬¬1 8
payment
¬¬9 @
)
¬¬@ A
{
√√ 	
try
ƒƒ 
{
≈≈ 
var
«« 
phOffset
«« 
=
«« 
TimeSpan
«« '
.
««' (
	FromHours
««( 1
(
««1 2
$num
««2 3
)
««3 4
;
««4 5
var
»» 
phPaymentDate
»» !
=
»»" #
payment
»»$ +
.
»»+ ,
PaymentDate
»», 7
.
»»7 8
ToUniversalTime
»»8 G
(
»»G H
)
»»H I
.
»»I J
Add
»»J M
(
»»M N
phOffset
»»N V
)
»»V W
;
»»W X
var
…… 
	emailBody
…… 
=
…… 
$@"
……  #
$str
…Á# 
{
ÁÁ 
payment
ÁÁ 
.
ÁÁ 
User
ÁÁ !
.
ÁÁ! "
	FirstName
ÁÁ" +
}
ÁÁ+ ,
$str
ÁÁ, -
{
ÁÁ- .
payment
ÁÁ. 5
.
ÁÁ5 6
User
ÁÁ6 :
.
ÁÁ: ;
LastName
ÁÁ; C
}
ÁÁC D
$str
ÁÓD )
{
ÓÓ) *
payment
ÓÓ* 1
.
ÓÓ1 2
	PaymentID
ÓÓ2 ;
.
ÓÓ; <
ToString
ÓÓ< D
(
ÓÓD E
)
ÓÓE F
.
ÓÓF G
PadLeft
ÓÓG N
(
ÓÓN O
$num
ÓÓO P
,
ÓÓP Q
$char
ÓÓR U
)
ÓÓU V
}
ÓÓV W
$str
ÓÚW )
{
ÚÚ) *
payment
ÚÚ* 1
.
ÚÚ1 2
	InvoiceID
ÚÚ2 ;
}
ÚÚ; <
$str
Úˆ< (
{
ˆˆ( )
phPaymentDate
ˆˆ) 6
:
ˆˆ6 7
$str
ˆˆ7 D
}
ˆˆD E
$str
ˆ˙E (
{
˙˙( )
payment
˙˙) 0
.
˙˙0 1
PaymentMethod
˙˙1 >
}
˙˙> ?
$str
˙˛? (
{
˛˛( )
payment
˛˛) 0
.
˛˛0 1
ReferenceNum
˛˛1 =
}
˛˛= >
$str
˛Ç> )
{
ÇÇ) *
payment
ÇÇ* 1
.
ÇÇ1 2

AmountPaid
ÇÇ2 <
:
ÇÇ< =
$str
ÇÇ= ?
}
ÇÇ? @
$str
Çñ@ 
"
ññ 
;
ññ 	
await
òò 
_emailService
òò #
.
òò# $
SendEmailAsync
òò$ 2
(
òò2 3
payment
ôô 
.
ôô 
User
ôô  
.
ôô  !
Email
ôô! &
!
ôô& '
,
ôô' (
$str
öö 6
,
öö6 7
	emailBody
õõ 
)
úú 
;
úú 
}
ùù 
catch
ûû 
(
ûû 
	Exception
ûû 
ex
ûû 
)
ûû  
{
üü 
Console
†† 
.
†† 
	WriteLine
†† !
(
††! "
$"
††" $
$str
††$ B
{
††B C
ex
††C E
.
††E F
Message
††F M
}
††M N
"
††N O
)
††O P
;
††P Q
}
°° 
}
¢¢ 	
private
§§ 
async
§§ 
Task
§§ %
CreateNotificationAsync
§§ 2
(
§§2 3
Payment
§§3 :
payment
§§; B
)
§§B C
{
•• 	
var
¶¶ 
notification
¶¶ 
=
¶¶ 
new
¶¶ "
Notification
¶¶# /
{
ßß 
UserID
®® 
=
®® 
payment
®®  
.
®®  !
UserID
®®! '
,
®®' (
Message
©© 
=
©© 
payment
©© !
.
©©! "
	InvoiceID
©©" +
.
©©+ ,
HasValue
©©, 4
?
™™ 
$"
™™ 
$str
™™ 5
{
™™5 6
payment
™™6 =
.
™™= >
	InvoiceID
™™> G
}
™™G H
$str
™™H f
{
™™f g
payment
™™g n
.
™™n o
User
™™o s
.
™™s t
Email
™™t y
}
™™y z
$str
™™z {
"
™™{ |
:
´´ 
$"
´´ 
$str
´´ E
{
´´E F
payment
´´F M
.
´´M N
User
´´N R
.
´´R S
Email
´´S X
}
´´X Y
$str
´´Y Z
"
´´Z [
,
´´[ \
Type
¨¨ 
=
¨¨ 
$str
¨¨ *
,
¨¨* +
Status
≠≠ 
=
≠≠ 
$str
≠≠ !
}
ÆÆ 
;
ÆÆ 
_context
ØØ 
.
ØØ 
Notifications
ØØ "
.
ØØ" #
Add
ØØ# &
(
ØØ& '
notification
ØØ' 3
)
ØØ3 4
;
ØØ4 5
await
∞∞ 
_context
∞∞ 
.
∞∞ 
SaveChangesAsync
∞∞ +
(
∞∞+ ,
)
∞∞, -
;
∞∞- .
}
±± 	
}
≤≤ 
}≥≥ Ω&
^E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\FAQManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class  
FAQManagementService %
{ 
private		 
readonly		  
ApplicationDbContext		 -
_context		. 6
;		6 7
public  
FAQManagementService #
(# $ 
ApplicationDbContext$ 8
context9 @
)@ A
{ 	
_context 
= 
context 
; 
} 	
public 
async 
Task 
< 
List 
< 
FAQ "
>" #
># $
GetAllFAQsAsync% 4
(4 5
)5 6
{ 	
return 
await 
_context !
.! "
FAQs" &
.& '
OrderByDescending' 8
(8 9
f9 :
=>; =
f> ?
.? @
	CreatedAt@ I
)I J
.J K
ToListAsyncK V
(V W
)W X
;X Y
} 	
public 
async 
Task 
< 
bool 
> 
CreateFAQAsync  .
(. /
string/ 5
question6 >
,> ?
string@ F
answerG M
,M N
stringO U
categoryV ^
,^ _
string` f
statusg m
)m n
{ 	
var 
faq 
= 
new 
FAQ 
{ 
Question 
= 
question #
,# $
Answer 
= 
answer 
,  
Category 
= 
category #
,# $
Status 
= 
status 
} 
; 
_context 
. 
FAQs 
. 
Add 
( 
faq !
)! "
;" #
await 
_context 
. 
SaveChangesAsync +
(+ ,
), -
;- .
return   
true   
;   
}!! 	
public## 
async## 
Task## 
<## 
bool## 
>## 
UpdateFAQAsync##  .
(##. /
int##/ 2
id##3 5
,##5 6
string##7 =
question##> F
,##F G
string##H N
answer##O U
,##U V
string##W ]
category##^ f
,##f g
string##h n
status##o u
)##u v
{$$ 	
var%% 
faq%% 
=%% 
await%% 
_context%% $
.%%$ %
FAQs%%% )
.%%) *
	FindAsync%%* 3
(%%3 4
id%%4 6
)%%6 7
;%%7 8
if&& 
(&& 
faq&& 
==&& 
null&& 
)&& 
return&& #
false&&$ )
;&&) *
faq(( 
.(( 
Question(( 
=(( 
question(( #
;((# $
faq)) 
.)) 
Answer)) 
=)) 
answer)) 
;))  
faq** 
.** 
Category** 
=** 
category** #
;**# $
faq++ 
.++ 
Status++ 
=++ 
status++ 
;++  
faq,, 
.,, 
	UpdatedAt,, 
=,, 
DateTime,, $
.,,$ %
UtcNow,,% +
;,,+ ,
await-- 
_context-- 
.-- 
SaveChangesAsync-- +
(--+ ,
)--, -
;--- .
return.. 
true.. 
;.. 
}// 	
public11 
async11 
Task11 
<11 
bool11 
>11 
DeleteFAQAsync11  .
(11. /
int11/ 2
id113 5
)115 6
{22 	
var33 
faq33 
=33 
await33 
_context33 $
.33$ %
FAQs33% )
.33) *
	FindAsync33* 3
(333 4
id334 6
)336 7
;337 8
if44 
(44 
faq44 
==44 
null44 
)44 
return44 #
false44$ )
;44) *
_context66 
.66 
FAQs66 
.66 
Remove66  
(66  !
faq66! $
)66$ %
;66% &
await77 
_context77 
.77 
SaveChangesAsync77 +
(77+ ,
)77, -
;77- .
return88 
true88 
;88 
}99 	
}:: 
};; ∆Ÿ
ZE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\DashboardService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class 
DashboardService !
{		 
private

 
readonly

  
ApplicationDbContext

 -
_context

. 6
;

6 7
private 
readonly 
UserManager $
<$ %
ApplicationUser% 4
>4 5
_userManager6 B
;B C
public 
DashboardService 
(   
ApplicationDbContext  4
context5 <
,< =
UserManager> I
<I J
ApplicationUserJ Y
>Y Z
userManager[ f
)f g
{ 	
_context 
= 
context 
; 
_userManager 
= 
userManager &
;& '
} 	
public 
async 
Task 
< 
object  
>  !"
GetDashboardStatsAsync" 8
(8 9
)9 :
{ 	
var 
totalCustomers 
=  
await! &
_userManager' 3
.3 4
Users4 9
. 
Where 
( 
u 
=> 
u 
. 
Role "
==# %
null& *
||+ -
(. /
u/ 0
.0 1
Role1 5
!=6 8
$str9 E
&&F H
uI J
.J K
RoleK O
!=P R
$strS Z
&&[ ]
u^ _
._ `
Role` d
!=e g
$strh o
)o p
)p q
. 

CountAsync 
( 
) 
; 
var 
activeSubscriptions #
=$ %
await& +
_context, 4
.4 5
Subscriptions5 B
.B C

CountAsyncC M
(M N
sN O
=>P R
sS T
.T U
StatusU [
==\ ^
$str_ g
)g h
;h i
var 
openTickets 
= 
await #
_context$ ,
., -
SupportTickets- ;
.; <

CountAsync< F
(F G
tG H
=>I K
tL M
.M N
StatusN T
==U W
$strX ^
)^ _
;_ `
var 
totalRevenue 
= 
await $
_context% -
.- .
Payments. 6
.6 7
SumAsync7 ?
(? @
p@ A
=>B D
pE F
.F G

AmountPaidG Q
)Q R
;R S
return 
new 
{ 
totalCustomers 
, 
activeSubscriptions #
,# $
openTickets   
,   
totalRevenue!! 
}"" 
;"" 
}## 	
public%% 
async%% 
Task%% 
<%% 
object%%  
>%%  !"
GetActiveServicesAsync%%" 8
(%%8 9
)%%9 :
{&& 	
var'' 
subscriptions'' 
='' 
await''  %
_context''& .
.''. /
Subscriptions''/ <
.(( 
Include(( 
((( 
s(( 
=>(( 
s(( 
.((  
User((  $
)(($ %
.)) 
Include)) 
()) 
s)) 
=>)) 
s)) 
.))  
Plan))  $
)))$ %
.** 
Select** 
(** 
s** 
=>** 
new**  
{++ 
s,, 
.,, 
SubscriptionID,, $
,,,$ %
Customer-- 
=-- 
s--  
.--  !
User--! %
.--% &
	FirstName--& /
+--0 1
$str--2 5
+--6 7
s--8 9
.--9 :
User--: >
.--> ?
LastName--? G
,--G H
Service.. 
=.. 
s.. 
...  
Plan..  $
...$ %
PlanName..% -
,..- .
s// 
.// 
Status// 
,// 
InstallDate00 
=00  !
s00" #
.00# $
	StartDate00$ -
,00- .
s11 
.11 
UserID11 
,11 
Type22 
=22 
$str22 )
}33 
)33 
.44 
ToListAsync44 
(44 
)44 
;44 
var66 
prepaidWiFi66 
=66 
await66 #
_context66$ ,
.66, -
PrepaidLoads66- 9
.77 
Include77 
(77 
p77 
=>77 
p77 
.77  
ServiceAccount77  .
)77. /
.88 
ThenInclude88  
(88  !
sa88! #
=>88$ &
sa88' )
.88) *
Device88* 0
)880 1
.99 
ThenInclude99 $
(99$ %
d99% &
=>99' )
d99* +
.99+ ,
User99, 0
)990 1
.:: 
Select:: 
(:: 
p:: 
=>:: 
new::  
{;; 
SubscriptionID<< "
=<<# $
p<<% &
.<<& '
PrepaidLoadID<<' 4
,<<4 5
Customer== 
=== 
p==  
.==  !
ServiceAccount==! /
.==/ 0
Device==0 6
.==6 7
User==7 ;
.==; <
	FirstName==< E
+==F G
$str==H K
+==L M
p==N O
.==O P
ServiceAccount==P ^
.==^ _
Device==_ e
.==e f
User==f j
.==j k
LastName==k s
,==s t
Service>> 
=>> 
$str>> ,
,>>, -
Status?? 
=?? 
p?? 
.?? 
ServiceAccount?? -
.??- .
Status??. 4
????5 7
$str??8 @
,??@ A
InstallDate@@ 
=@@  !
(@@" #
DateTime@@# +
?@@+ ,
)@@, -
p@@- .
.@@. /
ServiceAccount@@/ =
.@@= >
ActivatedAt@@> I
,@@I J
UserIDAA 
=AA 
pAA 
.AA 
ServiceAccountAA -
.AA- .
DeviceAA. 4
.AA4 5
UserIDAA5 ;
,AA; <
TypeBB 
=BB 
$strBB (
,BB( )
pCC 
.CC 
PhoneNumberCC !
,CC! "
pDD 
.DD 

LoadAmountDD  
,DD  !
pEE 
.EE 
RemainingBalanceEE &
,EE& '
pFF 
.FF 
LastReloadBalanceFF '
,FF' (

MACAddressGG 
=GG  
pGG! "
.GG" #
ServiceAccountGG# 1
.GG1 2
DeviceGG2 8
.GG8 9

MACAddressGG9 C
}HH 
)HH 
.II 
ToListAsyncII 
(II 
)II 
;II 
returnKK 
subscriptionsKK  
.KK  !
CastKK! %
<KK% &
objectKK& ,
>KK, -
(KK- .
)KK. /
.KK/ 0
ConcatKK0 6
(KK6 7
prepaidWiFiKK7 B
.KKB C
CastKKC G
<KKG H
objectKKH N
>KKN O
(KKO P
)KKP Q
)KKQ R
.KKR S
ToListKKS Y
(KKY Z
)KKZ [
;KK[ \
}LL 	
publicNN 
asyncNN 
TaskNN 
<NN 
objectNN  
>NN  !
GetAllInvoicesAsyncNN" 5
(NN5 6
)NN6 7
{OO 	
returnPP 
awaitPP 
_contextPP !
.PP! "
InvoicesPP" *
.QQ 
IncludeQQ 
(QQ 
iQQ 
=>QQ 
iQQ 
.QQ  
UserQQ  $
)QQ$ %
.RR 
IncludeRR 
(RR 
iRR 
=>RR 
iRR 
.RR  
SubscriptionRR  ,
)RR, -
.SS 
SelectSS 
(SS 
iSS 
=>SS 
newSS  
{TT 
iUU 
.UU 
	InvoiceIDUU 
,UU  
iVV 
.VV 
SubscriptionIDVV $
,VV$ %
UserWW 
=WW 
iWW 
.WW 
UserWW !
!=WW" $
nullWW% )
?WW* +
newWW, /
{WW0 1
iWW2 3
.WW3 4
UserWW4 8
.WW8 9
	FirstNameWW9 B
,WWB C
iWWD E
.WWE F
UserWWF J
.WWJ K
LastNameWWK S
,WWS T
iWWU V
.WWV W
UserWWW [
.WW[ \
EmailWW\ a
}WWb c
:WWd e
nullWWf j
,WWj k
iXX 
.XX 
AmountXX 
,XX 
iYY 
.YY 
DueDateYY 
,YY 
iZZ 
.ZZ 
StatusZZ 
,ZZ 
i[[ 
.[[ 
	CreatedAt[[ 
}\\ 
)\\ 
.]] 
OrderByDescending]] "
(]]" #
i]]# $
=>]]% '
i]]( )
.]]) *
	CreatedAt]]* 3
)]]3 4
.^^ 
ToListAsync^^ 
(^^ 
)^^ 
;^^ 
}__ 	
publicaa 
asyncaa 
Taskaa 
<aa 
objectaa  
>aa  !'
GetPaymentMethodsStatsAsyncaa" =
(aa= >
)aa> ?
{bb 	
returncc 
awaitcc 
_contextcc !
.cc! "
Paymentscc" *
.dd 
Wheredd 
(dd 
pdd 
=>dd 
pdd 
.dd 
Statusdd $
==dd% '
$strdd( 3
)dd3 4
.ee 
GroupByee 
(ee 
pee 
=>ee 
pee 
.ee  
PaymentMethodee  -
)ee- .
.ff 
Selectff 
(ff 
gff 
=>ff 
newff  
{gg 
Namehh 
=hh 
ghh 
.hh 
Keyhh  
,hh  !
Transactionsii  
=ii! "
gii# $
.ii$ %
Countii% *
(ii* +
)ii+ ,
,ii, -
Revenuejj 
=jj 
gjj 
.jj  
Sumjj  #
(jj# $
pjj$ %
=>jj& (
pjj) *
.jj* +

AmountPaidjj+ 5
)jj5 6
}kk 
)kk 
.ll 
ToListAsyncll 
(ll 
)ll 
;ll 
}mm 	
publicoo 
asyncoo 
Taskoo 
<oo 
objectoo  
>oo  ! 
GetActivityLogsAsyncoo" 6
(oo6 7
DateTimeoo7 ?
?oo? @
sinceooA F
=ooG H
nullooI M
)ooM N
{pp 	
varqq 

roleByUserqq 
=qq 
awaitqq "
_contextqq# +
.qq+ ,
	UserRolesqq, 5
.rr 
Joinrr 
(rr 
_contextss 
.ss 
Rolesss "
,ss" #
urtt 
=>tt 
urtt 
.tt 
RoleIdtt #
,tt# $
ruu 
=>uu 
ruu 
.uu 
Iduu 
,uu 
(vv 
urvv 
,vv 
rvv 
)vv 
=>vv 
newvv "
{vv# $
urvv% '
.vv' (
UserIdvv( .
,vv. /
RoleNamevv0 8
=vv9 :
rvv; <
.vv< =
Namevv= A
??vvB D
stringvvE K
.vvK L
EmptyvvL Q
}vvR S
)vvS T
.ww 
GroupByww 
(ww 
xww 
=>ww 
xww 
.ww  
UserIdww  &
)ww& '
.xx 
Selectxx 
(xx 
gxx 
=>xx 
newxx  
{yy 
UserIdzz 
=zz 
gzz 
.zz 
Keyzz "
,zz" #
Role{{ 
={{ 
g{{ 
.|| 
OrderBy||  
(||  !
x||! "
=>||# %
(||& '
x||' (
.||( )
RoleName||) 1
??||2 4
string||5 ;
.||; <
Empty||< A
)||A B
.||B C
ToLower||C J
(||J K
)||K L
==||M O
$str||P \
?||] ^
$num||_ `
:||a b
(||c d
x||d e
.||e f
RoleName||f n
??||o q
string||r x
.||x y
Empty||y ~
)||~ 
.	|| Ä
ToLower
||Ä á
(
||á à
)
||à â
==
||ä å
$str
||ç î
?
||ï ñ
$num
||ó ò
:
||ô ö
(
||õ ú
x
||ú ù
.
||ù û
RoleName
||û ¶
??
||ß ©
string
||™ ∞
.
||∞ ±
Empty
||± ∂
)
||∂ ∑
.
||∑ ∏
ToLower
||∏ ø
(
||ø ¿
)
||¿ ¡
==
||¬ ƒ
$str
||≈ Ã
?
||Õ Œ
$num
||œ –
:
||— “
$num
||” ‘
)
||‘ ’
.}} 
Select}} 
(}}  
x}}  !
=>}}" $
x}}% &
.}}& '
RoleName}}' /
)}}/ 0
.~~ 
FirstOrDefault~~ '
(~~' (
)~~( )
} 
) 
.
ÄÄ 
ToDictionaryAsync
ÄÄ "
(
ÄÄ" #
x
ÄÄ# $
=>
ÄÄ% '
x
ÄÄ( )
.
ÄÄ) *
UserId
ÄÄ* 0
,
ÄÄ0 1
x
ÄÄ2 3
=>
ÄÄ4 6
x
ÄÄ7 8
.
ÄÄ8 9
Role
ÄÄ9 =
??
ÄÄ> @
string
ÄÄA G
.
ÄÄG H
Empty
ÄÄH M
)
ÄÄM N
;
ÄÄN O
var
ÇÇ 
	logsQuery
ÇÇ 
=
ÇÇ 
_context
ÇÇ $
.
ÇÇ$ %
ActivityLogs
ÇÇ% 1
.
ÉÉ 
AsNoTracking
ÉÉ 
(
ÉÉ 
)
ÉÉ 
.
ÑÑ 
Include
ÑÑ 
(
ÑÑ 
l
ÑÑ 
=>
ÑÑ 
l
ÑÑ 
.
ÑÑ  
User
ÑÑ  $
)
ÑÑ$ %
.
ÖÖ 
AsQueryable
ÖÖ 
(
ÖÖ 
)
ÖÖ 
;
ÖÖ 
if
áá 
(
áá 
since
áá 
.
áá 
HasValue
áá 
)
áá 
{
àà 
var
ââ 
sinceUtc
ââ 
=
ââ 
DateTime
ââ '
.
ââ' (
SpecifyKind
ââ( 3
(
ââ3 4
since
ââ4 9
.
ââ9 :
Value
ââ: ?
,
ââ? @
DateTimeKind
ââA M
.
ââM N
Utc
ââN Q
)
ââQ R
;
ââR S
	logsQuery
ää 
=
ää 
	logsQuery
ää %
.
ää% &
Where
ää& +
(
ää+ ,
l
ää, -
=>
ää. 0
l
ää1 2
.
ää2 3
	Timestamp
ää3 <
>
ää= >
sinceUtc
ää? G
)
ääG H
;
ääH I
}
ãã 
var
çç 
logs
çç 
=
çç 
await
çç 
	logsQuery
çç &
.
éé 
OrderByDescending
éé "
(
éé" #
l
éé# $
=>
éé% '
l
éé( )
.
éé) *
	Timestamp
éé* 3
)
éé3 4
.
èè 
Take
èè 
(
èè 
$num
èè 
)
èè 
.
êê 
ToListAsync
êê 
(
êê 
)
êê 
;
êê 
var
íí 
loginHistoryQuery
íí !
=
íí" #
_context
íí$ ,
.
íí, -
LoginHistory
íí- 9
.
ìì 
AsNoTracking
ìì 
(
ìì 
)
ìì 
.
îî 
Include
îî 
(
îî 
h
îî 
=>
îî 
h
îî 
.
îî  
User
îî  $
)
îî$ %
.
ïï 
AsQueryable
ïï 
(
ïï 
)
ïï 
;
ïï 
if
óó 
(
óó 
since
óó 
.
óó 
HasValue
óó 
)
óó 
{
òò 
var
ôô 
sinceUtc
ôô 
=
ôô 
DateTime
ôô '
.
ôô' (
SpecifyKind
ôô( 3
(
ôô3 4
since
ôô4 9
.
ôô9 :
Value
ôô: ?
,
ôô? @
DateTimeKind
ôôA M
.
ôôM N
Utc
ôôN Q
)
ôôQ R
;
ôôR S
loginHistoryQuery
öö !
=
öö" #
loginHistoryQuery
öö$ 5
.
öö5 6
Where
öö6 ;
(
öö; <
h
öö< =
=>
öö> @
h
ööA B
.
ööB C
	LoginTime
ööC L
>
ööM N
sinceUtc
ööO W
)
ööW X
;
ööX Y
}
õõ 
var
ùù 
loginHistory
ùù 
=
ùù 
await
ùù $
loginHistoryQuery
ùù% 6
.
ûû 
OrderByDescending
ûû "
(
ûû" #
h
ûû# $
=>
ûû% '
h
ûû( )
.
ûû) *
	LoginTime
ûû* 3
)
ûû3 4
.
üü 
Take
üü 
(
üü 
$num
üü 
)
üü 
.
†† 
ToListAsync
†† 
(
†† 
)
†† 
;
†† 
var
¢¢ 
activityEntries
¢¢ 
=
¢¢  !
logs
¢¢" &
.
¢¢& '
Select
¢¢' -
(
¢¢- .
l
¢¢. /
=>
¢¢0 2
new
¢¢3 6
ActivityLogView
¢¢7 F
{
££ 
LogID
§§ 
=
§§ 
l
§§ 
.
§§ 
LogID
§§ 
,
§§  
UserID
•• 
=
•• 
l
•• 
.
•• 
UserID
•• !
,
••! "
	UserEmail
¶¶ 
=
¶¶ 
l
¶¶ 
.
¶¶ 
User
¶¶ "
?
¶¶" #
.
¶¶# $
Email
¶¶$ )
,
¶¶) *
User
ßß 
=
ßß 
l
ßß 
.
ßß 
User
ßß 
==
ßß  
null
ßß! %
?
®® 
$str
®® 
:
©© 
!
©© 
string
©© 
.
©©  
IsNullOrWhiteSpace
©© 0
(
©©0 1
(
©©1 2
l
©©2 3
.
©©3 4
User
©©4 8
.
©©8 9
	FirstName
©©9 B
+
©©C D
$str
©©E H
+
©©I J
l
©©K L
.
©©L M
User
©©M Q
.
©©Q R
LastName
©©R Z
)
©©Z [
.
©©[ \
Trim
©©\ `
(
©©` a
)
©©a b
)
©©b c
?
™™ 
(
™™ 
l
™™ 
.
™™ 
User
™™ !
.
™™! "
	FirstName
™™" +
+
™™, -
$str
™™. 1
+
™™2 3
l
™™4 5
.
™™5 6
User
™™6 :
.
™™: ;
LastName
™™; C
)
™™C D
.
™™D E
Trim
™™E I
(
™™I J
)
™™J K
:
´´ 
(
´´ 
l
´´ 
.
´´ 
User
´´ !
.
´´! "
Email
´´" '
??
´´( *
$str
´´+ 4
)
´´4 5
,
´´5 6
UserRole
¨¨ 
=
¨¨ 

roleByUser
¨¨ %
.
¨¨% &
TryGetValue
¨¨& 1
(
¨¨1 2
l
¨¨2 3
.
¨¨3 4
UserID
¨¨4 :
,
¨¨: ;
out
¨¨< ?
var
¨¨@ C
resolvedRole
¨¨D P
)
¨¨P Q
?
≠≠ 
resolvedRole
≠≠ "
:
ÆÆ 
(
ÆÆ 
l
ÆÆ 
.
ÆÆ 
User
ÆÆ 
!=
ÆÆ  
null
ÆÆ! %
&&
ÆÆ& (
!
ÆÆ) *
string
ÆÆ* 0
.
ÆÆ0 1 
IsNullOrWhiteSpace
ÆÆ1 C
(
ÆÆC D
l
ÆÆD E
.
ÆÆE F
User
ÆÆF J
.
ÆÆJ K
Role
ÆÆK O
)
ÆÆO P
?
ÆÆQ R
l
ÆÆS T
.
ÆÆT U
User
ÆÆU Y
.
ÆÆY Z
Role
ÆÆZ ^
:
ÆÆ_ `
$str
ÆÆa k
)
ÆÆk l
,
ÆÆl m
Action
ØØ 
=
ØØ 
l
ØØ 
.
ØØ 
Action
ØØ !
,
ØØ! "
Type
∞∞ 
=
∞∞ 
l
∞∞ 
.
∞∞ 
Type
∞∞ 
,
∞∞ 
	IPAddress
±± 
=
±± 
l
±± 
.
±± 
	IPAddress
±± '
,
±±' (
	Timestamp
≤≤ 
=
≤≤ 
l
≤≤ 
.
≤≤ 
	Timestamp
≤≤ '
}
≥≥ 
)
≥≥ 
;
≥≥ 
var
µµ 
loginEntries
µµ 
=
µµ 
loginHistory
µµ +
.
µµ+ ,
Select
µµ, 2
(
µµ2 3
h
µµ3 4
=>
µµ5 7
new
µµ8 ;
ActivityLogView
µµ< K
{
∂∂ 
LogID
∑∑ 
=
∑∑ 
-
∑∑ 
h
∑∑ 
.
∑∑ 
LoginHistoryID
∑∑ )
,
∑∑) *
UserID
∏∏ 
=
∏∏ 
h
∏∏ 
.
∏∏ 
UserID
∏∏ !
,
∏∏! "
	UserEmail
ππ 
=
ππ 
h
ππ 
.
ππ 
User
ππ "
?
ππ" #
.
ππ# $
Email
ππ$ )
,
ππ) *
User
∫∫ 
=
∫∫ 
h
∫∫ 
.
∫∫ 
User
∫∫ 
==
∫∫  
null
∫∫! %
?
ªª 
$str
ªª 
:
ºº 
!
ºº 
string
ºº 
.
ºº  
IsNullOrWhiteSpace
ºº 0
(
ºº0 1
(
ºº1 2
h
ºº2 3
.
ºº3 4
User
ºº4 8
.
ºº8 9
	FirstName
ºº9 B
+
ººC D
$str
ººE H
+
ººI J
h
ººK L
.
ººL M
User
ººM Q
.
ººQ R
LastName
ººR Z
)
ººZ [
.
ºº[ \
Trim
ºº\ `
(
ºº` a
)
ººa b
)
ººb c
?
ΩΩ 
(
ΩΩ 
h
ΩΩ 
.
ΩΩ 
User
ΩΩ !
.
ΩΩ! "
	FirstName
ΩΩ" +
+
ΩΩ, -
$str
ΩΩ. 1
+
ΩΩ2 3
h
ΩΩ4 5
.
ΩΩ5 6
User
ΩΩ6 :
.
ΩΩ: ;
LastName
ΩΩ; C
)
ΩΩC D
.
ΩΩD E
Trim
ΩΩE I
(
ΩΩI J
)
ΩΩJ K
:
ææ 
(
ææ 
h
ææ 
.
ææ 
User
ææ !
.
ææ! "
Email
ææ" '
??
ææ( *
$str
ææ+ 4
)
ææ4 5
,
ææ5 6
UserRole
øø 
=
øø 

roleByUser
øø %
.
øø% &
TryGetValue
øø& 1
(
øø1 2
h
øø2 3
.
øø3 4
UserID
øø4 :
,
øø: ;
out
øø< ?
var
øø@ C
resolvedRole
øøD P
)
øøP Q
?
¿¿ 
resolvedRole
¿¿ "
:
¡¡ 
(
¡¡ 
h
¡¡ 
.
¡¡ 
User
¡¡ 
!=
¡¡  
null
¡¡! %
&&
¡¡& (
!
¡¡) *
string
¡¡* 0
.
¡¡0 1 
IsNullOrWhiteSpace
¡¡1 C
(
¡¡C D
h
¡¡D E
.
¡¡E F
User
¡¡F J
.
¡¡J K
Role
¡¡K O
)
¡¡O P
?
¡¡Q R
h
¡¡S T
.
¡¡T U
User
¡¡U Y
.
¡¡Y Z
Role
¡¡Z ^
:
¡¡_ `
$str
¡¡a k
)
¡¡k l
,
¡¡l m
Action
¬¬ 
=
¬¬ 
$str
¬¬ $
,
¬¬$ %
Type
√√ 
=
√√ 
$str
√√ 
,
√√ 
	IPAddress
ƒƒ 
=
ƒƒ 
h
ƒƒ 
.
ƒƒ 
	IPAddress
ƒƒ '
,
ƒƒ' (
	Timestamp
≈≈ 
=
≈≈ 
h
≈≈ 
.
≈≈ 
	LoginTime
≈≈ '
}
∆∆ 
)
∆∆ 
;
∆∆ 
return
»» 
activityEntries
»» "
.
…… 
Concat
…… 
(
…… 
loginEntries
…… $
)
……$ %
.
   
Where
   
(
   
x
   
=>
   
!
   
string
   #
.
  # $
Equals
  $ *
(
  * +
x
  + ,
.
  , -
UserRole
  - 5
,
  5 6
$str
  7 C
,
  C D
StringComparison
  E U
.
  U V
OrdinalIgnoreCase
  V g
)
  g h
)
  h i
.
ÀÀ 
OrderByDescending
ÀÀ "
(
ÀÀ" #
x
ÀÀ# $
=>
ÀÀ% '
x
ÀÀ( )
.
ÀÀ) *
	Timestamp
ÀÀ* 3
)
ÀÀ3 4
.
ÃÃ 
Take
ÃÃ 
(
ÃÃ 
$num
ÃÃ 
)
ÃÃ 
.
ÕÕ 
Select
ÕÕ 
(
ÕÕ 
x
ÕÕ 
=>
ÕÕ 
new
ÕÕ  
{
ŒŒ 
x
œœ 
.
œœ 
LogID
œœ 
,
œœ 
x
–– 
.
–– 
UserID
–– 
,
–– 
x
—— 
.
—— 
	UserEmail
—— 
,
——  
x
““ 
.
““ 
User
““ 
,
““ 
x
”” 
.
”” 
UserRole
”” 
,
”” 
x
‘‘ 
.
‘‘ 
Action
‘‘ 
,
‘‘ 
x
’’ 
.
’’ 
Type
’’ 
,
’’ 
x
÷÷ 
.
÷÷ 
	IPAddress
÷÷ 
,
÷÷  
x
◊◊ 
.
◊◊ 
	Timestamp
◊◊ 
}
ÿÿ 
)
ÿÿ 
.
ŸŸ 
ToList
ŸŸ 
(
ŸŸ 
)
ŸŸ 
;
ŸŸ 
}
⁄⁄ 	
private
‹‹ 
sealed
‹‹ 
class
‹‹ 
ActivityLogView
‹‹ ,
{
›› 	
public
ﬁﬁ 
int
ﬁﬁ 
LogID
ﬁﬁ 
{
ﬁﬁ 
get
ﬁﬁ "
;
ﬁﬁ" #
set
ﬁﬁ$ '
;
ﬁﬁ' (
}
ﬁﬁ) *
public
ﬂﬂ 
string
ﬂﬂ 
UserID
ﬂﬂ  
{
ﬂﬂ! "
get
ﬂﬂ# &
;
ﬂﬂ& '
set
ﬂﬂ( +
;
ﬂﬂ+ ,
}
ﬂﬂ- .
=
ﬂﬂ/ 0
string
ﬂﬂ1 7
.
ﬂﬂ7 8
Empty
ﬂﬂ8 =
;
ﬂﬂ= >
public
‡‡ 
string
‡‡ 
?
‡‡ 
	UserEmail
‡‡ $
{
‡‡% &
get
‡‡' *
;
‡‡* +
set
‡‡, /
;
‡‡/ 0
}
‡‡1 2
public
·· 
string
·· 
User
·· 
{
··  
get
··! $
;
··$ %
set
··& )
;
··) *
}
··+ ,
=
··- .
$str
··/ 8
;
··8 9
public
‚‚ 
string
‚‚ 
UserRole
‚‚ "
{
‚‚# $
get
‚‚% (
;
‚‚( )
set
‚‚* -
;
‚‚- .
}
‚‚/ 0
=
‚‚1 2
$str
‚‚3 =
;
‚‚= >
public
„„ 
string
„„ 
Action
„„  
{
„„! "
get
„„# &
;
„„& '
set
„„( +
;
„„+ ,
}
„„- .
=
„„/ 0
string
„„1 7
.
„„7 8
Empty
„„8 =
;
„„= >
public
‰‰ 
string
‰‰ 
Type
‰‰ 
{
‰‰  
get
‰‰! $
;
‰‰$ %
set
‰‰& )
;
‰‰) *
}
‰‰+ ,
=
‰‰- .
$str
‰‰/ 5
;
‰‰5 6
public
ÂÂ 
string
ÂÂ 
?
ÂÂ 
	IPAddress
ÂÂ $
{
ÂÂ% &
get
ÂÂ' *
;
ÂÂ* +
set
ÂÂ, /
;
ÂÂ/ 0
}
ÂÂ1 2
public
ÊÊ 
DateTime
ÊÊ 
	Timestamp
ÊÊ %
{
ÊÊ& '
get
ÊÊ( +
;
ÊÊ+ ,
set
ÊÊ- 0
;
ÊÊ0 1
}
ÊÊ2 3
}
ÁÁ 	
}
ËË 
}ÈÈ ˆl
cE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\Admin\CustomerManagementService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
.) *
Admin* /
{ 
public 

class %
CustomerManagementService *
{		 
private

 
readonly

  
ApplicationDbContext

 -
_context

. 6
;

6 7
private 
readonly 
UserManager $
<$ %
ApplicationUser% 4
>4 5
_userManager6 B
;B C
private 
readonly 
EmailService %
_emailService& 3
;3 4
public %
CustomerManagementService (
(( ) 
ApplicationDbContext) =
context> E
,E F
UserManagerG R
<R S
ApplicationUserS b
>b c
userManagerd o
,o p
EmailServiceq }
emailService	~ ä
)
ä ã
{ 	
_context 
= 
context 
; 
_userManager 
= 
userManager &
;& '
_emailService 
= 
emailService (
;( )
} 	
public 
async 
Task 
< 
List 
< 
object %
>% &
>& ' 
GetAllCustomersAsync( <
(< =
)= >
{ 	
var 
users 
= 
await 
_userManager *
.* +
Users+ 0
.0 1
ToListAsync1 <
(< =
)= >
;> ?
var 
	customers 
= 
users !
.! "
Where" '
(' (
u( )
=>* ,
u- .
.. /
Role/ 3
!=4 6
$str7 >
&&? A
uB C
.C D
RoleD H
!=I K
$strL X
&&Y [
u\ ]
.] ^
Role^ b
!=c e
$strf m
)m n
.n o
ToListo u
(u v
)v w
;w x
var  
customersWithDetails $
=% &
new' *
List+ /
</ 0
object0 6
>6 7
(7 8
)8 9
;9 :
foreach 
( 
var 
user 
in  
	customers! *
)* +
{ 
var 
subscriptions !
=" #
await$ )
_context* 2
.2 3
Subscriptions3 @
. 
Include 
( 
s 
=> !
s" #
.# $
Plan$ (
)( )
.   
Where   
(   
s   
=>   
s    !
.  ! "
UserID  " (
==  ) +
user  , 0
.  0 1
Id  1 3
)  3 4
.!! 
Select!! 
(!! 
s!! 
=>!!  
new!!! $
{"" 
s## 
.## 
SubscriptionID## (
,##( )
PlanName$$  
=$$! "
s$$# $
.$$$ %
Plan$$% )
.$$) *
PlanName$$* 2
,$$2 3
s%% 
.%% 
Plan%% 
.%% 
	SpeedMbps%% (
,%%( )

MonthlyFee&& "
=&&# $
s&&% &
.&&& '
Plan&&' +
.&&+ ,
Price&&, 1
,&&1 2
s'' 
.'' 
Status''  
,''  !
s(( 
.(( 
	StartDate(( #
})) 
))) 
.** 
ToListAsync**  
(**  !
)**! "
;**" #
var,, 
totalBalance,,  
=,,! "
await,,# (
_context,,) 1
.,,1 2
Invoices,,2 :
.-- 
Where-- 
(-- 
i-- 
=>-- 
i--  !
.--! "
UserID--" (
==--) +
user--, 0
.--0 1
Id--1 3
&&--4 6
i--7 8
.--8 9
Status--9 ?
==--@ B
$str--C L
)--L M
... 
SumAsync.. 
(.. 
i.. 
=>..  "
i..# $
...$ %
Amount..% +
)..+ ,
;.., - 
customersWithDetails00 $
.00$ %
Add00% (
(00( )
new00) ,
{11 
user22 
.22 
Id22 
,22 
user33 
.33 
	FirstName33 "
,33" #
user44 
.44 
LastName44 !
,44! "
user55 
.55 
Email55 
,55 
Address66 
=66 
user66 "
.66" #
Address66# *
??66+ -
string66. 4
.664 5
Empty665 :
,66: ;
ProfilePictureUrl77 %
=77& '
user77( ,
.77, -
ProfilePictureUrl77- >
??77? A
string77B H
.77H I
Empty77I N
,77N O
user88 
.88 
Status88 
,88  
user99 
.99 
	CreatedAt99 "
,99" #
Subscriptions:: !
=::" #
subscriptions::$ 1
,::1 2
TotalBalance;;  
=;;! "
totalBalance;;# /
}<< 
)<< 
;<< 
}== 
return??  
customersWithDetails?? '
;??' (
}@@ 	
publicBB 
asyncBB 
TaskBB 
<BB 
objectBB  
?BB  !
>BB! " 
GetCustomerByIdAsyncBB# 7
(BB7 8
stringBB8 >
idBB? A
)BBA B
{CC 	
varDD 
userDD 
=DD 
awaitDD 
_userManagerDD )
.DD) *
FindByIdAsyncDD* 7
(DD7 8
idDD8 :
)DD: ;
;DD; <
ifEE 
(EE 
userEE 
==EE 
nullEE 
)EE 
returnEE $
nullEE% )
;EE) *
varGG 
subscriptionsGG 
=GG 
awaitGG  %
_contextGG& .
.GG. /
SubscriptionsGG/ <
.HH 
IncludeHH 
(HH 
sHH 
=>HH 
sHH 
.HH  
PlanHH  $
)HH$ %
.II 
WhereII 
(II 
sII 
=>II 
sII 
.II 
UserIDII $
==II% '
idII( *
)II* +
.JJ 
SelectJJ 
(JJ 
sJJ 
=>JJ 
newJJ  
{KK 
sLL 
.LL 
SubscriptionIDLL $
,LL$ %
PlanNameMM 
=MM 
sMM  
.MM  !
PlanMM! %
.MM% &
PlanNameMM& .
,MM. /
sNN 
.NN 
PlanNN 
.NN 
	SpeedMbpsNN $
,NN$ %

MonthlyFeeOO 
=OO  
sOO! "
.OO" #
PlanOO# '
.OO' (
PriceOO( -
,OO- .
sPP 
.PP 
StatusPP 
,PP 
sQQ 
.QQ 
	StartDateQQ 
}RR 
)RR 
.SS 
ToListAsyncSS 
(SS 
)SS 
;SS 
varUU 
totalBalanceUU 
=UU 
awaitUU $
_contextUU% -
.UU- .
InvoicesUU. 6
.VV 
WhereVV 
(VV 
iVV 
=>VV 
iVV 
.VV 
UserIDVV $
==VV% '
idVV( *
&&VV+ -
iVV. /
.VV/ 0
StatusVV0 6
==VV7 9
$strVV: C
)VVC D
.WW 
SumAsyncWW 
(WW 
iWW 
=>WW 
iWW  
.WW  !
AmountWW! '
)WW' (
;WW( )
returnYY 
newYY 
{ZZ 
user[[ 
.[[ 
Id[[ 
,[[ 
user\\ 
.\\ 
	FirstName\\ 
,\\ 
user]] 
.]] 
LastName]] 
,]] 
user^^ 
.^^ 
Email^^ 
,^^ 
Address__ 
=__ 
user__ 
.__ 
Address__ &
??__' )
string__* 0
.__0 1
Empty__1 6
,__6 7
ProfilePictureUrl`` !
=``" #
user``$ (
.``( )
ProfilePictureUrl``) :
??``; =
string``> D
.``D E
Empty``E J
,``J K
useraa 
.aa 
	CreatedAtaa 
,aa 
userbb 
.bb 
Statusbb 
,bb 
Subscriptionscc 
=cc 
subscriptionscc  -
,cc- .
TotalBalancedd 
=dd 
totalBalancedd +
}ee 
;ee 
}ff 	
publichh 
asynchh 
Taskhh 
<hh 
boolhh 
>hh 
UpdateCustomerAsynchh  3
(hh3 4
stringhh4 :
idhh; =
,hh= >
stringhh? E
	firstNamehhF O
,hhO P
stringhhQ W
lastNamehhX `
,hh` a
stringhhb h
emailhhi n
,hhn o
stringhhp v
statushhw }
)hh} ~
{ii 	
varjj 
userjj 
=jj 
awaitjj 
_userManagerjj )
.jj) *
FindByIdAsyncjj* 7
(jj7 8
idjj8 :
)jj: ;
;jj; <
ifkk 
(kk 
userkk 
==kk 
nullkk 
)kk 
returnkk $
falsekk% *
;kk* +
varmm 
	oldStatusmm 
=mm 
usermm  
.mm  !
Statusmm! '
;mm' (
usernn 
.nn 
	FirstNamenn 
=nn 
	firstNamenn &
;nn& '
useroo 
.oo 
LastNameoo 
=oo 
lastNameoo $
;oo$ %
userpp 
.pp 
Emailpp 
=pp 
emailpp 
;pp 
userqq 
.qq 
UserNameqq 
=qq 
emailqq !
;qq! "
userrr 
.rr 
NormalizedEmailrr  
=rr! "
emailrr# (
.rr( )
ToUpperrr) 0
(rr0 1
)rr1 2
;rr2 3
userss 
.ss 
NormalizedUserNamess #
=ss$ %
emailss& +
.ss+ ,
ToUpperss, 3
(ss3 4
)ss4 5
;ss5 6
usertt 
.tt 
Statustt 
=tt 
statustt  
;tt  !
awaituu 
_userManageruu 
.uu 
UpdateAsyncuu *
(uu* +
useruu+ /
)uu/ 0
;uu0 1
ifxx 
(xx 
	oldStatusxx 
!=xx 
statusxx #
)xx# $
{yy 
varzz 
statusMessagezz !
=zz" #
statuszz$ *
switchzz+ 1
{{{ 
$str|| 
=>|| 
$str||  c
,||c d
$str}} 
=>}} 
$str	}}  û
,
}}û ü
$str~~ 
=>~~ !
$str~~" q
,~~q r
_ 
=> 
$" 
$str C
{C D
statusD J
}J K
$strK L
"L M
}
ÄÄ 
;
ÄÄ 
var
ÇÇ 
	emailBody
ÇÇ 
=
ÇÇ 
$@"
ÇÇ  #
$str
ÇÑ# 
{
ÑÑ 
user
ÑÑ "
.
ÑÑ" #
	FirstName
ÑÑ# ,
}
ÑÑ, -
$str
ÑÑ- .
{
ÑÑ. /
user
ÑÑ/ 3
.
ÑÑ3 4
LastName
ÑÑ4 <
}
ÑÑ< =
$str
ÑÖ= 
{
ÖÖ 
statusMessage
ÖÖ %
}
ÖÖ% &
$str
Öâ& 
"
ââ 
;
ââ 
try
ãã 
{
åå 
await
çç 
_emailService
çç '
.
çç' (
SendEmailAsync
çç( 6
(
çç6 7
user
çç7 ;
.
çç; <
Email
çç< A
!
ççA B
,
ççB C
$str
ççD l
,
ççl m
	emailBody
ççn w
)
ççw x
;
ççx y
}
éé 
catch
èè 
(
èè 
	Exception
èè  
ex
èè! #
)
èè# $
{
êê 
Console
ëë 
.
ëë 
	WriteLine
ëë %
(
ëë% &
$"
ëë& (
$str
ëë( L
{
ëëL M
ex
ëëM O
.
ëëO P
Message
ëëP W
}
ëëW X
"
ëëX Y
)
ëëY Z
;
ëëZ [
}
íí 
}
ìì 
return
ïï 
true
ïï 
;
ïï 
}
ññ 	
public
òò 
async
òò 
Task
òò 
<
òò 
bool
òò 
>
òò !
DeleteCustomerAsync
òò  3
(
òò3 4
string
òò4 :
id
òò; =
)
òò= >
{
ôô 	
var
öö 
user
öö 
=
öö 
await
öö 
_userManager
öö )
.
öö) *
FindByIdAsync
öö* 7
(
öö7 8
id
öö8 :
)
öö: ;
;
öö; <
if
õõ 
(
õõ 
user
õõ 
==
õõ 
null
õõ 
)
õõ 
return
õõ $
false
õõ% *
;
õõ* +
await
ùù 
_userManager
ùù 
.
ùù 
DeleteAsync
ùù *
(
ùù* +
user
ùù+ /
)
ùù/ 0
;
ùù0 1
return
ûû 
true
ûû 
;
ûû 
}
üü 	
}
†† 
}°° €/
OE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\AdminSeeder.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

static 
class 
AdminSeeder #
{ 
private 
const 
string 
RoleSuperAdmin +
=, -
$str. :
;: ;
private		 
const		 
string		 
	RoleAdmin		 &
=		' (
$str		) 0
;		0 1
private

 
const

 
string

 
	RoleStaff

 &
=

' (
$str

) 0
;

0 1
private 
const 
string 
RoleUser %
=& '
$str( .
;. /
public 
static 
async 
Task  
SeedAdminAsync! /
(/ 0
UserManager0 ;
<; <
ApplicationUser< K
>K L
userManagerM X
,X Y
RoleManagerZ e
<e f
IdentityRolef r
>r s
roleManagert 
)	 Ä
{ 	
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
RoleSuperAdmin3 A
)A B
)B C
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
RoleSuperAdmin? M
)M N
)N O
;O P
} 
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
	RoleAdmin3 <
)< =
)= >
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
	RoleAdmin? H
)H I
)I J
;J K
} 
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
	RoleStaff3 <
)< =
)= >
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
	RoleStaff? H
)H I
)I J
;J K
} 
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
RoleUser3 ;
); <
)< =
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
RoleUser? G
)G H
)H I
;I J
} 
var   
superAdminEmail   
=    !
$str  " <
;  < =
var!! 
superAdminPassword!! "
=!!# $
$str!!% 0
;!!0 1
var"" 
superAdminUser"" 
=""  
await""! &
userManager""' 2
.""2 3
FindByEmailAsync""3 C
(""C D
superAdminEmail""D S
)""S T
;""T U
if$$ 
($$ 
superAdminUser$$ 
==$$ !
null$$" &
)$$& '
{%% 
superAdminUser&& 
=&&  
new&&! $
ApplicationUser&&% 4
{'' 
UserName(( 
=(( 
superAdminEmail(( .
,((. /
Email)) 
=)) 
superAdminEmail)) +
,))+ ,
	FirstName** 
=** 
$str**  '
,**' (
LastName++ 
=++ 
$str++ &
,++& '
EmailConfirmed,, "
=,,# $
true,,% )
,,,) *
Status-- 
=-- 
$str-- %
,--% &
Role.. 
=.. 
RoleSuperAdmin.. )
}// 
;// 
var11 
result11 
=11 
await11 "
userManager11# .
.11. /
CreateAsync11/ :
(11: ;
superAdminUser11; I
,11I J
superAdminPassword11K ]
)11] ^
;11^ _
if22 
(22 
result22 
.22 
	Succeeded22 $
)22$ %
await33 
userManager33 %
.33% &
AddToRoleAsync33& 4
(334 5
superAdminUser335 C
,33C D
RoleSuperAdmin33E S
)33S T
;33T U
}44 
else55 
{66 
var77 
token77 
=77 
await77 !
userManager77" -
.77- .+
GeneratePasswordResetTokenAsync77. M
(77M N
superAdminUser77N \
)77\ ]
;77] ^
await88 
userManager88 !
.88! "
ResetPasswordAsync88" 4
(884 5
superAdminUser885 C
,88C D
token88E J
,88J K
superAdminPassword88L ^
)88^ _
;88_ `
superAdminUser99 
.99 
Role99 #
=99$ %
RoleSuperAdmin99& 4
;994 5
await:: 
userManager:: !
.::! "
UpdateAsync::" -
(::- .
superAdminUser::. <
)::< =
;::= >
if<< 
(<< 
!<< 
await<< 
userManager<< &
.<<& '
IsInRoleAsync<<' 4
(<<4 5
superAdminUser<<5 C
,<<C D
RoleSuperAdmin<<E S
)<<S T
)<<T U
{== 
await>> 
userManager>> %
.>>% &
AddToRoleAsync>>& 4
(>>4 5
superAdminUser>>5 C
,>>C D
RoleSuperAdmin>>E S
)>>S T
;>>T U
}?? 
}@@ 
}AA 	
}BB 
}CC ør
]E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\ActivityLoggingMiddleware.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class %
ActivityLoggingMiddleware *
{		 
private

 
readonly

 
RequestDelegate

 (
_next

) .
;

. /
public %
ActivityLoggingMiddleware (
(( )
RequestDelegate) 8
next9 =
)= >
{ 	
_next 
= 
next 
; 
} 	
public 
async 
Task 
InvokeAsync %
(% &
HttpContext& 1
context2 9
,9 : 
ApplicationDbContext; O
	dbContextP Y
)Y Z
{ 	
var 
	shouldLog 
= 
ShouldLogRequest ,
(, -
context- 4
.4 5
Request5 <
)< =
;= >
await 
_next 
( 
context 
)  
;  !
if 
( 
! 
	shouldLog 
) 
return 
; 
if 
( 
context 
. 
Response  
.  !

StatusCode! +
<, -
StatusCodes. 9
.9 :
Status200OK: E
||F H
contextI P
.P Q
ResponseQ Y
.Y Z

StatusCodeZ d
>=e g
StatusCodesh s
.s t 
Status400BadRequest	t á
)
á à
return 
; 
var 
userId 
= 
context  
.  !
User! %
.% &
FindFirstValue& 4
(4 5

ClaimTypes5 ?
.? @
NameIdentifier@ N
)N O
;O P
if 
( 
string 
. 
IsNullOrWhiteSpace )
() *
userId* 0
)0 1
)1 2
return 
; 
try!! 
{"" 
var## 
type## 
=## 
GetActivityType## *
(##* +
context##+ 2
.##2 3
Request##3 :
)##: ;
;##; <
var$$ 
action$$ 
=$$ 
BuildAction$$ (
($$( )
context$$) 0
.$$0 1
Request$$1 8
,$$8 9
type$$: >
)$$> ?
;$$? @
	dbContext&& 
.&& 
ActivityLogs&& &
.&&& '
Add&&' *
(&&* +
new&&+ .
ActivityLog&&/ :
{'' 
UserID(( 
=(( 
userId(( #
,((# $
Action)) 
=)) 
action)) #
,))# $
Type** 
=** 
type** 
,**  
	IPAddress++ 
=++ 
context++  '
.++' (

Connection++( 2
.++2 3
RemoteIpAddress++3 B
?++B C
.++C D
ToString++D L
(++L M
)++M N
,++N O
	Timestamp,, 
=,, 
DateTime,,  (
.,,( )
UtcNow,,) /
}-- 
)-- 
;-- 
await// 
	dbContext// 
.//  
SaveChangesAsync//  0
(//0 1
)//1 2
;//2 3
}00 
catch11 
{22 
}44 
}55 	
private77 
static77 
bool77 
ShouldLogRequest77 ,
(77, -
HttpRequest77- 8
request779 @
)77@ A
{88 	
if99 
(99 
!99 
request99 
.99 
Path99 
.99 
StartsWithSegments99 0
(990 1
$str991 7
,997 8
StringComparison999 I
.99I J
OrdinalIgnoreCase99J [
)99[ \
)99\ ]
return:: 
false:: 
;:: 
var<< 
path<< 
=<< 
request<< 
.<< 
Path<< #
.<<# $
Value<<$ )
?<<) *
.<<* +
ToLowerInvariant<<+ ;
(<<; <
)<<< =
??<<> @
string<<A G
.<<G H
Empty<<H M
;<<M N
if?? 
(?? 
path?? 
.?? 

StartsWith?? 
(??  
$str??  :
)??: ;
||@@ 
path@@ 
.@@ 

StartsWith@@ "
(@@" #
$str@@# 6
)@@6 7
||AA 
pathAA 
.AA 

StartsWithAA "
(AA" #
$strAA# =
)AA= >
||BB 
pathBB 
.BB 

StartsWithBB "
(BB" #
$strBB# ?
)BB? @
||CC 
pathCC 
.CC 

StartsWithCC "
(CC" #
$strCC# @
)CC@ A
||DD 
pathDD 
.DD 

StartsWithDD "
(DD" #
$strDD# @
)DD@ A
||EE 
pathEE 
.EE 

StartsWithEE "
(EE" #
$strEE# :
)EE: ;
)EE; <
returnFF 
falseFF 
;FF 
returnHH 
requestHH 
.HH 
MethodHH !
isHH" $
$strHH% *
orHH+ -
$strHH. 4
orHH5 7
$strHH8 =
orHH> @
$strHHA H
orHHI K
$strHHL T
;HHT U
}II 	
privateKK 
staticKK 
stringKK 
GetActivityTypeKK -
(KK- .
HttpRequestKK. 9
requestKK: A
)KKA B
{LL 	
varMM 
pathMM 
=MM 
requestMM 
.MM 
PathMM #
.MM# $
ValueMM$ )
?MM) *
.MM* +
ToLowerInvariantMM+ ;
(MM; <
)MM< =
??MM> @
stringMMA G
.MMG H
EmptyMMH M
;MMM N
ifOO 
(OO 
pathOO 
.OO 
ContainsOO 
(OO 
$strOO +
)OO+ ,
||OO- /
pathOO0 4
.OO4 5
ContainsOO5 =
(OO= >
$strOO> R
)OOR S
||OOT V
pathOOW [
.OO[ \
ContainsOO\ d
(OOd e
$strOOe }
)OO} ~
)OO~ 
returnPP 
$strPP 
;PP 
returnRR 
requestRR 
.RR 
MethodRR !
switchRR" (
{SS 
$strTT 
=>TT 
$strTT 
,TT  
$strUU 
=>UU 
$strUU "
,UU" #
$strVV 
orVV 
$strVV  
=>VV! #
$strVV$ ,
,VV, -
$strWW 
=>WW 
$strWW $
,WW$ %
_XX 
=>XX 
$strXX 
}YY 
;YY 
}ZZ 	
private\\ 
static\\ 
string\\ 
BuildAction\\ )
(\\) *
HttpRequest\\* 5
request\\6 =
,\\= >
string\\? E
type\\F J
)\\J K
{]] 	
var^^ 
path^^ 
=^^ 
request^^ 
.^^ 
Path^^ #
.^^# $
Value^^$ )
?^^) *
.^^* +
ToLowerInvariant^^+ ;
(^^; <
)^^< =
??^^> @
string^^A G
.^^G H
Empty^^H M
;^^M N
if`` 
(`` 
path`` 
.`` 
Contains`` 
(`` 
$str`` +
)``+ ,
)``, -
return``. 4
$str``5 @
;``@ A
ifaa 
(aa 
pathaa 
.aa 
Containsaa 
(aa 
$straa .
)aa. /
)aa/ 0
returnaa1 7
$straa8 L
;aaL M
ifbb 
(bb 
pathbb 
.bb 
Containsbb 
(bb 
$strbb 2
)bb2 3
)bb3 4
returnbb5 ;
$strbb< S
;bbS T
ifcc 
(cc 
pathcc 
.cc 
Containscc 
(cc 
$strcc 2
)cc2 3
)cc3 4
returncc5 ;
$strcc< T
;ccT U
ifdd 
(dd 
pathdd 
.dd 
Containsdd 
(dd 
$strdd 6
)dd6 7
)dd7 8
returndd9 ?
$strdd@ \
;dd\ ]
ifff 
(ff 
pathff 
.ff 
Containsff 
(ff 
$strff 1
)ff1 2
&&ff3 5
typeff6 :
==ff; =
$strff> F
)ffF G
returnffH N
$strffO g
;ffg h
ifgg 
(gg 
pathgg 
.gg 
Containsgg 
(gg 
$strgg 1
)gg1 2
&&gg3 5
typegg6 :
==gg; =
$strgg> F
)ggF G
returnggH N
$strggO g
;ggg h
ifhh 
(hh 
pathhh 
.hh 
Containshh 
(hh 
$strhh 1
)hh1 2
&&hh3 5
typehh6 :
==hh; =
$strhh> F
)hhF G
returnhhH N
$strhhO g
;hhg h
ifjj 
(jj 
pathjj 
.jj 
Containsjj 
(jj 
$strjj .
)jj. /
&&jj0 2
typejj3 7
==jj8 :
$strjj; C
)jjC D
returnjjE K
$strjjL k
;jjk l
ifkk 
(kk 
pathkk 
.kk 
Containskk 
(kk 
$strkk /
)kk/ 0
&&kk1 3
pathkk4 8
.kk8 9
Containskk9 A
(kkA B
$strkkB K
)kkK L
)kkL M
returnkkN T
$strkkU g
;kkg h
ifll 
(ll 
pathll 
.ll 
Containsll 
(ll 
$strll /
)ll/ 0
&&ll1 3
pathll4 8
.ll8 9
Containsll9 A
(llA B
$strllB J
)llJ K
)llK L
returnllM S
$strllT f
;llf g
ifmm 
(mm 
pathmm 
.mm 
Containsmm 
(mm 
$strmm ,
)mm, -
&&mm. 0
typemm1 5
==mm6 8
$strmm9 A
)mmA B
returnmmC I
$strmmJ a
;mma b
ifnn 
(nn 
pathnn 
.nn 
Containsnn 
(nn 
$strnn ,
)nn, -
&&nn. 0
typenn1 5
==nn6 8
$strnn9 A
)nnA B
returnnnC I
$strnnJ a
;nna b
ifoo 
(oo 
pathoo 
.oo 
Containsoo 
(oo 
$stroo ,
)oo, -
&&oo. 0
typeoo1 5
==oo6 8
$stroo9 A
)ooA B
returnooC I
$strooJ a
;ooa b
ifpp 
(pp 
pathpp 
.pp 
Containspp 
(pp 
$strpp 0
)pp0 1
&&pp2 4
typepp5 9
==pp: <
$strpp= E
)ppE F
returnppG M
$strppN h
;pph i
ifqq 
(qq 
pathqq 
.qq 
Containsqq 
(qq 
$strqq 0
)qq0 1
&&qq2 4
typeqq5 9
==qq: <
$strqq= E
)qqE F
returnqqG M
$strqqN h
;qqh i
varss 
segmentsss 
=ss 
requestss "
.ss" #
Pathss# '
.ss' (
Valuess( -
?ss- .
.tt 
Splittt 
(tt 
$chartt 
,tt 
StringSplitOptionstt .
.tt. /
RemoveEmptyEntriestt/ A
)ttA B
.uu 
Skipuu 
(uu 
$numuu 
)uu 
.vv 
ToArrayvv 
(vv 
)vv 
??vv 
Arrayvv #
.vv# $
Emptyvv$ )
<vv) *
stringvv* 0
>vv0 1
(vv1 2
)vv2 3
;vv3 4
ifxx 
(xx 
segmentsxx 
.xx 
Lengthxx 
==xx  "
$numxx# $
)xx$ %
returnyy 
typeyy 
==yy 
$stryy '
?yy( )
$stryy* 8
:yy9 :
typeyy; ?
==yy@ B
$stryyC K
?yyL M
$stryyN \
:yy] ^
$stryy_ m
;yym n
var{{ 
resourceParts{{ 
={{ 
segments{{  (
.|| 
Take|| 
(|| 
Math|| 
.|| 
Min|| 
(|| 
$num||  
,||  !
segments||" *
.||* +
Length||+ 1
)||1 2
)||2 3
.}} 
Select}} 
(}} 
s}} 
=>}} 
s}} 
.}} 
Replace}} &
(}}& '
$char}}' *
,}}* +
$char}}, /
)}}/ 0
)}}0 1
.~~ 
Select~~ 
(~~ 
s~~ 
=>~~ 
CultureInfo~~ (
.~~( )
InvariantCulture~~) 9
.~~9 :
TextInfo~~: B
.~~B C
ToTitleCase~~C N
(~~N O
s~~O P
)~~P Q
)~~Q R
;~~R S
var
ÄÄ 
resource
ÄÄ 
=
ÄÄ 
string
ÄÄ !
.
ÄÄ! "
Join
ÄÄ" &
(
ÄÄ& '
$str
ÄÄ' *
,
ÄÄ* +
resourceParts
ÄÄ, 9
)
ÄÄ9 :
;
ÄÄ: ;
return
ÇÇ 
type
ÇÇ 
switch
ÇÇ 
{
ÉÉ 
$str
ÑÑ 
=>
ÑÑ 
$"
ÑÑ 
$str
ÑÑ &
{
ÑÑ& '
resource
ÑÑ' /
}
ÑÑ/ 0
"
ÑÑ0 1
,
ÑÑ1 2
$str
ÖÖ 
=>
ÖÖ 
$"
ÖÖ 
$str
ÖÖ &
{
ÖÖ& '
resource
ÖÖ' /
}
ÖÖ/ 0
"
ÖÖ0 1
,
ÖÖ1 2
$str
ÜÜ 
=>
ÜÜ 
$"
ÜÜ 
$str
ÜÜ &
{
ÜÜ& '
resource
ÜÜ' /
}
ÜÜ/ 0
"
ÜÜ0 1
,
ÜÜ1 2
_
áá 
=>
áá 
$"
áá 
$str
áá 
{
áá 
resource
áá '
}
áá' (
"
áá( )
}
àà 
;
àà 
}
ââ 	
}
ää 
}ãã Ú≠
BE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Program.cs
var 
builder 
= 
WebApplication 
. 
CreateBuilder *
(* +
args+ /
)/ 0
;0 1
builder 
. 
Services 
. 
AddControllers 
(  
)  !
. 
AddJsonOptions 
( 
options 
=> 
{ 
options 
. !
JsonSerializerOptions %
.% & 
PropertyNamingPolicy& :
=; <
System= C
.C D
TextD H
.H I
JsonI M
.M N
JsonNamingPolicyN ^
.^ _
	CamelCase_ h
;h i
options 
. !
JsonSerializerOptions %
.% &
DictionaryKeyPolicy& 9
=: ;
System< B
.B C
TextC G
.G H
JsonH L
.L M
JsonNamingPolicyM ]
.] ^
	CamelCase^ g
;g h
options 
. !
JsonSerializerOptions %
.% &'
PropertyNameCaseInsensitive& A
=B C
trueD H
;H I
options 
. !
JsonSerializerOptions %
.% &

Converters& 0
.0 1
Add1 4
(4 5
new5 8 
UtcDateTimeConverter9 M
(M N
)N O
)O P
;P Q
} 
) 
; 
builder 
. 
Services 
. #
AddEndpointsApiExplorer (
(( )
)) *
;* +
builder 
. 
Services 
. 
AddSwaggerGen 
( 
c  
=>! #
{ 
c   
.   !
AddSecurityDefinition   
(   
$str   $
,  $ %
new  & )
	Microsoft  * 3
.  3 4
OpenApi  4 ;
.  ; <
Models  < B
.  B C!
OpenApiSecurityScheme  C X
{!! 
Description"" 
="" 
$str"" t
,""t u
Name## 
=## 
$str## 
,## 
In$$ 

=$$ 
	Microsoft$$ 
.$$ 
OpenApi$$ 
.$$ 
Models$$ %
.$$% &
ParameterLocation$$& 7
.$$7 8
Header$$8 >
,$$> ?
Type%% 
=%% 
	Microsoft%% 
.%% 
OpenApi%%  
.%%  !
Models%%! '
.%%' (
SecuritySchemeType%%( :
.%%: ;
ApiKey%%; A
,%%A B
Scheme&& 
=&& 
$str&& 
}'' 
)'' 
;'' 
c(( 
.(( "
AddSecurityRequirement(( 
((( 
new((  
	Microsoft((! *
.((* +
OpenApi((+ 2
.((2 3
Models((3 9
.((9 :&
OpenApiSecurityRequirement((: T
{)) 
{** 	
new++ 
	Microsoft++ 
.++ 
OpenApi++ !
.++! "
Models++" (
.++( )!
OpenApiSecurityScheme++) >
{,, 
	Reference-- 
=-- 
new-- 
	Microsoft--  )
.--) *
OpenApi--* 1
.--1 2
Models--2 8
.--8 9
OpenApiReference--9 I
{.. 
Type// 
=// 
	Microsoft// $
.//$ %
OpenApi//% ,
.//, -
Models//- 3
.//3 4
ReferenceType//4 A
.//A B
SecurityScheme//B P
,//P Q
Id00 
=00 
$str00 !
}11 
}22 
,22 
Array33 
.33 
Empty33 
<33 
string33 
>33 
(33  
)33  !
}44 	
}55 
)55 
;55 
}66 
)66 
;66 
builder99 
.99 
Services99 
.99 
AddDbContext99 
<99  
ApplicationDbContext99 2
>992 3
(993 4
options994 ;
=>99< >
options:: 
.:: 
UseSqlServer:: 
(:: 
builder::  
.::  !
Configuration::! .
.::. /
GetConnectionString::/ B
(::B C
$str::C V
)::V W
)::W X
)::X Y
;::Y Z
builder== 
.== 
Services== 
.== 
AddIdentity== 
<== 
ApplicationUser== ,
,==, -
IdentityRole==. :
>==: ;
(==; <
options==< C
=>==D F
{>> 
options@@ 
.@@ 
Password@@ 
.@@ 
RequireDigit@@ !
=@@" #
true@@$ (
;@@( )
optionsAA 
.AA 
PasswordAA 
.AA 
RequireLowercaseAA %
=AA& '
trueAA( ,
;AA, -
optionsBB 
.BB 
PasswordBB 
.BB 
RequireUppercaseBB %
=BB& '
trueBB( ,
;BB, -
optionsCC 
.CC 
PasswordCC 
.CC "
RequireNonAlphanumericCC +
=CC, -
trueCC. 2
;CC2 3
optionsDD 
.DD 
PasswordDD 
.DD 
RequiredLengthDD #
=DD$ %
$numDD& (
;DD( )
optionsEE 
.EE 
PasswordEE 
.EE 
RequiredUniqueCharsEE (
=EE) *
$numEE+ ,
;EE, -
optionsHH 
.HH 
LockoutHH 
.HH 
AllowedForNewUsersHH &
=HH' (
trueHH) -
;HH- .
optionsII 
.II 
LockoutII 
.II #
MaxFailedAccessAttemptsII +
=II, -
$numII. /
;II/ 0
optionsJJ 
.JJ 
LockoutJJ 
.JJ "
DefaultLockoutTimeSpanJJ *
=JJ+ ,
TimeSpanJJ- 5
.JJ5 6
FromMinutesJJ6 A
(JJA B
$numJJB D
)JJD E
;JJE F
}KK 
)KK 
.LL $
AddEntityFrameworkStoresLL 
<LL  
ApplicationDbContextLL 2
>LL2 3
(LL3 4
)LL4 5
.MM $
AddDefaultTokenProvidersMM 
(MM 
)MM 
;MM  
varPP 
jwtKeyPP 

=PP 
EnvironmentPP 
.PP "
GetEnvironmentVariablePP /
(PP/ 0
$strPP0 9
)PP9 :
;PP: ;
ifQQ 
(QQ 
stringQQ 

.QQ
 
IsNullOrWhiteSpaceQQ 
(QQ 
jwtKeyQQ $
)QQ$ %
)QQ% &
throwRR 	
newRR
 %
InvalidOperationExceptionRR '
(RR' (
$strRR( m
)RRm n
;RRn o
builderTT 
.TT 
ServicesTT 
.TT 
AddAuthenticationTT "
(TT" #
optionsTT# *
=>TT+ -
{UU 
optionsVV 
.VV %
DefaultAuthenticateSchemeVV %
=VV& '
JwtBearerDefaultsVV( 9
.VV9 : 
AuthenticationSchemeVV: N
;VVN O
optionsWW 
.WW "
DefaultChallengeSchemeWW "
=WW# $
JwtBearerDefaultsWW% 6
.WW6 7 
AuthenticationSchemeWW7 K
;WWK L
}XX 
)XX 
.YY 
AddJwtBearerYY 
(YY 
optionsYY 
=>YY 
{ZZ 
options[[ 
.[[ %
TokenValidationParameters[[ %
=[[& '
new[[( +%
TokenValidationParameters[[, E
{\\ 
ValidateIssuer]] 
=]] 
true]] 
,]] 
ValidateAudience^^ 
=^^ 
true^^ 
,^^  
ValidateLifetime__ 
=__ 
true__ 
,__  $
ValidateIssuerSigningKey``  
=``! "
true``# '
,``' (
ValidIssueraa 
=aa 
builderaa 
.aa 
Configurationaa +
[aa+ ,
$straa, 8
]aa8 9
,aa9 :
ValidAudiencebb 
=bb 
builderbb 
.bb  
Configurationbb  -
[bb- .
$strbb. <
]bb< =
,bb= >
IssuerSigningKeycc 
=cc 
newcc  
SymmetricSecurityKeycc 3
(cc3 4
Encodingcc4 <
.cc< =
UTF8cc= A
.ccA B
GetBytesccB J
(ccJ K
jwtKeyccK Q
)ccQ R
)ccR S
}dd 
;dd 
}ee 
)ee 
.ff 
	AddGoogleff 

(ff
 
optionsff 
=>ff 
{gg 
optionshh 
.hh 
ClientIdhh 
=hh 
builderhh 
.hh 
Configurationhh ,
[hh, -
$strhh- >
]hh> ?
!hh? @
;hh@ A
optionsii 
.ii 
ClientSecretii 
=ii 
builderii "
.ii" #
Configurationii# 0
[ii0 1
$strii1 F
]iiF G
!iiG H
;iiH I
}jj 
)jj 
;jj 
buildermm 
.mm 
Servicesmm 
.mm 
AddCorsmm 
(mm 
optionsmm  
=>mm! #
{nn 
optionsoo 
.oo 
	AddPolicyoo 
(oo 
$stroo %
,oo% &
policypp 
=>pp 
{qq 	
policyrr 
.rr 
AllowAnyOriginrr !
(rr! "
)rr" #
.ss 
AllowAnyHeaderss !
(ss! "
)ss" #
.tt 
AllowAnyMethodtt !
(tt! "
)tt" #
;tt# $
}uu 	
)uu	 

;uu
 
}vv 
)vv 
;vv 
builderyy 
.yy 
Servicesyy 
.yy 
AddRateLimiteryy 
(yy  
optionsyy  '
=>yy( *
{zz 
options{{ 
.{{ 
RejectionStatusCode{{ 
={{  !
StatusCodes{{" -
.{{- .$
Status429TooManyRequests{{. F
;{{F G
options|| 
.|| 
	AddPolicy|| 
(|| 
$str|| 
,|| 
httpContext|| )
=>||* ,
RateLimitPartition}} 
.}} !
GetFixedWindowLimiter}} 0
(}}0 1
partitionKey~~ 
:~~ 
httpContext~~ %
.~~% &

Connection~~& 0
.~~0 1
RemoteIpAddress~~1 @
?~~@ A
.~~A B
ToString~~B J
(~~J K
)~~K L
??~~M O
$str~~P Y
,~~Y Z
factory 
: 
_ 
=> 
new )
FixedWindowRateLimiterOptions ;
{
ÄÄ 
PermitLimit
ÅÅ 
=
ÅÅ 
$num
ÅÅ  
,
ÅÅ  !
Window
ÇÇ 
=
ÇÇ 
TimeSpan
ÇÇ !
.
ÇÇ! "
FromMinutes
ÇÇ" -
(
ÇÇ- .
$num
ÇÇ. /
)
ÇÇ/ 0
,
ÇÇ0 1"
QueueProcessingOrder
ÉÉ $
=
ÉÉ% &"
QueueProcessingOrder
ÉÉ' ;
.
ÉÉ; <
OldestFirst
ÉÉ< G
,
ÉÉG H

QueueLimit
ÑÑ 
=
ÑÑ 
$num
ÑÑ 
}
ÖÖ 
)
ÖÖ 
)
ÖÖ 
;
ÖÖ 
}ÜÜ 
)
ÜÜ 
;
ÜÜ 
builderââ 
.
ââ 
Services
ââ 
.
ââ 
	AddScoped
ââ 
<
ââ $
TayoKonnektado_project
ââ 1
.
ââ1 2
Services
ââ2 :
.
ââ: ;
PayMongoService
ââ; J
>
ââJ K
(
ââK L
)
ââL M
;
ââM N
builderää 
.
ää 
Services
ää 
.
ää 
	AddScoped
ää 
<
ää $
TayoKonnektado_project
ää 1
.
ää1 2
Services
ää2 :
.
ää: ;
TokenService
ää; G
>
ääG H
(
ääH I
)
ääI J
;
ääJ K
builderãã 
.
ãã 
Services
ãã 
.
ãã 
	AddScoped
ãã 
<
ãã $
TayoKonnektado_project
ãã 1
.
ãã1 2
Services
ãã2 :
.
ãã: ;
EmailService
ãã; G
>
ããG H
(
ããH I
)
ããI J
;
ããJ K
builderåå 
.
åå 
Services
åå 
.
åå 
	AddScoped
åå 
<
åå $
TayoKonnektado_project
åå 1
.
åå1 2
Services
åå2 :
.
åå: ;
Admin
åå; @
.
åå@ A'
CustomerManagementService
ååA Z
>
ååZ [
(
åå[ \
)
åå\ ]
;
åå] ^
builderçç 
.
çç 
Services
çç 
.
çç 
	AddScoped
çç 
<
çç $
TayoKonnektado_project
çç 1
.
çç1 2
Services
çç2 :
.
çç: ;
Admin
çç; @
.
çç@ A%
TicketManagementService
ççA X
>
ççX Y
(
ççY Z
)
ççZ [
;
çç[ \
builderéé 
.
éé 
Services
éé 
.
éé 
	AddScoped
éé 
<
éé $
TayoKonnektado_project
éé 1
.
éé1 2
Services
éé2 :
.
éé: ;
Admin
éé; @
.
éé@ A&
PaymentManagementService
ééA Y
>
ééY Z
(
ééZ [
)
éé[ \
;
éé\ ]
builderèè 
.
èè 
Services
èè 
.
èè 
	AddScoped
èè 
<
èè $
TayoKonnektado_project
èè 1
.
èè1 2
Services
èè2 :
.
èè: ;
Admin
èè; @
.
èè@ A+
SubscriptionManagementService
èèA ^
>
èè^ _
(
èè_ `
)
èè` a
;
èèa b
builderêê 
.
êê 
Services
êê 
.
êê 
	AddScoped
êê 
<
êê $
TayoKonnektado_project
êê 1
.
êê1 2
Services
êê2 :
.
êê: ;
Admin
êê; @
.
êê@ A$
StaffManagementService
êêA W
>
êêW X
(
êêX Y
)
êêY Z
;
êêZ [
builderëë 
.
ëë 
Services
ëë 
.
ëë 
	AddScoped
ëë 
<
ëë $
TayoKonnektado_project
ëë 1
.
ëë1 2
Services
ëë2 :
.
ëë: ;
Admin
ëë; @
.
ëë@ A
DashboardService
ëëA Q
>
ëëQ R
(
ëëR S
)
ëëS T
;
ëëT U
builderíí 
.
íí 
Services
íí 
.
íí 
	AddScoped
íí 
<
íí $
TayoKonnektado_project
íí 1
.
íí1 2
Services
íí2 :
.
íí: ;
Admin
íí; @
.
íí@ A#
PlanManagementService
ííA V
>
ííV W
(
ííW X
)
ííX Y
;
ííY Z
builderìì 
.
ìì 
Services
ìì 
.
ìì 
	AddScoped
ìì 
<
ìì $
TayoKonnektado_project
ìì 1
.
ìì1 2
Services
ìì2 :
.
ìì: ;
Admin
ìì; @
.
ìì@ A"
FAQManagementService
ììA U
>
ììU V
(
ììV W
)
ììW X
;
ììX Y
builderîî 
.
îî 
Services
îî 
.
îî 
	AddScoped
îî 
<
îî $
TayoKonnektado_project
îî 1
.
îî1 2
Services
îî2 :
.
îî: ;!
LoginAttemptService
îî; N
>
îîN O
(
îîO P
)
îîP Q
;
îîQ R
builderïï 
.
ïï 
Services
ïï 
.
ïï 
AddHostedService
ïï !
<
ïï! "$
TayoKonnektado_project
ïï" 8
.
ïï8 9
Services
ïï9 A
.
ïïA B(
SubscriptionEndDateService
ïïB \
>
ïï\ ]
(
ïï] ^
)
ïï^ _
;
ïï_ `
builderññ 
.
ññ 
Services
ññ 
.
ññ 
AddHostedService
ññ !
<
ññ! "$
TayoKonnektado_project
ññ" 8
.
ññ8 9
Services
ññ9 A
.
ññA B!
PrepaidUsageService
ññB U
>
ññU V
(
ññV W
)
ññW X
;
ññX Y
builderóó 
.
óó 
Services
óó 
.
óó 
AddHttpClient
óó 
(
óó 
)
óó  
;
óó  !
builderòò 
.
òò 
Services
òò 
.
òò 
	Configure
òò 
<
òò 
SecuritySettings
òò +
>
òò+ ,
(
òò, -
builder
òò- 4
.
òò4 5
Configuration
òò5 B
.
òòB C

GetSection
òòC M
(
òòM N
$str
òòN X
)
òòX Y
)
òòY Z
;
òòZ [
builderôô 
.
ôô 
Services
ôô 
.
ôô 
AddSingleton
ôô 
<
ôô '
IpDeviceReputationService
ôô 7
>
ôô7 8
(
ôô8 9
)
ôô9 :
;
ôô: ;
builderöö 
.
öö 
Services
öö 
.
öö 
AddHttpClient
öö 
<
öö #
PasswordBreachService
öö 4
>
öö4 5
(
öö5 6
)
öö6 7
;
öö7 8
varúú 
app
úú 
=
úú 	
builder
úú
 
.
úú 
Build
úú 
(
úú 
)
úú 
;
úú 
appüü 
.
üü 

UseSwagger
üü 
(
üü 
)
üü 
;
üü 
app†† 
.
†† 
UseSwaggerUI
†† 
(
†† 
)
†† 
;
†† 
app¢¢ 
.
¢¢ 
UseCors
¢¢ 
(
¢¢ 
$str
¢¢ 
)
¢¢ 
;
¢¢ 
app§§ 
.
§§ 
UseStaticFiles
§§ 
(
§§ 
)
§§ 
;
§§ 
app•• 
.
•• 
UseDefaultFiles
•• 
(
•• 
)
•• 
;
•• 
ifßß 
(
ßß 
app
ßß 
.
ßß 
Environment
ßß 
.
ßß 
IsDevelopment
ßß !
(
ßß! "
)
ßß" #
)
ßß# $
{®® 
}™™ 
else´´ 
{¨¨ 
app
≠≠ 
.
≠≠ !
UseHttpsRedirection
≠≠ 
(
≠≠ 
)
≠≠ 
;
≠≠ 
}ÆÆ 
app∞∞ 
.
∞∞ 
UseAuthentication
∞∞ 
(
∞∞ 
)
∞∞ 
;
∞∞ 
app±± 
.
±± 
UseRateLimiter
±± 
(
±± 
)
±± 
;
±± 
app≤≤ 
.
≤≤ 
UseMiddleware
≤≤ 
<
≤≤ '
ActivityLoggingMiddleware
≤≤ +
>
≤≤+ ,
(
≤≤, -
)
≤≤- .
;
≤≤. /
app≥≥ 
.
≥≥ 
UseAuthorization
≥≥ 
(
≥≥ 
)
≥≥ 
;
≥≥ 
appµµ 
.
µµ 
MapControllers
µµ 
(
µµ 
)
µµ 
;
µµ 
app∑∑ 
.
∑∑ 
MapFallback
∑∑ 
(
∑∑ 
async
∑∑ 
context
∑∑ 
=>
∑∑  
{∏∏ 
if
ππ 
(
ππ 
!
ππ 	
context
ππ	 
.
ππ 
Request
ππ 
.
ππ 
Path
ππ 
.
ππ  
StartsWithSegments
ππ 0
(
ππ0 1
$str
ππ1 7
)
ππ7 8
)
ππ8 9
{
∫∫ 
context
ªª 
.
ªª 
Response
ªª 
.
ªª 
ContentType
ªª $
=
ªª% &
$str
ªª' 2
;
ªª2 3
await
ºº 
context
ºº 
.
ºº 
Response
ºº 
.
ºº 
SendFileAsync
ºº ,
(
ºº, -
Path
ºº- 1
.
ºº1 2
Combine
ºº2 9
(
ºº9 :
app
ºº: =
.
ºº= >
Environment
ºº> I
.
ººI J
WebRootPath
ººJ U
,
ººU V
$str
ººW c
)
ººc d
)
ººd e
;
ººe f
}
ΩΩ 
}ææ 
)
ææ 
;
ææ 
using¡¡ 
(
¡¡ 
var
¡¡ 

scope
¡¡ 
=
¡¡ 
app
¡¡ 
.
¡¡ 
Services
¡¡ 
.
¡¡  
CreateScope
¡¡  +
(
¡¡+ ,
)
¡¡, -
)
¡¡- .
{¬¬ 
var
√√ 
userManager
√√ 
=
√√ 
scope
√√ 
.
√√ 
ServiceProvider
√√ +
.
√√+ , 
GetRequiredService
√√, >
<
√√> ?
UserManager
√√? J
<
√√J K
ApplicationUser
√√K Z
>
√√Z [
>
√√[ \
(
√√\ ]
)
√√] ^
;
√√^ _
var
ƒƒ 
roleManager
ƒƒ 
=
ƒƒ 
scope
ƒƒ 
.
ƒƒ 
ServiceProvider
ƒƒ +
.
ƒƒ+ , 
GetRequiredService
ƒƒ, >
<
ƒƒ> ?
RoleManager
ƒƒ? J
<
ƒƒJ K
IdentityRole
ƒƒK W
>
ƒƒW X
>
ƒƒX Y
(
ƒƒY Z
)
ƒƒZ [
;
ƒƒ[ \
var
≈≈ 
context
≈≈ 
=
≈≈ 
scope
≈≈ 
.
≈≈ 
ServiceProvider
≈≈ '
.
≈≈' ( 
GetRequiredService
≈≈( :
<
≈≈: ;"
ApplicationDbContext
≈≈; O
>
≈≈O P
(
≈≈P Q
)
≈≈Q R
;
≈≈R S
await
∆∆ 	
AdminSeeder
∆∆
 
.
∆∆ 
SeedAdminAsync
∆∆ $
(
∆∆$ %
userManager
∆∆% 0
,
∆∆0 1
roleManager
∆∆2 =
)
∆∆= >
;
∆∆> ?
await
«« 	

PlanSeeder
««
 
.
«« 
SeedPlansAsync
«« #
(
««# $
context
««$ +
)
««+ ,
;
««, -
}»» 
await   
app
   	
.
  	 

RunAsync
  
 
(
   
)
   
;
   È
RE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\SecuritySettings.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
SecuritySettings !
{ 
public 
List 
< 
string 
> 

BlockedIPs &
{' (
get) ,
;, -
set. 1
;1 2
}3 4
=5 6
new7 :
(: ;
); <
;< =
public 
List 
< 
string 
> 
BlockedUserAgents -
{. /
get0 3
;3 4
set5 8
;8 9
}: ;
=< =
new> A
(A B
)B C
;C D
public 
int "
MaxFailedAttemptsPerIp )
{* +
get, /
;/ 0
set1 4
;4 5
}6 7
=8 9
$num: <
;< =
public 
int &
MaxFailedAttemptsPerDevice -
{. /
get0 3
;3 4
set5 8
;8 9
}: ;
=< =
$num> @
;@ A
public		 
int		 
BlockMinutes		 
{		  !
get		" %
;		% &
set		' *
;		* +
}		, -
=		. /
$num		0 2
;		2 3
}

 
} œ
TE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\SavedPaymentMethod.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
SavedPaymentMethod #
{ 
[ 	
Key	 
] 
public		 
int		 
PaymentMethodID		 "
{		# $
get		% (
;		( )
set		* -
;		- .
}		/ 0
public

 
string

 
UserID

 
{

 
get

 "
;

" #
set

$ '
;

' (
}

) *
=

+ ,
string

- 3
.

3 4
Empty

4 9
;

9 :
public 
string #
PayMongoPaymentMethodId -
{. /
get0 3
;3 4
set5 8
;8 9
}: ;
=< =
string> D
.D E
EmptyE J
;J K
public 
string 
Type 
{ 
get  
;  !
set" %
;% &
}' (
=) *
string+ 1
.1 2
Empty2 7
;7 8
public 
string 
? 
Last4 
{ 
get "
;" #
set$ '
;' (
}) *
public 
string 
? 
Brand 
{ 
get "
;" #
set$ '
;' (
}) *
public 
int 
? 
ExpMonth 
{ 
get "
;" #
set$ '
;' (
}) *
public 
int 
? 
ExpYear 
{ 
get !
;! "
set# &
;& '
}( )
public 
bool 
	IsDefault 
{ 
get  #
;# $
set% (
;( )
}* +
public 
DateTime 
	CreatedAt !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
DateTime2 :
.: ;
UtcNow; A
;A B
[ 	

ForeignKey	 
( 
$str 
) 
] 
public 
ApplicationUser 
User #
{$ %
get& )
;) *
set+ .
;. /
}0 1
=2 3
null4 8
!8 9
;9 :
} 
} Ÿ
PE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\PaymentRequest.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
PaymentRequest 
{ 
[ 	
Required	 
] 
public 
decimal 
Amount 
{ 
get  #
;# $
set% (
;( )
}* +
public		 
string		 
Description		 !
{		" #
get		$ '
;		' (
set		) ,
;		, -
}		. /
=		0 1
string		2 8
.		8 9
Empty		9 >
;		> ?
public

 
string

 
CustomerEmail

 #
{

$ %
get

& )
;

) *
set

+ .
;

. /
}

0 1
=

2 3
string

4 :
.

: ;
Empty

; @
;

@ A
public 
string 
CustomerName "
{# $
get% (
;( )
set* -
;- .
}/ 0
=1 2
string3 9
.9 :
Empty: ?
;? @
public 
string 
PaymentMethod #
{$ %
get& )
;) *
set+ .
;. /
}0 1
=2 3
$str4 H
;H I
} 
public 

class 
PaymentResponse  
{ 
public 
string 
	PaymentId 
{  !
get" %
;% &
set' *
;* +
}, -
=. /
string0 6
.6 7
Empty7 <
;< =
public 
string 
CheckoutUrl !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
public 
string 
Status 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
string- 3
.3 4
Empty4 9
;9 :
} 
} õ
RE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\OnboardingModels.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
VerificationCode !
{ 
[ 	
Key	 
] 
public 
int 
Id 
{ 
get 
; 
set  
;  !
}" #
public		 
string		 
Email		 
{		 
get		 !
;		! "
set		# &
;		& '
}		( )
=		* +
string		, 2
.		2 3
Empty		3 8
;		8 9
public

 
string

 
Code

 
{

 
get

  
;

  !
set

" %
;

% &
}

' (
=

) *
string

+ 1
.

1 2
Empty

2 7
;

7 8
public 
DateTime 
	ExpiresAt !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
bool 
IsUsed 
{ 
get  
;  !
set" %
;% &
}' (
=) *
false+ 0
;0 1
} 
public 

class 
OnboardingStatus !
{ 
[ 	
Key	 
] 
public 
int 
Id 
{ 
get 
; 
set  
;  !
}" #
public 
string 
UserID 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
string- 3
.3 4
Empty4 9
;9 :
public 
bool 
IsEmailVerified #
{$ %
get& )
;) *
set+ .
;. /
}0 1
=2 3
false4 9
;9 :
public 
bool "
HasSelectedServiceType *
{+ ,
get- 0
;0 1
set2 5
;5 6
}7 8
=9 :
false; @
;@ A
public 
bool 
HasRegisteredDevice '
{( )
get* -
;- .
set/ 2
;2 3
}4 5
=6 7
false8 =
;= >
public 
bool  
HasCompletedTutorial (
{) *
get+ .
;. /
set0 3
;3 4
}5 6
=7 8
false9 >
;> ?
} 
} π˚
JE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\Entities.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
Device 
{ 
[ 	
Key	 
] 
public		 
int		 
DeviceID		 
{		 
get		 !
;		! "
set		# &
;		& '
}		( )
public

 
string

 
UserID

 
{

 
get

 "
;

" #
set

$ '
;

' (
}

) *
=

+ ,
string

- 3
.

3 4
Empty

4 9
;

9 :
public 
string 
? 

MACAddress !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
string 
? 
OPCCodeToken #
{$ %
get& )
;) *
set+ .
;. /
}0 1
public 
string 
? 

DeviceType !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
string 
? 
Status 
{ 
get  #
;# $
set% (
;( )
}* +
public 
DateTime 
RegisteredAt $
{% &
get' *
;* +
set, /
;/ 0
}1 2
=3 4
DateTime5 =
.= >
UtcNow> D
;D E
[ 	

ForeignKey	 
( 
$str 
) 
] 
public 
ApplicationUser 
User #
{$ %
get& )
;) *
set+ .
;. /
}0 1
=2 3
null4 8
!8 9
;9 :
public 
ICollection 
< 
SupportTicket (
>( )
SupportTickets* 8
{9 :
get; >
;> ?
set@ C
;C D
}E F
=G H
newI L
ListM Q
<Q R
SupportTicketR _
>_ `
(` a
)a b
;b c
public 
ICollection 
< 
ServiceAccount )
>) *
ServiceAccounts+ :
{; <
get= @
;@ A
setB E
;E F
}G H
=I J
newK N
ListO S
<S T
ServiceAccountT b
>b c
(c d
)d e
;e f
} 
public 

class 
SupportTicket 
{ 
[ 	
Key	 
] 
public 
int 
TicketID 
{ 
get !
;! "
set# &
;& '
}( )
public 
string 
UserID 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
string- 3
.3 4
Empty4 9
;9 :
public 
int 
? 
DeviceID 
{ 
get "
;" #
set$ '
;' (
}) *
public 
string 
? 
AssignedStaffID &
{' (
get) ,
;, -
set. 1
;1 2
}3 4
public 
string 
Subject 
{ 
get  #
;# $
set% (
;( )
}* +
=, -
string. 4
.4 5
Empty5 :
;: ;
public 
string 
? 
Description "
{# $
get% (
;( )
set* -
;- .
}/ 0
public   
string   
?   
Category   
{    !
get  " %
;  % &
set  ' *
;  * +
}  , -
public!! 
string!! 
?!! 
Priority!! 
{!!  !
get!!" %
;!!% &
set!!' *
;!!* +
}!!, -
public"" 
string"" 
?"" 
AttachmentUrl"" $
{""% &
get""' *
;""* +
set"", /
;""/ 0
}""1 2
public## 
string## 
?## 
Status## 
{## 
get##  #
;### $
set##% (
;##( )
}##* +
public$$ 
bool$$ 

IsArchived$$ 
{$$  
get$$! $
;$$$ %
set$$& )
;$$) *
}$$+ ,
=$$- .
false$$/ 4
;$$4 5
public%% 
bool%% 
IsHiddenByCustomer%% &
{%%' (
get%%) ,
;%%, -
set%%. 1
;%%1 2
}%%3 4
=%%5 6
false%%7 <
;%%< =
public&& 
DateTime&& 
	CreatedAt&& !
{&&" #
get&&$ '
;&&' (
set&&) ,
;&&, -
}&&. /
=&&0 1
DateTime&&2 :
.&&: ;
UtcNow&&; A
;&&A B
[(( 	

ForeignKey((	 
((( 
$str(( 
)(( 
](( 
public)) 
ApplicationUser)) 
User)) #
{))$ %
get))& )
;))) *
set))+ .
;)). /
}))0 1
=))2 3
null))4 8
!))8 9
;))9 :
[** 	

ForeignKey**	 
(** 
$str** 
)** 
]**  
public++ 
Device++ 
?++ 
Device++ 
{++ 
get++  #
;++# $
set++% (
;++( )
}++* +
public,, 
ICollection,, 
<,, 
TicketReply,, &
>,,& '
Replies,,( /
{,,0 1
get,,2 5
;,,5 6
set,,7 :
;,,: ;
},,< =
=,,> ?
new,,@ C
List,,D H
<,,H I
TicketReply,,I T
>,,T U
(,,U V
),,V W
;,,W X
}-- 
public// 

class// 
TicketReply// 
{00 
[11 	
Key11	 
]11 
public22 
int22 
ReplyID22 
{22 
get22  
;22  !
set22" %
;22% &
}22' (
public33 
int33 
TicketID33 
{33 
get33 !
;33! "
set33# &
;33& '
}33( )
public44 
string44 
UserID44 
{44 
get44 "
;44" #
set44$ '
;44' (
}44) *
=44+ ,
string44- 3
.443 4
Empty444 9
;449 :
public55 
string55 
Message55 
{55 
get55  #
;55# $
set55% (
;55( )
}55* +
=55, -
string55. 4
.554 5
Empty555 :
;55: ;
public66 
bool66 
IsAdminReply66  
{66! "
get66# &
;66& '
set66( +
;66+ ,
}66- .
=66/ 0
false661 6
;666 7
public77 
DateTime77 
	CreatedAt77 !
{77" #
get77$ '
;77' (
set77) ,
;77, -
}77. /
=770 1
DateTime772 :
.77: ;
UtcNow77; A
;77A B
[99 	

ForeignKey99	 
(99 
$str99 
)99 
]99  
public:: 
SupportTicket:: 
Ticket:: #
{::$ %
get::& )
;::) *
set::+ .
;::. /
}::0 1
=::2 3
null::4 8
!::8 9
;::9 :
[;; 	

ForeignKey;;	 
(;; 
$str;; 
);; 
];; 
public<< 
ApplicationUser<< 
User<< #
{<<$ %
get<<& )
;<<) *
set<<+ .
;<<. /
}<<0 1
=<<2 3
null<<4 8
!<<8 9
;<<9 :
}== 
public?? 

class?? 
Notification?? 
{@@ 
[AA 	
KeyAA	 
]AA 
publicBB 
intBB 
NotificationIDBB !
{BB" #
getBB$ '
;BB' (
setBB) ,
;BB, -
}BB. /
publicCC 
stringCC 
UserIDCC 
{CC 
getCC "
;CC" #
setCC$ '
;CC' (
}CC) *
=CC+ ,
stringCC- 3
.CC3 4
EmptyCC4 9
;CC9 :
publicDD 
stringDD 
MessageDD 
{DD 
getDD  #
;DD# $
setDD% (
;DD( )
}DD* +
=DD, -
stringDD. 4
.DD4 5
EmptyDD5 :
;DD: ;
publicEE 
stringEE 
?EE 
TypeEE 
{EE 
getEE !
;EE! "
setEE# &
;EE& '
}EE( )
publicFF 
DateTimeFF 
SentAtFF 
{FF  
getFF! $
;FF$ %
setFF& )
;FF) *
}FF+ ,
=FF- .
DateTimeFF/ 7
.FF7 8
UtcNowFF8 >
;FF> ?
publicGG 
stringGG 
?GG 
StatusGG 
{GG 
getGG  #
;GG# $
setGG% (
;GG( )
}GG* +
[II 	

ForeignKeyII	 
(II 
$strII 
)II 
]II 
publicJJ 
ApplicationUserJJ 
UserJJ #
{JJ$ %
getJJ& )
;JJ) *
setJJ+ .
;JJ. /
}JJ0 1
=JJ2 3
nullJJ4 8
!JJ8 9
;JJ9 :
}KK 
publicMM 

classMM 
ServiceAccountMM 
{NN 
[OO 	
KeyOO	 
]OO 
publicPP 
intPP 
ServiceAccountIDPP #
{PP$ %
getPP& )
;PP) *
setPP+ .
;PP. /
}PP0 1
publicQQ 
intQQ 
DeviceIDQQ 
{QQ 
getQQ !
;QQ! "
setQQ# &
;QQ& '
}QQ( )
publicRR 
stringRR 
?RR 
ServiceTypeRR "
{RR# $
getRR% (
;RR( )
setRR* -
;RR- .
}RR/ 0
publicSS 
stringSS 
?SS 
StatusSS 
{SS 
getSS  #
;SS# $
setSS% (
;SS( )
}SS* +
publicTT 
DateTimeTT 
ActivatedAtTT #
{TT$ %
getTT& )
;TT) *
setTT+ .
;TT. /
}TT0 1
=TT2 3
DateTimeTT4 <
.TT< =
UtcNowTT= C
;TTC D
[VV 	

ForeignKeyVV	 
(VV 
$strVV 
)VV 
]VV  
publicWW 
DeviceWW 
DeviceWW 
{WW 
getWW "
;WW" #
setWW$ '
;WW' (
}WW) *
=WW+ ,
nullWW- 1
!WW1 2
;WW2 3
publicXX 
ICollectionXX 
<XX 
SubscriptionXX '
>XX' (
SubscriptionsXX) 6
{XX7 8
getXX9 <
;XX< =
setXX> A
;XXA B
}XXC D
=XXE F
newXXG J
ListXXK O
<XXO P
SubscriptionXXP \
>XX\ ]
(XX] ^
)XX^ _
;XX_ `
publicYY 
ICollectionYY 
<YY 
PrepaidLoadYY &
>YY& '
PrepaidLoadsYY( 4
{YY5 6
getYY7 :
;YY: ;
setYY< ?
;YY? @
}YYA B
=YYC D
newYYE H
ListYYI M
<YYM N
PrepaidLoadYYN Y
>YYY Z
(YYZ [
)YY[ \
;YY\ ]
}ZZ 
public\\ 

class\\ 
SubscriptionPlan\\ !
{]] 
[^^ 	
Key^^	 
]^^ 
public__ 
int__ 
PlanID__ 
{__ 
get__ 
;__  
set__! $
;__$ %
}__& '
public`` 
string`` 
PlanName`` 
{``  
get``! $
;``$ %
set``& )
;``) *
}``+ ,
=``- .
string``/ 5
.``5 6
Empty``6 ;
;``; <
publicaa 
decimalaa 
?aa 
	SpeedMbpsaa !
{aa" #
getaa$ '
;aa' (
setaa) ,
;aa, -
}aa. /
publicbb 
decimalbb 
?bb 
Pricebb 
{bb 
getbb  #
;bb# $
setbb% (
;bb( )
}bb* +
publiccc 
ICollectioncc 
<cc 
Subscriptioncc '
>cc' (
Subscriptionscc) 6
{cc7 8
getcc9 <
;cc< =
setcc> A
;ccA B
}ccC D
=ccE F
newccG J
ListccK O
<ccO P
SubscriptionccP \
>cc\ ]
(cc] ^
)cc^ _
;cc_ `
}dd 
publicff 

classff 
Subscriptionff 
{gg 
[hh 	
Keyhh	 
]hh 
publicii 
intii 
SubscriptionIDii !
{ii" #
getii$ '
;ii' (
setii) ,
;ii, -
}ii. /
publicjj 
intjj 
ServiceAccountIDjj #
{jj$ %
getjj& )
;jj) *
setjj+ .
;jj. /
}jj0 1
publickk 
intkk 
PlanIDkk 
{kk 
getkk 
;kk  
setkk! $
;kk$ %
}kk& '
publicll 
stringll 
UserIDll 
{ll 
getll "
;ll" #
setll$ '
;ll' (
}ll) *
=ll+ ,
stringll- 3
.ll3 4
Emptyll4 9
;ll9 :
publicmm 
stringmm 
?mm 

DeviceNamemm !
{mm" #
getmm$ '
;mm' (
setmm) ,
;mm, -
}mm. /
publicnn 
DateTimenn 
?nn 
	StartDatenn "
{nn# $
getnn% (
;nn( )
setnn* -
;nn- .
}nn/ 0
publicoo 
DateTimeoo 
?oo 
EndDateoo  
{oo! "
getoo# &
;oo& '
setoo( +
;oo+ ,
}oo- .
publicpp 
stringpp 
?pp 
Statuspp 
{pp 
getpp  #
;pp# $
setpp% (
;pp( )
}pp* +
[rr 	

ForeignKeyrr	 
(rr 
$strrr &
)rr& '
]rr' (
publicss 
ServiceAccountss 
ServiceAccountss ,
{ss- .
getss/ 2
;ss2 3
setss4 7
;ss7 8
}ss9 :
=ss; <
nullss= A
!ssA B
;ssB C
[tt 	

ForeignKeytt	 
(tt 
$strtt 
)tt 
]tt 
publicuu 
SubscriptionPlanuu 
Planuu  $
{uu% &
getuu' *
;uu* +
setuu, /
;uu/ 0
}uu1 2
=uu3 4
nulluu5 9
!uu9 :
;uu: ;
[vv 	

ForeignKeyvv	 
(vv 
$strvv 
)vv 
]vv 
publicww 
ApplicationUserww 
Userww #
{ww$ %
getww& )
;ww) *
setww+ .
;ww. /
}ww0 1
=ww2 3
nullww4 8
!ww8 9
;ww9 :
publicxx 
ICollectionxx 
<xx 
Invoicexx "
>xx" #
Invoicesxx$ ,
{xx- .
getxx/ 2
;xx2 3
setxx4 7
;xx7 8
}xx9 :
=xx; <
newxx= @
ListxxA E
<xxE F
InvoicexxF M
>xxM N
(xxN O
)xxO P
;xxP Q
}yy 
public{{ 

class{{ 
PrepaidLoad{{ 
{|| 
[}} 	
Key}}	 
]}} 
public~~ 
int~~ 
PrepaidLoadID~~  
{~~! "
get~~# &
;~~& '
set~~( +
;~~+ ,
}~~- .
public 
int 
ServiceAccountID #
{$ %
get& )
;) *
set+ .
;. /
}0 1
public
ÄÄ 
string
ÄÄ 
?
ÄÄ 
PhoneNumber
ÄÄ "
{
ÄÄ# $
get
ÄÄ% (
;
ÄÄ( )
set
ÄÄ* -
;
ÄÄ- .
}
ÄÄ/ 0
public
ÅÅ 
decimal
ÅÅ 

LoadAmount
ÅÅ !
{
ÅÅ" #
get
ÅÅ$ '
;
ÅÅ' (
set
ÅÅ) ,
;
ÅÅ, -
}
ÅÅ. /
public
ÇÇ 
decimal
ÇÇ 
?
ÇÇ 
RemainingBalance
ÇÇ (
{
ÇÇ) *
get
ÇÇ+ .
;
ÇÇ. /
set
ÇÇ0 3
;
ÇÇ3 4
}
ÇÇ5 6
public
ÉÉ 
DateTime
ÉÉ 
?
ÉÉ 
LastReloadBalance
ÉÉ *
{
ÉÉ+ ,
get
ÉÉ- 0
;
ÉÉ0 1
set
ÉÉ2 5
;
ÉÉ5 6
}
ÉÉ7 8
[
ÖÖ 	

ForeignKey
ÖÖ	 
(
ÖÖ 
$str
ÖÖ &
)
ÖÖ& '
]
ÖÖ' (
public
ÜÜ 
ServiceAccount
ÜÜ 
ServiceAccount
ÜÜ ,
{
ÜÜ- .
get
ÜÜ/ 2
;
ÜÜ2 3
set
ÜÜ4 7
;
ÜÜ7 8
}
ÜÜ9 :
=
ÜÜ; <
null
ÜÜ= A
!
ÜÜA B
;
ÜÜB C
}
áá 
public
ââ 

class
ââ 
PrepaidPromo
ââ 
{
ää 
[
ãã 	
Key
ãã	 
]
ãã 
public
åå 
int
åå 
PrepaidPromoID
åå !
{
åå" #
get
åå$ '
;
åå' (
set
åå) ,
;
åå, -
}
åå. /
public
çç 
int
çç 
PrepaidLoadID
çç  
{
çç! "
get
çç# &
;
çç& '
set
çç( +
;
çç+ ,
}
çç- .
public
éé 
string
éé 
UserID
éé 
{
éé 
get
éé "
;
éé" #
set
éé$ '
;
éé' (
}
éé) *
=
éé+ ,
string
éé- 3
.
éé3 4
Empty
éé4 9
;
éé9 :
public
èè 
string
èè 

PromoTitle
èè  
{
èè! "
get
èè# &
;
èè& '
set
èè( +
;
èè+ ,
}
èè- .
=
èè/ 0
string
èè1 7
.
èè7 8
Empty
èè8 =
;
èè= >
public
êê 
decimal
êê 
TotalDataMB
êê "
{
êê# $
get
êê% (
;
êê( )
set
êê* -
;
êê- .
}
êê/ 0
public
ëë 
decimal
ëë 
RemainingDataMB
ëë &
{
ëë' (
get
ëë) ,
;
ëë, -
set
ëë. 1
;
ëë1 2
}
ëë3 4
public
íí 
int
íí 
ValidityDays
íí 
{
íí  !
get
íí" %
;
íí% &
set
íí' *
;
íí* +
}
íí, -
public
ìì 
DateTime
ìì 
ActivatedAt
ìì #
{
ìì$ %
get
ìì& )
;
ìì) *
set
ìì+ .
;
ìì. /
}
ìì0 1
=
ìì2 3
DateTime
ìì4 <
.
ìì< =
UtcNow
ìì= C
;
ììC D
public
îî 
DateTime
îî 
	ExpiresAt
îî !
{
îî" #
get
îî$ '
;
îî' (
set
îî) ,
;
îî, -
}
îî. /
public
ïï 
string
ïï 
Status
ïï 
{
ïï 
get
ïï "
;
ïï" #
set
ïï$ '
;
ïï' (
}
ïï) *
=
ïï+ ,
$str
ïï- 5
;
ïï5 6
[
óó 	

ForeignKey
óó	 
(
óó 
$str
óó #
)
óó# $
]
óó$ %
public
òò 
PrepaidLoad
òò 
PrepaidLoad
òò &
{
òò' (
get
òò) ,
;
òò, -
set
òò. 1
;
òò1 2
}
òò3 4
=
òò5 6
null
òò7 ;
!
òò; <
;
òò< =
[
ôô 	

ForeignKey
ôô	 
(
ôô 
$str
ôô 
)
ôô 
]
ôô 
public
öö 
ApplicationUser
öö 
User
öö #
{
öö$ %
get
öö& )
;
öö) *
set
öö+ .
;
öö. /
}
öö0 1
=
öö2 3
null
öö4 8
!
öö8 9
;
öö9 :
}
õõ 
public
ùù 

class
ùù 

PromoOffer
ùù 
{
ûû 
[
üü 	
Key
üü	 
]
üü 
public
†† 
int
†† 
PromoOfferID
†† 
{
††  !
get
††" %
;
††% &
set
††' *
;
††* +
}
††, -
public
°° 
string
°° 
Title
°° 
{
°° 
get
°° !
;
°°! "
set
°°# &
;
°°& '
}
°°( )
=
°°* +
string
°°, 2
.
°°2 3
Empty
°°3 8
;
°°8 9
public
¢¢ 
string
¢¢ 
Description
¢¢ !
{
¢¢" #
get
¢¢$ '
;
¢¢' (
set
¢¢) ,
;
¢¢, -
}
¢¢. /
=
¢¢0 1
string
¢¢2 8
.
¢¢8 9
Empty
¢¢9 >
;
¢¢> ?
public
££ 
decimal
££ 
Price
££ 
{
££ 
get
££ "
;
££" #
set
££$ '
;
££' (
}
££) *
public
§§ 
string
§§ 
Data
§§ 
{
§§ 
get
§§  
;
§§  !
set
§§" %
;
§§% &
}
§§' (
=
§§) *
string
§§+ 1
.
§§1 2
Empty
§§2 7
;
§§7 8
public
•• 
string
•• 
Validity
•• 
{
••  
get
••! $
;
••$ %
set
••& )
;
••) *
}
••+ ,
=
••- .
string
••/ 5
.
••5 6
Empty
••6 ;
;
••; <
public
¶¶ 
string
¶¶ 
?
¶¶ 
Badge
¶¶ 
{
¶¶ 
get
¶¶ "
;
¶¶" #
set
¶¶$ '
;
¶¶' (
}
¶¶) *
public
ßß 
string
ßß 
Color
ßß 
{
ßß 
get
ßß !
;
ßß! "
set
ßß# &
;
ßß& '
}
ßß( )
=
ßß* +
$str
ßß, G
;
ßßG H
public
®® 
bool
®® 
IsActive
®® 
{
®® 
get
®® "
;
®®" #
set
®®$ '
;
®®' (
}
®®) *
=
®®+ ,
true
®®- 1
;
®®1 2
public
©© 
DateTime
©© 
	CreatedAt
©© !
{
©©" #
get
©©$ '
;
©©' (
set
©©) ,
;
©©, -
}
©©. /
=
©©0 1
DateTime
©©2 :
.
©©: ;
UtcNow
©©; A
;
©©A B
}
™™ 
public
¨¨ 

class
¨¨ 
Invoice
¨¨ 
{
≠≠ 
[
ÆÆ 	
Key
ÆÆ	 
]
ÆÆ 
public
ØØ 
int
ØØ 
	InvoiceID
ØØ 
{
ØØ 
get
ØØ "
;
ØØ" #
set
ØØ$ '
;
ØØ' (
}
ØØ) *
public
∞∞ 
int
∞∞ 
?
∞∞ 
SubscriptionID
∞∞ "
{
∞∞# $
get
∞∞% (
;
∞∞( )
set
∞∞* -
;
∞∞- .
}
∞∞/ 0
public
±± 
int
±± 
?
±± 
PrepaidLoadID
±± !
{
±±" #
get
±±$ '
;
±±' (
set
±±) ,
;
±±, -
}
±±. /
public
≤≤ 
string
≤≤ 
UserID
≤≤ 
{
≤≤ 
get
≤≤ "
;
≤≤" #
set
≤≤$ '
;
≤≤' (
}
≤≤) *
=
≤≤+ ,
string
≤≤- 3
.
≤≤3 4
Empty
≤≤4 9
;
≤≤9 :
public
≥≥ 
decimal
≥≥ 
Amount
≥≥ 
{
≥≥ 
get
≥≥  #
;
≥≥# $
set
≥≥% (
;
≥≥( )
}
≥≥* +
public
¥¥ 
DateTime
¥¥ 
?
¥¥ 
DueDate
¥¥  
{
¥¥! "
get
¥¥# &
;
¥¥& '
set
¥¥( +
;
¥¥+ ,
}
¥¥- .
public
µµ 
string
µµ 
?
µµ 
Status
µµ 
{
µµ 
get
µµ  #
;
µµ# $
set
µµ% (
;
µµ( )
}
µµ* +
public
∂∂ 
DateTime
∂∂ 
	CreatedAt
∂∂ !
{
∂∂" #
get
∂∂$ '
;
∂∂' (
set
∂∂) ,
;
∂∂, -
}
∂∂. /
=
∂∂0 1
DateTime
∂∂2 :
.
∂∂: ;
UtcNow
∂∂; A
;
∂∂A B
[
∏∏ 	

ForeignKey
∏∏	 
(
∏∏ 
$str
∏∏ $
)
∏∏$ %
]
∏∏% &
public
ππ 
Subscription
ππ 
?
ππ 
Subscription
ππ )
{
ππ* +
get
ππ, /
;
ππ/ 0
set
ππ1 4
;
ππ4 5
}
ππ6 7
[
∫∫ 	

ForeignKey
∫∫	 
(
∫∫ 
$str
∫∫ #
)
∫∫# $
]
∫∫$ %
public
ªª 
PrepaidLoad
ªª 
?
ªª 
PrepaidLoad
ªª '
{
ªª( )
get
ªª* -
;
ªª- .
set
ªª/ 2
;
ªª2 3
}
ªª4 5
[
ºº 	

ForeignKey
ºº	 
(
ºº 
$str
ºº 
)
ºº 
]
ºº 
public
ΩΩ 
ApplicationUser
ΩΩ 
User
ΩΩ #
{
ΩΩ$ %
get
ΩΩ& )
;
ΩΩ) *
set
ΩΩ+ .
;
ΩΩ. /
}
ΩΩ0 1
=
ΩΩ2 3
null
ΩΩ4 8
!
ΩΩ8 9
;
ΩΩ9 :
public
ææ 
ICollection
ææ 
<
ææ 
Payment
ææ "
>
ææ" #
Payments
ææ$ ,
{
ææ- .
get
ææ/ 2
;
ææ2 3
set
ææ4 7
;
ææ7 8
}
ææ9 :
=
ææ; <
new
ææ= @
List
ææA E
<
ææE F
Payment
ææF M
>
ææM N
(
ææN O
)
ææO P
;
ææP Q
}
øø 
public
¡¡ 

class
¡¡ 
Payment
¡¡ 
{
¬¬ 
[
√√ 	
Key
√√	 
]
√√ 
public
ƒƒ 
int
ƒƒ 
	PaymentID
ƒƒ 
{
ƒƒ 
get
ƒƒ "
;
ƒƒ" #
set
ƒƒ$ '
;
ƒƒ' (
}
ƒƒ) *
public
≈≈ 
int
≈≈ 
?
≈≈ 
	InvoiceID
≈≈ 
{
≈≈ 
get
≈≈  #
;
≈≈# $
set
≈≈% (
;
≈≈( )
}
≈≈* +
public
∆∆ 
string
∆∆ 
UserID
∆∆ 
{
∆∆ 
get
∆∆ "
;
∆∆" #
set
∆∆$ '
;
∆∆' (
}
∆∆) *
=
∆∆+ ,
string
∆∆- 3
.
∆∆3 4
Empty
∆∆4 9
;
∆∆9 :
public
«« 
decimal
«« 

AmountPaid
«« !
{
««" #
get
««$ '
;
««' (
set
««) ,
;
««, -
}
««. /
public
»» 
string
»» 
?
»» 
PaymentMethod
»» $
{
»»% &
get
»»' *
;
»»* +
set
»», /
;
»»/ 0
}
»»1 2
public
…… 
string
…… 
?
…… 
ReferenceNum
…… #
{
……$ %
get
……& )
;
……) *
set
……+ .
;
……. /
}
……0 1
public
   
DateTime
   
PaymentDate
   #
{
  $ %
get
  & )
;
  ) *
set
  + .
;
  . /
}
  0 1
=
  2 3
DateTime
  4 <
.
  < =
UtcNow
  = C
;
  C D
public
ÀÀ 
string
ÀÀ 
?
ÀÀ 
Status
ÀÀ 
{
ÀÀ 
get
ÀÀ  #
;
ÀÀ# $
set
ÀÀ% (
;
ÀÀ( )
}
ÀÀ* +
public
ÃÃ 
bool
ÃÃ 

IsArchived
ÃÃ 
{
ÃÃ  
get
ÃÃ! $
;
ÃÃ$ %
set
ÃÃ& )
;
ÃÃ) *
}
ÃÃ+ ,
=
ÃÃ- .
false
ÃÃ/ 4
;
ÃÃ4 5
[
ŒŒ 	

ForeignKey
ŒŒ	 
(
ŒŒ 
$str
ŒŒ 
)
ŒŒ  
]
ŒŒ  !
public
œœ 
Invoice
œœ 
?
œœ 
Invoice
œœ 
{
œœ  !
get
œœ" %
;
œœ% &
set
œœ' *
;
œœ* +
}
œœ, -
[
–– 	

ForeignKey
––	 
(
–– 
$str
–– 
)
–– 
]
–– 
public
—— 
ApplicationUser
—— 
User
—— #
{
——$ %
get
——& )
;
——) *
set
——+ .
;
——. /
}
——0 1
=
——2 3
null
——4 8
!
——8 9
;
——9 :
}
““ 
public
‘‘ 

class
‘‘ 
Addon
‘‘ 
{
’’ 
[
÷÷ 	
Key
÷÷	 
]
÷÷ 
public
◊◊ 
int
◊◊ 
AddonID
◊◊ 
{
◊◊ 
get
◊◊  
;
◊◊  !
set
◊◊" %
;
◊◊% &
}
◊◊' (
public
ÿÿ 
string
ÿÿ 
Name
ÿÿ 
{
ÿÿ 
get
ÿÿ  
;
ÿÿ  !
set
ÿÿ" %
;
ÿÿ% &
}
ÿÿ' (
=
ÿÿ) *
string
ÿÿ+ 1
.
ÿÿ1 2
Empty
ÿÿ2 7
;
ÿÿ7 8
public
ŸŸ 
string
ŸŸ 
?
ŸŸ 
Description
ŸŸ "
{
ŸŸ# $
get
ŸŸ% (
;
ŸŸ( )
set
ŸŸ* -
;
ŸŸ- .
}
ŸŸ/ 0
public
⁄⁄ 
decimal
⁄⁄ 
Price
⁄⁄ 
{
⁄⁄ 
get
⁄⁄ "
;
⁄⁄" #
set
⁄⁄$ '
;
⁄⁄' (
}
⁄⁄) *
public
€€ 
string
€€ 
BillingType
€€ !
{
€€" #
get
€€$ '
;
€€' (
set
€€) ,
;
€€, -
}
€€. /
=
€€0 1
string
€€2 8
.
€€8 9
Empty
€€9 >
;
€€> ?
public
‹‹ 
string
‹‹ 
?
‹‹ 
Icon
‹‹ 
{
‹‹ 
get
‹‹ !
;
‹‹! "
set
‹‹# &
;
‹‹& '
}
‹‹( )
public
›› 
string
›› 
?
›› 
Features
›› 
{
››  !
get
››" %
;
››% &
set
››' *
;
››* +
}
››, -
public
ﬁﬁ 
ICollection
ﬁﬁ 
<
ﬁﬁ 
	UserAddon
ﬁﬁ $
>
ﬁﬁ$ %

UserAddons
ﬁﬁ& 0
{
ﬁﬁ1 2
get
ﬁﬁ3 6
;
ﬁﬁ6 7
set
ﬁﬁ8 ;
;
ﬁﬁ; <
}
ﬁﬁ= >
=
ﬁﬁ? @
new
ﬁﬁA D
List
ﬁﬁE I
<
ﬁﬁI J
	UserAddon
ﬁﬁJ S
>
ﬁﬁS T
(
ﬁﬁT U
)
ﬁﬁU V
;
ﬁﬁV W
}
ﬂﬂ 
public
·· 

class
·· 
	UserAddon
·· 
{
‚‚ 
[
„„ 	
Key
„„	 
]
„„ 
public
‰‰ 
int
‰‰ 
UserAddonID
‰‰ 
{
‰‰  
get
‰‰! $
;
‰‰$ %
set
‰‰& )
;
‰‰) *
}
‰‰+ ,
public
ÂÂ 
string
ÂÂ 
UserID
ÂÂ 
{
ÂÂ 
get
ÂÂ "
;
ÂÂ" #
set
ÂÂ$ '
;
ÂÂ' (
}
ÂÂ) *
=
ÂÂ+ ,
string
ÂÂ- 3
.
ÂÂ3 4
Empty
ÂÂ4 9
;
ÂÂ9 :
public
ÊÊ 
int
ÊÊ 
AddonID
ÊÊ 
{
ÊÊ 
get
ÊÊ  
;
ÊÊ  !
set
ÊÊ" %
;
ÊÊ% &
}
ÊÊ' (
public
ÁÁ 
DateTime
ÁÁ 
ActivatedAt
ÁÁ #
{
ÁÁ$ %
get
ÁÁ& )
;
ÁÁ) *
set
ÁÁ+ .
;
ÁÁ. /
}
ÁÁ0 1
=
ÁÁ2 3
DateTime
ÁÁ4 <
.
ÁÁ< =
UtcNow
ÁÁ= C
;
ÁÁC D
public
ËË 
DateTime
ËË 
?
ËË 
NextBillingDate
ËË (
{
ËË) *
get
ËË+ .
;
ËË. /
set
ËË0 3
;
ËË3 4
}
ËË5 6
public
ÈÈ 
string
ÈÈ 
Status
ÈÈ 
{
ÈÈ 
get
ÈÈ "
;
ÈÈ" #
set
ÈÈ$ '
;
ÈÈ' (
}
ÈÈ) *
=
ÈÈ+ ,
$str
ÈÈ- 5
;
ÈÈ5 6
[
ÎÎ 	

ForeignKey
ÎÎ	 
(
ÎÎ 
$str
ÎÎ 
)
ÎÎ 
]
ÎÎ 
public
ÏÏ 
ApplicationUser
ÏÏ 
User
ÏÏ #
{
ÏÏ$ %
get
ÏÏ& )
;
ÏÏ) *
set
ÏÏ+ .
;
ÏÏ. /
}
ÏÏ0 1
=
ÏÏ2 3
null
ÏÏ4 8
!
ÏÏ8 9
;
ÏÏ9 :
[
ÌÌ 	

ForeignKey
ÌÌ	 
(
ÌÌ 
$str
ÌÌ 
)
ÌÌ 
]
ÌÌ 
public
ÓÓ 
Addon
ÓÓ 
Addon
ÓÓ 
{
ÓÓ 
get
ÓÓ  
;
ÓÓ  !
set
ÓÓ" %
;
ÓÓ% &
}
ÓÓ' (
=
ÓÓ) *
null
ÓÓ+ /
!
ÓÓ/ 0
;
ÓÓ0 1
}
ÔÔ 
public
ÒÒ 

class
ÒÒ 
ActivityLog
ÒÒ 
{
ÚÚ 
[
ÛÛ 	
Key
ÛÛ	 
]
ÛÛ 
public
ÙÙ 
int
ÙÙ 
LogID
ÙÙ 
{
ÙÙ 
get
ÙÙ 
;
ÙÙ 
set
ÙÙ  #
;
ÙÙ# $
}
ÙÙ% &
public
ıı 
string
ıı 
UserID
ıı 
{
ıı 
get
ıı "
;
ıı" #
set
ıı$ '
;
ıı' (
}
ıı) *
=
ıı+ ,
string
ıı- 3
.
ıı3 4
Empty
ıı4 9
;
ıı9 :
public
ˆˆ 
string
ˆˆ 
Action
ˆˆ 
{
ˆˆ 
get
ˆˆ "
;
ˆˆ" #
set
ˆˆ$ '
;
ˆˆ' (
}
ˆˆ) *
=
ˆˆ+ ,
string
ˆˆ- 3
.
ˆˆ3 4
Empty
ˆˆ4 9
;
ˆˆ9 :
public
˜˜ 
string
˜˜ 
Type
˜˜ 
{
˜˜ 
get
˜˜  
;
˜˜  !
set
˜˜" %
;
˜˜% &
}
˜˜' (
=
˜˜) *
string
˜˜+ 1
.
˜˜1 2
Empty
˜˜2 7
;
˜˜7 8
public
¯¯ 
string
¯¯ 
?
¯¯ 
	IPAddress
¯¯  
{
¯¯! "
get
¯¯# &
;
¯¯& '
set
¯¯( +
;
¯¯+ ,
}
¯¯- .
public
˘˘ 
DateTime
˘˘ 
	Timestamp
˘˘ !
{
˘˘" #
get
˘˘$ '
;
˘˘' (
set
˘˘) ,
;
˘˘, -
}
˘˘. /
=
˘˘0 1
DateTime
˘˘2 :
.
˘˘: ;
UtcNow
˘˘; A
;
˘˘A B
[
˚˚ 	

ForeignKey
˚˚	 
(
˚˚ 
$str
˚˚ 
)
˚˚ 
]
˚˚ 
public
¸¸ 
ApplicationUser
¸¸ 
User
¸¸ #
{
¸¸$ %
get
¸¸& )
;
¸¸) *
set
¸¸+ .
;
¸¸. /
}
¸¸0 1
=
¸¸2 3
null
¸¸4 8
!
¸¸8 9
;
¸¸9 :
}
˝˝ 
public
ˇˇ 

class
ˇˇ 
FAQ
ˇˇ 
{
ÄÄ 
[
ÅÅ 	
Key
ÅÅ	 
]
ÅÅ 
public
ÇÇ 
int
ÇÇ 
FAQID
ÇÇ 
{
ÇÇ 
get
ÇÇ 
;
ÇÇ 
set
ÇÇ  #
;
ÇÇ# $
}
ÇÇ% &
public
ÉÉ 
string
ÉÉ 
Question
ÉÉ 
{
ÉÉ  
get
ÉÉ! $
;
ÉÉ$ %
set
ÉÉ& )
;
ÉÉ) *
}
ÉÉ+ ,
=
ÉÉ- .
string
ÉÉ/ 5
.
ÉÉ5 6
Empty
ÉÉ6 ;
;
ÉÉ; <
public
ÑÑ 
string
ÑÑ 
Answer
ÑÑ 
{
ÑÑ 
get
ÑÑ "
;
ÑÑ" #
set
ÑÑ$ '
;
ÑÑ' (
}
ÑÑ) *
=
ÑÑ+ ,
string
ÑÑ- 3
.
ÑÑ3 4
Empty
ÑÑ4 9
;
ÑÑ9 :
public
ÖÖ 
string
ÖÖ 
Category
ÖÖ 
{
ÖÖ  
get
ÖÖ! $
;
ÖÖ$ %
set
ÖÖ& )
;
ÖÖ) *
}
ÖÖ+ ,
=
ÖÖ- .
string
ÖÖ/ 5
.
ÖÖ5 6
Empty
ÖÖ6 ;
;
ÖÖ; <
public
ÜÜ 
string
ÜÜ 
Status
ÜÜ 
{
ÜÜ 
get
ÜÜ "
;
ÜÜ" #
set
ÜÜ$ '
;
ÜÜ' (
}
ÜÜ) *
=
ÜÜ+ ,
$str
ÜÜ- 4
;
ÜÜ4 5
public
áá 
int
áá 
Views
áá 
{
áá 
get
áá 
;
áá 
set
áá  #
;
áá# $
}
áá% &
=
áá' (
$num
áá) *
;
áá* +
public
àà 
DateTime
àà 
	CreatedAt
àà !
{
àà" #
get
àà$ '
;
àà' (
set
àà) ,
;
àà, -
}
àà. /
=
àà0 1
DateTime
àà2 :
.
àà: ;
UtcNow
àà; A
;
ààA B
public
ââ 
DateTime
ââ 
?
ââ 
	UpdatedAt
ââ "
{
ââ# $
get
ââ% (
;
ââ( )
set
ââ* -
;
ââ- .
}
ââ/ 0
}
ää 
public
åå 

class
åå 
LoginHistory
åå 
{
çç 
[
éé 	
Key
éé	 
]
éé 
public
èè 
int
èè 
LoginHistoryID
èè !
{
èè" #
get
èè$ '
;
èè' (
set
èè) ,
;
èè, -
}
èè. /
public
êê 
string
êê 
UserID
êê 
{
êê 
get
êê "
;
êê" #
set
êê$ '
;
êê' (
}
êê) *
=
êê+ ,
string
êê- 3
.
êê3 4
Empty
êê4 9
;
êê9 :
public
ëë 
string
ëë 
Device
ëë 
{
ëë 
get
ëë "
;
ëë" #
set
ëë$ '
;
ëë' (
}
ëë) *
=
ëë+ ,
string
ëë- 3
.
ëë3 4
Empty
ëë4 9
;
ëë9 :
public
íí 
string
íí 
?
íí 
Location
íí 
{
íí  !
get
íí" %
;
íí% &
set
íí' *
;
íí* +
}
íí, -
public
ìì 
string
ìì 
?
ìì 
	IPAddress
ìì  
{
ìì! "
get
ìì# &
;
ìì& '
set
ìì( +
;
ìì+ ,
}
ìì- .
public
îî 
DateTime
îî 
	LoginTime
îî !
{
îî" #
get
îî$ '
;
îî' (
set
îî) ,
;
îî, -
}
îî. /
=
îî0 1
DateTime
îî2 :
.
îî: ;
UtcNow
îî; A
;
îîA B
[
ññ 	

ForeignKey
ññ	 
(
ññ 
$str
ññ 
)
ññ 
]
ññ 
public
óó 
ApplicationUser
óó 
User
óó #
{
óó$ %
get
óó& )
;
óó) *
set
óó+ .
;
óó. /
}
óó0 1
=
óó2 3
null
óó4 8
!
óó8 9
;
óó9 :
}
òò 
public
öö 

class
öö $
NotificationPreference
öö '
{
õõ 
[
úú 	
Key
úú	 
]
úú 
public
ùù 
int
ùù 
PreferenceID
ùù 
{
ùù  !
get
ùù" %
;
ùù% &
set
ùù' *
;
ùù* +
}
ùù, -
public
ûû 
string
ûû 
UserID
ûû 
{
ûû 
get
ûû "
;
ûû" #
set
ûû$ '
;
ûû' (
}
ûû) *
=
ûû+ ,
string
ûû- 3
.
ûû3 4
Empty
ûû4 9
;
ûû9 :
public
üü 
string
üü 
NotificationType
üü &
{
üü' (
get
üü) ,
;
üü, -
set
üü. 1
;
üü1 2
}
üü3 4
=
üü5 6
string
üü7 =
.
üü= >
Empty
üü> C
;
üüC D
public
†† 
bool
†† 
EmailEnabled
††  
{
††! "
get
††# &
;
††& '
set
††( +
;
††+ ,
}
††- .
=
††/ 0
true
††1 5
;
††5 6
public
°° 
DateTime
°° 
	CreatedAt
°° !
{
°°" #
get
°°$ '
;
°°' (
set
°°) ,
;
°°, -
}
°°. /
=
°°0 1
DateTime
°°2 :
.
°°: ;
UtcNow
°°; A
;
°°A B
public
¢¢ 
DateTime
¢¢ 
?
¢¢ 
	UpdatedAt
¢¢ "
{
¢¢# $
get
¢¢% (
;
¢¢( )
set
¢¢* -
;
¢¢- .
}
¢¢/ 0
[
§§ 	

ForeignKey
§§	 
(
§§ 
$str
§§ 
)
§§ 
]
§§ 
public
•• 
ApplicationUser
•• 
User
•• #
{
••$ %
get
••& )
;
••) *
set
••+ .
;
••. /
}
••0 1
=
••2 3
null
••4 8
!
••8 9
;
••9 :
}
¶¶ 
public
®® 

class
®® 
RolePermission
®® 
{
©© 
[
™™ 	
Key
™™	 
]
™™ 
public
´´ 
int
´´ 
RolePermissionID
´´ #
{
´´$ %
get
´´& )
;
´´) *
set
´´+ .
;
´´. /
}
´´0 1
public
¨¨ 
string
¨¨ 
RoleName
¨¨ 
{
¨¨  
get
¨¨! $
;
¨¨$ %
set
¨¨& )
;
¨¨) *
}
¨¨+ ,
=
¨¨- .
string
¨¨/ 5
.
¨¨5 6
Empty
¨¨6 ;
;
¨¨; <
public
≠≠ 
string
≠≠ 
PermissionName
≠≠ $
{
≠≠% &
get
≠≠' *
;
≠≠* +
set
≠≠, /
;
≠≠/ 0
}
≠≠1 2
=
≠≠3 4
string
≠≠5 ;
.
≠≠; <
Empty
≠≠< A
;
≠≠A B
public
ÆÆ 
DateTime
ÆÆ 
	CreatedAt
ÆÆ !
{
ÆÆ" #
get
ÆÆ$ '
;
ÆÆ' (
set
ÆÆ) ,
;
ÆÆ, -
}
ÆÆ. /
=
ÆÆ0 1
DateTime
ÆÆ2 :
.
ÆÆ: ;
UtcNow
ÆÆ; A
;
ÆÆA B
public
ØØ 
DateTime
ØØ 
?
ØØ 
	UpdatedAt
ØØ "
{
ØØ# $
get
ØØ% (
;
ØØ( )
set
ØØ* -
;
ØØ- .
}
ØØ/ 0
}
∞∞ 
public
≤≤ 

class
≤≤ 
SystemSettings
≤≤ 
{
≥≥ 
[
¥¥ 	
Key
¥¥	 
]
¥¥ 
public
µµ 
int
µµ 
	SettingID
µµ 
{
µµ 
get
µµ "
;
µµ" #
set
µµ$ '
;
µµ' (
}
µµ) *
public
∂∂ 
string
∂∂ 
SiteName
∂∂ 
{
∂∂  
get
∂∂! $
;
∂∂$ %
set
∂∂& )
;
∂∂) *
}
∂∂+ ,
=
∂∂- .
$str
∂∂/ ?
;
∂∂? @
public
∑∑ 
string
∑∑ 
	SiteEmail
∑∑ 
{
∑∑  !
get
∑∑" %
;
∑∑% &
set
∑∑' *
;
∑∑* +
}
∑∑, -
=
∑∑. /
string
∑∑0 6
.
∑∑6 7
Empty
∑∑7 <
;
∑∑< =
public
∏∏ 
bool
∏∏ 
MaintenanceMode
∏∏ #
{
∏∏$ %
get
∏∏& )
;
∏∏) *
set
∏∏+ .
;
∏∏. /
}
∏∏0 1
=
∏∏2 3
false
∏∏4 9
;
∏∏9 :
public
ππ 
int
ππ 
MaxLoginAttempts
ππ #
{
ππ$ %
get
ππ& )
;
ππ) *
set
ππ+ .
;
ππ. /
}
ππ0 1
=
ππ2 3
$num
ππ4 5
;
ππ5 6
public
∫∫ 
int
∫∫ 
SessionTimeout
∫∫ !
{
∫∫" #
get
∫∫$ '
;
∫∫' (
set
∫∫) ,
;
∫∫, -
}
∫∫. /
=
∫∫0 1
$num
∫∫2 4
;
∫∫4 5
public
ªª 
bool
ªª 
EnableTwoFactor
ªª #
{
ªª$ %
get
ªª& )
;
ªª) *
set
ªª+ .
;
ªª. /
}
ªª0 1
=
ªª2 3
true
ªª4 8
;
ªª8 9
public
ºº 
bool
ºº 
EnableAuditLogs
ºº #
{
ºº$ %
get
ºº& )
;
ºº) *
set
ºº+ .
;
ºº. /
}
ºº0 1
=
ºº2 3
true
ºº4 8
;
ºº8 9
public
ΩΩ 
string
ΩΩ 
NotificationEmail
ΩΩ '
{
ΩΩ( )
get
ΩΩ* -
;
ΩΩ- .
set
ΩΩ/ 2
;
ΩΩ2 3
}
ΩΩ4 5
=
ΩΩ6 7
string
ΩΩ8 >
.
ΩΩ> ?
Empty
ΩΩ? D
;
ΩΩD E
public
ææ 
bool
ææ 
EmailOnNewTickets
ææ %
{
ææ& '
get
ææ( +
;
ææ+ ,
set
ææ- 0
;
ææ0 1
}
ææ2 3
=
ææ4 5
true
ææ6 :
;
ææ: ;
public
øø 
bool
øø $
EmailOnPaymentReceived
øø *
{
øø+ ,
get
øø- 0
;
øø0 1
set
øø2 5
;
øø5 6
}
øø7 8
=
øø9 :
true
øø; ?
;
øø? @
public
¿¿ 
bool
¿¿ !
EmailOnSystemErrors
¿¿ '
{
¿¿( )
get
¿¿* -
;
¿¿- .
set
¿¿/ 2
;
¿¿2 3
}
¿¿4 5
=
¿¿6 7
true
¿¿8 <
;
¿¿< =
public
¡¡ 
bool
¡¡ #
EmailOnSecurityAlerts
¡¡ )
{
¡¡* +
get
¡¡, /
;
¡¡/ 0
set
¡¡1 4
;
¡¡4 5
}
¡¡6 7
=
¡¡8 9
true
¡¡: >
;
¡¡> ?
public
¬¬ 
DateTime
¬¬ 
	CreatedAt
¬¬ !
{
¬¬" #
get
¬¬$ '
;
¬¬' (
set
¬¬) ,
;
¬¬, -
}
¬¬. /
=
¬¬0 1
DateTime
¬¬2 :
.
¬¬: ;
UtcNow
¬¬; A
;
¬¬A B
public
√√ 
DateTime
√√ 
	UpdatedAt
√√ !
{
√√" #
get
√√$ '
;
√√' (
set
√√) ,
;
√√, -
}
√√. /
=
√√0 1
DateTime
√√2 :
.
√√: ;
UtcNow
√√; A
;
√√A B
}
ƒƒ 
public
∆∆ 

class
∆∆ 
LoginAttempt
∆∆ 
{
«« 
[
»» 	
Key
»»	 
]
»» 
public
…… 
int
…… 
LoginAttemptID
…… !
{
……" #
get
……$ '
;
……' (
set
……) ,
;
……, -
}
……. /
public
   
string
   
UserID
   
{
   
get
   "
;
  " #
set
  $ '
;
  ' (
}
  ) *
=
  + ,
string
  - 3
.
  3 4
Empty
  4 9
;
  9 :
public
ÀÀ 
int
ÀÀ 
FailedAttempts
ÀÀ !
{
ÀÀ" #
get
ÀÀ$ '
;
ÀÀ' (
set
ÀÀ) ,
;
ÀÀ, -
}
ÀÀ. /
=
ÀÀ0 1
$num
ÀÀ2 3
;
ÀÀ3 4
public
ÃÃ 
DateTime
ÃÃ 
?
ÃÃ 
LockedUntil
ÃÃ $
{
ÃÃ% &
get
ÃÃ' *
;
ÃÃ* +
set
ÃÃ, /
;
ÃÃ/ 0
}
ÃÃ1 2
public
ÕÕ 
string
ÕÕ 
?
ÕÕ 

LockReason
ÕÕ !
{
ÕÕ" #
get
ÕÕ$ '
;
ÕÕ' (
set
ÕÕ) ,
;
ÕÕ, -
}
ÕÕ. /
public
ŒŒ 
DateTime
ŒŒ 
LastAttemptAt
ŒŒ %
{
ŒŒ& '
get
ŒŒ( +
;
ŒŒ+ ,
set
ŒŒ- 0
;
ŒŒ0 1
}
ŒŒ2 3
=
ŒŒ4 5
DateTime
ŒŒ6 >
.
ŒŒ> ?
UtcNow
ŒŒ? E
;
ŒŒE F
public
œœ 
DateTime
œœ 
	CreatedAt
œœ !
{
œœ" #
get
œœ$ '
;
œœ' (
set
œœ) ,
;
œœ, -
}
œœ. /
=
œœ0 1
DateTime
œœ2 :
.
œœ: ;
UtcNow
œœ; A
;
œœA B
[
—— 	

ForeignKey
——	 
(
—— 
$str
—— 
)
—— 
]
—— 
public
““ 
ApplicationUser
““ 
User
““ #
{
““$ %
get
““& )
;
““) *
set
““+ .
;
““. /
}
““0 1
=
““2 3
null
““4 8
!
““8 9
;
““9 :
}
”” 
}‘‘ •=
LE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\AuthModels.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
RegisterRequest  
{ 
[ 	
Required	 
] 
[ 	
EmailAddress	 
] 
public		 
string		 
Email		 
{		 
get		 !
;		! "
set		# &
;		& '
}		( )
=		* +
string		, 2
.		2 3
Empty		3 8
;		8 9
[

 	
Required

	 
]

 
[ 	
	MinLength	 
( 
$num 
) 
] 
public 
string 
Password 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
[ 	
Required	 
] 
public 
string 
	FirstName 
{  !
get" %
;% &
set' *
;* +
}, -
=. /
string0 6
.6 7
Empty7 <
;< =
[ 	
Required	 
] 
public 
string 
LastName 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
public 
DateTime 
? 
Birthday !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
string 
? 
Address 
{  
get! $
;$ %
set& )
;) *
}+ ,
[ 	
Required	 
] 
public 
string 
CaptchaToken "
{# $
get% (
;( )
set* -
;- .
}/ 0
=1 2
string3 9
.9 :
Empty: ?
;? @
} 
public 

class 
VerifyEmailRequest #
{ 
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
public 
string 
Code 
{ 
get  
;  !
set" %
;% &
}' (
=) *
string+ 1
.1 2
Empty2 7
;7 8
} 
public 

class $
SelectServiceTypeRequest )
{ 
public 
string 
ServiceType !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
}   
public"" 

class"" !
RegisterDeviceRequest"" &
{## 
public$$ 
string$$ 

MACAddress$$  
{$$! "
get$$# &
;$$& '
set$$( +
;$$+ ,
}$$- .
=$$/ 0
string$$1 7
.$$7 8
Empty$$8 =
;$$= >
public%% 
int%% 
?%% 
PlanID%% 
{%% 
get%%  
;%%  !
set%%" %
;%%% &
}%%' (
public&& 
string&& 
?&& 
ServiceType&& "
{&&# $
get&&% (
;&&( )
set&&* -
;&&- .
}&&/ 0
public'' 
string'' 
?'' 
PhoneNumber'' "
{''# $
get''% (
;''( )
set''* -
;''- .
}''/ 0
}(( 
public** 

class** 
LoginRequest** 
{++ 
[,, 	
Required,,	 
],, 
[-- 	
EmailAddress--	 
]-- 
public.. 
string.. 
Email.. 
{.. 
get.. !
;..! "
set..# &
;..& '
}..( )
=..* +
string.., 2
...2 3
Empty..3 8
;..8 9
[// 	
Required//	 
]// 
public00 
string00 
Password00 
{00  
get00! $
;00$ %
set00& )
;00) *
}00+ ,
=00- .
string00/ 5
.005 6
Empty006 ;
;00; <
[11 	
Required11	 
]11 
public22 
string22 
CaptchaToken22 "
{22# $
get22% (
;22( )
set22* -
;22- .
}22/ 0
=221 2
string223 9
.229 :
Empty22: ?
;22? @
}33 
public55 

class55 
GoogleLoginRequest55 #
{66 
public77 
string77 
Email77 
{77 
get77 !
;77! "
set77# &
;77& '
}77( )
=77* +
string77, 2
.772 3
Empty773 8
;778 9
public88 
string88 
	FirstName88 
{88  !
get88" %
;88% &
set88' *
;88* +
}88, -
=88. /
string880 6
.886 7
Empty887 <
;88< =
public99 
string99 
LastName99 
{99  
get99! $
;99$ %
set99& )
;99) *
}99+ ,
=99- .
string99/ 5
.995 6
Empty996 ;
;99; <
public:: 
string:: 
GoogleToken:: !
{::" #
get::$ '
;::' (
set::) ,
;::, -
}::. /
=::0 1
string::2 8
.::8 9
Empty::9 >
;::> ?
};; 
public== 

class==  
ResetPasswordRequest== %
{>> 
public?? 
string?? 
Email?? 
{?? 
get?? !
;??! "
set??# &
;??& '
}??( )
=??* +
string??, 2
.??2 3
Empty??3 8
;??8 9
public@@ 
string@@ 
Code@@ 
{@@ 
get@@  
;@@  !
set@@" %
;@@% &
}@@' (
=@@) *
string@@+ 1
.@@1 2
Empty@@2 7
;@@7 8
publicAA 
stringAA 
NewPasswordAA !
{AA" #
getAA$ '
;AA' (
setAA) ,
;AA, -
}AA. /
=AA0 1
stringAA2 8
.AA8 9
EmptyAA9 >
;AA> ?
}BB 
publicDD 

classDD 
AuthResponseDD 
{EE 
publicFF 
stringFF 
TokenFF 
{FF 
getFF !
;FF! "
setFF# &
;FF& '
}FF( )
=FF* +
stringFF, 2
.FF2 3
EmptyFF3 8
;FF8 9
publicGG 
stringGG 
EmailGG 
{GG 
getGG !
;GG! "
setGG# &
;GG& '
}GG( )
=GG* +
stringGG, 2
.GG2 3
EmptyGG3 8
;GG8 9
publicHH 
stringHH 
?HH 
RoleHH 
{HH 
getHH !
;HH! "
setHH# &
;HH& '
}HH( )
publicII 
DateTimeII 

ExpirationII "
{II# $
getII% (
;II( )
setII* -
;II- .
}II/ 0
}JJ 
}KK Ô$
QE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\ApplicationUser.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
ApplicationUser  
:! "
IdentityUser# /
{ 
public 
string 
	FirstName 
{  !
get" %
;% &
set' *
;* +
}, -
=. /
string0 6
.6 7
Empty7 <
;< =
public 
string 
LastName 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
public		 
DateTime		 
?		 
Birthday		 !
{		" #
get		$ '
;		' (
set		) ,
;		, -
}		. /
public

 
string

 
?

 
Address

 
{

  
get

! $
;

$ %
set

& )
;

) *
}

+ ,
public 
string 
? 
ProfilePictureUrl (
{) *
get+ .
;. /
set0 3
;3 4
}5 6
public 
string 
? 
Role 
{ 
get !
;! "
set# &
;& '
}( )
public 
string 
? 
Status 
{ 
get  #
;# $
set% (
;( )
}* +
public 
bool 
TwoFactorEnabled $
{% &
get' *
;* +
set, /
;/ 0
}1 2
=3 4
false5 :
;: ;
public 
string 
? 
SecurityPin "
{# $
get% (
;( )
set* -
;- .
}/ 0
public 
bool  
PinProtectionEnabled (
{) *
get+ .
;. /
set0 3
;3 4
}5 6
=7 8
false9 >
;> ?
public 
DateTime 
	CreatedAt !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
DateTime2 :
.: ;
UtcNow; A
;A B
public 
ICollection 
< 
Device !
>! "
Devices# *
{+ ,
get- 0
;0 1
set2 5
;5 6
}7 8
=9 :
new; >
List? C
<C D
DeviceD J
>J K
(K L
)L M
;M N
public 
ICollection 
< 
SupportTicket (
>( )
SupportTickets* 8
{9 :
get; >
;> ?
set@ C
;C D
}E F
=G H
newI L
ListM Q
<Q R
SupportTicketR _
>_ `
(` a
)a b
;b c
public 
ICollection 
< 
Notification '
>' (
Notifications) 6
{7 8
get9 <
;< =
set> A
;A B
}C D
=E F
newG J
ListK O
<O P
NotificationP \
>\ ]
(] ^
)^ _
;_ `
public 
ICollection 
< 
Subscription '
>' (
Subscriptions) 6
{7 8
get9 <
;< =
set> A
;A B
}C D
=E F
newG J
ListK O
<O P
SubscriptionP \
>\ ]
(] ^
)^ _
;_ `
public 
ICollection 
< 
Invoice "
>" #
Invoices$ ,
{- .
get/ 2
;2 3
set4 7
;7 8
}9 :
=; <
new= @
ListA E
<E F
InvoiceF M
>M N
(N O
)O P
;P Q
public 
ICollection 
< 
Payment "
>" #
Payments$ ,
{- .
get/ 2
;2 3
set4 7
;7 8
}9 :
=; <
new= @
ListA E
<E F
PaymentF M
>M N
(N O
)O P
;P Q
} 
} ü
aE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\AddPhoneNumberToPrepaidLoad.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class '
AddPhoneNumberToPrepaidLoad 4
:5 6
	Migration7 @
{ 
	protected		 
override		 
void		 
Up		  "
(		" #
MigrationBuilder		# 3
migrationBuilder		4 D
)		D E
{

 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str #
,# $
table 
: 
$str %
,% &
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str #
,# $
table 
: 
$str %
)% &
;& '
} 	
} 
} á%
lE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260428145859_AddLoginAttemptTracking.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 #
AddLoginAttemptTracking		 0
:		1 2
	Migration		3 <
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str %
,% &
columns 
: 
table 
=> !
new" %
{ 
LoginAttemptID "
=# $
table% *
.* +
Column+ 1
<1 2
int2 5
>5 6
(6 7
type7 ;
:; <
$str= B
,B C
nullableD L
:L M
falseN S
)S T
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
FailedAttempts "
=# $
table% *
.* +
Column+ 1
<1 2
int2 5
>5 6
(6 7
type7 ;
:; <
$str= B
,B C
nullableD L
:L M
falseN S
)S T
,T U
LockedUntil 
=  !
table" '
.' (
Column( .
<. /
DateTime/ 7
>7 8
(8 9
type9 =
:= >
$str? J
,J K
nullableL T
:T U
trueV Z
)Z [
,[ \

LockReason 
=  
table! &
.& '
Column' -
<- .
string. 4
>4 5
(5 6
type6 :
:: ;
$str< K
,K L
nullableM U
:U V
trueW [
)[ \
,\ ]
LastAttemptAt !
=" #
table$ )
.) *
Column* 0
<0 1
DateTime1 9
>9 :
(: ;
type; ?
:? @
$strA L
,L M
nullableN V
:V W
falseX ]
)] ^
,^ _
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 7
,7 8
x9 :
=>; =
x> ?
.? @
LoginAttemptID@ N
)N O
;O P
table 
. 

ForeignKey $
($ %
name 
: 
$str C
,C D
column   
:   
x    !
=>  " $
x  % &
.  & '
UserID  ' -
,  - .
principalTable!! &
:!!& '
$str!!( 5
,!!5 6
principalColumn"" '
:""' (
$str"") -
,""- .
onDelete##  
:##  !
ReferentialAction##" 3
.##3 4
Cascade##4 ;
)##; <
;##< =
}$$ 
)$$ 
;$$ 
migrationBuilder&& 
.&& 
CreateIndex&& (
(&&( )
name'' 
:'' 
$str'' /
,''/ 0
table(( 
:(( 
$str(( &
,((& '
column)) 
:)) 
$str))  
)))  !
;))! "
}** 	
	protected-- 
override-- 
void-- 
Down--  $
(--$ %
MigrationBuilder--% 5
migrationBuilder--6 F
)--F G
{.. 	
migrationBuilder// 
.// 
	DropTable// &
(//& '
name00 
:00 
$str00 %
)00% &
;00& '
}11 	
}22 
}33 ı1
fE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260428142721_AddSystemSettings.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddSystemSettings		 *
:		+ ,
	Migration		- 6
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str &
,& '
columns 
: 
table 
=> !
new" %
{ 
	SettingID 
= 
table  %
.% &
Column& ,
<, -
int- 0
>0 1
(1 2
type2 6
:6 7
$str8 =
,= >
nullable? G
:G H
falseI N
)N O
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
SiteName 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: I
,I J
nullableK S
:S T
falseU Z
)Z [
,[ \
	SiteEmail 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; J
,J K
nullableL T
:T U
falseV [
)[ \
,\ ]
MaintenanceMode #
=$ %
table& +
.+ ,
Column, 2
<2 3
bool3 7
>7 8
(8 9
type9 =
:= >
$str? D
,D E
nullableF N
:N O
falseP U
)U V
,V W
MaxLoginAttempts $
=% &
table' ,
., -
Column- 3
<3 4
int4 7
>7 8
(8 9
type9 =
:= >
$str? D
,D E
nullableF N
:N O
falseP U
)U V
,V W
SessionTimeout "
=# $
table% *
.* +
Column+ 1
<1 2
int2 5
>5 6
(6 7
type7 ;
:; <
$str= B
,B C
nullableD L
:L M
falseN S
)S T
,T U
EnableTwoFactor #
=$ %
table& +
.+ ,
Column, 2
<2 3
bool3 7
>7 8
(8 9
type9 =
:= >
$str? D
,D E
nullableF N
:N O
falseP U
)U V
,V W
EnableAuditLogs #
=$ %
table& +
.+ ,
Column, 2
<2 3
bool3 7
>7 8
(8 9
type9 =
:= >
$str? D
,D E
nullableF N
:N O
falseP U
)U V
,V W
NotificationEmail %
=& '
table( -
.- .
Column. 4
<4 5
string5 ;
>; <
(< =
type= A
:A B
$strC R
,R S
nullableT \
:\ ]
false^ c
)c d
,d e
EmailOnNewTickets %
=& '
table( -
.- .
Column. 4
<4 5
bool5 9
>9 :
(: ;
type; ?
:? @
$strA F
,F G
nullableH P
:P Q
falseR W
)W X
,X Y"
EmailOnPaymentReceived *
=+ ,
table- 2
.2 3
Column3 9
<9 :
bool: >
>> ?
(? @
type@ D
:D E
$strF K
,K L
nullableM U
:U V
falseW \
)\ ]
,] ^
EmailOnSystemErrors '
=( )
table* /
./ 0
Column0 6
<6 7
bool7 ;
>; <
(< =
type= A
:A B
$strC H
,H I
nullableJ R
:R S
falseT Y
)Y Z
,Z [!
EmailOnSecurityAlerts )
=* +
table, 1
.1 2
Column2 8
<8 9
bool9 =
>= >
(> ?
type? C
:C D
$strE J
,J K
nullableL T
:T U
falseV [
)[ \
,\ ]
	CreatedAt   
=   
table    %
.  % &
Column  & ,
<  , -
DateTime  - 5
>  5 6
(  6 7
type  7 ;
:  ; <
$str  = H
,  H I
nullable  J R
:  R S
false  T Y
)  Y Z
,  Z [
	UpdatedAt!! 
=!! 
table!!  %
.!!% &
Column!!& ,
<!!, -
DateTime!!- 5
>!!5 6
(!!6 7
type!!7 ;
:!!; <
$str!!= H
,!!H I
nullable!!J R
:!!R S
false!!T Y
)!!Y Z
}"" 
,"" 
constraints## 
:## 
table## "
=>### %
{$$ 
table%% 
.%% 

PrimaryKey%% $
(%%$ %
$str%%% 8
,%%8 9
x%%: ;
=>%%< >
x%%? @
.%%@ A
	SettingID%%A J
)%%J K
;%%K L
}&& 
)&& 
;&& 
}'' 	
	protected** 
override** 
void** 
Down**  $
(**$ %
MigrationBuilder**% 5
migrationBuilder**6 F
)**F G
{++ 	
migrationBuilder,, 
.,, 
	DropTable,, &
(,,& '
name-- 
:-- 
$str-- &
)--& '
;--' (
}.. 	
}// 
}00 ö
gE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260428092534_AddRolePermissions.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddRolePermissions		 +
:		, -
	Migration		. 7
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str '
,' (
columns 
: 
table 
=> !
new" %
{ 
RolePermissionID $
=% &
table' ,
., -
Column- 3
<3 4
int4 7
>7 8
(8 9
type9 =
:= >
$str? D
,D E
nullableF N
:N O
falseP U
)U V
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
RoleName 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: I
,I J
nullableK S
:S T
falseU Z
)Z [
,[ \
PermissionName "
=# $
table% *
.* +
Column+ 1
<1 2
string2 8
>8 9
(9 :
type: >
:> ?
$str@ O
,O P
nullableQ Y
:Y Z
false[ `
)` a
,a b
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
,Z [
	UpdatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
trueT X
)X Y
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 9
,9 :
x; <
=>= ?
x@ A
.A B
RolePermissionIDB R
)R S
;S T
} 
) 
; 
migrationBuilder 
. 
CreateIndex (
(( )
name 
: 
$str B
,B C
table   
:   
$str   (
,  ( )
columns!! 
:!! 
new!! 
[!! 
]!! 
{!!  
$str!!! +
,!!+ ,
$str!!- =
}!!> ?
,!!? @
unique"" 
:"" 
true"" 
)"" 
;"" 
}## 	
	protected&& 
override&& 
void&& 
Down&&  $
(&&$ %
MigrationBuilder&&% 5
migrationBuilder&&6 F
)&&F G
{'' 	
migrationBuilder(( 
.(( 
	DropTable(( &
(((& '
name)) 
:)) 
$str)) '
)))' (
;))( )
}** 	
}++ 
},, ˛
sE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260310131151_AddIsHiddenByCustomerToTickets.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class *
AddIsHiddenByCustomerToTickets 7
:8 9
	Migration: C
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
bool' +
>+ ,
(, -
name 
: 
$str *
,* +
table 
: 
$str '
,' (
type 
: 
$str 
, 
nullable 
: 
false 
,  
defaultValue 
: 
false #
)# $
;$ %
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str *
,* +
table 
: 
$str '
)' (
;( )
} 	
} 
} ó%
cE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260310120423_AddPromoOffers.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddPromoOffers		 '
:		( )
	Migration		* 3
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str #
,# $
columns 
: 
table 
=> !
new" %
{ 
PromoOfferID  
=! "
table# (
.( )
Column) /
</ 0
int0 3
>3 4
(4 5
type5 9
:9 :
$str; @
,@ A
nullableB J
:J K
falseL Q
)Q R
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
Title 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 F
,F G
nullableH P
:P Q
falseR W
)W X
,X Y
Description 
=  !
table" '
.' (
Column( .
<. /
string/ 5
>5 6
(6 7
type7 ;
:; <
$str= L
,L M
nullableN V
:V W
falseX ]
)] ^
,^ _
Price 
= 
table !
.! "
Column" (
<( )
decimal) 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Data 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 E
,E F
nullableG O
:O P
falseQ V
)V W
,W X
Validity 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: I
,I J
nullableK S
:S T
falseU Z
)Z [
,[ \
Badge 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 F
,F G
nullableH P
:P Q
trueR V
)V W
,W X
Color 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 F
,F G
nullableH P
:P Q
falseR W
)W X
,X Y
IsActive 
= 
table $
.$ %
Column% +
<+ ,
bool, 0
>0 1
(1 2
type2 6
:6 7
$str8 =
,= >
nullable? G
:G H
falseI N
)N O
,O P
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
} 
, 
constraints 
: 
table "
=># %
{ 
table   
.   

PrimaryKey   $
(  $ %
$str  % 5
,  5 6
x  7 8
=>  9 ;
x  < =
.  = >
PromoOfferID  > J
)  J K
;  K L
}!! 
)!! 
;!! 
}"" 	
	protected%% 
override%% 
void%% 
Down%%  $
(%%$ %
MigrationBuilder%%% 5
migrationBuilder%%6 F
)%%F G
{&& 	
migrationBuilder'' 
.'' 
	DropTable'' &
(''& '
name(( 
:(( 
$str(( #
)((# $
;(($ %
})) 	
}** 
}++ Ï<
eE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260310111411_AddPrepaidPromos.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddPrepaidPromos		 )
:		* +
	Migration		, 5
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
DropForeignKey +
(+ ,
name 
: 
$str I
,I J
table 
: 
$str &
)& '
;' (
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str %
,% &
columns 
: 
table 
=> !
new" %
{ 
PrepaidPromoID "
=# $
table% *
.* +
Column+ 1
<1 2
int2 5
>5 6
(6 7
type7 ;
:; <
$str= B
,B C
nullableD L
:L M
falseN S
)S T
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
PrepaidLoadID !
=" #
table$ )
.) *
Column* 0
<0 1
int1 4
>4 5
(5 6
type6 :
:: ;
$str< A
,A B
nullableC K
:K L
falseM R
)R S
,S T
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z

PromoTitle 
=  
table! &
.& '
Column' -
<- .
string. 4
>4 5
(5 6
type6 :
:: ;
$str< K
,K L
nullableM U
:U V
falseW \
)\ ]
,] ^
TotalDataMB 
=  !
table" '
.' (
Column( .
<. /
decimal/ 6
>6 7
(7 8
type8 <
:< =
$str> M
,M N
nullableO W
:W X
falseY ^
)^ _
,_ `
RemainingDataMB #
=$ %
table& +
.+ ,
Column, 2
<2 3
decimal3 :
>: ;
(; <
type< @
:@ A
$strB Q
,Q R
nullableS [
:[ \
false] b
)b c
,c d
ValidityDays  
=! "
table# (
.( )
Column) /
</ 0
int0 3
>3 4
(4 5
type5 9
:9 :
$str; @
,@ A
nullableB J
:J K
falseL Q
)Q R
,R S
ActivatedAt 
=  !
table" '
.' (
Column( .
<. /
DateTime/ 7
>7 8
(8 9
type9 =
:= >
$str? J
,J K
nullableL T
:T U
falseV [
)[ \
,\ ]
	ExpiresAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
,Z [
Status   
=   
table   "
.  " #
Column  # )
<  ) *
string  * 0
>  0 1
(  1 2
type  2 6
:  6 7
$str  8 G
,  G H
nullable  I Q
:  Q R
false  S X
)  X Y
}!! 
,!! 
constraints"" 
:"" 
table"" "
=>""# %
{## 
table$$ 
.$$ 

PrimaryKey$$ $
($$$ %
$str$$% 7
,$$7 8
x$$9 :
=>$$; =
x$$> ?
.$$? @
PrepaidPromoID$$@ N
)$$N O
;$$O P
table%% 
.%% 

ForeignKey%% $
(%%$ %
name&& 
:&& 
$str&& C
,&&C D
column'' 
:'' 
x''  !
=>''" $
x''% &
.''& '
UserID''' -
,''- .
principalTable(( &
:((& '
$str((( 5
,((5 6
principalColumn)) '
:))' (
$str))) -
)))- .
;)). /
table** 
.** 

ForeignKey** $
(**$ %
name++ 
:++ 
$str++ K
,++K L
column,, 
:,, 
x,,  !
=>,," $
x,,% &
.,,& '
PrepaidLoadID,,' 4
,,,4 5
principalTable-- &
:--& '
$str--( 6
,--6 7
principalColumn.. '
:..' (
$str..) 8
)..8 9
;..9 :
}// 
)// 
;// 
migrationBuilder11 
.11 
CreateIndex11 (
(11( )
name22 
:22 
$str22 6
,226 7
table33 
:33 
$str33 &
,33& '
column44 
:44 
$str44 '
)44' (
;44( )
migrationBuilder66 
.66 
CreateIndex66 (
(66( )
name77 
:77 
$str77 /
,77/ 0
table88 
:88 
$str88 &
,88& '
column99 
:99 
$str99  
)99  !
;99! "
migrationBuilder;; 
.;; 
AddForeignKey;; *
(;;* +
name<< 
:<< 
$str<< I
,<<I J
table== 
:== 
$str== &
,==& '
column>> 
:>> 
$str>> *
,>>* +
principalTable?? 
:?? 
$str??  1
,??1 2
principalColumn@@ 
:@@  
$str@@! 3
)@@3 4
;@@4 5
}AA 	
	protectedDD 
overrideDD 
voidDD 
DownDD  $
(DD$ %
MigrationBuilderDD% 5
migrationBuilderDD6 F
)DDF G
{EE 	
migrationBuilderFF 
.FF 
DropForeignKeyFF +
(FF+ ,
nameGG 
:GG 
$strGG I
,GGI J
tableHH 
:HH 
$strHH &
)HH& '
;HH' (
migrationBuilderJJ 
.JJ 
	DropTableJJ &
(JJ& '
nameKK 
:KK 
$strKK %
)KK% &
;KK& '
migrationBuilderMM 
.MM 
AddForeignKeyMM *
(MM* +
nameNN 
:NN 
$strNN I
,NNI J
tableOO 
:OO 
$strOO &
,OO& '
columnPP 
:PP 
$strPP *
,PP* +
principalTableQQ 
:QQ 
$strQQ  1
,QQ1 2
principalColumnRR 
:RR  
$strRR! 3
,RR3 4
onDeleteSS 
:SS 
ReferentialActionSS +
.SS+ ,
CascadeSS, 3
)SS3 4
;SS4 5
}TT 	
}UU 
}VV ß
qE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260310055858_UpdateCascadeDeleteRulesOnly.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class (
UpdateCascadeDeleteRulesOnly 5
:6 7
	Migration8 A
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
} 	
} 
} †
iE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260309115835_AddProfilePictureUrl.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class  
AddProfilePictureUrl -
:. /
	Migration0 9
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str )
,) *
table 
: 
$str $
,$ %
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str )
,) *
table 
: 
$str $
)$ %
;% &
} 	
} 
} “"
oE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260309053049_AddNotificationPreferences.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 &
AddNotificationPreferences		 3
:		4 5
	Migration		6 ?
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str /
,/ 0
columns 
: 
table 
=> !
new" %
{ 
PreferenceID  
=! "
table# (
.( )
Column) /
</ 0
int0 3
>3 4
(4 5
type5 9
:9 :
$str; @
,@ A
nullableB J
:J K
falseL Q
)Q R
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
NotificationType $
=% &
table' ,
., -
Column- 3
<3 4
string4 :
>: ;
(; <
type< @
:@ A
$strB Q
,Q R
nullableS [
:[ \
false] b
)b c
,c d
EmailEnabled  
=! "
table# (
.( )
Column) /
</ 0
bool0 4
>4 5
(5 6
type6 :
:: ;
$str< A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
,Z [
	UpdatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
trueT X
)X Y
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% A
,A B
xC D
=>E G
xH I
.I J
PreferenceIDJ V
)V W
;W X
table 
. 

ForeignKey $
($ %
name 
: 
$str M
,M N
column 
: 
x  !
=>" $
x% &
.& '
UserID' -
,- .
principalTable   &
:  & '
$str  ( 5
,  5 6
principalColumn!! '
:!!' (
$str!!) -
,!!- .
onDelete""  
:""  !
ReferentialAction""" 3
.""3 4
Cascade""4 ;
)""; <
;""< =
}## 
)## 
;## 
migrationBuilder%% 
.%% 
CreateIndex%% (
(%%( )
name&& 
:&& 
$str&& 9
,&&9 :
table'' 
:'' 
$str'' 0
,''0 1
column(( 
:(( 
$str((  
)((  !
;((! "
})) 	
	protected,, 
override,, 
void,, 
Down,,  $
(,,$ %
MigrationBuilder,,% 5
migrationBuilder,,6 F
),,F G
{-- 	
migrationBuilder.. 
... 
	DropTable.. &
(..& '
name// 
:// 
$str// /
)/// 0
;//0 1
}00 	
}11 
}22 Á
cE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260309051547_AddSecurityPin.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class 
AddSecurityPin '
:( )
	Migration* 3
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
bool' +
>+ ,
(, -
name 
: 
$str ,
,, -
table 
: 
$str $
,$ %
type 
: 
$str 
, 
nullable 
: 
false 
,  
defaultValue 
: 
false #
)# $
;$ %
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str #
,# $
table 
: 
$str $
,$ %
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str ,
,, -
table   
:   
$str   $
)  $ %
;  % &
migrationBuilder"" 
."" 

DropColumn"" '
(""' (
name## 
:## 
$str## #
,### $
table$$ 
:$$ 
$str$$ $
)$$$ %
;$$% &
}%% 	
}&& 
}'' ï
hE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260309050131_AddTwoFactorEnabled.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class 
AddTwoFactorEnabled ,
:- .
	Migration/ 8
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
} 	
} 
} ±"
dE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260309045218_AddLoginHistory.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddLoginHistory		 (
:		) *
	Migration		+ 4
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str $
,$ %
columns 
: 
table 
=> !
new" %
{ 
LoginHistoryID "
=# $
table% *
.* +
Column+ 1
<1 2
int2 5
>5 6
(6 7
type7 ;
:; <
$str= B
,B C
nullableD L
:L M
falseN S
)S T
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Device 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Location 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: I
,I J
nullableK S
:S T
trueU Y
)Y Z
,Z [
	IPAddress 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; J
,J K
nullableL T
:T U
trueV Z
)Z [
,[ \
	LoginTime 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 6
,6 7
x8 9
=>: <
x= >
.> ?
LoginHistoryID? M
)M N
;N O
table 
. 

ForeignKey $
($ %
name 
: 
$str B
,B C
column 
: 
x  !
=>" $
x% &
.& '
UserID' -
,- .
principalTable   &
:  & '
$str  ( 5
,  5 6
principalColumn!! '
:!!' (
$str!!) -
,!!- .
onDelete""  
:""  !
ReferentialAction""" 3
.""3 4
Cascade""4 ;
)""; <
;""< =
}## 
)## 
;## 
migrationBuilder%% 
.%% 
CreateIndex%% (
(%%( )
name&& 
:&& 
$str&& .
,&&. /
table'' 
:'' 
$str'' %
,''% &
column(( 
:(( 
$str((  
)((  !
;((! "
})) 	
	protected,, 
override,, 
void,, 
Down,,  $
(,,$ %
MigrationBuilder,,% 5
migrationBuilder,,6 F
),,F G
{-- 	
migrationBuilder.. 
... 
	DropTable.. &
(..& '
name// 
:// 
$str// $
)//$ %
;//% &
}00 	
}11 
}22 π
pE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260309015733_AddBirthdayAndAddressToUser.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 '
AddBirthdayAndAddressToUser		 4
:		5 6
	Migration		7 @
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str 
,  
table 
: 
$str $
,$ %
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
	AddColumn &
<& '
DateTime' /
>/ 0
(0 1
name 
: 
$str  
,  !
table 
: 
$str $
,$ %
type 
: 
$str !
,! "
nullable 
: 
true 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str 
,  
table   
:   
$str   $
)  $ %
;  % &
migrationBuilder"" 
."" 

DropColumn"" '
(""' (
name## 
:## 
$str##  
,##  !
table$$ 
:$$ 
$str$$ $
)$$$ %
;$$% &
}%% 	
}&& 
}'' ˙
qE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260224143105_AddIsArchivedToSupportTicket.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class (
AddIsArchivedToSupportTicket 5
:6 7
	Migration8 A
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
bool' +
>+ ,
(, -
name 
: 
$str "
," #
table 
: 
$str '
,' (
type 
: 
$str 
, 
nullable 
: 
false 
,  
defaultValue 
: 
false #
)# $
;$ %
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str "
," #
table 
: 
$str '
)' (
;( )
} 	
} 
} ˜
qE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260222124411_MakePaymentInvoiceIDNullable.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class (
MakePaymentInvoiceIDNullable 5
:6 7
	Migration8 A
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
AlterColumn (
<( )
int) ,
>, -
(- .
name 
: 
$str !
,! "
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
true 
, 

oldClrType 
: 
typeof "
(" #
int# &
)& '
,' (
oldType 
: 
$str 
) 
;  
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 
AlterColumn (
<( )
int) ,
>, -
(- .
name 
: 
$str !
,! "
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
false 
,  
defaultValue 
: 
$num 
,  

oldClrType 
: 
typeof "
(" #
int# &
)& '
,' (
oldType   
:   
$str   
,   
oldNullable!! 
:!! 
true!! !
)!!! "
;!!" #
}"" 	
}## 
}$$ ã(
eE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260221145055_AddTicketReplies.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddTicketReplies		 )
:		* +
	Migration		, 5
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str %
,% &
columns 
: 
table 
=> !
new" %
{ 
ReplyID 
= 
table #
.# $
Column$ *
<* +
int+ .
>. /
(/ 0
type0 4
:4 5
$str6 ;
,; <
nullable= E
:E F
falseG L
)L M
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
TicketID 
= 
table $
.$ %
Column% +
<+ ,
int, /
>/ 0
(0 1
type1 5
:5 6
$str7 <
,< =
nullable> F
:F G
falseH M
)M N
,N O
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Message 
= 
table #
.# $
Column$ *
<* +
string+ 1
>1 2
(2 3
type3 7
:7 8
$str9 H
,H I
nullableJ R
:R S
falseT Y
)Y Z
,Z [
IsAdminReply  
=! "
table# (
.( )
Column) /
</ 0
bool0 4
>4 5
(5 6
type6 :
:: ;
$str< A
,A B
nullableC K
:K L
falseM R
)R S
,S T
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 7
,7 8
x9 :
=>; =
x> ?
.? @
ReplyID@ G
)G H
;H I
table 
. 

ForeignKey $
($ %
name 
: 
$str C
,C D
column 
: 
x  !
=>" $
x% &
.& '
UserID' -
,- .
principalTable   &
:  & '
$str  ( 5
,  5 6
principalColumn!! '
:!!' (
$str!!) -
,!!- .
onDelete""  
:""  !
ReferentialAction""" 3
.""3 4
Cascade""4 ;
)""; <
;""< =
table## 
.## 

ForeignKey## $
(##$ %
name$$ 
:$$ 
$str$$ H
,$$H I
column%% 
:%% 
x%%  !
=>%%" $
x%%% &
.%%& '
TicketID%%' /
,%%/ 0
principalTable&& &
:&&& '
$str&&( 8
,&&8 9
principalColumn'' '
:''' (
$str'') 3
)''3 4
;''4 5
}(( 
)(( 
;(( 
migrationBuilder** 
.** 
CreateIndex** (
(**( )
name++ 
:++ 
$str++ 1
,++1 2
table,, 
:,, 
$str,, &
,,,& '
column-- 
:-- 
$str-- "
)--" #
;--# $
migrationBuilder// 
.// 
CreateIndex// (
(//( )
name00 
:00 
$str00 /
,00/ 0
table11 
:11 
$str11 &
,11& '
column22 
:22 
$str22  
)22  !
;22! "
}33 	
	protected66 
override66 
void66 
Down66  $
(66$ %
MigrationBuilder66% 5
migrationBuilder666 F
)66F G
{77 	
migrationBuilder88 
.88 
	DropTable88 &
(88& '
name99 
:99 
$str99 %
)99% &
;99& '
}:: 	
};; 
}<< Ó
kE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260221121614_AddIsArchivedToPayment.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class "
AddIsArchivedToPayment /
:0 1
	Migration2 ;
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
bool' +
>+ ,
(, -
name 
: 
$str "
," #
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
false 
,  
defaultValue 
: 
false #
)# $
;$ %
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 

DropColumn '
(' (
name 
: 
$str "
," #
table 
: 
$str !
)! "
;" #
} 	
} 
} ‘ 
sE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260221112132_MakeInvoiceForeignKeysNullable.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class *
MakeInvoiceForeignKeysNullable 7
:8 9
	Migration: C
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str #
,# $
table 
: 
$str %
,% &
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
AlterColumn (
<( )
int) ,
>, -
(- .
name 
: 
$str &
,& '
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
true 
, 

oldClrType 
: 
typeof "
(" #
int# &
)& '
,' (
oldType 
: 
$str 
) 
;  
migrationBuilder 
. 
AlterColumn (
<( )
int) ,
>, -
(- .
name 
: 
$str %
,% &
table 
: 
$str !
,! "
type 
: 
$str 
, 
nullable 
: 
true 
, 

oldClrType   
:   
typeof   "
(  " #
int  # &
)  & '
,  ' (
oldType!! 
:!! 
$str!! 
)!! 
;!!  
}"" 	
	protected%% 
override%% 
void%% 
Down%%  $
(%%$ %
MigrationBuilder%%% 5
migrationBuilder%%6 F
)%%F G
{&& 	
migrationBuilder'' 
.'' 

DropColumn'' '
(''' (
name(( 
:(( 
$str(( #
,((# $
table)) 
:)) 
$str)) %
)))% &
;))& '
migrationBuilder++ 
.++ 
AlterColumn++ (
<++( )
int++) ,
>++, -
(++- .
name,, 
:,, 
$str,, &
,,,& '
table-- 
:-- 
$str-- !
,--! "
type.. 
:.. 
$str.. 
,.. 
nullable// 
:// 
false// 
,//  
defaultValue00 
:00 
$num00 
,00  

oldClrType11 
:11 
typeof11 "
(11" #
int11# &
)11& '
,11' (
oldType22 
:22 
$str22 
,22 
oldNullable33 
:33 
true33 !
)33! "
;33" #
migrationBuilder55 
.55 
AlterColumn55 (
<55( )
int55) ,
>55, -
(55- .
name66 
:66 
$str66 %
,66% &
table77 
:77 
$str77 !
,77! "
type88 
:88 
$str88 
,88 
nullable99 
:99 
false99 
,99  
defaultValue:: 
::: 
$num:: 
,::  

oldClrType;; 
:;; 
typeof;; "
(;;" #
int;;# &
);;& '
,;;' (
oldType<< 
:<< 
$str<< 
,<< 
oldNullable== 
:== 
true== !
)==! "
;==" #
}>> 	
}?? 
}@@ ˝
rE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260220122903_ChangeAssignedStaffIDToString.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class )
ChangeAssignedStaffIDToString 6
:7 8
	Migration9 B
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
AlterColumn (
<( )
string) /
>/ 0
(0 1
name 
: 
$str '
,' (
table 
: 
$str '
,' (
type 
: 
$str %
,% &
nullable 
: 
true 
, 

oldClrType 
: 
typeof "
(" #
int# &
)& '
,' (
oldType 
: 
$str 
, 
oldNullable 
: 
true !
)! "
;" #
} 	
	protected 
override 
void 
Down  $
($ %
MigrationBuilder% 5
migrationBuilder6 F
)F G
{ 	
migrationBuilder 
. 
AlterColumn (
<( )
int) ,
>, -
(- .
name 
: 
$str '
,' (
table 
: 
$str '
,' (
type 
: 
$str 
, 
nullable 
: 
true 
, 

oldClrType 
: 
typeof "
(" #
string# )
)) *
,* +
oldType   
:   
$str   (
,  ( )
oldNullable!! 
:!! 
true!! !
)!!! "
;!!" #
}"" 	
}## 
}$$ –
xE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260220115932_AddTicketCategoryPriorityAttachment.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public 

partial 
class /
#AddTicketCategoryPriorityAttachment <
:= >
	Migration? H
{		 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str %
,% &
table 
: 
$str '
,' (
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str  
,  !
table 
: 
$str '
,' (
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str  
,  !
table 
: 
$str '
,' (
type 
: 
$str %
,% &
nullable 
: 
true 
) 
;  
} 	
	protected!! 
override!! 
void!! 
Down!!  $
(!!$ %
MigrationBuilder!!% 5
migrationBuilder!!6 F
)!!F G
{"" 	
migrationBuilder## 
.## 

DropColumn## '
(##' (
name$$ 
:$$ 
$str$$ %
,$$% &
table%% 
:%% 
$str%% '
)%%' (
;%%( )
migrationBuilder'' 
.'' 

DropColumn'' '
(''' (
name(( 
:(( 
$str((  
,((  !
table)) 
:)) 
$str)) '
)))' (
;))( )
migrationBuilder++ 
.++ 

DropColumn++ '
(++' (
name,, 
:,, 
$str,,  
,,,  !
table-- 
:-- 
$str-- '
)--' (
;--( )
}.. 	
}// 
}00 ¢ 
`E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260220112910_AddFAQTable.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddFAQTable		 $
:		% &
	Migration		' 0
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str 
, 
columns 
: 
table 
=> !
new" %
{ 
FAQID 
= 
table !
.! "
Column" (
<( )
int) ,
>, -
(- .
type. 2
:2 3
$str4 9
,9 :
nullable; C
:C D
falseE J
)J K
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
Question 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: I
,I J
nullableK S
:S T
falseU Z
)Z [
,[ \
Answer 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Category 
= 
table $
.$ %
Column% +
<+ ,
string, 2
>2 3
(3 4
type4 8
:8 9
$str: I
,I J
nullableK S
:S T
falseU Z
)Z [
,[ \
Status 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Views 
= 
table !
.! "
Column" (
<( )
int) ,
>, -
(- .
type. 2
:2 3
$str4 9
,9 :
nullable; C
:C D
falseE J
)J K
,K L
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
,Z [
	UpdatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
trueT X
)X Y
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% .
,. /
x0 1
=>2 4
x5 6
.6 7
FAQID7 <
)< =
;= >
} 
) 
; 
}   	
	protected## 
override## 
void## 
Down##  $
(##$ %
MigrationBuilder##% 5
migrationBuilder##6 F
)##F G
{$$ 	
migrationBuilder%% 
.%% 
	DropTable%% &
(%%& '
name&& 
:&& 
$str&& 
)&& 
;&& 
}'' 	
}(( 
})) ú"
dE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260220103819_AddActivityLogs.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
AddActivityLogs		 (
:		) *
	Migration		+ 4
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str $
,$ %
columns 
: 
table 
=> !
new" %
{ 
LogID 
= 
table !
.! "
Column" (
<( )
int) ,
>, -
(- .
type. 2
:2 3
$str4 9
,9 :
nullable; C
:C D
falseE J
)J K
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Action 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z
Type 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 E
,E F
nullableG O
:O P
falseQ V
)V W
,W X
	IPAddress 
= 
table  %
.% &
Column& ,
<, -
string- 3
>3 4
(4 5
type5 9
:9 :
$str; J
,J K
nullableL T
:T U
trueV Z
)Z [
,[ \
	Timestamp 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 6
,6 7
x8 9
=>: <
x= >
.> ?
LogID? D
)D E
;E F
table 
. 

ForeignKey $
($ %
name 
: 
$str B
,B C
column 
: 
x  !
=>" $
x% &
.& '
UserID' -
,- .
principalTable   &
:  & '
$str  ( 5
,  5 6
principalColumn!! '
:!!' (
$str!!) -
,!!- .
onDelete""  
:""  !
ReferentialAction""" 3
.""3 4
Cascade""4 ;
)""; <
;""< =
}## 
)## 
;## 
migrationBuilder%% 
.%% 
CreateIndex%% (
(%%( )
name&& 
:&& 
$str&& .
,&&. /
table'' 
:'' 
$str'' %
,''% &
column(( 
:(( 
$str((  
)((  !
;((! "
})) 	
	protected,, 
override,, 
void,, 
Down,,  $
(,,$ %
MigrationBuilder,,% 5
migrationBuilder,,6 F
),,F G
{-- 	
migrationBuilder.. 
... 
	DropTable.. &
(..& '
name// 
:// 
$str// $
)//$ %
;//% &
}00 	
}11 
}22 ñ
{E:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260220072516_RemoveSubscriptionPlanUserRelationship.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 2
&RemoveSubscriptionPlanUserRelationship		 ?
:		@ A
	Migration		B K
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
Sql  
(  !
$str! 
) 
; 
migrationBuilder 
. 
Sql  
(  !
$str! 
) 
; 
migrationBuilder 
. 
Sql  
(  !
$str! 
) 
; 
migrationBuilder 
. 
Sql  
(  !
$str ! 
)   
;   
migrationBuilder"" 
."" 
Sql""  
(""  !
$str"%! 
)%% 
;%% 
migrationBuilder'' 
.'' 
Sql''  
(''  !
$str'5! 
)55 
;55 
migrationBuilder77 
.77 
Sql77  
(77  !
$str7H! 
)HH 
;HH 
}II 	
	protectedLL 
overrideLL 
voidLL 
DownLL  $
(LL$ %
MigrationBuilderLL% 5
migrationBuilderLL6 F
)LLF G
{MM 	
migrationBuilderNN 
.NN 
	DropTableNN &
(NN& '
nameOO 
:OO 
$strOO "
)OO" #
;OO# $
migrationBuilderQQ 
.QQ 
	DropTableQQ &
(QQ& '
nameRR 
:RR 
$strRR 
)RR 
;RR  
migrationBuilderTT 
.TT 

DropColumnTT '
(TT' (
nameUU 
:UU 
$strUU "
,UU" #
tableVV 
:VV 
$strVV &
)VV& '
;VV' (
migrationBuilderXX 
.XX 

DropColumnXX '
(XX' (
nameYY 
:YY 
$strYY 
,YY 
tableZZ 
:ZZ 
$strZZ *
)ZZ* +
;ZZ+ ,
migrationBuilder\\ 
.\\ 
	AddColumn\\ &
<\\& '
string\\' -
>\\- .
(\\. /
name]] 
:]] 
$str]] 
,]] 
table^^ 
:^^ 
$str^^ *
,^^* +
type__ 
:__ 
$str__ %
,__% &
nullable`` 
:`` 
false`` 
,``  
defaultValueaa 
:aa 
$straa  
)aa  !
;aa! "
migrationBuildercc 
.cc 
CreateIndexcc (
(cc( )
namedd 
:dd 
$strdd 3
,dd3 4
tableee 
:ee 
$stree *
,ee* +
columnff 
:ff 
$strff  
)ff  !
;ff! "
migrationBuilderhh 
.hh 
AddForeignKeyhh *
(hh* +
nameii 
:ii 
$strii ?
,ii? @
tablejj 
:jj 
$strjj *
,jj* +
columnkk 
:kk 
$strkk  
,kk  !
principalTablell 
:ll 
$strll  -
,ll- .
principalColumnmm 
:mm  
$strmm! %
,mm% &
onDeletenn 
:nn 
ReferentialActionnn +
.nn+ ,
Cascadenn, 3
)nn3 4
;nn4 5
}oo 	
}pp 
}qq ç,
kE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260219142433_AddSavedPaymentMethods.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 "
AddSavedPaymentMethods		 /
:		0 1
	Migration		2 ;
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str +
,+ ,
columns 
: 
table 
=> !
new" %
{ 
PaymentMethodID #
=$ %
table& +
.+ ,
Column, 2
<2 3
int3 6
>6 7
(7 8
type8 <
:< =
$str> C
,C D
nullableE M
:M N
falseO T
)T U
. 

Annotation #
(# $
$str$ 8
,8 9
$str: @
)@ A
,A B
UserID 
= 
table "
." #
Column# )
<) *
string* 0
>0 1
(1 2
type2 6
:6 7
$str8 G
,G H
nullableI Q
:Q R
falseS X
)X Y
,Y Z#
PayMongoPaymentMethodId +
=, -
table. 3
.3 4
Column4 :
<: ;
string; A
>A B
(B C
typeC G
:G H
$strI X
,X Y
nullableZ b
:b c
falsed i
)i j
,j k
Type 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 E
,E F
nullableG O
:O P
falseQ V
)V W
,W X
Last4 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 F
,F G
nullableH P
:P Q
trueR V
)V W
,W X
Brand 
= 
table !
.! "
Column" (
<( )
string) /
>/ 0
(0 1
type1 5
:5 6
$str7 F
,F G
nullableH P
:P Q
trueR V
)V W
,W X
ExpMonth 
= 
table $
.$ %
Column% +
<+ ,
int, /
>/ 0
(0 1
type1 5
:5 6
$str7 <
,< =
nullable> F
:F G
trueH L
)L M
,M N
ExpYear 
= 
table #
.# $
Column$ *
<* +
int+ .
>. /
(/ 0
type0 4
:4 5
$str6 ;
,; <
nullable= E
:E F
trueG K
)K L
,L M
	IsDefault 
= 
table  %
.% &
Column& ,
<, -
bool- 1
>1 2
(2 3
type3 7
:7 8
$str9 >
,> ?
nullable@ H
:H I
falseJ O
)O P
,P Q
	CreatedAt 
= 
table  %
.% &
Column& ,
<, -
DateTime- 5
>5 6
(6 7
type7 ;
:; <
$str= H
,H I
nullableJ R
:R S
falseT Y
)Y Z
} 
, 
constraints 
: 
table "
=># %
{ 
table   
.   

PrimaryKey   $
(  $ %
$str  % =
,  = >
x  ? @
=>  A C
x  D E
.  E F
PaymentMethodID  F U
)  U V
;  V W
table!! 
.!! 

ForeignKey!! $
(!!$ %
name"" 
:"" 
$str"" I
,""I J
column## 
:## 
x##  !
=>##" $
x##% &
.##& '
UserID##' -
,##- .
principalTable$$ &
:$$& '
$str$$( 5
,$$5 6
principalColumn%% '
:%%' (
$str%%) -
,%%- .
onDelete&&  
:&&  !
ReferentialAction&&" 3
.&&3 4
Cascade&&4 ;
)&&; <
;&&< =
}'' 
)'' 
;'' 
migrationBuilder)) 
.)) 
CreateIndex)) (
())( )
name** 
:** 
$str** 5
,**5 6
table++ 
:++ 
$str++ ,
,++, -
column,, 
:,, 
$str,,  
),,  !
;,,! "
}-- 	
	protected00 
override00 
void00 
Down00  $
(00$ %
MigrationBuilder00% 5
migrationBuilder006 F
)00F G
{11 	
migrationBuilder22 
.22 
	DropTable22 &
(22& '
name33 
:33 
$str33 +
)33+ ,
;33, -
}44 	
}55 
}66 Àï
nE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260217134524_CompleteERDImplementation.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 %
CompleteERDImplementation		 2
:		3 4
	Migration		5 >
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
	AddColumn &
<& '
DateTime' /
>/ 0
(0 1
name 
: 
$str !
,! "
table 
: 
$str $
,$ %
type 
: 
$str !
,! "
nullable 
: 
false 
,  
defaultValue 
: 
new !
DateTime" *
(* +
$num+ ,
,, -
$num. /
,/ 0
$num1 2
,2 3
$num4 5
,5 6
$num7 8
,8 9
$num: ;
,; <
$num= >
,> ?
DateTimeKind@ L
.L M
UnspecifiedM X
)X Y
)Y Z
;Z [
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str !
,! "
table 
: 
$str $
,$ %
type 
: 
$str %
,% &
nullable 
: 
false 
,  
defaultValue 
: 
$str  
)  !
;! "
migrationBuilder 
. 
	AddColumn &
<& '
string' -
>- .
(. /
name 
: 
$str  
,  !
table 
: 
$str $
,$ %
type 
: 
$str %
,% &
nullable   
:   
false   
,    
defaultValue!! 
:!! 
$str!!  
)!!  !
;!!! "
migrationBuilder## 
.## 
	AddColumn## &
<##& '
string##' -
>##- .
(##. /
name$$ 
:$$ 
$str$$ 
,$$ 
table%% 
:%% 
$str%% $
,%%$ %
type&& 
:&& 
$str&& %
,&&% &
nullable'' 
:'' 
true'' 
)'' 
;''  
migrationBuilder)) 
.)) 
	AddColumn)) &
<))& '
string))' -
>))- .
()). /
name** 
:** 
$str** 
,** 
table++ 
:++ 
$str++ $
,++$ %
type,, 
:,, 
$str,, %
,,,% &
nullable-- 
:-- 
true-- 
)-- 
;--  
migrationBuilder// 
.// 
CreateTable// (
(//( )
name00 
:00 
$str00 
,00  
columns11 
:11 
table11 
=>11 !
new11" %
{22 
DeviceID33 
=33 
table33 $
.33$ %
Column33% +
<33+ ,
int33, /
>33/ 0
(330 1
type331 5
:335 6
$str337 <
,33< =
nullable33> F
:33F G
false33H M
)33M N
.44 

Annotation44 #
(44# $
$str44$ 8
,448 9
$str44: @
)44@ A
,44A B
UserID55 
=55 
table55 "
.55" #
Column55# )
<55) *
string55* 0
>550 1
(551 2
type552 6
:556 7
$str558 G
,55G H
nullable55I Q
:55Q R
false55S X
)55X Y
,55Y Z

MACAddress66 
=66  
table66! &
.66& '
Column66' -
<66- .
string66. 4
>664 5
(665 6
type666 :
:66: ;
$str66< K
,66K L
nullable66M U
:66U V
true66W [
)66[ \
,66\ ]
OPCCodeToken77  
=77! "
table77# (
.77( )
Column77) /
<77/ 0
string770 6
>776 7
(777 8
type778 <
:77< =
$str77> M
,77M N
nullable77O W
:77W X
true77Y ]
)77] ^
,77^ _

DeviceType88 
=88  
table88! &
.88& '
Column88' -
<88- .
string88. 4
>884 5
(885 6
type886 :
:88: ;
$str88< K
,88K L
nullable88M U
:88U V
true88W [
)88[ \
,88\ ]
Status99 
=99 
table99 "
.99" #
Column99# )
<99) *
string99* 0
>990 1
(991 2
type992 6
:996 7
$str998 G
,99G H
nullable99I Q
:99Q R
true99S W
)99W X
,99X Y
RegisteredAt::  
=::! "
table::# (
.::( )
Column::) /
<::/ 0
DateTime::0 8
>::8 9
(::9 :
type::: >
:::> ?
$str::@ K
,::K L
nullable::M U
:::U V
false::W \
)::\ ]
};; 
,;; 
constraints<< 
:<< 
table<< "
=><<# %
{== 
table>> 
.>> 

PrimaryKey>> $
(>>$ %
$str>>% 1
,>>1 2
x>>3 4
=>>>5 7
x>>8 9
.>>9 :
DeviceID>>: B
)>>B C
;>>C D
table?? 
.?? 

ForeignKey?? $
(??$ %
name@@ 
:@@ 
$str@@ =
,@@= >
columnAA 
:AA 
xAA  !
=>AA" $
xAA% &
.AA& '
UserIDAA' -
,AA- .
principalTableBB &
:BB& '
$strBB( 5
,BB5 6
principalColumnCC '
:CC' (
$strCC) -
,CC- .
onDeleteDD  
:DD  !
ReferentialActionDD" 3
.DD3 4
CascadeDD4 ;
)DD; <
;DD< =
}EE 
)EE 
;EE 
migrationBuilderGG 
.GG 
CreateTableGG (
(GG( )
nameHH 
:HH 
$strHH %
,HH% &
columnsII 
:II 
tableII 
=>II !
newII" %
{JJ 
NotificationIDKK "
=KK# $
tableKK% *
.KK* +
ColumnKK+ 1
<KK1 2
intKK2 5
>KK5 6
(KK6 7
typeKK7 ;
:KK; <
$strKK= B
,KKB C
nullableKKD L
:KKL M
falseKKN S
)KKS T
.LL 

AnnotationLL #
(LL# $
$strLL$ 8
,LL8 9
$strLL: @
)LL@ A
,LLA B
UserIDMM 
=MM 
tableMM "
.MM" #
ColumnMM# )
<MM) *
stringMM* 0
>MM0 1
(MM1 2
typeMM2 6
:MM6 7
$strMM8 G
,MMG H
nullableMMI Q
:MMQ R
falseMMS X
)MMX Y
,MMY Z
MessageNN 
=NN 
tableNN #
.NN# $
ColumnNN$ *
<NN* +
stringNN+ 1
>NN1 2
(NN2 3
typeNN3 7
:NN7 8
$strNN9 H
,NNH I
nullableNNJ R
:NNR S
falseNNT Y
)NNY Z
,NNZ [
TypeOO 
=OO 
tableOO  
.OO  !
ColumnOO! '
<OO' (
stringOO( .
>OO. /
(OO/ 0
typeOO0 4
:OO4 5
$strOO6 E
,OOE F
nullableOOG O
:OOO P
trueOOQ U
)OOU V
,OOV W
SentAtPP 
=PP 
tablePP "
.PP" #
ColumnPP# )
<PP) *
DateTimePP* 2
>PP2 3
(PP3 4
typePP4 8
:PP8 9
$strPP: E
,PPE F
nullablePPG O
:PPO P
falsePPQ V
)PPV W
,PPW X
StatusQQ 
=QQ 
tableQQ "
.QQ" #
ColumnQQ# )
<QQ) *
stringQQ* 0
>QQ0 1
(QQ1 2
typeQQ2 6
:QQ6 7
$strQQ8 G
,QQG H
nullableQQI Q
:QQQ R
trueQQS W
)QQW X
}RR 
,RR 
constraintsSS 
:SS 
tableSS "
=>SS# %
{TT 
tableUU 
.UU 

PrimaryKeyUU $
(UU$ %
$strUU% 7
,UU7 8
xUU9 :
=>UU; =
xUU> ?
.UU? @
NotificationIDUU@ N
)UUN O
;UUO P
tableVV 
.VV 

ForeignKeyVV $
(VV$ %
nameWW 
:WW 
$strWW C
,WWC D
columnXX 
:XX 
xXX  !
=>XX" $
xXX% &
.XX& '
UserIDXX' -
,XX- .
principalTableYY &
:YY& '
$strYY( 5
,YY5 6
principalColumnZZ '
:ZZ' (
$strZZ) -
,ZZ- .
onDelete[[  
:[[  !
ReferentialAction[[" 3
.[[3 4
Cascade[[4 ;
)[[; <
;[[< =
}\\ 
)\\ 
;\\ 
migrationBuilder^^ 
.^^ 
CreateTable^^ (
(^^( )
name__ 
:__ 
$str__ *
,__* +
columns`` 
:`` 
table`` 
=>`` !
new``" %
{aa 
Idbb 
=bb 
tablebb 
.bb 
Columnbb %
<bb% &
intbb& )
>bb) *
(bb* +
typebb+ /
:bb/ 0
$strbb1 6
,bb6 7
nullablebb8 @
:bb@ A
falsebbB G
)bbG H
.cc 

Annotationcc #
(cc# $
$strcc$ 8
,cc8 9
$strcc: @
)cc@ A
,ccA B
UserIDdd 
=dd 
tabledd "
.dd" #
Columndd# )
<dd) *
stringdd* 0
>dd0 1
(dd1 2
typedd2 6
:dd6 7
$strdd8 G
,ddG H
nullableddI Q
:ddQ R
falseddS X
)ddX Y
,ddY Z
IsEmailVerifiedee #
=ee$ %
tableee& +
.ee+ ,
Columnee, 2
<ee2 3
boolee3 7
>ee7 8
(ee8 9
typeee9 =
:ee= >
$stree? D
,eeD E
nullableeeF N
:eeN O
falseeeP U
)eeU V
,eeV W"
HasSelectedServiceTypeff *
=ff+ ,
tableff- 2
.ff2 3
Columnff3 9
<ff9 :
boolff: >
>ff> ?
(ff? @
typeff@ D
:ffD E
$strffF K
,ffK L
nullableffM U
:ffU V
falseffW \
)ff\ ]
,ff] ^
HasRegisteredDevicegg '
=gg( )
tablegg* /
.gg/ 0
Columngg0 6
<gg6 7
boolgg7 ;
>gg; <
(gg< =
typegg= A
:ggA B
$strggC H
,ggH I
nullableggJ R
:ggR S
falseggT Y
)ggY Z
,ggZ [ 
HasCompletedTutorialhh (
=hh) *
tablehh+ 0
.hh0 1
Columnhh1 7
<hh7 8
boolhh8 <
>hh< =
(hh= >
typehh> B
:hhB C
$strhhD I
,hhI J
nullablehhK S
:hhS T
falsehhU Z
)hhZ [
}ii 
,ii 
constraintsjj 
:jj 
tablejj "
=>jj# %
{kk 
tablell 
.ll 

PrimaryKeyll $
(ll$ %
$strll% <
,ll< =
xll> ?
=>ll@ B
xllC D
.llD E
IdllE G
)llG H
;llH I
}mm 
)mm 
;mm 
migrationBuilderoo 
.oo 
CreateTableoo (
(oo( )
namepp 
:pp 
$strpp )
,pp) *
columnsqq 
:qq 
tableqq 
=>qq !
newqq" %
{rr 
PlanIDss 
=ss 
tabless "
.ss" #
Columnss# )
<ss) *
intss* -
>ss- .
(ss. /
typess/ 3
:ss3 4
$strss5 :
,ss: ;
nullabless< D
:ssD E
falsessF K
)ssK L
.tt 

Annotationtt #
(tt# $
$strtt$ 8
,tt8 9
$strtt: @
)tt@ A
,ttA B
UserIDuu 
=uu 
tableuu "
.uu" #
Columnuu# )
<uu) *
stringuu* 0
>uu0 1
(uu1 2
typeuu2 6
:uu6 7
$struu8 G
,uuG H
nullableuuI Q
:uuQ R
falseuuS X
)uuX Y
,uuY Z
PlanNamevv 
=vv 
tablevv $
.vv$ %
Columnvv% +
<vv+ ,
stringvv, 2
>vv2 3
(vv3 4
typevv4 8
:vv8 9
$strvv: I
,vvI J
nullablevvK S
:vvS T
falsevvU Z
)vvZ [
,vv[ \
	SpeedMbpsww 
=ww 
tableww  %
.ww% &
Columnww& ,
<ww, -
decimalww- 4
>ww4 5
(ww5 6
typeww6 :
:ww: ;
$strww< K
,wwK L
nullablewwM U
:wwU V
truewwW [
)ww[ \
}xx 
,xx 
constraintsyy 
:yy 
tableyy "
=>yy# %
{zz 
table{{ 
.{{ 

PrimaryKey{{ $
({{$ %
$str{{% ;
,{{; <
x{{= >
=>{{? A
x{{B C
.{{C D
PlanID{{D J
){{J K
;{{K L
table|| 
.|| 

ForeignKey|| $
(||$ %
name}} 
:}} 
$str}} G
,}}G H
column~~ 
:~~ 
x~~  !
=>~~" $
x~~% &
.~~& '
UserID~~' -
,~~- .
principalTable &
:& '
$str( 5
,5 6
principalColumn
ÄÄ '
:
ÄÄ' (
$str
ÄÄ) -
,
ÄÄ- .
onDelete
ÅÅ  
:
ÅÅ  !
ReferentialAction
ÅÅ" 3
.
ÅÅ3 4
Cascade
ÅÅ4 ;
)
ÅÅ; <
;
ÅÅ< =
}
ÇÇ 
)
ÇÇ 
;
ÇÇ 
migrationBuilder
ÑÑ 
.
ÑÑ 
CreateTable
ÑÑ (
(
ÑÑ( )
name
ÖÖ 
:
ÖÖ 
$str
ÖÖ )
,
ÖÖ) *
columns
ÜÜ 
:
ÜÜ 
table
ÜÜ 
=>
ÜÜ !
new
ÜÜ" %
{
áá 
Id
àà 
=
àà 
table
àà 
.
àà 
Column
àà %
<
àà% &
int
àà& )
>
àà) *
(
àà* +
type
àà+ /
:
àà/ 0
$str
àà1 6
,
àà6 7
nullable
àà8 @
:
àà@ A
false
ààB G
)
ààG H
.
ââ 

Annotation
ââ #
(
ââ# $
$str
ââ$ 8
,
ââ8 9
$str
ââ: @
)
ââ@ A
,
ââA B
Email
ää 
=
ää 
table
ää !
.
ää! "
Column
ää" (
<
ää( )
string
ää) /
>
ää/ 0
(
ää0 1
type
ää1 5
:
ää5 6
$str
ää7 F
,
ääF G
nullable
ääH P
:
ääP Q
false
ääR W
)
ääW X
,
ääX Y
Code
ãã 
=
ãã 
table
ãã  
.
ãã  !
Column
ãã! '
<
ãã' (
string
ãã( .
>
ãã. /
(
ãã/ 0
type
ãã0 4
:
ãã4 5
$str
ãã6 E
,
ããE F
nullable
ããG O
:
ããO P
false
ããQ V
)
ããV W
,
ããW X
	ExpiresAt
åå 
=
åå 
table
åå  %
.
åå% &
Column
åå& ,
<
åå, -
DateTime
åå- 5
>
åå5 6
(
åå6 7
type
åå7 ;
:
åå; <
$str
åå= H
,
ååH I
nullable
ååJ R
:
ååR S
false
ååT Y
)
ååY Z
,
ååZ [
IsUsed
çç 
=
çç 
table
çç "
.
çç" #
Column
çç# )
<
çç) *
bool
çç* .
>
çç. /
(
çç/ 0
type
çç0 4
:
çç4 5
$str
çç6 ;
,
çç; <
nullable
çç= E
:
ççE F
false
ççG L
)
ççL M
}
éé 
,
éé 
constraints
èè 
:
èè 
table
èè "
=>
èè# %
{
êê 
table
ëë 
.
ëë 

PrimaryKey
ëë $
(
ëë$ %
$str
ëë% ;
,
ëë; <
x
ëë= >
=>
ëë? A
x
ëëB C
.
ëëC D
Id
ëëD F
)
ëëF G
;
ëëG H
}
íí 
)
íí 
;
íí 
migrationBuilder
îî 
.
îî 
CreateTable
îî (
(
îî( )
name
ïï 
:
ïï 
$str
ïï '
,
ïï' (
columns
ññ 
:
ññ 
table
ññ 
=>
ññ !
new
ññ" %
{
óó 
ServiceAccountID
òò $
=
òò% &
table
òò' ,
.
òò, -
Column
òò- 3
<
òò3 4
int
òò4 7
>
òò7 8
(
òò8 9
type
òò9 =
:
òò= >
$str
òò? D
,
òòD E
nullable
òòF N
:
òòN O
false
òòP U
)
òòU V
.
ôô 

Annotation
ôô #
(
ôô# $
$str
ôô$ 8
,
ôô8 9
$str
ôô: @
)
ôô@ A
,
ôôA B
DeviceID
öö 
=
öö 
table
öö $
.
öö$ %
Column
öö% +
<
öö+ ,
int
öö, /
>
öö/ 0
(
öö0 1
type
öö1 5
:
öö5 6
$str
öö7 <
,
öö< =
nullable
öö> F
:
ööF G
false
ööH M
)
ööM N
,
ööN O
ServiceType
õõ 
=
õõ  !
table
õõ" '
.
õõ' (
Column
õõ( .
<
õõ. /
string
õõ/ 5
>
õõ5 6
(
õõ6 7
type
õõ7 ;
:
õõ; <
$str
õõ= L
,
õõL M
nullable
õõN V
:
õõV W
true
õõX \
)
õõ\ ]
,
õõ] ^
Status
úú 
=
úú 
table
úú "
.
úú" #
Column
úú# )
<
úú) *
string
úú* 0
>
úú0 1
(
úú1 2
type
úú2 6
:
úú6 7
$str
úú8 G
,
úúG H
nullable
úúI Q
:
úúQ R
true
úúS W
)
úúW X
,
úúX Y
ActivatedAt
ùù 
=
ùù  !
table
ùù" '
.
ùù' (
Column
ùù( .
<
ùù. /
DateTime
ùù/ 7
>
ùù7 8
(
ùù8 9
type
ùù9 =
:
ùù= >
$str
ùù? J
,
ùùJ K
nullable
ùùL T
:
ùùT U
false
ùùV [
)
ùù[ \
}
ûû 
,
ûû 
constraints
üü 
:
üü 
table
üü "
=>
üü# %
{
†† 
table
°° 
.
°° 

PrimaryKey
°° $
(
°°$ %
$str
°°% 9
,
°°9 :
x
°°; <
=>
°°= ?
x
°°@ A
.
°°A B
ServiceAccountID
°°B R
)
°°R S
;
°°S T
table
¢¢ 
.
¢¢ 

ForeignKey
¢¢ $
(
¢¢$ %
name
££ 
:
££ 
$str
££ C
,
££C D
column
§§ 
:
§§ 
x
§§  !
=>
§§" $
x
§§% &
.
§§& '
DeviceID
§§' /
,
§§/ 0
principalTable
•• &
:
••& '
$str
••( 1
,
••1 2
principalColumn
¶¶ '
:
¶¶' (
$str
¶¶) 3
,
¶¶3 4
onDelete
ßß  
:
ßß  !
ReferentialAction
ßß" 3
.
ßß3 4
Cascade
ßß4 ;
)
ßß; <
;
ßß< =
}
®® 
)
®® 
;
®® 
migrationBuilder
™™ 
.
™™ 
CreateTable
™™ (
(
™™( )
name
´´ 
:
´´ 
$str
´´ &
,
´´& '
columns
¨¨ 
:
¨¨ 
table
¨¨ 
=>
¨¨ !
new
¨¨" %
{
≠≠ 
TicketID
ÆÆ 
=
ÆÆ 
table
ÆÆ $
.
ÆÆ$ %
Column
ÆÆ% +
<
ÆÆ+ ,
int
ÆÆ, /
>
ÆÆ/ 0
(
ÆÆ0 1
type
ÆÆ1 5
:
ÆÆ5 6
$str
ÆÆ7 <
,
ÆÆ< =
nullable
ÆÆ> F
:
ÆÆF G
false
ÆÆH M
)
ÆÆM N
.
ØØ 

Annotation
ØØ #
(
ØØ# $
$str
ØØ$ 8
,
ØØ8 9
$str
ØØ: @
)
ØØ@ A
,
ØØA B
UserID
∞∞ 
=
∞∞ 
table
∞∞ "
.
∞∞" #
Column
∞∞# )
<
∞∞) *
string
∞∞* 0
>
∞∞0 1
(
∞∞1 2
type
∞∞2 6
:
∞∞6 7
$str
∞∞8 G
,
∞∞G H
nullable
∞∞I Q
:
∞∞Q R
false
∞∞S X
)
∞∞X Y
,
∞∞Y Z
DeviceID
±± 
=
±± 
table
±± $
.
±±$ %
Column
±±% +
<
±±+ ,
int
±±, /
>
±±/ 0
(
±±0 1
type
±±1 5
:
±±5 6
$str
±±7 <
,
±±< =
nullable
±±> F
:
±±F G
true
±±H L
)
±±L M
,
±±M N
AssignedStaffID
≤≤ #
=
≤≤$ %
table
≤≤& +
.
≤≤+ ,
Column
≤≤, 2
<
≤≤2 3
int
≤≤3 6
>
≤≤6 7
(
≤≤7 8
type
≤≤8 <
:
≤≤< =
$str
≤≤> C
,
≤≤C D
nullable
≤≤E M
:
≤≤M N
true
≤≤O S
)
≤≤S T
,
≤≤T U
Subject
≥≥ 
=
≥≥ 
table
≥≥ #
.
≥≥# $
Column
≥≥$ *
<
≥≥* +
string
≥≥+ 1
>
≥≥1 2
(
≥≥2 3
type
≥≥3 7
:
≥≥7 8
$str
≥≥9 H
,
≥≥H I
nullable
≥≥J R
:
≥≥R S
false
≥≥T Y
)
≥≥Y Z
,
≥≥Z [
Description
¥¥ 
=
¥¥  !
table
¥¥" '
.
¥¥' (
Column
¥¥( .
<
¥¥. /
string
¥¥/ 5
>
¥¥5 6
(
¥¥6 7
type
¥¥7 ;
:
¥¥; <
$str
¥¥= L
,
¥¥L M
nullable
¥¥N V
:
¥¥V W
true
¥¥X \
)
¥¥\ ]
,
¥¥] ^
Status
µµ 
=
µµ 
table
µµ "
.
µµ" #
Column
µµ# )
<
µµ) *
string
µµ* 0
>
µµ0 1
(
µµ1 2
type
µµ2 6
:
µµ6 7
$str
µµ8 G
,
µµG H
nullable
µµI Q
:
µµQ R
true
µµS W
)
µµW X
,
µµX Y
	CreatedAt
∂∂ 
=
∂∂ 
table
∂∂  %
.
∂∂% &
Column
∂∂& ,
<
∂∂, -
DateTime
∂∂- 5
>
∂∂5 6
(
∂∂6 7
type
∂∂7 ;
:
∂∂; <
$str
∂∂= H
,
∂∂H I
nullable
∂∂J R
:
∂∂R S
false
∂∂T Y
)
∂∂Y Z
}
∑∑ 
,
∑∑ 
constraints
∏∏ 
:
∏∏ 
table
∏∏ "
=>
∏∏# %
{
ππ 
table
∫∫ 
.
∫∫ 

PrimaryKey
∫∫ $
(
∫∫$ %
$str
∫∫% 8
,
∫∫8 9
x
∫∫: ;
=>
∫∫< >
x
∫∫? @
.
∫∫@ A
TicketID
∫∫A I
)
∫∫I J
;
∫∫J K
table
ªª 
.
ªª 

ForeignKey
ªª $
(
ªª$ %
name
ºº 
:
ºº 
$str
ºº D
,
ººD E
column
ΩΩ 
:
ΩΩ 
x
ΩΩ  !
=>
ΩΩ" $
x
ΩΩ% &
.
ΩΩ& '
UserID
ΩΩ' -
,
ΩΩ- .
principalTable
ææ &
:
ææ& '
$str
ææ( 5
,
ææ5 6
principalColumn
øø '
:
øø' (
$str
øø) -
,
øø- .
onDelete
¿¿  
:
¿¿  !
ReferentialAction
¿¿" 3
.
¿¿3 4
Cascade
¿¿4 ;
)
¿¿; <
;
¿¿< =
table
¡¡ 
.
¡¡ 

ForeignKey
¡¡ $
(
¡¡$ %
name
¬¬ 
:
¬¬ 
$str
¬¬ B
,
¬¬B C
column
√√ 
:
√√ 
x
√√  !
=>
√√" $
x
√√% &
.
√√& '
DeviceID
√√' /
,
√√/ 0
principalTable
ƒƒ &
:
ƒƒ& '
$str
ƒƒ( 1
,
ƒƒ1 2
principalColumn
≈≈ '
:
≈≈' (
$str
≈≈) 3
)
≈≈3 4
;
≈≈4 5
}
∆∆ 
)
∆∆ 
;
∆∆ 
migrationBuilder
»» 
.
»» 
CreateTable
»» (
(
»»( )
name
…… 
:
…… 
$str
…… $
,
……$ %
columns
   
:
   
table
   
=>
   !
new
  " %
{
ÀÀ 
PrepaidLoadID
ÃÃ !
=
ÃÃ" #
table
ÃÃ$ )
.
ÃÃ) *
Column
ÃÃ* 0
<
ÃÃ0 1
int
ÃÃ1 4
>
ÃÃ4 5
(
ÃÃ5 6
type
ÃÃ6 :
:
ÃÃ: ;
$str
ÃÃ< A
,
ÃÃA B
nullable
ÃÃC K
:
ÃÃK L
false
ÃÃM R
)
ÃÃR S
.
ÕÕ 

Annotation
ÕÕ #
(
ÕÕ# $
$str
ÕÕ$ 8
,
ÕÕ8 9
$str
ÕÕ: @
)
ÕÕ@ A
,
ÕÕA B
ServiceAccountID
ŒŒ $
=
ŒŒ% &
table
ŒŒ' ,
.
ŒŒ, -
Column
ŒŒ- 3
<
ŒŒ3 4
int
ŒŒ4 7
>
ŒŒ7 8
(
ŒŒ8 9
type
ŒŒ9 =
:
ŒŒ= >
$str
ŒŒ? D
,
ŒŒD E
nullable
ŒŒF N
:
ŒŒN O
false
ŒŒP U
)
ŒŒU V
,
ŒŒV W

LoadAmount
œœ 
=
œœ  
table
œœ! &
.
œœ& '
Column
œœ' -
<
œœ- .
decimal
œœ. 5
>
œœ5 6
(
œœ6 7
type
œœ7 ;
:
œœ; <
$str
œœ= L
,
œœL M
nullable
œœN V
:
œœV W
false
œœX ]
)
œœ] ^
,
œœ^ _
RemainingBalance
–– $
=
––% &
table
––' ,
.
––, -
Column
––- 3
<
––3 4
decimal
––4 ;
>
––; <
(
––< =
type
––= A
:
––A B
$str
––C R
,
––R S
nullable
––T \
:
––\ ]
true
––^ b
)
––b c
,
––c d
LastReloadBalance
—— %
=
——& '
table
——( -
.
——- .
Column
——. 4
<
——4 5
DateTime
——5 =
>
——= >
(
——> ?
type
——? C
:
——C D
$str
——E P
,
——P Q
nullable
——R Z
:
——Z [
true
——\ `
)
——` a
}
““ 
,
““ 
constraints
”” 
:
”” 
table
”” "
=>
””# %
{
‘‘ 
table
’’ 
.
’’ 

PrimaryKey
’’ $
(
’’$ %
$str
’’% 6
,
’’6 7
x
’’8 9
=>
’’: <
x
’’= >
.
’’> ?
PrepaidLoadID
’’? L
)
’’L M
;
’’M N
table
÷÷ 
.
÷÷ 

ForeignKey
÷÷ $
(
÷÷$ %
name
◊◊ 
:
◊◊ 
$str
◊◊ P
,
◊◊P Q
column
ÿÿ 
:
ÿÿ 
x
ÿÿ  !
=>
ÿÿ" $
x
ÿÿ% &
.
ÿÿ& '
ServiceAccountID
ÿÿ' 7
,
ÿÿ7 8
principalTable
ŸŸ &
:
ŸŸ& '
$str
ŸŸ( 9
,
ŸŸ9 :
principalColumn
⁄⁄ '
:
⁄⁄' (
$str
⁄⁄) ;
,
⁄⁄; <
onDelete
€€  
:
€€  !
ReferentialAction
€€" 3
.
€€3 4
Cascade
€€4 ;
)
€€; <
;
€€< =
}
‹‹ 
)
‹‹ 
;
‹‹ 
migrationBuilder
ﬁﬁ 
.
ﬁﬁ 
CreateTable
ﬁﬁ (
(
ﬁﬁ( )
name
ﬂﬂ 
:
ﬂﬂ 
$str
ﬂﬂ %
,
ﬂﬂ% &
columns
‡‡ 
:
‡‡ 
table
‡‡ 
=>
‡‡ !
new
‡‡" %
{
·· 
SubscriptionID
‚‚ "
=
‚‚# $
table
‚‚% *
.
‚‚* +
Column
‚‚+ 1
<
‚‚1 2
int
‚‚2 5
>
‚‚5 6
(
‚‚6 7
type
‚‚7 ;
:
‚‚; <
$str
‚‚= B
,
‚‚B C
nullable
‚‚D L
:
‚‚L M
false
‚‚N S
)
‚‚S T
.
„„ 

Annotation
„„ #
(
„„# $
$str
„„$ 8
,
„„8 9
$str
„„: @
)
„„@ A
,
„„A B
ServiceAccountID
‰‰ $
=
‰‰% &
table
‰‰' ,
.
‰‰, -
Column
‰‰- 3
<
‰‰3 4
int
‰‰4 7
>
‰‰7 8
(
‰‰8 9
type
‰‰9 =
:
‰‰= >
$str
‰‰? D
,
‰‰D E
nullable
‰‰F N
:
‰‰N O
false
‰‰P U
)
‰‰U V
,
‰‰V W
PlanID
ÂÂ 
=
ÂÂ 
table
ÂÂ "
.
ÂÂ" #
Column
ÂÂ# )
<
ÂÂ) *
int
ÂÂ* -
>
ÂÂ- .
(
ÂÂ. /
type
ÂÂ/ 3
:
ÂÂ3 4
$str
ÂÂ5 :
,
ÂÂ: ;
nullable
ÂÂ< D
:
ÂÂD E
false
ÂÂF K
)
ÂÂK L
,
ÂÂL M
UserID
ÊÊ 
=
ÊÊ 
table
ÊÊ "
.
ÊÊ" #
Column
ÊÊ# )
<
ÊÊ) *
string
ÊÊ* 0
>
ÊÊ0 1
(
ÊÊ1 2
type
ÊÊ2 6
:
ÊÊ6 7
$str
ÊÊ8 G
,
ÊÊG H
nullable
ÊÊI Q
:
ÊÊQ R
false
ÊÊS X
)
ÊÊX Y
,
ÊÊY Z
	StartDate
ÁÁ 
=
ÁÁ 
table
ÁÁ  %
.
ÁÁ% &
Column
ÁÁ& ,
<
ÁÁ, -
DateTime
ÁÁ- 5
>
ÁÁ5 6
(
ÁÁ6 7
type
ÁÁ7 ;
:
ÁÁ; <
$str
ÁÁ= H
,
ÁÁH I
nullable
ÁÁJ R
:
ÁÁR S
true
ÁÁT X
)
ÁÁX Y
,
ÁÁY Z
EndDate
ËË 
=
ËË 
table
ËË #
.
ËË# $
Column
ËË$ *
<
ËË* +
DateTime
ËË+ 3
>
ËË3 4
(
ËË4 5
type
ËË5 9
:
ËË9 :
$str
ËË; F
,
ËËF G
nullable
ËËH P
:
ËËP Q
true
ËËR V
)
ËËV W
,
ËËW X
Status
ÈÈ 
=
ÈÈ 
table
ÈÈ "
.
ÈÈ" #
Column
ÈÈ# )
<
ÈÈ) *
string
ÈÈ* 0
>
ÈÈ0 1
(
ÈÈ1 2
type
ÈÈ2 6
:
ÈÈ6 7
$str
ÈÈ8 G
,
ÈÈG H
nullable
ÈÈI Q
:
ÈÈQ R
true
ÈÈS W
)
ÈÈW X
}
ÍÍ 
,
ÍÍ 
constraints
ÎÎ 
:
ÎÎ 
table
ÎÎ "
=>
ÎÎ# %
{
ÏÏ 
table
ÌÌ 
.
ÌÌ 

PrimaryKey
ÌÌ $
(
ÌÌ$ %
$str
ÌÌ% 7
,
ÌÌ7 8
x
ÌÌ9 :
=>
ÌÌ; =
x
ÌÌ> ?
.
ÌÌ? @
SubscriptionID
ÌÌ@ N
)
ÌÌN O
;
ÌÌO P
table
ÓÓ 
.
ÓÓ 

ForeignKey
ÓÓ $
(
ÓÓ$ %
name
ÔÔ 
:
ÔÔ 
$str
ÔÔ C
,
ÔÔC D
column
 
:
 
x
  !
=>
" $
x
% &
.
& '
UserID
' -
,
- .
principalTable
ÒÒ &
:
ÒÒ& '
$str
ÒÒ( 5
,
ÒÒ5 6
principalColumn
ÚÚ '
:
ÚÚ' (
$str
ÚÚ) -
,
ÚÚ- .
onDelete
ÛÛ  
:
ÛÛ  !
ReferentialAction
ÛÛ" 3
.
ÛÛ3 4
Cascade
ÛÛ4 ;
)
ÛÛ; <
;
ÛÛ< =
table
ÙÙ 
.
ÙÙ 

ForeignKey
ÙÙ $
(
ÙÙ$ %
name
ıı 
:
ıı 
$str
ıı Q
,
ııQ R
column
ˆˆ 
:
ˆˆ 
x
ˆˆ  !
=>
ˆˆ" $
x
ˆˆ% &
.
ˆˆ& '
ServiceAccountID
ˆˆ' 7
,
ˆˆ7 8
principalTable
˜˜ &
:
˜˜& '
$str
˜˜( 9
,
˜˜9 :
principalColumn
¯¯ '
:
¯¯' (
$str
¯¯) ;
)
¯¯; <
;
¯¯< =
table
˘˘ 
.
˘˘ 

ForeignKey
˘˘ $
(
˘˘$ %
name
˙˙ 
:
˙˙ 
$str
˙˙ I
,
˙˙I J
column
˚˚ 
:
˚˚ 
x
˚˚  !
=>
˚˚" $
x
˚˚% &
.
˚˚& '
PlanID
˚˚' -
,
˚˚- .
principalTable
¸¸ &
:
¸¸& '
$str
¸¸( ;
,
¸¸; <
principalColumn
˝˝ '
:
˝˝' (
$str
˝˝) 1
)
˝˝1 2
;
˝˝2 3
}
˛˛ 
)
˛˛ 
;
˛˛ 
migrationBuilder
ÄÄ 
.
ÄÄ 
CreateTable
ÄÄ (
(
ÄÄ( )
name
ÅÅ 
:
ÅÅ 
$str
ÅÅ  
,
ÅÅ  !
columns
ÇÇ 
:
ÇÇ 
table
ÇÇ 
=>
ÇÇ !
new
ÇÇ" %
{
ÉÉ 
	InvoiceID
ÑÑ 
=
ÑÑ 
table
ÑÑ  %
.
ÑÑ% &
Column
ÑÑ& ,
<
ÑÑ, -
int
ÑÑ- 0
>
ÑÑ0 1
(
ÑÑ1 2
type
ÑÑ2 6
:
ÑÑ6 7
$str
ÑÑ8 =
,
ÑÑ= >
nullable
ÑÑ? G
:
ÑÑG H
false
ÑÑI N
)
ÑÑN O
.
ÖÖ 

Annotation
ÖÖ #
(
ÖÖ# $
$str
ÖÖ$ 8
,
ÖÖ8 9
$str
ÖÖ: @
)
ÖÖ@ A
,
ÖÖA B
SubscriptionID
ÜÜ "
=
ÜÜ# $
table
ÜÜ% *
.
ÜÜ* +
Column
ÜÜ+ 1
<
ÜÜ1 2
int
ÜÜ2 5
>
ÜÜ5 6
(
ÜÜ6 7
type
ÜÜ7 ;
:
ÜÜ; <
$str
ÜÜ= B
,
ÜÜB C
nullable
ÜÜD L
:
ÜÜL M
false
ÜÜN S
)
ÜÜS T
,
ÜÜT U
PrepaidLoadID
áá !
=
áá" #
table
áá$ )
.
áá) *
Column
áá* 0
<
áá0 1
int
áá1 4
>
áá4 5
(
áá5 6
type
áá6 :
:
áá: ;
$str
áá< A
,
ááA B
nullable
ááC K
:
ááK L
false
ááM R
)
ááR S
,
ááS T
UserID
àà 
=
àà 
table
àà "
.
àà" #
Column
àà# )
<
àà) *
string
àà* 0
>
àà0 1
(
àà1 2
type
àà2 6
:
àà6 7
$str
àà8 G
,
ààG H
nullable
ààI Q
:
ààQ R
false
ààS X
)
ààX Y
,
ààY Z
Amount
ââ 
=
ââ 
table
ââ "
.
ââ" #
Column
ââ# )
<
ââ) *
decimal
ââ* 1
>
ââ1 2
(
ââ2 3
type
ââ3 7
:
ââ7 8
$str
ââ9 H
,
ââH I
nullable
ââJ R
:
ââR S
false
ââT Y
)
ââY Z
,
ââZ [
DueDate
ää 
=
ää 
table
ää #
.
ää# $
Column
ää$ *
<
ää* +
DateTime
ää+ 3
>
ää3 4
(
ää4 5
type
ää5 9
:
ää9 :
$str
ää; F
,
ääF G
nullable
ääH P
:
ääP Q
true
ääR V
)
ääV W
,
ääW X
Status
ãã 
=
ãã 
table
ãã "
.
ãã" #
Column
ãã# )
<
ãã) *
string
ãã* 0
>
ãã0 1
(
ãã1 2
type
ãã2 6
:
ãã6 7
$str
ãã8 G
,
ããG H
nullable
ããI Q
:
ããQ R
true
ããS W
)
ããW X
,
ããX Y
	CreatedAt
åå 
=
åå 
table
åå  %
.
åå% &
Column
åå& ,
<
åå, -
DateTime
åå- 5
>
åå5 6
(
åå6 7
type
åå7 ;
:
åå; <
$str
åå= H
,
ååH I
nullable
ååJ R
:
ååR S
false
ååT Y
)
ååY Z
}
çç 
,
çç 
constraints
éé 
:
éé 
table
éé "
=>
éé# %
{
èè 
table
êê 
.
êê 

PrimaryKey
êê $
(
êê$ %
$str
êê% 2
,
êê2 3
x
êê4 5
=>
êê6 8
x
êê9 :
.
êê: ;
	InvoiceID
êê; D
)
êêD E
;
êêE F
table
ëë 
.
ëë 

ForeignKey
ëë $
(
ëë$ %
name
íí 
:
íí 
$str
íí >
,
íí> ?
column
ìì 
:
ìì 
x
ìì  !
=>
ìì" $
x
ìì% &
.
ìì& '
UserID
ìì' -
,
ìì- .
principalTable
îî &
:
îî& '
$str
îî( 5
,
îî5 6
principalColumn
ïï '
:
ïï' (
$str
ïï) -
,
ïï- .
onDelete
ññ  
:
ññ  !
ReferentialAction
ññ" 3
.
ññ3 4
Cascade
ññ4 ;
)
ññ; <
;
ññ< =
table
óó 
.
óó 

ForeignKey
óó $
(
óó$ %
name
òò 
:
òò 
$str
òò F
,
òòF G
column
ôô 
:
ôô 
x
ôô  !
=>
ôô" $
x
ôô% &
.
ôô& '
PrepaidLoadID
ôô' 4
,
ôô4 5
principalTable
öö &
:
öö& '
$str
öö( 6
,
öö6 7
principalColumn
õõ '
:
õõ' (
$str
õõ) 8
)
õõ8 9
;
õõ9 :
table
úú 
.
úú 

ForeignKey
úú $
(
úú$ %
name
ùù 
:
ùù 
$str
ùù H
,
ùùH I
column
ûû 
:
ûû 
x
ûû  !
=>
ûû" $
x
ûû% &
.
ûû& '
SubscriptionID
ûû' 5
,
ûû5 6
principalTable
üü &
:
üü& '
$str
üü( 7
,
üü7 8
principalColumn
†† '
:
††' (
$str
††) 9
)
††9 :
;
††: ;
}
°° 
)
°° 
;
°° 
migrationBuilder
££ 
.
££ 
CreateTable
££ (
(
££( )
name
§§ 
:
§§ 
$str
§§  
,
§§  !
columns
•• 
:
•• 
table
•• 
=>
•• !
new
••" %
{
¶¶ 
	PaymentID
ßß 
=
ßß 
table
ßß  %
.
ßß% &
Column
ßß& ,
<
ßß, -
int
ßß- 0
>
ßß0 1
(
ßß1 2
type
ßß2 6
:
ßß6 7
$str
ßß8 =
,
ßß= >
nullable
ßß? G
:
ßßG H
false
ßßI N
)
ßßN O
.
®® 

Annotation
®® #
(
®®# $
$str
®®$ 8
,
®®8 9
$str
®®: @
)
®®@ A
,
®®A B
	InvoiceID
©© 
=
©© 
table
©©  %
.
©©% &
Column
©©& ,
<
©©, -
int
©©- 0
>
©©0 1
(
©©1 2
type
©©2 6
:
©©6 7
$str
©©8 =
,
©©= >
nullable
©©? G
:
©©G H
false
©©I N
)
©©N O
,
©©O P
UserID
™™ 
=
™™ 
table
™™ "
.
™™" #
Column
™™# )
<
™™) *
string
™™* 0
>
™™0 1
(
™™1 2
type
™™2 6
:
™™6 7
$str
™™8 G
,
™™G H
nullable
™™I Q
:
™™Q R
false
™™S X
)
™™X Y
,
™™Y Z

AmountPaid
´´ 
=
´´  
table
´´! &
.
´´& '
Column
´´' -
<
´´- .
decimal
´´. 5
>
´´5 6
(
´´6 7
type
´´7 ;
:
´´; <
$str
´´= L
,
´´L M
nullable
´´N V
:
´´V W
false
´´X ]
)
´´] ^
,
´´^ _
PaymentMethod
¨¨ !
=
¨¨" #
table
¨¨$ )
.
¨¨) *
Column
¨¨* 0
<
¨¨0 1
string
¨¨1 7
>
¨¨7 8
(
¨¨8 9
type
¨¨9 =
:
¨¨= >
$str
¨¨? N
,
¨¨N O
nullable
¨¨P X
:
¨¨X Y
true
¨¨Z ^
)
¨¨^ _
,
¨¨_ `
ReferenceNum
≠≠  
=
≠≠! "
table
≠≠# (
.
≠≠( )
Column
≠≠) /
<
≠≠/ 0
string
≠≠0 6
>
≠≠6 7
(
≠≠7 8
type
≠≠8 <
:
≠≠< =
$str
≠≠> M
,
≠≠M N
nullable
≠≠O W
:
≠≠W X
true
≠≠Y ]
)
≠≠] ^
,
≠≠^ _
PaymentDate
ÆÆ 
=
ÆÆ  !
table
ÆÆ" '
.
ÆÆ' (
Column
ÆÆ( .
<
ÆÆ. /
DateTime
ÆÆ/ 7
>
ÆÆ7 8
(
ÆÆ8 9
type
ÆÆ9 =
:
ÆÆ= >
$str
ÆÆ? J
,
ÆÆJ K
nullable
ÆÆL T
:
ÆÆT U
false
ÆÆV [
)
ÆÆ[ \
,
ÆÆ\ ]
Status
ØØ 
=
ØØ 
table
ØØ "
.
ØØ" #
Column
ØØ# )
<
ØØ) *
string
ØØ* 0
>
ØØ0 1
(
ØØ1 2
type
ØØ2 6
:
ØØ6 7
$str
ØØ8 G
,
ØØG H
nullable
ØØI Q
:
ØØQ R
true
ØØS W
)
ØØW X
}
∞∞ 
,
∞∞ 
constraints
±± 
:
±± 
table
±± "
=>
±±# %
{
≤≤ 
table
≥≥ 
.
≥≥ 

PrimaryKey
≥≥ $
(
≥≥$ %
$str
≥≥% 2
,
≥≥2 3
x
≥≥4 5
=>
≥≥6 8
x
≥≥9 :
.
≥≥: ;
	PaymentID
≥≥; D
)
≥≥D E
;
≥≥E F
table
¥¥ 
.
¥¥ 

ForeignKey
¥¥ $
(
¥¥$ %
name
µµ 
:
µµ 
$str
µµ >
,
µµ> ?
column
∂∂ 
:
∂∂ 
x
∂∂  !
=>
∂∂" $
x
∂∂% &
.
∂∂& '
UserID
∂∂' -
,
∂∂- .
principalTable
∑∑ &
:
∑∑& '
$str
∑∑( 5
,
∑∑5 6
principalColumn
∏∏ '
:
∏∏' (
$str
∏∏) -
,
∏∏- .
onDelete
ππ  
:
ππ  !
ReferentialAction
ππ" 3
.
ππ3 4
Cascade
ππ4 ;
)
ππ; <
;
ππ< =
table
∫∫ 
.
∫∫ 

ForeignKey
∫∫ $
(
∫∫$ %
name
ªª 
:
ªª 
$str
ªª >
,
ªª> ?
column
ºº 
:
ºº 
x
ºº  !
=>
ºº" $
x
ºº% &
.
ºº& '
	InvoiceID
ºº' 0
,
ºº0 1
principalTable
ΩΩ &
:
ΩΩ& '
$str
ΩΩ( 2
,
ΩΩ2 3
principalColumn
ææ '
:
ææ' (
$str
ææ) 4
)
ææ4 5
;
ææ5 6
}
øø 
)
øø 
;
øø 
migrationBuilder
¡¡ 
.
¡¡ 
CreateIndex
¡¡ (
(
¡¡( )
name
¬¬ 
:
¬¬ 
$str
¬¬ )
,
¬¬) *
table
√√ 
:
√√ 
$str
√√  
,
√√  !
column
ƒƒ 
:
ƒƒ 
$str
ƒƒ  
)
ƒƒ  !
;
ƒƒ! "
migrationBuilder
∆∆ 
.
∆∆ 
CreateIndex
∆∆ (
(
∆∆( )
name
«« 
:
«« 
$str
«« 1
,
««1 2
table
»» 
:
»» 
$str
»» !
,
»»! "
column
…… 
:
…… 
$str
…… '
)
……' (
;
……( )
migrationBuilder
ÀÀ 
.
ÀÀ 
CreateIndex
ÀÀ (
(
ÀÀ( )
name
ÃÃ 
:
ÃÃ 
$str
ÃÃ 2
,
ÃÃ2 3
table
ÕÕ 
:
ÕÕ 
$str
ÕÕ !
,
ÕÕ! "
column
ŒŒ 
:
ŒŒ 
$str
ŒŒ (
)
ŒŒ( )
;
ŒŒ) *
migrationBuilder
–– 
.
–– 
CreateIndex
–– (
(
––( )
name
—— 
:
—— 
$str
—— *
,
——* +
table
““ 
:
““ 
$str
““ !
,
““! "
column
”” 
:
”” 
$str
””  
)
””  !
;
””! "
migrationBuilder
’’ 
.
’’ 
CreateIndex
’’ (
(
’’( )
name
÷÷ 
:
÷÷ 
$str
÷÷ /
,
÷÷/ 0
table
◊◊ 
:
◊◊ 
$str
◊◊ &
,
◊◊& '
column
ÿÿ 
:
ÿÿ 
$str
ÿÿ  
)
ÿÿ  !
;
ÿÿ! "
migrationBuilder
⁄⁄ 
.
⁄⁄ 
CreateIndex
⁄⁄ (
(
⁄⁄( )
name
€€ 
:
€€ 
$str
€€ -
,
€€- .
table
‹‹ 
:
‹‹ 
$str
‹‹ !
,
‹‹! "
column
›› 
:
›› 
$str
›› #
)
››# $
;
››$ %
migrationBuilder
ﬂﬂ 
.
ﬂﬂ 
CreateIndex
ﬂﬂ (
(
ﬂﬂ( )
name
‡‡ 
:
‡‡ 
$str
‡‡ *
,
‡‡* +
table
·· 
:
·· 
$str
·· !
,
··! "
column
‚‚ 
:
‚‚ 
$str
‚‚  
)
‚‚  !
;
‚‚! "
migrationBuilder
‰‰ 
.
‰‰ 
CreateIndex
‰‰ (
(
‰‰( )
name
ÂÂ 
:
ÂÂ 
$str
ÂÂ 8
,
ÂÂ8 9
table
ÊÊ 
:
ÊÊ 
$str
ÊÊ %
,
ÊÊ% &
column
ÁÁ 
:
ÁÁ 
$str
ÁÁ *
)
ÁÁ* +
;
ÁÁ+ ,
migrationBuilder
ÈÈ 
.
ÈÈ 
CreateIndex
ÈÈ (
(
ÈÈ( )
name
ÍÍ 
:
ÍÍ 
$str
ÍÍ 3
,
ÍÍ3 4
table
ÎÎ 
:
ÎÎ 
$str
ÎÎ (
,
ÎÎ( )
column
ÏÏ 
:
ÏÏ 
$str
ÏÏ "
)
ÏÏ" #
;
ÏÏ# $
migrationBuilder
ÓÓ 
.
ÓÓ 
CreateIndex
ÓÓ (
(
ÓÓ( )
name
ÔÔ 
:
ÔÔ 
$str
ÔÔ 3
,
ÔÔ3 4
table
 
:
 
$str
 *
,
* +
column
ÒÒ 
:
ÒÒ 
$str
ÒÒ  
)
ÒÒ  !
;
ÒÒ! "
migrationBuilder
ÛÛ 
.
ÛÛ 
CreateIndex
ÛÛ (
(
ÛÛ( )
name
ÙÙ 
:
ÙÙ 
$str
ÙÙ /
,
ÙÙ/ 0
table
ıı 
:
ıı 
$str
ıı &
,
ıı& '
column
ˆˆ 
:
ˆˆ 
$str
ˆˆ  
)
ˆˆ  !
;
ˆˆ! "
migrationBuilder
¯¯ 
.
¯¯ 
CreateIndex
¯¯ (
(
¯¯( )
name
˘˘ 
:
˘˘ 
$str
˘˘ 9
,
˘˘9 :
table
˙˙ 
:
˙˙ 
$str
˙˙ &
,
˙˙& '
column
˚˚ 
:
˚˚ 
$str
˚˚ *
)
˚˚* +
;
˚˚+ ,
migrationBuilder
˝˝ 
.
˝˝ 
CreateIndex
˝˝ (
(
˝˝( )
name
˛˛ 
:
˛˛ 
$str
˛˛ /
,
˛˛/ 0
table
ˇˇ 
:
ˇˇ 
$str
ˇˇ &
,
ˇˇ& '
column
ÄÄ 
:
ÄÄ 
$str
ÄÄ  
)
ÄÄ  !
;
ÄÄ! "
migrationBuilder
ÇÇ 
.
ÇÇ 
CreateIndex
ÇÇ (
(
ÇÇ( )
name
ÉÉ 
:
ÉÉ 
$str
ÉÉ 2
,
ÉÉ2 3
table
ÑÑ 
:
ÑÑ 
$str
ÑÑ '
,
ÑÑ' (
column
ÖÖ 
:
ÖÖ 
$str
ÖÖ "
)
ÖÖ" #
;
ÖÖ# $
migrationBuilder
áá 
.
áá 
CreateIndex
áá (
(
áá( )
name
àà 
:
àà 
$str
àà 0
,
àà0 1
table
ââ 
:
ââ 
$str
ââ '
,
ââ' (
column
ää 
:
ää 
$str
ää  
)
ää  !
;
ää! "
}
ãã 	
	protected
éé 
override
éé 
void
éé 
Down
éé  $
(
éé$ %
MigrationBuilder
éé% 5
migrationBuilder
éé6 F
)
ééF G
{
èè 	
migrationBuilder
êê 
.
êê 
	DropTable
êê &
(
êê& '
name
ëë 
:
ëë 
$str
ëë %
)
ëë% &
;
ëë& '
migrationBuilder
ìì 
.
ìì 
	DropTable
ìì &
(
ìì& '
name
îî 
:
îî 
$str
îî *
)
îî* +
;
îî+ ,
migrationBuilder
ññ 
.
ññ 
	DropTable
ññ &
(
ññ& '
name
óó 
:
óó 
$str
óó  
)
óó  !
;
óó! "
migrationBuilder
ôô 
.
ôô 
	DropTable
ôô &
(
ôô& '
name
öö 
:
öö 
$str
öö &
)
öö& '
;
öö' (
migrationBuilder
úú 
.
úú 
	DropTable
úú &
(
úú& '
name
ùù 
:
ùù 
$str
ùù )
)
ùù) *
;
ùù* +
migrationBuilder
üü 
.
üü 
	DropTable
üü &
(
üü& '
name
†† 
:
†† 
$str
††  
)
††  !
;
††! "
migrationBuilder
¢¢ 
.
¢¢ 
	DropTable
¢¢ &
(
¢¢& '
name
££ 
:
££ 
$str
££ $
)
££$ %
;
££% &
migrationBuilder
•• 
.
•• 
	DropTable
•• &
(
••& '
name
¶¶ 
:
¶¶ 
$str
¶¶ %
)
¶¶% &
;
¶¶& '
migrationBuilder
®® 
.
®® 
	DropTable
®® &
(
®®& '
name
©© 
:
©© 
$str
©© '
)
©©' (
;
©©( )
migrationBuilder
´´ 
.
´´ 
	DropTable
´´ &
(
´´& '
name
¨¨ 
:
¨¨ 
$str
¨¨ )
)
¨¨) *
;
¨¨* +
migrationBuilder
ÆÆ 
.
ÆÆ 
	DropTable
ÆÆ &
(
ÆÆ& '
name
ØØ 
:
ØØ 
$str
ØØ 
)
ØØ  
;
ØØ  !
migrationBuilder
±± 
.
±± 

DropColumn
±± '
(
±±' (
name
≤≤ 
:
≤≤ 
$str
≤≤ !
,
≤≤! "
table
≥≥ 
:
≥≥ 
$str
≥≥ $
)
≥≥$ %
;
≥≥% &
migrationBuilder
µµ 
.
µµ 

DropColumn
µµ '
(
µµ' (
name
∂∂ 
:
∂∂ 
$str
∂∂ !
,
∂∂! "
table
∑∑ 
:
∑∑ 
$str
∑∑ $
)
∑∑$ %
;
∑∑% &
migrationBuilder
ππ 
.
ππ 

DropColumn
ππ '
(
ππ' (
name
∫∫ 
:
∫∫ 
$str
∫∫  
,
∫∫  !
table
ªª 
:
ªª 
$str
ªª $
)
ªª$ %
;
ªª% &
migrationBuilder
ΩΩ 
.
ΩΩ 

DropColumn
ΩΩ '
(
ΩΩ' (
name
ææ 
:
ææ 
$str
ææ 
,
ææ 
table
øø 
:
øø 
$str
øø $
)
øø$ %
;
øø% &
migrationBuilder
¡¡ 
.
¡¡ 

DropColumn
¡¡ '
(
¡¡' (
name
¬¬ 
:
¬¬ 
$str
¬¬ 
,
¬¬ 
table
√√ 
:
√√ 
$str
√√ $
)
√√$ %
;
√√% &
}
ƒƒ 	
}
≈≈ 
}∆∆ Ï≈
bE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Migrations\20260217130633_InitialCreate.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Migrations! +
{ 
public		 

partial		 
class		 
InitialCreate		 &
:		' (
	Migration		) 2
{

 
	protected 
override 
void 
Up  "
(" #
MigrationBuilder# 3
migrationBuilder4 D
)D E
{ 	
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str #
,# $
columns 
: 
table 
=> !
new" %
{ 
Id 
= 
table 
. 
Column %
<% &
string& ,
>, -
(- .
type. 2
:2 3
$str4 C
,C D
nullableE M
:M N
falseO T
)T U
,U V
Name 
= 
table  
.  !
Column! '
<' (
string( .
>. /
(/ 0
type0 4
:4 5
$str6 E
,E F
	maxLengthG P
:P Q
$numR U
,U V
nullableW _
:_ `
truea e
)e f
,f g
NormalizedName "
=# $
table% *
.* +
Column+ 1
<1 2
string2 8
>8 9
(9 :
type: >
:> ?
$str@ O
,O P
	maxLengthQ Z
:Z [
$num\ _
,_ `
nullablea i
:i j
truek o
)o p
,p q
ConcurrencyStamp $
=% &
table' ,
., -
Column- 3
<3 4
string4 :
>: ;
(; <
type< @
:@ A
$strB Q
,Q R
nullableS [
:[ \
true] a
)a b
} 
, 
constraints 
: 
table "
=># %
{ 
table 
. 

PrimaryKey $
($ %
$str% 5
,5 6
x7 8
=>9 ;
x< =
.= >
Id> @
)@ A
;A B
} 
) 
; 
migrationBuilder 
. 
CreateTable (
(( )
name 
: 
$str #
,# $
columns 
: 
table 
=> !
new" %
{ 
Id   
=   
table   
.   
Column   %
<  % &
string  & ,
>  , -
(  - .
type  . 2
:  2 3
$str  4 C
,  C D
nullable  E M
:  M N
false  O T
)  T U
,  U V
UserName!! 
=!! 
table!! $
.!!$ %
Column!!% +
<!!+ ,
string!!, 2
>!!2 3
(!!3 4
type!!4 8
:!!8 9
$str!!: I
,!!I J
	maxLength!!K T
:!!T U
$num!!V Y
,!!Y Z
nullable!![ c
:!!c d
true!!e i
)!!i j
,!!j k
NormalizedUserName"" &
=""' (
table"") .
."". /
Column""/ 5
<""5 6
string""6 <
>""< =
(""= >
type""> B
:""B C
$str""D S
,""S T
	maxLength""U ^
:""^ _
$num""` c
,""c d
nullable""e m
:""m n
true""o s
)""s t
,""t u
Email## 
=## 
table## !
.##! "
Column##" (
<##( )
string##) /
>##/ 0
(##0 1
type##1 5
:##5 6
$str##7 F
,##F G
	maxLength##H Q
:##Q R
$num##S V
,##V W
nullable##X `
:##` a
true##b f
)##f g
,##g h
NormalizedEmail$$ #
=$$$ %
table$$& +
.$$+ ,
Column$$, 2
<$$2 3
string$$3 9
>$$9 :
($$: ;
type$$; ?
:$$? @
$str$$A P
,$$P Q
	maxLength$$R [
:$$[ \
$num$$] `
,$$` a
nullable$$b j
:$$j k
true$$l p
)$$p q
,$$q r
EmailConfirmed%% "
=%%# $
table%%% *
.%%* +
Column%%+ 1
<%%1 2
bool%%2 6
>%%6 7
(%%7 8
type%%8 <
:%%< =
$str%%> C
,%%C D
nullable%%E M
:%%M N
false%%O T
)%%T U
,%%U V
PasswordHash&&  
=&&! "
table&&# (
.&&( )
Column&&) /
<&&/ 0
string&&0 6
>&&6 7
(&&7 8
type&&8 <
:&&< =
$str&&> M
,&&M N
nullable&&O W
:&&W X
true&&Y ]
)&&] ^
,&&^ _
SecurityStamp'' !
=''" #
table''$ )
.'') *
Column''* 0
<''0 1
string''1 7
>''7 8
(''8 9
type''9 =
:''= >
$str''? N
,''N O
nullable''P X
:''X Y
true''Z ^
)''^ _
,''_ `
ConcurrencyStamp(( $
=((% &
table((' ,
.((, -
Column((- 3
<((3 4
string((4 :
>((: ;
(((; <
type((< @
:((@ A
$str((B Q
,((Q R
nullable((S [
:(([ \
true((] a
)((a b
,((b c
PhoneNumber)) 
=))  !
table))" '
.))' (
Column))( .
<)). /
string))/ 5
>))5 6
())6 7
type))7 ;
:)); <
$str))= L
,))L M
nullable))N V
:))V W
true))X \
)))\ ]
,))] ^ 
PhoneNumberConfirmed** (
=**) *
table**+ 0
.**0 1
Column**1 7
<**7 8
bool**8 <
>**< =
(**= >
type**> B
:**B C
$str**D I
,**I J
nullable**K S
:**S T
false**U Z
)**Z [
,**[ \
TwoFactorEnabled++ $
=++% &
table++' ,
.++, -
Column++- 3
<++3 4
bool++4 8
>++8 9
(++9 :
type++: >
:++> ?
$str++@ E
,++E F
nullable++G O
:++O P
false++Q V
)++V W
,++W X

LockoutEnd,, 
=,,  
table,,! &
.,,& '
Column,,' -
<,,- .
DateTimeOffset,,. <
>,,< =
(,,= >
type,,> B
:,,B C
$str,,D T
,,,T U
nullable,,V ^
:,,^ _
true,,` d
),,d e
,,,e f
LockoutEnabled-- "
=--# $
table--% *
.--* +
Column--+ 1
<--1 2
bool--2 6
>--6 7
(--7 8
type--8 <
:--< =
$str--> C
,--C D
nullable--E M
:--M N
false--O T
)--T U
,--U V
AccessFailedCount.. %
=..& '
table..( -
...- .
Column... 4
<..4 5
int..5 8
>..8 9
(..9 :
type..: >
:..> ?
$str..@ E
,..E F
nullable..G O
:..O P
false..Q V
)..V W
}// 
,// 
constraints00 
:00 
table00 "
=>00# %
{11 
table22 
.22 

PrimaryKey22 $
(22$ %
$str22% 5
,225 6
x227 8
=>229 ;
x22< =
.22= >
Id22> @
)22@ A
;22A B
}33 
)33 
;33 
migrationBuilder55 
.55 
CreateTable55 (
(55( )
name66 
:66 
$str66 (
,66( )
columns77 
:77 
table77 
=>77 !
new77" %
{88 
Id99 
=99 
table99 
.99 
Column99 %
<99% &
int99& )
>99) *
(99* +
type99+ /
:99/ 0
$str991 6
,996 7
nullable998 @
:99@ A
false99B G
)99G H
.:: 

Annotation:: #
(::# $
$str::$ 8
,::8 9
$str::: @
)::@ A
,::A B
RoleId;; 
=;; 
table;; "
.;;" #
Column;;# )
<;;) *
string;;* 0
>;;0 1
(;;1 2
type;;2 6
:;;6 7
$str;;8 G
,;;G H
nullable;;I Q
:;;Q R
false;;S X
);;X Y
,;;Y Z
	ClaimType<< 
=<< 
table<<  %
.<<% &
Column<<& ,
<<<, -
string<<- 3
><<3 4
(<<4 5
type<<5 9
:<<9 :
$str<<; J
,<<J K
nullable<<L T
:<<T U
true<<V Z
)<<Z [
,<<[ \

ClaimValue== 
===  
table==! &
.==& '
Column==' -
<==- .
string==. 4
>==4 5
(==5 6
type==6 :
:==: ;
$str==< K
,==K L
nullable==M U
:==U V
true==W [
)==[ \
}>> 
,>> 
constraints?? 
:?? 
table?? "
=>??# %
{@@ 
tableAA 
.AA 

PrimaryKeyAA $
(AA$ %
$strAA% :
,AA: ;
xAA< =
=>AA> @
xAAA B
.AAB C
IdAAC E
)AAE F
;AAF G
tableBB 
.BB 

ForeignKeyBB $
(BB$ %
nameCC 
:CC 
$strCC F
,CCF G
columnDD 
:DD 
xDD  !
=>DD" $
xDD% &
.DD& '
RoleIdDD' -
,DD- .
principalTableEE &
:EE& '
$strEE( 5
,EE5 6
principalColumnFF '
:FF' (
$strFF) -
,FF- .
onDeleteGG  
:GG  !
ReferentialActionGG" 3
.GG3 4
CascadeGG4 ;
)GG; <
;GG< =
}HH 
)HH 
;HH 
migrationBuilderJJ 
.JJ 
CreateTableJJ (
(JJ( )
nameKK 
:KK 
$strKK (
,KK( )
columnsLL 
:LL 
tableLL 
=>LL !
newLL" %
{MM 
IdNN 
=NN 
tableNN 
.NN 
ColumnNN %
<NN% &
intNN& )
>NN) *
(NN* +
typeNN+ /
:NN/ 0
$strNN1 6
,NN6 7
nullableNN8 @
:NN@ A
falseNNB G
)NNG H
.OO 

AnnotationOO #
(OO# $
$strOO$ 8
,OO8 9
$strOO: @
)OO@ A
,OOA B
UserIdPP 
=PP 
tablePP "
.PP" #
ColumnPP# )
<PP) *
stringPP* 0
>PP0 1
(PP1 2
typePP2 6
:PP6 7
$strPP8 G
,PPG H
nullablePPI Q
:PPQ R
falsePPS X
)PPX Y
,PPY Z
	ClaimTypeQQ 
=QQ 
tableQQ  %
.QQ% &
ColumnQQ& ,
<QQ, -
stringQQ- 3
>QQ3 4
(QQ4 5
typeQQ5 9
:QQ9 :
$strQQ; J
,QQJ K
nullableQQL T
:QQT U
trueQQV Z
)QQZ [
,QQ[ \

ClaimValueRR 
=RR  
tableRR! &
.RR& '
ColumnRR' -
<RR- .
stringRR. 4
>RR4 5
(RR5 6
typeRR6 :
:RR: ;
$strRR< K
,RRK L
nullableRRM U
:RRU V
trueRRW [
)RR[ \
}SS 
,SS 
constraintsTT 
:TT 
tableTT "
=>TT# %
{UU 
tableVV 
.VV 

PrimaryKeyVV $
(VV$ %
$strVV% :
,VV: ;
xVV< =
=>VV> @
xVVA B
.VVB C
IdVVC E
)VVE F
;VVF G
tableWW 
.WW 

ForeignKeyWW $
(WW$ %
nameXX 
:XX 
$strXX F
,XXF G
columnYY 
:YY 
xYY  !
=>YY" $
xYY% &
.YY& '
UserIdYY' -
,YY- .
principalTableZZ &
:ZZ& '
$strZZ( 5
,ZZ5 6
principalColumn[[ '
:[[' (
$str[[) -
,[[- .
onDelete\\  
:\\  !
ReferentialAction\\" 3
.\\3 4
Cascade\\4 ;
)\\; <
;\\< =
}]] 
)]] 
;]] 
migrationBuilder__ 
.__ 
CreateTable__ (
(__( )
name`` 
:`` 
$str`` (
,``( )
columnsaa 
:aa 
tableaa 
=>aa !
newaa" %
{bb 
LoginProvidercc !
=cc" #
tablecc$ )
.cc) *
Columncc* 0
<cc0 1
stringcc1 7
>cc7 8
(cc8 9
typecc9 =
:cc= >
$strcc? N
,ccN O
nullableccP X
:ccX Y
falseccZ _
)cc_ `
,cc` a
ProviderKeydd 
=dd  !
tabledd" '
.dd' (
Columndd( .
<dd. /
stringdd/ 5
>dd5 6
(dd6 7
typedd7 ;
:dd; <
$strdd= L
,ddL M
nullableddN V
:ddV W
falseddX ]
)dd] ^
,dd^ _
ProviderDisplayNameee '
=ee( )
tableee* /
.ee/ 0
Columnee0 6
<ee6 7
stringee7 =
>ee= >
(ee> ?
typeee? C
:eeC D
$streeE T
,eeT U
nullableeeV ^
:ee^ _
trueee` d
)eed e
,eee f
UserIdff 
=ff 
tableff "
.ff" #
Columnff# )
<ff) *
stringff* 0
>ff0 1
(ff1 2
typeff2 6
:ff6 7
$strff8 G
,ffG H
nullableffI Q
:ffQ R
falseffS X
)ffX Y
}gg 
,gg 
constraintshh 
:hh 
tablehh "
=>hh# %
{ii 
tablejj 
.jj 

PrimaryKeyjj $
(jj$ %
$strjj% :
,jj: ;
xjj< =
=>jj> @
newjjA D
{jjE F
xjjG H
.jjH I
LoginProviderjjI V
,jjV W
xjjX Y
.jjY Z
ProviderKeyjjZ e
}jjf g
)jjg h
;jjh i
tablekk 
.kk 

ForeignKeykk $
(kk$ %
namell 
:ll 
$strll F
,llF G
columnmm 
:mm 
xmm  !
=>mm" $
xmm% &
.mm& '
UserIdmm' -
,mm- .
principalTablenn &
:nn& '
$strnn( 5
,nn5 6
principalColumnoo '
:oo' (
$stroo) -
,oo- .
onDeletepp  
:pp  !
ReferentialActionpp" 3
.pp3 4
Cascadepp4 ;
)pp; <
;pp< =
}qq 
)qq 
;qq 
migrationBuilderss 
.ss 
CreateTabless (
(ss( )
namett 
:tt 
$strtt '
,tt' (
columnsuu 
:uu 
tableuu 
=>uu !
newuu" %
{vv 
UserIdww 
=ww 
tableww "
.ww" #
Columnww# )
<ww) *
stringww* 0
>ww0 1
(ww1 2
typeww2 6
:ww6 7
$strww8 G
,wwG H
nullablewwI Q
:wwQ R
falsewwS X
)wwX Y
,wwY Z
RoleIdxx 
=xx 
tablexx "
.xx" #
Columnxx# )
<xx) *
stringxx* 0
>xx0 1
(xx1 2
typexx2 6
:xx6 7
$strxx8 G
,xxG H
nullablexxI Q
:xxQ R
falsexxS X
)xxX Y
}yy 
,yy 
constraintszz 
:zz 
tablezz "
=>zz# %
{{{ 
table|| 
.|| 

PrimaryKey|| $
(||$ %
$str||% 9
,||9 :
x||; <
=>||= ?
new||@ C
{||D E
x||F G
.||G H
UserId||H N
,||N O
x||P Q
.||Q R
RoleId||R X
}||Y Z
)||Z [
;||[ \
table}} 
.}} 

ForeignKey}} $
(}}$ %
name~~ 
:~~ 
$str~~ E
,~~E F
column 
: 
x  !
=>" $
x% &
.& '
RoleId' -
,- .
principalTable
ÄÄ &
:
ÄÄ& '
$str
ÄÄ( 5
,
ÄÄ5 6
principalColumn
ÅÅ '
:
ÅÅ' (
$str
ÅÅ) -
,
ÅÅ- .
onDelete
ÇÇ  
:
ÇÇ  !
ReferentialAction
ÇÇ" 3
.
ÇÇ3 4
Cascade
ÇÇ4 ;
)
ÇÇ; <
;
ÇÇ< =
table
ÉÉ 
.
ÉÉ 

ForeignKey
ÉÉ $
(
ÉÉ$ %
name
ÑÑ 
:
ÑÑ 
$str
ÑÑ E
,
ÑÑE F
column
ÖÖ 
:
ÖÖ 
x
ÖÖ  !
=>
ÖÖ" $
x
ÖÖ% &
.
ÖÖ& '
UserId
ÖÖ' -
,
ÖÖ- .
principalTable
ÜÜ &
:
ÜÜ& '
$str
ÜÜ( 5
,
ÜÜ5 6
principalColumn
áá '
:
áá' (
$str
áá) -
,
áá- .
onDelete
àà  
:
àà  !
ReferentialAction
àà" 3
.
àà3 4
Cascade
àà4 ;
)
àà; <
;
àà< =
}
ââ 
)
ââ 
;
ââ 
migrationBuilder
ãã 
.
ãã 
CreateTable
ãã (
(
ãã( )
name
åå 
:
åå 
$str
åå (
,
åå( )
columns
çç 
:
çç 
table
çç 
=>
çç !
new
çç" %
{
éé 
UserId
èè 
=
èè 
table
èè "
.
èè" #
Column
èè# )
<
èè) *
string
èè* 0
>
èè0 1
(
èè1 2
type
èè2 6
:
èè6 7
$str
èè8 G
,
èèG H
nullable
èèI Q
:
èèQ R
false
èèS X
)
èèX Y
,
èèY Z
LoginProvider
êê !
=
êê" #
table
êê$ )
.
êê) *
Column
êê* 0
<
êê0 1
string
êê1 7
>
êê7 8
(
êê8 9
type
êê9 =
:
êê= >
$str
êê? N
,
êêN O
nullable
êêP X
:
êêX Y
false
êêZ _
)
êê_ `
,
êê` a
Name
ëë 
=
ëë 
table
ëë  
.
ëë  !
Column
ëë! '
<
ëë' (
string
ëë( .
>
ëë. /
(
ëë/ 0
type
ëë0 4
:
ëë4 5
$str
ëë6 E
,
ëëE F
nullable
ëëG O
:
ëëO P
false
ëëQ V
)
ëëV W
,
ëëW X
Value
íí 
=
íí 
table
íí !
.
íí! "
Column
íí" (
<
íí( )
string
íí) /
>
íí/ 0
(
íí0 1
type
íí1 5
:
íí5 6
$str
íí7 F
,
ííF G
nullable
ííH P
:
ííP Q
true
ííR V
)
ííV W
}
ìì 
,
ìì 
constraints
îî 
:
îî 
table
îî "
=>
îî# %
{
ïï 
table
ññ 
.
ññ 

PrimaryKey
ññ $
(
ññ$ %
$str
ññ% :
,
ññ: ;
x
ññ< =
=>
ññ> @
new
ññA D
{
ññE F
x
ññG H
.
ññH I
UserId
ññI O
,
ññO P
x
ññQ R
.
ññR S
LoginProvider
ññS `
,
ññ` a
x
ññb c
.
ññc d
Name
ññd h
}
ññi j
)
ññj k
;
ññk l
table
óó 
.
óó 

ForeignKey
óó $
(
óó$ %
name
òò 
:
òò 
$str
òò F
,
òòF G
column
ôô 
:
ôô 
x
ôô  !
=>
ôô" $
x
ôô% &
.
ôô& '
UserId
ôô' -
,
ôô- .
principalTable
öö &
:
öö& '
$str
öö( 5
,
öö5 6
principalColumn
õõ '
:
õõ' (
$str
õõ) -
,
õõ- .
onDelete
úú  
:
úú  !
ReferentialAction
úú" 3
.
úú3 4
Cascade
úú4 ;
)
úú; <
;
úú< =
}
ùù 
)
ùù 
;
ùù 
migrationBuilder
üü 
.
üü 
CreateIndex
üü (
(
üü( )
name
†† 
:
†† 
$str
†† 2
,
††2 3
table
°° 
:
°° 
$str
°° )
,
°°) *
column
¢¢ 
:
¢¢ 
$str
¢¢  
)
¢¢  !
;
¢¢! "
migrationBuilder
§§ 
.
§§ 
CreateIndex
§§ (
(
§§( )
name
•• 
:
•• 
$str
•• %
,
••% &
table
¶¶ 
:
¶¶ 
$str
¶¶ $
,
¶¶$ %
column
ßß 
:
ßß 
$str
ßß (
,
ßß( )
unique
®® 
:
®® 
true
®® 
,
®® 
filter
©© 
:
©© 
$str
©© 6
)
©©6 7
;
©©7 8
migrationBuilder
´´ 
.
´´ 
CreateIndex
´´ (
(
´´( )
name
¨¨ 
:
¨¨ 
$str
¨¨ 2
,
¨¨2 3
table
≠≠ 
:
≠≠ 
$str
≠≠ )
,
≠≠) *
column
ÆÆ 
:
ÆÆ 
$str
ÆÆ  
)
ÆÆ  !
;
ÆÆ! "
migrationBuilder
∞∞ 
.
∞∞ 
CreateIndex
∞∞ (
(
∞∞( )
name
±± 
:
±± 
$str
±± 2
,
±±2 3
table
≤≤ 
:
≤≤ 
$str
≤≤ )
,
≤≤) *
column
≥≥ 
:
≥≥ 
$str
≥≥  
)
≥≥  !
;
≥≥! "
migrationBuilder
µµ 
.
µµ 
CreateIndex
µµ (
(
µµ( )
name
∂∂ 
:
∂∂ 
$str
∂∂ 1
,
∂∂1 2
table
∑∑ 
:
∑∑ 
$str
∑∑ (
,
∑∑( )
column
∏∏ 
:
∏∏ 
$str
∏∏  
)
∏∏  !
;
∏∏! "
migrationBuilder
∫∫ 
.
∫∫ 
CreateIndex
∫∫ (
(
∫∫( )
name
ªª 
:
ªª 
$str
ªª "
,
ªª" #
table
ºº 
:
ºº 
$str
ºº $
,
ºº$ %
column
ΩΩ 
:
ΩΩ 
$str
ΩΩ )
)
ΩΩ) *
;
ΩΩ* +
migrationBuilder
øø 
.
øø 
CreateIndex
øø (
(
øø( )
name
¿¿ 
:
¿¿ 
$str
¿¿ %
,
¿¿% &
table
¡¡ 
:
¡¡ 
$str
¡¡ $
,
¡¡$ %
column
¬¬ 
:
¬¬ 
$str
¬¬ ,
,
¬¬, -
unique
√√ 
:
√√ 
true
√√ 
,
√√ 
filter
ƒƒ 
:
ƒƒ 
$str
ƒƒ :
)
ƒƒ: ;
;
ƒƒ; <
}
≈≈ 	
	protected
»» 
override
»» 
void
»» 
Down
»»  $
(
»»$ %
MigrationBuilder
»»% 5
migrationBuilder
»»6 F
)
»»F G
{
…… 	
migrationBuilder
   
.
   
	DropTable
   &
(
  & '
name
ÀÀ 
:
ÀÀ 
$str
ÀÀ (
)
ÀÀ( )
;
ÀÀ) *
migrationBuilder
ÕÕ 
.
ÕÕ 
	DropTable
ÕÕ &
(
ÕÕ& '
name
ŒŒ 
:
ŒŒ 
$str
ŒŒ (
)
ŒŒ( )
;
ŒŒ) *
migrationBuilder
–– 
.
–– 
	DropTable
–– &
(
––& '
name
—— 
:
—— 
$str
—— (
)
——( )
;
——) *
migrationBuilder
”” 
.
”” 
	DropTable
”” &
(
””& '
name
‘‘ 
:
‘‘ 
$str
‘‘ '
)
‘‘' (
;
‘‘( )
migrationBuilder
÷÷ 
.
÷÷ 
	DropTable
÷÷ &
(
÷÷& '
name
◊◊ 
:
◊◊ 
$str
◊◊ (
)
◊◊( )
;
◊◊) *
migrationBuilder
ŸŸ 
.
ŸŸ 
	DropTable
ŸŸ &
(
ŸŸ& '
name
⁄⁄ 
:
⁄⁄ 
$str
⁄⁄ #
)
⁄⁄# $
;
⁄⁄$ %
migrationBuilder
‹‹ 
.
‹‹ 
	DropTable
‹‹ &
(
‹‹& '
name
›› 
:
›› 
$str
›› #
)
››# $
;
››$ %
}
ﬁﬁ 	
}
ﬂﬂ 
}‡‡ Æb
TE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Data\ApplicationDbContext.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Data! %
{ 
public 

class  
ApplicationDbContext %
:& '
IdentityDbContext( 9
<9 :
ApplicationUser: I
>I J
{ 
public		  
ApplicationDbContext		 #
(		# $
DbContextOptions		$ 4
<		4 5 
ApplicationDbContext		5 I
>		I J
options		K R
)		R S
:		T U
base		V Z
(		Z [
options		[ b
)		b c
{		d e
}		f g
public 
DbSet 
< 
Device 
> 
Devices $
{% &
get' *
;* +
set, /
;/ 0
}1 2
public 
DbSet 
< 
SupportTicket "
>" #
SupportTickets$ 2
{3 4
get5 8
;8 9
set: =
;= >
}? @
public 
DbSet 
< 
TicketReply  
>  !
TicketReplies" /
{0 1
get2 5
;5 6
set7 :
;: ;
}< =
public 
DbSet 
< 
Notification !
>! "
Notifications# 0
{1 2
get3 6
;6 7
set8 ;
;; <
}= >
public 
DbSet 
< 
ServiceAccount #
># $
ServiceAccounts% 4
{5 6
get7 :
;: ;
set< ?
;? @
}A B
public 
DbSet 
< 
SubscriptionPlan %
>% &
SubscriptionPlans' 8
{9 :
get; >
;> ?
set@ C
;C D
}E F
public 
DbSet 
< 
Subscription !
>! "
Subscriptions# 0
{1 2
get3 6
;6 7
set8 ;
;; <
}= >
public 
DbSet 
< 
PrepaidLoad  
>  !
PrepaidLoads" .
{/ 0
get1 4
;4 5
set6 9
;9 :
}; <
public 
DbSet 
< 
PrepaidPromo !
>! "
PrepaidPromos# 0
{1 2
get3 6
;6 7
set8 ;
;; <
}= >
public 
DbSet 
< 
Invoice 
> 
Invoices &
{' (
get) ,
;, -
set. 1
;1 2
}3 4
public 
DbSet 
< 
Payment 
> 
Payments &
{' (
get) ,
;, -
set. 1
;1 2
}3 4
public 
DbSet 
< 
VerificationCode %
>% &
VerificationCodes' 8
{9 :
get; >
;> ?
set@ C
;C D
}E F
public 
DbSet 
< 
OnboardingStatus %
>% &
OnboardingStatuses' 9
{: ;
get< ?
;? @
setA D
;D E
}F G
public 
DbSet 
< 
SavedPaymentMethod '
>' (
SavedPaymentMethods) <
{= >
get? B
;B C
setD G
;G H
}I J
public 
DbSet 
< 
Addon 
> 
Addons "
{# $
get% (
;( )
set* -
;- .
}/ 0
public 
DbSet 
< 
	UserAddon 
> 

UserAddons  *
{+ ,
get- 0
;0 1
set2 5
;5 6
}7 8
public 
DbSet 
< 
ActivityLog  
>  !
ActivityLogs" .
{/ 0
get1 4
;4 5
set6 9
;9 :
}; <
public 
DbSet 
< 
FAQ 
> 
FAQs 
{  
get! $
;$ %
set& )
;) *
}+ ,
public 
DbSet 
< 
LoginHistory !
>! "
LoginHistory# /
{0 1
get2 5
;5 6
set7 :
;: ;
}< =
public 
DbSet 
< "
NotificationPreference +
>+ ,#
NotificationPreferences- D
{E F
getG J
;J K
setL O
;O P
}Q R
public 
DbSet 
< 

PromoOffer 
>  
PromoOffers! ,
{- .
get/ 2
;2 3
set4 7
;7 8
}9 :
public   
DbSet   
<   
RolePermission   #
>  # $
RolePermissions  % 4
{  5 6
get  7 :
;  : ;
set  < ?
;  ? @
}  A B
public!! 
DbSet!! 
<!! 
SystemSettings!! #
>!!# $
SystemSettings!!% 3
{!!4 5
get!!6 9
;!!9 :
set!!; >
;!!> ?
}!!@ A
public"" 
DbSet"" 
<"" 
LoginAttempt"" !
>""! "
LoginAttempts""# 0
{""1 2
get""3 6
;""6 7
set""8 ;
;""; <
}""= >
	protected$$ 
override$$ 
void$$ 
OnModelCreating$$  /
($$/ 0
ModelBuilder$$0 <
builder$$= D
)$$D E
{%% 	
base&& 
.&& 
OnModelCreating&&  
(&&  !
builder&&! (
)&&( )
;&&) *
builder(( 
.(( 
Entity(( 
<(( 
Device(( !
>((! "
(((" #
)((# $
.)) 
Property)) 
()) 
d)) 
=>)) 
d))  
.))  !
UserID))! '
)))' (
.** 
HasColumnName** 
(** 
$str** '
)**' (
;**( )
builder,, 
.,, 
Entity,, 
<,, 
Subscription,, '
>,,' (
(,,( )
),,) *
.-- 
Property-- 
(-- 
s-- 
=>-- 
s--  
.--  !
UserID--! '
)--' (
... 
HasColumnName.. 
(.. 
$str.. '
)..' (
;..( )
builder00 
.00 
Entity00 
<00 
Subscription00 '
>00' (
(00( )
)00) *
.11 
HasOne11 
(11 
s11 
=>11 
s11 
.11 
ServiceAccount11 -
)11- .
.22 
WithMany22 
(22 
sa22 
=>22 
sa22  "
.22" #
Subscriptions22# 0
)220 1
.33 
OnDelete33 
(33 
DeleteBehavior33 (
.33( )
NoAction33) 1
)331 2
;332 3
builder55 
.55 
Entity55 
<55 
Subscription55 '
>55' (
(55( )
)55) *
.66 
HasOne66 
(66 
s66 
=>66 
s66 
.66 
Plan66 #
)66# $
.77 
WithMany77 
(77 
p77 
=>77 
p77  
.77  !
Subscriptions77! .
)77. /
.88 
OnDelete88 
(88 
DeleteBehavior88 (
.88( )
NoAction88) 1
)881 2
;882 3
builder:: 
.:: 
Entity:: 
<:: 
Invoice:: "
>::" #
(::# $
)::$ %
.;; 
HasOne;; 
(;; 
i;; 
=>;; 
i;; 
.;; 
Subscription;; +
);;+ ,
.<< 
WithMany<< 
(<< 
s<< 
=><< 
s<<  
.<<  !
Invoices<<! )
)<<) *
.== 
OnDelete== 
(== 
DeleteBehavior== (
.==( )
Cascade==) 0
)==0 1
;==1 2
builder?? 
.?? 
Entity?? 
<?? 
Invoice?? "
>??" #
(??# $
)??$ %
.@@ 
HasOne@@ 
(@@ 
i@@ 
=>@@ 
i@@ 
.@@ 
PrepaidLoad@@ *
)@@* +
.AA 
WithManyAA 
(AA 
)AA 
.BB 
OnDeleteBB 
(BB 
DeleteBehaviorBB (
.BB( )
NoActionBB) 1
)BB1 2
;BB2 3
builderDD 
.DD 
EntityDD 
<DD 
PaymentDD "
>DD" #
(DD# $
)DD$ %
.EE 
HasOneEE 
(EE 
pEE 
=>EE 
pEE 
.EE 
InvoiceEE &
)EE& '
.FF 
WithManyFF 
(FF 
iFF 
=>FF 
iFF  
.FF  !
PaymentsFF! )
)FF) *
.GG 
OnDeleteGG 
(GG 
DeleteBehaviorGG (
.GG( )
CascadeGG) 0
)GG0 1
;GG1 2
builderII 
.II 
EntityII 
<II 
TicketReplyII &
>II& '
(II' (
)II( )
.JJ 
HasOneJJ 
(JJ 
rJJ 
=>JJ 
rJJ 
.JJ 
TicketJJ %
)JJ% &
.KK 
WithManyKK 
(KK 
tKK 
=>KK 
tKK  
.KK  !
RepliesKK! (
)KK( )
.LL 
OnDeleteLL 
(LL 
DeleteBehaviorLL (
.LL( )
NoActionLL) 1
)LL1 2
;LL2 3
builderNN 
.NN 
EntityNN 
<NN 
PrepaidPromoNN '
>NN' (
(NN( )
)NN) *
.OO 
HasOneOO 
(OO 
ppOO 
=>OO 
ppOO  
.OO  !
PrepaidLoadOO! ,
)OO, -
.PP 
WithManyPP 
(PP 
)PP 
.QQ 
HasForeignKeyQQ 
(QQ 
ppQQ !
=>QQ" $
ppQQ% '
.QQ' (
PrepaidLoadIDQQ( 5
)QQ5 6
.RR 
OnDeleteRR 
(RR 
DeleteBehaviorRR (
.RR( )
NoActionRR) 1
)RR1 2
;RR2 3
builderTT 
.TT 
EntityTT 
<TT 
PrepaidPromoTT '
>TT' (
(TT( )
)TT) *
.UU 
HasOneUU 
(UU 
ppUU 
=>UU 
ppUU  
.UU  !
UserUU! %
)UU% &
.VV 
WithManyVV 
(VV 
)VV 
.WW 
HasForeignKeyWW 
(WW 
ppWW !
=>WW" $
ppWW% '
.WW' (
UserIDWW( .
)WW. /
.XX 
OnDeleteXX 
(XX 
DeleteBehaviorXX (
.XX( )
NoActionXX) 1
)XX1 2
;XX2 3
builderZZ 
.ZZ 
EntityZZ 
<ZZ 
RolePermissionZZ )
>ZZ) *
(ZZ* +
)ZZ+ ,
.[[ 
HasKey[[ 
([[ 
rp[[ 
=>[[ 
rp[[  
.[[  !
RolePermissionID[[! 1
)[[1 2
;[[2 3
builder]] 
.]] 
Entity]] 
<]] 
RolePermission]] )
>]]) *
(]]* +
)]]+ ,
.^^ 
HasIndex^^ 
(^^ 
rp^^ 
=>^^ 
new^^  #
{^^$ %
rp^^& (
.^^( )
RoleName^^) 1
,^^1 2
rp^^3 5
.^^5 6
PermissionName^^6 D
}^^E F
)^^F G
.__ 
IsUnique__ 
(__ 
)__ 
;__ 
}`` 	
}aa 
}bb »
UE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\TestController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public 

class 
TestController 
:  !
ControllerBase" 0
{ 
[		 	
HttpGet			 
]		 
public

 
IActionResult

 
Get

  
(

  !
)

! "
{ 	
return 
Ok 
( 
new 
{ 
message #
=$ %
$str& G
,G H
	timestampI R
=S T
DateTimeU ]
.] ^
Now^ a
}b c
)c d
;d e
} 	
} 
} ﬂ
VE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\PlansController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public		 

class		 
PlansController		  
:		! "
ControllerBase		# 1
{

 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
public 
PlansController 
(  
ApplicationDbContext 3
context4 ;
); <
{ 	
_context 
= 
context 
; 
} 	
[ 	
HttpGet	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (

CheckPlans) 3
(3 4
)4 5
{ 	
var 
hasPlans 
= 
await  
_context! )
.) *
SubscriptionPlans* ;
.; <
AnyAsync< D
(D E
)E F
;F G
return 
Ok 
( 
new 
{ 
hasPlans $
}% &
)& '
;' (
} 	
[ 	
HttpGet	 
] 
public 
async 
Task 
< 
IActionResult '
>' (
GetPlans) 1
(1 2
)2 3
{ 	
var 
plans 
= 
await 
_context &
.& '
SubscriptionPlans' 8
.8 9
ToListAsync9 D
(D E
)E F
;F G
return 
Ok 
( 
plans 
) 
; 
} 	
[   	
HttpGet  	 
(   
$str   
)    
]    !
public!! 
async!! 
Task!! 
<!! 
IActionResult!! '
>!!' (
GetPromoOffers!!) 7
(!!7 8
)!!8 9
{"" 	
var## 
offers## 
=## 
await## 
_context## '
.##' (
PromoOffers##( 3
.$$ 
Where$$ 
($$ 
o$$ 
=>$$ 
o$$ 
.$$ 
IsActive$$ &
)$$& '
.%% 
OrderByDescending%% "
(%%" #
o%%# $
=>%%% '
o%%( )
.%%) *
	CreatedAt%%* 3
)%%3 4
.&& 
Select&& 
(&& 
o&& 
=>&& 
new&&  
{'' 
o(( 
.(( 
PromoOfferID(( "
,((" #
o)) 
.)) 
Title)) 
,)) 
o** 
.** 
Description** !
,**! "
o++ 
.++ 
Price++ 
,++ 
o,, 
.,, 
Data,, 
,,, 
o-- 
.-- 
Validity-- 
,-- 
o.. 
... 
Badge.. 
,.. 
o// 
.// 
Color// 
}00 
)00 
.11 
ToListAsync11 
(11 
)11 
;11 
return22 
Ok22 
(22 
offers22 
)22 
;22 
}33 	
}44 
}55 Í	
XE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\PaymentController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
	Authorize 
] 
[		 
ApiController		 
]		 
[

 
Route

 

(


 
$str

 
)

 
]

 
public 

class 
PaymentController "
:# $
ControllerBase% 3
{ 
public 
PaymentController  
(  !
)! "
{ 	
} 	
[ 	
HttpPost	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (
CreatePayment) 6
(6 7
[7 8
FromBody8 @
]@ A
PaymentRequestB P
requestQ X
)X Y
{ 	
return 
Ok 
( 
new 
{ 
message #
=$ %
$str& C
}D E
)E F
;F G
} 	
} 
} œø
YE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\CustomerController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
	Authorize 
] 
[ $
RequireEmailVerification 
] 
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public 

class 
CustomerController #
:$ %
ControllerBase& 4
{ 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
private 
readonly 
UserManager $
<$ %
ApplicationUser% 4
>4 5
_userManager6 B
;B C
private 
readonly 
PayMongoService (
_payMongoService) 9
;9 :
private 
readonly 
EmailService %
_emailService& 3
;3 4
private 
readonly 
IConfiguration '
_configuration( 6
;6 7
private 
readonly 
IHttpClientFactory +
_httpClientFactory, >
;> ?
public 
CustomerController !
(! " 
ApplicationDbContext" 6
context7 >
,> ?
UserManager@ K
<K L
ApplicationUserL [
>[ \
userManager] h
,h i
PayMongoServicej y
payMongoService	z â
,
â ä
EmailService
ã ó
emailService
ò §
,
§ •
IConfiguration
¶ ¥
configuration
µ ¬
,
¬ √ 
IHttpClientFactory
ƒ ÷
httpClientFactory
◊ Ë
)
Ë È
{ 	
_context 
= 
context 
; 
_userManager 
= 
userManager &
;& '
_payMongoService 
= 
payMongoService .
;. /
_emailService   
=   
emailService   (
;  ( )
_configuration!! 
=!! 
configuration!! *
;!!* +
_httpClientFactory"" 
=""  
httpClientFactory""! 2
;""2 3
}## 	
[%% 	
HttpGet%%	 
(%% 
$str%% 
)%% 
]%% 
public&& 
async&& 
Task&& 
<&& 
IActionResult&& '
>&&' (

GetProfile&&) 3
(&&3 4
)&&4 5
{'' 	
var(( 
userId(( 
=(( 
User(( 
.(( 
	FindFirst(( '
(((' (
System((( .
.((. /
Security((/ 7
.((7 8
Claims((8 >
.((> ?

ClaimTypes((? I
.((I J
NameIdentifier((J X
)((X Y
?((Y Z
.((Z [
Value(([ `
;((` a
var)) 
user)) 
=)) 
await)) 
_userManager)) )
.))) *
FindByIdAsync))* 7
())7 8
userId))8 >
!))> ?
)))? @
;))@ A
if** 
(** 
user** 
==** 
null** 
)** 
return** $
NotFound**% -
(**- .
)**. /
;**/ 0
return,, 
Ok,, 
(,, 
new,, 
{,, 
id-- 
=-- 
user-- 
.-- 
Id-- 
,-- 
	firstName.. 
=.. 
user..  
...  !
	FirstName..! *
,..* +
lastName// 
=// 
user// 
.//  
LastName//  (
,//( )
email00 
=00 
user00 
.00 
Email00 "
,00" #
birthday11 
=11 
user11 
.11  
Birthday11  (
,11( )
address22 
=22 
user22 
.22 
Address22 &
,22& '
profilePictureUrl33 !
=33" #
user33$ (
.33( )
ProfilePictureUrl33) :
,33: ;
status44 
=44 
user44 
.44 
Status44 $
,44$ %
role55 
=55 
user55 
.55 
Role55  
,55  !
	createdAt66 
=66 
user66  
.66  !
	CreatedAt66! *
}77 
)77 
;77 
}88 	
[:: 	
HttpPut::	 
(:: 
$str:: 
):: 
]:: 
public;; 
async;; 
Task;; 
<;; 
IActionResult;; '
>;;' (
UpdateProfile;;) 6
(;;6 7
[;;7 8
FromBody;;8 @
];;@ A 
UpdateProfileRequest;;B V
request;;W ^
);;^ _
{<< 	
var== 
userId== 
=== 
User== 
.== 
	FindFirst== '
(==' (
System==( .
.==. /
Security==/ 7
.==7 8
Claims==8 >
.==> ?

ClaimTypes==? I
.==I J
NameIdentifier==J X
)==X Y
?==Y Z
.==Z [
Value==[ `
;==` a
var>> 
user>> 
=>> 
await>> 
_userManager>> )
.>>) *
FindByIdAsync>>* 7
(>>7 8
userId>>8 >
!>>> ?
)>>? @
;>>@ A
if?? 
(?? 
user?? 
==?? 
null?? 
)?? 
return?? $
NotFound??% -
(??- .
)??. /
;??/ 0
userAA 
.AA 
	FirstNameAA 
=AA 
requestAA $
.AA$ %
	FirstNameAA% .
;AA. /
userBB 
.BB 
LastNameBB 
=BB 
requestBB #
.BB# $
LastNameBB$ ,
;BB, -
ifCC 
(CC 
!CC 
stringCC 
.CC 
IsNullOrEmptyCC %
(CC% &
requestCC& -
.CC- .
BirthdayCC. 6
)CC6 7
)CC7 8
userDD 
.DD 
BirthdayDD 
=DD 
DateTimeDD  (
.DD( )
ParseDD) .
(DD. /
requestDD/ 6
.DD6 7
BirthdayDD7 ?
)DD? @
;DD@ A
ifEE 
(EE 
!EE 
stringEE 
.EE 
IsNullOrEmptyEE %
(EE% &
requestEE& -
.EE- .
AddressEE. 5
)EE5 6
)EE6 7
userFF 
.FF 
AddressFF 
=FF 
requestFF &
.FF& '
AddressFF' .
;FF. /
awaitHH 
_userManagerHH 
.HH 
UpdateAsyncHH *
(HH* +
userHH+ /
)HH/ 0
;HH0 1
returnJJ 
OkJJ 
(JJ 
newJJ 
{JJ 
messageJJ #
=JJ$ %
$strJJ& D
}JJE F
)JJF G
;JJG H
}KK 	
[MM 	
HttpPutMM	 
(MM 
$strMM  
)MM  !
]MM! "
publicNN 
asyncNN 
TaskNN 
<NN 
IActionResultNN '
>NN' (
UpdateProfilePhotoNN) ;
(NN; <
[NN< =
FromBodyNN= E
]NNE F%
UpdateProfilePhotoRequestNNG `
requestNNa h
)NNh i
{OO 	
varPP 
userIdPP 
=PP 
UserPP 
.PP 
	FindFirstPP '
(PP' (
SystemPP( .
.PP. /
SecurityPP/ 7
.PP7 8
ClaimsPP8 >
.PP> ?

ClaimTypesPP? I
.PPI J
NameIdentifierPPJ X
)PPX Y
?PPY Z
.PPZ [
ValuePP[ `
;PP` a
varQQ 
userQQ 
=QQ 
awaitQQ 
_userManagerQQ )
.QQ) *
FindByIdAsyncQQ* 7
(QQ7 8
userIdQQ8 >
!QQ> ?
)QQ? @
;QQ@ A
ifRR 
(RR 
userRR 
==RR 
nullRR 
)RR 
returnRR $
NotFoundRR% -
(RR- .
)RR. /
;RR/ 0
userTT 
.TT 
ProfilePictureUrlTT "
=TT# $
requestTT% ,
.TT, -
PhotoUrlTT- 5
;TT5 6
awaitUU 
_userManagerUU 
.UU 
UpdateAsyncUU *
(UU* +
userUU+ /
)UU/ 0
;UU0 1
returnWW 
OkWW 
(WW 
newWW 
{WW 
messageWW #
=WW$ %
$strWW& J
,WWJ K
profilePictureUrlWWL ]
=WW^ _
userWW` d
.WWd e
ProfilePictureUrlWWe v
}WWw x
)WWx y
;WWy z
}XX 	
[ZZ 	
HttpGetZZ	 
(ZZ 
$strZZ 
)ZZ 
]ZZ 
public[[ 
async[[ 
Task[[ 
<[[ 
IActionResult[[ '
>[[' (

GetDevices[[) 3
([[3 4
)[[4 5
{\\ 	
var]] 
userId]] 
=]] 
User]] 
.]] 
	FindFirst]] '
(]]' (
System]]( .
.]]. /
Security]]/ 7
.]]7 8
Claims]]8 >
.]]> ?

ClaimTypes]]? I
.]]I J
NameIdentifier]]J X
)]]X Y
?]]Y Z
.]]Z [
Value]][ `
;]]` a
var^^ 
devices^^ 
=^^ 
await^^ 
_context^^  (
.^^( )
Devices^^) 0
.^^0 1
Where^^1 6
(^^6 7
d^^7 8
=>^^9 ;
d^^< =
.^^= >
UserID^^> D
==^^E G
userId^^H N
)^^N O
.^^O P
ToListAsync^^P [
(^^[ \
)^^\ ]
;^^] ^
return__ 
Ok__ 
(__ 
devices__ 
)__ 
;__ 
}`` 	
[bb 	
HttpGetbb	 
(bb 
$strbb 
)bb 
]bb 
publiccc 
asynccc 
Taskcc 
<cc 
IActionResultcc '
>cc' (

GetTicketscc) 3
(cc3 4
)cc4 5
{dd 	
varee 
userIdee 
=ee 
Useree 
.ee 
	FindFirstee '
(ee' (
Systemee( .
.ee. /
Securityee/ 7
.ee7 8
Claimsee8 >
.ee> ?

ClaimTypesee? I
.eeI J
NameIdentifiereeJ X
)eeX Y
?eeY Z
.eeZ [
Valueee[ `
;ee` a
varff 
ticketsff 
=ff 
awaitff 
_contextff  (
.ff( )
SupportTicketsff) 7
.gg 
Includegg 
(gg 
tgg 
=>gg 
tgg 
.gg  
Repliesgg  '
)gg' (
.hh 
ThenIncludehh  
(hh  !
rhh! "
=>hh# %
rhh& '
.hh' (
Userhh( ,
)hh, -
.ii 
Whereii 
(ii 
tii 
=>ii 
tii 
.ii 
UserIDii $
==ii% '
userIdii( .
&&ii/ 1
!ii2 3
tii3 4
.ii4 5
IsHiddenByCustomerii5 G
)iiG H
.jj 
Selectjj 
(jj 
tjj 
=>jj 
newjj  
{kk 
tll 
.ll 
TicketIDll 
,ll 
tmm 
.mm 
Subjectmm 
,mm 
tnn 
.nn 
Descriptionnn !
,nn! "
too 
.oo 
Categoryoo 
,oo 
tpp 
.pp 
Prioritypp 
,pp 
tqq 
.qq 
Statusqq 
,qq 
trr 
.rr 
AttachmentUrlrr #
,rr# $
tss 
.ss 
	CreatedAtss 
,ss  
	UpdatedAttt 
=tt 
ttt  !
.tt! "
Repliestt" )
.tt) *
Anytt* -
(tt- .
)tt. /
?tt0 1
ttt2 3
.tt3 4
Repliestt4 ;
.tt; <
Maxtt< ?
(tt? @
rtt@ A
=>ttB D
rttE F
.ttF G
	CreatedAtttG P
)ttP Q
:ttR S
tttT U
.ttU V
	CreatedAtttV _
,tt_ `
Repliesuu 
=uu 
tuu 
.uu  
Repliesuu  '
.uu' (
OrderByuu( /
(uu/ 0
ruu0 1
=>uu2 4
ruu5 6
.uu6 7
	CreatedAtuu7 @
)uu@ A
.uuA B
SelectuuB H
(uuH I
ruuI J
=>uuK M
newuuN Q
{vv 
rww 
.ww 
ReplyIDww !
,ww! "
rxx 
.xx 
Messagexx !
,xx! "
ryy 
.yy 
IsAdminReplyyy &
,yy& '
rzz 
.zz 
	CreatedAtzz #
,zz# $
UserName{{  
={{! "
r{{# $
.{{$ %
User{{% )
.{{) *
	FirstName{{* 3
+{{4 5
$str{{6 9
+{{: ;
r{{< =
.{{= >
User{{> B
.{{B C
LastName{{C K
}|| 
)|| 
.|| 
ToList|| 
(|| 
)|| 
}}} 
)}} 
.~~ 
OrderByDescending~~ "
(~~" #
t~~# $
=>~~% '
t~~( )
.~~) *
	UpdatedAt~~* 3
)~~3 4
. 
ToListAsync 
( 
) 
; 
return
ÄÄ 
Ok
ÄÄ 
(
ÄÄ 
tickets
ÄÄ 
)
ÄÄ 
;
ÄÄ 
}
ÅÅ 	
[
ÉÉ 	
HttpPost
ÉÉ	 
(
ÉÉ 
$str
ÉÉ  
)
ÉÉ  !
]
ÉÉ! "
[
ÑÑ 	
RequestSizeLimit
ÑÑ	 
(
ÑÑ 
$num
ÑÑ 
*
ÑÑ 
$num
ÑÑ #
*
ÑÑ$ %
$num
ÑÑ& *
)
ÑÑ* +
]
ÑÑ+ ,
public
ÖÖ 
async
ÖÖ 
Task
ÖÖ 
<
ÖÖ 
IActionResult
ÖÖ '
>
ÖÖ' (
UploadImage
ÖÖ) 4
(
ÖÖ4 5
	IFormFile
ÖÖ5 >
file
ÖÖ? C
)
ÖÖC D
{
ÜÜ 	
if
áá 
(
áá 
file
áá 
==
áá 
null
áá 
||
áá 
file
áá  $
.
áá$ %
Length
áá% +
==
áá, .
$num
áá/ 0
)
áá0 1
return
àà 

BadRequest
àà !
(
àà! "
new
àà" %
{
àà& '
message
àà( /
=
àà0 1
$str
àà2 E
}
ààF G
)
ààG H
;
ààH I
var
ää 
allowed
ää 
=
ää 
new
ää 
[
ää 
]
ää 
{
ää  !
$str
ää" .
,
ää. /
$str
ää0 ;
,
ää; <
$str
ää= H
,
ääH I
$str
ääJ V
}
ääW X
;
ääX Y
if
ãã 
(
ãã 
!
ãã 
allowed
ãã 
.
ãã 
Contains
ãã !
(
ãã! "
file
ãã" &
.
ãã& '
ContentType
ãã' 2
.
ãã2 3
ToLower
ãã3 :
(
ãã: ;
)
ãã; <
)
ãã< =
)
ãã= >
return
åå 

BadRequest
åå !
(
åå! "
new
åå" %
{
åå& '
message
åå( /
=
åå0 1
$str
åå2 e
}
ååf g
)
ååg h
;
ååh i
if
éé 
(
éé 
file
éé 
.
éé 
Length
éé 
>
éé 
$num
éé 
*
éé  !
$num
éé" &
*
éé' (
$num
éé) -
)
éé- .
return
èè 

BadRequest
èè !
(
èè! "
new
èè" %
{
èè& '
message
èè( /
=
èè0 1
$str
èè2 M
}
èèN O
)
èèO P
;
èèP Q
var
ëë 
apiKey
ëë 
=
ëë 
_configuration
ëë '
[
ëë' (
$str
ëë( 6
]
ëë6 7
;
ëë7 8
if
íí 
(
íí 
string
íí 
.
íí 
IsNullOrEmpty
íí $
(
íí$ %
apiKey
íí% +
)
íí+ ,
)
íí, -
return
ìì 

StatusCode
ìì !
(
ìì! "
$num
ìì" %
,
ìì% &
new
ìì' *
{
ìì+ ,
message
ìì- 4
=
ìì5 6
$str
ìì7 ]
}
ìì^ _
)
ìì_ `
;
ìì` a
using
ïï 
var
ïï 
ms
ïï 
=
ïï 
new
ïï 
MemoryStream
ïï +
(
ïï+ ,
)
ïï, -
;
ïï- .
await
ññ 
file
ññ 
.
ññ 
CopyToAsync
ññ "
(
ññ" #
ms
ññ# %
)
ññ% &
;
ññ& '
var
óó 
base64
óó 
=
óó 
Convert
óó  
.
óó  !
ToBase64String
óó! /
(
óó/ 0
ms
óó0 2
.
óó2 3
ToArray
óó3 :
(
óó: ;
)
óó; <
)
óó< =
;
óó= >
using
ôô 
var
ôô 
form
ôô 
=
ôô 
new
ôô  &
MultipartFormDataContent
ôô! 9
(
ôô9 :
)
ôô: ;
;
ôô; <
form
öö 
.
öö 
Add
öö 
(
öö 
new
öö 
StringContent
öö &
(
öö& '
base64
öö' -
)
öö- .
,
öö. /
$str
öö0 7
)
öö7 8
;
öö8 9
var
úú 
client
úú 
=
úú  
_httpClientFactory
úú +
.
úú+ ,
CreateClient
úú, 8
(
úú8 9
)
úú9 :
;
úú: ;
var
ùù 
response
ùù 
=
ùù 
await
ùù  
client
ùù! '
.
ùù' (
	PostAsync
ùù( 1
(
ùù1 2
$"
ùù2 4
$str
ùù4 W
{
ùùW X
apiKey
ùùX ^
}
ùù^ _
"
ùù_ `
,
ùù` a
form
ùùb f
)
ùùf g
;
ùùg h
if
üü 
(
üü 
!
üü 
response
üü 
.
üü !
IsSuccessStatusCode
üü -
)
üü- .
return
†† 

StatusCode
†† !
(
††! "
$num
††" %
,
††% &
new
††' *
{
††+ ,
message
††- 4
=
††5 6
$str
††7 V
}
††W X
)
††X Y
;
††Y Z
var
¢¢ 
json
¢¢ 
=
¢¢ 
await
¢¢ 
response
¢¢ %
.
¢¢% &
Content
¢¢& -
.
¢¢- .
ReadAsStringAsync
¢¢. ?
(
¢¢? @
)
¢¢@ A
;
¢¢A B
using
££ 
var
££ 
doc
££ 
=
££ 
JsonDocument
££ (
.
££( )
Parse
££) .
(
££. /
json
££/ 3
)
££3 4
;
££4 5
var
§§ 
url
§§ 
=
§§ 
doc
§§ 
.
§§ 
RootElement
§§ %
.
§§% &
GetProperty
§§& 1
(
§§1 2
$str
§§2 8
)
§§8 9
.
§§9 :
GetProperty
§§: E
(
§§E F
$str
§§F K
)
§§K L
.
§§L M
	GetString
§§M V
(
§§V W
)
§§W X
;
§§X Y
return
¶¶ 
Ok
¶¶ 
(
¶¶ 
new
¶¶ 
{
¶¶ 
url
¶¶ 
}
¶¶  !
)
¶¶! "
;
¶¶" #
}
ßß 	
[
©© 	
HttpPost
©©	 
(
©© 
$str
©© 
)
©© 
]
©© 
public
™™ 
async
™™ 
Task
™™ 
<
™™ 
IActionResult
™™ '
>
™™' (
CreateTicket
™™) 5
(
™™5 6
[
™™6 7
FromBody
™™7 ?
]
™™? @!
CreateTicketRequest
™™A T
request
™™U \
)
™™\ ]
{
´´ 	
var
¨¨ 
userId
¨¨ 
=
¨¨ 
User
¨¨ 
.
¨¨ 
	FindFirst
¨¨ '
(
¨¨' (
System
¨¨( .
.
¨¨. /
Security
¨¨/ 7
.
¨¨7 8
Claims
¨¨8 >
.
¨¨> ?

ClaimTypes
¨¨? I
.
¨¨I J
NameIdentifier
¨¨J X
)
¨¨X Y
?
¨¨Y Z
.
¨¨Z [
Value
¨¨[ `
;
¨¨` a
var
≠≠ 
user
≠≠ 
=
≠≠ 
await
≠≠ 
_userManager
≠≠ )
.
≠≠) *
FindByIdAsync
≠≠* 7
(
≠≠7 8
userId
≠≠8 >
!
≠≠> ?
)
≠≠? @
;
≠≠@ A
if
ÆÆ 
(
ÆÆ 
user
ÆÆ 
==
ÆÆ 
null
ÆÆ 
)
ÆÆ 
return
ÆÆ $
NotFound
ÆÆ% -
(
ÆÆ- .
)
ÆÆ. /
;
ÆÆ/ 0
var
∞∞ 
ticket
∞∞ 
=
∞∞ 
new
∞∞ 
SupportTicket
∞∞ *
{
±± 
UserID
≤≤ 
=
≤≤ 
userId
≤≤ 
!
≤≤  
,
≤≤  !
Subject
≥≥ 
=
≥≥ 
request
≥≥ !
.
≥≥! "
Subject
≥≥" )
,
≥≥) *
Description
¥¥ 
=
¥¥ 
request
¥¥ %
.
¥¥% &
Description
¥¥& 1
,
¥¥1 2
Category
µµ 
=
µµ 
request
µµ "
.
µµ" #
Category
µµ# +
,
µµ+ ,
Priority
∂∂ 
=
∂∂ 
request
∂∂ "
.
∂∂" #
Priority
∂∂# +
,
∂∂+ ,
AttachmentUrl
∑∑ 
=
∑∑ 
request
∑∑  '
.
∑∑' (
AttachmentUrl
∑∑( 5
,
∑∑5 6
Status
∏∏ 
=
∏∏ 
$str
∏∏ 
}
ππ 
;
ππ 
_context
∫∫ 
.
∫∫ 
SupportTickets
∫∫ #
.
∫∫# $
Add
∫∫$ '
(
∫∫' (
ticket
∫∫( .
)
∫∫. /
;
∫∫/ 0
await
ªª 
_context
ªª 
.
ªª 
SaveChangesAsync
ªª +
(
ªª+ ,
)
ªª, -
;
ªª- .
var
ΩΩ 

ticketPref
ΩΩ 
=
ΩΩ 
await
ΩΩ "
_context
ΩΩ# +
.
ΩΩ+ ,%
NotificationPreferences
ΩΩ, C
.
ææ !
FirstOrDefaultAsync
ææ $
(
ææ$ %
np
ææ% '
=>
ææ( *
np
ææ+ -
.
ææ- .
UserID
ææ. 4
==
ææ5 7
userId
ææ8 >
&&
ææ? A
np
ææB D
.
ææD E
NotificationType
ææE U
==
ææV X
$str
ææY i
)
ææi j
;
ææj k
if
øø 
(
øø 

ticketPref
øø 
?
øø 
.
øø 
EmailEnabled
øø (
!=
øø) +
false
øø, 1
)
øø1 2
{
¿¿ 
await
¡¡ 
_emailService
¡¡ #
.
¡¡# $
SendEmailAsync
¡¡$ 2
(
¡¡2 3
user
¬¬ 
.
¬¬ 
Email
¬¬ 
!
¬¬ 
,
¬¬  
$str
√√ =
,
√√= >
$"
ƒƒ 
$str
ƒƒ 
{
ƒƒ 
user
ƒƒ !
.
ƒƒ! "
	FirstName
ƒƒ" +
}
ƒƒ+ ,
$str
ƒƒ, R
{
ƒƒR S
ticket
ƒƒS Y
.
ƒƒY Z
TicketID
ƒƒZ b
}
ƒƒb c
$strƒƒc ≠
{ƒƒ≠ Æ
requestƒƒÆ µ
.ƒƒµ ∂
Subjectƒƒ∂ Ω
}ƒƒΩ æ
$strƒƒæ ›
{ƒƒ› ﬁ
requestƒƒﬁ Â
.ƒƒÂ Ê
CategoryƒƒÊ Ó
}ƒƒÓ Ô
$strƒƒÔ é
{ƒƒé è
requestƒƒè ñ
.ƒƒñ ó
Priorityƒƒó ü
}ƒƒü †
$strƒƒ† ∫
"ƒƒ∫ ª
)
≈≈ 
;
≈≈ 
}
∆∆ 
await
»» 
_emailService
»» 
.
»»  
SendEmailAsync
»»  .
(
»». /
$str
…… *
,
……* +
$"
   
$str
   &
{
  & '
ticket
  ' -
.
  - .
TicketID
  . 6
}
  6 7
$str
  7 :
{
  : ;
request
  ; B
.
  B C
Priority
  C K
}
  K L
$str
  L U
"
  U V
,
  V W
$"
ÀÀ 
$str
ÀÀ ]
{
ÀÀ] ^
ticket
ÀÀ^ d
.
ÀÀd e
TicketID
ÀÀe m
}
ÀÀm n
$strÀÀn ç
{ÀÀç é
userÀÀé í
.ÀÀí ì
	FirstNameÀÀì ú
}ÀÀú ù
$strÀÀù û
{ÀÀû ü
userÀÀü £
.ÀÀ£ §
LastNameÀÀ§ ¨
}ÀÀ¨ ≠
$strÀÀ≠ Ø
{ÀÀØ ∞
userÀÀ∞ ¥
.ÀÀ¥ µ
EmailÀÀµ ∫
}ÀÀ∫ ª
$strÀÀª ⁄
{ÀÀ⁄ €
requestÀÀ€ ‚
.ÀÀ‚ „
SubjectÀÀ„ Í
}ÀÀÍ Î
$strÀÀÎ ä
{ÀÀä ã
requestÀÀã í
.ÀÀí ì
CategoryÀÀì õ
}ÀÀõ ú
$strÀÀú ª
{ÀÀª º
requestÀÀº √
.ÀÀ√ ƒ
PriorityÀÀƒ Ã
}ÀÀÃ Õ
$strÀÀÕ Ô
{ÀÀÔ 
requestÀÀ ˜
.ÀÀ˜ ¯
DescriptionÀÀ¯ É
}ÀÀÉ Ñ
$strÀÀÑ Æ
"ÀÀÆ Ø
)
ÃÃ 
;
ÃÃ 
var
ŒŒ 
notification
ŒŒ 
=
ŒŒ 
new
ŒŒ "
Notification
ŒŒ# /
{
œœ 
UserID
–– 
=
–– 
userId
–– 
!
––  
,
––  !
Message
—— 
=
—— 
$"
—— 
$str
—— 1
{
——1 2
ticket
——2 8
.
——8 9
TicketID
——9 A
}
——A B
$str
——B k
"
——k l
,
——l m
Type
““ 
=
““ 
$str
““ 
,
““  
Status
”” 
=
”” 
$str
”” !
}
‘‘ 
;
‘‘ 
_context
’’ 
.
’’ 
Notifications
’’ "
.
’’" #
Add
’’# &
(
’’& '
notification
’’' 3
)
’’3 4
;
’’4 5
await
÷÷ 
_context
÷÷ 
.
÷÷ 
SaveChangesAsync
÷÷ +
(
÷÷+ ,
)
÷÷, -
;
÷÷- .
return
ÿÿ 
Ok
ÿÿ 
(
ÿÿ 
new
ÿÿ 
{
ÿÿ 
message
ÿÿ #
=
ÿÿ$ %
$str
ÿÿ& C
,
ÿÿC D
ticketId
ÿÿE M
=
ÿÿN O
ticket
ÿÿP V
.
ÿÿV W
TicketID
ÿÿW _
}
ÿÿ` a
)
ÿÿa b
;
ÿÿb c
}
ŸŸ 	
[
€€ 	

HttpDelete
€€	 
(
€€ 
$str
€€ "
)
€€" #
]
€€# $
public
‹‹ 
async
‹‹ 
Task
‹‹ 
<
‹‹ 
IActionResult
‹‹ '
>
‹‹' (
DeleteTicket
‹‹) 5
(
‹‹5 6
int
‹‹6 9
id
‹‹: <
)
‹‹< =
{
›› 	
var
ﬁﬁ 
userId
ﬁﬁ 
=
ﬁﬁ 
User
ﬁﬁ 
.
ﬁﬁ 
	FindFirst
ﬁﬁ '
(
ﬁﬁ' (
System
ﬁﬁ( .
.
ﬁﬁ. /
Security
ﬁﬁ/ 7
.
ﬁﬁ7 8
Claims
ﬁﬁ8 >
.
ﬁﬁ> ?

ClaimTypes
ﬁﬁ? I
.
ﬁﬁI J
NameIdentifier
ﬁﬁJ X
)
ﬁﬁX Y
?
ﬁﬁY Z
.
ﬁﬁZ [
Value
ﬁﬁ[ `
;
ﬁﬁ` a
var
ﬂﬂ 
ticket
ﬂﬂ 
=
ﬂﬂ 
await
ﬂﬂ 
_context
ﬂﬂ '
.
ﬂﬂ' (
SupportTickets
ﬂﬂ( 6
.
ﬂﬂ6 7!
FirstOrDefaultAsync
ﬂﬂ7 J
(
ﬂﬂJ K
t
ﬂﬂK L
=>
ﬂﬂM O
t
ﬂﬂP Q
.
ﬂﬂQ R
TicketID
ﬂﬂR Z
==
ﬂﬂ[ ]
id
ﬂﬂ^ `
&&
ﬂﬂa c
t
ﬂﬂd e
.
ﬂﬂe f
UserID
ﬂﬂf l
==
ﬂﬂm o
userId
ﬂﬂp v
)
ﬂﬂv w
;
ﬂﬂw x
if
‡‡ 
(
‡‡ 
ticket
‡‡ 
==
‡‡ 
null
‡‡ 
)
‡‡ 
return
‡‡  &
NotFound
‡‡' /
(
‡‡/ 0
new
‡‡0 3
{
‡‡4 5
message
‡‡6 =
=
‡‡> ?
$str
‡‡@ R
}
‡‡S T
)
‡‡T U
;
‡‡U V
if
·· 
(
·· 
ticket
·· 
.
·· 
Status
·· 
!=
··  
$str
··! )
)
··) *
return
··+ 1

BadRequest
··2 <
(
··< =
new
··= @
{
··A B
message
··C J
=
··K L
$str
··M q
}
··r s
)
··s t
;
··t u
ticket
„„ 
.
„„  
IsHiddenByCustomer
„„ %
=
„„& '
true
„„( ,
;
„„, -
await
‰‰ 
_context
‰‰ 
.
‰‰ 
SaveChangesAsync
‰‰ +
(
‰‰+ ,
)
‰‰, -
;
‰‰- .
return
ÂÂ 
Ok
ÂÂ 
(
ÂÂ 
new
ÂÂ 
{
ÂÂ 
message
ÂÂ #
=
ÂÂ$ %
$str
ÂÂ& C
}
ÂÂD E
)
ÂÂE F
;
ÂÂF G
}
ÊÊ 	
[
ËË 	
HttpPost
ËË	 
(
ËË 
$str
ËË &
)
ËË& '
]
ËË' (
public
ÈÈ 
async
ÈÈ 
Task
ÈÈ 
<
ÈÈ 
IActionResult
ÈÈ '
>
ÈÈ' (
ReplyToTicket
ÈÈ) 6
(
ÈÈ6 7
int
ÈÈ7 :
id
ÈÈ; =
,
ÈÈ= >
[
ÈÈ? @
FromBody
ÈÈ@ H
]
ÈÈH I"
CustomerReplyRequest
ÈÈJ ^
request
ÈÈ_ f
)
ÈÈf g
{
ÍÍ 	
var
ÎÎ 
userId
ÎÎ 
=
ÎÎ 
User
ÎÎ 
.
ÎÎ 
	FindFirst
ÎÎ '
(
ÎÎ' (
System
ÎÎ( .
.
ÎÎ. /
Security
ÎÎ/ 7
.
ÎÎ7 8
Claims
ÎÎ8 >
.
ÎÎ> ?

ClaimTypes
ÎÎ? I
.
ÎÎI J
NameIdentifier
ÎÎJ X
)
ÎÎX Y
?
ÎÎY Z
.
ÎÎZ [
Value
ÎÎ[ `
;
ÎÎ` a
var
ÏÏ 
user
ÏÏ 
=
ÏÏ 
await
ÏÏ 
_userManager
ÏÏ )
.
ÏÏ) *
FindByIdAsync
ÏÏ* 7
(
ÏÏ7 8
userId
ÏÏ8 >
!
ÏÏ> ?
)
ÏÏ? @
;
ÏÏ@ A
if
ÌÌ 
(
ÌÌ 
user
ÌÌ 
==
ÌÌ 
null
ÌÌ 
)
ÌÌ 
return
ÌÌ $
NotFound
ÌÌ% -
(
ÌÌ- .
)
ÌÌ. /
;
ÌÌ/ 0
var
ÔÔ 
ticket
ÔÔ 
=
ÔÔ 
await
ÔÔ 
_context
ÔÔ '
.
ÔÔ' (
SupportTickets
ÔÔ( 6
.
 
Include
 
(
 
t
 
=>
 
t
 
.
  
Replies
  '
)
' (
.
ÒÒ !
FirstOrDefaultAsync
ÒÒ $
(
ÒÒ$ %
t
ÒÒ% &
=>
ÒÒ' )
t
ÒÒ* +
.
ÒÒ+ ,
TicketID
ÒÒ, 4
==
ÒÒ5 7
id
ÒÒ8 :
&&
ÒÒ; =
t
ÒÒ> ?
.
ÒÒ? @
UserID
ÒÒ@ F
==
ÒÒG I
userId
ÒÒJ P
)
ÒÒP Q
;
ÒÒQ R
if
ÚÚ 
(
ÚÚ 
ticket
ÚÚ 
==
ÚÚ 
null
ÚÚ 
)
ÚÚ 
return
ÚÚ  &
NotFound
ÚÚ' /
(
ÚÚ/ 0
new
ÚÚ0 3
{
ÚÚ4 5
message
ÚÚ6 =
=
ÚÚ> ?
$str
ÚÚ@ R
}
ÚÚS T
)
ÚÚT U
;
ÚÚU V
if
ÛÛ 
(
ÛÛ 
ticket
ÛÛ 
.
ÛÛ 
Status
ÛÛ 
==
ÛÛ  
$str
ÛÛ! )
)
ÛÛ) *
return
ÛÛ+ 1

BadRequest
ÛÛ2 <
(
ÛÛ< =
new
ÛÛ= @
{
ÛÛA B
message
ÛÛC J
=
ÛÛK L
$str
ÛÛM n
}
ÛÛo p
)
ÛÛp q
;
ÛÛq r
var
ıı 
reply
ıı 
=
ıı 
new
ıı 
TicketReply
ıı '
{
ˆˆ 
TicketID
˜˜ 
=
˜˜ 
id
˜˜ 
,
˜˜ 
UserID
¯¯ 
=
¯¯ 
userId
¯¯ 
!
¯¯  
,
¯¯  !
Message
˘˘ 
=
˘˘ 
request
˘˘ !
.
˘˘! "
Message
˘˘" )
,
˘˘) *
IsAdminReply
˙˙ 
=
˙˙ 
false
˙˙ $
}
˚˚ 
;
˚˚ 
_context
¸¸ 
.
¸¸ 
TicketReplies
¸¸ "
.
¸¸" #
Add
¸¸# &
(
¸¸& '
reply
¸¸' ,
)
¸¸, -
;
¸¸- .
if
˛˛ 
(
˛˛ 
ticket
˛˛ 
.
˛˛ 
Status
˛˛ 
==
˛˛  
$str
˛˛! +
)
˛˛+ ,
ticket
˛˛- 3
.
˛˛3 4
Status
˛˛4 :
=
˛˛; <
$str
˛˛= F
;
˛˛F G
await
ÄÄ 
_context
ÄÄ 
.
ÄÄ 
SaveChangesAsync
ÄÄ +
(
ÄÄ+ ,
)
ÄÄ, -
;
ÄÄ- .
return
ÇÇ 
Ok
ÇÇ 
(
ÇÇ 
new
ÇÇ 
{
ÉÉ 
replyID
ÑÑ 
=
ÑÑ 
reply
ÑÑ 
.
ÑÑ  
ReplyID
ÑÑ  '
,
ÑÑ' (
message
ÖÖ 
=
ÖÖ 
reply
ÖÖ 
.
ÖÖ  
Message
ÖÖ  '
,
ÖÖ' (
isAdminReply
ÜÜ 
=
ÜÜ 
reply
ÜÜ $
.
ÜÜ$ %
IsAdminReply
ÜÜ% 1
,
ÜÜ1 2
	createdAt
áá 
=
áá 
reply
áá !
.
áá! "
	CreatedAt
áá" +
,
áá+ ,
userName
àà 
=
àà 
user
àà 
.
àà  
	FirstName
àà  )
+
àà* +
$str
àà, /
+
àà0 1
user
àà2 6
.
àà6 7
LastName
àà7 ?
}
ââ 
)
ââ 
;
ââ 
}
ää 	
[
åå 	
AllowAnonymous
åå	 
]
åå 
[
çç 	
HttpGet
çç	 
(
çç 
$str
çç 
)
çç 
]
çç 
public
éé 
async
éé 
Task
éé 
<
éé 
IActionResult
éé '
>
éé' (
GetFAQs
éé) 0
(
éé0 1
)
éé1 2
{
èè 	
var
êê 
faqs
êê 
=
êê 
await
êê 
_context
êê %
.
êê% &
FAQs
êê& *
.
ëë 
Where
ëë 
(
ëë 
f
ëë 
=>
ëë 
f
ëë 
.
ëë 
Status
ëë $
==
ëë% '
$str
ëë( 3
)
ëë3 4
.
íí 
OrderBy
íí 
(
íí 
f
íí 
=>
íí 
f
íí 
.
íí  
Category
íí  (
)
íí( )
.
ìì 
ThenByDescending
ìì !
(
ìì! "
f
ìì" #
=>
ìì$ &
f
ìì' (
.
ìì( )
	CreatedAt
ìì) 2
)
ìì2 3
.
îî 
Select
îî 
(
îî 
f
îî 
=>
îî 
new
îî  
{
îî! "
f
îî# $
.
îî$ %
FAQID
îî% *
,
îî* +
f
îî, -
.
îî- .
Question
îî. 6
,
îî6 7
f
îî8 9
.
îî9 :
Answer
îî: @
,
îî@ A
f
îîB C
.
îîC D
Category
îîD L
}
îîM N
)
îîN O
.
ïï 
ToListAsync
ïï 
(
ïï 
)
ïï 
;
ïï 
return
ññ 
Ok
ññ 
(
ññ 
faqs
ññ 
)
ññ 
;
ññ 
}
óó 	
[
ôô 	
HttpGet
ôô	 
(
ôô 
$str
ôô  
)
ôô  !
]
ôô! "
public
öö 
async
öö 
Task
öö 
<
öö 
IActionResult
öö '
>
öö' (
GetSubscriptions
öö) 9
(
öö9 :
)
öö: ;
{
õõ 	
try
úú 
{
ùù 
var
ûû 
userId
ûû 
=
ûû 
User
ûû !
.
ûû! "
	FindFirst
ûû" +
(
ûû+ ,
System
ûû, 2
.
ûû2 3
Security
ûû3 ;
.
ûû; <
Claims
ûû< B
.
ûûB C

ClaimTypes
ûûC M
.
ûûM N
NameIdentifier
ûûN \
)
ûû\ ]
?
ûû] ^
.
ûû^ _
Value
ûû_ d
;
ûûd e
var
°° 
subscriptions
°° !
=
°°" #
await
°°$ )
_context
°°* 2
.
°°2 3
Subscriptions
°°3 @
.
¢¢ 
Include
¢¢ 
(
¢¢ 
s
¢¢ 
=>
¢¢ !
s
¢¢" #
.
¢¢# $
Plan
¢¢$ (
)
¢¢( )
.
££ 
Include
££ 
(
££ 
s
££ 
=>
££ !
s
££" #
.
££# $
ServiceAccount
££$ 2
)
££2 3
.
§§ 
ThenInclude
§§ $
(
§§$ %
sa
§§% '
=>
§§( *
sa
§§+ -
.
§§- .
Device
§§. 4
)
§§4 5
.
•• 
Where
•• 
(
•• 
s
•• 
=>
•• 
s
••  !
.
••! "
UserID
••" (
==
••) +
userId
••, 2
)
••2 3
.
¶¶ 
Select
¶¶ 
(
¶¶ 
s
¶¶ 
=>
¶¶  
new
¶¶! $
{
ßß 
s
®® 
.
®® 
SubscriptionID
®® (
,
®®( )
s
©© 
.
©© 
PlanID
©©  
,
©©  !
s
™™ 
.
™™ 
UserID
™™  
,
™™  !

DeviceName
´´ "
=
´´# $
s
´´% &
.
´´& '

DeviceName
´´' 1
??
´´2 4
$str
´´5 7
,
´´7 8
s
¨¨ 
.
¨¨ 
	StartDate
¨¨ #
,
¨¨# $
s
≠≠ 
.
≠≠ 
EndDate
≠≠ !
,
≠≠! "
s
ÆÆ 
.
ÆÆ 
Status
ÆÆ  
,
ÆÆ  !
Plan
ØØ 
=
ØØ 
new
ØØ "
{
∞∞ 
s
±± 
.
±± 
Plan
±± "
.
±±" #
PlanID
±±# )
,
±±) *
s
≤≤ 
.
≤≤ 
Plan
≤≤ "
.
≤≤" #
PlanName
≤≤# +
,
≤≤+ ,
s
≥≥ 
.
≥≥ 
Plan
≥≥ "
.
≥≥" #
	SpeedMbps
≥≥# ,
}
¥¥ 
,
¥¥ 

MACAddress
µµ "
=
µµ# $
s
µµ% &
.
µµ& '
ServiceAccount
µµ' 5
.
µµ5 6
Device
µµ6 <
.
µµ< =

MACAddress
µµ= G
??
µµH J
$str
µµK M
,
µµM N
ServiceType
∂∂ #
=
∂∂$ %
$str
∂∂& 4
}
∑∑ 
)
∑∑ 
.
∏∏ 
ToListAsync
∏∏  
(
∏∏  !
)
∏∏! "
;
∏∏" #
var
ªª 
prepaidServices
ªª #
=
ªª$ %
await
ªª& +
_context
ªª, 4
.
ªª4 5
PrepaidLoads
ªª5 A
.
ºº 
Where
ºº 
(
ºº 
p
ºº 
=>
ºº 
p
ºº  !
.
ºº! "
ServiceAccount
ºº" 0
.
ºº0 1
Device
ºº1 7
.
ºº7 8
UserID
ºº8 >
==
ºº? A
userId
ººB H
)
ººH I
.
ΩΩ 
Select
ΩΩ 
(
ΩΩ 
p
ΩΩ 
=>
ΩΩ  
new
ΩΩ! $
{
ææ 
SubscriptionID
øø &
=
øø' (
p
øø) *
.
øø* +
PrepaidLoadID
øø+ 8
,
øø8 9
PlanID
¿¿ 
=
¿¿  
(
¿¿! "
int
¿¿" %
?
¿¿% &
)
¿¿& '
null
¿¿' +
,
¿¿+ ,
UserID
¡¡ 
=
¡¡  
userId
¡¡! '
,
¡¡' (

DeviceName
¬¬ "
=
¬¬# $
$str
¬¬% 3
,
¬¬3 4
	StartDate
√√ !
=
√√" #
p
√√$ %
.
√√% &
ServiceAccount
√√& 4
.
√√4 5
ActivatedAt
√√5 @
,
√√@ A
EndDate
ƒƒ 
=
ƒƒ  !
(
ƒƒ" #
DateTime
ƒƒ# +
?
ƒƒ+ ,
)
ƒƒ, -
null
ƒƒ- 1
,
ƒƒ1 2
Status
≈≈ 
=
≈≈  
p
≈≈! "
.
≈≈" #
ServiceAccount
≈≈# 1
.
≈≈1 2
Status
≈≈2 8
,
≈≈8 9
Plan
∆∆ 
=
∆∆ 
(
∆∆  
object
∆∆  &
?
∆∆& '
)
∆∆' (
null
∆∆( ,
,
∆∆, -

MACAddress
«« "
=
««# $
p
««% &
.
««& '
ServiceAccount
««' 5
.
««5 6
Device
««6 <
.
««< =

MACAddress
««= G
??
««H J
$str
««K M
,
««M N
ServiceType
»» #
=
»»$ %
$str
»»& /
,
»»/ 0
PhoneNumber
…… #
=
……$ %
p
……& '
.
……' (
PhoneNumber
……( 3
,
……3 4
RemainingBalance
   (
=
  ) *
p
  + ,
.
  , -
RemainingBalance
  - =
}
ÀÀ 
)
ÀÀ 
.
ÃÃ 
ToListAsync
ÃÃ  
(
ÃÃ  !
)
ÃÃ! "
;
ÃÃ" #
var
ŒŒ 
allServices
ŒŒ 
=
ŒŒ  !
subscriptions
ŒŒ" /
.
ŒŒ/ 0
Cast
ŒŒ0 4
<
ŒŒ4 5
object
ŒŒ5 ;
>
ŒŒ; <
(
ŒŒ< =
)
ŒŒ= >
.
ŒŒ> ?
Concat
ŒŒ? E
(
ŒŒE F
prepaidServices
ŒŒF U
.
ŒŒU V
Cast
ŒŒV Z
<
ŒŒZ [
object
ŒŒ[ a
>
ŒŒa b
(
ŒŒb c
)
ŒŒc d
)
ŒŒd e
.
ŒŒe f
ToList
ŒŒf l
(
ŒŒl m
)
ŒŒm n
;
ŒŒn o
return
œœ 
Ok
œœ 
(
œœ 
allServices
œœ %
)
œœ% &
;
œœ& '
}
–– 
catch
—— 
(
—— 
	Exception
—— 
ex
—— 
)
——  
{
““ 
return
”” 

BadRequest
”” !
(
””! "
new
””" %
{
””& '
message
””( /
=
””0 1
$"
””2 4
$str
””4 S
{
””S T
ex
””T V
.
””V W
Message
””W ^
}
””^ _
"
””_ `
}
””a b
)
””b c
;
””c d
}
‘‘ 
}
’’ 	
[
◊◊ 	

HttpDelete
◊◊	 
(
◊◊ 
$str
◊◊ "
)
◊◊" #
]
◊◊# $
public
ÿÿ 
async
ÿÿ 
Task
ÿÿ 
<
ÿÿ 
IActionResult
ÿÿ '
>
ÿÿ' ("
DeletePrepaidService
ÿÿ) =
(
ÿÿ= >
int
ÿÿ> A
id
ÿÿB D
)
ÿÿD E
{
ŸŸ 	
var
⁄⁄ 
userId
⁄⁄ 
=
⁄⁄ 
User
⁄⁄ 
.
⁄⁄ 
	FindFirst
⁄⁄ '
(
⁄⁄' (
System
⁄⁄( .
.
⁄⁄. /
Security
⁄⁄/ 7
.
⁄⁄7 8
Claims
⁄⁄8 >
.
⁄⁄> ?

ClaimTypes
⁄⁄? I
.
⁄⁄I J
NameIdentifier
⁄⁄J X
)
⁄⁄X Y
?
⁄⁄Y Z
.
⁄⁄Z [
Value
⁄⁄[ `
;
⁄⁄` a
var
€€ 
prepaid
€€ 
=
€€ 
await
€€ 
_context
€€  (
.
€€( )
PrepaidLoads
€€) 5
.
‹‹ 
Include
‹‹ 
(
‹‹ 
p
‹‹ 
=>
‹‹ 
p
‹‹ 
.
‹‹  
ServiceAccount
‹‹  .
)
‹‹. /
.
›› 
ThenInclude
››  
(
››  !
sa
››! #
=>
››$ &
sa
››' )
.
››) *
Device
››* 0
)
››0 1
.
ﬁﬁ !
FirstOrDefaultAsync
ﬁﬁ $
(
ﬁﬁ$ %
p
ﬁﬁ% &
=>
ﬁﬁ' )
p
ﬁﬁ* +
.
ﬁﬁ+ ,
PrepaidLoadID
ﬁﬁ, 9
==
ﬁﬁ: <
id
ﬁﬁ= ?
&&
ﬁﬁ@ B
p
ﬁﬁC D
.
ﬁﬁD E
ServiceAccount
ﬁﬁE S
.
ﬁﬁS T
Device
ﬁﬁT Z
.
ﬁﬁZ [
UserID
ﬁﬁ[ a
==
ﬁﬁb d
userId
ﬁﬁe k
)
ﬁﬁk l
;
ﬁﬁl m
if
‡‡ 
(
‡‡ 
prepaid
‡‡ 
==
‡‡ 
null
‡‡ 
)
‡‡  
return
‡‡! '
NotFound
‡‡( 0
(
‡‡0 1
new
‡‡1 4
{
‡‡5 6
message
‡‡7 >
=
‡‡? @
$str
‡‡A \
}
‡‡] ^
)
‡‡^ _
;
‡‡_ `
_context
‚‚ 
.
‚‚ 
PrepaidLoads
‚‚ !
.
‚‚! "
Remove
‚‚" (
(
‚‚( )
prepaid
‚‚) 0
)
‚‚0 1
;
‚‚1 2
await
„„ 
_context
„„ 
.
„„ 
SaveChangesAsync
„„ +
(
„„+ ,
)
„„, -
;
„„- .
return
‰‰ 
Ok
‰‰ 
(
‰‰ 
new
‰‰ 
{
‰‰ 
message
‰‰ #
=
‰‰$ %
$str
‰‰& L
}
‰‰M N
)
‰‰N O
;
‰‰O P
}
ÂÂ 	
[
ÁÁ 	
HttpGet
ÁÁ	 
(
ÁÁ 
$str
ÁÁ '
)
ÁÁ' (
]
ÁÁ( )
public
ËË 
async
ËË 
Task
ËË 
<
ËË 
IActionResult
ËË '
>
ËË' (
GetPrepaidBalance
ËË) :
(
ËË: ;
int
ËË; >
id
ËË? A
)
ËËA B
{
ÈÈ 	
var
ÍÍ 
userId
ÍÍ 
=
ÍÍ 
User
ÍÍ 
.
ÍÍ 
	FindFirst
ÍÍ '
(
ÍÍ' (
System
ÍÍ( .
.
ÍÍ. /
Security
ÍÍ/ 7
.
ÍÍ7 8
Claims
ÍÍ8 >
.
ÍÍ> ?

ClaimTypes
ÍÍ? I
.
ÍÍI J
NameIdentifier
ÍÍJ X
)
ÍÍX Y
?
ÍÍY Z
.
ÍÍZ [
Value
ÍÍ[ `
;
ÍÍ` a
var
ÎÎ 
prepaid
ÎÎ 
=
ÎÎ 
await
ÎÎ 
_context
ÎÎ  (
.
ÎÎ( )
PrepaidLoads
ÎÎ) 5
.
ÏÏ 
Include
ÏÏ 
(
ÏÏ 
p
ÏÏ 
=>
ÏÏ 
p
ÏÏ 
.
ÏÏ  
ServiceAccount
ÏÏ  .
)
ÏÏ. /
.
ÌÌ 
ThenInclude
ÌÌ  
(
ÌÌ  !
sa
ÌÌ! #
=>
ÌÌ$ &
sa
ÌÌ' )
.
ÌÌ) *
Device
ÌÌ* 0
)
ÌÌ0 1
.
ÓÓ !
FirstOrDefaultAsync
ÓÓ $
(
ÓÓ$ %
p
ÓÓ% &
=>
ÓÓ' )
p
ÓÓ* +
.
ÓÓ+ ,
PrepaidLoadID
ÓÓ, 9
==
ÓÓ: <
id
ÓÓ= ?
&&
ÓÓ@ B
p
ÓÓC D
.
ÓÓD E
ServiceAccount
ÓÓE S
.
ÓÓS T
Device
ÓÓT Z
.
ÓÓZ [
UserID
ÓÓ[ a
==
ÓÓb d
userId
ÓÓe k
)
ÓÓk l
;
ÓÓl m
if
 
(
 
prepaid
 
==
 
null
 
)
  
return
! '
NotFound
( 0
(
0 1
new
1 4
{
5 6
message
7 >
=
? @
$str
A \
}
] ^
)
^ _
;
_ `
return
ÚÚ 
Ok
ÚÚ 
(
ÚÚ 
new
ÚÚ 
{
ÛÛ 
prepaidLoadID
ÙÙ 
=
ÙÙ 
prepaid
ÙÙ  '
.
ÙÙ' (
PrepaidLoadID
ÙÙ( 5
,
ÙÙ5 6
phoneNumber
ıı 
=
ıı 
prepaid
ıı %
.
ıı% &
PhoneNumber
ıı& 1
,
ıı1 2

loadAmount
ˆˆ 
=
ˆˆ 
prepaid
ˆˆ $
.
ˆˆ$ %

LoadAmount
ˆˆ% /
,
ˆˆ/ 0
remainingBalance
˜˜  
=
˜˜! "
prepaid
˜˜# *
.
˜˜* +
RemainingBalance
˜˜+ ;
??
˜˜< >
$num
˜˜? @
,
˜˜@ A

lastReload
¯¯ 
=
¯¯ 
prepaid
¯¯ $
.
¯¯$ %
LastReloadBalance
¯¯% 6
}
˘˘ 
)
˘˘ 
;
˘˘ 
}
˙˙ 	
[
¸¸ 	
HttpPost
¸¸	 
(
¸¸ 
$str
¸¸ *
)
¸¸* +
]
¸¸+ ,
public
˝˝ 
async
˝˝ 
Task
˝˝ 
<
˝˝ 
IActionResult
˝˝ '
>
˝˝' (
BuyPromo
˝˝) 1
(
˝˝1 2
int
˝˝2 5
id
˝˝6 8
,
˝˝8 9
[
˝˝: ;
FromBody
˝˝; C
]
˝˝C D
BuyPromoRequest
˝˝E T
request
˝˝U \
)
˝˝\ ]
{
˛˛ 	
var
ˇˇ 
userId
ˇˇ 
=
ˇˇ 
User
ˇˇ 
.
ˇˇ 
	FindFirst
ˇˇ '
(
ˇˇ' (
System
ˇˇ( .
.
ˇˇ. /
Security
ˇˇ/ 7
.
ˇˇ7 8
Claims
ˇˇ8 >
.
ˇˇ> ?

ClaimTypes
ˇˇ? I
.
ˇˇI J
NameIdentifier
ˇˇJ X
)
ˇˇX Y
?
ˇˇY Z
.
ˇˇZ [
Value
ˇˇ[ `
;
ˇˇ` a
var
ÄÄ 
prepaid
ÄÄ 
=
ÄÄ 
await
ÄÄ 
_context
ÄÄ  (
.
ÄÄ( )
PrepaidLoads
ÄÄ) 5
.
ÅÅ 
Include
ÅÅ 
(
ÅÅ 
p
ÅÅ 
=>
ÅÅ 
p
ÅÅ 
.
ÅÅ  
ServiceAccount
ÅÅ  .
)
ÅÅ. /
.
ÇÇ 
ThenInclude
ÇÇ  
(
ÇÇ  !
sa
ÇÇ! #
=>
ÇÇ$ &
sa
ÇÇ' )
.
ÇÇ) *
Device
ÇÇ* 0
)
ÇÇ0 1
.
ÉÉ !
FirstOrDefaultAsync
ÉÉ $
(
ÉÉ$ %
p
ÉÉ% &
=>
ÉÉ' )
p
ÉÉ* +
.
ÉÉ+ ,
PrepaidLoadID
ÉÉ, 9
==
ÉÉ: <
id
ÉÉ= ?
&&
ÉÉ@ B
p
ÉÉC D
.
ÉÉD E
ServiceAccount
ÉÉE S
.
ÉÉS T
Device
ÉÉT Z
.
ÉÉZ [
UserID
ÉÉ[ a
==
ÉÉb d
userId
ÉÉe k
)
ÉÉk l
;
ÉÉl m
if
ÖÖ 
(
ÖÖ 
prepaid
ÖÖ 
==
ÖÖ 
null
ÖÖ 
)
ÖÖ  
return
ÖÖ! '
NotFound
ÖÖ( 0
(
ÖÖ0 1
new
ÖÖ1 4
{
ÖÖ5 6
message
ÖÖ7 >
=
ÖÖ? @
$str
ÖÖA \
}
ÖÖ] ^
)
ÖÖ^ _
;
ÖÖ_ `
if
ÜÜ 
(
ÜÜ 
request
ÜÜ 
.
ÜÜ 
Amount
ÜÜ 
<=
ÜÜ !
$num
ÜÜ" #
)
ÜÜ# $
return
ÜÜ% +

BadRequest
ÜÜ, 6
(
ÜÜ6 7
new
ÜÜ7 :
{
ÜÜ; <
message
ÜÜ= D
=
ÜÜE F
$str
ÜÜG W
}
ÜÜX Y
)
ÜÜY Z
;
ÜÜZ [
if
áá 
(
áá 
(
áá 
prepaid
áá 
.
áá 
RemainingBalance
áá )
??
áá* ,
$num
áá- .
)
áá. /
<
áá0 1
request
áá2 9
.
áá9 :
Amount
áá: @
)
áá@ A
return
ááB H

BadRequest
ááI S
(
ááS T
new
ááT W
{
ááX Y
message
ááZ a
=
ááb c
$str
áád z
}
áá{ |
)
áá| }
;
áá} ~
prepaid
ââ 
.
ââ 
RemainingBalance
ââ $
-=
ââ% '
request
ââ( /
.
ââ/ 0
Amount
ââ0 6
;
ââ6 7
decimal
ãã 
totalDataMB
ãã 
=
ãã  !
$num
ãã" #
;
ãã# $
if
åå 
(
åå 
!
åå 
string
åå 
.
åå 
IsNullOrEmpty
åå %
(
åå% &
request
åå& -
.
åå- .
	PromoData
åå. 7
)
åå7 8
)
åå8 9
{
çç 
if
éé 
(
éé 
request
éé 
.
éé 
	PromoData
éé %
.
éé% &
ToLower
éé& -
(
éé- .
)
éé. /
.
éé/ 0
Contains
éé0 8
(
éé8 9
$str
éé9 D
)
ééD E
)
ééE F
totalDataMB
èè 
=
èè  !
$num
èè" (
;
èè( )
else
êê 
{
ëë 
var
íí 
numStr
íí 
=
íí  
new
íí! $
string
íí% +
(
íí+ ,
request
íí, 3
.
íí3 4
	PromoData
íí4 =
.
íí= >
Where
íí> C
(
ííC D
c
ííD E
=>
ííF H
char
ííI M
.
ííM N
IsDigit
ííN U
(
ííU V
c
ííV W
)
ííW X
||
ííY [
c
íí\ ]
==
íí^ `
$char
íía d
)
ííd e
.
ííe f
ToArray
ííf m
(
íím n
)
íín o
)
íío p
;
ííp q
if
ìì 
(
ìì 
decimal
ìì 
.
ìì  
TryParse
ìì  (
(
ìì( )
numStr
ìì) /
,
ìì/ 0
out
ìì1 4
var
ìì5 8
gb
ìì9 ;
)
ìì; <
)
ìì< =
totalDataMB
îî #
=
îî$ %
gb
îî& (
*
îî) *
$num
îî+ /
;
îî/ 0
}
ïï 
}
ññ 
int
òò 
validityDays
òò 
=
òò 
$num
òò !
;
òò! "
if
ôô 
(
ôô 
!
ôô 
string
ôô 
.
ôô 
IsNullOrEmpty
ôô %
(
ôô% &
request
ôô& -
.
ôô- .
PromoValidity
ôô. ;
)
ôô; <
)
ôô< =
{
öö 
var
õõ 
dayStr
õõ 
=
õõ 
new
õõ  
string
õõ! '
(
õõ' (
request
õõ( /
.
õõ/ 0
PromoValidity
õõ0 =
.
õõ= >
Where
õõ> C
(
õõC D
char
õõD H
.
õõH I
IsDigit
õõI P
)
õõP Q
.
õõQ R
ToArray
õõR Y
(
õõY Z
)
õõZ [
)
õõ[ \
;
õõ\ ]
if
úú 
(
úú 
int
úú 
.
úú 
TryParse
úú  
(
úú  !
dayStr
úú! '
,
úú' (
out
úú) ,
var
úú- 0
days
úú1 5
)
úú5 6
)
úú6 7
validityDays
úú8 D
=
úúE F
days
úúG K
;
úúK L
}
ùù 
var
üü 
promo
üü 
=
üü 
new
üü 
PrepaidPromo
üü (
{
†† 
PrepaidLoadID
°° 
=
°° 
prepaid
°°  '
.
°°' (
PrepaidLoadID
°°( 5
,
°°5 6
UserID
¢¢ 
=
¢¢ 
userId
¢¢ 
!
¢¢  
,
¢¢  !

PromoTitle
££ 
=
££ 
request
££ $
.
££$ %

PromoTitle
££% /
??
££0 2
$str
££3 B
,
££B C
TotalDataMB
§§ 
=
§§ 
totalDataMB
§§ )
,
§§) *
RemainingDataMB
•• 
=
••  !
totalDataMB
••" -
,
••- .
ValidityDays
¶¶ 
=
¶¶ 
validityDays
¶¶ +
,
¶¶+ ,
ActivatedAt
ßß 
=
ßß 
DateTime
ßß &
.
ßß& '
UtcNow
ßß' -
,
ßß- .
	ExpiresAt
®® 
=
®® 
DateTime
®® $
.
®®$ %
UtcNow
®®% +
.
®®+ ,
AddDays
®®, 3
(
®®3 4
validityDays
®®4 @
)
®®@ A
,
®®A B
Status
©© 
=
©© 
$str
©© !
}
™™ 
;
™™ 
_context
´´ 
.
´´ 
PrepaidPromos
´´ "
.
´´" #
Add
´´# &
(
´´& '
promo
´´' ,
)
´´, -
;
´´- .
var
≠≠ 
invoice
≠≠ 
=
≠≠ 
new
≠≠ 
Invoice
≠≠ %
{
ÆÆ 
PrepaidLoadID
ØØ 
=
ØØ 
prepaid
ØØ  '
.
ØØ' (
PrepaidLoadID
ØØ( 5
,
ØØ5 6
UserID
∞∞ 
=
∞∞ 
userId
∞∞ 
!
∞∞  
,
∞∞  !
Amount
±± 
=
±± 
request
±±  
.
±±  !
Amount
±±! '
,
±±' (
DueDate
≤≤ 
=
≤≤ 
DateTime
≤≤ "
.
≤≤" #
UtcNow
≤≤# )
,
≤≤) *
Status
≥≥ 
=
≥≥ 
$str
≥≥ 
,
≥≥  
	CreatedAt
¥¥ 
=
¥¥ 
DateTime
¥¥ $
.
¥¥$ %
UtcNow
¥¥% +
}
µµ 
;
µµ 
_context
∂∂ 
.
∂∂ 
Invoices
∂∂ 
.
∂∂ 
Add
∂∂ !
(
∂∂! "
invoice
∂∂" )
)
∂∂) *
;
∂∂* +
await
∑∑ 
_context
∑∑ 
.
∑∑ 
SaveChangesAsync
∑∑ +
(
∑∑+ ,
)
∑∑, -
;
∑∑- .
var
ππ 
payment
ππ 
=
ππ 
new
ππ 
Payment
ππ %
{
∫∫ 
UserID
ªª 
=
ªª 
userId
ªª 
!
ªª  
,
ªª  !
	InvoiceID
ºº 
=
ºº 
invoice
ºº #
.
ºº# $
	InvoiceID
ºº$ -
,
ºº- .

AmountPaid
ΩΩ 
=
ΩΩ 
request
ΩΩ $
.
ΩΩ$ %
Amount
ΩΩ% +
,
ΩΩ+ ,
PaymentMethod
ææ 
=
ææ 
$str
ææ  1
,
ææ1 2
PaymentDate
øø 
=
øø 
DateTime
øø &
.
øø& '
UtcNow
øø' -
,
øø- .
ReferenceNum
¿¿ 
=
¿¿ 
$"
¿¿ !
$str
¿¿! '
{
¿¿' (
request
¿¿( /
.
¿¿/ 0

PromoTitle
¿¿0 :
?
¿¿: ;
.
¿¿; <
Replace
¿¿< C
(
¿¿C D
$str
¿¿D G
,
¿¿G H
$str
¿¿I L
)
¿¿L M
.
¿¿M N
ToUpper
¿¿N U
(
¿¿U V
)
¿¿V W
??
¿¿X Z
$str
¿¿[ d
}
¿¿d e
$str
¿¿e f
{
¿¿f g
DateTime
¿¿g o
.
¿¿o p
UtcNow
¿¿p v
:
¿¿v w
$str¿¿w Ö
}¿¿Ö Ü
"¿¿Ü á
,¿¿á à
Status
¡¡ 
=
¡¡ 
$str
¡¡ $
}
¬¬ 
;
¬¬ 
_context
√√ 
.
√√ 
Payments
√√ 
.
√√ 
Add
√√ !
(
√√! "
payment
√√" )
)
√√) *
;
√√* +
await
ƒƒ 
_context
ƒƒ 
.
ƒƒ 
SaveChangesAsync
ƒƒ +
(
ƒƒ+ ,
)
ƒƒ, -
;
ƒƒ- .
return
∆∆ 
Ok
∆∆ 
(
∆∆ 
new
∆∆ 
{
∆∆ 
message
«« 
=
«« 
$str
«« 8
,
««8 9
remainingBalance
»»  
=
»»! "
prepaid
»»# *
.
»»* +
RemainingBalance
»»+ ;
,
»»; <
	paymentId
…… 
=
…… 
payment
…… #
.
……# $
	PaymentID
……$ -
,
……- .
promoId
   
=
   
promo
   
.
    
PrepaidPromoID
    .
,
  . /

promoTitle
ÀÀ 
=
ÀÀ 
request
ÀÀ $
.
ÀÀ$ %

PromoTitle
ÀÀ% /
,
ÀÀ/ 0
	promoData
ÃÃ 
=
ÃÃ 
request
ÃÃ #
.
ÃÃ# $
	PromoData
ÃÃ$ -
,
ÃÃ- .
promoValidity
ÕÕ 
=
ÕÕ 
request
ÕÕ  '
.
ÕÕ' (
PromoValidity
ÕÕ( 5
,
ÕÕ5 6
totalDataMB
ŒŒ 
,
ŒŒ 
remainingDataMB
œœ 
=
œœ  !
totalDataMB
œœ" -
}
–– 
)
–– 
;
–– 
}
—— 	
[
”” 	
HttpGet
””	 
(
”” 
$str
”” -
)
””- .
]
””. /
public
‘‘ 
async
‘‘ 
Task
‘‘ 
<
‘‘ 
IActionResult
‘‘ '
>
‘‘' (
GetActivePromos
‘‘) 8
(
‘‘8 9
int
‘‘9 <
id
‘‘= ?
)
‘‘? @
{
’’ 	
var
÷÷ 
userId
÷÷ 
=
÷÷ 
User
÷÷ 
.
÷÷ 
	FindFirst
÷÷ '
(
÷÷' (
System
÷÷( .
.
÷÷. /
Security
÷÷/ 7
.
÷÷7 8
Claims
÷÷8 >
.
÷÷> ?

ClaimTypes
÷÷? I
.
÷÷I J
NameIdentifier
÷÷J X
)
÷÷X Y
?
÷÷Y Z
.
÷÷Z [
Value
÷÷[ `
;
÷÷` a
var
◊◊ 
prepaid
◊◊ 
=
◊◊ 
await
◊◊ 
_context
◊◊  (
.
◊◊( )
PrepaidLoads
◊◊) 5
.
ÿÿ 
Include
ÿÿ 
(
ÿÿ 
p
ÿÿ 
=>
ÿÿ 
p
ÿÿ 
.
ÿÿ  
ServiceAccount
ÿÿ  .
)
ÿÿ. /
.
ŸŸ 
ThenInclude
ŸŸ  
(
ŸŸ  !
sa
ŸŸ! #
=>
ŸŸ$ &
sa
ŸŸ' )
.
ŸŸ) *
Device
ŸŸ* 0
)
ŸŸ0 1
.
⁄⁄ !
FirstOrDefaultAsync
⁄⁄ $
(
⁄⁄$ %
p
⁄⁄% &
=>
⁄⁄' )
p
⁄⁄* +
.
⁄⁄+ ,
PrepaidLoadID
⁄⁄, 9
==
⁄⁄: <
id
⁄⁄= ?
&&
⁄⁄@ B
p
⁄⁄C D
.
⁄⁄D E
ServiceAccount
⁄⁄E S
.
⁄⁄S T
Device
⁄⁄T Z
.
⁄⁄Z [
UserID
⁄⁄[ a
==
⁄⁄b d
userId
⁄⁄e k
)
⁄⁄k l
;
⁄⁄l m
if
‹‹ 
(
‹‹ 
prepaid
‹‹ 
==
‹‹ 
null
‹‹ 
)
‹‹  
return
‹‹! '
NotFound
‹‹( 0
(
‹‹0 1
new
‹‹1 4
{
‹‹5 6
message
‹‹7 >
=
‹‹? @
$str
‹‹A \
}
‹‹] ^
)
‹‹^ _
;
‹‹_ `
var
ﬁﬁ 
expiredPromos
ﬁﬁ 
=
ﬁﬁ 
await
ﬁﬁ  %
_context
ﬁﬁ& .
.
ﬁﬁ. /
PrepaidPromos
ﬁﬁ/ <
.
ﬂﬂ 
Where
ﬂﬂ 
(
ﬂﬂ 
p
ﬂﬂ 
=>
ﬂﬂ 
p
ﬂﬂ 
.
ﬂﬂ 
PrepaidLoadID
ﬂﬂ +
==
ﬂﬂ, .
id
ﬂﬂ/ 1
&&
ﬂﬂ2 4
p
ﬂﬂ5 6
.
ﬂﬂ6 7
UserID
ﬂﬂ7 =
==
ﬂﬂ> @
userId
ﬂﬂA G
&&
ﬂﬂH J
p
ﬂﬂK L
.
ﬂﬂL M
Status
ﬂﬂM S
==
ﬂﬂT V
$str
ﬂﬂW _
&&
ﬂﬂ` b
p
ﬂﬂc d
.
ﬂﬂd e
	ExpiresAt
ﬂﬂe n
<=
ﬂﬂo q
DateTime
ﬂﬂr z
.
ﬂﬂz {
UtcNowﬂﬂ{ Å
)ﬂﬂÅ Ç
.
‡‡ 
ToListAsync
‡‡ 
(
‡‡ 
)
‡‡ 
;
‡‡ 
foreach
·· 
(
·· 
var
·· 
ep
·· 
in
·· 
expiredPromos
·· ,
)
··, -
ep
··. 0
.
··0 1
Status
··1 7
=
··8 9
$str
··: C
;
··C D
if
‚‚ 
(
‚‚ 
expiredPromos
‚‚ 
.
‚‚ 
Any
‚‚ !
(
‚‚! "
)
‚‚" #
)
‚‚# $
await
‚‚% *
_context
‚‚+ 3
.
‚‚3 4
SaveChangesAsync
‚‚4 D
(
‚‚D E
)
‚‚E F
;
‚‚F G
var
‰‰ 
promos
‰‰ 
=
‰‰ 
await
‰‰ 
_context
‰‰ '
.
‰‰' (
PrepaidPromos
‰‰( 5
.
ÂÂ 
Where
ÂÂ 
(
ÂÂ 
p
ÂÂ 
=>
ÂÂ 
p
ÂÂ 
.
ÂÂ 
PrepaidLoadID
ÂÂ +
==
ÂÂ, .
id
ÂÂ/ 1
&&
ÂÂ2 4
p
ÂÂ5 6
.
ÂÂ6 7
UserID
ÂÂ7 =
==
ÂÂ> @
userId
ÂÂA G
&&
ÂÂH J
p
ÂÂK L
.
ÂÂL M
Status
ÂÂM S
==
ÂÂT V
$str
ÂÂW _
)
ÂÂ_ `
.
ÊÊ 
OrderByDescending
ÊÊ "
(
ÊÊ" #
p
ÊÊ# $
=>
ÊÊ% '
p
ÊÊ( )
.
ÊÊ) *
ActivatedAt
ÊÊ* 5
)
ÊÊ5 6
.
ÁÁ 
Select
ÁÁ 
(
ÁÁ 
p
ÁÁ 
=>
ÁÁ 
new
ÁÁ  
{
ÁÁ! "
p
ËË 
.
ËË 
PrepaidPromoID
ËË $
,
ËË$ %
p
ÈÈ 
.
ÈÈ 

PromoTitle
ÈÈ  
,
ÈÈ  !
p
ÍÍ 
.
ÍÍ 
TotalDataMB
ÍÍ !
,
ÍÍ! "
p
ÎÎ 
.
ÎÎ 
RemainingDataMB
ÎÎ %
,
ÎÎ% &
p
ÏÏ 
.
ÏÏ 
ValidityDays
ÏÏ "
,
ÏÏ" #
p
ÌÌ 
.
ÌÌ 
ActivatedAt
ÌÌ !
,
ÌÌ! "
p
ÓÓ 
.
ÓÓ 
	ExpiresAt
ÓÓ 
,
ÓÓ  
p
ÔÔ 
.
ÔÔ 
Status
ÔÔ 
}
 
)
 
.
ÒÒ 
ToListAsync
ÒÒ 
(
ÒÒ 
)
ÒÒ 
;
ÒÒ 
return
ÛÛ 
Ok
ÛÛ 
(
ÛÛ 
promos
ÛÛ 
)
ÛÛ 
;
ÛÛ 
}
ÙÙ 	
[
ˆˆ 	
HttpPost
ˆˆ	 
(
ˆˆ 
$str
ˆˆ ,
)
ˆˆ, -
]
ˆˆ- .
public
˜˜ 
async
˜˜ 
Task
˜˜ 
<
˜˜ 
IActionResult
˜˜ '
>
˜˜' (
TopUpPrepaidGCash
˜˜) :
(
˜˜: ;
int
˜˜; >
id
˜˜? A
,
˜˜A B
[
˜˜C D
FromBody
˜˜D L
]
˜˜L M
TopUpRequest
˜˜N Z
request
˜˜[ b
)
˜˜b c
{
¯¯ 	
var
˘˘ 
userId
˘˘ 
=
˘˘ 
User
˘˘ 
.
˘˘ 
	FindFirst
˘˘ '
(
˘˘' (
System
˘˘( .
.
˘˘. /
Security
˘˘/ 7
.
˘˘7 8
Claims
˘˘8 >
.
˘˘> ?

ClaimTypes
˘˘? I
.
˘˘I J
NameIdentifier
˘˘J X
)
˘˘X Y
?
˘˘Y Z
.
˘˘Z [
Value
˘˘[ `
;
˘˘` a
var
˙˙ 
prepaid
˙˙ 
=
˙˙ 
await
˙˙ 
_context
˙˙  (
.
˙˙( )
PrepaidLoads
˙˙) 5
.
˚˚ 
Include
˚˚ 
(
˚˚ 
p
˚˚ 
=>
˚˚ 
p
˚˚ 
.
˚˚  
ServiceAccount
˚˚  .
)
˚˚. /
.
¸¸ 
ThenInclude
¸¸  
(
¸¸  !
sa
¸¸! #
=>
¸¸$ &
sa
¸¸' )
.
¸¸) *
Device
¸¸* 0
)
¸¸0 1
.
˝˝ !
FirstOrDefaultAsync
˝˝ $
(
˝˝$ %
p
˝˝% &
=>
˝˝' )
p
˝˝* +
.
˝˝+ ,
PrepaidLoadID
˝˝, 9
==
˝˝: <
id
˝˝= ?
&&
˝˝@ B
p
˝˝C D
.
˝˝D E
ServiceAccount
˝˝E S
.
˝˝S T
Device
˝˝T Z
.
˝˝Z [
UserID
˝˝[ a
==
˝˝b d
userId
˝˝e k
)
˝˝k l
;
˝˝l m
if
ˇˇ 
(
ˇˇ 
prepaid
ˇˇ 
==
ˇˇ 
null
ˇˇ 
)
ˇˇ  
return
ˇˇ! '
NotFound
ˇˇ( 0
(
ˇˇ0 1
new
ˇˇ1 4
{
ˇˇ5 6
message
ˇˇ7 >
=
ˇˇ? @
$str
ˇˇA \
}
ˇˇ] ^
)
ˇˇ^ _
;
ˇˇ_ `
if
ÄÄ 
(
ÄÄ 
request
ÄÄ 
.
ÄÄ 
Amount
ÄÄ 
<=
ÄÄ !
$num
ÄÄ" #
)
ÄÄ# $
return
ÄÄ% +

BadRequest
ÄÄ, 6
(
ÄÄ6 7
new
ÄÄ7 :
{
ÄÄ; <
message
ÄÄ= D
=
ÄÄE F
$str
ÄÄG W
}
ÄÄX Y
)
ÄÄY Z
;
ÄÄZ [
if
ÅÅ 
(
ÅÅ 
request
ÅÅ 
.
ÅÅ 
Amount
ÅÅ 
<
ÅÅ  
$num
ÅÅ! #
)
ÅÅ# $
return
ÅÅ% +

BadRequest
ÅÅ, 6
(
ÅÅ6 7
new
ÅÅ7 :
{
ÅÅ; <
message
ÅÅ= D
=
ÅÅE F
$str
ÅÅG e
}
ÅÅf g
)
ÅÅg h
;
ÅÅh i
try
ÉÉ 
{
ÑÑ 
var
ÖÖ 
invoice
ÖÖ 
=
ÖÖ 
new
ÖÖ !
Invoice
ÖÖ" )
{
ÜÜ 
PrepaidLoadID
áá !
=
áá" #
id
áá$ &
,
áá& '
UserID
àà 
=
àà 
userId
àà #
!
àà# $
,
àà$ %
Amount
ââ 
=
ââ 
request
ââ $
.
ââ$ %
Amount
ââ% +
,
ââ+ ,
DueDate
ää 
=
ää 
DateTime
ää &
.
ää& '
UtcNow
ää' -
.
ää- .
	AddMonths
ää. 7
(
ää7 8
$num
ää8 9
)
ää9 :
,
ää: ;
Status
ãã 
=
ãã 
$str
ãã &
}
åå 
;
åå 
_context
çç 
.
çç 
Invoices
çç !
.
çç! "
Add
çç" %
(
çç% &
invoice
çç& -
)
çç- .
;
çç. /
await
éé 
_context
éé 
.
éé 
SaveChangesAsync
éé /
(
éé/ 0
)
éé0 1
;
éé1 2
var
êê 
(
êê 
sourceId
êê 
,
êê 
checkoutUrl
êê *
)
êê* +
=
êê, -
await
êê. 3
_payMongoService
êê4 D
.
êêD E)
CreateSourceForPrepaidTopUp
êêE `
(
êê` a
request
êêa h
.
êêh i
Amount
êêi o
,
êêo p
id
êêq s
,
êês t
$"
êêu w
$strêêw á
{êêá à
invoiceêêà è
.êêè ê
	InvoiceIDêêê ô
}êêô ö
"êêö õ
)êêõ ú
;êêú ù
if
íí 
(
íí 
string
íí 
.
íí 
IsNullOrEmpty
íí (
(
íí( )
checkoutUrl
íí) 4
)
íí4 5
)
íí5 6
{
ìì 
return
îî 

BadRequest
îî %
(
îî% &
new
îî& )
{
îî* +
message
îî, 3
=
îî4 5
$str
îî6 W
}
îîX Y
)
îîY Z
;
îîZ [
}
ïï 
var
óó 
payment
óó 
=
óó 
new
óó !
Payment
óó" )
{
òò 
UserID
ôô 
=
ôô 
userId
ôô #
!
ôô# $
,
ôô$ %
	InvoiceID
öö 
=
öö 
invoice
öö  '
.
öö' (
	InvoiceID
öö( 1
,
öö1 2

AmountPaid
õõ 
=
õõ  
request
õõ! (
.
õõ( )
Amount
õõ) /
,
õõ/ 0
PaymentMethod
úú !
=
úú" #
$str
úú$ +
,
úú+ ,
PaymentDate
ùù 
=
ùù  !
DateTime
ùù" *
.
ùù* +
UtcNow
ùù+ 1
,
ùù1 2
ReferenceNum
ûû  
=
ûû! "
sourceId
ûû# +
,
ûû+ ,
Status
üü 
=
üü 
$str
üü &
}
†† 
;
†† 
_context
°° 
.
°° 
Payments
°° !
.
°°! "
Add
°°" %
(
°°% &
payment
°°& -
)
°°- .
;
°°. /
await
¢¢ 
_context
¢¢ 
.
¢¢ 
SaveChangesAsync
¢¢ /
(
¢¢/ 0
)
¢¢0 1
;
¢¢1 2
return
§§ 
Ok
§§ 
(
§§ 
new
§§ 
{
§§ 
checkoutUrl
§§  +
=
§§, -
checkoutUrl
§§. 9
,
§§9 :
	paymentId
§§; D
=
§§E F
payment
§§G N
.
§§N O
	PaymentID
§§O X
}
§§Y Z
)
§§Z [
;
§§[ \
}
•• 
catch
¶¶ 
(
¶¶ 
	Exception
¶¶ 
ex
¶¶ 
)
¶¶  
{
ßß 
Console
®® 
.
®® 
	WriteLine
®® !
(
®®! "
$"
®®" $
$str
®®$ =
{
®®= >
ex
®®> @
.
®®@ A
Message
®®A H
}
®®H I
"
®®I J
)
®®J K
;
®®K L
return
©© 

BadRequest
©© !
(
©©! "
new
©©" %
{
©©& '
message
©©( /
=
©©0 1
ex
©©2 4
.
©©4 5
Message
©©5 <
}
©©= >
)
©©> ?
;
©©? @
}
™™ 
}
´´ 	
[
≠≠ 	
HttpPost
≠≠	 
(
≠≠ 
$str
≠≠ /
)
≠≠/ 0
]
≠≠0 1
public
ÆÆ 
async
ÆÆ 
Task
ÆÆ 
<
ÆÆ 
IActionResult
ÆÆ '
>
ÆÆ' ("
CompletePrepaidTopUp
ÆÆ) =
(
ÆÆ= >
int
ÆÆ> A
id
ÆÆB D
)
ÆÆD E
{
ØØ 	
var
∞∞ 
userId
∞∞ 
=
∞∞ 
User
∞∞ 
.
∞∞ 
	FindFirst
∞∞ '
(
∞∞' (
System
∞∞( .
.
∞∞. /
Security
∞∞/ 7
.
∞∞7 8
Claims
∞∞8 >
.
∞∞> ?

ClaimTypes
∞∞? I
.
∞∞I J
NameIdentifier
∞∞J X
)
∞∞X Y
?
∞∞Y Z
.
∞∞Z [
Value
∞∞[ `
;
∞∞` a
var
±± 
prepaid
±± 
=
±± 
await
±± !
GetPrepaidLoadAsync
±±  3
(
±±3 4
id
±±4 6
,
±±6 7
userId
±±8 >
)
±±> ?
;
±±? @
if
≤≤ 
(
≤≤ 
prepaid
≤≤ 
==
≤≤ 
null
≤≤ 
)
≤≤  
return
≥≥ 
NotFound
≥≥ 
(
≥≥  
new
≥≥  #
{
≥≥$ %
message
≥≥& -
=
≥≥. /
$str
≥≥0 K
}
≥≥L M
)
≥≥M N
;
≥≥N O
var
µµ 
pendingPayment
µµ 
=
µµ  
await
µµ! &*
GetLatestPendingPaymentAsync
µµ' C
(
µµC D
id
µµD F
,
µµF G
userId
µµH N
)
µµN O
;
µµO P
if
∂∂ 
(
∂∂ 
pendingPayment
∂∂ 
==
∂∂ !
null
∂∂" &
)
∂∂& '
return
∑∑ 
await
∑∑ .
 BuildNoPendingTopupResponseAsync
∑∑ =
(
∑∑= >
id
∑∑> @
,
∑∑@ A
userId
∑∑B H
,
∑∑H I
prepaid
∑∑J Q
)
∑∑Q R
;
∑∑R S
return
ππ 
await
ππ %
HandlePendingTopupAsync
ππ 0
(
ππ0 1
pendingPayment
ππ1 ?
,
ππ? @
prepaid
ππA H
)
ππH I
;
ππI J
}
∫∫ 	
private
ºº 
Task
ºº 
<
ºº 
PrepaidLoad
ºº  
?
ºº  !
>
ºº! "!
GetPrepaidLoadAsync
ºº# 6
(
ºº6 7
int
ºº7 :
id
ºº; =
,
ºº= >
string
ºº? E
?
ººE F
userId
ººG M
)
ººM N
{
ΩΩ 	
return
ææ 
_context
ææ 
.
ææ 
PrepaidLoads
ææ (
.
øø 
Include
øø 
(
øø 
p
øø 
=>
øø 
p
øø 
.
øø  
ServiceAccount
øø  .
)
øø. /
.
¿¿ 
ThenInclude
¿¿  
(
¿¿  !
sa
¿¿! #
=>
¿¿$ &
sa
¿¿' )
.
¿¿) *
Device
¿¿* 0
)
¿¿0 1
.
¡¡ !
FirstOrDefaultAsync
¡¡ $
(
¡¡$ %
p
¡¡% &
=>
¡¡' )
p
¡¡* +
.
¡¡+ ,
PrepaidLoadID
¡¡, 9
==
¡¡: <
id
¡¡= ?
&&
¡¡@ B
p
¡¡C D
.
¡¡D E
ServiceAccount
¡¡E S
.
¡¡S T
Device
¡¡T Z
.
¡¡Z [
UserID
¡¡[ a
==
¡¡b d
userId
¡¡e k
)
¡¡k l
;
¡¡l m
}
¬¬ 	
private
ƒƒ 
Task
ƒƒ 
<
ƒƒ 
Payment
ƒƒ 
?
ƒƒ 
>
ƒƒ *
GetLatestPendingPaymentAsync
ƒƒ ;
(
ƒƒ; <
int
ƒƒ< ?
id
ƒƒ@ B
,
ƒƒB C
string
ƒƒD J
?
ƒƒJ K
userId
ƒƒL R
)
ƒƒR S
{
≈≈ 	
return
∆∆ 
_context
∆∆ 
.
∆∆ 
Payments
∆∆ $
.
«« 
Include
«« 
(
«« 
p
«« 
=>
«« 
p
«« 
.
««  
Invoice
««  '
)
««' (
.
»» 
Where
»» 
(
»» 
p
»» 
=>
»» 
p
»» 
.
»» 
UserID
»» $
==
»»% '
userId
»»( .
&&
»»/ 1
p
»»2 3
.
»»3 4
Status
»»4 :
==
»»; =
$str
»»> G
&&
»»H J
p
»»K L
.
»»L M
Invoice
»»M T
!=
»»U W
null
»»X \
&&
»»] _
p
»»` a
.
»»a b
Invoice
»»b i
.
»»i j
PrepaidLoadID
»»j w
==
»»x z
id
»»{ }
)
»»} ~
.
…… 
OrderByDescending
…… "
(
……" #
p
……# $
=>
……% '
p
……( )
.
……) *
PaymentDate
……* 5
)
……5 6
.
   !
FirstOrDefaultAsync
   $
(
  $ %
)
  % &
;
  & '
}
ÀÀ 	
private
ÕÕ 
async
ÕÕ 
Task
ÕÕ 
<
ÕÕ 
IActionResult
ÕÕ (
>
ÕÕ( ).
 BuildNoPendingTopupResponseAsync
ÕÕ* J
(
ÕÕJ K
int
ÕÕK N
id
ÕÕO Q
,
ÕÕQ R
string
ÕÕS Y
?
ÕÕY Z
userId
ÕÕ[ a
,
ÕÕa b
PrepaidLoad
ÕÕc n
prepaid
ÕÕo v
)
ÕÕv w
{
ŒŒ 	
var
œœ 
alreadyCompleted
œœ  
=
œœ! "
await
œœ# (
_context
œœ) 1
.
œœ1 2
Payments
œœ2 :
.
–– 
Include
–– 
(
–– 
p
–– 
=>
–– 
p
–– 
.
––  
Invoice
––  '
)
––' (
.
—— 
Where
—— 
(
—— 
p
—— 
=>
—— 
p
—— 
.
—— 
UserID
—— $
==
——% '
userId
——( .
&&
——/ 1
p
——2 3
.
——3 4
Status
——4 :
==
——; =
$str
——> I
&&
——J L
p
——M N
.
——N O
Invoice
——O V
!=
——W Y
null
——Z ^
&&
——_ a
p
——b c
.
——c d
Invoice
——d k
.
——k l
PrepaidLoadID
——l y
==
——z |
id
——} 
)—— Ä
.
““ 
OrderByDescending
““ "
(
““" #
p
““# $
=>
““% '
p
““( )
.
““) *
PaymentDate
““* 5
)
““5 6
.
”” !
FirstOrDefaultAsync
”” $
(
””$ %
)
””% &
;
””& '
if
’’ 
(
’’ 
alreadyCompleted
’’  
!=
’’! #
null
’’$ (
)
’’( )
{
÷÷ 
return
◊◊ 
Ok
◊◊ 
(
◊◊ 
new
◊◊ 
{
ÿÿ 
status
ŸŸ 
=
ŸŸ 
$str
ŸŸ (
,
ŸŸ( )
message
⁄⁄ 
=
⁄⁄ 
$str
⁄⁄ 7
,
⁄⁄7 8
amountAdded
€€ 
=
€€  !
alreadyCompleted
€€" 2
.
€€2 3

AmountPaid
€€3 =
,
€€= >

loadAmount
‹‹ 
=
‹‹  
prepaid
‹‹! (
.
‹‹( )

LoadAmount
‹‹) 3
,
‹‹3 4
remainingBalance
›› $
=
››% &
prepaid
››' .
.
››. /
RemainingBalance
››/ ?
,
››? @

lastReload
ﬁﬁ 
=
ﬁﬁ  
prepaid
ﬁﬁ! (
.
ﬁﬁ( )
LastReloadBalance
ﬁﬁ) :
}
ﬂﬂ 
)
ﬂﬂ 
;
ﬂﬂ 
}
‡‡ 
return
‚‚ 
Ok
‚‚ 
(
‚‚ 
new
‚‚ 
{
‚‚ 
status
‚‚ "
=
‚‚# $
$str
‚‚% .
,
‚‚. /
message
‚‚0 7
=
‚‚8 9
$str
‚‚: [
}
‚‚\ ]
)
‚‚] ^
;
‚‚^ _
}
„„ 	
private
ÂÂ 
async
ÂÂ 
Task
ÂÂ 
<
ÂÂ 
IActionResult
ÂÂ (
>
ÂÂ( )%
HandlePendingTopupAsync
ÂÂ* A
(
ÂÂA B
Payment
ÂÂB I
pendingPayment
ÂÂJ X
,
ÂÂX Y
PrepaidLoad
ÂÂZ e
prepaid
ÂÂf m
)
ÂÂm n
{
ÊÊ 	
try
ÁÁ 
{
ËË 
var
ÈÈ 
sourceStatus
ÈÈ  
=
ÈÈ! "
await
ÈÈ# (
_payMongoService
ÈÈ) 9
.
ÈÈ9 :
GetSourceStatus
ÈÈ: I
(
ÈÈI J
pendingPayment
ÈÈJ X
.
ÈÈX Y
ReferenceNum
ÈÈY e
!
ÈÈe f
)
ÈÈf g
;
ÈÈg h
Console
ÍÍ 
.
ÍÍ 
	WriteLine
ÍÍ !
(
ÍÍ! "
$"
ÍÍ" $
$str
ÍÍ$ D
{
ÍÍD E
pendingPayment
ÍÍE S
.
ÍÍS T
ReferenceNum
ÍÍT `
}
ÍÍ` a
$str
ÍÍa c
{
ÍÍc d
sourceStatus
ÍÍd p
}
ÍÍp q
"
ÍÍq r
)
ÍÍr s
;
ÍÍs t
if
ÏÏ 
(
ÏÏ 
sourceStatus
ÏÏ  
==
ÏÏ! #
$str
ÏÏ$ 0
||
ÏÏ1 3
sourceStatus
ÏÏ4 @
==
ÏÏA C
$str
ÏÏD J
)
ÏÏJ K
return
ÌÌ 
await
ÌÌ   
CompleteTopupAsync
ÌÌ! 3
(
ÌÌ3 4
pendingPayment
ÌÌ4 B
,
ÌÌB C
prepaid
ÌÌD K
)
ÌÌK L
;
ÌÌL M
if
ÔÔ 
(
ÔÔ 
sourceStatus
ÔÔ  
==
ÔÔ! #
$str
ÔÔ$ /
||
ÔÔ0 2
sourceStatus
ÔÔ3 ?
==
ÔÔ@ B
$str
ÔÔC L
)
ÔÔL M
return
 
await
  
FailTopupAsync
! /
(
/ 0
pendingPayment
0 >
)
> ?
;
? @
return
ÚÚ 
Ok
ÚÚ 
(
ÚÚ 
new
ÚÚ 
{
ÚÚ 
status
ÚÚ  &
=
ÚÚ' (
$str
ÚÚ) 2
,
ÚÚ2 3
message
ÚÚ4 ;
=
ÚÚ< =
$str
ÚÚ> r
}
ÚÚs t
)
ÚÚt u
;
ÚÚu v
}
ÛÛ 
catch
ÙÙ 
(
ÙÙ 
	Exception
ÙÙ 
ex
ÙÙ 
)
ÙÙ  
{
ıı 
Console
ˆˆ 
.
ˆˆ 
	WriteLine
ˆˆ !
(
ˆˆ! "
$"
ˆˆ" $
$str
ˆˆ$ P
{
ˆˆP Q
ex
ˆˆQ S
.
ˆˆS T
Message
ˆˆT [
}
ˆˆ[ \
"
ˆˆ\ ]
)
ˆˆ] ^
;
ˆˆ^ _
return
˜˜ 
Ok
˜˜ 
(
˜˜ 
new
˜˜ 
{
˜˜ 
status
˜˜  &
=
˜˜' (
$str
˜˜) 2
,
˜˜2 3
message
˜˜4 ;
=
˜˜< =
$str
˜˜> r
}
˜˜s t
)
˜˜t u
;
˜˜u v
}
¯¯ 
}
˘˘ 	
private
˚˚ 
async
˚˚ 
Task
˚˚ 
<
˚˚ 
IActionResult
˚˚ (
>
˚˚( ) 
CompleteTopupAsync
˚˚* <
(
˚˚< =
Payment
˚˚= D
pendingPayment
˚˚E S
,
˚˚S T
PrepaidLoad
˚˚U `
prepaid
˚˚a h
)
˚˚h i
{
¸¸ 	
pendingPayment
˝˝ 
.
˝˝ 
Status
˝˝ !
=
˝˝" #
$str
˝˝$ /
;
˝˝/ 0
pendingPayment
˛˛ 
.
˛˛ 
PaymentDate
˛˛ &
=
˛˛' (
DateTime
˛˛) 1
.
˛˛1 2
UtcNow
˛˛2 8
;
˛˛8 9
if
ÄÄ 
(
ÄÄ 
pendingPayment
ÄÄ 
.
ÄÄ 
Invoice
ÄÄ &
!=
ÄÄ' )
null
ÄÄ* .
)
ÄÄ. /
pendingPayment
ÅÅ 
.
ÅÅ 
Invoice
ÅÅ &
.
ÅÅ& '
Status
ÅÅ' -
=
ÅÅ. /
$str
ÅÅ0 6
;
ÅÅ6 7
var
ÉÉ 
amountAdded
ÉÉ 
=
ÉÉ 
pendingPayment
ÉÉ ,
.
ÉÉ, -

AmountPaid
ÉÉ- 7
;
ÉÉ7 8
prepaid
ÑÑ 
.
ÑÑ 

LoadAmount
ÑÑ 
+=
ÑÑ !
amountAdded
ÑÑ" -
;
ÑÑ- .
prepaid
ÖÖ 
.
ÖÖ 
RemainingBalance
ÖÖ $
=
ÖÖ% &
(
ÖÖ' (
prepaid
ÖÖ( /
.
ÖÖ/ 0
RemainingBalance
ÖÖ0 @
??
ÖÖA C
$num
ÖÖD E
)
ÖÖE F
+
ÖÖG H
amountAdded
ÖÖI T
;
ÖÖT U
prepaid
ÜÜ 
.
ÜÜ 
LastReloadBalance
ÜÜ %
=
ÜÜ& '
DateTime
ÜÜ( 0
.
ÜÜ0 1
UtcNow
ÜÜ1 7
;
ÜÜ7 8
await
àà 
_context
àà 
.
àà 
SaveChangesAsync
àà +
(
àà+ ,
)
àà, -
;
àà- .
return
ää 
Ok
ää 
(
ää 
new
ää 
{
ãã 
status
åå 
=
åå 
$str
åå $
,
åå$ %
message
çç 
=
çç 
$str
çç :
,
çç: ;
amountAdded
éé 
,
éé 

loadAmount
èè 
=
èè 
prepaid
èè $
.
èè$ %

LoadAmount
èè% /
,
èè/ 0
remainingBalance
êê  
=
êê! "
prepaid
êê# *
.
êê* +
RemainingBalance
êê+ ;
,
êê; <

lastReload
ëë 
=
ëë 
prepaid
ëë $
.
ëë$ %
LastReloadBalance
ëë% 6
}
íí 
)
íí 
;
íí 
}
ìì 	
private
ïï 
async
ïï 
Task
ïï 
<
ïï 
IActionResult
ïï (
>
ïï( )
FailTopupAsync
ïï* 8
(
ïï8 9
Payment
ïï9 @
pendingPayment
ïïA O
)
ïïO P
{
ññ 	
pendingPayment
óó 
.
óó 
Status
óó !
=
óó" #
$str
óó$ ,
;
óó, -
if
òò 
(
òò 
pendingPayment
òò 
.
òò 
Invoice
òò &
!=
òò' )
null
òò* .
)
òò. /
pendingPayment
ôô 
.
ôô 
Invoice
ôô &
.
ôô& '
Status
ôô' -
=
ôô. /
$str
ôô0 8
;
ôô8 9
await
õõ 
_context
õõ 
.
õõ 
SaveChangesAsync
õõ +
(
õõ+ ,
)
õõ, -
;
õõ- .
return
úú 
Ok
úú 
(
úú 
new
úú 
{
úú 
status
úú "
=
úú# $
$str
úú% -
,
úú- .
message
úú/ 6
=
úú7 8
$str
úú9 \
}
úú] ^
)
úú^ _
;
úú_ `
}
ùù 	
[
°° 	
HttpGet
°°	 
(
°° 
$str
°° 
)
°° 
]
°° 
public
¢¢ 
async
¢¢ 
Task
¢¢ 
<
¢¢ 
IActionResult
¢¢ '
>
¢¢' (
GetInvoices
¢¢) 4
(
¢¢4 5
)
¢¢5 6
{
££ 	
try
§§ 
{
•• 
var
¶¶ 
userId
¶¶ 
=
¶¶ 
User
¶¶ !
.
¶¶! "
	FindFirst
¶¶" +
(
¶¶+ ,
System
¶¶, 2
.
¶¶2 3
Security
¶¶3 ;
.
¶¶; <
Claims
¶¶< B
.
¶¶B C

ClaimTypes
¶¶C M
.
¶¶M N
NameIdentifier
¶¶N \
)
¶¶\ ]
?
¶¶] ^
.
¶¶^ _
Value
¶¶_ d
;
¶¶d e
var
ßß 
invoices
ßß 
=
ßß 
await
ßß $
_context
ßß% -
.
ßß- .
Invoices
ßß. 6
.
®® 
Include
®® 
(
®® 
i
®® 
=>
®® !
i
®®" #
.
®®# $
Payments
®®$ ,
)
®®, -
.
©© 
Where
©© 
(
©© 
i
©© 
=>
©© 
i
©©  !
.
©©! "
UserID
©©" (
==
©©) +
userId
©©, 2
)
©©2 3
.
™™ 
OrderByDescending
™™ &
(
™™& '
i
™™' (
=>
™™) +
i
™™, -
.
™™- .
	CreatedAt
™™. 7
)
™™7 8
.
´´ 
Select
´´ 
(
´´ 
i
´´ 
=>
´´  
new
´´! $
{
¨¨ 
i
≠≠ 
.
≠≠ 
	InvoiceID
≠≠ #
,
≠≠# $
i
ÆÆ 
.
ÆÆ 
SubscriptionID
ÆÆ (
,
ÆÆ( )
i
ØØ 
.
ØØ 
UserID
ØØ  
,
ØØ  !
i
∞∞ 
.
∞∞ 
Amount
∞∞  
,
∞∞  !
i
±± 
.
±± 
DueDate
±± !
,
±±! "
i
≤≤ 
.
≤≤ 
Status
≤≤  
,
≤≤  !
i
≥≥ 
.
≥≥ 
	CreatedAt
≥≥ #
,
≥≥# $
Payments
¥¥  
=
¥¥! "
i
¥¥# $
.
¥¥$ %
Payments
¥¥% -
.
¥¥- .
Select
¥¥. 4
(
¥¥4 5
p
¥¥5 6
=>
¥¥7 9
new
¥¥: =
{
¥¥> ?
p
¥¥@ A
.
¥¥A B
	PaymentID
¥¥B K
,
¥¥K L
p
¥¥M N
.
¥¥N O
Status
¥¥O U
,
¥¥U V
p
¥¥W X
.
¥¥X Y
ReferenceNum
¥¥Y e
}
¥¥f g
)
¥¥g h
.
¥¥h i
ToList
¥¥i o
(
¥¥o p
)
¥¥p q
}
µµ 
)
µµ 
.
∂∂ 
ToListAsync
∂∂  
(
∂∂  !
)
∂∂! "
;
∂∂" #
return
∑∑ 
Ok
∑∑ 
(
∑∑ 
invoices
∑∑ "
)
∑∑" #
;
∑∑# $
}
∏∏ 
catch
ππ 
(
ππ 
	Exception
ππ 
ex
ππ 
)
ππ  
{
∫∫ 
return
ªª 

StatusCode
ªª !
(
ªª! "
$num
ªª" %
,
ªª% &
new
ªª' *
{
ªª+ ,
message
ªª- 4
=
ªª5 6
$"
ªª7 9
$str
ªª9 S
{
ªªS T
ex
ªªT V
.
ªªV W
Message
ªªW ^
}
ªª^ _
"
ªª_ `
}
ªªa b
)
ªªb c
;
ªªc d
}
ºº 
}
ΩΩ 	
[
øø 	
HttpGet
øø	 
(
øø 
$str
øø 
)
øø 
]
øø 
public
¿¿ 
async
¿¿ 
Task
¿¿ 
<
¿¿ 
IActionResult
¿¿ '
>
¿¿' (
GetPayments
¿¿) 4
(
¿¿4 5
)
¿¿5 6
{
¡¡ 	
try
¬¬ 
{
√√ 
var
ƒƒ 
userId
ƒƒ 
=
ƒƒ 
User
ƒƒ !
.
ƒƒ! "
	FindFirst
ƒƒ" +
(
ƒƒ+ ,
System
ƒƒ, 2
.
ƒƒ2 3
Security
ƒƒ3 ;
.
ƒƒ; <
Claims
ƒƒ< B
.
ƒƒB C

ClaimTypes
ƒƒC M
.
ƒƒM N
NameIdentifier
ƒƒN \
)
ƒƒ\ ]
?
ƒƒ] ^
.
ƒƒ^ _
Value
ƒƒ_ d
;
ƒƒd e
var
≈≈ 
payments
≈≈ 
=
≈≈ 
await
≈≈ $
_context
≈≈% -
.
≈≈- .
Payments
≈≈. 6
.
∆∆ 
Where
∆∆ 
(
∆∆ 
p
∆∆ 
=>
∆∆ 
p
∆∆  !
.
∆∆! "
UserID
∆∆" (
==
∆∆) +
userId
∆∆, 2
)
∆∆2 3
.
«« 
OrderByDescending
«« &
(
««& '
p
««' (
=>
««) +
p
««, -
.
««- .
PaymentDate
««. 9
)
««9 :
.
»» 
Select
»» 
(
»» 
p
»» 
=>
»»  
new
»»! $
{
…… 
p
   
.
   
	PaymentID
   #
,
  # $
p
ÀÀ 
.
ÀÀ 
	InvoiceID
ÀÀ #
,
ÀÀ# $
p
ÃÃ 
.
ÃÃ 
UserID
ÃÃ  
,
ÃÃ  !
p
ÕÕ 
.
ÕÕ 

AmountPaid
ÕÕ $
,
ÕÕ$ %
p
ŒŒ 
.
ŒŒ 
PaymentMethod
ŒŒ '
,
ŒŒ' (
p
œœ 
.
œœ 
ReferenceNum
œœ &
,
œœ& '
p
–– 
.
–– 
PaymentDate
–– %
,
––% &
p
—— 
.
—— 
Status
——  
}
““ 
)
““ 
.
”” 
ToListAsync
””  
(
””  !
)
””! "
;
””" #
return
‘‘ 
Ok
‘‘ 
(
‘‘ 
payments
‘‘ "
)
‘‘" #
;
‘‘# $
}
’’ 
catch
÷÷ 
(
÷÷ 
	Exception
÷÷ 
ex
÷÷ 
)
÷÷  
{
◊◊ 
return
ÿÿ 

StatusCode
ÿÿ !
(
ÿÿ! "
$num
ÿÿ" %
,
ÿÿ% &
new
ÿÿ' *
{
ÿÿ+ ,
message
ÿÿ- 4
=
ÿÿ5 6
$"
ÿÿ7 9
$str
ÿÿ9 S
{
ÿÿS T
ex
ÿÿT V
.
ÿÿV W
Message
ÿÿW ^
}
ÿÿ^ _
"
ÿÿ_ `
}
ÿÿa b
)
ÿÿb c
;
ÿÿc d
}
ŸŸ 
}
⁄⁄ 	
[
‹‹ 	
HttpPut
‹‹	 
(
‹‹ 
$str
‹‹ *
)
‹‹* +
]
‹‹+ ,
public
›› 
async
›› 
Task
›› 
<
›› 
IActionResult
›› '
>
››' ($
UpdateSubscriptionName
››) ?
(
››? @
int
››@ C
id
››D F
,
››F G
[
››H I
FromBody
››I Q
]
››Q R
UpdateNameRequest
››S d
request
››e l
)
››l m
{
ﬁﬁ 	
var
ﬂﬂ 
userId
ﬂﬂ 
=
ﬂﬂ 
User
ﬂﬂ 
.
ﬂﬂ 
	FindFirst
ﬂﬂ '
(
ﬂﬂ' (
System
ﬂﬂ( .
.
ﬂﬂ. /
Security
ﬂﬂ/ 7
.
ﬂﬂ7 8
Claims
ﬂﬂ8 >
.
ﬂﬂ> ?

ClaimTypes
ﬂﬂ? I
.
ﬂﬂI J
NameIdentifier
ﬂﬂJ X
)
ﬂﬂX Y
?
ﬂﬂY Z
.
ﬂﬂZ [
Value
ﬂﬂ[ `
;
ﬂﬂ` a
var
‡‡ 
subscription
‡‡ 
=
‡‡ 
await
‡‡ $
_context
‡‡% -
.
‡‡- .
Subscriptions
‡‡. ;
.
‡‡; <!
FirstOrDefaultAsync
‡‡< O
(
‡‡O P
s
‡‡P Q
=>
‡‡R T
s
‡‡U V
.
‡‡V W
SubscriptionID
‡‡W e
==
‡‡f h
id
‡‡i k
&&
‡‡l n
s
‡‡o p
.
‡‡p q
UserID
‡‡q w
==
‡‡x z
userId‡‡{ Å
)‡‡Å Ç
;‡‡Ç É
if
·· 
(
·· 
subscription
·· 
==
·· 
null
··  $
)
··$ %
return
··& ,
NotFound
··- 5
(
··5 6
)
··6 7
;
··7 8
subscription
„„ 
.
„„ 

DeviceName
„„ #
=
„„$ %
request
„„& -
.
„„- .

DeviceName
„„. 8
;
„„8 9
await
‰‰ 
_context
‰‰ 
.
‰‰ 
SaveChangesAsync
‰‰ +
(
‰‰+ ,
)
‰‰, -
;
‰‰- .
return
ÂÂ 
Ok
ÂÂ 
(
ÂÂ 
new
ÂÂ 
{
ÂÂ 
message
ÂÂ #
=
ÂÂ$ %
$str
ÂÂ& ;
}
ÂÂ< =
)
ÂÂ= >
;
ÂÂ> ?
}
ÊÊ 	
[
ËË 	
HttpPost
ËË	 
(
ËË 
$str
ËË  
)
ËË  !
]
ËË! "
public
ÈÈ 
async
ÈÈ 
Task
ÈÈ 
<
ÈÈ 
IActionResult
ÈÈ '
>
ÈÈ' (
UpgradePlan
ÈÈ) 4
(
ÈÈ4 5
[
ÈÈ5 6
FromBody
ÈÈ6 >
]
ÈÈ> ? 
UpgradePlanRequest
ÈÈ@ R
request
ÈÈS Z
)
ÈÈZ [
{
ÍÍ 	
var
ÎÎ 
userId
ÎÎ 
=
ÎÎ 
User
ÎÎ 
.
ÎÎ 
	FindFirst
ÎÎ '
(
ÎÎ' (
System
ÎÎ( .
.
ÎÎ. /
Security
ÎÎ/ 7
.
ÎÎ7 8
Claims
ÎÎ8 >
.
ÎÎ> ?

ClaimTypes
ÎÎ? I
.
ÎÎI J
NameIdentifier
ÎÎJ X
)
ÎÎX Y
?
ÎÎY Z
.
ÎÎZ [
Value
ÎÎ[ `
;
ÎÎ` a
var
ÏÏ 
user
ÏÏ 
=
ÏÏ 
await
ÏÏ 
_userManager
ÏÏ )
.
ÏÏ) *
FindByIdAsync
ÏÏ* 7
(
ÏÏ7 8
userId
ÏÏ8 >
!
ÏÏ> ?
)
ÏÏ? @
;
ÏÏ@ A
var
ÌÌ 
subscription
ÌÌ 
=
ÌÌ 
await
ÌÌ $
_context
ÌÌ% -
.
ÌÌ- .
Subscriptions
ÌÌ. ;
.
ÓÓ 
Include
ÓÓ 
(
ÓÓ 
s
ÓÓ 
=>
ÓÓ 
s
ÓÓ 
.
ÓÓ  
Plan
ÓÓ  $
)
ÓÓ$ %
.
ÔÔ !
FirstOrDefaultAsync
ÔÔ $
(
ÔÔ$ %
s
ÔÔ% &
=>
ÔÔ' )
s
ÔÔ* +
.
ÔÔ+ ,
SubscriptionID
ÔÔ, :
==
ÔÔ; =
request
ÔÔ> E
.
ÔÔE F
SubscriptionId
ÔÔF T
&&
ÔÔU W
s
ÔÔX Y
.
ÔÔY Z
UserID
ÔÔZ `
==
ÔÔa c
userId
ÔÔd j
)
ÔÔj k
;
ÔÔk l
if
 
(
 
subscription
 
==
 
null
  $
)
$ %
return
& ,
NotFound
- 5
(
5 6
new
6 9
{
: ;
message
< C
=
D E
$"
F H
$str
H V
{
V W
request
W ^
.
^ _
SubscriptionId
_ m
}
m n
$strn â
"â ä
}ã å
)å ç
;ç é
var
ÚÚ 
oldPlan
ÚÚ 
=
ÚÚ 
subscription
ÚÚ &
.
ÚÚ& '
Plan
ÚÚ' +
;
ÚÚ+ ,
var
ÛÛ 
newPlan
ÛÛ 
=
ÛÛ 
await
ÛÛ 
_context
ÛÛ  (
.
ÛÛ( )
SubscriptionPlans
ÛÛ) :
.
ÛÛ: ;
	FindAsync
ÛÛ; D
(
ÛÛD E
request
ÛÛE L
.
ÛÛL M
	NewPlanId
ÛÛM V
)
ÛÛV W
;
ÛÛW X
if
ÙÙ 
(
ÙÙ 
newPlan
ÙÙ 
==
ÙÙ 
null
ÙÙ 
)
ÙÙ  
return
ÙÙ! '
NotFound
ÙÙ( 0
(
ÙÙ0 1
new
ÙÙ1 4
{
ÙÙ5 6
message
ÙÙ7 >
=
ÙÙ? @
$str
ÙÙA Q
}
ÙÙR S
)
ÙÙS T
;
ÙÙT U
var
ˆˆ 

planChange
ˆˆ 
=
ˆˆ 
(
ˆˆ 
oldPlan
ˆˆ %
.
ˆˆ% &
	SpeedMbps
ˆˆ& /
??
ˆˆ0 2
$num
ˆˆ3 4
)
ˆˆ4 5
<
ˆˆ6 7
(
ˆˆ8 9
newPlan
ˆˆ9 @
.
ˆˆ@ A
	SpeedMbps
ˆˆA J
??
ˆˆK M
$num
ˆˆN O
)
ˆˆO P
?
ˆˆQ R
$str
ˆˆS ]
:
ˆˆ^ _
$str
ˆˆ` l
;
ˆˆl m
subscription
˜˜ 
.
˜˜ 
PlanID
˜˜ 
=
˜˜  !
request
˜˜" )
.
˜˜) *
	NewPlanId
˜˜* 3
;
˜˜3 4
await
¯¯ 
_context
¯¯ 
.
¯¯ 
SaveChangesAsync
¯¯ +
(
¯¯+ ,
)
¯¯, -
;
¯¯- .
var
˙˙ 
planPref
˙˙ 
=
˙˙ 
await
˙˙  
_context
˙˙! )
.
˙˙) *%
NotificationPreferences
˙˙* A
.
˚˚ !
FirstOrDefaultAsync
˚˚ $
(
˚˚$ %
np
˚˚% '
=>
˚˚( *
np
˚˚+ -
.
˚˚- .
UserID
˚˚. 4
==
˚˚5 7
userId
˚˚8 >
&&
˚˚? A
np
˚˚B D
.
˚˚D E
NotificationType
˚˚E U
==
˚˚V X
$str
˚˚Y f
)
˚˚f g
;
˚˚g h
if
¸¸ 
(
¸¸ 
planPref
¸¸ 
?
¸¸ 
.
¸¸ 
EmailEnabled
¸¸ &
!=
¸¸' )
false
¸¸* /
)
¸¸/ 0
{
˝˝ 
try
˛˛ 
{
ˇˇ 
Console
ÄÄ 
.
ÄÄ 
	WriteLine
ÄÄ %
(
ÄÄ% &
$"
ÄÄ& (
$str
ÄÄ( 9
{
ÄÄ9 :
user
ÄÄ: >
!
ÄÄ> ?
.
ÄÄ? @
Email
ÄÄ@ E
}
ÄÄE F
$str
ÄÄF P
{
ÄÄP Q

planChange
ÄÄQ [
}
ÄÄ[ \
"
ÄÄ\ ]
)
ÄÄ] ^
;
ÄÄ^ _
await
ÅÅ 
_emailService
ÅÅ '
.
ÅÅ' (
SendEmailAsync
ÅÅ( 6
(
ÅÅ6 7
user
ÇÇ 
!
ÇÇ 
.
ÇÇ 
Email
ÇÇ #
!
ÇÇ# $
,
ÇÇ$ %
$"
ÉÉ 
$str
ÉÉ 
{
ÉÉ  

planChange
ÉÉ  *
.
ÉÉ* +
ToUpper
ÉÉ+ 2
(
ÉÉ2 3
)
ÉÉ3 4
}
ÉÉ4 5
$str
ÉÉ5 F
"
ÉÉF G
,
ÉÉG H
$"
ÑÑ 
$str
ÑÑ  
{
ÑÑ  !
user
ÑÑ! %
.
ÑÑ% &
	FirstName
ÑÑ& /
}
ÑÑ/ 0
$str
ÑÑ0 L
{
ÑÑL M

planChange
ÑÑM W
}
ÑÑW X
$str
ÑÑX f
{
ÑÑf g
oldPlan
ÑÑg n
.
ÑÑn o
PlanName
ÑÑo w
}
ÑÑw x
$strÑÑx ç
{ÑÑç é
newPlanÑÑé ï
.ÑÑï ñ
PlanNameÑÑñ û
}ÑÑû ü
$strÑÑü ◊
"ÑÑ◊ ÿ
)
ÖÖ 
;
ÖÖ 
Console
ÜÜ 
.
ÜÜ 
	WriteLine
ÜÜ %
(
ÜÜ% &
$str
ÜÜ& @
)
ÜÜ@ A
;
ÜÜA B
}
áá 
catch
àà 
(
àà 
	Exception
àà  
ex
àà! #
)
àà# $
{
ââ 
Console
ää 
.
ää 
	WriteLine
ää %
(
ää% &
$"
ää& (
$str
ää( J
{
ääJ K
ex
ääK M
.
ääM N
Message
ääN U
}
ääU V
"
ääV W
)
ääW X
;
ääX Y
}
ãã 
}
åå 
return
éé 
Ok
éé 
(
éé 
new
éé 
{
éé 
message
éé #
=
éé$ %
$"
éé& (
$str
éé( -
{
éé- .

planChange
éé. 8
}
éé8 9
$str
éé9 F
"
ééF G
}
ééH I
)
ééI J
;
ééJ K
}
èè 	
[
ëë 	
HttpPost
ëë	 
(
ëë 
$str
ëë )
)
ëë) *
]
ëë* +
public
íí 
async
íí 
Task
íí 
<
íí 
IActionResult
íí '
>
íí' (!
CreatePaymentIntent
íí) <
(
íí< =
[
íí= >
FromBody
íí> F
]
ííF G(
CreatePaymentIntentRequest
ííH b
request
ííc j
)
ííj k
{
ìì 	
var
îî 
userId
îî 
=
îî 
User
îî 
.
îî 
	FindFirst
îî '
(
îî' (
System
îî( .
.
îî. /
Security
îî/ 7
.
îî7 8
Claims
îî8 >
.
îî> ?

ClaimTypes
îî? I
.
îîI J
NameIdentifier
îîJ X
)
îîX Y
?
îîY Z
.
îîZ [
Value
îî[ `
;
îî` a
var
ïï 
invoice
ïï 
=
ïï 
await
ïï 
_context
ïï  (
.
ïï( )
Invoices
ïï) 1
.
ïï1 2!
FirstOrDefaultAsync
ïï2 E
(
ïïE F
i
ïïF G
=>
ïïH J
i
ïïK L
.
ïïL M
	InvoiceID
ïïM V
==
ïïW Y
request
ïïZ a
.
ïïa b
	InvoiceId
ïïb k
&&
ïïl n
i
ïïo p
.
ïïp q
UserID
ïïq w
==
ïïx z
userIdïï{ Å
)ïïÅ Ç
;ïïÇ É
if
ññ 
(
ññ 
invoice
ññ 
==
ññ 
null
ññ 
)
ññ  
return
ññ! '
NotFound
ññ( 0
(
ññ0 1
new
ññ1 4
{
ññ5 6
message
ññ7 >
=
ññ? @
$str
ññA T
}
ññU V
)
ññV W
;
ññW X
var
òò 
paymentIntentId
òò 
=
òò  !
await
òò" '
_payMongoService
òò( 8
.
òò8 9!
CreatePaymentIntent
òò9 L
(
òòL M
invoice
òòM T
.
òòT U
Amount
òòU [
,
òò[ \
$"
òò] _
$str
òò_ h
{
òòh i
invoice
òòi p
.
òòp q
	InvoiceID
òòq z
}
òòz {
"
òò{ |
)
òò| }
;
òò} ~
return
ôô 
Ok
ôô 
(
ôô 
new
ôô 
{
ôô 
paymentIntentId
ôô +
,
ôô+ ,
amount
ôô- 3
=
ôô4 5
invoice
ôô6 =
.
ôô= >
Amount
ôô> D
}
ôôE F
)
ôôF G
;
ôôG H
}
öö 	
[
úú 	
HttpPost
úú	 
(
úú 
$str
úú '
)
úú' (
]
úú( )
public
ùù 
async
ùù 
Task
ùù 
<
ùù 
IActionResult
ùù '
>
ùù' (
SavePaymentMethod
ùù) :
(
ùù: ;
[
ùù; <
FromBody
ùù< D
]
ùùD E&
SavePaymentMethodRequest
ùùF ^
request
ùù_ f
)
ùùf g
{
ûû 	
var
üü 
userId
üü 
=
üü 
User
üü 
.
üü 
	FindFirst
üü '
(
üü' (
System
üü( .
.
üü. /
Security
üü/ 7
.
üü7 8
Claims
üü8 >
.
üü> ?

ClaimTypes
üü? I
.
üüI J
NameIdentifier
üüJ X
)
üüX Y
?
üüY Z
.
üüZ [
Value
üü[ `
;
üü` a
var
†† 
details
†† 
=
†† 
new
†† 
PaymentDetails
†† ,
{
°° 

CardNumber
¢¢ 
=
¢¢ 
request
¢¢ $
.
¢¢$ %

CardNumber
¢¢% /
,
¢¢/ 0
ExpMonth
££ 
=
££ 
request
££ "
.
££" #
ExpMonth
££# +
,
££+ ,
ExpYear
§§ 
=
§§ 
request
§§ !
.
§§! "
ExpYear
§§" )
,
§§) *
Cvc
•• 
=
•• 
request
•• 
.
•• 
Cvc
•• !
}
¶¶ 
;
¶¶ 
var
ßß 
paymentMethodId
ßß 
=
ßß  !
await
ßß" '
_payMongoService
ßß( 8
.
ßß8 9!
CreatePaymentMethod
ßß9 L
(
ßßL M
$str
ßßM S
,
ßßS T
details
ßßU \
)
ßß\ ]
;
ßß] ^
if
©© 
(
©© 
request
©© 
.
©© 
	IsDefault
©© !
)
©©! "
{
™™ 
var
´´ 
existingMethods
´´ #
=
´´$ %
await
´´& +
_context
´´, 4
.
´´4 5!
SavedPaymentMethods
´´5 H
.
´´H I
Where
´´I N
(
´´N O
pm
´´O Q
=>
´´R T
pm
´´U W
.
´´W X
UserID
´´X ^
==
´´_ a
userId
´´b h
)
´´h i
.
´´i j
ToListAsync
´´j u
(
´´u v
)
´´v w
;
´´w x
foreach
¨¨ 
(
¨¨ 
var
¨¨ 
method
¨¨ #
in
¨¨$ &
existingMethods
¨¨' 6
)
¨¨6 7
method
¨¨8 >
.
¨¨> ?
	IsDefault
¨¨? H
=
¨¨I J
false
¨¨K P
;
¨¨P Q
}
≠≠ 
var
ØØ 
savedMethod
ØØ 
=
ØØ 
new
ØØ ! 
SavedPaymentMethod
ØØ" 4
{
∞∞ 
UserID
±± 
=
±± 
userId
±± 
!
±±  
,
±±  !%
PayMongoPaymentMethodId
≤≤ '
=
≤≤( )
paymentMethodId
≤≤* 9
,
≤≤9 :
Type
≥≥ 
=
≥≥ 
$str
≥≥ 
,
≥≥ 
Last4
¥¥ 
=
¥¥ 
request
¥¥ 
.
¥¥  

CardNumber
¥¥  *
.
¥¥* +
	Substring
¥¥+ 4
(
¥¥4 5
request
¥¥5 <
.
¥¥< =

CardNumber
¥¥= G
.
¥¥G H
Length
¥¥H N
-
¥¥O P
$num
¥¥Q R
)
¥¥R S
,
¥¥S T
Brand
µµ 
=
µµ 
$str
µµ 
,
µµ 
ExpMonth
∂∂ 
=
∂∂ 
request
∂∂ "
.
∂∂" #
ExpMonth
∂∂# +
,
∂∂+ ,
ExpYear
∑∑ 
=
∑∑ 
request
∑∑ !
.
∑∑! "
ExpYear
∑∑" )
,
∑∑) *
	IsDefault
∏∏ 
=
∏∏ 
request
∏∏ #
.
∏∏# $
	IsDefault
∏∏$ -
}
ππ 
;
ππ 
_context
∫∫ 
.
∫∫ !
SavedPaymentMethods
∫∫ (
.
∫∫( )
Add
∫∫) ,
(
∫∫, -
savedMethod
∫∫- 8
)
∫∫8 9
;
∫∫9 :
await
ªª 
_context
ªª 
.
ªª 
SaveChangesAsync
ªª +
(
ªª+ ,
)
ªª, -
;
ªª- .
return
ΩΩ 
Ok
ΩΩ 
(
ΩΩ 
new
ΩΩ 
{
ΩΩ 
message
ΩΩ #
=
ΩΩ$ %
$str
ΩΩ& I
,
ΩΩI J
paymentMethodId
ΩΩK Z
=
ΩΩ[ \
savedMethod
ΩΩ] h
.
ΩΩh i
PaymentMethodID
ΩΩi x
}
ΩΩy z
)
ΩΩz {
;
ΩΩ{ |
}
ææ 	
[
¿¿ 	
HttpPost
¿¿	 
(
¿¿ 
$str
¿¿ %
)
¿¿% &
]
¿¿& '
public
¡¡ 
async
¡¡ 
Task
¡¡ 
<
¡¡ 
IActionResult
¡¡ '
>
¡¡' (
SaveGCashMethod
¡¡) 8
(
¡¡8 9
[
¡¡9 :
FromBody
¡¡: B
]
¡¡B C$
SaveGCashMethodRequest
¡¡D Z
request
¡¡[ b
)
¡¡b c
{
¬¬ 	
var
√√ 
userId
√√ 
=
√√ 
User
√√ 
.
√√ 
	FindFirst
√√ '
(
√√' (
System
√√( .
.
√√. /
Security
√√/ 7
.
√√7 8
Claims
√√8 >
.
√√> ?

ClaimTypes
√√? I
.
√√I J
NameIdentifier
√√J X
)
√√X Y
?
√√Y Z
.
√√Z [
Value
√√[ `
;
√√` a
if
∆∆ 
(
∆∆ 
request
∆∆ 
.
∆∆ 
	IsDefault
∆∆ !
)
∆∆! "
{
«« 
var
»» 
existingMethods
»» #
=
»»$ %
await
»»& +
_context
»», 4
.
»»4 5!
SavedPaymentMethods
»»5 H
.
»»H I
Where
»»I N
(
»»N O
pm
»»O Q
=>
»»R T
pm
»»U W
.
»»W X
UserID
»»X ^
==
»»_ a
userId
»»b h
)
»»h i
.
»»i j
ToListAsync
»»j u
(
»»u v
)
»»v w
;
»»w x
foreach
…… 
(
…… 
var
…… 
method
…… #
in
……$ &
existingMethods
……' 6
)
……6 7
method
……8 >
.
……> ?
	IsDefault
……? H
=
……I J
false
……K P
;
……P Q
}
   
var
ÃÃ 
savedMethod
ÃÃ 
=
ÃÃ 
new
ÃÃ ! 
SavedPaymentMethod
ÃÃ" 4
{
ÕÕ 
UserID
ŒŒ 
=
ŒŒ 
userId
ŒŒ 
!
ŒŒ  
,
ŒŒ  !%
PayMongoPaymentMethodId
œœ '
=
œœ( )
$str
œœ* 2
+
œœ3 4
Guid
œœ5 9
.
œœ9 :
NewGuid
œœ: A
(
œœA B
)
œœB C
.
œœC D
ToString
œœD L
(
œœL M
)
œœM N
,
œœN O
Type
–– 
=
–– 
$str
–– 
,
–– 
Last4
—— 
=
—— 
request
—— 
.
——  
PhoneNumber
——  +
,
——+ ,
	IsDefault
““ 
=
““ 
request
““ #
.
““# $
	IsDefault
““$ -
}
”” 
;
”” 
_context
‘‘ 
.
‘‘ !
SavedPaymentMethods
‘‘ (
.
‘‘( )
Add
‘‘) ,
(
‘‘, -
savedMethod
‘‘- 8
)
‘‘8 9
;
‘‘9 :
await
’’ 
_context
’’ 
.
’’ 
SaveChangesAsync
’’ +
(
’’+ ,
)
’’, -
;
’’- .
return
◊◊ 
Ok
◊◊ 
(
◊◊ 
new
◊◊ 
{
◊◊ 
message
◊◊ #
=
◊◊$ %
$str
◊◊& G
,
◊◊G H
paymentMethodId
◊◊I X
=
◊◊Y Z
savedMethod
◊◊[ f
.
◊◊f g
PaymentMethodID
◊◊g v
}
◊◊w x
)
◊◊x y
;
◊◊y z
}
ÿÿ 	
[
⁄⁄ 	
HttpGet
⁄⁄	 
(
⁄⁄ 
$str
⁄⁄ "
)
⁄⁄" #
]
⁄⁄# $
public
€€ 
async
€€ 
Task
€€ 
<
€€ 
IActionResult
€€ '
>
€€' (
GetPaymentMethods
€€) :
(
€€: ;
)
€€; <
{
‹‹ 	
var
›› 
userId
›› 
=
›› 
User
›› 
.
›› 
	FindFirst
›› '
(
››' (
System
››( .
.
››. /
Security
››/ 7
.
››7 8
Claims
››8 >
.
››> ?

ClaimTypes
››? I
.
››I J
NameIdentifier
››J X
)
››X Y
?
››Y Z
.
››Z [
Value
››[ `
;
››` a
var
ﬁﬁ 
methods
ﬁﬁ 
=
ﬁﬁ 
await
ﬁﬁ 
_context
ﬁﬁ  (
.
ﬁﬁ( )!
SavedPaymentMethods
ﬁﬁ) <
.
ﬁﬁ< =
Where
ﬁﬁ= B
(
ﬁﬁB C
pm
ﬁﬁC E
=>
ﬁﬁF H
pm
ﬁﬁI K
.
ﬁﬁK L
UserID
ﬁﬁL R
==
ﬁﬁS U
userId
ﬁﬁV \
)
ﬁﬁ\ ]
.
ﬁﬁ] ^
ToListAsync
ﬁﬁ^ i
(
ﬁﬁi j
)
ﬁﬁj k
;
ﬁﬁk l
return
ﬂﬂ 
Ok
ﬂﬂ 
(
ﬂﬂ 
methods
ﬂﬂ 
)
ﬂﬂ 
;
ﬂﬂ 
}
‡‡ 	
[
‚‚ 	

HttpDelete
‚‚	 
(
‚‚ 
$str
‚‚ *
)
‚‚* +
]
‚‚+ ,
public
„„ 
async
„„ 
Task
„„ 
<
„„ 
IActionResult
„„ '
>
„„' (!
DeletePaymentMethod
„„) <
(
„„< =
int
„„= @
id
„„A C
)
„„C D
{
‰‰ 	
var
ÂÂ 
userId
ÂÂ 
=
ÂÂ 
User
ÂÂ 
.
ÂÂ 
	FindFirst
ÂÂ '
(
ÂÂ' (
System
ÂÂ( .
.
ÂÂ. /
Security
ÂÂ/ 7
.
ÂÂ7 8
Claims
ÂÂ8 >
.
ÂÂ> ?

ClaimTypes
ÂÂ? I
.
ÂÂI J
NameIdentifier
ÂÂJ X
)
ÂÂX Y
?
ÂÂY Z
.
ÂÂZ [
Value
ÂÂ[ `
;
ÂÂ` a
var
ÊÊ 
method
ÊÊ 
=
ÊÊ 
await
ÊÊ 
_context
ÊÊ '
.
ÊÊ' (!
SavedPaymentMethods
ÊÊ( ;
.
ÊÊ; <!
FirstOrDefaultAsync
ÊÊ< O
(
ÊÊO P
pm
ÊÊP R
=>
ÊÊS U
pm
ÊÊV X
.
ÊÊX Y
PaymentMethodID
ÊÊY h
==
ÊÊi k
id
ÊÊl n
&&
ÊÊo q
pm
ÊÊr t
.
ÊÊt u
UserID
ÊÊu {
==
ÊÊ| ~
userIdÊÊ Ö
)ÊÊÖ Ü
;ÊÊÜ á
if
ÁÁ 
(
ÁÁ 
method
ÁÁ 
==
ÁÁ 
null
ÁÁ 
)
ÁÁ 
return
ÁÁ  &
NotFound
ÁÁ' /
(
ÁÁ/ 0
)
ÁÁ0 1
;
ÁÁ1 2
_context
ÈÈ 
.
ÈÈ !
SavedPaymentMethods
ÈÈ (
.
ÈÈ( )
Remove
ÈÈ) /
(
ÈÈ/ 0
method
ÈÈ0 6
)
ÈÈ6 7
;
ÈÈ7 8
await
ÍÍ 
_context
ÍÍ 
.
ÍÍ 
SaveChangesAsync
ÍÍ +
(
ÍÍ+ ,
)
ÍÍ, -
;
ÍÍ- .
return
ÎÎ 
Ok
ÎÎ 
(
ÎÎ 
new
ÎÎ 
{
ÎÎ 
message
ÎÎ #
=
ÎÎ$ %
$str
ÎÎ& >
}
ÎÎ? @
)
ÎÎ@ A
;
ÎÎA B
}
ÏÏ 	
[
ÓÓ 	
HttpPut
ÓÓ	 
(
ÓÓ 
$str
ÓÓ /
)
ÓÓ/ 0
]
ÓÓ0 1
public
ÔÔ 
async
ÔÔ 
Task
ÔÔ 
<
ÔÔ 
IActionResult
ÔÔ '
>
ÔÔ' (%
SetDefaultPaymentMethod
ÔÔ) @
(
ÔÔ@ A
int
ÔÔA D
id
ÔÔE G
)
ÔÔG H
{
 	
var
ÒÒ 
userId
ÒÒ 
=
ÒÒ 
User
ÒÒ 
.
ÒÒ 
	FindFirst
ÒÒ '
(
ÒÒ' (
System
ÒÒ( .
.
ÒÒ. /
Security
ÒÒ/ 7
.
ÒÒ7 8
Claims
ÒÒ8 >
.
ÒÒ> ?

ClaimTypes
ÒÒ? I
.
ÒÒI J
NameIdentifier
ÒÒJ X
)
ÒÒX Y
?
ÒÒY Z
.
ÒÒZ [
Value
ÒÒ[ `
;
ÒÒ` a
var
ÚÚ 
methods
ÚÚ 
=
ÚÚ 
await
ÚÚ 
_context
ÚÚ  (
.
ÚÚ( )!
SavedPaymentMethods
ÚÚ) <
.
ÚÚ< =
Where
ÚÚ= B
(
ÚÚB C
pm
ÚÚC E
=>
ÚÚF H
pm
ÚÚI K
.
ÚÚK L
UserID
ÚÚL R
==
ÚÚS U
userId
ÚÚV \
)
ÚÚ\ ]
.
ÚÚ] ^
ToListAsync
ÚÚ^ i
(
ÚÚi j
)
ÚÚj k
;
ÚÚk l
foreach
ÛÛ 
(
ÛÛ 
var
ÛÛ 
method
ÛÛ 
in
ÛÛ  "
methods
ÛÛ# *
)
ÛÛ* +
method
ÛÛ, 2
.
ÛÛ2 3
	IsDefault
ÛÛ3 <
=
ÛÛ= >
method
ÛÛ? E
.
ÛÛE F
PaymentMethodID
ÛÛF U
==
ÛÛV X
id
ÛÛY [
;
ÛÛ[ \
await
ÙÙ 
_context
ÙÙ 
.
ÙÙ 
SaveChangesAsync
ÙÙ +
(
ÙÙ+ ,
)
ÙÙ, -
;
ÙÙ- .
return
ıı 
Ok
ıı 
(
ıı 
new
ıı 
{
ıı 
message
ıı #
=
ıı$ %
$str
ıı& F
}
ııG H
)
ııH I
;
ııI J
}
ˆˆ 	
[
¯¯ 	
HttpPost
¯¯	 
(
¯¯ 
$str
¯¯ #
)
¯¯# $
]
¯¯$ %
public
˘˘ 
async
˘˘ 
Task
˘˘ 
<
˘˘ 
IActionResult
˘˘ '
>
˘˘' (
ProcessPayment
˘˘) 7
(
˘˘7 8
[
˘˘8 9
FromBody
˘˘9 A
]
˘˘A B#
ProcessPaymentRequest
˘˘C X
request
˘˘Y `
)
˘˘` a
{
˙˙ 	
var
˚˚ 
userId
˚˚ 
=
˚˚ 
User
˚˚ 
.
˚˚ 
	FindFirst
˚˚ '
(
˚˚' (
System
˚˚( .
.
˚˚. /
Security
˚˚/ 7
.
˚˚7 8
Claims
˚˚8 >
.
˚˚> ?

ClaimTypes
˚˚? I
.
˚˚I J
NameIdentifier
˚˚J X
)
˚˚X Y
?
˚˚Y Z
.
˚˚Z [
Value
˚˚[ `
;
˚˚` a
var
¸¸ 
invoice
¸¸ 
=
¸¸ 
await
¸¸ 
_context
¸¸  (
.
¸¸( )
Invoices
¸¸) 1
.
¸¸1 2!
FirstOrDefaultAsync
¸¸2 E
(
¸¸E F
i
¸¸F G
=>
¸¸H J
i
¸¸K L
.
¸¸L M
	InvoiceID
¸¸M V
==
¸¸W Y
request
¸¸Z a
.
¸¸a b
	InvoiceId
¸¸b k
&&
¸¸l n
i
¸¸o p
.
¸¸p q
UserID
¸¸q w
==
¸¸x z
userId¸¸{ Å
)¸¸Å Ç
;¸¸Ç É
if
˝˝ 
(
˝˝ 
invoice
˝˝ 
==
˝˝ 
null
˝˝ 
)
˝˝  
return
˝˝! '
NotFound
˝˝( 0
(
˝˝0 1
new
˝˝1 4
{
˝˝5 6
message
˝˝7 >
=
˝˝? @
$str
˝˝A T
}
˝˝U V
)
˝˝V W
;
˝˝W X
if
˛˛ 
(
˛˛ 
invoice
˛˛ 
.
˛˛ 
Status
˛˛ 
!=
˛˛ !
$str
˛˛" +
)
˛˛+ ,
return
˛˛- 3

BadRequest
˛˛4 >
(
˛˛> ?
new
˛˛? B
{
˛˛C D
message
˛˛E L
=
˛˛M N
$str
˛˛O g
}
˛˛h i
)
˛˛i j
;
˛˛j k
var
ÅÅ 
completedPayment
ÅÅ  
=
ÅÅ! "
await
ÅÅ# (
_context
ÅÅ) 1
.
ÅÅ1 2
Payments
ÅÅ2 :
.
ÅÅ: ;!
FirstOrDefaultAsync
ÅÅ; N
(
ÅÅN O
p
ÅÅO P
=>
ÅÅQ S
p
ÅÅT U
.
ÅÅU V
	InvoiceID
ÅÅV _
==
ÅÅ` b
request
ÅÅc j
.
ÅÅj k
	InvoiceId
ÅÅk t
&&
ÅÅu w
p
ÅÅx y
.
ÅÅy z
StatusÅÅz Ä
==ÅÅÅ É
$strÅÅÑ è
)ÅÅè ê
;ÅÅê ë
if
ÇÇ 
(
ÇÇ 
completedPayment
ÇÇ  
!=
ÇÇ! #
null
ÇÇ$ (
)
ÇÇ( )
return
ÇÇ* 0

BadRequest
ÇÇ1 ;
(
ÇÇ; <
new
ÇÇ< ?
{
ÇÇ@ A
message
ÇÇB I
=
ÇÇJ K
$str
ÇÇL p
}
ÇÇq r
)
ÇÇr s
;
ÇÇs t
var
ÖÖ 
stalePending
ÖÖ 
=
ÖÖ 
await
ÖÖ $
_context
ÖÖ% -
.
ÖÖ- .
Payments
ÖÖ. 6
.
ÖÖ6 7!
FirstOrDefaultAsync
ÖÖ7 J
(
ÖÖJ K
p
ÖÖK L
=>
ÖÖM O
p
ÖÖP Q
.
ÖÖQ R
	InvoiceID
ÖÖR [
==
ÖÖ\ ^
request
ÖÖ_ f
.
ÖÖf g
	InvoiceId
ÖÖg p
&&
ÖÖq s
p
ÖÖt u
.
ÖÖu v
Status
ÖÖv |
==
ÖÖ} 
$strÖÖÄ â
)ÖÖâ ä
;ÖÖä ã
if
ÜÜ 
(
ÜÜ 
stalePending
ÜÜ 
!=
ÜÜ 
null
ÜÜ  $
)
ÜÜ$ %
_context
ÜÜ& .
.
ÜÜ. /
Payments
ÜÜ/ 7
.
ÜÜ7 8
Remove
ÜÜ8 >
(
ÜÜ> ?
stalePending
ÜÜ? K
)
ÜÜK L
;
ÜÜL M
var
ââ 
(
ââ 
sourceId
ââ 
,
ââ 
checkoutUrl
ââ &
)
ââ& '
=
ââ( )
await
ââ* /
_payMongoService
ââ0 @
.
ââ@ A
CreateSource
ââA M
(
ââM N
invoice
ââN U
.
ââU V
Amount
ââV \
,
ââ\ ]
$"
ââ^ `
$str
ââ` i
{
ââi j
invoice
ââj q
.
ââq r
	InvoiceID
ââr {
}
ââ{ |
"
ââ| }
)
ââ} ~
;
ââ~ 
var
åå 
payment
åå 
=
åå 
new
åå 
Payment
åå %
{
çç 
UserID
éé 
=
éé 
userId
éé 
!
éé  
,
éé  !
	InvoiceID
èè 
=
èè 
request
èè #
.
èè# $
	InvoiceId
èè$ -
,
èè- .

AmountPaid
êê 
=
êê 
invoice
êê $
.
êê$ %
Amount
êê% +
,
êê+ ,
PaymentMethod
ëë 
=
ëë 
$str
ëë  '
,
ëë' (
PaymentDate
íí 
=
íí 
DateTime
íí &
.
íí& '
UtcNow
íí' -
,
íí- .
ReferenceNum
ìì 
=
ìì 
sourceId
ìì '
,
ìì' (
Status
îî 
=
îî 
$str
îî "
}
ïï 
;
ïï 
_context
ññ 
.
ññ 
Payments
ññ 
.
ññ 
Add
ññ !
(
ññ! "
payment
ññ" )
)
ññ) *
;
ññ* +
await
óó 
_context
óó 
.
óó 
SaveChangesAsync
óó +
(
óó+ ,
)
óó, -
;
óó- .
return
ôô 
Ok
ôô 
(
ôô 
new
ôô 
{
ôô 
message
ôô #
=
ôô$ %
$str
ôô& A
,
ôôA B
	paymentId
ôôC L
=
ôôM N
payment
ôôO V
.
ôôV W
	PaymentID
ôôW `
,
ôô` a
checkoutUrl
ôôb m
}
ôôn o
)
ôôo p
;
ôôp q
}
öö 	
[
úú 	
HttpPost
úú	 
(
úú 
$str
úú .
)
úú. /
]
úú/ 0
public
ùù 
async
ùù 
Task
ùù 
<
ùù 
IActionResult
ùù '
>
ùù' ("
CancelPendingPayment
ùù) =
(
ùù= >
int
ùù> A
	invoiceId
ùùB K
)
ùùK L
{
ûû 	
var
üü 
userId
üü 
=
üü 
User
üü 
.
üü 
	FindFirst
üü '
(
üü' (
System
üü( .
.
üü. /
Security
üü/ 7
.
üü7 8
Claims
üü8 >
.
üü> ?

ClaimTypes
üü? I
.
üüI J
NameIdentifier
üüJ X
)
üüX Y
?
üüY Z
.
üüZ [
Value
üü[ `
;
üü` a
var
†† 
payment
†† 
=
†† 
await
†† 
_context
††  (
.
††( )
Payments
††) 1
.
††1 2!
FirstOrDefaultAsync
††2 E
(
††E F
p
††F G
=>
††H J
p
††K L
.
††L M
	InvoiceID
††M V
==
††W Y
	invoiceId
††Z c
&&
††d f
p
††g h
.
††h i
UserID
††i o
==
††p r
userId
††s y
&&
††z |
p
††} ~
.
††~ 
Status†† Ö
==††Ü à
$str††â í
)††í ì
;††ì î
if
°° 
(
°° 
payment
°° 
==
°° 
null
°° 
)
°°  
return
°°! '
NotFound
°°( 0
(
°°0 1
new
°°1 4
{
°°5 6
message
°°7 >
=
°°? @
$str
°°A [
}
°°\ ]
)
°°] ^
;
°°^ _
_context
££ 
.
££ 
Payments
££ 
.
££ 
Remove
££ $
(
££$ %
payment
££% ,
)
££, -
;
££- .
await
§§ 
_context
§§ 
.
§§ 
SaveChangesAsync
§§ +
(
§§+ ,
)
§§, -
;
§§- .
return
¶¶ 
Ok
¶¶ 
(
¶¶ 
new
¶¶ 
{
¶¶ 
message
¶¶ #
=
¶¶$ %
$str
¶¶& 9
}
¶¶: ;
)
¶¶; <
;
¶¶< =
}
ßß 	
[
©© 	
AllowAnonymous
©©	 
]
©© 
[
™™ 	
HttpPost
™™	 
(
™™ 
$str
™™ $
)
™™$ %
]
™™% &
public
´´ 
async
´´ 
Task
´´ 
<
´´ 
IActionResult
´´ '
>
´´' (
PayMongoWebhook
´´) 8
(
´´8 9
[
´´9 :
FromBody
´´: B
]
´´B C
JsonElement
´´D O
webhookData
´´P [
)
´´[ \
{
¨¨ 	
try
≠≠ 
{
ÆÆ 
var
ØØ 
	eventType
ØØ 
=
ØØ 
webhookData
ØØ  +
.
ØØ+ ,
GetProperty
ØØ, 7
(
ØØ7 8
$str
ØØ8 >
)
ØØ> ?
.
ØØ? @
GetProperty
ØØ@ K
(
ØØK L
$str
ØØL X
)
ØØX Y
.
ØØY Z
GetProperty
ØØZ e
(
ØØe f
$str
ØØf l
)
ØØl m
.
ØØm n
	GetString
ØØn w
(
ØØw x
)
ØØx y
;
ØØy z
if
±± 
(
±± 
	eventType
±± 
==
±±  
$str
±±! /
)
±±/ 0
{
≤≤ 
var
≥≥ 
paymentIntentId
≥≥ '
=
≥≥( )
webhookData
≥≥* 5
.
≥≥5 6
GetProperty
≥≥6 A
(
≥≥A B
$str
≥≥B H
)
≥≥H I
.
≥≥I J
GetProperty
≥≥J U
(
≥≥U V
$str
≥≥V b
)
≥≥b c
.
≥≥c d
GetProperty
≥≥d o
(
≥≥o p
$str
≥≥p v
)
≥≥v w
.
≥≥w x
GetProperty≥≥x É
(≥≥É Ñ
$str≥≥Ñ ê
)≥≥ê ë
.≥≥ë í
GetProperty≥≥í ù
(≥≥ù û
$str≥≥û ±
)≥≥± ≤
.≥≥≤ ≥
	GetString≥≥≥ º
(≥≥º Ω
)≥≥Ω æ
;≥≥æ ø
var
¥¥ 
payment
¥¥ 
=
¥¥  !
await
¥¥" '
_context
¥¥( 0
.
¥¥0 1
Payments
¥¥1 9
.
¥¥9 :
Include
¥¥: A
(
¥¥A B
p
¥¥B C
=>
¥¥D F
p
¥¥G H
.
¥¥H I
Invoice
¥¥I P
)
¥¥P Q
.
¥¥Q R!
FirstOrDefaultAsync
¥¥R e
(
¥¥e f
p
¥¥f g
=>
¥¥h j
p
¥¥k l
.
¥¥l m
ReferenceNum
¥¥m y
==
¥¥z |
paymentIntentId¥¥} å
)¥¥å ç
;¥¥ç é
if
µµ 
(
µµ 
payment
µµ 
!=
µµ  "
null
µµ# '
)
µµ' (
{
∂∂ 
Console
∑∑ 
.
∑∑  
	WriteLine
∑∑  )
(
∑∑) *
$"
∑∑* ,
$str
∑∑, 4
{
∑∑4 5
payment
∑∑5 <
.
∑∑< =
	PaymentID
∑∑= F
}
∑∑F G
$str
∑∑G ~
"
∑∑~ 
)∑∑ Ä
;∑∑Ä Å
}
∏∏ 
}
ππ 
return
ªª 
Ok
ªª 
(
ªª 
)
ªª 
;
ªª 
}
ºº 
catch
ΩΩ 
(
ΩΩ 
	Exception
ΩΩ 
ex
ΩΩ 
)
ΩΩ  
{
ææ 
Console
øø 
.
øø 
	WriteLine
øø !
(
øø! "
$"
øø" $
$str
øø$ 3
{
øø3 4
ex
øø4 6
.
øø6 7
Message
øø7 >
}
øø> ?
"
øø? @
)
øø@ A
;
øøA B
return
¿¿ 
Ok
¿¿ 
(
¿¿ 
)
¿¿ 
;
¿¿ 
}
¡¡ 
}
¬¬ 	
[
ƒƒ 	
HttpPost
ƒƒ	 
(
ƒƒ 
$str
ƒƒ 3
)
ƒƒ3 4
]
ƒƒ4 5
public
≈≈ 
async
≈≈ 
Task
≈≈ 
<
≈≈ 
IActionResult
≈≈ '
>
≈≈' (
SyncPaymentStatus
≈≈) :
(
≈≈: ;
int
≈≈; >
	invoiceId
≈≈? H
)
≈≈H I
{
∆∆ 	
var
«« 
userId
«« 
=
«« 
User
«« 
.
«« 
	FindFirst
«« '
(
««' (
System
««( .
.
««. /
Security
««/ 7
.
««7 8
Claims
««8 >
.
««> ?

ClaimTypes
««? I
.
««I J
NameIdentifier
««J X
)
««X Y
?
««Y Z
.
««Z [
Value
««[ `
;
««` a
var
»» 
payment
»» 
=
»» 
await
»» 
_context
»»  (
.
»»( )
Payments
»») 1
.
»»1 2
Include
»»2 9
(
»»9 :
p
»»: ;
=>
»»< >
p
»»? @
.
»»@ A
Invoice
»»A H
)
»»H I
.
…… !
FirstOrDefaultAsync
…… $
(
……$ %
p
……% &
=>
……' )
p
……* +
.
……+ ,
	InvoiceID
……, 5
==
……6 8
	invoiceId
……9 B
&&
……C E
p
……F G
.
……G H
UserID
……H N
==
……O Q
userId
……R X
)
……X Y
;
……Y Z
if
ÀÀ 
(
ÀÀ 
payment
ÀÀ 
==
ÀÀ 
null
ÀÀ 
)
ÀÀ  
return
ÀÀ! '
NotFound
ÀÀ( 0
(
ÀÀ0 1
new
ÀÀ1 4
{
ÀÀ5 6
message
ÀÀ7 >
=
ÀÀ? @
$str
ÀÀA T
}
ÀÀU V
)
ÀÀV W
;
ÀÀW X
if
ŒŒ 
(
ŒŒ 
payment
ŒŒ 
.
ŒŒ 
Status
ŒŒ 
==
ŒŒ !
$str
ŒŒ" -
)
ŒŒ- .
return
œœ 
Ok
œœ 
(
œœ 
new
œœ 
{
œœ 
message
œœ  '
=
œœ( )
$str
œœ* G
,
œœG H
status
œœI O
=
œœP Q
$str
œœR ]
}
œœ^ _
)
œœ_ `
;
œœ` a
return
““ 
Ok
““ 
(
““ 
new
““ 
{
““ 
message
““ #
=
““$ %
$str
““& W
,
““W X
status
““Y _
=
““` a
payment
““b i
.
““i j
Status
““j p
}
““q r
)
““r s
;
““s t
}
”” 	
[
’’ 	
HttpGet
’’	 
(
’’ 
$str
’’ 
)
’’ 
]
’’ 
public
÷÷ 
async
÷÷ 
Task
÷÷ 
<
÷÷ 
IActionResult
÷÷ '
>
÷÷' (
	GetAddons
÷÷) 2
(
÷÷2 3
)
÷÷3 4
{
◊◊ 	
var
ÿÿ 
addons
ÿÿ 
=
ÿÿ 
await
ÿÿ 
_context
ÿÿ '
.
ÿÿ' (
Addons
ÿÿ( .
.
ÿÿ. /
ToListAsync
ÿÿ/ :
(
ÿÿ: ;
)
ÿÿ; <
;
ÿÿ< =
return
ŸŸ 
Ok
ŸŸ 
(
ŸŸ 
addons
ŸŸ 
)
ŸŸ 
;
ŸŸ 
}
⁄⁄ 	
[
‹‹ 	
HttpGet
‹‹	 
(
‹‹ 
$str
‹‹ 
)
‹‹ 
]
‹‹  
public
›› 
async
›› 
Task
›› 
<
›› 
IActionResult
›› '
>
››' (
GetUserAddons
››) 6
(
››6 7
)
››7 8
{
ﬁﬁ 	
var
ﬂﬂ 
userId
ﬂﬂ 
=
ﬂﬂ 
User
ﬂﬂ 
.
ﬂﬂ 
	FindFirst
ﬂﬂ '
(
ﬂﬂ' (
System
ﬂﬂ( .
.
ﬂﬂ. /
Security
ﬂﬂ/ 7
.
ﬂﬂ7 8
Claims
ﬂﬂ8 >
.
ﬂﬂ> ?

ClaimTypes
ﬂﬂ? I
.
ﬂﬂI J
NameIdentifier
ﬂﬂJ X
)
ﬂﬂX Y
?
ﬂﬂY Z
.
ﬂﬂZ [
Value
ﬂﬂ[ `
;
ﬂﬂ` a
var
‡‡ 

userAddons
‡‡ 
=
‡‡ 
await
‡‡ "
_context
‡‡# +
.
‡‡+ ,

UserAddons
‡‡, 6
.
·· 
Where
·· 
(
·· 
ua
·· 
=>
·· 
ua
·· 
.
··  
UserID
··  &
==
··' )
userId
··* 0
)
··0 1
.
‚‚ 
Select
‚‚ 
(
‚‚ 
ua
‚‚ 
=>
‚‚ 
new
‚‚ !
{
„„ 
ua
‰‰ 
.
‰‰ 
UserAddonID
‰‰ "
,
‰‰" #
ua
ÂÂ 
.
ÂÂ 
AddonID
ÂÂ 
,
ÂÂ 
ua
ÊÊ 
.
ÊÊ 
ActivatedAt
ÊÊ "
,
ÊÊ" #
ua
ÁÁ 
.
ÁÁ 
NextBillingDate
ÁÁ &
,
ÁÁ& '
ua
ËË 
.
ËË 
Status
ËË 
,
ËË 
Addon
ÈÈ 
=
ÈÈ 
new
ÈÈ 
{
ÍÍ 
ua
ÎÎ 
.
ÎÎ 
Addon
ÎÎ  
.
ÎÎ  !
AddonID
ÎÎ! (
,
ÎÎ( )
ua
ÏÏ 
.
ÏÏ 
Addon
ÏÏ  
.
ÏÏ  !
Name
ÏÏ! %
,
ÏÏ% &
ua
ÌÌ 
.
ÌÌ 
Addon
ÌÌ  
.
ÌÌ  !
Description
ÌÌ! ,
,
ÌÌ, -
ua
ÓÓ 
.
ÓÓ 
Addon
ÓÓ  
.
ÓÓ  !
Price
ÓÓ! &
,
ÓÓ& '
ua
ÔÔ 
.
ÔÔ 
Addon
ÔÔ  
.
ÔÔ  !
BillingType
ÔÔ! ,
,
ÔÔ, -
ua
 
.
 
Addon
  
.
  !
Icon
! %
,
% &
ua
ÒÒ 
.
ÒÒ 
Addon
ÒÒ  
.
ÒÒ  !
Features
ÒÒ! )
}
ÚÚ 
}
ÛÛ 
)
ÛÛ 
.
ÙÙ 
ToListAsync
ÙÙ 
(
ÙÙ 
)
ÙÙ 
;
ÙÙ 
return
ıı 
Ok
ıı 
(
ıı 

userAddons
ıı  
)
ıı  !
;
ıı! "
}
ˆˆ 	
[
¯¯ 	
HttpPost
¯¯	 
(
¯¯ 
$str
¯¯ 
)
¯¯ 
]
¯¯ 
public
˘˘ 
async
˘˘ 
Task
˘˘ 
<
˘˘ 
IActionResult
˘˘ '
>
˘˘' (
AddAddon
˘˘) 1
(
˘˘1 2
[
˘˘2 3
FromBody
˘˘3 ;
]
˘˘; <
AddAddonRequest
˘˘= L
request
˘˘M T
)
˘˘T U
{
˙˙ 	
var
˚˚ 
userId
˚˚ 
=
˚˚ 
User
˚˚ 
.
˚˚ 
	FindFirst
˚˚ '
(
˚˚' (
System
˚˚( .
.
˚˚. /
Security
˚˚/ 7
.
˚˚7 8
Claims
˚˚8 >
.
˚˚> ?

ClaimTypes
˚˚? I
.
˚˚I J
NameIdentifier
˚˚J X
)
˚˚X Y
?
˚˚Y Z
.
˚˚Z [
Value
˚˚[ `
;
˚˚` a
var
¸¸ 
addon
¸¸ 
=
¸¸ 
await
¸¸ 
_context
¸¸ &
.
¸¸& '
Addons
¸¸' -
.
¸¸- .
	FindAsync
¸¸. 7
(
¸¸7 8
request
¸¸8 ?
.
¸¸? @
AddonId
¸¸@ G
)
¸¸G H
;
¸¸H I
if
˝˝ 
(
˝˝ 
addon
˝˝ 
==
˝˝ 
null
˝˝ 
)
˝˝ 
return
˝˝ %
NotFound
˝˝& .
(
˝˝. /
new
˝˝/ 2
{
˝˝3 4
message
˝˝5 <
=
˝˝= >
$str
˝˝? P
}
˝˝Q R
)
˝˝R S
;
˝˝S T
var
ˇˇ 
existing
ˇˇ 
=
ˇˇ 
await
ˇˇ  
_context
ˇˇ! )
.
ˇˇ) *

UserAddons
ˇˇ* 4
.
ˇˇ4 5!
FirstOrDefaultAsync
ˇˇ5 H
(
ˇˇH I
ua
ˇˇI K
=>
ˇˇL N
ua
ˇˇO Q
.
ˇˇQ R
UserID
ˇˇR X
==
ˇˇY [
userId
ˇˇ\ b
&&
ˇˇc e
ua
ˇˇf h
.
ˇˇh i
AddonID
ˇˇi p
==
ˇˇq s
request
ˇˇt {
.
ˇˇ{ |
AddonIdˇˇ| É
&&ˇˇÑ Ü
uaˇˇá â
.ˇˇâ ä
Statusˇˇä ê
==ˇˇë ì
$strˇˇî ú
)ˇˇú ù
;ˇˇù û
if
ÄÄ 
(
ÄÄ 
existing
ÄÄ 
!=
ÄÄ 
null
ÄÄ  
)
ÄÄ  !
return
ÄÄ" (

BadRequest
ÄÄ) 3
(
ÄÄ3 4
new
ÄÄ4 7
{
ÄÄ8 9
message
ÄÄ: A
=
ÄÄB C
$str
ÄÄD Z
}
ÄÄ[ \
)
ÄÄ\ ]
;
ÄÄ] ^
var
ÇÇ 
	userAddon
ÇÇ 
=
ÇÇ 
new
ÇÇ 
	UserAddon
ÇÇ  )
{
ÉÉ 
UserID
ÑÑ 
=
ÑÑ 
userId
ÑÑ 
!
ÑÑ  
,
ÑÑ  !
AddonID
ÖÖ 
=
ÖÖ 
request
ÖÖ !
.
ÖÖ! "
AddonId
ÖÖ" )
,
ÖÖ) *
NextBillingDate
ÜÜ 
=
ÜÜ  !
addon
ÜÜ" '
.
ÜÜ' (
BillingType
ÜÜ( 3
==
ÜÜ4 6
$str
ÜÜ7 @
?
ÜÜA B
DateTime
ÜÜC K
.
ÜÜK L
UtcNow
ÜÜL R
.
ÜÜR S
	AddMonths
ÜÜS \
(
ÜÜ\ ]
$num
ÜÜ] ^
)
ÜÜ^ _
:
ÜÜ` a
null
ÜÜb f
}
áá 
;
áá 
_context
àà 
.
àà 

UserAddons
àà 
.
àà  
Add
àà  #
(
àà# $
	userAddon
àà$ -
)
àà- .
;
àà. /
await
ââ 
_context
ââ 
.
ââ 
SaveChangesAsync
ââ +
(
ââ+ ,
)
ââ, -
;
ââ- .
return
ãã 
Ok
ãã 
(
ãã 
new
ãã 
{
ãã 
message
ãã #
=
ãã$ %
$str
ãã& @
,
ãã@ A
userAddonId
ããB M
=
ããN O
	userAddon
ããP Y
.
ããY Z
UserAddonID
ããZ e
}
ããf g
)
ããg h
;
ããh i
}
åå 	
[
éé 	

HttpDelete
éé	 
(
éé 
$str
éé &
)
éé& '
]
éé' (
public
èè 
async
èè 
Task
èè 
<
èè 
IActionResult
èè '
>
èè' (
RemoveAddon
èè) 4
(
èè4 5
int
èè5 8
id
èè9 ;
)
èè; <
{
êê 	
var
ëë 
userId
ëë 
=
ëë 
User
ëë 
.
ëë 
	FindFirst
ëë '
(
ëë' (
System
ëë( .
.
ëë. /
Security
ëë/ 7
.
ëë7 8
Claims
ëë8 >
.
ëë> ?

ClaimTypes
ëë? I
.
ëëI J
NameIdentifier
ëëJ X
)
ëëX Y
?
ëëY Z
.
ëëZ [
Value
ëë[ `
;
ëë` a
var
íí 
	userAddon
íí 
=
íí 
await
íí !
_context
íí" *
.
íí* +

UserAddons
íí+ 5
.
íí5 6!
FirstOrDefaultAsync
íí6 I
(
ííI J
ua
ííJ L
=>
ííM O
ua
ííP R
.
ííR S
UserAddonID
ííS ^
==
íí_ a
id
ííb d
&&
ííe g
ua
ííh j
.
ííj k
UserID
íík q
==
íír t
userId
ííu {
)
íí{ |
;
íí| }
if
ìì 
(
ìì 
	userAddon
ìì 
==
ìì 
null
ìì !
)
ìì! "
return
ìì# )
NotFound
ìì* 2
(
ìì2 3
)
ìì3 4
;
ìì4 5
	userAddon
ïï 
.
ïï 
Status
ïï 
=
ïï 
$str
ïï *
;
ïï* +
await
ññ 
_context
ññ 
.
ññ 
SaveChangesAsync
ññ +
(
ññ+ ,
)
ññ, -
;
ññ- .
return
óó 
Ok
óó 
(
óó 
new
óó 
{
óó 
message
óó #
=
óó$ %
$str
óó& B
}
óóC D
)
óóD E
;
óóE F
}
òò 	
[
öö 	
HttpPost
öö	 
(
öö 
$str
öö $
)
öö$ %
]
öö% &
public
õõ 
async
õõ 
Task
õõ 
<
õõ 
IActionResult
õõ '
>
õõ' (
GenerateInvoice
õõ) 8
(
õõ8 9
)
õõ9 :
{
úú 	
try
ùù 
{
ûû 
var
üü 
userId
üü 
=
üü 
User
üü !
.
üü! "
	FindFirst
üü" +
(
üü+ ,
System
üü, 2
.
üü2 3
Security
üü3 ;
.
üü; <
Claims
üü< B
.
üüB C

ClaimTypes
üüC M
.
üüM N
NameIdentifier
üüN \
)
üü\ ]
?
üü] ^
.
üü^ _
Value
üü_ d
;
üüd e
var
†† 
subscriptions
†† !
=
††" #
await
††$ )
_context
††* 2
.
††2 3
Subscriptions
††3 @
.
°° 
Where
°° 
(
°° 
s
°° 
=>
°° 
s
°°  !
.
°°! "
UserID
°°" (
==
°°) +
userId
°°, 2
&&
°°3 5
s
°°6 7
.
°°7 8
Status
°°8 >
==
°°? A
$str
°°B J
)
°°J K
.
¢¢ 
Select
¢¢ 
(
¢¢ 
s
¢¢ 
=>
¢¢  
new
¢¢! $
{
¢¢% &
s
¢¢' (
.
¢¢( )
SubscriptionID
¢¢) 7
,
¢¢7 8
s
¢¢9 :
.
¢¢: ;
PlanID
¢¢; A
}
¢¢B C
)
¢¢C D
.
££ 
ToListAsync
££  
(
££  !
)
££! "
;
££" #
if
§§ 
(
§§ 
subscriptions
§§ !
.
§§! "
Count
§§" '
==
§§( *
$num
§§+ ,
)
§§, -
return
§§. 4
NotFound
§§5 =
(
§§= >
new
§§> A
{
§§B C
message
§§D K
=
§§L M
$str
§§N f
}
§§g h
)
§§h i
;
§§i j
var
¶¶ 
generatedInvoices
¶¶ %
=
¶¶& '
new
¶¶( +
List
¶¶, 0
<
¶¶0 1
object
¶¶1 7
>
¶¶7 8
(
¶¶8 9
)
¶¶9 :
;
¶¶: ;
foreach
ßß 
(
ßß 
var
ßß 
subscription
ßß )
in
ßß* ,
subscriptions
ßß- :
)
ßß: ;
{
®® 
var
©© 
existingInvoice
©© '
=
©©( )
await
©©* /
_context
©©0 8
.
©©8 9
Invoices
©©9 A
.
™™ !
FirstOrDefaultAsync
™™ ,
(
™™, -
i
™™- .
=>
™™/ 1
i
™™2 3
.
™™3 4
SubscriptionID
™™4 B
==
™™C E
subscription
™™F R
.
™™R S
SubscriptionID
™™S a
&&
™™b d
i
™™e f
.
™™f g
Status
™™g m
==
™™n p
$str
™™q z
)
™™z {
;
™™{ |
if
´´ 
(
´´ 
existingInvoice
´´ '
!=
´´( *
null
´´+ /
)
´´/ 0
{
¨¨ 
generatedInvoices
≠≠ )
.
≠≠) *
Add
≠≠* -
(
≠≠- .
new
≠≠. 1
{
≠≠2 3
invoice
≠≠4 ;
=
≠≠< =
existingInvoice
≠≠> M
,
≠≠M N
message
≠≠O V
=
≠≠W X
$str
≠≠Y q
}
≠≠r s
)
≠≠s t
;
≠≠t u
continue
ÆÆ  
;
ÆÆ  !
}
ØØ 
var
±± 
plan
±± 
=
±± 
await
±± $
_context
±±% -
.
±±- .
SubscriptionPlans
±±. ?
.
≤≤ 
Where
≤≤ 
(
≤≤ 
p
≤≤  
=>
≤≤! #
p
≤≤$ %
.
≤≤% &
PlanID
≤≤& ,
==
≤≤- /
subscription
≤≤0 <
.
≤≤< =
PlanID
≤≤= C
)
≤≤C D
.
≥≥ 
Select
≥≥ 
(
≥≥  
p
≥≥  !
=>
≥≥" $
new
≥≥% (
{
≥≥) *
p
≥≥+ ,
.
≥≥, -
Price
≥≥- 2
}
≥≥3 4
)
≥≥4 5
.
¥¥ !
FirstOrDefaultAsync
¥¥ ,
(
¥¥, -
)
¥¥- .
;
¥¥. /
var
µµ 
invoice
µµ 
=
µµ  !
new
µµ" %
Invoice
µµ& -
{
∂∂ 
SubscriptionID
∑∑ &
=
∑∑' (
subscription
∑∑) 5
.
∑∑5 6
SubscriptionID
∑∑6 D
,
∑∑D E
UserID
∏∏ 
=
∏∏  
userId
∏∏! '
!
∏∏' (
,
∏∏( )
Amount
ππ 
=
ππ  
plan
ππ! %
?
ππ% &
.
ππ& '
Price
ππ' ,
??
ππ- /
$num
ππ0 8
,
ππ8 9
DueDate
∫∫ 
=
∫∫  !
DateTime
∫∫" *
.
∫∫* +
UtcNow
∫∫+ 1
.
∫∫1 2
	AddMonths
∫∫2 ;
(
∫∫; <
$num
∫∫< =
)
∫∫= >
,
∫∫> ?
Status
ªª 
=
ªª  
$str
ªª! *
}
ºº 
;
ºº 
_context
ΩΩ 
.
ΩΩ 
Invoices
ΩΩ %
.
ΩΩ% &
Add
ΩΩ& )
(
ΩΩ) *
invoice
ΩΩ* 1
)
ΩΩ1 2
;
ΩΩ2 3
generatedInvoices
ææ %
.
ææ% &
Add
ææ& )
(
ææ) *
new
ææ* -
{
ææ. /
invoice
ææ0 7
,
ææ7 8
message
ææ9 @
=
ææA B
$str
ææC V
}
ææW X
)
ææX Y
;
ææY Z
}
øø 
await
¿¿ 
_context
¿¿ 
.
¿¿ 
SaveChangesAsync
¿¿ /
(
¿¿/ 0
)
¿¿0 1
;
¿¿1 2
return
¬¬ 
Ok
¬¬ 
(
¬¬ 
new
¬¬ 
{
¬¬ 
message
¬¬  '
=
¬¬( )
$str
¬¬* >
,
¬¬> ?
invoices
¬¬@ H
=
¬¬I J
generatedInvoices
¬¬K \
}
¬¬] ^
)
¬¬^ _
;
¬¬_ `
}
√√ 
catch
ƒƒ 
(
ƒƒ 
	Exception
ƒƒ 
ex
ƒƒ 
)
ƒƒ  
{
≈≈ 
return
∆∆ 

StatusCode
∆∆ !
(
∆∆! "
$num
∆∆" %
,
∆∆% &
new
∆∆' *
{
∆∆+ ,
message
∆∆- 4
=
∆∆5 6
$"
∆∆7 9
$str
∆∆9 U
{
∆∆U V
ex
∆∆V X
.
∆∆X Y
Message
∆∆Y `
}
∆∆` a
"
∆∆a b
}
∆∆c d
)
∆∆d e
;
∆∆e f
}
«« 
}
»» 	
[
   	
HttpGet
  	 
(
   
$str
    
)
    !
]
  ! "
public
ÀÀ 
async
ÀÀ 
Task
ÀÀ 
<
ÀÀ 
IActionResult
ÀÀ '
>
ÀÀ' (
GetNotifications
ÀÀ) 9
(
ÀÀ9 :
)
ÀÀ: ;
{
ÃÃ 	
var
ÕÕ 
userId
ÕÕ 
=
ÕÕ 
User
ÕÕ 
.
ÕÕ 
	FindFirst
ÕÕ '
(
ÕÕ' (
System
ÕÕ( .
.
ÕÕ. /
Security
ÕÕ/ 7
.
ÕÕ7 8
Claims
ÕÕ8 >
.
ÕÕ> ?

ClaimTypes
ÕÕ? I
.
ÕÕI J
NameIdentifier
ÕÕJ X
)
ÕÕX Y
?
ÕÕY Z
.
ÕÕZ [
Value
ÕÕ[ `
;
ÕÕ` a
var
ŒŒ 
notifications
ŒŒ 
=
ŒŒ 
await
ŒŒ  %
_context
ŒŒ& .
.
ŒŒ. /
Notifications
ŒŒ/ <
.
œœ 
Where
œœ 
(
œœ 
n
œœ 
=>
œœ 
n
œœ 
.
œœ 
UserID
œœ $
==
œœ% '
userId
œœ( .
)
œœ. /
.
–– 
OrderByDescending
–– "
(
––" #
n
––# $
=>
––% '
n
––( )
.
––) *
SentAt
––* 0
)
––0 1
.
—— 
Take
—— 
(
—— 
$num
—— 
)
—— 
.
““ 
ToListAsync
““ 
(
““ 
)
““ 
;
““ 
return
”” 
Ok
”” 
(
”” 
notifications
”” #
)
””# $
;
””$ %
}
‘‘ 	
[
÷÷ 	
HttpPut
÷÷	 
(
÷÷ 
$str
÷÷ *
)
÷÷* +
]
÷÷+ ,
public
◊◊ 
async
◊◊ 
Task
◊◊ 
<
◊◊ 
IActionResult
◊◊ '
>
◊◊' ($
MarkNotificationAsRead
◊◊) ?
(
◊◊? @
int
◊◊@ C
id
◊◊D F
)
◊◊F G
{
ÿÿ 	
var
ŸŸ 
userId
ŸŸ 
=
ŸŸ 
User
ŸŸ 
.
ŸŸ 
	FindFirst
ŸŸ '
(
ŸŸ' (
System
ŸŸ( .
.
ŸŸ. /
Security
ŸŸ/ 7
.
ŸŸ7 8
Claims
ŸŸ8 >
.
ŸŸ> ?

ClaimTypes
ŸŸ? I
.
ŸŸI J
NameIdentifier
ŸŸJ X
)
ŸŸX Y
?
ŸŸY Z
.
ŸŸZ [
Value
ŸŸ[ `
;
ŸŸ` a
var
⁄⁄ 
notification
⁄⁄ 
=
⁄⁄ 
await
⁄⁄ $
_context
⁄⁄% -
.
⁄⁄- .
Notifications
⁄⁄. ;
.
⁄⁄; <!
FirstOrDefaultAsync
⁄⁄< O
(
⁄⁄O P
n
⁄⁄P Q
=>
⁄⁄R T
n
⁄⁄U V
.
⁄⁄V W
NotificationID
⁄⁄W e
==
⁄⁄f h
id
⁄⁄i k
&&
⁄⁄l n
n
⁄⁄o p
.
⁄⁄p q
UserID
⁄⁄q w
==
⁄⁄x z
userId⁄⁄{ Å
)⁄⁄Å Ç
;⁄⁄Ç É
if
€€ 
(
€€ 
notification
€€ 
==
€€ 
null
€€  $
)
€€$ %
return
€€& ,
NotFound
€€- 5
(
€€5 6
)
€€6 7
;
€€7 8
notification
‹‹ 
.
‹‹ 
Status
‹‹ 
=
‹‹  !
$str
‹‹" (
;
‹‹( )
await
›› 
_context
›› 
.
›› 
SaveChangesAsync
›› +
(
››+ ,
)
››, -
;
››- .
return
ﬁﬁ 
Ok
ﬁﬁ 
(
ﬁﬁ 
new
ﬁﬁ 
{
ﬁﬁ 
message
ﬁﬁ #
=
ﬁﬁ$ %
$str
ﬁﬁ& C
}
ﬁﬁD E
)
ﬁﬁE F
;
ﬁﬁF G
}
ﬂﬂ 	
[
·· 	

HttpDelete
··	 
(
·· 
$str
·· (
)
··( )
]
··) *
public
‚‚ 
async
‚‚ 
Task
‚‚ 
<
‚‚ 
IActionResult
‚‚ '
>
‚‚' ( 
DeleteNotification
‚‚) ;
(
‚‚; <
int
‚‚< ?
id
‚‚@ B
)
‚‚B C
{
„„ 	
var
‰‰ 
userId
‰‰ 
=
‰‰ 
User
‰‰ 
.
‰‰ 
	FindFirst
‰‰ '
(
‰‰' (
System
‰‰( .
.
‰‰. /
Security
‰‰/ 7
.
‰‰7 8
Claims
‰‰8 >
.
‰‰> ?

ClaimTypes
‰‰? I
.
‰‰I J
NameIdentifier
‰‰J X
)
‰‰X Y
?
‰‰Y Z
.
‰‰Z [
Value
‰‰[ `
;
‰‰` a
var
ÂÂ 
notification
ÂÂ 
=
ÂÂ 
await
ÂÂ $
_context
ÂÂ% -
.
ÂÂ- .
Notifications
ÂÂ. ;
.
ÂÂ; <!
FirstOrDefaultAsync
ÂÂ< O
(
ÂÂO P
n
ÂÂP Q
=>
ÂÂR T
n
ÂÂU V
.
ÂÂV W
NotificationID
ÂÂW e
==
ÂÂf h
id
ÂÂi k
&&
ÂÂl n
n
ÂÂo p
.
ÂÂp q
UserID
ÂÂq w
==
ÂÂx z
userIdÂÂ{ Å
)ÂÂÅ Ç
;ÂÂÇ É
if
ÊÊ 
(
ÊÊ 
notification
ÊÊ 
==
ÊÊ 
null
ÊÊ  $
)
ÊÊ$ %
return
ÊÊ& ,
NotFound
ÊÊ- 5
(
ÊÊ5 6
)
ÊÊ6 7
;
ÊÊ7 8
_context
ÁÁ 
.
ÁÁ 
Notifications
ÁÁ "
.
ÁÁ" #
Remove
ÁÁ# )
(
ÁÁ) *
notification
ÁÁ* 6
)
ÁÁ6 7
;
ÁÁ7 8
await
ËË 
_context
ËË 
.
ËË 
SaveChangesAsync
ËË +
(
ËË+ ,
)
ËË, -
;
ËË- .
return
ÈÈ 
Ok
ÈÈ 
(
ÈÈ 
new
ÈÈ 
{
ÈÈ 
message
ÈÈ #
=
ÈÈ$ %
$str
ÈÈ& <
}
ÈÈ= >
)
ÈÈ> ?
;
ÈÈ? @
}
ÍÍ 	
[
ÏÏ 	
HttpPost
ÏÏ	 
(
ÏÏ 
$str
ÏÏ #
)
ÏÏ# $
]
ÏÏ$ %
public
ÌÌ 
async
ÌÌ 
Task
ÌÌ 
<
ÌÌ 
IActionResult
ÌÌ '
>
ÌÌ' (
ChangePassword
ÌÌ) 7
(
ÌÌ7 8
[
ÌÌ8 9
FromBody
ÌÌ9 A
]
ÌÌA B#
ChangePasswordRequest
ÌÌC X
request
ÌÌY `
)
ÌÌ` a
{
ÓÓ 	
var
ÔÔ 
userId
ÔÔ 
=
ÔÔ 
User
ÔÔ 
.
ÔÔ 
	FindFirst
ÔÔ '
(
ÔÔ' (
System
ÔÔ( .
.
ÔÔ. /
Security
ÔÔ/ 7
.
ÔÔ7 8
Claims
ÔÔ8 >
.
ÔÔ> ?

ClaimTypes
ÔÔ? I
.
ÔÔI J
NameIdentifier
ÔÔJ X
)
ÔÔX Y
?
ÔÔY Z
.
ÔÔZ [
Value
ÔÔ[ `
;
ÔÔ` a
var
 
user
 
=
 
await
 
_userManager
 )
.
) *
FindByIdAsync
* 7
(
7 8
userId
8 >
!
> ?
)
? @
;
@ A
if
ÒÒ 
(
ÒÒ 
user
ÒÒ 
==
ÒÒ 
null
ÒÒ 
)
ÒÒ 
return
ÒÒ $
NotFound
ÒÒ% -
(
ÒÒ- .
new
ÒÒ. 1
{
ÒÒ2 3
message
ÒÒ4 ;
=
ÒÒ< =
$str
ÒÒ> N
}
ÒÒO P
)
ÒÒP Q
;
ÒÒQ R
var
ÛÛ $
isCurrentPasswordValid
ÛÛ &
=
ÛÛ' (
await
ÛÛ) .
_userManager
ÛÛ/ ;
.
ÛÛ; < 
CheckPasswordAsync
ÛÛ< N
(
ÛÛN O
user
ÛÛO S
,
ÛÛS T
request
ÛÛU \
.
ÛÛ\ ]
CurrentPassword
ÛÛ] l
)
ÛÛl m
;
ÛÛm n
if
ÙÙ 
(
ÙÙ 
!
ÙÙ $
isCurrentPasswordValid
ÙÙ '
)
ÙÙ' (
return
ÙÙ) /

BadRequest
ÙÙ0 :
(
ÙÙ: ;
new
ÙÙ; >
{
ÙÙ? @
message
ÙÙA H
=
ÙÙI J
$str
ÙÙK j
}
ÙÙk l
)
ÙÙl m
;
ÙÙm n
var
ˆˆ 
result
ˆˆ 
=
ˆˆ 
await
ˆˆ 
_userManager
ˆˆ +
.
ˆˆ+ ,!
ChangePasswordAsync
ˆˆ, ?
(
ˆˆ? @
user
ˆˆ@ D
,
ˆˆD E
request
ˆˆF M
.
ˆˆM N
CurrentPassword
ˆˆN ]
,
ˆˆ] ^
request
ˆˆ_ f
.
ˆˆf g
NewPassword
ˆˆg r
)
ˆˆr s
;
ˆˆs t
if
˜˜ 
(
˜˜ 
!
˜˜ 
result
˜˜ 
.
˜˜ 
	Succeeded
˜˜ !
)
˜˜! "
{
¯¯ 
var
˘˘ 
errors
˘˘ 
=
˘˘ 
string
˘˘ #
.
˘˘# $
Join
˘˘$ (
(
˘˘( )
$str
˘˘) -
,
˘˘- .
result
˘˘/ 5
.
˘˘5 6
Errors
˘˘6 <
.
˘˘< =
Select
˘˘= C
(
˘˘C D
e
˘˘D E
=>
˘˘F H
e
˘˘I J
.
˘˘J K
Description
˘˘K V
)
˘˘V W
)
˘˘W X
;
˘˘X Y
return
˙˙ 

BadRequest
˙˙ !
(
˙˙! "
new
˙˙" %
{
˙˙& '
message
˙˙( /
=
˙˙0 1
errors
˙˙2 8
}
˙˙9 :
)
˙˙: ;
;
˙˙; <
}
˚˚ 
var
˛˛ 
passwordPref
˛˛ 
=
˛˛ 
await
˛˛ $
_context
˛˛% -
.
˛˛- .%
NotificationPreferences
˛˛. E
.
ˇˇ !
FirstOrDefaultAsync
ˇˇ $
(
ˇˇ$ %
np
ˇˇ% '
=>
ˇˇ( *
np
ˇˇ+ -
.
ˇˇ- .
UserID
ˇˇ. 4
==
ˇˇ5 7
userId
ˇˇ8 >
&&
ˇˇ? A
np
ˇˇB D
.
ˇˇD E
NotificationType
ˇˇE U
==
ˇˇV X
$str
ˇˇY j
)
ˇˇj k
;
ˇˇk l
if
Ä	Ä	 
(
Ä	Ä	 
passwordPref
Ä	Ä	 
?
Ä	Ä	 
.
Ä	Ä	 
EmailEnabled
Ä	Ä	 *
!=
Ä	Ä	+ -
false
Ä	Ä	. 3
)
Ä	Ä	3 4
{
Å	Å	 
await
Ç	Ç	 
_emailService
Ç	Ç	 #
.
Ç	Ç	# $
SendEmailAsync
Ç	Ç	$ 2
(
Ç	Ç	2 3
user
É	É	 
.
É	É	 
Email
É	É	 
!
É	É	 
,
É	É	  
$str
Ñ	Ñ	 7
,
Ñ	Ñ	7 8
$"
Ö	Ö	 
$str
Ö	Ö	 
{
Ö	Ö	 
user
Ö	Ö	 !
.
Ö	Ö	! "
	FirstName
Ö	Ö	" +
}
Ö	Ö	+ ,
$strÖ	Ö	, ≠
"Ö	Ö	≠ Æ
)
Ü	Ü	 
;
Ü	Ü	 
}
á	á	 
return
â	â	 
Ok
â	â	 
(
â	â	 
new
â	â	 
{
â	â	 
message
â	â	 #
=
â	â	$ %
$str
â	â	& E
}
â	â	F G
)
â	â	G H
;
â	â	H I
}
ä	ä	 	
[
å	å	 	
HttpGet
å	å		 
(
å	å	 
$str
å	å	  
)
å	å	  !
]
å	å	! "
public
ç	ç	 
async
ç	ç	 
Task
ç	ç	 
<
ç	ç	 
IActionResult
ç	ç	 '
>
ç	ç	' (
GetLoginHistory
ç	ç	) 8
(
ç	ç	8 9
)
ç	ç	9 :
{
é	é	 	
var
è	è	 
userId
è	è	 
=
è	è	 
User
è	è	 
.
è	è	 
	FindFirst
è	è	 '
(
è	è	' (
System
è	è	( .
.
è	è	. /
Security
è	è	/ 7
.
è	è	7 8
Claims
è	è	8 >
.
è	è	> ?

ClaimTypes
è	è	? I
.
è	è	I J
NameIdentifier
è	è	J X
)
è	è	X Y
?
è	è	Y Z
.
è	è	Z [
Value
è	è	[ `
;
è	è	` a
var
ê	ê	 
loginHistory
ê	ê	 
=
ê	ê	 
await
ê	ê	 $
_context
ê	ê	% -
.
ê	ê	- .
LoginHistory
ê	ê	. :
.
ë	ë	 
Where
ë	ë	 
(
ë	ë	 
lh
ë	ë	 
=>
ë	ë	 
lh
ë	ë	 
.
ë	ë	  
UserID
ë	ë	  &
==
ë	ë	' )
userId
ë	ë	* 0
)
ë	ë	0 1
.
í	í	 
OrderByDescending
í	í	 "
(
í	í	" #
lh
í	í	# %
=>
í	í	& (
lh
í	í	) +
.
í	í	+ ,
	LoginTime
í	í	, 5
)
í	í	5 6
.
ì	ì	 
Take
ì	ì	 
(
ì	ì	 
$num
ì	ì	 
)
ì	ì	 
.
î	î	 
Select
î	î	 
(
î	î	 
lh
î	î	 
=>
î	î	 
new
î	î	 !
{
ï	ï	 
lh
ñ	ñ	 
.
ñ	ñ	 
LoginHistoryID
ñ	ñ	 %
,
ñ	ñ	% &
lh
ó	ó	 
.
ó	ó	 
Device
ó	ó	 
,
ó	ó	 
lh
ò	ò	 
.
ò	ò	 
Location
ò	ò	 
,
ò	ò	  
lh
ô	ô	 
.
ô	ô	 
	LoginTime
ô	ô	  
,
ô	ô	  !
lh
ö	ö	 
.
ö	ö	 
	IPAddress
ö	ö	  
,
ö	ö	  !
Current
õ	õ	 
=
õ	õ	 
lh
õ	õ	  
.
õ	õ	  !
	LoginTime
õ	õ	! *
>
õ	õ	+ ,
DateTime
õ	õ	- 5
.
õ	õ	5 6
UtcNow
õ	õ	6 <
.
õ	õ	< =
AddHours
õ	õ	= E
(
õ	õ	E F
-
õ	õ	F G
$num
õ	õ	G H
)
õ	õ	H I
}
ú	ú	 
)
ú	ú	 
.
ù	ù	 
ToListAsync
ù	ù	 
(
ù	ù	 
)
ù	ù	 
;
ù	ù	 
return
û	û	 
Ok
û	û	 
(
û	û	 
loginHistory
û	û	 "
)
û	û	" #
;
û	û	# $
}
ü	ü	 	
[
°	°	 	
HttpPost
°	°		 
(
°	°	 
$str
°	°	 
)
°	°	 
]
°	°	  
public
¢	¢	 
async
¢	¢	 
Task
¢	¢	 
<
¢	¢	 
IActionResult
¢	¢	 '
>
¢	¢	' (
	Enable2FA
¢	¢	) 2
(
¢	¢	2 3
)
¢	¢	3 4
{
£	£	 	
var
§	§	 
userId
§	§	 
=
§	§	 
User
§	§	 
.
§	§	 
	FindFirst
§	§	 '
(
§	§	' (
System
§	§	( .
.
§	§	. /
Security
§	§	/ 7
.
§	§	7 8
Claims
§	§	8 >
.
§	§	> ?

ClaimTypes
§	§	? I
.
§	§	I J
NameIdentifier
§	§	J X
)
§	§	X Y
?
§	§	Y Z
.
§	§	Z [
Value
§	§	[ `
;
§	§	` a
var
•	•	 
user
•	•	 
=
•	•	 
await
•	•	 
_userManager
•	•	 )
.
•	•	) *
FindByIdAsync
•	•	* 7
(
•	•	7 8
userId
•	•	8 >
!
•	•	> ?
)
•	•	? @
;
•	•	@ A
if
¶	¶	 
(
¶	¶	 
user
¶	¶	 
==
¶	¶	 
null
¶	¶	 
)
¶	¶	 
return
¶	¶	 $
NotFound
¶	¶	% -
(
¶	¶	- .
new
¶	¶	. 1
{
¶	¶	2 3
message
¶	¶	4 ;
=
¶	¶	< =
$str
¶	¶	> N
}
¶	¶	O P
)
¶	¶	P Q
;
¶	¶	Q R
var
®	®	 
code
®	®	 
=
®	®	 
new
®	®	 
Random
®	®	 !
(
®	®	! "
)
®	®	" #
.
®	®	# $
Next
®	®	$ (
(
®	®	( )
$num
®	®	) /
,
®	®	/ 0
$num
®	®	1 7
)
®	®	7 8
.
®	®	8 9
ToString
®	®	9 A
(
®	®	A B
)
®	®	B C
;
®	®	C D
_context
©	©	 
.
©	©	 
VerificationCodes
©	©	 &
.
©	©	& '
Add
©	©	' *
(
©	©	* +
new
©	©	+ .
VerificationCode
©	©	/ ?
{
™	™	 
Email
´	´	 
=
´	´	 
user
´	´	 
.
´	´	 
Email
´	´	 "
!
´	´	" #
,
´	´	# $
Code
¨	¨	 
=
¨	¨	 
code
¨	¨	 
,
¨	¨	 
	ExpiresAt
≠	≠	 
=
≠	≠	 
DateTime
≠	≠	 $
.
≠	≠	$ %
UtcNow
≠	≠	% +
.
≠	≠	+ ,

AddMinutes
≠	≠	, 6
(
≠	≠	6 7
$num
≠	≠	7 9
)
≠	≠	9 :
}
Æ	Æ	 
)
Æ	Æ	 
;
Æ	Æ	 
await
Ø	Ø	 
_context
Ø	Ø	 
.
Ø	Ø	 
SaveChangesAsync
Ø	Ø	 +
(
Ø	Ø	+ ,
)
Ø	Ø	, -
;
Ø	Ø	- .
await
∞	∞	 
_emailService
∞	∞	 
.
∞	∞	  
SendEmailAsync
∞	∞	  .
(
∞	∞	. /
user
∞	∞	/ 3
.
∞	∞	3 4
Email
∞	∞	4 9
!
∞	∞	9 :
,
∞	∞	: ;
$str
∞	∞	< Y
,
∞	∞	Y Z
$"
∞	∞	[ ]
$str
∞	∞	] x
{
∞	∞	x y
code
∞	∞	y }
}
∞	∞	} ~
"
∞	∞	~ 
)∞	∞	 Ä
;∞	∞	Ä Å
return
≤	≤	 
Ok
≤	≤	 
(
≤	≤	 
new
≤	≤	 
{
≤	≤	 
message
≤	≤	 #
=
≤	≤	$ %
$str
≤	≤	& L
}
≤	≤	M N
)
≤	≤	N O
;
≤	≤	O P
}
≥	≥	 	
[
µ	µ	 	
HttpPost
µ	µ		 
(
µ	µ	 
$str
µ	µ	 $
)
µ	µ	$ %
]
µ	µ	% &
public
∂	∂	 
async
∂	∂	 
Task
∂	∂	 
<
∂	∂	 
IActionResult
∂	∂	 '
>
∂	∂	' (
Verify2FASetup
∂	∂	) 7
(
∂	∂	7 8
[
∂	∂	8 9
FromBody
∂	∂	9 A
]
∂	∂	A B
VerifyCodeRequest
∂	∂	C T
request
∂	∂	U \
)
∂	∂	\ ]
{
∑	∑	 	
var
∏	∏	 
userId
∏	∏	 
=
∏	∏	 
User
∏	∏	 
.
∏	∏	 
	FindFirst
∏	∏	 '
(
∏	∏	' (
System
∏	∏	( .
.
∏	∏	. /
Security
∏	∏	/ 7
.
∏	∏	7 8
Claims
∏	∏	8 >
.
∏	∏	> ?

ClaimTypes
∏	∏	? I
.
∏	∏	I J
NameIdentifier
∏	∏	J X
)
∏	∏	X Y
?
∏	∏	Y Z
.
∏	∏	Z [
Value
∏	∏	[ `
;
∏	∏	` a
var
π	π	 
user
π	π	 
=
π	π	 
await
π	π	 
_userManager
π	π	 )
.
π	π	) *
FindByIdAsync
π	π	* 7
(
π	π	7 8
userId
π	π	8 >
!
π	π	> ?
)
π	π	? @
;
π	π	@ A
if
∫	∫	 
(
∫	∫	 
user
∫	∫	 
==
∫	∫	 
null
∫	∫	 
)
∫	∫	 
return
∫	∫	 $
NotFound
∫	∫	% -
(
∫	∫	- .
new
∫	∫	. 1
{
∫	∫	2 3
message
∫	∫	4 ;
=
∫	∫	< =
$str
∫	∫	> N
}
∫	∫	O P
)
∫	∫	P Q
;
∫	∫	Q R
var
º	º	 
verification
º	º	 
=
º	º	 
await
º	º	 $
_context
º	º	% -
.
º	º	- .
VerificationCodes
º	º	. ?
.
Ω	Ω	 !
FirstOrDefaultAsync
Ω	Ω	 $
(
Ω	Ω	$ %
v
Ω	Ω	% &
=>
Ω	Ω	' )
v
Ω	Ω	* +
.
Ω	Ω	+ ,
Email
Ω	Ω	, 1
==
Ω	Ω	2 4
user
Ω	Ω	5 9
.
Ω	Ω	9 :
Email
Ω	Ω	: ?
&&
Ω	Ω	@ B
v
Ω	Ω	C D
.
Ω	Ω	D E
Code
Ω	Ω	E I
==
Ω	Ω	J L
request
Ω	Ω	M T
.
Ω	Ω	T U
Code
Ω	Ω	U Y
&&
Ω	Ω	Z \
!
Ω	Ω	] ^
v
Ω	Ω	^ _
.
Ω	Ω	_ `
IsUsed
Ω	Ω	` f
&&
Ω	Ω	g i
v
Ω	Ω	j k
.
Ω	Ω	k l
	ExpiresAt
Ω	Ω	l u
>
Ω	Ω	v w
DateTimeΩ	Ω	x Ä
.Ω	Ω	Ä Å
UtcNowΩ	Ω	Å á
)Ω	Ω	á à
;Ω	Ω	à â
if
æ	æ	 
(
æ	æ	 
verification
æ	æ	 
==
æ	æ	 
null
æ	æ	  $
)
æ	æ	$ %
return
æ	æ	& ,

BadRequest
æ	æ	- 7
(
æ	æ	7 8
new
æ	æ	8 ;
{
æ	æ	< =
message
æ	æ	> E
=
æ	æ	F G
$str
æ	æ	H a
}
æ	æ	b c
)
æ	æ	c d
;
æ	æ	d e
await
¿	¿	 
_context
¿	¿	 
.
¿	¿	 
Users
¿	¿	  
.
¿	¿	  !
Where
¿	¿	! &
(
¿	¿	& '
u
¿	¿	' (
=>
¿	¿	) +
u
¿	¿	, -
.
¿	¿	- .
Id
¿	¿	. 0
==
¿	¿	1 3
userId
¿	¿	4 :
)
¿	¿	: ;
.
¿	¿	; < 
ExecuteUpdateAsync
¿	¿	< N
(
¿	¿	N O
u
¿	¿	O P
=>
¿	¿	Q S
u
¿	¿	T U
.
¿	¿	U V
SetProperty
¿	¿	V a
(
¿	¿	a b
p
¿	¿	b c
=>
¿	¿	d f
p
¿	¿	g h
.
¿	¿	h i
TwoFactorEnabled
¿	¿	i y
,
¿	¿	y z
true
¿	¿	{ 
)¿	¿	 Ä
)¿	¿	Ä Å
;¿	¿	Å Ç
verification
¬	¬	 
.
¬	¬	 
IsUsed
¬	¬	 
=
¬	¬	  !
true
¬	¬	" &
;
¬	¬	& '
await
√	√	 
_context
√	√	 
.
√	√	 
SaveChangesAsync
√	√	 +
(
√	√	+ ,
)
√	√	, -
;
√	√	- .
return
≈	≈	 
Ok
≈	≈	 
(
≈	≈	 
new
≈	≈	 
{
≈	≈	 
message
≈	≈	 #
=
≈	≈	$ %
$str
≈	≈	& V
}
≈	≈	W X
)
≈	≈	X Y
;
≈	≈	Y Z
}
∆	∆	 	
[
»	»	 	
HttpPost
»	»		 
(
»	»	 
$str
»	»	 
)
»	»	  
]
»	»	  !
public
…	…	 
async
…	…	 
Task
…	…	 
<
…	…	 
IActionResult
…	…	 '
>
…	…	' (

Disable2FA
…	…	) 3
(
…	…	3 4
)
…	…	4 5
{
 	 	 	
var
À	À	 
userId
À	À	 
=
À	À	 
User
À	À	 
.
À	À	 
	FindFirst
À	À	 '
(
À	À	' (
System
À	À	( .
.
À	À	. /
Security
À	À	/ 7
.
À	À	7 8
Claims
À	À	8 >
.
À	À	> ?

ClaimTypes
À	À	? I
.
À	À	I J
NameIdentifier
À	À	J X
)
À	À	X Y
?
À	À	Y Z
.
À	À	Z [
Value
À	À	[ `
;
À	À	` a
var
Ã	Ã	 
user
Ã	Ã	 
=
Ã	Ã	 
await
Ã	Ã	 
_userManager
Ã	Ã	 )
.
Ã	Ã	) *
FindByIdAsync
Ã	Ã	* 7
(
Ã	Ã	7 8
userId
Ã	Ã	8 >
!
Ã	Ã	> ?
)
Ã	Ã	? @
;
Ã	Ã	@ A
if
Õ	Õ	 
(
Õ	Õ	 
user
Õ	Õ	 
==
Õ	Õ	 
null
Õ	Õ	 
)
Õ	Õ	 
return
Õ	Õ	 $
NotFound
Õ	Õ	% -
(
Õ	Õ	- .
new
Õ	Õ	. 1
{
Õ	Õ	2 3
message
Õ	Õ	4 ;
=
Õ	Õ	< =
$str
Õ	Õ	> N
}
Õ	Õ	O P
)
Õ	Õ	P Q
;
Õ	Õ	Q R
var
œ	œ	 
code
œ	œ	 
=
œ	œ	 
new
œ	œ	 
Random
œ	œ	 !
(
œ	œ	! "
)
œ	œ	" #
.
œ	œ	# $
Next
œ	œ	$ (
(
œ	œ	( )
$num
œ	œ	) /
,
œ	œ	/ 0
$num
œ	œ	1 7
)
œ	œ	7 8
.
œ	œ	8 9
ToString
œ	œ	9 A
(
œ	œ	A B
)
œ	œ	B C
;
œ	œ	C D
_context
–	–	 
.
–	–	 
VerificationCodes
–	–	 &
.
–	–	& '
Add
–	–	' *
(
–	–	* +
new
–	–	+ .
VerificationCode
–	–	/ ?
{
—	—	 
Email
“	“	 
=
“	“	 
user
“	“	 
.
“	“	 
Email
“	“	 "
!
“	“	" #
,
“	“	# $
Code
”	”	 
=
”	”	 
code
”	”	 
,
”	”	 
	ExpiresAt
‘	‘	 
=
‘	‘	 
DateTime
‘	‘	 $
.
‘	‘	$ %
UtcNow
‘	‘	% +
.
‘	‘	+ ,

AddMinutes
‘	‘	, 6
(
‘	‘	6 7
$num
‘	‘	7 9
)
‘	‘	9 :
}
’	’	 
)
’	’	 
;
’	’	 
await
÷	÷	 
_context
÷	÷	 
.
÷	÷	 
SaveChangesAsync
÷	÷	 +
(
÷	÷	+ ,
)
÷	÷	, -
;
÷	÷	- .
await
◊	◊	 
_emailService
◊	◊	 
.
◊	◊	  
SendEmailAsync
◊	◊	  .
(
◊	◊	. /
user
◊	◊	/ 3
.
◊	◊	3 4
Email
◊	◊	4 9
!
◊	◊	9 :
,
◊	◊	: ;
$str
◊	◊	< Z
,
◊	◊	Z [
$"
◊	◊	\ ^
$str◊	◊	^ à
{◊	◊	à â
code◊	◊	â ç
}◊	◊	ç é
"◊	◊	é è
)◊	◊	è ê
;◊	◊	ê ë
return
Ÿ	Ÿ	 
Ok
Ÿ	Ÿ	 
(
Ÿ	Ÿ	 
new
Ÿ	Ÿ	 
{
Ÿ	Ÿ	 
message
Ÿ	Ÿ	 #
=
Ÿ	Ÿ	$ %
$str
Ÿ	Ÿ	& L
}
Ÿ	Ÿ	M N
)
Ÿ	Ÿ	N O
;
Ÿ	Ÿ	O P
}
⁄	⁄	 	
[
‹	‹	 	
HttpPost
‹	‹		 
(
‹	‹	 
$str
‹	‹	 &
)
‹	‹	& '
]
‹	‹	' (
public
›	›	 
async
›	›	 
Task
›	›	 
<
›	›	 
IActionResult
›	›	 '
>
›	›	' (
VerifyDisable2FA
›	›	) 9
(
›	›	9 :
[
›	›	: ;
FromBody
›	›	; C
]
›	›	C D
VerifyCodeRequest
›	›	E V
request
›	›	W ^
)
›	›	^ _
{
ﬁ	ﬁ	 	
var
ﬂ	ﬂ	 
userId
ﬂ	ﬂ	 
=
ﬂ	ﬂ	 
User
ﬂ	ﬂ	 
.
ﬂ	ﬂ	 
	FindFirst
ﬂ	ﬂ	 '
(
ﬂ	ﬂ	' (
System
ﬂ	ﬂ	( .
.
ﬂ	ﬂ	. /
Security
ﬂ	ﬂ	/ 7
.
ﬂ	ﬂ	7 8
Claims
ﬂ	ﬂ	8 >
.
ﬂ	ﬂ	> ?

ClaimTypes
ﬂ	ﬂ	? I
.
ﬂ	ﬂ	I J
NameIdentifier
ﬂ	ﬂ	J X
)
ﬂ	ﬂ	X Y
?
ﬂ	ﬂ	Y Z
.
ﬂ	ﬂ	Z [
Value
ﬂ	ﬂ	[ `
;
ﬂ	ﬂ	` a
var
‡	‡	 
user
‡	‡	 
=
‡	‡	 
await
‡	‡	 
_userManager
‡	‡	 )
.
‡	‡	) *
FindByIdAsync
‡	‡	* 7
(
‡	‡	7 8
userId
‡	‡	8 >
!
‡	‡	> ?
)
‡	‡	? @
;
‡	‡	@ A
if
·	·	 
(
·	·	 
user
·	·	 
==
·	·	 
null
·	·	 
)
·	·	 
return
·	·	 $
NotFound
·	·	% -
(
·	·	- .
new
·	·	. 1
{
·	·	2 3
message
·	·	4 ;
=
·	·	< =
$str
·	·	> N
}
·	·	O P
)
·	·	P Q
;
·	·	Q R
var
„	„	 
verification
„	„	 
=
„	„	 
await
„	„	 $
_context
„	„	% -
.
„	„	- .
VerificationCodes
„	„	. ?
.
‰	‰	 !
FirstOrDefaultAsync
‰	‰	 $
(
‰	‰	$ %
v
‰	‰	% &
=>
‰	‰	' )
v
‰	‰	* +
.
‰	‰	+ ,
Email
‰	‰	, 1
==
‰	‰	2 4
user
‰	‰	5 9
.
‰	‰	9 :
Email
‰	‰	: ?
&&
‰	‰	@ B
v
‰	‰	C D
.
‰	‰	D E
Code
‰	‰	E I
==
‰	‰	J L
request
‰	‰	M T
.
‰	‰	T U
Code
‰	‰	U Y
&&
‰	‰	Z \
!
‰	‰	] ^
v
‰	‰	^ _
.
‰	‰	_ `
IsUsed
‰	‰	` f
&&
‰	‰	g i
v
‰	‰	j k
.
‰	‰	k l
	ExpiresAt
‰	‰	l u
>
‰	‰	v w
DateTime‰	‰	x Ä
.‰	‰	Ä Å
UtcNow‰	‰	Å á
)‰	‰	á à
;‰	‰	à â
if
Â	Â	 
(
Â	Â	 
verification
Â	Â	 
==
Â	Â	 
null
Â	Â	  $
)
Â	Â	$ %
return
Â	Â	& ,

BadRequest
Â	Â	- 7
(
Â	Â	7 8
new
Â	Â	8 ;
{
Â	Â	< =
message
Â	Â	> E
=
Â	Â	F G
$str
Â	Â	H a
}
Â	Â	b c
)
Â	Â	c d
;
Â	Â	d e
await
Ë	Ë	 
_context
Ë	Ë	 
.
Ë	Ë	 
Users
Ë	Ë	  
.
Ë	Ë	  !
Where
Ë	Ë	! &
(
Ë	Ë	& '
u
Ë	Ë	' (
=>
Ë	Ë	) +
u
Ë	Ë	, -
.
Ë	Ë	- .
Id
Ë	Ë	. 0
==
Ë	Ë	1 3
userId
Ë	Ë	4 :
)
Ë	Ë	: ;
.
Ë	Ë	; < 
ExecuteUpdateAsync
Ë	Ë	< N
(
Ë	Ë	N O
u
Ë	Ë	O P
=>
Ë	Ë	Q S
u
Ë	Ë	T U
.
Ë	Ë	U V
SetProperty
Ë	Ë	V a
(
Ë	Ë	a b
p
Ë	Ë	b c
=>
Ë	Ë	d f
p
Ë	Ë	g h
.
Ë	Ë	h i
TwoFactorEnabled
Ë	Ë	i y
,
Ë	Ë	y z
falseË	Ë	{ Ä
)Ë	Ë	Ä Å
)Ë	Ë	Å Ç
;Ë	Ë	Ç É
verification
Í	Í	 
.
Í	Í	 
IsUsed
Í	Í	 
=
Í	Í	  !
true
Í	Í	" &
;
Í	Í	& '
await
Î	Î	 
_context
Î	Î	 
.
Î	Î	 
SaveChangesAsync
Î	Î	 +
(
Î	Î	+ ,
)
Î	Î	, -
;
Î	Î	- .
return
Ì	Ì	 
Ok
Ì	Ì	 
(
Ì	Ì	 
new
Ì	Ì	 
{
Ì	Ì	 
message
Ì	Ì	 #
=
Ì	Ì	$ %
$str
Ì	Ì	& W
}
Ì	Ì	X Y
)
Ì	Ì	Y Z
;
Ì	Ì	Z [
}
Ó	Ó	 	
[
		 	
HttpGet
			 
(
		 
$str
		 
)
		 
]
		 
public
Ò	Ò	 
async
Ò	Ò	 
Task
Ò	Ò	 
<
Ò	Ò	 
IActionResult
Ò	Ò	 '
>
Ò	Ò	' (
Get2FAStatus
Ò	Ò	) 5
(
Ò	Ò	5 6
)
Ò	Ò	6 7
{
Ú	Ú	 	
var
Û	Û	 
userId
Û	Û	 
=
Û	Û	 
User
Û	Û	 
.
Û	Û	 
	FindFirst
Û	Û	 '
(
Û	Û	' (
System
Û	Û	( .
.
Û	Û	. /
Security
Û	Û	/ 7
.
Û	Û	7 8
Claims
Û	Û	8 >
.
Û	Û	> ?

ClaimTypes
Û	Û	? I
.
Û	Û	I J
NameIdentifier
Û	Û	J X
)
Û	Û	X Y
?
Û	Û	Y Z
.
Û	Û	Z [
Value
Û	Û	[ `
;
Û	Û	` a
var
Ù	Ù	 
user
Ù	Ù	 
=
Ù	Ù	 
await
Ù	Ù	 
_userManager
Ù	Ù	 )
.
Ù	Ù	) *
FindByIdAsync
Ù	Ù	* 7
(
Ù	Ù	7 8
userId
Ù	Ù	8 >
!
Ù	Ù	> ?
)
Ù	Ù	? @
;
Ù	Ù	@ A
if
ı	ı	 
(
ı	ı	 
user
ı	ı	 
==
ı	ı	 
null
ı	ı	 
)
ı	ı	 
return
ı	ı	 $
NotFound
ı	ı	% -
(
ı	ı	- .
new
ı	ı	. 1
{
ı	ı	2 3
message
ı	ı	4 ;
=
ı	ı	< =
$str
ı	ı	> N
}
ı	ı	O P
)
ı	ı	P Q
;
ı	ı	Q R
return
˜	˜	 
Ok
˜	˜	 
(
˜	˜	 
new
˜	˜	 
{
˜	˜	 
twoFactorEnabled
˜	˜	 ,
=
˜	˜	- .
user
˜	˜	/ 3
.
˜	˜	3 4
TwoFactorEnabled
˜	˜	4 D
}
˜	˜	E F
)
˜	˜	F G
;
˜	˜	G H
}
¯	¯	 	
[
˙	˙	 	
HttpPost
˙	˙		 
(
˙	˙	 
$str
˙	˙	 $
)
˙	˙	$ %
]
˙	˙	% &
public
˚	˚	 
async
˚	˚	 
Task
˚	˚	 
<
˚	˚	 
IActionResult
˚	˚	 '
>
˚	˚	' (
SetSecurityPin
˚	˚	) 7
(
˚	˚	7 8
[
˚	˚	8 9
FromBody
˚	˚	9 A
]
˚	˚	A B
SetPinRequest
˚	˚	C P
request
˚	˚	Q X
)
˚	˚	X Y
{
¸	¸	 	
var
˝	˝	 
userId
˝	˝	 
=
˝	˝	 
User
˝	˝	 
.
˝	˝	 
	FindFirst
˝	˝	 '
(
˝	˝	' (
System
˝	˝	( .
.
˝	˝	. /
Security
˝	˝	/ 7
.
˝	˝	7 8
Claims
˝	˝	8 >
.
˝	˝	> ?

ClaimTypes
˝	˝	? I
.
˝	˝	I J
NameIdentifier
˝	˝	J X
)
˝	˝	X Y
?
˝	˝	Y Z
.
˝	˝	Z [
Value
˝	˝	[ `
;
˝	˝	` a
var
˛	˛	 
user
˛	˛	 
=
˛	˛	 
await
˛	˛	 
_userManager
˛	˛	 )
.
˛	˛	) *
FindByIdAsync
˛	˛	* 7
(
˛	˛	7 8
userId
˛	˛	8 >
!
˛	˛	> ?
)
˛	˛	? @
;
˛	˛	@ A
if
ˇ	ˇ	 
(
ˇ	ˇ	 
user
ˇ	ˇ	 
==
ˇ	ˇ	 
null
ˇ	ˇ	 
)
ˇ	ˇ	 
return
ˇ	ˇ	 $
NotFound
ˇ	ˇ	% -
(
ˇ	ˇ	- .
new
ˇ	ˇ	. 1
{
ˇ	ˇ	2 3
message
ˇ	ˇ	4 ;
=
ˇ	ˇ	< =
$str
ˇ	ˇ	> N
}
ˇ	ˇ	O P
)
ˇ	ˇ	P Q
;
ˇ	ˇ	Q R
user
Å
Å
 
.
Å
Å
 
SecurityPin
Å
Å
 
=
Å
Å
 
request
Å
Å
 &
.
Å
Å
& '
Pin
Å
Å
' *
;
Å
Å
* +
user
Ç
Ç
 
.
Ç
Ç
 "
PinProtectionEnabled
Ç
Ç
 %
=
Ç
Ç
& '
true
Ç
Ç
( ,
;
Ç
Ç
, -
await
É
É
 
_userManager
É
É
 
.
É
É
 
UpdateAsync
É
É
 *
(
É
É
* +
user
É
É
+ /
)
É
É
/ 0
;
É
É
0 1
return
Ñ
Ñ
 
Ok
Ñ
Ñ
 
(
Ñ
Ñ
 
new
Ñ
Ñ
 
{
Ñ
Ñ
 
message
Ñ
Ñ
 #
=
Ñ
Ñ
$ %
$str
Ñ
Ñ
& E
}
Ñ
Ñ
F G
)
Ñ
Ñ
G H
;
Ñ
Ñ
H I
}
Ö
Ö
 	
[
á
á
 	
HttpPost
á
á
	 
(
á
á
 
$str
á
á
 '
)
á
á
' (
]
á
á
( )
public
à
à
 
async
à
à
 
Task
à
à
 
<
à
à
 
IActionResult
à
à
 '
>
à
à
' (
VerifySecurityPin
à
à
) :
(
à
à
: ;
[
à
à
; <
FromBody
à
à
< D
]
à
à
D E
VerifyPinRequest
à
à
F V
request
à
à
W ^
)
à
à
^ _
{
â
â
 	
var
ä
ä
 
userId
ä
ä
 
=
ä
ä
 
User
ä
ä
 
.
ä
ä
 
	FindFirst
ä
ä
 '
(
ä
ä
' (
System
ä
ä
( .
.
ä
ä
. /
Security
ä
ä
/ 7
.
ä
ä
7 8
Claims
ä
ä
8 >
.
ä
ä
> ?

ClaimTypes
ä
ä
? I
.
ä
ä
I J
NameIdentifier
ä
ä
J X
)
ä
ä
X Y
?
ä
ä
Y Z
.
ä
ä
Z [
Value
ä
ä
[ `
;
ä
ä
` a
var
ã
ã
 
user
ã
ã
 
=
ã
ã
 
await
ã
ã
 
_userManager
ã
ã
 )
.
ã
ã
) *
FindByIdAsync
ã
ã
* 7
(
ã
ã
7 8
userId
ã
ã
8 >
!
ã
ã
> ?
)
ã
ã
? @
;
ã
ã
@ A
if
å
å
 
(
å
å
 
user
å
å
 
==
å
å
 
null
å
å
 
)
å
å
 
return
å
å
 $
NotFound
å
å
% -
(
å
å
- .
new
å
å
. 1
{
å
å
2 3
message
å
å
4 ;
=
å
å
< =
$str
å
å
> N
}
å
å
O P
)
å
å
P Q
;
å
å
Q R
if
é
é
 
(
é
é
 
user
é
é
 
.
é
é
 
SecurityPin
é
é
  
!=
é
é
! #
request
é
é
$ +
.
é
é
+ ,
Pin
é
é
, /
)
é
é
/ 0
return
è
è
 

BadRequest
è
è
 !
(
è
è
! "
new
è
è
" %
{
è
è
& '
message
è
è
( /
=
è
è
0 1
$str
è
è
2 ?
}
è
è
@ A
)
è
è
A B
;
è
è
B C
return
ë
ë
 
Ok
ë
ë
 
(
ë
ë
 
new
ë
ë
 
{
ë
ë
 
message
ë
ë
 #
=
ë
ë
$ %
$str
ë
ë
& A
}
ë
ë
B C
)
ë
ë
C D
;
ë
ë
D E
}
í
í
 	
[
î
î
 	
HttpPost
î
î
	 
(
î
î
 
$str
î
î
 )
)
î
î
) *
]
î
î
* +
public
ï
ï
 
async
ï
ï
 
Task
ï
ï
 
<
ï
ï
 
IActionResult
ï
ï
 '
>
ï
ï
' (!
TogglePinProtection
ï
ï
) <
(
ï
ï
< =
)
ï
ï
= >
{
ñ
ñ
 	
var
ó
ó
 
userId
ó
ó
 
=
ó
ó
 
User
ó
ó
 
.
ó
ó
 
	FindFirst
ó
ó
 '
(
ó
ó
' (
System
ó
ó
( .
.
ó
ó
. /
Security
ó
ó
/ 7
.
ó
ó
7 8
Claims
ó
ó
8 >
.
ó
ó
> ?

ClaimTypes
ó
ó
? I
.
ó
ó
I J
NameIdentifier
ó
ó
J X
)
ó
ó
X Y
?
ó
ó
Y Z
.
ó
ó
Z [
Value
ó
ó
[ `
;
ó
ó
` a
var
ò
ò
 
user
ò
ò
 
=
ò
ò
 
await
ò
ò
 
_userManager
ò
ò
 )
.
ò
ò
) *
FindByIdAsync
ò
ò
* 7
(
ò
ò
7 8
userId
ò
ò
8 >
!
ò
ò
> ?
)
ò
ò
? @
;
ò
ò
@ A
if
ô
ô
 
(
ô
ô
 
user
ô
ô
 
==
ô
ô
 
null
ô
ô
 
)
ô
ô
 
return
ô
ô
 $
NotFound
ô
ô
% -
(
ô
ô
- .
new
ô
ô
. 1
{
ô
ô
2 3
message
ô
ô
4 ;
=
ô
ô
< =
$str
ô
ô
> N
}
ô
ô
O P
)
ô
ô
P Q
;
ô
ô
Q R
if
ú
ú
 
(
ú
ú
 
user
ú
ú
 
.
ú
ú
 "
PinProtectionEnabled
ú
ú
 )
)
ú
ú
) *
{
ù
ù
 
var
û
û
 
code
û
û
 
=
û
û
 
new
û
û
 
Random
û
û
 %
(
û
û
% &
)
û
û
& '
.
û
û
' (
Next
û
û
( ,
(
û
û
, -
$num
û
û
- 3
,
û
û
3 4
$num
û
û
5 ;
)
û
û
; <
.
û
û
< =
ToString
û
û
= E
(
û
û
E F
)
û
û
F G
;
û
û
G H
_context
ü
ü
 
.
ü
ü
 
VerificationCodes
ü
ü
 *
.
ü
ü
* +
Add
ü
ü
+ .
(
ü
ü
. /
new
ü
ü
/ 2
VerificationCode
ü
ü
3 C
{
†
†
 
Email
°
°
 
=
°
°
 
user
°
°
  
.
°
°
  !
Email
°
°
! &
!
°
°
& '
,
°
°
' (
Code
¢
¢
 
=
¢
¢
 
code
¢
¢
 
,
¢
¢
  
	ExpiresAt
£
£
 
=
£
£
 
DateTime
£
£
  (
.
£
£
( )
UtcNow
£
£
) /
.
£
£
/ 0

AddMinutes
£
£
0 :
(
£
£
: ;
$num
£
£
; =
)
£
£
= >
}
§
§
 
)
§
§
 
;
§
§
 
await
•
•
 
_context
•
•
 
.
•
•
 
SaveChangesAsync
•
•
 /
(
•
•
/ 0
)
•
•
0 1
;
•
•
1 2
await
¶
¶
 
_emailService
¶
¶
 #
.
¶
¶
# $
SendEmailAsync
¶
¶
$ 2
(
¶
¶
2 3
user
¶
¶
3 7
.
¶
¶
7 8
Email
¶
¶
8 =
!
¶
¶
= >
,
¶
¶
> ?
$str
¶
¶
@ i
,
¶
¶
i j
$"
¶
¶
k m
$str¶
¶
m ¢
{¶
¶
¢ £
code¶
¶
£ ß
}¶
¶
ß ®
"¶
¶
® ©
)¶
¶
© ™
;¶
¶
™ ´
return
®
®
 
Ok
®
®
 
(
®
®
 
new
®
®
 
{
®
®
 "
requiresVerification
®
®
  4
=
®
®
5 6
true
®
®
7 ;
,
®
®
; <
message
®
®
= D
=
®
®
E F
$str
®
®
G m
}
®
®
n o
)
®
®
o p
;
®
®
p q
}
©
©
 
else
™
™
 
{
´
´
 
user
≠
≠
 
.
≠
≠
 "
PinProtectionEnabled
≠
≠
 )
=
≠
≠
* +
true
≠
≠
, 0
;
≠
≠
0 1
await
Æ
Æ
 
_userManager
Æ
Æ
 "
.
Æ
Æ
" #
UpdateAsync
Æ
Æ
# .
(
Æ
Æ
. /
user
Æ
Æ
/ 3
)
Æ
Æ
3 4
;
Æ
Æ
4 5
return
Ø
Ø
 
Ok
Ø
Ø
 
(
Ø
Ø
 
new
Ø
Ø
 
{
Ø
Ø
 "
pinProtectionEnabled
Ø
Ø
  4
=
Ø
Ø
5 6
true
Ø
Ø
7 ;
}
Ø
Ø
< =
)
Ø
Ø
= >
;
Ø
Ø
> ?
}
∞
∞
 
}
±
±
 	
[
≥
≥
 	
HttpPost
≥
≥
	 
(
≥
≥
 
$str
≥
≥
 &
)
≥
≥
& '
]
≥
≥
' (
public
¥
¥
 
async
¥
¥
 
Task
¥
¥
 
<
¥
¥
 
IActionResult
¥
¥
 '
>
¥
¥
' (
VerifyDisablePin
¥
¥
) 9
(
¥
¥
9 :
[
¥
¥
: ;
FromBody
¥
¥
; C
]
¥
¥
C D
VerifyCodeRequest
¥
¥
E V
request
¥
¥
W ^
)
¥
¥
^ _
{
µ
µ
 	
var
∂
∂
 
userId
∂
∂
 
=
∂
∂
 
User
∂
∂
 
.
∂
∂
 
	FindFirst
∂
∂
 '
(
∂
∂
' (
System
∂
∂
( .
.
∂
∂
. /
Security
∂
∂
/ 7
.
∂
∂
7 8
Claims
∂
∂
8 >
.
∂
∂
> ?

ClaimTypes
∂
∂
? I
.
∂
∂
I J
NameIdentifier
∂
∂
J X
)
∂
∂
X Y
?
∂
∂
Y Z
.
∂
∂
Z [
Value
∂
∂
[ `
;
∂
∂
` a
var
∑
∑
 
user
∑
∑
 
=
∑
∑
 
await
∑
∑
 
_userManager
∑
∑
 )
.
∑
∑
) *
FindByIdAsync
∑
∑
* 7
(
∑
∑
7 8
userId
∑
∑
8 >
!
∑
∑
> ?
)
∑
∑
? @
;
∑
∑
@ A
if
∏
∏
 
(
∏
∏
 
user
∏
∏
 
==
∏
∏
 
null
∏
∏
 
)
∏
∏
 
return
∏
∏
 $
NotFound
∏
∏
% -
(
∏
∏
- .
new
∏
∏
. 1
{
∏
∏
2 3
message
∏
∏
4 ;
=
∏
∏
< =
$str
∏
∏
> N
}
∏
∏
O P
)
∏
∏
P Q
;
∏
∏
Q R
var
∫
∫
 
verification
∫
∫
 
=
∫
∫
 
await
∫
∫
 $
_context
∫
∫
% -
.
∫
∫
- .
VerificationCodes
∫
∫
. ?
.
ª
ª
 !
FirstOrDefaultAsync
ª
ª
 $
(
ª
ª
$ %
v
ª
ª
% &
=>
ª
ª
' )
v
ª
ª
* +
.
ª
ª
+ ,
Email
ª
ª
, 1
==
ª
ª
2 4
user
ª
ª
5 9
.
ª
ª
9 :
Email
ª
ª
: ?
&&
ª
ª
@ B
v
ª
ª
C D
.
ª
ª
D E
Code
ª
ª
E I
==
ª
ª
J L
request
ª
ª
M T
.
ª
ª
T U
Code
ª
ª
U Y
&&
ª
ª
Z \
!
ª
ª
] ^
v
ª
ª
^ _
.
ª
ª
_ `
IsUsed
ª
ª
` f
&&
ª
ª
g i
v
ª
ª
j k
.
ª
ª
k l
	ExpiresAt
ª
ª
l u
>
ª
ª
v w
DateTimeª
ª
x Ä
.ª
ª
Ä Å
UtcNowª
ª
Å á
)ª
ª
á à
;ª
ª
à â
if
º
º
 
(
º
º
 
verification
º
º
 
==
º
º
 
null
º
º
  $
)
º
º
$ %
return
º
º
& ,

BadRequest
º
º
- 7
(
º
º
7 8
new
º
º
8 ;
{
º
º
< =
message
º
º
> E
=
º
º
F G
$str
º
º
H a
}
º
º
b c
)
º
º
c d
;
º
º
d e
user
æ
æ
 
.
æ
æ
 "
PinProtectionEnabled
æ
æ
 %
=
æ
æ
& '
false
æ
æ
( -
;
æ
æ
- .
await
ø
ø
 
_userManager
ø
ø
 
.
ø
ø
 
UpdateAsync
ø
ø
 *
(
ø
ø
* +
user
ø
ø
+ /
)
ø
ø
/ 0
;
ø
ø
0 1
verification
¿
¿
 
.
¿
¿
 
IsUsed
¿
¿
 
=
¿
¿
  !
true
¿
¿
" &
;
¿
¿
& '
await
¡
¡
 
_context
¡
¡
 
.
¡
¡
 
SaveChangesAsync
¡
¡
 +
(
¡
¡
+ ,
)
¡
¡
, -
;
¡
¡
- .
return
√
√
 
Ok
√
√
 
(
√
√
 
new
√
√
 
{
√
√
 "
pinProtectionEnabled
√
√
 0
=
√
√
1 2
false
√
√
3 8
,
√
√
8 9
message
√
√
: A
=
√
√
B C
$str
√
√
D j
}
√
√
k l
)
√
√
l m
;
√
√
m n
}
ƒ
ƒ
 	
[
∆
∆
 	
HttpGet
∆
∆
	 
(
∆
∆
 
$str
∆
∆
 
)
∆
∆
 
]
∆
∆
 
public
«
«
 
async
«
«
 
Task
«
«
 
<
«
«
 
IActionResult
«
«
 '
>
«
«
' (
GetPinStatus
«
«
) 5
(
«
«
5 6
)
«
«
6 7
{
»
»
 	
var
…
…
 
userId
…
…
 
=
…
…
 
User
…
…
 
.
…
…
 
	FindFirst
…
…
 '
(
…
…
' (
System
…
…
( .
.
…
…
. /
Security
…
…
/ 7
.
…
…
7 8
Claims
…
…
8 >
.
…
…
> ?

ClaimTypes
…
…
? I
.
…
…
I J
NameIdentifier
…
…
J X
)
…
…
X Y
?
…
…
Y Z
.
…
…
Z [
Value
…
…
[ `
;
…
…
` a
var
 
 
 
user
 
 
 
=
 
 
 
await
 
 
 
_userManager
 
 
 )
.
 
 
) *
FindByIdAsync
 
 
* 7
(
 
 
7 8
userId
 
 
8 >
!
 
 
> ?
)
 
 
? @
;
 
 
@ A
if
À
À
 
(
À
À
 
user
À
À
 
==
À
À
 
null
À
À
 
)
À
À
 
return
À
À
 $
NotFound
À
À
% -
(
À
À
- .
new
À
À
. 1
{
À
À
2 3
message
À
À
4 ;
=
À
À
< =
$str
À
À
> N
}
À
À
O P
)
À
À
P Q
;
À
À
Q R
return
Õ
Õ
 
Ok
Õ
Õ
 
(
Õ
Õ
 
new
Õ
Õ
 
{
Õ
Õ
 "
pinProtectionEnabled
Œ
Œ
 $
=
Œ
Œ
% &
user
Œ
Œ
' +
.
Œ
Œ
+ ,"
PinProtectionEnabled
Œ
Œ
, @
,
Œ
Œ
@ A
	hasPinSet
œ
œ
 
=
œ
œ
 
!
œ
œ
 
string
œ
œ
 #
.
œ
œ
# $
IsNullOrEmpty
œ
œ
$ 1
(
œ
œ
1 2
user
œ
œ
2 6
.
œ
œ
6 7
SecurityPin
œ
œ
7 B
)
œ
œ
B C
}
–
–
 
)
–
–
 
;
–
–
 
}
—
—
 	
[
”
”
 	
HttpGet
”
”
	 
(
”
”
 
$str
”
”
 +
)
”
”
+ ,
]
”
”
, -
public
‘
‘
 
async
‘
‘
 
Task
‘
‘
 
<
‘
‘
 
IActionResult
‘
‘
 '
>
‘
‘
' ((
GetNotificationPreferences
‘
‘
) C
(
‘
‘
C D
)
‘
‘
D E
{
’
’
 	
var
÷
÷
 
userId
÷
÷
 
=
÷
÷
 
User
÷
÷
 
.
÷
÷
 
	FindFirst
÷
÷
 '
(
÷
÷
' (
System
÷
÷
( .
.
÷
÷
. /
Security
÷
÷
/ 7
.
÷
÷
7 8
Claims
÷
÷
8 >
.
÷
÷
> ?

ClaimTypes
÷
÷
? I
.
÷
÷
I J
NameIdentifier
÷
÷
J X
)
÷
÷
X Y
?
÷
÷
Y Z
.
÷
÷
Z [
Value
÷
÷
[ `
;
÷
÷
` a
var
◊
◊
 
preferences
◊
◊
 
=
◊
◊
 
await
◊
◊
 #
_context
◊
◊
$ ,
.
◊
◊
, -%
NotificationPreferences
◊
◊
- D
.
ÿ
ÿ
 
Where
ÿ
ÿ
 
(
ÿ
ÿ
 
np
ÿ
ÿ
 
=>
ÿ
ÿ
 
np
ÿ
ÿ
 
.
ÿ
ÿ
  
UserID
ÿ
ÿ
  &
==
ÿ
ÿ
' )
userId
ÿ
ÿ
* 0
)
ÿ
ÿ
0 1
.
Ÿ
Ÿ
 
ToDictionaryAsync
Ÿ
Ÿ
 "
(
Ÿ
Ÿ
" #
np
Ÿ
Ÿ
# %
=>
Ÿ
Ÿ
& (
np
Ÿ
Ÿ
) +
.
Ÿ
Ÿ
+ ,
NotificationType
Ÿ
Ÿ
, <
,
Ÿ
Ÿ
< =
np
Ÿ
Ÿ
> @
=>
Ÿ
Ÿ
A C
np
Ÿ
Ÿ
D F
.
Ÿ
Ÿ
F G
EmailEnabled
Ÿ
Ÿ
G S
)
Ÿ
Ÿ
S T
;
Ÿ
Ÿ
T U
return
⁄
⁄
 
Ok
⁄
⁄
 
(
⁄
⁄
 
preferences
⁄
⁄
 !
)
⁄
⁄
! "
;
⁄
⁄
" #
}
€
€
 	
[
›
›
 	
HttpPost
›
›
	 
(
›
›
 
$str
›
›
 ,
)
›
›
, -
]
›
›
- .
public
ﬁ
ﬁ
 
async
ﬁ
ﬁ
 
Task
ﬁ
ﬁ
 
<
ﬁ
ﬁ
 
IActionResult
ﬁ
ﬁ
 '
>
ﬁ
ﬁ
' (+
UpdateNotificationPreferences
ﬁ
ﬁ
) F
(
ﬁ
ﬁ
F G
[
ﬁ
ﬁ
G H
FromBody
ﬁ
ﬁ
H P
]
ﬁ
ﬁ
P Q

Dictionary
ﬁ
ﬁ
R \
<
ﬁ
ﬁ
\ ]
string
ﬁ
ﬁ
] c
,
ﬁ
ﬁ
c d
bool
ﬁ
ﬁ
e i
>
ﬁ
ﬁ
i j
preferences
ﬁ
ﬁ
k v
)
ﬁ
ﬁ
v w
{
ﬂ
ﬂ
 	
var
‡
‡
 
userId
‡
‡
 
=
‡
‡
 
User
‡
‡
 
.
‡
‡
 
	FindFirst
‡
‡
 '
(
‡
‡
' (
System
‡
‡
( .
.
‡
‡
. /
Security
‡
‡
/ 7
.
‡
‡
7 8
Claims
‡
‡
8 >
.
‡
‡
> ?

ClaimTypes
‡
‡
? I
.
‡
‡
I J
NameIdentifier
‡
‡
J X
)
‡
‡
X Y
?
‡
‡
Y Z
.
‡
‡
Z [
Value
‡
‡
[ `
;
‡
‡
` a
foreach
‚
‚
 
(
‚
‚
 
var
‚
‚
 
pref
‚
‚
 
in
‚
‚
  
preferences
‚
‚
! ,
)
‚
‚
, -
{
„
„
 
var
‰
‰
 
existing
‰
‰
 
=
‰
‰
 
await
‰
‰
 $
_context
‰
‰
% -
.
‰
‰
- .%
NotificationPreferences
‰
‰
. E
.
Â
Â
 !
FirstOrDefaultAsync
Â
Â
 (
(
Â
Â
( )
np
Â
Â
) +
=>
Â
Â
, .
np
Â
Â
/ 1
.
Â
Â
1 2
UserID
Â
Â
2 8
==
Â
Â
9 ;
userId
Â
Â
< B
&&
Â
Â
C E
np
Â
Â
F H
.
Â
Â
H I
NotificationType
Â
Â
I Y
==
Â
Â
Z \
pref
Â
Â
] a
.
Â
Â
a b
Key
Â
Â
b e
)
Â
Â
e f
;
Â
Â
f g
if
Á
Á
 
(
Á
Á
 
existing
Á
Á
 
!=
Á
Á
 
null
Á
Á
  $
)
Á
Á
$ %
{
Ë
Ë
 
existing
È
È
 
.
È
È
 
EmailEnabled
È
È
 )
=
È
È
* +
pref
È
È
, 0
.
È
È
0 1
Value
È
È
1 6
;
È
È
6 7
existing
Í
Í
 
.
Í
Í
 
	UpdatedAt
Í
Í
 &
=
Í
Í
' (
DateTime
Í
Í
) 1
.
Í
Í
1 2
UtcNow
Í
Í
2 8
;
Í
Í
8 9
}
Î
Î
 
else
Ï
Ï
 
{
Ì
Ì
 
_context
Ó
Ó
 
.
Ó
Ó
 %
NotificationPreferences
Ó
Ó
 4
.
Ó
Ó
4 5
Add
Ó
Ó
5 8
(
Ó
Ó
8 9
new
Ó
Ó
9 <$
NotificationPreference
Ó
Ó
= S
{
Ô
Ô
 
UserID


 
=


  
userId


! '
!


' (
,


( )
NotificationType
Ò
Ò
 (
=
Ò
Ò
) *
pref
Ò
Ò
+ /
.
Ò
Ò
/ 0
Key
Ò
Ò
0 3
,
Ò
Ò
3 4
EmailEnabled
Ú
Ú
 $
=
Ú
Ú
% &
pref
Ú
Ú
' +
.
Ú
Ú
+ ,
Value
Ú
Ú
, 1
}
Û
Û
 
)
Û
Û
 
;
Û
Û
 
}
Ù
Ù
 
}
ı
ı
 
await
˜
˜
 
_context
˜
˜
 
.
˜
˜
 
SaveChangesAsync
˜
˜
 +
(
˜
˜
+ ,
)
˜
˜
, -
;
˜
˜
- .
return
¯
¯
 
Ok
¯
¯
 
(
¯
¯
 
new
¯
¯
 
{
¯
¯
 
message
¯
¯
 #
=
¯
¯
$ %
$str
¯
¯
& U
}
¯
¯
V W
)
¯
¯
W X
;
¯
¯
X Y
}
˘
˘
 	
}
˙
˙
 
public
¸
¸
 

class
¸
¸
 "
UpdateProfileRequest
¸
¸
 %
{
˝
˝
 
public
˛
˛
 
string
˛
˛
 
	FirstName
˛
˛
 
{
˛
˛
  !
get
˛
˛
" %
;
˛
˛
% &
set
˛
˛
' *
;
˛
˛
* +
}
˛
˛
, -
=
˛
˛
. /
string
˛
˛
0 6
.
˛
˛
6 7
Empty
˛
˛
7 <
;
˛
˛
< =
public
ˇ
ˇ
 
string
ˇ
ˇ
 
LastName
ˇ
ˇ
 
{
ˇ
ˇ
  
get
ˇ
ˇ
! $
;
ˇ
ˇ
$ %
set
ˇ
ˇ
& )
;
ˇ
ˇ
) *
}
ˇ
ˇ
+ ,
=
ˇ
ˇ
- .
string
ˇ
ˇ
/ 5
.
ˇ
ˇ
5 6
Empty
ˇ
ˇ
6 ;
;
ˇ
ˇ
; <
public
ÄÄ 
string
ÄÄ 
?
ÄÄ 
Birthday
ÄÄ 
{
ÄÄ  !
get
ÄÄ" %
;
ÄÄ% &
set
ÄÄ' *
;
ÄÄ* +
}
ÄÄ, -
public
ÅÅ 
string
ÅÅ 
?
ÅÅ 
Address
ÅÅ 
{
ÅÅ  
get
ÅÅ! $
;
ÅÅ$ %
set
ÅÅ& )
;
ÅÅ) *
}
ÅÅ+ ,
}
ÇÇ 
public
ÑÑ 

class
ÑÑ '
UpdateProfilePhotoRequest
ÑÑ *
{
ÖÖ 
public
ÜÜ 
string
ÜÜ 
?
ÜÜ 
PhotoUrl
ÜÜ 
{
ÜÜ  !
get
ÜÜ" %
;
ÜÜ% &
set
ÜÜ' *
;
ÜÜ* +
}
ÜÜ, -
}
áá 
public
ââ 

class
ââ !
CreateTicketRequest
ââ $
{
ää 
public
ãã 
string
ãã 
Subject
ãã 
{
ãã 
get
ãã  #
;
ãã# $
set
ãã% (
;
ãã( )
}
ãã* +
=
ãã, -
string
ãã. 4
.
ãã4 5
Empty
ãã5 :
;
ãã: ;
public
åå 
string
åå 
Description
åå !
{
åå" #
get
åå$ '
;
åå' (
set
åå) ,
;
åå, -
}
åå. /
=
åå0 1
string
åå2 8
.
åå8 9
Empty
åå9 >
;
åå> ?
public
çç 
string
çç 
Category
çç 
{
çç  
get
çç! $
;
çç$ %
set
çç& )
;
çç) *
}
çç+ ,
=
çç- .
string
çç/ 5
.
çç5 6
Empty
çç6 ;
;
çç; <
public
éé 
string
éé 
Priority
éé 
{
éé  
get
éé! $
;
éé$ %
set
éé& )
;
éé) *
}
éé+ ,
=
éé- .
string
éé/ 5
.
éé5 6
Empty
éé6 ;
;
éé; <
public
èè 
string
èè 
?
èè 
AttachmentUrl
èè $
{
èè% &
get
èè' *
;
èè* +
set
èè, /
;
èè/ 0
}
èè1 2
}
êê 
public
íí 

class
íí "
CustomerReplyRequest
íí %
{
ìì 
public
îî 
string
îî 
Message
îî 
{
îî 
get
îî  #
;
îî# $
set
îî% (
;
îî( )
}
îî* +
=
îî, -
string
îî. 4
.
îî4 5
Empty
îî5 :
;
îî: ;
}
ïï 
public
óó 

class
óó  
UpgradePlanRequest
óó #
{
òò 
[
ôô 	
Required
ôô	 
]
ôô 
public
öö 
int
öö 
SubscriptionId
öö !
{
öö" #
get
öö$ '
;
öö' (
set
öö) ,
;
öö, -
}
öö. /
[
õõ 	
Required
õõ	 
]
õõ 
public
úú 
int
úú 
	NewPlanId
úú 
{
úú 
get
úú "
;
úú" #
set
úú$ '
;
úú' (
}
úú) *
}
ùù 
public
üü 

class
üü (
CreatePaymentIntentRequest
üü +
{
†† 
[
°° 	
Required
°°	 
]
°° 
public
¢¢ 
int
¢¢ 
	InvoiceId
¢¢ 
{
¢¢ 
get
¢¢ "
;
¢¢" #
set
¢¢$ '
;
¢¢' (
}
¢¢) *
}
££ 
public
•• 

class
•• #
ProcessPaymentRequest
•• &
{
¶¶ 
[
ßß 	
Required
ßß	 
]
ßß 
public
®® 
int
®® 
	InvoiceId
®® 
{
®® 
get
®® "
;
®®" #
set
®®$ '
;
®®' (
}
®®) *
public
©© 
string
©© 
PaymentMethod
©© #
{
©©$ %
get
©©& )
;
©©) *
set
©©+ .
;
©©. /
}
©©0 1
=
©©2 3
string
©©4 :
.
©©: ;
Empty
©©; @
;
©©@ A
public
™™ 
string
™™ 
?
™™ 
PaymentIntentId
™™ &
{
™™' (
get
™™) ,
;
™™, -
set
™™. 1
;
™™1 2
}
™™3 4
public
´´ 
string
´´ 
?
´´ 

CardNumber
´´ !
{
´´" #
get
´´$ '
;
´´' (
set
´´) ,
;
´´, -
}
´´. /
[
¨¨ 	
Required
¨¨	 
]
¨¨ 
public
≠≠ 
int
≠≠ 
ExpMonth
≠≠ 
{
≠≠ 
get
≠≠ !
;
≠≠! "
set
≠≠# &
;
≠≠& '
}
≠≠( )
[
ÆÆ 	
Required
ÆÆ	 
]
ÆÆ 
public
ØØ 
int
ØØ 
ExpYear
ØØ 
{
ØØ 
get
ØØ  
;
ØØ  !
set
ØØ" %
;
ØØ% &
}
ØØ' (
public
∞∞ 
string
∞∞ 
?
∞∞ 
Cvc
∞∞ 
{
∞∞ 
get
∞∞  
;
∞∞  !
set
∞∞" %
;
∞∞% &
}
∞∞' (
}
±± 
public
≥≥ 

class
≥≥ &
SavePaymentMethodRequest
≥≥ )
{
¥¥ 
public
µµ 
string
µµ 

CardNumber
µµ  
{
µµ! "
get
µµ# &
;
µµ& '
set
µµ( +
;
µµ+ ,
}
µµ- .
=
µµ/ 0
string
µµ1 7
.
µµ7 8
Empty
µµ8 =
;
µµ= >
[
∂∂ 	
Required
∂∂	 
]
∂∂ 
public
∑∑ 
int
∑∑ 
ExpMonth
∑∑ 
{
∑∑ 
get
∑∑ !
;
∑∑! "
set
∑∑# &
;
∑∑& '
}
∑∑( )
[
∏∏ 	
Required
∏∏	 
]
∏∏ 
public
ππ 
int
ππ 
ExpYear
ππ 
{
ππ 
get
ππ  
;
ππ  !
set
ππ" %
;
ππ% &
}
ππ' (
public
∫∫ 
string
∫∫ 
Cvc
∫∫ 
{
∫∫ 
get
∫∫ 
;
∫∫  
set
∫∫! $
;
∫∫$ %
}
∫∫& '
=
∫∫( )
string
∫∫* 0
.
∫∫0 1
Empty
∫∫1 6
;
∫∫6 7
[
ªª 	
Required
ªª	 
]
ªª 
public
ºº 
bool
ºº 
	IsDefault
ºº 
{
ºº 
get
ºº  #
;
ºº# $
set
ºº% (
;
ºº( )
}
ºº* +
}
ΩΩ 
public
øø 

class
øø $
SaveGCashMethodRequest
øø '
{
¿¿ 
public
¡¡ 
string
¡¡ 
PhoneNumber
¡¡ !
{
¡¡" #
get
¡¡$ '
;
¡¡' (
set
¡¡) ,
;
¡¡, -
}
¡¡. /
=
¡¡0 1
string
¡¡2 8
.
¡¡8 9
Empty
¡¡9 >
;
¡¡> ?
[
¬¬ 	
Required
¬¬	 
]
¬¬ 
public
√√ 
bool
√√ 
	IsDefault
√√ 
{
√√ 
get
√√  #
;
√√# $
set
√√% (
;
√√( )
}
√√* +
}
ƒƒ 
public
∆∆ 

class
∆∆ '
ConfirmGCashMethodRequest
∆∆ *
{
«« 
public
»» 
string
»» 
PhoneNumber
»» !
{
»»" #
get
»»$ '
;
»»' (
set
»») ,
;
»», -
}
»». /
=
»»0 1
string
»»2 8
.
»»8 9
Empty
»»9 >
;
»»> ?
[
…… 	
Required
……	 
]
…… 
public
   
bool
   
	IsDefault
   
{
   
get
    #
;
  # $
set
  % (
;
  ( )
}
  * +
}
ÀÀ 
public
ÕÕ 

class
ÕÕ 
AddAddonRequest
ÕÕ  
{
ŒŒ 
[
œœ 	
Required
œœ	 
]
œœ 
public
–– 
int
–– 
AddonId
–– 
{
–– 
get
––  
;
––  !
set
––" %
;
––% &
}
––' (
}
—— 
public
”” 

class
”” 
UpdateNameRequest
”” "
{
‘‘ 
public
’’ 
string
’’ 

DeviceName
’’  
{
’’! "
get
’’# &
;
’’& '
set
’’( +
;
’’+ ,
}
’’- .
=
’’/ 0
string
’’1 7
.
’’7 8
Empty
’’8 =
;
’’= >
}
÷÷ 
public
ÿÿ 

class
ÿÿ #
ChangePasswordRequest
ÿÿ &
{
ŸŸ 
public
⁄⁄ 
string
⁄⁄ 
CurrentPassword
⁄⁄ %
{
⁄⁄& '
get
⁄⁄( +
;
⁄⁄+ ,
set
⁄⁄- 0
;
⁄⁄0 1
}
⁄⁄2 3
=
⁄⁄4 5
string
⁄⁄6 <
.
⁄⁄< =
Empty
⁄⁄= B
;
⁄⁄B C
public
€€ 
string
€€ 
NewPassword
€€ !
{
€€" #
get
€€$ '
;
€€' (
set
€€) ,
;
€€, -
}
€€. /
=
€€0 1
string
€€2 8
.
€€8 9
Empty
€€9 >
;
€€> ?
}
‹‹ 
public
ﬁﬁ 

class
ﬁﬁ 
VerifyCodeRequest
ﬁﬁ "
{
ﬂﬂ 
public
‡‡ 
string
‡‡ 
Code
‡‡ 
{
‡‡ 
get
‡‡  
;
‡‡  !
set
‡‡" %
;
‡‡% &
}
‡‡' (
=
‡‡) *
string
‡‡+ 1
.
‡‡1 2
Empty
‡‡2 7
;
‡‡7 8
}
·· 
public
„„ 

class
„„ 
SetPinRequest
„„ 
{
‰‰ 
public
ÂÂ 
string
ÂÂ 
Pin
ÂÂ 
{
ÂÂ 
get
ÂÂ 
;
ÂÂ  
set
ÂÂ! $
;
ÂÂ$ %
}
ÂÂ& '
=
ÂÂ( )
string
ÂÂ* 0
.
ÂÂ0 1
Empty
ÂÂ1 6
;
ÂÂ6 7
}
ÊÊ 
public
ËË 

class
ËË 
VerifyPinRequest
ËË !
{
ÈÈ 
public
ÍÍ 
string
ÍÍ 
Pin
ÍÍ 
{
ÍÍ 
get
ÍÍ 
;
ÍÍ  
set
ÍÍ! $
;
ÍÍ$ %
}
ÍÍ& '
=
ÍÍ( )
string
ÍÍ* 0
.
ÍÍ0 1
Empty
ÍÍ1 6
;
ÍÍ6 7
}
ÎÎ 
public
ÌÌ 

class
ÌÌ 
TopUpRequest
ÌÌ 
{
ÓÓ 
[
ÔÔ 	
Required
ÔÔ	 
]
ÔÔ 
public
 
decimal
 
Amount
 
{
 
get
  #
;
# $
set
% (
;
( )
}
* +
}
ÒÒ 
public
ÛÛ 

class
ÛÛ 
BuyPromoRequest
ÛÛ  
{
ÙÙ 
[
ıı 	
Required
ıı	 
]
ıı 
public
ˆˆ 
decimal
ˆˆ 
Amount
ˆˆ 
{
ˆˆ 
get
ˆˆ  #
;
ˆˆ# $
set
ˆˆ% (
;
ˆˆ( )
}
ˆˆ* +
public
˜˜ 
string
˜˜ 
?
˜˜ 

PromoTitle
˜˜ !
{
˜˜" #
get
˜˜$ '
;
˜˜' (
set
˜˜) ,
;
˜˜, -
}
˜˜. /
public
¯¯ 
string
¯¯ 
?
¯¯ 
	PromoData
¯¯  
{
¯¯! "
get
¯¯# &
;
¯¯& '
set
¯¯( +
;
¯¯+ ,
}
¯¯- .
public
˘˘ 
string
˘˘ 
?
˘˘ 
PromoValidity
˘˘ $
{
˘˘% &
get
˘˘' *
;
˘˘* +
set
˘˘, /
;
˘˘/ 0
}
˘˘1 2
}
˙˙ 
}˚˚ Ÿû
UE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\AuthController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
EnableRateLimiting 
( 
$str 
) 
]  
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public 

class 
AuthController 
:  !
ControllerBase" 0
{ 
private 
const 
string 
StatusActive )
=* +
$str, 4
;4 5
private 
const 
string 
StatusPending *
=+ ,
$str- 6
;6 7
private 
const 
string 
StatusInactive +
=, -
$str. 8
;8 9
private 
const 
string 
StatusSuspended ,
=- .
$str/ :
;: ;
private 
const 
string 
ServicePrepaid +
=, -
$str. 7
;7 8
private 
const 
string 
ServiceSubscription 0
=1 2
$str3 A
;A B
private 
const 
string 
DeviceTypeWifi +
=, -
$str. 4
;4 5
private 
const 
string 
	RoleStaff &
=' (
$str) 0
;0 1
private 
const 
string 
	RoleAdmin &
=' (
$str) 0
;0 1
private 
const 
string 
RoleSuperAdmin +
=, -
$str. :
;: ;
private 
const 
string 
MessageUserNotFound 0
=1 2
$str3 C
;C D
private   
const   
string   
DeviceUnknown   *
=  + ,
$str  - =
;  = >
private!! 
readonly!! 
UserManager!! $
<!!$ %
ApplicationUser!!% 4
>!!4 5
_userManager!!6 B
;!!B C
private"" 
readonly"" 
TokenService"" %
_tokenService""& 3
;""3 4
private## 
readonly## 
EmailService## %
_emailService##& 3
;##3 4
private$$ 
readonly$$  
ApplicationDbContext$$ -
_context$$. 6
;$$6 7
private%% 
readonly%% 
IConfiguration%% '
_configuration%%( 6
;%%6 7
private&& 
readonly&& 
IHttpClientFactory&& +
_httpClientFactory&&, >
;&&> ?
private'' 
readonly'' 
LoginAttemptService'' , 
_loginAttemptService''- A
;''A B
private(( 
readonly(( %
IpDeviceReputationService(( 2&
_ipDeviceReputationService((3 M
;((M N
private)) 
readonly)) !
PasswordBreachService)) ."
_passwordBreachService))/ E
;))E F
public++ 
AuthController++ 
(++ 
UserManager,, 
<,, 
ApplicationUser,, '
>,,' (
userManager,,) 4
,,,4 5
TokenService-- 
tokenService-- %
,--% &
EmailService.. 
emailService.. %
,..% & 
ApplicationDbContext//  
context//! (
,//( )
IConfiguration00 
configuration00 (
,00( )
IHttpClientFactory11 
httpClientFactory11 0
,110 1
LoginAttemptService22 
loginAttemptService22  3
,223 4%
IpDeviceReputationService33 %%
ipDeviceReputationService33& ?
,33? @!
PasswordBreachService44 !!
passwordBreachService44" 7
)447 8
{55 	
_userManager66 
=66 
userManager66 &
;66& '
_tokenService77 
=77 
tokenService77 (
;77( )
_emailService88 
=88 
emailService88 (
;88( )
_context99 
=99 
context99 
;99 
_configuration:: 
=:: 
configuration:: *
;::* +
_httpClientFactory;; 
=;;  
httpClientFactory;;! 2
;;;2 3 
_loginAttemptService<<  
=<<! "
loginAttemptService<<# 6
;<<6 7&
_ipDeviceReputationService== &
===' (%
ipDeviceReputationService==) B
;==B C"
_passwordBreachService>> "
=>># $!
passwordBreachService>>% :
;>>: ;
}?? 	
[AA 	
HttpPostAA	 
(AA 
$strAA 
)AA 
]AA 
publicBB 
asyncBB 
TaskBB 
<BB 
IActionResultBB '
>BB' (
RegisterBB) 1
(BB1 2
[BB2 3
FromBodyBB3 ;
]BB; <
RegisterRequestBB= L
requestBBM T
,BBT U
[BBV W

FromHeaderBBW a
(BBa b
NameBBb f
=BBg h
$strBBi u
)BBu v
]BBv w
stringBBx ~
?BB~ 
	userAgent
BBÄ â
)
BBâ ä
{CC 	
tryDD 
{EE 
varFF 
userAgentValueFF "
=FF# $
	userAgentFF% .
??FF/ 1
stringFF2 8
.FF8 9
EmptyFF9 >
;FF> ?
varGG 
	ipAddressGG 
=GG 
HttpContextGG  +
.GG+ ,

ConnectionGG, 6
.GG6 7
RemoteIpAddressGG7 F
?GGF G
.GGG H
ToStringGGH P
(GGP Q
)GGQ R
;GGR S
ifHH 
(HH &
_ipDeviceReputationServiceHH .
.HH. /
	IsBlockedHH/ 8
(HH8 9
	ipAddressHH9 B
,HHB C
userAgentValueHHD R
,HHR S
outHHT W
varHHX [
blockReasonHH\ g
)HHg h
)HHh i
returnII 

StatusCodeII %
(II% &
$numII& )
,II) *
newII+ .
{II/ 0
messageII1 8
=II9 :
$"II; =
$strII= M
{IIM N
blockReasonIIN Y
}IIY Z
$strIIZ s
"IIs t
}IIu v
)IIv w
;IIw x
ifKK 
(KK 
!KK 
awaitKK  
VerifyReCaptchaAsyncKK /
(KK/ 0
requestKK0 7
.KK7 8
CaptchaTokenKK8 D
)KKD E
)KKE F
returnLL 

BadRequestLL %
(LL% &
newLL& )
{LL* +
messageLL, 3
=LL4 5
$strLL6 S
}LLT U
)LLU V
;LLV W
ifNN 
(NN 
!NN 
requestNN 
.NN 
EmailNN "
.NN" #
EndsWithNN# +
(NN+ ,
$strNN, 8
,NN8 9
StringComparisonNN: J
.NNJ K
OrdinalIgnoreCaseNNK \
)NN\ ]
)NN] ^
returnOO 

BadRequestOO %
(OO% &
newOO& )
{OO* +
messageOO, 3
=OO4 5
$strOO6 X
}OOY Z
)OOZ [
;OO[ \
ifQQ 
(QQ 
awaitQQ "
_passwordBreachServiceQQ 0
.QQ0 1
IsBreachedAsyncQQ1 @
(QQ@ A
requestQQA H
.QQH I
PasswordQQI Q
)QQQ R
)QQR S
returnRR 

BadRequestRR %
(RR% &
newRR& )
{RR* +
messageRR, 3
=RR4 5
$str	RR6 Ä
}
RRÅ Ç
)
RRÇ É
;
RRÉ Ñ
varTT 
existingUserTT  
=TT! "
awaitTT# (
_userManagerTT) 5
.TT5 6
FindByEmailAsyncTT6 F
(TTF G
requestTTG N
.TTN O
EmailTTO T
)TTT U
;TTU V
ifUU 
(UU 
existingUserUU  
!=UU! #
nullUU$ (
)UU( )
returnVV 

BadRequestVV %
(VV% &
newVV& )
{VV* +
messageVV, 3
=VV4 5
$strVV6 s
}VVt u
)VVu v
;VVv w
varXX 
userXX 
=XX 
newXX 
ApplicationUserXX .
{YY 
UserNameZZ 
=ZZ 
requestZZ &
.ZZ& '
EmailZZ' ,
,ZZ, -
Email[[ 
=[[ 
request[[ #
.[[# $
Email[[$ )
,[[) *
	FirstName\\ 
=\\ 
request\\  '
.\\' (
	FirstName\\( 1
,\\1 2
LastName]] 
=]] 
request]] &
.]]& '
LastName]]' /
,]]/ 0
Birthday^^ 
=^^ 
request^^ &
.^^& '
Birthday^^' /
,^^/ 0
Address__ 
=__ 
request__ %
.__% &
Address__& -
,__- .
Status`` 
=`` 
StatusPending`` *
}aa 
;aa 
varbb 
resultbb 
=bb 
awaitbb "
_userManagerbb# /
.bb/ 0
CreateAsyncbb0 ;
(bb; <
userbb< @
,bb@ A
requestbbB I
.bbI J
PasswordbbJ R
)bbR S
;bbS T
ifdd 
(dd 
!dd 
resultdd 
.dd 
	Succeededdd %
)dd% &
{ee 
varff 
errorsff 
=ff  
stringff! '
.ff' (
Joinff( ,
(ff, -
$strff- 1
,ff1 2
resultff3 9
.ff9 :
Errorsff: @
.ff@ A
SelectffA G
(ffG H
effH I
=>ffJ L
effM N
.ffN O
DescriptionffO Z
)ffZ [
)ff[ \
;ff\ ]
returngg 

BadRequestgg %
(gg% &
newgg& )
{gg* +
messagegg, 3
=gg4 5
errorsgg6 <
}gg= >
)gg> ?
;gg? @
}hh 
varjj 
codejj 
=jj 
newjj 
Randomjj %
(jj% &
)jj& '
.jj' (
Nextjj( ,
(jj, -
$numjj- 3
,jj3 4
$numjj5 ;
)jj; <
.jj< =
ToStringjj= E
(jjE F
)jjF G
;jjG H
_contextkk 
.kk 
VerificationCodeskk *
.kk* +
Addkk+ .
(kk. /
newkk/ 2
VerificationCodekk3 C
{ll 
Emailmm 
=mm 
requestmm #
.mm# $
Emailmm$ )
,mm) *
Codenn 
=nn 
codenn 
,nn  
	ExpiresAtoo 
=oo 
DateTimeoo  (
.oo( )
UtcNowoo) /
.oo/ 0

AddMinutesoo0 :
(oo: ;
$numoo; =
)oo= >
}pp 
)pp 
;pp 
_contextrr 
.rr 
OnboardingStatusesrr +
.rr+ ,
Addrr, /
(rr/ 0
newrr0 3
OnboardingStatusrr4 D
{ss 
UserIDtt 
=tt 
usertt !
.tt! "
Idtt" $
}uu 
)uu 
;uu 
awaitww 
_contextww 
.ww 
SaveChangesAsyncww /
(ww/ 0
)ww0 1
;ww1 2
awaitxx 
_emailServicexx #
.xx# $%
SendVerificationCodeAsyncxx$ =
(xx= >
requestxx> E
.xxE F
EmailxxF K
,xxK L
codexxM Q
)xxQ R
;xxR S
awaitzz 
LogActivityAsynczz &
(zz& '
userzz' +
.zz+ ,
Idzz, .
,zz. /
$strzz0 D
,zzD E
$strzzF N
)zzN O
;zzO P&
_ipDeviceReputationService|| *
.||* +
RegisterSuccess||+ :
(||: ;
	ipAddress||; D
,||D E
userAgentValue||F T
)||T U
;||U V
return~~ 
Ok~~ 
(~~ 
new~~ 
{~~ 
message~~  '
=~~( )
$str~~* s
}~~t u
)~~u v
;~~v w
} 
catch
ÄÄ 
(
ÄÄ 
	Exception
ÄÄ 
ex
ÄÄ 
)
ÄÄ  
{
ÅÅ 
return
ÇÇ 

BadRequest
ÇÇ !
(
ÇÇ! "
new
ÇÇ" %
{
ÇÇ& '
message
ÇÇ( /
=
ÇÇ0 1
$"
ÇÇ2 4
$str
ÇÇ4 I
{
ÇÇI J
ex
ÇÇJ L
.
ÇÇL M
Message
ÇÇM T
}
ÇÇT U
"
ÇÇU V
}
ÇÇW X
)
ÇÇX Y
;
ÇÇY Z
}
ÉÉ 
}
ÑÑ 	
[
ÜÜ 	
HttpPost
ÜÜ	 
(
ÜÜ 
$str
ÜÜ  
)
ÜÜ  !
]
ÜÜ! "
public
áá 
async
áá 
Task
áá 
<
áá 
IActionResult
áá '
>
áá' (
VerifyEmail
áá) 4
(
áá4 5
[
áá5 6
FromBody
áá6 >
]
áá> ? 
VerifyEmailRequest
áá@ R
request
ááS Z
)
ááZ [
{
àà 	
var
ââ 
verification
ââ 
=
ââ 
await
ââ $
_context
ââ% -
.
ââ- .
VerificationCodes
ââ. ?
.
ää !
FirstOrDefaultAsync
ää $
(
ää$ %
v
ää% &
=>
ää' )
v
ää* +
.
ää+ ,
Email
ää, 1
==
ää2 4
request
ää5 <
.
ää< =
Email
ää= B
&&
ääC E
v
ääF G
.
ääG H
Code
ääH L
==
ääM O
request
ääP W
.
ääW X
Code
ääX \
&&
ää] _
!
ää` a
v
ääa b
.
ääb c
IsUsed
ääc i
&&
ääj l
v
ääm n
.
ään o
	ExpiresAt
ääo x
>
ääy z
DateTimeää{ É
.ääÉ Ñ
UtcNowääÑ ä
)äää ã
;ääã å
if
åå 
(
åå 
verification
åå 
==
åå 
null
åå  $
)
åå$ %
return
çç 

BadRequest
çç !
(
çç! "
new
çç" %
{
çç& '
message
çç( /
=
çç0 1
$str
çç2 X
}
ççY Z
)
ççZ [
;
çç[ \
var
èè 
user
èè 
=
èè 
await
èè 
_userManager
èè )
.
èè) *
FindByEmailAsync
èè* :
(
èè: ;
request
èè; B
.
èèB C
Email
èèC H
)
èèH I
;
èèI J
if
êê 
(
êê 
user
êê 
==
êê 
null
êê 
)
êê 
return
ëë 
NotFound
ëë 
(
ëë  
new
ëë  #
{
ëë$ %
message
ëë& -
=
ëë. /!
MessageUserNotFound
ëë0 C
}
ëëD E
)
ëëE F
;
ëëF G
user
ìì 
.
ìì 
EmailConfirmed
ìì 
=
ìì  !
true
ìì" &
;
ìì& '
user
îî 
.
îî 
Status
îî 
=
îî 
StatusActive
îî &
;
îî& '
await
ïï 
_userManager
ïï 
.
ïï 
UpdateAsync
ïï *
(
ïï* +
user
ïï+ /
)
ïï/ 0
;
ïï0 1
verification
óó 
.
óó 
IsUsed
óó 
=
óó  !
true
óó" &
;
óó& '
var
ôô 

onboarding
ôô 
=
ôô 
await
ôô "
_context
ôô# +
.
ôô+ , 
OnboardingStatuses
ôô, >
.
ôô> ?!
FirstOrDefaultAsync
ôô? R
(
ôôR S
o
ôôS T
=>
ôôU W
o
ôôX Y
.
ôôY Z
UserID
ôôZ `
==
ôôa c
user
ôôd h
.
ôôh i
Id
ôôi k
)
ôôk l
;
ôôl m
if
öö 
(
öö 

onboarding
öö 
!=
öö 
null
öö "
)
öö" #

onboarding
õõ 
.
õõ 
IsEmailVerified
õõ *
=
õõ+ ,
true
õõ- 1
;
õõ1 2
await
ùù 
_context
ùù 
.
ùù 
SaveChangesAsync
ùù +
(
ùù+ ,
)
ùù, -
;
ùù- .
return
üü 
Ok
üü 
(
üü 
new
üü 
{
üü 
message
üü #
=
üü$ %
$str
üü& C
}
üüD E
)
üüE F
;
üüF G
}
†† 	
[
¢¢ 	
HttpPost
¢¢	 
(
¢¢ 
$str
¢¢ 
)
¢¢  
]
¢¢  !
public
££ 
async
££ 
Task
££ 
<
££ 
IActionResult
££ '
>
££' (

ResendCode
££) 3
(
££3 4
[
££4 5
FromBody
££5 =
]
££= >
string
££? E
email
££F K
)
££K L
{
§§ 	
var
•• 
code
•• 
=
•• 
new
•• 
Random
•• !
(
••! "
)
••" #
.
••# $
Next
••$ (
(
••( )
$num
••) /
,
••/ 0
$num
••1 7
)
••7 8
.
••8 9
ToString
••9 A
(
••A B
)
••B C
;
••C D
_context
¶¶ 
.
¶¶ 
VerificationCodes
¶¶ &
.
¶¶& '
Add
¶¶' *
(
¶¶* +
new
¶¶+ .
VerificationCode
¶¶/ ?
{
ßß 
Email
®® 
=
®® 
email
®® 
,
®® 
Code
©© 
=
©© 
code
©© 
,
©© 
	ExpiresAt
™™ 
=
™™ 
DateTime
™™ $
.
™™$ %
UtcNow
™™% +
.
™™+ ,

AddMinutes
™™, 6
(
™™6 7
$num
™™7 9
)
™™9 :
}
´´ 
)
´´ 
;
´´ 
await
¨¨ 
_context
¨¨ 
.
¨¨ 
SaveChangesAsync
¨¨ +
(
¨¨+ ,
)
¨¨, -
;
¨¨- .
await
≠≠ 
_emailService
≠≠ 
.
≠≠  '
SendVerificationCodeAsync
≠≠  9
(
≠≠9 :
email
≠≠: ?
,
≠≠? @
code
≠≠A E
)
≠≠E F
;
≠≠F G
return
ØØ 
Ok
ØØ 
(
ØØ 
new
ØØ 
{
ØØ 
message
ØØ #
=
ØØ$ %
$str
ØØ& >
}
ØØ? @
)
ØØ@ A
;
ØØA B
}
∞∞ 	
[
≤≤ 	
HttpPost
≤≤	 
(
≤≤ 
$str
≤≤ 
)
≤≤ 
]
≤≤ 
public
≥≥ 
async
≥≥ 
Task
≥≥ 
<
≥≥ 
IActionResult
≥≥ '
>
≥≥' (
Login
≥≥) .
(
≥≥. /
[
≥≥/ 0
FromBody
≥≥0 8
]
≥≥8 9
LoginRequest
≥≥: F
request
≥≥G N
,
≥≥N O
[
≥≥P Q

FromHeader
≥≥Q [
(
≥≥[ \
Name
≥≥\ `
=
≥≥a b
$str
≥≥c o
)
≥≥o p
]
≥≥p q
string
≥≥r x
?
≥≥x y
	userAgent≥≥z É
)≥≥É Ñ
{
¥¥ 	
var
µµ 
userAgentValue
µµ 
=
µµ  
	userAgent
µµ! *
??
µµ+ -
string
µµ. 4
.
µµ4 5
Empty
µµ5 :
;
µµ: ;
var
∂∂ 
	ipAddress
∂∂ 
=
∂∂ 
HttpContext
∂∂ '
.
∂∂' (

Connection
∂∂( 2
.
∂∂2 3
RemoteIpAddress
∂∂3 B
?
∂∂B C
.
∂∂C D
ToString
∂∂D L
(
∂∂L M
)
∂∂M N
;
∂∂N O
if
∑∑ 
(
∑∑ (
_ipDeviceReputationService
∑∑ *
.
∑∑* +
	IsBlocked
∑∑+ 4
(
∑∑4 5
	ipAddress
∑∑5 >
,
∑∑> ?
userAgentValue
∑∑@ N
,
∑∑N O
out
∑∑P S
var
∑∑T W
blockReason
∑∑X c
)
∑∑c d
)
∑∑d e
return
∏∏ 

StatusCode
∏∏ !
(
∏∏! "
$num
∏∏" %
,
∏∏% &
new
∏∏' *
{
∏∏+ ,
message
∏∏- 4
=
∏∏5 6
$"
∏∏7 9
$str
∏∏9 I
{
∏∏I J
blockReason
∏∏J U
}
∏∏U V
$str
∏∏V o
"
∏∏o p
}
∏∏q r
)
∏∏r s
;
∏∏s t
if
∫∫ 
(
∫∫ 
!
∫∫ 
await
∫∫ "
VerifyReCaptchaAsync
∫∫ +
(
∫∫+ ,
request
∫∫, 3
.
∫∫3 4
CaptchaToken
∫∫4 @
)
∫∫@ A
)
∫∫A B
return
ªª 

BadRequest
ªª !
(
ªª! "
new
ªª" %
{
ªª& '
message
ªª( /
=
ªª0 1
$str
ªª2 O
}
ªªP Q
)
ªªQ R
;
ªªR S
var
ΩΩ 
user
ΩΩ 
=
ΩΩ 
await
ΩΩ 
_userManager
ΩΩ )
.
ΩΩ) *
FindByEmailAsync
ΩΩ* :
(
ΩΩ: ;
request
ΩΩ; B
.
ΩΩB C
Email
ΩΩC H
)
ΩΩH I
;
ΩΩI J
if
ææ 
(
ææ 
user
ææ 
==
ææ 
null
ææ 
)
ææ 
{
øø (
_ipDeviceReputationService
¿¿ *
.
¿¿* +
RegisterFailure
¿¿+ :
(
¿¿: ;
	ipAddress
¿¿; D
,
¿¿D E
userAgentValue
¿¿F T
)
¿¿T U
;
¿¿U V
return
¡¡ 
Unauthorized
¡¡ #
(
¡¡# $
new
¡¡$ '
{
¡¡( )
message
¡¡* 1
=
¡¡2 3
$str
¡¡4 I
}
¡¡J K
)
¡¡K L
;
¡¡L M
}
¬¬ 
var
≈≈ 
lockoutCheck
≈≈ 
=
≈≈ 
await
≈≈ $"
_loginAttemptService
≈≈% 9
.
≈≈9 :$
CheckLoginAttemptAsync
≈≈: P
(
≈≈P Q
user
≈≈Q U
.
≈≈U V
Id
≈≈V X
)
≈≈X Y
;
≈≈Y Z
if
∆∆ 
(
∆∆ 
lockoutCheck
∆∆ 
.
∆∆ 
isLocked
∆∆ %
)
∆∆% &
return
«« 
Unauthorized
«« #
(
««# $
new
««$ '
{
««( )
message
««* 1
=
««2 3
$"
««4 6
$str
««6 y
{
««y z
lockoutCheck««z Ü
.««Ü á
message««á é
}««é è
"««è ê
}««ë í
)««í ì
;««ì î
if
…… 
(
…… 
!
…… 
await
…… 
_userManager
…… #
.
……# $ 
CheckPasswordAsync
……$ 6
(
……6 7
user
……7 ;
,
……; <
request
……= D
.
……D E
Password
……E M
)
……M N
)
……N O
{
   
await
ÃÃ "
_loginAttemptService
ÃÃ *
.
ÃÃ* +&
RecordFailedAttemptAsync
ÃÃ+ C
(
ÃÃC D
user
ÃÃD H
.
ÃÃH I
Id
ÃÃI K
)
ÃÃK L
;
ÃÃL M(
_ipDeviceReputationService
ÕÕ *
.
ÕÕ* +
RegisterFailure
ÕÕ+ :
(
ÕÕ: ;
	ipAddress
ÕÕ; D
,
ÕÕD E
userAgentValue
ÕÕF T
)
ÕÕT U
;
ÕÕU V
return
ŒŒ 
Unauthorized
ŒŒ #
(
ŒŒ# $
new
ŒŒ$ '
{
ŒŒ( )
message
ŒŒ* 1
=
ŒŒ2 3
$str
ŒŒ4 I
}
ŒŒJ K
)
ŒŒK L
;
ŒŒL M
}
œœ 
if
—— 
(
—— 
!
—— 
user
—— 
.
—— 
EmailConfirmed
—— $
)
——$ %
{
““ 
var
‘‘ 
code
‘‘ 
=
‘‘ 
new
‘‘ 
Random
‘‘ %
(
‘‘% &
)
‘‘& '
.
‘‘' (
Next
‘‘( ,
(
‘‘, -
$num
‘‘- 3
,
‘‘3 4
$num
‘‘5 ;
)
‘‘; <
.
‘‘< =
ToString
‘‘= E
(
‘‘E F
)
‘‘F G
;
‘‘G H
_context
’’ 
.
’’ 
VerificationCodes
’’ *
.
’’* +
Add
’’+ .
(
’’. /
new
’’/ 2
VerificationCode
’’3 C
{
÷÷ 
Email
◊◊ 
=
◊◊ 
request
◊◊ #
.
◊◊# $
Email
◊◊$ )
,
◊◊) *
Code
ÿÿ 
=
ÿÿ 
code
ÿÿ 
,
ÿÿ  
	ExpiresAt
ŸŸ 
=
ŸŸ 
DateTime
ŸŸ  (
.
ŸŸ( )
UtcNow
ŸŸ) /
.
ŸŸ/ 0

AddMinutes
ŸŸ0 :
(
ŸŸ: ;
$num
ŸŸ; =
)
ŸŸ= >
}
⁄⁄ 
)
⁄⁄ 
;
⁄⁄ 
await
€€ 
_context
€€ 
.
€€ 
SaveChangesAsync
€€ /
(
€€/ 0
)
€€0 1
;
€€1 2
await
‹‹ 
_emailService
‹‹ #
.
‹‹# $'
SendVerificationCodeAsync
‹‹$ =
(
‹‹= >
request
‹‹> E
.
‹‹E F
Email
‹‹F K
,
‹‹K L
code
‹‹M Q
)
‹‹Q R
;
‹‹R S
return
ﬁﬁ 
Ok
ﬁﬁ 
(
ﬁﬁ 
new
ﬁﬁ 
{
ﬁﬁ '
requiresEmailVerification
ﬂﬂ -
=
ﬂﬂ. /
true
ﬂﬂ0 4
,
ﬂﬂ4 5
email
‡‡ 
=
‡‡ 
request
‡‡ #
.
‡‡# $
Email
‡‡$ )
,
‡‡) *
message
·· 
=
·· 
$str
·· f
}
‚‚ 
)
‚‚ 
;
‚‚ 
}
„„ 
if
ÂÂ 
(
ÂÂ 
user
ÂÂ 
.
ÂÂ 
Status
ÂÂ 
==
ÂÂ 
StatusSuspended
ÂÂ .
)
ÂÂ. /
return
ÊÊ 
Unauthorized
ÊÊ #
(
ÊÊ# $
new
ÊÊ$ '
{
ÊÊ( )
message
ÊÊ* 1
=
ÊÊ2 3
$str
ÊÊ4 n
}
ÊÊo p
)
ÊÊp q
;
ÊÊq r
var
ËË 
roles
ËË 
=
ËË 
await
ËË 
_userManager
ËË *
.
ËË* +
GetRolesAsync
ËË+ 8
(
ËË8 9
user
ËË9 =
)
ËË= >
;
ËË> ?
var
ÈÈ 
role
ÈÈ 
=
ÈÈ 
roles
ÈÈ 
.
ÈÈ 
FirstOrDefault
ÈÈ +
(
ÈÈ+ ,
)
ÈÈ, -
??
ÈÈ. 0
user
ÈÈ1 5
.
ÈÈ5 6
Role
ÈÈ6 :
;
ÈÈ: ;
if
ÎÎ 
(
ÎÎ 
(
ÎÎ 
role
ÎÎ 
==
ÎÎ 
	RoleStaff
ÎÎ "
||
ÎÎ# %
role
ÎÎ& *
==
ÎÎ+ -
	RoleAdmin
ÎÎ. 7
||
ÎÎ8 :
role
ÎÎ; ?
==
ÎÎ@ B
RoleSuperAdmin
ÎÎC Q
)
ÎÎQ R
&&
ÎÎS U
user
ÎÎV Z
.
ÎÎZ [
Status
ÎÎ[ a
==
ÎÎb d
StatusInactive
ÎÎe s
)
ÎÎs t
return
ÏÏ 
Unauthorized
ÏÏ #
(
ÏÏ# $
new
ÏÏ$ '
{
ÏÏ( )
message
ÏÏ* 1
=
ÏÏ2 3
$str
ÏÏ4 m
}
ÏÏn o
)
ÏÏo p
;
ÏÏp q
var
ÓÓ 
dbUser
ÓÓ 
=
ÓÓ 
await
ÓÓ 
_context
ÓÓ '
.
ÓÓ' (
Users
ÓÓ( -
.
ÓÓ- .
AsNoTracking
ÓÓ. :
(
ÓÓ: ;
)
ÓÓ; <
.
ÓÓ< =!
FirstOrDefaultAsync
ÓÓ= P
(
ÓÓP Q
u
ÓÓQ R
=>
ÓÓS U
u
ÓÓV W
.
ÓÓW X
Id
ÓÓX Z
==
ÓÓ[ ]
user
ÓÓ^ b
.
ÓÓb c
Id
ÓÓc e
)
ÓÓe f
;
ÓÓf g
if
 
(
 
dbUser
 
?
 
.
 
TwoFactorEnabled
 (
==
) +
true
, 0
)
0 1
{
ÒÒ 
var
ÚÚ 
code
ÚÚ 
=
ÚÚ 
new
ÚÚ 
Random
ÚÚ %
(
ÚÚ% &
)
ÚÚ& '
.
ÚÚ' (
Next
ÚÚ( ,
(
ÚÚ, -
$num
ÚÚ- 3
,
ÚÚ3 4
$num
ÚÚ5 ;
)
ÚÚ; <
.
ÚÚ< =
ToString
ÚÚ= E
(
ÚÚE F
)
ÚÚF G
;
ÚÚG H
_context
ÛÛ 
.
ÛÛ 
VerificationCodes
ÛÛ *
.
ÛÛ* +
Add
ÛÛ+ .
(
ÛÛ. /
new
ÛÛ/ 2
VerificationCode
ÛÛ3 C
{
ÙÙ 
Email
ıı 
=
ıı 
user
ıı  
.
ıı  !
Email
ıı! &
!
ıı& '
,
ıı' (
Code
ˆˆ 
=
ˆˆ 
code
ˆˆ 
,
ˆˆ  
	ExpiresAt
˜˜ 
=
˜˜ 
DateTime
˜˜  (
.
˜˜( )
UtcNow
˜˜) /
.
˜˜/ 0

AddMinutes
˜˜0 :
(
˜˜: ;
$num
˜˜; =
)
˜˜= >
}
¯¯ 
)
¯¯ 
;
¯¯ 
await
˘˘ 
_context
˘˘ 
.
˘˘ 
SaveChangesAsync
˘˘ /
(
˘˘/ 0
)
˘˘0 1
;
˘˘1 2
await
˙˙ 
_emailService
˙˙ #
.
˙˙# $
SendEmailAsync
˙˙$ 2
(
˙˙2 3
user
˙˙3 7
.
˙˙7 8
Email
˙˙8 =
!
˙˙= >
,
˙˙> ?
$str
˙˙@ e
,
˙˙e f
$"
˙˙g i
$str˙˙i ä
{˙˙ä ã
code˙˙ã è
}˙˙è ê
"˙˙ê ë
)˙˙ë í
;˙˙í ì
return
¸¸ 
Ok
¸¸ 
(
¸¸ 
new
¸¸ 
{
¸¸ 
requiresTwoFactor
¸¸  1
=
¸¸2 3
true
¸¸4 8
,
¸¸8 9
email
¸¸: ?
=
¸¸@ A
user
¸¸B F
.
¸¸F G
Email
¸¸G L
,
¸¸L M
message
¸¸N U
=
¸¸V W
$str
¸¸X ~
}¸¸ Ä
)¸¸Ä Å
;¸¸Å Ç
}
˝˝ 
var
ˇˇ 
device
ˇˇ 
=
ˇˇ $
GetDeviceFromUserAgent
ˇˇ /
(
ˇˇ/ 0
userAgentValue
ˇˇ0 >
)
ˇˇ> ?
;
ˇˇ? @
var
ÄÄ 
location
ÄÄ 
=
ÄÄ 
$str
ÄÄ (
;
ÄÄ( )
_context
ÇÇ 
.
ÇÇ 
LoginHistory
ÇÇ !
.
ÇÇ! "
Add
ÇÇ" %
(
ÇÇ% &
new
ÇÇ& )
LoginHistory
ÇÇ* 6
{
ÉÉ 
UserID
ÑÑ 
=
ÑÑ 
user
ÑÑ 
.
ÑÑ 
Id
ÑÑ  
,
ÑÑ  !
Device
ÖÖ 
=
ÖÖ 
device
ÖÖ 
,
ÖÖ  
Location
ÜÜ 
=
ÜÜ 
location
ÜÜ #
,
ÜÜ# $
	IPAddress
áá 
=
áá 
	ipAddress
áá %
,
áá% &
	LoginTime
àà 
=
àà 
DateTime
àà $
.
àà$ %
UtcNow
àà% +
}
ââ 
)
ââ 
;
ââ 
await
ää 
_context
ää 
.
ää 
SaveChangesAsync
ää +
(
ää+ ,
)
ää, -
;
ää- .
var
åå 
isNewDevice
åå 
=
åå 
!
åå 
await
åå $
_context
åå% -
.
åå- .
LoginHistory
åå. :
.
çç 
AnyAsync
çç 
(
çç 
lh
çç 
=>
çç 
lh
çç  "
.
çç" #
UserID
çç# )
==
çç* ,
user
çç- 1
.
çç1 2
Id
çç2 4
&&
çç5 7
lh
çç8 :
.
çç: ;
Device
çç; A
==
ççB D
device
ççE K
&&
ççL N
lh
ççO Q
.
ççQ R
	LoginTime
ççR [
<
çç\ ]
DateTime
çç^ f
.
ççf g
UtcNow
ççg m
.
ççm n

AddMinutes
ççn x
(
ççx y
-
ççy z
$num
ççz {
)
çç{ |
)
çç| }
;
çç} ~
if
èè 
(
èè 
isNewDevice
èè 
)
èè 
{
êê 
var
ëë 
	loginPref
ëë 
=
ëë 
await
ëë  %
_context
ëë& .
.
ëë. /%
NotificationPreferences
ëë/ F
.
íí !
FirstOrDefaultAsync
íí (
(
íí( )
np
íí) +
=>
íí, .
np
íí/ 1
.
íí1 2
UserID
íí2 8
==
íí9 ;
user
íí< @
.
íí@ A
Id
ííA C
&&
ííD F
np
ííG I
.
ííI J
NotificationType
ííJ Z
==
íí[ ]
$str
íí^ i
)
ííi j
;
ííj k
if
ìì 
(
ìì 
	loginPref
ìì 
?
ìì 
.
ìì 
EmailEnabled
ìì +
!=
ìì, .
false
ìì/ 4
)
ìì4 5
{
îî 
await
ïï 
_emailService
ïï '
.
ïï' (
SendEmailAsync
ïï( 6
(
ïï6 7
user
ññ 
.
ññ 
Email
ññ "
!
ññ" #
,
ññ# $
$str
óó ;
,
óó; <
$"
òò 
$str
òò  
{
òò  !
user
òò! %
.
òò% &
	FirstName
òò& /
}
òò/ 0
$stròò0 É
{òòÉ Ñ
deviceòòÑ ä
}òòä ã
$stròòã ™
{òò™ ´
locationòò´ ≥
}òò≥ ¥
$stròò¥ œ
{òòœ –
DateTimeòò– ÿ
.òòÿ Ÿ
UtcNowòòŸ ﬂ
:òòﬂ ‡
$stròò‡ Û
}òòÛ Ù
$stròòÙ ª
"òòª º
)
ôô 
;
ôô 
}
öö 
}
õõ 
await
ûû "
_loginAttemptService
ûû &
.
ûû& ' 
ResetAttemptsAsync
ûû' 9
(
ûû9 :
user
ûû: >
.
ûû> ?
Id
ûû? A
)
ûûA B
;
ûûB C(
_ipDeviceReputationService
üü &
.
üü& '
RegisterSuccess
üü' 6
(
üü6 7
	ipAddress
üü7 @
,
üü@ A
userAgentValue
üüB P
)
üüP Q
;
üüQ R
var
°° 
token
°° 
=
°° 
await
°° 
_tokenService
°° +
.
°°+ , 
GenerateTokenAsync
°°, >
(
°°> ?
user
°°? C
.
°°C D
Email
°°D I
!
°°I J
,
°°J K
user
°°L P
.
°°P Q
Id
°°Q S
,
°°S T
role
°°U Y
)
°°Y Z
;
°°Z [
var
££ 
settings
££ 
=
££ 
await
££  
_context
££! )
.
££) *
SystemSettings
££* 8
.
££8 9!
FirstOrDefaultAsync
££9 L
(
££L M
)
££M N
;
££N O
var
§§ #
sessionTimeoutMinutes
§§ %
=
§§& '
settings
§§( 0
?
§§0 1
.
§§1 2
SessionTimeout
§§2 @
??
§§A C
$num
§§D F
;
§§F G
await
¶¶ 
LogActivityAsync
¶¶ "
(
¶¶" #
user
¶¶# '
.
¶¶' (
Id
¶¶( *
,
¶¶* +
$str
¶¶, 7
,
¶¶7 8
$str
¶¶9 @
)
¶¶@ A
;
¶¶A B
return
®® 
Ok
®® 
(
®® 
new
®® 
AuthResponse
®® &
{
©© 
Token
™™ 
=
™™ 
token
™™ 
,
™™ 
Email
´´ 
=
´´ 
user
´´ 
.
´´ 
Email
´´ "
!
´´" #
,
´´# $
Role
¨¨ 
=
¨¨ 
role
¨¨ 
,
¨¨ 

Expiration
≠≠ 
=
≠≠ 
DateTime
≠≠ %
.
≠≠% &
UtcNow
≠≠& ,
.
≠≠, -

AddMinutes
≠≠- 7
(
≠≠7 8#
sessionTimeoutMinutes
≠≠8 M
)
≠≠M N
}
ÆÆ 
)
ÆÆ 
;
ÆÆ 
}
ØØ 	
private
±± 
async
±± 
Task
±± 
<
±± 
bool
±± 
>
±±  "
VerifyReCaptchaAsync
±±! 5
(
±±5 6
string
±±6 <
?
±±< =
captchaToken
±±> J
)
±±J K
{
≤≤ 	
if
≥≥ 
(
≥≥ 
string
≥≥ 
.
≥≥  
IsNullOrWhiteSpace
≥≥ )
(
≥≥) *
captchaToken
≥≥* 6
)
≥≥6 7
)
≥≥7 8
return
¥¥ 
false
¥¥ 
;
¥¥ 
var
∂∂ 
	secretKey
∂∂ 
=
∂∂ 
_configuration
∂∂ *
[
∂∂* +
$str
∂∂+ @
]
∂∂@ A
;
∂∂A B
var
∑∑ 
	verifyUrl
∑∑ 
=
∑∑ 
_configuration
∑∑ *
[
∑∑* +
$str
∑∑+ @
]
∑∑@ A
??
∑∑B D
$str
∑∑E v
;
∑∑v w
if
ππ 
(
ππ 
string
ππ 
.
ππ  
IsNullOrWhiteSpace
ππ )
(
ππ) *
	secretKey
ππ* 3
)
ππ3 4
)
ππ4 5
return
∫∫ 
false
∫∫ 
;
∫∫ 
var
ºº 

httpClient
ºº 
=
ºº  
_httpClientFactory
ºº /
.
ºº/ 0
CreateClient
ºº0 <
(
ºº< =
)
ºº= >
;
ºº> ?
var
ΩΩ 
content
ΩΩ 
=
ΩΩ 
new
ΩΩ #
FormUrlEncodedContent
ΩΩ 3
(
ΩΩ3 4
new
ΩΩ4 7

Dictionary
ΩΩ8 B
<
ΩΩB C
string
ΩΩC I
,
ΩΩI J
string
ΩΩK Q
>
ΩΩQ R
{
ææ 
[
øø 
$str
øø 
]
øø 
=
øø 
	secretKey
øø &
,
øø& '
[
¿¿ 
$str
¿¿ 
]
¿¿ 
=
¿¿ 
captchaToken
¿¿ +
,
¿¿+ ,
[
¡¡ 
$str
¡¡ 
]
¡¡ 
=
¡¡ 
HttpContext
¡¡ *
.
¡¡* +

Connection
¡¡+ 5
.
¡¡5 6
RemoteIpAddress
¡¡6 E
?
¡¡E F
.
¡¡F G
ToString
¡¡G O
(
¡¡O P
)
¡¡P Q
??
¡¡R T
string
¡¡U [
.
¡¡[ \
Empty
¡¡\ a
}
¬¬ 
)
¬¬ 
;
¬¬ 
var
ƒƒ 
response
ƒƒ 
=
ƒƒ 
await
ƒƒ  

httpClient
ƒƒ! +
.
ƒƒ+ ,
	PostAsync
ƒƒ, 5
(
ƒƒ5 6
	verifyUrl
ƒƒ6 ?
,
ƒƒ? @
content
ƒƒA H
)
ƒƒH I
;
ƒƒI J
if
≈≈ 
(
≈≈ 
!
≈≈ 
response
≈≈ 
.
≈≈ !
IsSuccessStatusCode
≈≈ -
)
≈≈- .
return
∆∆ 
false
∆∆ 
;
∆∆ 
var
»» 
responseJson
»» 
=
»» 
await
»» $
response
»»% -
.
»»- .
Content
»». 5
.
»»5 6
ReadAsStringAsync
»»6 G
(
»»G H
)
»»H I
;
»»I J
var
…… 
result
…… 
=
…… 
JsonSerializer
…… '
.
……' (
Deserialize
……( 3
<
……3 4+
ReCaptchaVerificationResponse
……4 Q
>
……Q R
(
……R S
responseJson
……S _
,
……_ `
new
……a d#
JsonSerializerOptions
……e z
{
   )
PropertyNameCaseInsensitive
ÀÀ +
=
ÀÀ, -
true
ÀÀ. 2
}
ÃÃ 
)
ÃÃ 
;
ÃÃ 
return
ŒŒ 
result
ŒŒ 
?
ŒŒ 
.
ŒŒ 
Success
ŒŒ "
==
ŒŒ# %
true
ŒŒ& *
;
ŒŒ* +
}
œœ 	
private
—— 
sealed
—— 
class
—— +
ReCaptchaVerificationResponse
—— :
{
““ 	
public
”” 
bool
”” 
Success
”” 
{
””  !
get
””" %
;
””% &
set
””' *
;
””* +
}
””, -
[
’’ 
JsonPropertyName
’’ 
(
’’ 
$str
’’ +
)
’’+ ,
]
’’, -
public
÷÷ 
string
÷÷ 
[
÷÷ 
]
÷÷ 
?
÷÷ 

ErrorCodes
÷÷ '
{
÷÷( )
get
÷÷* -
;
÷÷- .
set
÷÷/ 2
;
÷÷2 3
}
÷÷4 5
}
◊◊ 	
[
ŸŸ 	
HttpPost
ŸŸ	 
(
ŸŸ 
$str
ŸŸ $
)
ŸŸ$ %
]
ŸŸ% &
public
⁄⁄ 
async
⁄⁄ 
Task
⁄⁄ 
<
⁄⁄ 
IActionResult
⁄⁄ '
>
⁄⁄' (
Verify2FALogin
⁄⁄) 7
(
⁄⁄7 8
[
⁄⁄8 9
FromBody
⁄⁄9 A
]
⁄⁄A B#
Verify2FALoginRequest
⁄⁄C X
request
⁄⁄Y `
,
⁄⁄` a
[
⁄⁄b c

FromHeader
⁄⁄c m
(
⁄⁄m n
Name
⁄⁄n r
=
⁄⁄s t
$str⁄⁄u Å
)⁄⁄Å Ç
]⁄⁄Ç É
string⁄⁄Ñ ä
?⁄⁄ä ã
	userAgent⁄⁄å ï
)⁄⁄ï ñ
{
€€ 	
var
‹‹ 
userAgentValue
‹‹ 
=
‹‹  
	userAgent
‹‹! *
??
‹‹+ -
string
‹‹. 4
.
‹‹4 5
Empty
‹‹5 :
;
‹‹: ;
var
›› 
	ipAddress
›› 
=
›› 
HttpContext
›› '
.
››' (

Connection
››( 2
.
››2 3
RemoteIpAddress
››3 B
?
››B C
.
››C D
ToString
››D L
(
››L M
)
››M N
;
››N O
if
ﬁﬁ 
(
ﬁﬁ (
_ipDeviceReputationService
ﬁﬁ *
.
ﬁﬁ* +
	IsBlocked
ﬁﬁ+ 4
(
ﬁﬁ4 5
	ipAddress
ﬁﬁ5 >
,
ﬁﬁ> ?
userAgentValue
ﬁﬁ@ N
,
ﬁﬁN O
out
ﬁﬁP S
var
ﬁﬁT W
blockReason
ﬁﬁX c
)
ﬁﬁc d
)
ﬁﬁd e
return
ﬂﬂ 

StatusCode
ﬂﬂ !
(
ﬂﬂ! "
$num
ﬂﬂ" %
,
ﬂﬂ% &
new
ﬂﬂ' *
{
ﬂﬂ+ ,
message
ﬂﬂ- 4
=
ﬂﬂ5 6
$"
ﬂﬂ7 9
$str
ﬂﬂ9 I
{
ﬂﬂI J
blockReason
ﬂﬂJ U
}
ﬂﬂU V
$str
ﬂﬂV o
"
ﬂﬂo p
}
ﬂﬂq r
)
ﬂﬂr s
;
ﬂﬂs t
var
·· 
user
·· 
=
·· 
await
·· 
_userManager
·· )
.
··) *
FindByEmailAsync
··* :
(
··: ;
request
··; B
.
··B C
Email
··C H
)
··H I
;
··I J
if
‚‚ 
(
‚‚ 
user
‚‚ 
==
‚‚ 
null
‚‚ 
)
‚‚ 
return
‚‚ $
Unauthorized
‚‚% 1
(
‚‚1 2
new
‚‚2 5
{
‚‚6 7
message
‚‚8 ?
=
‚‚@ A!
MessageUserNotFound
‚‚B U
}
‚‚V W
)
‚‚W X
;
‚‚X Y
var
‰‰ 
verification
‰‰ 
=
‰‰ 
await
‰‰ $
_context
‰‰% -
.
‰‰- .
VerificationCodes
‰‰. ?
.
ÂÂ !
FirstOrDefaultAsync
ÂÂ $
(
ÂÂ$ %
v
ÂÂ% &
=>
ÂÂ' )
v
ÂÂ* +
.
ÂÂ+ ,
Email
ÂÂ, 1
==
ÂÂ2 4
request
ÂÂ5 <
.
ÂÂ< =
Email
ÂÂ= B
&&
ÂÂC E
v
ÂÂF G
.
ÂÂG H
Code
ÂÂH L
==
ÂÂM O
request
ÂÂP W
.
ÂÂW X
Code
ÂÂX \
&&
ÂÂ] _
!
ÂÂ` a
v
ÂÂa b
.
ÂÂb c
IsUsed
ÂÂc i
&&
ÂÂj l
v
ÂÂm n
.
ÂÂn o
	ExpiresAt
ÂÂo x
>
ÂÂy z
DateTimeÂÂ{ É
.ÂÂÉ Ñ
UtcNowÂÂÑ ä
)ÂÂä ã
;ÂÂã å
if
ÊÊ 
(
ÊÊ 
verification
ÊÊ 
==
ÊÊ 
null
ÊÊ  $
)
ÊÊ$ %
return
ÊÊ& ,

BadRequest
ÊÊ- 7
(
ÊÊ7 8
new
ÊÊ8 ;
{
ÊÊ< =
message
ÊÊ> E
=
ÊÊF G
$str
ÊÊH n
}
ÊÊo p
)
ÊÊp q
;
ÊÊq r
verification
ËË 
.
ËË 
IsUsed
ËË 
=
ËË  !
true
ËË" &
;
ËË& '
var
ÍÍ 
device
ÍÍ 
=
ÍÍ $
GetDeviceFromUserAgent
ÍÍ /
(
ÍÍ/ 0
userAgentValue
ÍÍ0 >
)
ÍÍ> ?
;
ÍÍ? @
var
ÎÎ 
location
ÎÎ 
=
ÎÎ 
$str
ÎÎ (
;
ÎÎ( )
_context
ÌÌ 
.
ÌÌ 
LoginHistory
ÌÌ !
.
ÌÌ! "
Add
ÌÌ" %
(
ÌÌ% &
new
ÌÌ& )
LoginHistory
ÌÌ* 6
{
ÓÓ 
UserID
ÔÔ 
=
ÔÔ 
user
ÔÔ 
.
ÔÔ 
Id
ÔÔ  
,
ÔÔ  !
Device
 
=
 
device
 
,
  
Location
ÒÒ 
=
ÒÒ 
location
ÒÒ #
,
ÒÒ# $
	IPAddress
ÚÚ 
=
ÚÚ 
	ipAddress
ÚÚ %
,
ÚÚ% &
	LoginTime
ÛÛ 
=
ÛÛ 
DateTime
ÛÛ $
.
ÛÛ$ %
UtcNow
ÛÛ% +
}
ÙÙ 
)
ÙÙ 
;
ÙÙ 
await
ıı 
_context
ıı 
.
ıı 
SaveChangesAsync
ıı +
(
ıı+ ,
)
ıı, -
;
ıı- .
await
¯¯ "
_loginAttemptService
¯¯ &
.
¯¯& ' 
ResetAttemptsAsync
¯¯' 9
(
¯¯9 :
user
¯¯: >
.
¯¯> ?
Id
¯¯? A
)
¯¯A B
;
¯¯B C(
_ipDeviceReputationService
˘˘ &
.
˘˘& '
RegisterSuccess
˘˘' 6
(
˘˘6 7
	ipAddress
˘˘7 @
,
˘˘@ A
userAgentValue
˘˘B P
)
˘˘P Q
;
˘˘Q R
var
˚˚ 
roles
˚˚ 
=
˚˚ 
await
˚˚ 
_userManager
˚˚ *
.
˚˚* +
GetRolesAsync
˚˚+ 8
(
˚˚8 9
user
˚˚9 =
)
˚˚= >
;
˚˚> ?
var
¸¸ 
role
¸¸ 
=
¸¸ 
roles
¸¸ 
.
¸¸ 
FirstOrDefault
¸¸ +
(
¸¸+ ,
)
¸¸, -
??
¸¸. 0
user
¸¸1 5
.
¸¸5 6
Role
¸¸6 :
;
¸¸: ;
var
˝˝ 
token
˝˝ 
=
˝˝ 
await
˝˝ 
_tokenService
˝˝ +
.
˝˝+ , 
GenerateTokenAsync
˝˝, >
(
˝˝> ?
user
˝˝? C
.
˝˝C D
Email
˝˝D I
!
˝˝I J
,
˝˝J K
user
˝˝L P
.
˝˝P Q
Id
˝˝Q S
,
˝˝S T
role
˝˝U Y
)
˝˝Y Z
;
˝˝Z [
var
ˇˇ 
settings
ˇˇ 
=
ˇˇ 
await
ˇˇ  
_context
ˇˇ! )
.
ˇˇ) *
SystemSettings
ˇˇ* 8
.
ˇˇ8 9!
FirstOrDefaultAsync
ˇˇ9 L
(
ˇˇL M
)
ˇˇM N
;
ˇˇN O
var
ÄÄ #
sessionTimeoutMinutes
ÄÄ %
=
ÄÄ& '
settings
ÄÄ( 0
?
ÄÄ0 1
.
ÄÄ1 2
SessionTimeout
ÄÄ2 @
??
ÄÄA C
$num
ÄÄD F
;
ÄÄF G
await
ÇÇ 
LogActivityAsync
ÇÇ "
(
ÇÇ" #
user
ÇÇ# '
.
ÇÇ' (
Id
ÇÇ( *
,
ÇÇ* +
$str
ÇÇ, H
,
ÇÇH I
$str
ÇÇJ Q
)
ÇÇQ R
;
ÇÇR S
return
ÑÑ 
Ok
ÑÑ 
(
ÑÑ 
new
ÑÑ 
AuthResponse
ÑÑ &
{
ÖÖ 
Token
ÜÜ 
=
ÜÜ 
token
ÜÜ 
,
ÜÜ 
Email
áá 
=
áá 
user
áá 
.
áá 
Email
áá "
!
áá" #
,
áá# $
Role
àà 
=
àà 
role
àà 
,
àà 

Expiration
ââ 
=
ââ 
DateTime
ââ %
.
ââ% &
UtcNow
ââ& ,
.
ââ, -

AddMinutes
ââ- 7
(
ââ7 8#
sessionTimeoutMinutes
ââ8 M
)
ââM N
}
ää 
)
ää 
;
ää 
}
ãã 	
private
çç 
static
çç 
string
çç $
GetDeviceFromUserAgent
çç 4
(
çç4 5
string
çç5 ;
	userAgent
çç< E
)
ççE F
{
éé 	
if
èè 
(
èè 
string
èè 
.
èè 
IsNullOrEmpty
èè $
(
èè$ %
	userAgent
èè% .
)
èè. /
)
èè/ 0
return
êê 
DeviceUnknown
êê $
;
êê$ %
var
íí 
rules
íí 
=
íí 
new
íí 
(
íí 
string
íí #
[
íí# $
]
íí$ %
MustContain
íí& 1
,
íí1 2
string
íí3 9
Result
íí: @
)
íí@ A
[
ííA B
]
ííB C
{
ìì 
(
îî 
new
îî 
[
îî 
]
îî 
{
îî 
$str
îî !
,
îî! "
$str
îî# ,
}
îî- .
,
îî. /
$str
îî0 C
)
îîC D
,
îîD E
(
ïï 
new
ïï 
[
ïï 
]
ïï 
{
ïï 
$str
ïï !
,
ïï! "
$str
ïï# (
}
ïï) *
,
ïï* +
$str
ïï, ;
)
ïï; <
,
ïï< =
(
ññ 
new
ññ 
[
ññ 
]
ññ 
{
ññ 
$str
ññ !
,
ññ! "
$str
ññ# ,
}
ññ- .
,
ññ. /
$str
ññ0 C
)
ññC D
,
ññD E
(
óó 
new
óó 
[
óó 
]
óó 
{
óó 
$str
óó !
,
óó! "
$str
óó# +
}
óó, -
,
óó- .
$str
óó/ A
)
óóA B
,
óóB C
(
òò 
new
òò 
[
òò 
]
òò 
{
òò 
$str
òò !
,
òò! "
$str
òò# )
}
òò* +
,
òò+ ,
$str
òò- =
)
òò= >
,
òò> ?
(
ôô 
new
ôô 
[
ôô 
]
ôô 
{
ôô 
$str
ôô "
}
ôô# $
,
ôô$ %
$str
ôô& 7
)
ôô7 8
,
ôô8 9
(
öö 
new
öö 
[
öö 
]
öö 
{
öö 
$str
öö 
}
öö  !
,
öö! "
$str
öö# 3
)
öö3 4
}
õõ 
;
õõ 
foreach
ùù 
(
ùù 
var
ùù 
rule
ùù 
in
ùù  
rules
ùù! &
)
ùù& '
{
ûû 
if
üü 
(
üü 
rule
üü 
.
üü 
MustContain
üü $
.
üü$ %
All
üü% (
(
üü( )
token
üü) .
=>
üü/ 1
	userAgent
üü2 ;
.
üü; <
Contains
üü< D
(
üüD E
token
üüE J
,
üüJ K
StringComparison
üüL \
.
üü\ ]
OrdinalIgnoreCase
üü] n
)
üün o
)
üüo p
)
üüp q
return
†† 
rule
†† 
.
††  
Result
††  &
;
††& '
}
°° 
return
££ 
DeviceUnknown
££  
;
££  !
}
§§ 	
[
¶¶ 	
HttpPost
¶¶	 
(
¶¶ 
$str
¶¶  
)
¶¶  !
]
¶¶! "
public
ßß 
async
ßß 
Task
ßß 
<
ßß 
IActionResult
ßß '
>
ßß' (
GoogleLogin
ßß) 4
(
ßß4 5
[
ßß5 6
FromBody
ßß6 >
]
ßß> ? 
GoogleLoginRequest
ßß@ R
request
ßßS Z
)
ßßZ [
{
®® 	
var
©© 
user
©© 
=
©© 
await
©© 
_userManager
©© )
.
©©) *
FindByEmailAsync
©©* :
(
©©: ;
request
©©; B
.
©©B C
Email
©©C H
)
©©H I
;
©©I J
if
´´ 
(
´´ 
user
´´ 
==
´´ 
null
´´ 
)
´´ 
{
¨¨ 
user
≠≠ 
=
≠≠ 
new
≠≠ 
ApplicationUser
≠≠ *
{
ÆÆ 
UserName
ØØ 
=
ØØ 
request
ØØ &
.
ØØ& '
Email
ØØ' ,
,
ØØ, -
Email
∞∞ 
=
∞∞ 
request
∞∞ #
.
∞∞# $
Email
∞∞$ )
,
∞∞) *
	FirstName
±± 
=
±± 
request
±±  '
.
±±' (
	FirstName
±±( 1
,
±±1 2
LastName
≤≤ 
=
≤≤ 
request
≤≤ &
.
≤≤& '
LastName
≤≤' /
,
≤≤/ 0
EmailConfirmed
≥≥ "
=
≥≥# $
true
≥≥% )
,
≥≥) *
Status
¥¥ 
=
¥¥ 
StatusActive
¥¥ )
}
µµ 
;
µµ 
var
∑∑ 
result
∑∑ 
=
∑∑ 
await
∑∑ "
_userManager
∑∑# /
.
∑∑/ 0
CreateAsync
∑∑0 ;
(
∑∑; <
user
∑∑< @
)
∑∑@ A
;
∑∑A B
if
∏∏ 
(
∏∏ 
!
∏∏ 
result
∏∏ 
.
∏∏ 
	Succeeded
∏∏ %
)
∏∏% &
return
ππ 

BadRequest
ππ %
(
ππ% &
result
ππ& ,
.
ππ, -
Errors
ππ- 3
)
ππ3 4
;
ππ4 5
_context
ªª 
.
ªª  
OnboardingStatuses
ªª +
.
ªª+ ,
Add
ªª, /
(
ªª/ 0
new
ªª0 3
OnboardingStatus
ªª4 D
{
ºº 
UserID
ΩΩ 
=
ΩΩ 
user
ΩΩ !
.
ΩΩ! "
Id
ΩΩ" $
,
ΩΩ$ %
IsEmailVerified
ææ #
=
ææ$ %
true
ææ& *
}
øø 
)
øø 
;
øø 
await
¿¿ 
_context
¿¿ 
.
¿¿ 
SaveChangesAsync
¿¿ /
(
¿¿/ 0
)
¿¿0 1
;
¿¿1 2
}
¡¡ 
await
ƒƒ "
_loginAttemptService
ƒƒ &
.
ƒƒ& ' 
ResetAttemptsAsync
ƒƒ' 9
(
ƒƒ9 :
user
ƒƒ: >
.
ƒƒ> ?
Id
ƒƒ? A
)
ƒƒA B
;
ƒƒB C
var
∆∆ 
roles
∆∆ 
=
∆∆ 
await
∆∆ 
_userManager
∆∆ *
.
∆∆* +
GetRolesAsync
∆∆+ 8
(
∆∆8 9
user
∆∆9 =
)
∆∆= >
;
∆∆> ?
var
«« 
role
«« 
=
«« 
roles
«« 
.
«« 
FirstOrDefault
«« +
(
««+ ,
)
««, -
??
««. 0
user
««1 5
.
««5 6
Role
««6 :
;
««: ;
var
…… 
token
…… 
=
…… 
await
…… 
_tokenService
…… +
.
……+ , 
GenerateTokenAsync
……, >
(
……> ?
user
……? C
.
……C D
Email
……D I
!
……I J
,
……J K
user
……L P
.
……P Q
Id
……Q S
,
……S T
role
……U Y
)
……Y Z
;
……Z [
var
ÀÀ 
settings
ÀÀ 
=
ÀÀ 
await
ÀÀ  
_context
ÀÀ! )
.
ÀÀ) *
SystemSettings
ÀÀ* 8
.
ÀÀ8 9!
FirstOrDefaultAsync
ÀÀ9 L
(
ÀÀL M
)
ÀÀM N
;
ÀÀN O
var
ÃÃ #
sessionTimeoutMinutes
ÃÃ %
=
ÃÃ& '
settings
ÃÃ( 0
?
ÃÃ0 1
.
ÃÃ1 2
SessionTimeout
ÃÃ2 @
??
ÃÃA C
$num
ÃÃD F
;
ÃÃF G
await
ŒŒ 
LogActivityAsync
ŒŒ "
(
ŒŒ" #
user
ŒŒ# '
.
ŒŒ' (
Id
ŒŒ( *
,
ŒŒ* +
$str
ŒŒ, C
,
ŒŒC D
$str
ŒŒE L
)
ŒŒL M
;
ŒŒM N
return
–– 
Ok
–– 
(
–– 
new
–– 
AuthResponse
–– &
{
—— 
Token
““ 
=
““ 
token
““ 
,
““ 
Email
”” 
=
”” 
user
”” 
.
”” 
Email
”” "
!
””" #
,
””# $
Role
‘‘ 
=
‘‘ 
role
‘‘ 
,
‘‘ 

Expiration
’’ 
=
’’ 
DateTime
’’ %
.
’’% &
UtcNow
’’& ,
.
’’, -

AddMinutes
’’- 7
(
’’7 8#
sessionTimeoutMinutes
’’8 M
)
’’M N
}
÷÷ 
)
÷÷ 
;
÷÷ 
}
◊◊ 	
private
ŸŸ 
async
ŸŸ 
Task
ŸŸ 
LogActivityAsync
ŸŸ +
(
ŸŸ+ ,
string
ŸŸ, 2
userId
ŸŸ3 9
,
ŸŸ9 :
string
ŸŸ; A
action
ŸŸB H
,
ŸŸH I
string
ŸŸJ P
type
ŸŸQ U
)
ŸŸU V
{
⁄⁄ 	
if
€€ 
(
€€ 
string
€€ 
.
€€  
IsNullOrWhiteSpace
€€ )
(
€€) *
userId
€€* 0
)
€€0 1
||
€€2 4
string
€€5 ;
.
€€; < 
IsNullOrWhiteSpace
€€< N
(
€€N O
action
€€O U
)
€€U V
)
€€V W
return
‹‹ 
;
‹‹ 
try
ﬁﬁ 
{
ﬂﬂ 
_context
‡‡ 
.
‡‡ 
ActivityLogs
‡‡ %
.
‡‡% &
Add
‡‡& )
(
‡‡) *
new
‡‡* -
ActivityLog
‡‡. 9
{
·· 
UserID
‚‚ 
=
‚‚ 
userId
‚‚ #
,
‚‚# $
Action
„„ 
=
„„ 
action
„„ #
,
„„# $
Type
‰‰ 
=
‰‰ 
string
‰‰ !
.
‰‰! " 
IsNullOrWhiteSpace
‰‰" 4
(
‰‰4 5
type
‰‰5 9
)
‰‰9 :
?
‰‰; <
$str
‰‰= E
:
‰‰F G
type
‰‰H L
,
‰‰L M
	IPAddress
ÂÂ 
=
ÂÂ 
HttpContext
ÂÂ  +
.
ÂÂ+ ,

Connection
ÂÂ, 6
.
ÂÂ6 7
RemoteIpAddress
ÂÂ7 F
?
ÂÂF G
.
ÂÂG H
ToString
ÂÂH P
(
ÂÂP Q
)
ÂÂQ R
,
ÂÂR S
	Timestamp
ÊÊ 
=
ÊÊ 
DateTime
ÊÊ  (
.
ÊÊ( )
UtcNow
ÊÊ) /
}
ÁÁ 
)
ÁÁ 
;
ÁÁ 
await
ÈÈ 
_context
ÈÈ 
.
ÈÈ 
SaveChangesAsync
ÈÈ /
(
ÈÈ/ 0
)
ÈÈ0 1
;
ÈÈ1 2
}
ÍÍ 
catch
ÎÎ 
{
ÏÏ 
}
ÓÓ 
}
ÔÔ 	
[
ÒÒ 	
	Authorize
ÒÒ	 
]
ÒÒ 
[
ÚÚ 	&
RequireEmailVerification
ÚÚ	 !
]
ÚÚ! "
[
ÛÛ 	
HttpPost
ÛÛ	 
(
ÛÛ 
$str
ÛÛ '
)
ÛÛ' (
]
ÛÛ( )
public
ÙÙ 
async
ÙÙ 
Task
ÙÙ 
<
ÙÙ 
IActionResult
ÙÙ '
>
ÙÙ' (
SelectServiceType
ÙÙ) :
(
ÙÙ: ;
[
ÙÙ; <
FromBody
ÙÙ< D
]
ÙÙD E&
SelectServiceTypeRequest
ÙÙF ^
request
ÙÙ_ f
)
ÙÙf g
{
ıı 	
var
ˆˆ 
userId
ˆˆ 
=
ˆˆ 
User
ˆˆ 
.
ˆˆ 
	FindFirst
ˆˆ '
(
ˆˆ' (
System
ˆˆ( .
.
ˆˆ. /
Security
ˆˆ/ 7
.
ˆˆ7 8
Claims
ˆˆ8 >
.
ˆˆ> ?

ClaimTypes
ˆˆ? I
.
ˆˆI J
NameIdentifier
ˆˆJ X
)
ˆˆX Y
?
ˆˆY Z
.
ˆˆZ [
Value
ˆˆ[ `
;
ˆˆ` a
var
˜˜ 
activeSubCount
˜˜ 
=
˜˜  
await
˜˜! &
_context
˜˜' /
.
˜˜/ 0
Subscriptions
˜˜0 =
.
¯¯ 

CountAsync
¯¯ 
(
¯¯ 
s
¯¯ 
=>
¯¯  
s
¯¯! "
.
¯¯" #
UserID
¯¯# )
==
¯¯* ,
userId
¯¯- 3
&&
¯¯4 6
s
¯¯7 8
.
¯¯8 9
Status
¯¯9 ?
==
¯¯@ B
StatusActive
¯¯C O
)
¯¯O P
;
¯¯P Q
var
˘˘ 
activePrepCount
˘˘ 
=
˘˘  !
await
˘˘" '
_context
˘˘( 0
.
˘˘0 1
Devices
˘˘1 8
.
˙˙ 
Where
˙˙ 
(
˙˙ 
d
˙˙ 
=>
˙˙ 
d
˙˙ 
.
˙˙ 
UserID
˙˙ $
==
˙˙% '
userId
˙˙( .
)
˙˙. /
.
˚˚ 

SelectMany
˚˚ 
(
˚˚ 
d
˚˚ 
=>
˚˚  
d
˚˚! "
.
˚˚" #
ServiceAccounts
˚˚# 2
)
˚˚2 3
.
¸¸ 
Where
¸¸ 
(
¸¸ 
sa
¸¸ 
=>
¸¸ 
sa
¸¸ 
.
¸¸  
Status
¸¸  &
==
¸¸' )
StatusActive
¸¸* 6
&&
¸¸7 9
sa
¸¸: <
.
¸¸< =
ServiceType
¸¸= H
==
¸¸I K
ServicePrepaid
¸¸L Z
)
¸¸Z [
.
˝˝ 

CountAsync
˝˝ 
(
˝˝ 
)
˝˝ 
;
˝˝ 
if
ˇˇ 
(
ˇˇ 
activeSubCount
ˇˇ 
+
ˇˇ  
activePrepCount
ˇˇ! 0
>=
ˇˇ1 3
$num
ˇˇ4 5
)
ˇˇ5 6
return
ÄÄ 

BadRequest
ÄÄ !
(
ÄÄ! "
new
ÄÄ" %
{
ÄÄ& '
message
ÄÄ( /
=
ÄÄ0 1
$str
ÄÄ2 l
}
ÄÄm n
)
ÄÄn o
;
ÄÄo p
var
ÇÇ 

onboarding
ÇÇ 
=
ÇÇ 
await
ÇÇ "
_context
ÇÇ# +
.
ÇÇ+ , 
OnboardingStatuses
ÇÇ, >
.
ÇÇ> ?!
FirstOrDefaultAsync
ÇÇ? R
(
ÇÇR S
o
ÇÇS T
=>
ÇÇU W
o
ÇÇX Y
.
ÇÇY Z
UserID
ÇÇZ `
==
ÇÇa c
userId
ÇÇd j
)
ÇÇj k
;
ÇÇk l
if
ÑÑ 
(
ÑÑ 

onboarding
ÑÑ 
==
ÑÑ 
null
ÑÑ "
)
ÑÑ" #
return
ÖÖ 
NotFound
ÖÖ 
(
ÖÖ  
new
ÖÖ  #
{
ÖÖ$ %
message
ÖÖ& -
=
ÖÖ. /
$str
ÖÖ0 M
}
ÖÖN O
)
ÖÖO P
;
ÖÖP Q

onboarding
áá 
.
áá $
HasSelectedServiceType
áá -
=
áá. /
true
áá0 4
;
áá4 5
await
àà 
_context
àà 
.
àà 
SaveChangesAsync
àà +
(
àà+ ,
)
àà, -
;
àà- .
return
ää 
Ok
ää 
(
ää 
new
ää 
{
ää 
message
ää #
=
ää$ %
$str
ää& J
}
ääK L
)
ääL M
;
ääM N
}
ãã 	
[
çç 	
	Authorize
çç	 
]
çç 
[
éé 	&
RequireEmailVerification
éé	 !
]
éé! "
[
èè 	
HttpGet
èè	 
(
èè 
$str
èè $
)
èè$ %
]
èè% &
public
êê 
async
êê 
Task
êê 
<
êê 
IActionResult
êê '
>
êê' (!
GetOnboardingStatus
êê) <
(
êê< =
)
êê= >
{
ëë 	
var
íí 
userId
íí 
=
íí 
User
íí 
.
íí 
	FindFirst
íí '
(
íí' (
System
íí( .
.
íí. /
Security
íí/ 7
.
íí7 8
Claims
íí8 >
.
íí> ?

ClaimTypes
íí? I
.
ííI J
NameIdentifier
ííJ X
)
ííX Y
?
ííY Z
.
ííZ [
Value
íí[ `
;
íí` a
var
îî #
hasActiveSubscription
îî %
=
îî& '
await
îî( -
_context
îî. 6
.
îî6 7
Subscriptions
îî7 D
.
ïï 
AnyAsync
ïï 
(
ïï 
s
ïï 
=>
ïï 
s
ïï  
.
ïï  !
UserID
ïï! '
==
ïï( *
userId
ïï+ 1
&&
ïï2 4
s
ïï5 6
.
ïï6 7
Status
ïï7 =
==
ïï> @
StatusActive
ïïA M
)
ïïM N
;
ïïN O
var
óó 
hasActivePrepaid
óó  
=
óó! "
await
óó# (
_context
óó) 1
.
óó1 2
Devices
óó2 9
.
òò 
Where
òò 
(
òò 
d
òò 
=>
òò 
d
òò 
.
òò 
UserID
òò $
==
òò% '
userId
òò( .
)
òò. /
.
ôô 

SelectMany
ôô 
(
ôô 
d
ôô 
=>
ôô  
d
ôô! "
.
ôô" #
ServiceAccounts
ôô# 2
)
ôô2 3
.
öö 
Where
öö 
(
öö 
sa
öö 
=>
öö 
sa
öö 
.
öö  
Status
öö  &
==
öö' )
StatusActive
öö* 6
)
öö6 7
.
õõ 

SelectMany
õõ 
(
õõ 
sa
õõ 
=>
õõ !
sa
õõ" $
.
õõ$ %
PrepaidLoads
õõ% 1
)
õõ1 2
.
úú 
AnyAsync
úú 
(
úú 
)
úú 
;
úú 
var
ûû 
hasActivePlan
ûû 
=
ûû #
hasActiveSubscription
ûû  5
||
ûû6 8
hasActivePrepaid
ûû9 I
;
ûûI J
var
†† 

onboarding
†† 
=
†† 
await
†† "
_context
††# +
.
††+ , 
OnboardingStatuses
††, >
.
††> ?!
FirstOrDefaultAsync
††? R
(
††R S
o
††S T
=>
††U W
o
††X Y
.
††Y Z
UserID
††Z `
==
††a c
userId
††d j
)
††j k
;
††k l
if
¢¢ 
(
¢¢ 

onboarding
¢¢ 
==
¢¢ 
null
¢¢ "
)
¢¢" #
{
££ 
return
§§ 
Ok
§§ 
(
§§ 
new
§§ 
{
•• $
hasSelectedServiceType
¶¶ *
=
¶¶+ ,
false
¶¶- 2
,
¶¶2 3!
hasRegisteredDevice
ßß '
=
ßß( )
false
ßß* /
,
ßß/ 0"
hasCompletedTutorial
®® (
=
®®) *
false
®®+ 0
,
®®0 1
hasActivePlan
©© !
}
™™ 
)
™™ 
;
™™ 
}
´´ 
return
≠≠ 
Ok
≠≠ 
(
≠≠ 
new
≠≠ 
{
ÆÆ $
hasSelectedServiceType
ØØ &
=
ØØ' (

onboarding
ØØ) 3
.
ØØ3 4$
HasSelectedServiceType
ØØ4 J
,
ØØJ K!
hasRegisteredDevice
∞∞ #
=
∞∞$ %

onboarding
∞∞& 0
.
∞∞0 1!
HasRegisteredDevice
∞∞1 D
,
∞∞D E"
hasCompletedTutorial
±± $
=
±±% &

onboarding
±±' 1
.
±±1 2"
HasCompletedTutorial
±±2 F
,
±±F G
hasActivePlan
≤≤ 
}
≥≥ 
)
≥≥ 
;
≥≥ 
}
¥¥ 	
[
∂∂ 	
	Authorize
∂∂	 
]
∂∂ 
[
∑∑ 	&
RequireEmailVerification
∑∑	 !
]
∑∑! "
[
∏∏ 	
HttpPost
∏∏	 
(
∏∏ 
$str
∏∏ #
)
∏∏# $
]
∏∏$ %
public
ππ 
async
ππ 
Task
ππ 
<
ππ 
IActionResult
ππ '
>
ππ' (
RegisterDevice
ππ) 7
(
ππ7 8
[
ππ8 9
FromBody
ππ9 A
]
ππA B#
RegisterDeviceRequest
ππC X
request
ππY `
)
ππ` a
{
∫∫ 	
try
ªª 
{
ºº 
var
ΩΩ 
userId
ΩΩ 
=
ΩΩ 
User
ΩΩ !
.
ΩΩ! "
	FindFirst
ΩΩ" +
(
ΩΩ+ ,
System
ΩΩ, 2
.
ΩΩ2 3
Security
ΩΩ3 ;
.
ΩΩ; <
Claims
ΩΩ< B
.
ΩΩB C

ClaimTypes
ΩΩC M
.
ΩΩM N
NameIdentifier
ΩΩN \
)
ΩΩ\ ]
?
ΩΩ] ^
.
ΩΩ^ _
Value
ΩΩ_ d
;
ΩΩd e
var
øø 
limitResult
øø 
=
øø  !
await
øø" '&
EnforceServiceLimitAsync
øø( @
(
øø@ A
userId
øøA G
)
øøG H
;
øøH I
if
¿¿ 
(
¿¿ 
limitResult
¿¿ 
!=
¿¿  "
null
¿¿# '
)
¿¿' (
return
¡¡ 
limitResult
¡¡ &
;
¡¡& '
var
√√ 
serviceType
√√ 
=
√√  ! 
ResolveServiceType
√√" 4
(
√√4 5
request
√√5 <
.
√√< =
ServiceType
√√= H
)
√√H I
;
√√I J
var
ƒƒ 
validationResult
ƒƒ $
=
ƒƒ% &$
ValidatePrepaidRequest
ƒƒ' =
(
ƒƒ= >
serviceType
ƒƒ> I
,
ƒƒI J
request
ƒƒK R
.
ƒƒR S
PhoneNumber
ƒƒS ^
)
ƒƒ^ _
;
ƒƒ_ `
if
≈≈ 
(
≈≈ 
validationResult
≈≈ $
!=
≈≈% '
null
≈≈( ,
)
≈≈, -
return
∆∆ 
validationResult
∆∆ +
;
∆∆+ ,
var
»» 

macAddress
»» 
=
»»  
ResolveMacAddress
»»! 2
(
»»2 3
serviceType
»»3 >
,
»»> ?
request
»»@ G
.
»»G H

MacAddress
»»H R
)
»»R S
;
»»S T
var
   
device
   
=
   
await
   "
CreateDeviceAsync
  # 4
(
  4 5
userId
  5 ;
!
  ; <
,
  < =

macAddress
  > H
)
  H I
;
  I J
var
ÀÀ 
serviceAccount
ÀÀ "
=
ÀÀ# $
await
ÀÀ% *'
CreateServiceAccountAsync
ÀÀ+ D
(
ÀÀD E
device
ÀÀE K
.
ÀÀK L
DeviceID
ÀÀL T
,
ÀÀT U
serviceType
ÀÀV a
)
ÀÀa b
;
ÀÀb c
if
ÕÕ 
(
ÕÕ 
serviceType
ÕÕ 
==
ÕÕ  "
ServicePrepaid
ÕÕ# 1
)
ÕÕ1 2
{
ŒŒ 
await
œœ $
CreatePrepaidLoadAsync
œœ 0
(
œœ0 1
serviceAccount
œœ1 ?
.
œœ? @
ServiceAccountID
œœ@ P
,
œœP Q
request
œœR Y
.
œœY Z
PhoneNumber
œœZ e
)
œœe f
;
œœf g
}
–– 
else
—— 
{
““ 
var
”” 

planResult
”” "
=
””# $
await
””% * 
ResolvePlanIdAsync
””+ =
(
””= >
request
””> E
.
””E F
PlanID
””F L
,
””L M
request
””N U
.
””U V

MacAddress
””V `
)
””` a
;
””a b
if
‘‘ 
(
‘‘ 

planResult
‘‘ "
.
‘‘" #
Error
‘‘# (
!=
‘‘) +
null
‘‘, 0
)
‘‘0 1
return
’’ 

planResult
’’ )
.
’’) *
Error
’’* /
;
’’/ 0
await
◊◊ %
CreateSubscriptionAsync
◊◊ 1
(
◊◊1 2
serviceAccount
◊◊2 @
.
◊◊@ A
ServiceAccountID
◊◊A Q
,
◊◊Q R
userId
◊◊S Y
!
◊◊Y Z
,
◊◊Z [

planResult
◊◊\ f
.
◊◊f g
PlanId
◊◊g m
!
◊◊m n
.
◊◊n o
Value
◊◊o t
)
◊◊t u
;
◊◊u v
}
ÿÿ 
await
⁄⁄ #
UpdateOnboardingAsync
⁄⁄ +
(
⁄⁄+ ,
userId
⁄⁄, 2
)
⁄⁄2 3
;
⁄⁄3 4
return
‹‹ 
Ok
‹‹ 
(
‹‹ 
new
‹‹ 
{
‹‹ 
message
‹‹  '
=
‹‹( )
$str
‹‹* J
,
‹‹J K
deviceId
‹‹L T
=
‹‹U V
device
‹‹W ]
.
‹‹] ^
DeviceID
‹‹^ f
,
‹‹f g
serviceType
‹‹h s
}
‹‹t u
)
‹‹u v
;
‹‹v w
}
›› 
catch
ﬁﬁ 
(
ﬁﬁ 
	Exception
ﬁﬁ 
ex
ﬁﬁ 
)
ﬁﬁ  
{
ﬂﬂ 
return
‡‡ 

BadRequest
‡‡ !
(
‡‡! "
new
‡‡" %
{
‡‡& '
message
‡‡( /
=
‡‡0 1
$"
‡‡2 4
$str
‡‡4 O
{
‡‡O P
ex
‡‡P R
.
‡‡R S
Message
‡‡S Z
}
‡‡Z [
"
‡‡[ \
}
‡‡] ^
)
‡‡^ _
;
‡‡_ `
}
·· 
}
‚‚ 	
private
‰‰ 
async
‰‰ 
Task
‰‰ 
<
‰‰ 
IActionResult
‰‰ (
?
‰‰( )
>
‰‰) *&
EnforceServiceLimitAsync
‰‰+ C
(
‰‰C D
string
‰‰D J
?
‰‰J K
userId
‰‰L R
)
‰‰R S
{
ÂÂ 	
var
ÊÊ %
activeSubscriptionCount
ÊÊ '
=
ÊÊ( )
await
ÊÊ* /
_context
ÊÊ0 8
.
ÊÊ8 9
Subscriptions
ÊÊ9 F
.
ÁÁ 

CountAsync
ÁÁ 
(
ÁÁ 
s
ÁÁ 
=>
ÁÁ  
s
ÁÁ! "
.
ÁÁ" #
UserID
ÁÁ# )
==
ÁÁ* ,
userId
ÁÁ- 3
&&
ÁÁ4 6
s
ÁÁ7 8
.
ÁÁ8 9
Status
ÁÁ9 ?
==
ÁÁ@ B
StatusActive
ÁÁC O
)
ÁÁO P
;
ÁÁP Q
var
ËË  
activePrepaidCount
ËË "
=
ËË# $
await
ËË% *
_context
ËË+ 3
.
ËË3 4
Devices
ËË4 ;
.
ÈÈ 
Where
ÈÈ 
(
ÈÈ 
d
ÈÈ 
=>
ÈÈ 
d
ÈÈ 
.
ÈÈ 
UserID
ÈÈ $
==
ÈÈ% '
userId
ÈÈ( .
)
ÈÈ. /
.
ÍÍ 

SelectMany
ÍÍ 
(
ÍÍ 
d
ÍÍ 
=>
ÍÍ  
d
ÍÍ! "
.
ÍÍ" #
ServiceAccounts
ÍÍ# 2
)
ÍÍ2 3
.
ÎÎ 
Where
ÎÎ 
(
ÎÎ 
sa
ÎÎ 
=>
ÎÎ 
sa
ÎÎ 
.
ÎÎ  
Status
ÎÎ  &
==
ÎÎ' )
StatusActive
ÎÎ* 6
&&
ÎÎ7 9
sa
ÎÎ: <
.
ÎÎ< =
ServiceType
ÎÎ= H
==
ÎÎI K
ServicePrepaid
ÎÎL Z
)
ÎÎZ [
.
ÏÏ 

CountAsync
ÏÏ 
(
ÏÏ 
)
ÏÏ 
;
ÏÏ 
if
ÓÓ 
(
ÓÓ %
activeSubscriptionCount
ÓÓ '
+
ÓÓ( ) 
activePrepaidCount
ÓÓ* <
>=
ÓÓ= ?
$num
ÓÓ@ A
)
ÓÓA B
return
ÔÔ 

BadRequest
ÔÔ !
(
ÔÔ! "
new
ÔÔ" %
{
ÔÔ& '
message
ÔÔ( /
=
ÔÔ0 1
$str
ÔÔ2 l
}
ÔÔm n
)
ÔÔn o
;
ÔÔo p
return
ÒÒ 
null
ÒÒ 
;
ÒÒ 
}
ÚÚ 	
private
ÙÙ 
static
ÙÙ 
string
ÙÙ  
ResolveServiceType
ÙÙ 0
(
ÙÙ0 1
string
ÙÙ1 7
?
ÙÙ7 8
serviceType
ÙÙ9 D
)
ÙÙD E
{
ıı 	
return
ˆˆ 
string
ˆˆ 
.
ˆˆ  
IsNullOrWhiteSpace
ˆˆ ,
(
ˆˆ, -
serviceType
ˆˆ- 8
)
ˆˆ8 9
?
ˆˆ: ;!
ServiceSubscription
ˆˆ< O
:
ˆˆP Q
serviceType
ˆˆR ]
;
ˆˆ] ^
}
˜˜ 	
private
˘˘ $
BadRequestObjectResult
˘˘ &
?
˘˘& '$
ValidatePrepaidRequest
˘˘( >
(
˘˘> ?
string
˘˘? E
serviceType
˘˘F Q
,
˘˘Q R
string
˘˘S Y
?
˘˘Y Z
phoneNumber
˘˘[ f
)
˘˘f g
{
˙˙ 	
if
˚˚ 
(
˚˚ 
serviceType
˚˚ 
==
˚˚ 
ServicePrepaid
˚˚ -
&&
˚˚. 0
string
˚˚1 7
.
˚˚7 8 
IsNullOrWhiteSpace
˚˚8 J
(
˚˚J K
phoneNumber
˚˚K V
)
˚˚V W
)
˚˚W X
return
¸¸ 

BadRequest
¸¸ !
(
¸¸! "
new
¸¸" %
{
¸¸& '
message
¸¸( /
=
¸¸0 1
$str
¸¸2 e
}
¸¸f g
)
¸¸g h
;
¸¸h i
return
˛˛ 
null
˛˛ 
;
˛˛ 
}
ˇˇ 	
private
ÅÅ 
static
ÅÅ 
string
ÅÅ 
?
ÅÅ 
ResolveMacAddress
ÅÅ 0
(
ÅÅ0 1
string
ÅÅ1 7
serviceType
ÅÅ8 C
,
ÅÅC D
string
ÅÅE K
?
ÅÅK L

macAddress
ÅÅM W
)
ÅÅW X
{
ÇÇ 	
if
ÉÉ 
(
ÉÉ 
serviceType
ÉÉ 
!=
ÉÉ 
ServicePrepaid
ÉÉ -
||
ÉÉ. 0
!
ÉÉ1 2
string
ÉÉ2 8
.
ÉÉ8 9 
IsNullOrWhiteSpace
ÉÉ9 K
(
ÉÉK L

macAddress
ÉÉL V
)
ÉÉV W
)
ÉÉW X
return
ÑÑ 

macAddress
ÑÑ !
;
ÑÑ! "
return
ÜÜ 
$"
ÜÜ 
$str
ÜÜ 
{
ÜÜ 
DateTime
ÜÜ !
.
ÜÜ! "
UtcNow
ÜÜ" (
:
ÜÜ( )
$str
ÜÜ) /
}
ÜÜ/ 0
$str
ÜÜ0 1
{
ÜÜ1 2
new
ÜÜ2 5
Random
ÜÜ6 <
(
ÜÜ< =
)
ÜÜ= >
.
ÜÜ> ?
Next
ÜÜ? C
(
ÜÜC D
$num
ÜÜD H
,
ÜÜH I
$num
ÜÜJ N
)
ÜÜN O
:
ÜÜO P
$str
ÜÜP R
}
ÜÜR S
$str
ÜÜS T
{
ÜÜT U
new
ÜÜU X
Random
ÜÜY _
(
ÜÜ_ `
)
ÜÜ` a
.
ÜÜa b
Next
ÜÜb f
(
ÜÜf g
$num
ÜÜg k
,
ÜÜk l
$num
ÜÜm q
)
ÜÜq r
:
ÜÜr s
$str
ÜÜs u
}
ÜÜu v
$str
ÜÜv w
{
ÜÜw x
new
ÜÜx {
RandomÜÜ| Ç
(ÜÜÇ É
)ÜÜÉ Ñ
.ÜÜÑ Ö
NextÜÜÖ â
(ÜÜâ ä
$numÜÜä é
,ÜÜé è
$numÜÜê î
)ÜÜî ï
:ÜÜï ñ
$strÜÜñ ò
}ÜÜò ô
$strÜÜô ö
{ÜÜö õ
newÜÜõ û
RandomÜÜü •
(ÜÜ• ¶
)ÜÜ¶ ß
.ÜÜß ®
NextÜÜ® ¨
(ÜÜ¨ ≠
$numÜÜ≠ ±
,ÜÜ± ≤
$numÜÜ≥ ∑
)ÜÜ∑ ∏
:ÜÜ∏ π
$strÜÜπ ª
}ÜÜª º
"ÜÜº Ω
;ÜÜΩ æ
}
áá 	
private
ââ 
async
ââ 
Task
ââ 
<
ââ 
Device
ââ !
>
ââ! "
CreateDeviceAsync
ââ# 4
(
ââ4 5
string
ââ5 ;
userId
ââ< B
,
ââB C
string
ââD J
?
ââJ K

macAddress
ââL V
)
ââV W
{
ää 	
var
ãã 
device
ãã 
=
ãã 
new
ãã 
Device
ãã #
{
åå 
UserID
çç 
=
çç 
userId
çç 
,
çç  

MACAddress
éé 
=
éé 

macAddress
éé '
,
éé' (
Status
èè 
=
èè 
StatusActive
èè %
,
èè% &

DeviceType
êê 
=
êê 
DeviceTypeWifi
êê +
}
ëë 
;
ëë 
_context
íí 
.
íí 
Devices
íí 
.
íí 
Add
íí  
(
íí  !
device
íí! '
)
íí' (
;
íí( )
await
ìì 
_context
ìì 
.
ìì 
SaveChangesAsync
ìì +
(
ìì+ ,
)
ìì, -
;
ìì- .
return
îî 
device
îî 
;
îî 
}
ïï 	
private
óó 
async
óó 
Task
óó 
<
óó 
ServiceAccount
óó )
>
óó) *'
CreateServiceAccountAsync
óó+ D
(
óóD E
int
óóE H
deviceId
óóI Q
,
óóQ R
string
óóS Y
serviceType
óóZ e
)
óóe f
{
òò 	
var
ôô 
serviceAccount
ôô 
=
ôô  
new
ôô! $
ServiceAccount
ôô% 3
{
öö 
DeviceID
õõ 
=
õõ 
deviceId
õõ #
,
õõ# $
ServiceType
úú 
=
úú 
serviceType
úú )
,
úú) *
Status
ùù 
=
ùù 
StatusActive
ùù %
}
ûû 
;
ûû 
_context
üü 
.
üü 
ServiceAccounts
üü $
.
üü$ %
Add
üü% (
(
üü( )
serviceAccount
üü) 7
)
üü7 8
;
üü8 9
await
†† 
_context
†† 
.
†† 
SaveChangesAsync
†† +
(
††+ ,
)
††, -
;
††- .
return
°° 
serviceAccount
°° !
;
°°! "
}
¢¢ 	
private
§§ 
async
§§ 
Task
§§ $
CreatePrepaidLoadAsync
§§ 1
(
§§1 2
int
§§2 5
serviceAccountId
§§6 F
,
§§F G
string
§§H N
?
§§N O
phoneNumber
§§P [
)
§§[ \
{
•• 	
var
¶¶ 
prepaidLoad
¶¶ 
=
¶¶ 
new
¶¶ !
PrepaidLoad
¶¶" -
{
ßß 
ServiceAccountID
®®  
=
®®! "
serviceAccountId
®®# 3
,
®®3 4
PhoneNumber
©© 
=
©© 
phoneNumber
©© )
,
©©) *

LoadAmount
™™ 
=
™™ 
$num
™™ 
,
™™ 
RemainingBalance
´´  
=
´´! "
$num
´´# $
}
¨¨ 
;
¨¨ 
_context
≠≠ 
.
≠≠ 
PrepaidLoads
≠≠ !
.
≠≠! "
Add
≠≠" %
(
≠≠% &
prepaidLoad
≠≠& 1
)
≠≠1 2
;
≠≠2 3
await
ÆÆ 
_context
ÆÆ 
.
ÆÆ 
SaveChangesAsync
ÆÆ +
(
ÆÆ+ ,
)
ÆÆ, -
;
ÆÆ- .
}
ØØ 	
private
±± 
async
±± 
Task
±± 
<
±± 
(
±± 
int
±± 
?
±±  
PlanId
±±! '
,
±±' (
IActionResult
±±) 6
?
±±6 7
Error
±±8 =
)
±±= >
>
±±> ? 
ResolvePlanIdAsync
±±@ R
(
±±R S
int
±±S V
?
±±V W
planId
±±X ^
,
±±^ _
string
±±` f
?
±±f g

macAddress
±±h r
)
±±r s
{
≤≤ 	
if
≥≥ 
(
≥≥ 
planId
≥≥ 
.
≥≥ 
HasValue
≥≥ 
)
≥≥  
return
¥¥ 
(
¥¥ 
planId
¥¥ 
.
¥¥ 
Value
¥¥ $
,
¥¥$ %
null
¥¥& *
)
¥¥* +
;
¥¥+ ,
if
∂∂ 
(
∂∂ 
string
∂∂ 
.
∂∂  
IsNullOrWhiteSpace
∂∂ )
(
∂∂) *

macAddress
∂∂* 4
)
∂∂4 5
)
∂∂5 6
return
∑∑ 
(
∑∑ 
null
∑∑ 
,
∑∑ 

BadRequest
∑∑ (
(
∑∑( )
new
∑∑) ,
{
∑∑- .
message
∑∑/ 6
=
∑∑7 8
$str
∑∑9 k
}
∑∑l m
)
∑∑m n
)
∑∑n o
;
∑∑o p
var
ππ 

normalized
ππ 
=
ππ 

macAddress
ππ '
.
ππ' (
Replace
ππ( /
(
ππ/ 0
$str
ππ0 3
,
ππ3 4
$str
ππ5 7
)
ππ7 8
.
ππ8 9
ToUpperInvariant
ππ9 I
(
ππI J
)
ππJ K
;
ππK L
if
∫∫ 
(
∫∫ 

normalized
∫∫ 
.
∫∫ 
Length
∫∫ !
<
∫∫" #
$num
∫∫$ %
)
∫∫% &
return
ªª 
(
ªª 
null
ªª 
,
ªª 

BadRequest
ªª (
(
ªª( )
new
ªª) ,
{
ªª- .
message
ªª/ 6
=
ªª7 8
$str
ªª9 N
}
ªªO P
)
ªªP Q
)
ªªQ R
;
ªªR S
var
ºº 
	macSuffix
ºº 
=
ºº 

normalized
ºº &
.
ºº& '
	Substring
ºº' 0
(
ºº0 1

normalized
ºº1 ;
.
ºº; <
Length
ºº< B
-
ººC D
$num
ººE F
)
ººF G
;
ººG H
var
ΩΩ 
	speedMbps
ΩΩ 
=
ΩΩ 
	macSuffix
ΩΩ %
switch
ΩΩ& ,
{
ææ 
$str
øø 
=>
øø 
$num
øø 
,
øø 
$str
¿¿ 
=>
¿¿ 
$num
¿¿ 
,
¿¿ 
$str
¡¡ 
=>
¡¡ 
$num
¡¡ 
,
¡¡ 
$str
¬¬ 
=>
¬¬ 
$num
¬¬ 
,
¬¬ 
_
√√ 
=>
√√ 
$num
√√ 
}
ƒƒ 
;
ƒƒ 
if
∆∆ 
(
∆∆ 
	speedMbps
∆∆ 
==
∆∆ 
$num
∆∆ 
)
∆∆ 
return
«« 
(
«« 
null
«« 
,
«« 

BadRequest
«« (
(
««( )
new
««) ,
{
««- .
message
««/ 6
=
««7 8
$str««9 ë
}««í ì
)««ì î
)««î ï
;««ï ñ
var
…… 
plan
…… 
=
…… 
await
…… 
_context
…… %
.
……% &
SubscriptionPlans
……& 7
.
   
AsNoTracking
   
(
   
)
   
.
ÀÀ 
Where
ÀÀ 
(
ÀÀ 
p
ÀÀ 
=>
ÀÀ 
p
ÀÀ 
.
ÀÀ 
	SpeedMbps
ÀÀ '
==
ÀÀ( *
	speedMbps
ÀÀ+ 4
)
ÀÀ4 5
.
ÃÃ 
Select
ÃÃ 
(
ÃÃ 
p
ÃÃ 
=>
ÃÃ 
new
ÃÃ  
{
ÃÃ! "
p
ÃÃ# $
.
ÃÃ$ %
PlanID
ÃÃ% +
}
ÃÃ, -
)
ÃÃ- .
.
ÕÕ !
FirstOrDefaultAsync
ÕÕ $
(
ÕÕ$ %
)
ÕÕ% &
;
ÕÕ& '
if
ŒŒ 
(
ŒŒ 
plan
ŒŒ 
==
ŒŒ 
null
ŒŒ 
)
ŒŒ 
return
œœ 
(
œœ 
null
œœ 
,
œœ 

BadRequest
œœ (
(
œœ( )
new
œœ) ,
{
œœ- .
message
œœ/ 6
=
œœ7 8
$strœœ9 Ö
}œœÜ á
)œœá à
)œœà â
;œœâ ä
return
—— 
(
—— 
plan
—— 
.
—— 
PlanID
—— 
,
——  
null
——! %
)
——% &
;
——& '
}
““ 	
private
‘‘ 
async
‘‘ 
Task
‘‘ %
CreateSubscriptionAsync
‘‘ 2
(
‘‘2 3
int
‘‘3 6
serviceAccountId
‘‘7 G
,
‘‘G H
string
‘‘I O
userId
‘‘P V
,
‘‘V W
int
‘‘X [
planId
‘‘\ b
)
‘‘b c
{
’’ 	
var
÷÷ 
subscription
÷÷ 
=
÷÷ 
new
÷÷ "
Subscription
÷÷# /
{
◊◊ 
ServiceAccountID
ÿÿ  
=
ÿÿ! "
serviceAccountId
ÿÿ# 3
,
ÿÿ3 4
PlanID
ŸŸ 
=
ŸŸ 
planId
ŸŸ 
,
ŸŸ  
UserID
⁄⁄ 
=
⁄⁄ 
userId
⁄⁄ 
,
⁄⁄  
	StartDate
€€ 
=
€€ 
DateTime
€€ $
.
€€$ %
UtcNow
€€% +
,
€€+ ,
Status
‹‹ 
=
‹‹ 
StatusActive
‹‹ %
}
›› 
;
›› 
_context
ﬁﬁ 
.
ﬁﬁ 
Subscriptions
ﬁﬁ "
.
ﬁﬁ" #
Add
ﬁﬁ# &
(
ﬁﬁ& '
subscription
ﬁﬁ' 3
)
ﬁﬁ3 4
;
ﬁﬁ4 5
await
ﬂﬂ 
_context
ﬂﬂ 
.
ﬂﬂ 
SaveChangesAsync
ﬂﬂ +
(
ﬂﬂ+ ,
)
ﬂﬂ, -
;
ﬂﬂ- .
}
‡‡ 	
private
‚‚ 
async
‚‚ 
Task
‚‚ #
UpdateOnboardingAsync
‚‚ 0
(
‚‚0 1
string
‚‚1 7
?
‚‚7 8
userId
‚‚9 ?
)
‚‚? @
{
„„ 	
var
‰‰ 

onboarding
‰‰ 
=
‰‰ 
await
‰‰ "
_context
‰‰# +
.
‰‰+ , 
OnboardingStatuses
‰‰, >
.
‰‰> ?!
FirstOrDefaultAsync
‰‰? R
(
‰‰R S
o
‰‰S T
=>
‰‰U W
o
‰‰X Y
.
‰‰Y Z
UserID
‰‰Z `
==
‰‰a c
userId
‰‰d j
)
‰‰j k
;
‰‰k l
if
ÂÂ 
(
ÂÂ 

onboarding
ÂÂ 
!=
ÂÂ 
null
ÂÂ "
)
ÂÂ" #

onboarding
ÊÊ 
.
ÊÊ !
HasRegisteredDevice
ÊÊ .
=
ÊÊ/ 0
true
ÊÊ1 5
;
ÊÊ5 6
await
ËË 
_context
ËË 
.
ËË 
SaveChangesAsync
ËË +
(
ËË+ ,
)
ËË, -
;
ËË- .
}
ÈÈ 	
[
ÎÎ 	
	Authorize
ÎÎ	 
]
ÎÎ 
[
ÏÏ 	&
RequireEmailVerification
ÏÏ	 !
]
ÏÏ! "
[
ÌÌ 	
HttpPost
ÌÌ	 
(
ÌÌ 
$str
ÌÌ %
)
ÌÌ% &
]
ÌÌ& '
public
ÓÓ 
async
ÓÓ 
Task
ÓÓ 
<
ÓÓ 
IActionResult
ÓÓ '
>
ÓÓ' (
CompleteTutorial
ÓÓ) 9
(
ÓÓ9 :
)
ÓÓ: ;
{
ÔÔ 	
var
 
userId
 
=
 
User
 
.
 
	FindFirst
 '
(
' (
System
( .
.
. /
Security
/ 7
.
7 8
Claims
8 >
.
> ?

ClaimTypes
? I
.
I J
NameIdentifier
J X
)
X Y
?
Y Z
.
Z [
Value
[ `
;
` a
var
ÒÒ 
activeSubCount
ÒÒ 
=
ÒÒ  
await
ÒÒ! &
_context
ÒÒ' /
.
ÒÒ/ 0
Subscriptions
ÒÒ0 =
.
ÚÚ 

CountAsync
ÚÚ 
(
ÚÚ 
s
ÚÚ 
=>
ÚÚ  
s
ÚÚ! "
.
ÚÚ" #
UserID
ÚÚ# )
==
ÚÚ* ,
userId
ÚÚ- 3
&&
ÚÚ4 6
s
ÚÚ7 8
.
ÚÚ8 9
Status
ÚÚ9 ?
==
ÚÚ@ B
StatusActive
ÚÚC O
)
ÚÚO P
;
ÚÚP Q
var
ÛÛ 
activePrepCount
ÛÛ 
=
ÛÛ  !
await
ÛÛ" '
_context
ÛÛ( 0
.
ÛÛ0 1
Devices
ÛÛ1 8
.
ÙÙ 
Where
ÙÙ 
(
ÙÙ 
d
ÙÙ 
=>
ÙÙ 
d
ÙÙ 
.
ÙÙ 
UserID
ÙÙ $
==
ÙÙ% '
userId
ÙÙ( .
)
ÙÙ. /
.
ıı 

SelectMany
ıı 
(
ıı 
d
ıı 
=>
ıı  
d
ıı! "
.
ıı" #
ServiceAccounts
ıı# 2
)
ıı2 3
.
ˆˆ 
Where
ˆˆ 
(
ˆˆ 
sa
ˆˆ 
=>
ˆˆ 
sa
ˆˆ 
.
ˆˆ  
Status
ˆˆ  &
==
ˆˆ' )
StatusActive
ˆˆ* 6
&&
ˆˆ7 9
sa
ˆˆ: <
.
ˆˆ< =
ServiceType
ˆˆ= H
==
ˆˆI K
ServicePrepaid
ˆˆL Z
)
ˆˆZ [
.
˜˜ 

CountAsync
˜˜ 
(
˜˜ 
)
˜˜ 
;
˜˜ 
if
˘˘ 
(
˘˘ 
activeSubCount
˘˘ 
+
˘˘  
activePrepCount
˘˘! 0
>=
˘˘1 3
$num
˘˘4 5
)
˘˘5 6
return
˙˙ 

BadRequest
˙˙ !
(
˙˙! "
new
˙˙" %
{
˙˙& '
message
˙˙( /
=
˙˙0 1
$str
˙˙2 l
}
˙˙m n
)
˙˙n o
;
˙˙o p
var
¸¸ 

onboarding
¸¸ 
=
¸¸ 
await
¸¸ "
_context
¸¸# +
.
¸¸+ , 
OnboardingStatuses
¸¸, >
.
¸¸> ?!
FirstOrDefaultAsync
¸¸? R
(
¸¸R S
o
¸¸S T
=>
¸¸U W
o
¸¸X Y
.
¸¸Y Z
UserID
¸¸Z `
==
¸¸a c
userId
¸¸d j
)
¸¸j k
;
¸¸k l
if
˝˝ 
(
˝˝ 

onboarding
˝˝ 
==
˝˝ 
null
˝˝ "
)
˝˝" #
return
˛˛ 
NotFound
˛˛ 
(
˛˛  
new
˛˛  #
{
˛˛$ %
message
˛˛& -
=
˛˛. /
$str
˛˛0 M
}
˛˛N O
)
˛˛O P
;
˛˛P Q

onboarding
ÄÄ 
.
ÄÄ "
HasCompletedTutorial
ÄÄ +
=
ÄÄ, -
true
ÄÄ. 2
;
ÄÄ2 3
await
ÅÅ 
_context
ÅÅ 
.
ÅÅ 
SaveChangesAsync
ÅÅ +
(
ÅÅ+ ,
)
ÅÅ, -
;
ÅÅ- .
return
ÉÉ 
Ok
ÉÉ 
(
ÉÉ 
new
ÉÉ 
{
ÉÉ 
message
ÉÉ #
=
ÉÉ$ %
$str
ÉÉ& G
}
ÉÉH I
)
ÉÉI J
;
ÉÉJ K
}
ÑÑ 	
[
ÜÜ 	
HttpPost
ÜÜ	 
(
ÜÜ 
$str
ÜÜ #
)
ÜÜ# $
]
ÜÜ$ %
public
áá 
async
áá 
Task
áá 
<
áá 
IActionResult
áá '
>
áá' (
ForgotPassword
áá) 7
(
áá7 8
[
áá8 9
FromBody
áá9 A
]
ááA B 
VerifyEmailRequest
ááC U
request
ááV ]
)
áá] ^
{
àà 	
var
ââ 
user
ââ 
=
ââ 
await
ââ 
_userManager
ââ )
.
ââ) *
FindByEmailAsync
ââ* :
(
ââ: ;
request
ââ; B
.
ââB C
Email
ââC H
)
ââH I
;
ââI J
if
ää 
(
ää 
user
ää 
==
ää 
null
ää 
)
ää 
return
ãã 
Ok
ãã 
(
ãã 
new
ãã 
{
ãã 
message
ãã  '
=
ãã( )
$str
ãã* [
}
ãã\ ]
)
ãã] ^
;
ãã^ _
var
çç 
code
çç 
=
çç 
new
çç 
Random
çç !
(
çç! "
)
çç" #
.
çç# $
Next
çç$ (
(
çç( )
$num
çç) /
,
çç/ 0
$num
çç1 7
)
çç7 8
.
çç8 9
ToString
çç9 A
(
ççA B
)
ççB C
;
ççC D
_context
éé 
.
éé 
VerificationCodes
éé &
.
éé& '
Add
éé' *
(
éé* +
new
éé+ .
VerificationCode
éé/ ?
{
èè 
Email
êê 
=
êê 
request
êê 
.
êê  
Email
êê  %
,
êê% &
Code
ëë 
=
ëë 
code
ëë 
,
ëë 
	ExpiresAt
íí 
=
íí 
DateTime
íí $
.
íí$ %
UtcNow
íí% +
.
íí+ ,

AddMinutes
íí, 6
(
íí6 7
$num
íí7 9
)
íí9 :
}
ìì 
)
ìì 
;
ìì 
await
îî 
_context
îî 
.
îî 
SaveChangesAsync
îî +
(
îî+ ,
)
îî, -
;
îî- .
await
ïï 
_emailService
ïï 
.
ïï  '
SendVerificationCodeAsync
ïï  9
(
ïï9 :
request
ïï: A
.
ïïA B
Email
ïïB G
,
ïïG H
code
ïïI M
)
ïïM N
;
ïïN O
return
óó 
Ok
óó 
(
óó 
new
óó 
{
óó 
message
óó #
=
óó$ %
$str
óó& E
}
óóF G
)
óóG H
;
óóH I
}
òò 	
[
öö 	
HttpPost
öö	 
(
öö 
$str
öö "
)
öö" #
]
öö# $
public
õõ 
async
õõ 
Task
õõ 
<
õõ 
IActionResult
õõ '
>
õõ' (
ResetPassword
õõ) 6
(
õõ6 7
[
õõ7 8
FromBody
õõ8 @
]
õõ@ A"
ResetPasswordRequest
õõB V
request
õõW ^
,
õõ^ _
[
õõ` a

FromHeader
õõa k
(
õõk l
Name
õõl p
=
õõq r
$str
õõs 
)õõ Ä
]õõÄ Å
stringõõÇ à
?õõà â
	userAgentõõä ì
)õõì î
{
úú 	
var
ùù 
userAgentValue
ùù 
=
ùù  
	userAgent
ùù! *
??
ùù+ -
string
ùù. 4
.
ùù4 5
Empty
ùù5 :
;
ùù: ;
var
ûû 
	ipAddress
ûû 
=
ûû 
HttpContext
ûû '
.
ûû' (

Connection
ûû( 2
.
ûû2 3
RemoteIpAddress
ûû3 B
?
ûûB C
.
ûûC D
ToString
ûûD L
(
ûûL M
)
ûûM N
;
ûûN O
if
üü 
(
üü (
_ipDeviceReputationService
üü *
.
üü* +
	IsBlocked
üü+ 4
(
üü4 5
	ipAddress
üü5 >
,
üü> ?
userAgentValue
üü@ N
,
üüN O
out
üüP S
var
üüT W
blockReason
üüX c
)
üüc d
)
üüd e
return
†† 

StatusCode
†† !
(
††! "
$num
††" %
,
††% &
new
††' *
{
††+ ,
message
††- 4
=
††5 6
$"
††7 9
$str
††9 I
{
††I J
blockReason
††J U
}
††U V
$str
††V o
"
††o p
}
††q r
)
††r s
;
††s t
var
¢¢ 
verification
¢¢ 
=
¢¢ 
await
¢¢ $
_context
¢¢% -
.
¢¢- .
VerificationCodes
¢¢. ?
.
££ !
FirstOrDefaultAsync
££ $
(
££$ %
v
££% &
=>
££' )
v
££* +
.
££+ ,
Email
££, 1
==
££2 4
request
££5 <
.
££< =
Email
££= B
&&
££C E
v
££F G
.
££G H
Code
££H L
==
££M O
request
££P W
.
££W X
Code
££X \
&&
££] _
!
££` a
v
££a b
.
££b c
IsUsed
££c i
&&
££j l
v
££m n
.
££n o
	ExpiresAt
££o x
>
££y z
DateTime££{ É
.££É Ñ
UtcNow££Ñ ä
)££ä ã
;££ã å
if
•• 
(
•• 
verification
•• 
==
•• 
null
••  $
)
••$ %
{
¶¶ (
_ipDeviceReputationService
ßß *
.
ßß* +
RegisterFailure
ßß+ :
(
ßß: ;
	ipAddress
ßß; D
,
ßßD E
userAgentValue
ßßF T
)
ßßT U
;
ßßU V
return
®® 

BadRequest
®® !
(
®®! "
new
®®" %
{
®®& '
message
®®( /
=
®®0 1
$str
®®2 Q
}
®®R S
)
®®S T
;
®®T U
}
©© 
var
´´ 
user
´´ 
=
´´ 
await
´´ 
_userManager
´´ )
.
´´) *
FindByEmailAsync
´´* :
(
´´: ;
request
´´; B
.
´´B C
Email
´´C H
)
´´H I
;
´´I J
if
¨¨ 
(
¨¨ 
user
¨¨ 
==
¨¨ 
null
¨¨ 
)
¨¨ 
{
≠≠ (
_ipDeviceReputationService
ÆÆ *
.
ÆÆ* +
RegisterFailure
ÆÆ+ :
(
ÆÆ: ;
	ipAddress
ÆÆ; D
,
ÆÆD E
userAgentValue
ÆÆF T
)
ÆÆT U
;
ÆÆU V
return
ØØ 
NotFound
ØØ 
(
ØØ  
new
ØØ  #
{
ØØ$ %
message
ØØ& -
=
ØØ. /!
MessageUserNotFound
ØØ0 C
}
ØØD E
)
ØØE F
;
ØØF G
}
∞∞ 
if
≤≤ 
(
≤≤ 
await
≤≤ $
_passwordBreachService
≤≤ ,
.
≤≤, -
IsBreachedAsync
≤≤- <
(
≤≤< =
request
≤≤= D
.
≤≤D E
NewPassword
≤≤E P
)
≤≤P Q
)
≤≤Q R
return
≥≥ 

BadRequest
≥≥ !
(
≥≥! "
new
≥≥" %
{
≥≥& '
message
≥≥( /
=
≥≥0 1
$str≥≥2 Ä
}≥≥Å Ç
)≥≥Ç É
;≥≥É Ñ
var
µµ 
token
µµ 
=
µµ 
await
µµ 
_userManager
µµ *
.
µµ* +-
GeneratePasswordResetTokenAsync
µµ+ J
(
µµJ K
user
µµK O
)
µµO P
;
µµP Q
var
∂∂ 
result
∂∂ 
=
∂∂ 
await
∂∂ 
_userManager
∂∂ +
.
∂∂+ , 
ResetPasswordAsync
∂∂, >
(
∂∂> ?
user
∂∂? C
,
∂∂C D
token
∂∂E J
,
∂∂J K
request
∂∂L S
.
∂∂S T
NewPassword
∂∂T _
)
∂∂_ `
;
∂∂` a
if
∏∏ 
(
∏∏ 
!
∏∏ 
result
∏∏ 
.
∏∏ 
	Succeeded
∏∏ !
)
∏∏! "
{
ππ (
_ipDeviceReputationService
∫∫ *
.
∫∫* +
RegisterFailure
∫∫+ :
(
∫∫: ;
	ipAddress
∫∫; D
,
∫∫D E
userAgentValue
∫∫F T
)
∫∫T U
;
∫∫U V
return
ªª 

BadRequest
ªª !
(
ªª! "
new
ªª" %
{
ªª& '
message
ªª( /
=
ªª0 1
string
ªª2 8
.
ªª8 9
Join
ªª9 =
(
ªª= >
$str
ªª> B
,
ªªB C
result
ªªD J
.
ªªJ K
Errors
ªªK Q
.
ªªQ R
Select
ªªR X
(
ªªX Y
e
ªªY Z
=>
ªª[ ]
e
ªª^ _
.
ªª_ `
Description
ªª` k
)
ªªk l
)
ªªl m
}
ªªn o
)
ªªo p
;
ªªp q
}
ºº 
verification
ææ 
.
ææ 
IsUsed
ææ 
=
ææ  !
true
ææ" &
;
ææ& '
await
øø 
_context
øø 
.
øø 
SaveChangesAsync
øø +
(
øø+ ,
)
øø, -
;
øø- .(
_ipDeviceReputationService
¡¡ &
.
¡¡& '
RegisterSuccess
¡¡' 6
(
¡¡6 7
	ipAddress
¡¡7 @
,
¡¡@ A
userAgentValue
¡¡B P
)
¡¡P Q
;
¡¡Q R
return
√√ 
Ok
√√ 
(
√√ 
new
√√ 
{
√√ 
message
√√ #
=
√√$ %
$str
√√& C
}
√√D E
)
√√E F
;
√√F G
}
ƒƒ 	
}
≈≈ 
public
«« 

class
«« #
RegisterDeviceRequest
«« &
{
»» 
public
…… 
string
…… 
?
…… 

MacAddress
…… !
{
……" #
get
……$ '
;
……' (
set
……) ,
;
……, -
}
……. /
public
   
string
   
ServiceType
   !
{
  " #
get
  $ '
;
  ' (
set
  ) ,
;
  , -
}
  . /
=
  0 1
string
  2 8
.
  8 9
Empty
  9 >
;
  > ?
public
ÀÀ 
int
ÀÀ 
?
ÀÀ 
PlanID
ÀÀ 
{
ÀÀ 
get
ÀÀ  
;
ÀÀ  !
set
ÀÀ" %
;
ÀÀ% &
}
ÀÀ' (
public
ÃÃ 
string
ÃÃ 
?
ÃÃ 
PhoneNumber
ÃÃ "
{
ÃÃ# $
get
ÃÃ% (
;
ÃÃ( )
set
ÃÃ* -
;
ÃÃ- .
}
ÃÃ/ 0
}
ÕÕ 
public
œœ 

class
œœ #
Verify2FALoginRequest
œœ &
{
–– 
public
—— 
string
—— 
Email
—— 
{
—— 
get
—— !
;
——! "
set
——# &
;
——& '
}
——( )
=
——* +
string
——, 2
.
——2 3
Empty
——3 8
;
——8 9
public
““ 
string
““ 
Code
““ 
{
““ 
get
““  
;
““  !
set
““" %
;
““% &
}
““' (
=
““) *
string
““+ 1
.
““1 2
Empty
““2 7
;
““7 8
}
”” 
}‘‘ Œæ
VE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\AdminController.cs
	namespace		 	"
TayoKonnektado_project		
  
.		  !
Controllers		! ,
{

 
[ 
	Authorize 
( 
Roles 
= 
$str /
)/ 0
]0 1
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public 

class 
AdminController  
:! "
ControllerBase# 1
{ 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
private 
readonly %
CustomerManagementService 2
_customerService3 C
;C D
private 
readonly #
TicketManagementService 0
_ticketService1 ?
;? @
private 
readonly $
PaymentManagementService 1
_paymentService2 A
;A B
private 
readonly )
SubscriptionManagementService 6 
_subscriptionService7 K
;K L
private 
readonly "
StaffManagementService /
_staffService0 =
;= >
private 
readonly 
DashboardService )
_dashboardService* ;
;; <
private 
readonly !
PlanManagementService .
_planService/ ;
;; <
private 
readonly  
FAQManagementService -
_faqService. 9
;9 :
public 
AdminController 
(  
ApplicationDbContext  
context! (
,( )%
CustomerManagementService %
customerService& 5
,5 6#
TicketManagementService #
ticketService$ 1
,1 2$
PaymentManagementService $
paymentService% 3
,3 4)
SubscriptionManagementService )
subscriptionService* =
,= >"
StaffManagementService   "
staffService  # /
,  / 0
DashboardService!! 
dashboardService!! -
,!!- .!
PlanManagementService"" !
planService""" -
,""- . 
FAQManagementService##  

faqService##! +
)##+ ,
{$$ 	
_context%% 
=%% 
context%% 
;%% 
_customerService&& 
=&& 
customerService&& .
;&&. /
_ticketService'' 
='' 
ticketService'' *
;''* +
_paymentService(( 
=(( 
paymentService(( ,
;((, - 
_subscriptionService))  
=))! "
subscriptionService))# 6
;))6 7
_staffService** 
=** 
staffService** (
;**( )
_dashboardService++ 
=++ 
dashboardService++  0
;++0 1
_planService,, 
=,, 
planService,, &
;,,& '
_faqService-- 
=-- 

faqService-- $
;--$ %
}.. 	
[00 	
	Authorize00	 
(00 
Roles00 
=00 
$str00 -
)00- .
]00. /
[11 	
HttpGet11	 
(11 
$str11 
)11 
]11 
public22 
async22 
Task22 
<22 
IActionResult22 '
>22' (
GetCustomers22) 5
(225 6
)226 7
=>228 :
Ok22; =
(22= >
await22> C
_customerService22D T
.22T U 
GetAllCustomersAsync22U i
(22i j
)22j k
)22k l
;22l m
[44 	
	Authorize44	 
(44 
Roles44 
=44 
$str44 -
)44- .
]44. /
[55 	
HttpGet55	 
(55 
$str55 !
)55! "
]55" #
public66 
async66 
Task66 
<66 
IActionResult66 '
>66' (
GetCustomer66) 4
(664 5
string665 ;
id66< >
)66> ?
{77 	
var88 
customer88 
=88 
await88  
_customerService88! 1
.881 2 
GetCustomerByIdAsync882 F
(88F G
id88G I
)88I J
;88J K
return99 
customer99 
==99 
null99 #
?99$ %
NotFound99& .
(99. /
)99/ 0
:991 2
Ok993 5
(995 6
customer996 >
)99> ?
;99? @
}:: 	
[<< 	
	Authorize<<	 
(<< 
Roles<< 
=<< 
$str<< -
)<<- .
]<<. /
[== 	
HttpPut==	 
(== 
$str== !
)==! "
]==" #
public>> 
async>> 
Task>> 
<>> 
IActionResult>> '
>>>' (
UpdateCustomer>>) 7
(>>7 8
string>>8 >
id>>? A
,>>A B
[>>C D
FromBody>>D L
]>>L M!
UpdateCustomerRequest>>N c
request>>d k
)>>k l
{?? 	
var@@ 
success@@ 
=@@ 
await@@ 
_customerService@@  0
.@@0 1
UpdateCustomerAsync@@1 D
(@@D E
id@@E G
,@@G H
request@@I P
.@@P Q
	FirstName@@Q Z
,@@Z [
request@@\ c
.@@c d
LastName@@d l
,@@l m
request@@n u
.@@u v
Email@@v {
,@@{ |
request	@@} Ñ
.
@@Ñ Ö
Status
@@Ö ã
)
@@ã å
;
@@å ç
returnAA 
successAA 
?AA 
OkAA 
(AA  
newAA  #
{AA$ %
messageAA& -
=AA. /
$strAA0 O
}AAP Q
)AAQ R
:AAS T
NotFoundAAU ]
(AA] ^
)AA^ _
;AA_ `
}BB 	
[DD 	
	AuthorizeDD	 
(DD 
RolesDD 
=DD 
$strDD '
)DD' (
]DD( )
[EE 	

HttpDeleteEE	 
(EE 
$strEE $
)EE$ %
]EE% &
publicFF 
asyncFF 
TaskFF 
<FF 
IActionResultFF '
>FF' (
DeleteCustomerFF) 7
(FF7 8
stringFF8 >
idFF? A
)FFA B
{GG 	
varHH 
successHH 
=HH 
awaitHH 
_customerServiceHH  0
.HH0 1
DeleteCustomerAsyncHH1 D
(HHD E
idHHE G
)HHG H
;HHH I
returnII 
successII 
?II 
OkII 
(II  
newII  #
{II$ %
messageII& -
=II. /
$strII0 O
}IIP Q
)IIQ R
:IIS T
NotFoundIIU ]
(II] ^
)II^ _
;II_ `
}JJ 	
[LL 	
	AuthorizeLL	 
(LL 
RolesLL 
=LL 
$strLL 3
)LL3 4
]LL4 5
[MM 	
HttpGetMM	 
(MM 
$strMM 
)MM 
]MM 
publicNN 
asyncNN 
TaskNN 
<NN 
IActionResultNN '
>NN' (
GetAllTicketsNN) 6
(NN6 7
)NN7 8
=>NN9 ;
OkNN< >
(NN> ?
awaitNN? D
_ticketServiceNNE S
.NNS T
GetAllTicketsAsyncNNT f
(NNf g
)NNg h
)NNh i
;NNi j
[PP 	
HttpPutPP	 
(PP 
$strPP 
)PP  
]PP  !
publicQQ 
asyncQQ 
TaskQQ 
<QQ 
IActionResultQQ '
>QQ' (
UpdateTicketQQ) 5
(QQ5 6
intQQ6 9
idQQ: <
,QQ< =
[QQ> ?
FromBodyQQ? G
]QQG H
UpdateTicketRequestQQI \
requestQQ] d
)QQd e
{RR 	
varSS 
successSS 
=SS 
awaitSS 
_ticketServiceSS  .
.SS. /
UpdateTicketAsyncSS/ @
(SS@ A
idSSA C
,SSC D
requestSSE L
.SSL M
StatusSSM S
,SSS T
requestSSU \
.SS\ ]
AssignedStaffIDSS] l
)SSl m
;SSm n
returnTT 
successTT 
?TT 
OkTT 
(TT  
newTT  #
{TT$ %
messageTT& -
=TT. /
$strTT0 M
}TTN O
)TTO P
:TTQ R
NotFoundTTS [
(TT[ \
)TT\ ]
;TT] ^
}UU 	
[WW 	
HttpPostWW	 
(WW 
$strWW &
)WW& '
]WW' (
publicXX 
asyncXX 
TaskXX 
<XX 
IActionResultXX '
>XX' (
ReplyToTicketXX) 6
(XX6 7
intXX7 :
idXX; =
,XX= >
[XX? @
FromBodyXX@ H
]XXH I
ReplyTicketRequestXXJ \
requestXX] d
)XXd e
{YY 	
varZZ 
userIdZZ 
=ZZ 
UserZZ 
.ZZ 
	FindFirstZZ '
(ZZ' (
SystemZZ( .
.ZZ. /
SecurityZZ/ 7
.ZZ7 8
ClaimsZZ8 >
.ZZ> ?

ClaimTypesZZ? I
.ZZI J
NameIdentifierZZJ X
)ZZX Y
?ZZY Z
.ZZZ [
ValueZZ[ `
;ZZ` a
if[[ 
([[ 
userId[[ 
==[[ 
null[[ 
)[[ 
return[[  &
Unauthorized[[' 3
([[3 4
)[[4 5
;[[5 6
var]] 
success]] 
=]] 
await]] 
_ticketService]]  .
.]]. /
ReplyToTicketAsync]]/ A
(]]A B
id]]B D
,]]D E
userId]]F L
,]]L M
request]]N U
.]]U V
Message]]V ]
)]]] ^
;]]^ _
return^^ 
success^^ 
?^^ 
Ok^^ 
(^^  
new^^  #
{^^$ %
message^^& -
=^^. /
$str^^0 I
}^^J K
)^^K L
:^^M N
NotFound^^O W
(^^W X
)^^X Y
;^^Y Z
}__ 	
[aa 	
HttpPostaa	 
(aa 
$straa (
)aa( )
]aa) *
publicbb 
asyncbb 
Taskbb 
<bb 
IActionResultbb '
>bb' (
ArchiveTicketbb) 6
(bb6 7
intbb7 :
idbb; =
)bb= >
{cc 	
vardd 
successdd 
=dd 
awaitdd 
_ticketServicedd  .
.dd. /
ArchiveTicketAsyncdd/ A
(ddA B
idddB D
)ddD E
;ddE F
returnee 
successee 
?ee 
Okee 
(ee  
newee  #
{ee$ %
messageee& -
=ee. /
$stree0 N
}eeO P
)eeP Q
:eeR S

BadRequesteeT ^
(ee^ _
newee_ b
{eec d
messageeee l
=eem n
$str	eeo î
}
eeï ñ
)
eeñ ó
;
eeó ò
}ff 	
[hh 	
HttpPosthh	 
(hh 
$strhh *
)hh* +
]hh+ ,
publicii 
asyncii 
Taskii 
<ii 
IActionResultii '
>ii' (
UnarchiveTicketii) 8
(ii8 9
intii9 <
idii= ?
)ii? @
{jj 	
varkk 
successkk 
=kk 
awaitkk 
_ticketServicekk  .
.kk. / 
UnarchiveTicketAsynckk/ C
(kkC D
idkkD F
)kkF G
;kkG H
returnll 
successll 
?ll 
Okll 
(ll  
newll  #
{ll$ %
messagell& -
=ll. /
$strll0 N
}llO P
)llP Q
:llR S
NotFoundllT \
(ll\ ]
)ll] ^
;ll^ _
}mm 	
[oo 	

HttpDeleteoo	 
(oo 
$stroo "
)oo" #
]oo# $
publicpp 
asyncpp 
Taskpp 
<pp 
IActionResultpp '
>pp' (
DeleteTicketpp) 5
(pp5 6
intpp6 9
idpp: <
)pp< =
{qq 	
varrr 
successrr 
=rr 
awaitrr 
_ticketServicerr  .
.rr. /
DeleteTicketAsyncrr/ @
(rr@ A
idrrA C
)rrC D
;rrD E
returnss 
successss 
?ss 
Okss 
(ss  
newss  #
{ss$ %
messagess& -
=ss. /
$strss0 M
}ssN O
)ssO P
:ssQ R

BadRequestssS ]
(ss] ^
newss^ a
{ssb c
messagessd k
=ssl m
$str	ssn í
}
ssì î
)
ssî ï
;
ssï ñ
}tt 	
[vv 	
	Authorizevv	 
(vv 
Rolesvv 
=vv 
$strvv 3
)vv3 4
]vv4 5
[ww 	
HttpGetww	 
(ww 
$strww 
)ww 
]ww 
publicxx 
asyncxx 
Taskxx 
<xx 
IActionResultxx '
>xx' (
GetAllPaymentsxx) 7
(xx7 8
)xx8 9
=>xx: <
Okxx= ?
(xx? @
awaitxx@ E
_paymentServicexxF U
.xxU V
GetAllPaymentsAsyncxxV i
(xxi j
)xxj k
)xxk l
;xxl m
[zz 	
HttpPostzz	 
(zz 
$strzz )
)zz) *
]zz* +
public{{ 
async{{ 
Task{{ 
<{{ 
IActionResult{{ '
>{{' (
ApprovePayment{{) 7
({{7 8
int{{8 ;
id{{< >
){{> ?
{|| 	
var}} 
(}} 
success}} 
,}} 
message}} !
)}}! "
=}}# $
await}}% *
_paymentService}}+ :
.}}: ;
ApprovePaymentAsync}}; N
(}}N O
id}}O Q
)}}Q R
;}}R S
return~~ 
success~~ 
?~~ 
Ok~~ 
(~~  
new~~  #
{~~$ %
message~~& -
}~~. /
)~~/ 0
:~~1 2

BadRequest~~3 =
(~~= >
new~~> A
{~~B C
message~~D K
}~~L M
)~~M N
;~~N O
} 	
[
ÅÅ 	
HttpPost
ÅÅ	 
(
ÅÅ 
$str
ÅÅ )
)
ÅÅ) *
]
ÅÅ* +
public
ÇÇ 
async
ÇÇ 
Task
ÇÇ 
<
ÇÇ 
IActionResult
ÇÇ '
>
ÇÇ' (
ConfirmPayment
ÇÇ) 7
(
ÇÇ7 8
int
ÇÇ8 ;
id
ÇÇ< >
)
ÇÇ> ?
=>
ÇÇ@ B
await
ÇÇC H
ApprovePayment
ÇÇI W
(
ÇÇW X
id
ÇÇX Z
)
ÇÇZ [
;
ÇÇ[ \
[
ÑÑ 	
HttpPost
ÑÑ	 
(
ÑÑ 
$str
ÑÑ (
)
ÑÑ( )
]
ÑÑ) *
public
ÖÖ 
async
ÖÖ 
Task
ÖÖ 
<
ÖÖ 
IActionResult
ÖÖ '
>
ÖÖ' (
RejectPayment
ÖÖ) 6
(
ÖÖ6 7
int
ÖÖ7 :
id
ÖÖ; =
)
ÖÖ= >
{
ÜÜ 	
var
áá 
success
áá 
=
áá 
await
áá 
_paymentService
áá  /
.
áá/ 0 
RejectPaymentAsync
áá0 B
(
ááB C
id
ááC E
)
ááE F
;
ááF G
return
àà 
success
àà 
?
àà 
Ok
àà 
(
àà  
new
àà  #
{
àà$ %
message
àà& -
=
àà. /
$str
àà0 B
}
ààC D
)
ààD E
:
ààF G

BadRequest
ààH R
(
ààR S
new
ààS V
{
ààW X
message
ààY `
=
ààa b
$str
ààc {
}
àà| }
)
àà} ~
;
àà~ 
}
ââ 	
[
ãã 	
HttpPost
ãã	 
(
ãã 
$str
ãã )
)
ãã) *
]
ãã* +
public
åå 
async
åå 
Task
åå 
<
åå 
IActionResult
åå '
>
åå' (
ArchivePayment
åå) 7
(
åå7 8
int
åå8 ;
id
åå< >
)
åå> ?
{
çç 	
var
éé 
success
éé 
=
éé 
await
éé 
_paymentService
éé  /
.
éé/ 0!
ArchivePaymentAsync
éé0 C
(
ééC D
id
ééD F
)
ééF G
;
ééG H
return
èè 
success
èè 
?
èè 
Ok
èè 
(
èè  
new
èè  #
{
èè$ %
message
èè& -
=
èè. /
$str
èè0 B
}
èèC D
)
èèD E
:
èèF G
NotFound
èèH P
(
èèP Q
)
èèQ R
;
èèR S
}
êê 	
[
íí 	
HttpPost
íí	 
(
íí 
$str
íí +
)
íí+ ,
]
íí, -
public
ìì 
async
ìì 
Task
ìì 
<
ìì 
IActionResult
ìì '
>
ìì' (
UnarchivePayment
ìì) 9
(
ìì9 :
int
ìì: =
id
ìì> @
)
ìì@ A
{
îî 	
var
ïï 
success
ïï 
=
ïï 
await
ïï 
_paymentService
ïï  /
.
ïï/ 0#
UnarchivePaymentAsync
ïï0 E
(
ïïE F
id
ïïF H
)
ïïH I
;
ïïI J
return
ññ 
success
ññ 
?
ññ 
Ok
ññ 
(
ññ  
new
ññ  #
{
ññ$ %
message
ññ& -
=
ññ. /
$str
ññ0 B
}
ññC D
)
ññD E
:
ññF G
NotFound
ññH P
(
ññP Q
)
ññQ R
;
ññR S
}
óó 	
[
ôô 	

HttpDelete
ôô	 
(
ôô 
$str
ôô #
)
ôô# $
]
ôô$ %
public
öö 
async
öö 
Task
öö 
<
öö 
IActionResult
öö '
>
öö' (
DeletePayment
öö) 6
(
öö6 7
int
öö7 :
id
öö; =
)
öö= >
{
õõ 	
var
úú 
success
úú 
=
úú 
await
úú 
_paymentService
úú  /
.
úú/ 0 
DeletePaymentAsync
úú0 B
(
úúB C
id
úúC E
)
úúE F
;
úúF G
return
ùù 
success
ùù 
?
ùù 
Ok
ùù 
(
ùù  
new
ùù  #
{
ùù$ %
message
ùù& -
=
ùù. /
$str
ùù0 A
}
ùùB C
)
ùùC D
:
ùùE F

BadRequest
ùùG Q
(
ùùQ R
new
ùùR U
{
ùùV W
message
ùùX _
=
ùù` a
$strùùb â
}ùùä ã
)ùùã å
;ùùå ç
}
ûû 	
[
†† 	
	Authorize
††	 
(
†† 
Roles
†† 
=
†† 
$str
†† 3
)
††3 4
]
††4 5
[
°° 	
HttpGet
°°	 
(
°° 
$str
°°  
)
°°  !
]
°°! "
public
¢¢ 
async
¢¢ 
Task
¢¢ 
<
¢¢ 
IActionResult
¢¢ '
>
¢¢' (!
GetAllSubscriptions
¢¢) <
(
¢¢< =
)
¢¢= >
=>
¢¢? A
Ok
¢¢B D
(
¢¢D E
await
¢¢E J"
_subscriptionService
¢¢K _
.
¢¢_ `&
GetAllSubscriptionsAsync
¢¢` x
(
¢¢x y
)
¢¢y z
)
¢¢z {
;
¢¢{ |
[
§§ 	
HttpPut
§§	 
(
§§ 
$str
§§ %
)
§§% &
]
§§& '
public
•• 
async
•• 
Task
•• 
<
•• 
IActionResult
•• '
>
••' ( 
UpdateSubscription
••) ;
(
••; <
int
••< ?
id
••@ B
,
••B C
[
••D E
FromBody
••E M
]
••M N'
UpdateSubscriptionRequest
••O h
request
••i p
)
••p q
{
¶¶ 	
try
ßß 
{
®® 
var
©© 
success
©© 
=
©© 
await
©© #"
_subscriptionService
©©$ 8
.
©©8 9%
UpdateSubscriptionAsync
©©9 P
(
©©P Q
id
©©Q S
,
©©S T
request
©©U \
.
©©\ ]
Status
©©] c
,
©©c d
request
©©e l
.
©©l m
PlanID
©©m s
,
©©s t
request
©©u |
.
©©| }
EndDate©©} Ñ
)©©Ñ Ö
;©©Ö Ü
return
™™ 
success
™™ 
?
™™  
Ok
™™! #
(
™™# $
new
™™$ '
{
™™( )
message
™™* 1
=
™™2 3
$str
™™4 W
}
™™X Y
)
™™Y Z
:
™™[ \
NotFound
™™] e
(
™™e f
)
™™f g
;
™™g h
}
´´ 
catch
¨¨ 
(
¨¨ 
	Exception
¨¨ 
ex
¨¨ 
)
¨¨  
{
≠≠ 
return
ÆÆ 

BadRequest
ÆÆ !
(
ÆÆ! "
new
ÆÆ" %
{
ÆÆ& '
message
ÆÆ( /
=
ÆÆ0 1
ex
ÆÆ2 4
.
ÆÆ4 5
Message
ÆÆ5 <
}
ÆÆ= >
)
ÆÆ> ?
;
ÆÆ? @
}
ØØ 
}
∞∞ 	
[
≤≤ 	

HttpDelete
≤≤	 
(
≤≤ 
$str
≤≤ (
)
≤≤( )
]
≤≤) *
public
≥≥ 
async
≥≥ 
Task
≥≥ 
<
≥≥ 
IActionResult
≥≥ '
>
≥≥' ( 
DeleteSubscription
≥≥) ;
(
≥≥; <
int
≥≥< ?
id
≥≥@ B
)
≥≥B C
{
¥¥ 	
try
µµ 
{
∂∂ 
var
∑∑ 
success
∑∑ 
=
∑∑ 
await
∑∑ #"
_subscriptionService
∑∑$ 8
.
∑∑8 9%
DeleteSubscriptionAsync
∑∑9 P
(
∑∑P Q
id
∑∑Q S
)
∑∑S T
;
∑∑T U
if
∏∏ 
(
∏∏ 
!
∏∏ 
success
∏∏ 
)
∏∏ 
{
ππ 
return
∫∫ 
NotFound
∫∫ #
(
∫∫# $
new
∫∫$ '
{
∫∫( )
message
∫∫* 1
=
∫∫2 3
$str
∫∫4 L
}
∫∫M N
)
∫∫N O
;
∫∫O P
}
ªª 
return
ºº 
Ok
ºº 
(
ºº 
new
ºº 
{
ºº 
message
ºº  '
=
ºº( )
$str
ºº* M
}
ººN O
)
ººO P
;
ººP Q
}
ΩΩ 
catch
ææ 
(
ææ 
	Exception
ææ 
ex
ææ 
)
ææ  
{
øø 
Console
¿¿ 
.
¿¿ 
	WriteLine
¿¿ !
(
¿¿! "
$"
¿¿" $
$str
¿¿$ ?
{
¿¿? @
ex
¿¿@ B
.
¿¿B C
Message
¿¿C J
}
¿¿J K
$str
¿¿K M
{
¿¿M N
ex
¿¿N P
.
¿¿P Q
InnerException
¿¿Q _
?
¿¿_ `
.
¿¿` a
Message
¿¿a h
}
¿¿h i
"
¿¿i j
)
¿¿j k
;
¿¿k l
return
¡¡ 

BadRequest
¡¡ !
(
¡¡! "
new
¡¡" %
{
¡¡& '
message
¡¡( /
=
¡¡0 1
ex
¡¡2 4
.
¡¡4 5
InnerException
¡¡5 C
?
¡¡C D
.
¡¡D E
Message
¡¡E L
??
¡¡M O
ex
¡¡P R
.
¡¡R S
Message
¡¡S Z
}
¡¡[ \
)
¡¡\ ]
;
¡¡] ^
}
¬¬ 
}
√√ 	
[
∆∆ 	
	Authorize
∆∆	 
(
∆∆ 
Roles
∆∆ 
=
∆∆ 
$str
∆∆ -
)
∆∆- .
]
∆∆. /
[
«« 	
HttpGet
««	 
(
«« 
$str
«« "
)
««" #
]
««# $
public
»» 
async
»» 
Task
»» 
<
»» 
IActionResult
»» '
>
»»' (
GetDashboardStats
»») :
(
»»: ;
)
»»; <
=>
»»= ?
Ok
»»@ B
(
»»B C
await
»»C H
_dashboardService
»»I Z
.
»»Z [$
GetDashboardStatsAsync
»»[ q
(
»»q r
)
»»r s
)
»»s t
;
»»t u
[
   	
HttpGet
  	 
(
   
$str
   "
)
  " #
]
  # $
public
ÀÀ 
async
ÀÀ 
Task
ÀÀ 
<
ÀÀ 
IActionResult
ÀÀ '
>
ÀÀ' (
GetActiveServices
ÀÀ) :
(
ÀÀ: ;
)
ÀÀ; <
=>
ÀÀ= ?
Ok
ÀÀ@ B
(
ÀÀB C
await
ÀÀC H
_dashboardService
ÀÀI Z
.
ÀÀZ [$
GetActiveServicesAsync
ÀÀ[ q
(
ÀÀq r
)
ÀÀr s
)
ÀÀs t
;
ÀÀt u
[
ÕÕ 	
HttpGet
ÕÕ	 
(
ÕÕ 
$str
ÕÕ 
)
ÕÕ 
]
ÕÕ 
public
ŒŒ 
async
ŒŒ 
Task
ŒŒ 
<
ŒŒ 
IActionResult
ŒŒ '
>
ŒŒ' (
GetAllInvoices
ŒŒ) 7
(
ŒŒ7 8
)
ŒŒ8 9
=>
ŒŒ: <
Ok
ŒŒ= ?
(
ŒŒ? @
await
ŒŒ@ E
_dashboardService
ŒŒF W
.
ŒŒW X!
GetAllInvoicesAsync
ŒŒX k
(
ŒŒk l
)
ŒŒl m
)
ŒŒm n
;
ŒŒn o
[
–– 	
HttpGet
––	 
(
–– 
$str
–– (
)
––( )
]
––) *
public
—— 
async
—— 
Task
—— 
<
—— 
IActionResult
—— '
>
——' ($
GetPaymentMethodsStats
——) ?
(
——? @
)
——@ A
=>
——B D
Ok
——E G
(
——G H
await
——H M
_dashboardService
——N _
.
——_ `)
GetPaymentMethodsStatsAsync
——` {
(
——{ |
)
——| }
)
——} ~
;
——~ 
[
”” 	
	Authorize
””	 
(
”” 
Roles
”” 
=
”” 
$str
”” -
)
””- .
]
””. /
[
‘‘ 	
HttpGet
‘‘	 
(
‘‘ 
$str
‘‘  
)
‘‘  !
]
‘‘! "
public
’’ 
async
’’ 
Task
’’ 
<
’’ 
IActionResult
’’ '
>
’’' (
GetActivityLogs
’’) 8
(
’’8 9
[
’’9 :
	FromQuery
’’: C
]
’’C D
DateTime
’’E M
?
’’M N
since
’’O T
=
’’U V
null
’’W [
)
’’[ \
{
÷÷ 	
Response
◊◊ 
.
◊◊ 
Headers
◊◊ 
.
◊◊ 
CacheControl
◊◊ )
=
◊◊* +
$str
◊◊, Q
;
◊◊Q R
Response
ÿÿ 
.
ÿÿ 
Headers
ÿÿ 
.
ÿÿ 
Pragma
ÿÿ #
=
ÿÿ$ %
$str
ÿÿ& 0
;
ÿÿ0 1
Response
ŸŸ 
.
ŸŸ 
Headers
ŸŸ 
.
ŸŸ 
Expires
ŸŸ $
=
ŸŸ% &
$str
ŸŸ' *
;
ŸŸ* +
return
€€ 
Ok
€€ 
(
€€ 
await
€€ 
_dashboardService
€€ -
.
€€- ."
GetActivityLogsAsync
€€. B
(
€€B C
since
€€C H
)
€€H I
)
€€I J
;
€€J K
}
‹‹ 	
[
ﬁﬁ 	
	Authorize
ﬁﬁ	 
(
ﬁﬁ 
Roles
ﬁﬁ 
=
ﬁﬁ 
$str
ﬁﬁ -
)
ﬁﬁ- .
]
ﬁﬁ. /
[
ﬂﬂ 	

HttpDelete
ﬂﬂ	 
(
ﬂﬂ 
$str
ﬂﬂ (
)
ﬂﬂ( )
]
ﬂﬂ) *
public
‡‡ 
async
‡‡ 
Task
‡‡ 
<
‡‡ 
IActionResult
‡‡ '
>
‡‡' (
DeleteActivityLog
‡‡) :
(
‡‡: ;
int
‡‡; >
id
‡‡? A
)
‡‡A B
{
·· 	
var
‚‚ 
log
‚‚ 
=
‚‚ 
await
‚‚ 
_context
‚‚ $
.
‚‚$ %
ActivityLogs
‚‚% 1
.
‚‚1 2
	FindAsync
‚‚2 ;
(
‚‚; <
id
‚‚< >
)
‚‚> ?
;
‚‚? @
if
„„ 
(
„„ 
log
„„ 
==
„„ 
null
„„ 
)
„„ 
return
„„ #
NotFound
„„$ ,
(
„„, -
)
„„- .
;
„„. /
_context
‰‰ 
.
‰‰ 
ActivityLogs
‰‰ !
.
‰‰! "
Remove
‰‰" (
(
‰‰( )
log
‰‰) ,
)
‰‰, -
;
‰‰- .
await
ÂÂ 
_context
ÂÂ 
.
ÂÂ 
SaveChangesAsync
ÂÂ +
(
ÂÂ+ ,
)
ÂÂ, -
;
ÂÂ- .
return
ÊÊ 
Ok
ÊÊ 
(
ÊÊ 
new
ÊÊ 
{
ÊÊ 
message
ÊÊ #
=
ÊÊ$ %
$str
ÊÊ& <
}
ÊÊ= >
)
ÊÊ> ?
;
ÊÊ? @
}
ÁÁ 	
[
ÈÈ 	
HttpPost
ÈÈ	 
(
ÈÈ 
$str
ÈÈ !
)
ÈÈ! "
]
ÈÈ" #
public
ÍÍ 
async
ÍÍ 
Task
ÍÍ 
<
ÍÍ 
IActionResult
ÍÍ '
>
ÍÍ' (
CreateActivityLog
ÍÍ) :
(
ÍÍ: ;
[
ÍÍ; <
FromBody
ÍÍ< D
]
ÍÍD E&
CreateActivityLogRequest
ÍÍF ^
request
ÍÍ_ f
)
ÍÍf g
{
ÎÎ 	
var
ÏÏ 
userId
ÏÏ 
=
ÏÏ 
User
ÏÏ 
.
ÏÏ 
	FindFirst
ÏÏ '
(
ÏÏ' (
System
ÏÏ( .
.
ÏÏ. /
Security
ÏÏ/ 7
.
ÏÏ7 8
Claims
ÏÏ8 >
.
ÏÏ> ?

ClaimTypes
ÏÏ? I
.
ÏÏI J
NameIdentifier
ÏÏJ X
)
ÏÏX Y
?
ÏÏY Z
.
ÏÏZ [
Value
ÏÏ[ `
;
ÏÏ` a
if
ÌÌ 
(
ÌÌ 
string
ÌÌ 
.
ÌÌ  
IsNullOrWhiteSpace
ÌÌ )
(
ÌÌ) *
userId
ÌÌ* 0
)
ÌÌ0 1
)
ÌÌ1 2
return
ÓÓ 
Unauthorized
ÓÓ #
(
ÓÓ# $
)
ÓÓ$ %
;
ÓÓ% &
var
 

actionText
 
=
 
!
 
string
 $
.
$ % 
IsNullOrWhiteSpace
% 7
(
7 8
request
8 ?
.
? @
Action
@ F
)
F G
?
ÒÒ 
request
ÒÒ 
.
ÒÒ 
Action
ÒÒ  
:
ÚÚ 
request
ÚÚ 
.
ÚÚ 
Description
ÚÚ %
;
ÚÚ% &
if
ÙÙ 
(
ÙÙ 
string
ÙÙ 
.
ÙÙ  
IsNullOrWhiteSpace
ÙÙ )
(
ÙÙ) *

actionText
ÙÙ* 4
)
ÙÙ4 5
)
ÙÙ5 6
return
ıı 

BadRequest
ıı !
(
ıı! "
new
ıı" %
{
ıı& '
message
ıı( /
=
ıı0 1
$str
ıı2 U
}
ııV W
)
ııW X
;
ııX Y
var
˜˜ 
activityLog
˜˜ 
=
˜˜ 
new
˜˜ !
ActivityLog
˜˜" -
{
¯¯ 
UserID
˘˘ 
=
˘˘ 
userId
˘˘ 
,
˘˘  
Action
˙˙ 
=
˙˙ 

actionText
˙˙ #
,
˙˙# $
Type
˚˚ 
=
˚˚ 
string
˚˚ 
.
˚˚  
IsNullOrWhiteSpace
˚˚ 0
(
˚˚0 1
request
˚˚1 8
.
˚˚8 9
Type
˚˚9 =
)
˚˚= >
?
˚˚? @
$str
˚˚A I
:
˚˚J K
request
˚˚L S
.
˚˚S T
Type
˚˚T X
,
˚˚X Y
	IPAddress
¸¸ 
=
¸¸ 
HttpContext
¸¸ '
.
¸¸' (

Connection
¸¸( 2
.
¸¸2 3
RemoteIpAddress
¸¸3 B
?
¸¸B C
.
¸¸C D
ToString
¸¸D L
(
¸¸L M
)
¸¸M N
,
¸¸N O
	Timestamp
˝˝ 
=
˝˝ 
DateTime
˝˝ $
.
˝˝$ %
UtcNow
˝˝% +
}
˛˛ 
;
˛˛ 
_context
ÄÄ 
.
ÄÄ 
ActivityLogs
ÄÄ !
.
ÄÄ! "
Add
ÄÄ" %
(
ÄÄ% &
activityLog
ÄÄ& 1
)
ÄÄ1 2
;
ÄÄ2 3
await
ÅÅ 
_context
ÅÅ 
.
ÅÅ 
SaveChangesAsync
ÅÅ +
(
ÅÅ+ ,
)
ÅÅ, -
;
ÅÅ- .
return
ÉÉ 
Ok
ÉÉ 
(
ÉÉ 
new
ÉÉ 
{
ÉÉ 
message
ÉÉ #
=
ÉÉ$ %
$str
ÉÉ& D
}
ÉÉE F
)
ÉÉF G
;
ÉÉG H
}
ÑÑ 	
[
áá 	
HttpGet
áá	 
(
áá 
$str
áá 
)
áá 
]
áá 
public
àà 
async
àà 
Task
àà 
<
àà 
IActionResult
àà '
>
àà' (
GetPlans
àà) 1
(
àà1 2
)
àà2 3
=>
àà4 6
Ok
àà7 9
(
àà9 :
await
àà: ?
_planService
àà@ L
.
ààL M
GetAllPlansAsync
ààM ]
(
àà] ^
)
àà^ _
)
àà_ `
;
àà` a
[
ää 	
	Authorize
ää	 
(
ää 
Roles
ää 
=
ää 
$str
ää -
)
ää- .
]
ää. /
[
ãã 	
HttpPut
ãã	 
(
ãã 
$str
ãã 
)
ãã 
]
ãã 
public
åå 
async
åå 
Task
åå 
<
åå 
IActionResult
åå '
>
åå' (

UpdatePlan
åå) 3
(
åå3 4
int
åå4 7
id
åå8 :
,
åå: ;
[
åå< =
FromBody
åå= E
]
ååE F
UpdatePlanRequest
ååG X
request
ååY `
)
åå` a
{
çç 	
var
éé 
success
éé 
=
éé 
await
éé 
_planService
éé  ,
.
éé, -
UpdatePlanAsync
éé- <
(
éé< =
id
éé= ?
,
éé? @
request
ééA H
.
ééH I
PlanName
ééI Q
,
ééQ R
request
ééS Z
.
ééZ [
	SpeedMbps
éé[ d
??
éée g
$num
ééh i
,
ééi j
request
éék r
.
éér s
Price
éés x
??
ééy {
$num
éé| }
)
éé} ~
;
éé~ 
return
èè 
success
èè 
?
èè 
Ok
èè 
(
èè  
new
èè  #
{
èè$ %
message
èè& -
=
èè. /
$str
èè0 K
}
èèL M
)
èèM N
:
èèO P
NotFound
èèQ Y
(
èèY Z
)
èèZ [
;
èè[ \
}
êê 	
[
íí 	
	Authorize
íí	 
(
íí 
Roles
íí 
=
íí 
$str
íí -
)
íí- .
]
íí. /
[
ìì 	

HttpDelete
ìì	 
(
ìì 
$str
ìì  
)
ìì  !
]
ìì! "
public
îî 
async
îî 
Task
îî 
<
îî 
IActionResult
îî '
>
îî' (

DeletePlan
îî) 3
(
îî3 4
int
îî4 7
id
îî8 :
)
îî: ;
{
ïï 	
var
ññ 
success
ññ 
=
ññ 
await
ññ 
_planService
ññ  ,
.
ññ, -
DeletePlanAsync
ññ- <
(
ññ< =
id
ññ= ?
)
ññ? @
;
ññ@ A
return
óó 
success
óó 
?
óó 
Ok
óó 
(
óó  
new
óó  #
{
óó$ %
message
óó& -
=
óó. /
$str
óó0 K
}
óóL M
)
óóM N
:
óóO P
NotFound
óóQ Y
(
óóY Z
)
óóZ [
;
óó[ \
}
òò 	
[
õõ 	
	Authorize
õõ	 
(
õõ 
Roles
õõ 
=
õõ 
$str
õõ '
)
õõ' (
]
õõ( )
[
úú 	
HttpGet
úú	 
(
úú 
$str
úú 
)
úú 
]
úú 
public
ùù 
async
ùù 
Task
ùù 
<
ùù 
IActionResult
ùù '
>
ùù' (
GetStaff
ùù) 1
(
ùù1 2
)
ùù2 3
=>
ùù4 6
Ok
ùù7 9
(
ùù9 :
await
ùù: ?
_staffService
ùù@ M
.
ùùM N
GetAllStaffAsync
ùùN ^
(
ùù^ _
)
ùù_ `
)
ùù` a
;
ùùa b
[
üü 	
	Authorize
üü	 
(
üü 
Roles
üü 
=
üü 
$str
üü '
)
üü' (
]
üü( )
[
†† 	
HttpPost
††	 
(
†† 
$str
†† 
)
†† 
]
†† 
public
°° 
async
°° 
Task
°° 
<
°° 
IActionResult
°° '
>
°°' (
CreateStaff
°°) 4
(
°°4 5
[
°°5 6
FromBody
°°6 >
]
°°> ? 
CreateStaffRequest
°°@ R
request
°°S Z
)
°°Z [
{
¢¢ 	
var
££ 
(
££ 
success
££ 
,
££ 
message
££ !
)
££! "
=
££# $
await
££% *
_staffService
££+ 8
.
££8 9
CreateStaffAsync
££9 I
(
££I J
request
££J Q
.
££Q R
Email
££R W
,
££W X
request
££Y `
.
££` a
	FirstName
££a j
,
££j k
request
££l s
.
££s t
LastName
££t |
,
££| }
request££~ Ö
.££Ö Ü
Password££Ü é
,££é è
request££ê ó
.££ó ò
Role££ò ú
)££ú ù
;££ù û
return
§§ 
success
§§ 
?
§§ 
Ok
§§ 
(
§§  
new
§§  #
{
§§$ %
message
§§& -
}
§§. /
)
§§/ 0
:
§§1 2

BadRequest
§§3 =
(
§§= >
new
§§> A
{
§§B C
message
§§D K
}
§§L M
)
§§M N
;
§§N O
}
•• 	
[
ßß 	
	Authorize
ßß	 
(
ßß 
Roles
ßß 
=
ßß 
$str
ßß '
)
ßß' (
]
ßß( )
[
®® 	
HttpPut
®®	 
(
®® 
$str
®® 
)
®® 
]
®® 
public
©© 
async
©© 
Task
©© 
<
©© 
IActionResult
©© '
>
©©' (
UpdateStaff
©©) 4
(
©©4 5
string
©©5 ;
id
©©< >
,
©©> ?
[
©©@ A
FromBody
©©A I
]
©©I J 
UpdateStaffRequest
©©K ]
request
©©^ e
)
©©e f
{
™™ 	
var
´´ 
success
´´ 
=
´´ 
await
´´ 
_staffService
´´  -
.
´´- .
UpdateStaffAsync
´´. >
(
´´> ?
id
´´? A
,
´´A B
request
´´C J
.
´´J K
	FirstName
´´K T
,
´´T U
request
´´V ]
.
´´] ^
LastName
´´^ f
,
´´f g
request
´´h o
.
´´o p
Status
´´p v
,
´´v w
request
´´x 
.´´ Ä
Role´´Ä Ñ
,´´Ñ Ö
request´´Ü ç
.´´ç é
Password´´é ñ
)´´ñ ó
;´´ó ò
return
¨¨ 
success
¨¨ 
?
¨¨ 
Ok
¨¨ 
(
¨¨  
new
¨¨  #
{
¨¨$ %
message
¨¨& -
=
¨¨. /
$str
¨¨0 L
}
¨¨M N
)
¨¨N O
:
¨¨P Q
NotFound
¨¨R Z
(
¨¨Z [
)
¨¨[ \
;
¨¨\ ]
}
≠≠ 	
[
ØØ 	
	Authorize
ØØ	 
(
ØØ 
Roles
ØØ 
=
ØØ 
$str
ØØ '
)
ØØ' (
]
ØØ( )
[
∞∞ 	

HttpDelete
∞∞	 
(
∞∞ 
$str
∞∞  
)
∞∞  !
]
∞∞! "
public
±± 
async
±± 
Task
±± 
<
±± 
IActionResult
±± '
>
±±' (
DeleteStaff
±±) 4
(
±±4 5
string
±±5 ;
id
±±< >
)
±±> ?
{
≤≤ 	
var
≥≥ 
user
≥≥ 
=
≥≥ 
await
≥≥ 
_context
≥≥ %
.
≥≥% &
Users
≥≥& +
.
≥≥+ ,
	FindAsync
≥≥, 5
(
≥≥5 6
id
≥≥6 8
)
≥≥8 9
;
≥≥9 :
if
¥¥ 
(
¥¥ 
user
¥¥ 
==
¥¥ 
null
¥¥ 
)
¥¥ 
return
¥¥ $
NotFound
¥¥% -
(
¥¥- .
new
¥¥. 1
{
¥¥2 3
message
¥¥4 ;
=
¥¥< =
$str
¥¥> O
}
¥¥P Q
)
¥¥Q R
;
¥¥R S
if
∂∂ 
(
∂∂ 
user
∂∂ 
.
∂∂ 
Role
∂∂ 
==
∂∂ 
$str
∂∂ )
)
∂∂) *
{
∑∑ 
var
∏∏ 
superAdminCount
∏∏ #
=
∏∏$ %
await
∏∏& +
_context
∏∏, 4
.
∏∏4 5
Users
∏∏5 :
.
∏∏: ;

CountAsync
∏∏; E
(
∏∏E F
u
∏∏F G
=>
∏∏H J
u
∏∏K L
.
∏∏L M
Role
∏∏M Q
==
∏∏R T
$str
∏∏U a
)
∏∏a b
;
∏∏b c
if
ππ 
(
ππ 
superAdminCount
ππ #
<=
ππ$ &
$num
ππ' (
)
ππ( )
return
∫∫ 

BadRequest
∫∫ %
(
∫∫% &
new
∫∫& )
{
∫∫* +
message
∫∫, 3
=
∫∫4 5
$str
∫∫6 q
}
∫∫r s
)
∫∫s t
;
∫∫t u
}
ªª 
var
ΩΩ 
success
ΩΩ 
=
ΩΩ 
await
ΩΩ 
_staffService
ΩΩ  -
.
ΩΩ- .
DeleteStaffAsync
ΩΩ. >
(
ΩΩ> ?
id
ΩΩ? A
)
ΩΩA B
;
ΩΩB C
return
ææ 
success
ææ 
?
ææ 
Ok
ææ 
(
ææ  
new
ææ  #
{
ææ$ %
message
ææ& -
=
ææ. /
$str
ææ0 L
}
ææM N
)
ææN O
:
ææP Q
NotFound
ææR Z
(
ææZ [
)
ææ[ \
;
ææ\ ]
}
øø 	
[
¡¡ 	
	Authorize
¡¡	 
(
¡¡ 
Roles
¡¡ 
=
¡¡ 
$str
¡¡ '
)
¡¡' (
]
¡¡( )
[
¬¬ 	
HttpPut
¬¬	 
(
¬¬ 
$str
¬¬ #
)
¬¬# $
]
¬¬$ %
public
√√ 
async
√√ 
Task
√√ 
<
√√ 
IActionResult
√√ '
>
√√' (

UpdateRole
√√) 3
(
√√3 4
string
√√4 :
roleName
√√; C
,
√√C D
[
√√E F
FromBody
√√F N
]
√√N O
UpdateRoleRequest
√√P a
request
√√b i
)
√√i j
{
ƒƒ 	
if
≈≈ 
(
≈≈ 
string
≈≈ 
.
≈≈  
IsNullOrWhiteSpace
≈≈ )
(
≈≈) *
roleName
≈≈* 2
)
≈≈2 3
||
≈≈4 6
request
≈≈7 >
?
≈≈> ?
.
≈≈? @
Permissions
≈≈@ K
==
≈≈L N
null
≈≈O S
)
≈≈S T
return
∆∆ 

BadRequest
∆∆ !
(
∆∆! "
new
∆∆" %
{
∆∆& '
message
∆∆( /
=
∆∆0 1
$str
∆∆2 O
}
∆∆P Q
)
∆∆Q R
;
∆∆R S
try
»» 
{
…… 
var
   !
existingPermissions
   '
=
  ( )
await
  * /
_context
  0 8
.
  8 9
RolePermissions
  9 H
.
ÀÀ 
Where
ÀÀ 
(
ÀÀ 
rp
ÀÀ 
=>
ÀÀ  
rp
ÀÀ! #
.
ÀÀ# $
RoleName
ÀÀ$ ,
==
ÀÀ- /
roleName
ÀÀ0 8
)
ÀÀ8 9
.
ÃÃ 
ToListAsync
ÃÃ  
(
ÃÃ  !
)
ÃÃ! "
;
ÃÃ" #
_context
ŒŒ 
.
ŒŒ 
RolePermissions
ŒŒ (
.
ŒŒ( )
RemoveRange
ŒŒ) 4
(
ŒŒ4 5!
existingPermissions
ŒŒ5 H
)
ŒŒH I
;
ŒŒI J
var
–– 
newPermissions
–– "
=
––# $
request
––% ,
.
––, -
Permissions
––- 8
.
––8 9
Select
––9 ?
(
––? @
p
––@ A
=>
––B D
new
––E H
RolePermission
––I W
{
—— 
RoleName
““ 
=
““ 
roleName
““ '
,
““' (
PermissionName
”” "
=
””# $
p
””% &
,
””& '
	CreatedAt
‘‘ 
=
‘‘ 
DateTime
‘‘  (
.
‘‘( )
UtcNow
‘‘) /
}
’’ 
)
’’ 
.
’’ 
ToList
’’ 
(
’’ 
)
’’ 
;
’’ 
_context
◊◊ 
.
◊◊ 
RolePermissions
◊◊ (
.
◊◊( )
AddRange
◊◊) 1
(
◊◊1 2
newPermissions
◊◊2 @
)
◊◊@ A
;
◊◊A B
await
ÿÿ 
_context
ÿÿ 
.
ÿÿ 
SaveChangesAsync
ÿÿ /
(
ÿÿ/ 0
)
ÿÿ0 1
;
ÿÿ1 2
return
⁄⁄ 
Ok
⁄⁄ 
(
⁄⁄ 
new
⁄⁄ 
{
⁄⁄ 
message
⁄⁄  '
=
⁄⁄( )
$str
⁄⁄* Q
}
⁄⁄R S
)
⁄⁄S T
;
⁄⁄T U
}
€€ 
catch
‹‹ 
(
‹‹ 
	Exception
‹‹ 
ex
‹‹ 
)
‹‹  
{
›› 
return
ﬁﬁ 

BadRequest
ﬁﬁ !
(
ﬁﬁ! "
new
ﬁﬁ" %
{
ﬁﬁ& '
message
ﬁﬁ( /
=
ﬁﬁ0 1
ex
ﬁﬁ2 4
.
ﬁﬁ4 5
Message
ﬁﬁ5 <
}
ﬁﬁ= >
)
ﬁﬁ> ?
;
ﬁﬁ? @
}
ﬂﬂ 
}
‡‡ 	
[
‚‚ 	
	Authorize
‚‚	 
(
‚‚ 
Roles
‚‚ 
=
‚‚ 
$str
‚‚ 3
)
‚‚3 4
]
‚‚4 5
[
„„ 	
HttpGet
„„	 
(
„„ 
$str
„„ 
)
„„ 
]
„„ 
public
‰‰ 
async
‰‰ 
Task
‰‰ 
<
‰‰ 
IActionResult
‰‰ '
>
‰‰' (
GetRoles
‰‰) 1
(
‰‰1 2
)
‰‰2 3
{
ÂÂ 	
var
ÊÊ 

adminUsers
ÊÊ 
=
ÊÊ 
await
ÊÊ "
_context
ÊÊ# +
.
ÊÊ+ ,
Users
ÊÊ, 1
.
ÁÁ 
Where
ÁÁ 
(
ÁÁ 
u
ÁÁ 
=>
ÁÁ 
u
ÁÁ 
.
ÁÁ 
Role
ÁÁ "
==
ÁÁ# %
$str
ÁÁ& -
)
ÁÁ- .
.
ËË 
Select
ËË 
(
ËË 
u
ËË 
=>
ËË 
new
ËË  
{
ËË! "
id
ËË# %
=
ËË& '
u
ËË( )
.
ËË) *
Id
ËË* ,
,
ËË, -
name
ËË. 2
=
ËË3 4
$"
ËË5 7
{
ËË7 8
u
ËË8 9
.
ËË9 :
	FirstName
ËË: C
}
ËËC D
$str
ËËD E
{
ËËE F
u
ËËF G
.
ËËG H
LastName
ËËH P
}
ËËP Q
"
ËËQ R
,
ËËR S
email
ËËT Y
=
ËËZ [
u
ËË\ ]
.
ËË] ^
Email
ËË^ c
}
ËËd e
)
ËËe f
.
ÈÈ 
ToListAsync
ÈÈ 
(
ÈÈ 
)
ÈÈ 
;
ÈÈ 
var
ÎÎ 

staffUsers
ÎÎ 
=
ÎÎ 
await
ÎÎ "
_context
ÎÎ# +
.
ÎÎ+ ,
Users
ÎÎ, 1
.
ÏÏ 
Where
ÏÏ 
(
ÏÏ 
u
ÏÏ 
=>
ÏÏ 
u
ÏÏ 
.
ÏÏ 
Role
ÏÏ "
==
ÏÏ# %
$str
ÏÏ& -
)
ÏÏ- .
.
ÌÌ 
Select
ÌÌ 
(
ÌÌ 
u
ÌÌ 
=>
ÌÌ 
new
ÌÌ  
{
ÌÌ! "
id
ÌÌ# %
=
ÌÌ& '
u
ÌÌ( )
.
ÌÌ) *
Id
ÌÌ* ,
,
ÌÌ, -
name
ÌÌ. 2
=
ÌÌ3 4
$"
ÌÌ5 7
{
ÌÌ7 8
u
ÌÌ8 9
.
ÌÌ9 :
	FirstName
ÌÌ: C
}
ÌÌC D
$str
ÌÌD E
{
ÌÌE F
u
ÌÌF G
.
ÌÌG H
LastName
ÌÌH P
}
ÌÌP Q
"
ÌÌQ R
,
ÌÌR S
email
ÌÌT Y
=
ÌÌZ [
u
ÌÌ\ ]
.
ÌÌ] ^
Email
ÌÌ^ c
}
ÌÌd e
)
ÌÌe f
.
ÓÓ 
ToListAsync
ÓÓ 
(
ÓÓ 
)
ÓÓ 
;
ÓÓ 
var
 
adminPermissions
  
=
! "
await
# (
_context
) 1
.
1 2
RolePermissions
2 A
.
ÒÒ 
Where
ÒÒ 
(
ÒÒ 
rp
ÒÒ 
=>
ÒÒ 
rp
ÒÒ 
.
ÒÒ  
RoleName
ÒÒ  (
==
ÒÒ) +
$str
ÒÒ, 3
)
ÒÒ3 4
.
ÚÚ 
Select
ÚÚ 
(
ÚÚ 
rp
ÚÚ 
=>
ÚÚ 
rp
ÚÚ  
.
ÚÚ  !
PermissionName
ÚÚ! /
)
ÚÚ/ 0
.
ÛÛ 
ToListAsync
ÛÛ 
(
ÛÛ 
)
ÛÛ 
;
ÛÛ 
var
ıı 
staffPermissions
ıı  
=
ıı! "
await
ıı# (
_context
ıı) 1
.
ıı1 2
RolePermissions
ıı2 A
.
ˆˆ 
Where
ˆˆ 
(
ˆˆ 
rp
ˆˆ 
=>
ˆˆ 
rp
ˆˆ 
.
ˆˆ  
RoleName
ˆˆ  (
==
ˆˆ) +
$str
ˆˆ, 3
)
ˆˆ3 4
.
˜˜ 
Select
˜˜ 
(
˜˜ 
rp
˜˜ 
=>
˜˜ 
rp
˜˜  
.
˜˜  !
PermissionName
˜˜! /
)
˜˜/ 0
.
¯¯ 
ToListAsync
¯¯ 
(
¯¯ 
)
¯¯ 
;
¯¯ 
var
˙˙ 
roles
˙˙ 
=
˙˙ 
new
˙˙ 
object
˙˙ "
[
˙˙" #
]
˙˙# $
{
˚˚ 
new
¸¸ 
{
˝˝ 
id
˛˛ 
=
˛˛ 
$num
˛˛ 
,
˛˛ 
name
ˇˇ 
=
ˇˇ 
$str
ˇˇ "
,
ˇˇ" #
users
ÄÄ 
=
ÄÄ 

adminUsers
ÄÄ &
.
ÄÄ& '
Count
ÄÄ' ,
,
ÄÄ, -
members
ÅÅ 
=
ÅÅ 

adminUsers
ÅÅ (
,
ÅÅ( )
permissions
ÇÇ 
=
ÇÇ  !
adminPermissions
ÇÇ" 2
.
ÇÇ2 3
Count
ÇÇ3 8
>
ÇÇ9 :
$num
ÇÇ; <
?
ÇÇ= >
adminPermissions
ÇÇ? O
:
ÇÇP Q
new
ÇÇR U
List
ÇÇV Z
<
ÇÇZ [
string
ÇÇ[ a
>
ÇÇa b
(
ÇÇb c
)
ÇÇc d
,
ÇÇd e
color
ÉÉ 
=
ÉÉ 
$str
ÉÉ !
}
ÑÑ 
,
ÑÑ 
new
ÖÖ 
{
ÜÜ 
id
áá 
=
áá 
$num
áá 
,
áá 
name
àà 
=
àà 
$str
àà "
,
àà" #
users
ââ 
=
ââ 

staffUsers
ââ &
.
ââ& '
Count
ââ' ,
,
ââ, -
members
ää 
=
ää 

staffUsers
ää (
,
ää( )
permissions
ãã 
=
ãã  !
staffPermissions
ãã" 2
.
ãã2 3
Count
ãã3 8
>
ãã9 :
$num
ãã; <
?
ãã= >
staffPermissions
ãã? O
:
ããP Q
new
ããR U
List
ããV Z
<
ããZ [
string
ãã[ a
>
ããa b
(
ããb c
)
ããc d
,
ããd e
color
åå 
=
åå 
$str
åå "
}
çç 
}
éé 
;
éé 
return
êê 
Ok
êê 
(
êê 
roles
êê 
)
êê 
;
êê 
}
ëë 	
[
îî 	
HttpGet
îî	 
(
îî 
$str
îî 
)
îî 
]
îî 
public
ïï 
async
ïï 
Task
ïï 
<
ïï 
IActionResult
ïï '
>
ïï' (
GetFAQs
ïï) 0
(
ïï0 1
)
ïï1 2
=>
ïï3 5
Ok
ïï6 8
(
ïï8 9
await
ïï9 >
_faqService
ïï? J
.
ïïJ K
GetAllFAQsAsync
ïïK Z
(
ïïZ [
)
ïï[ \
)
ïï\ ]
;
ïï] ^
[
óó 	
HttpPost
óó	 
(
óó 
$str
óó 
)
óó 
]
óó 
public
òò 
async
òò 
Task
òò 
<
òò 
IActionResult
òò '
>
òò' (
	CreateFAQ
òò) 2
(
òò2 3
[
òò3 4
FromBody
òò4 <
]
òò< =
CreateFAQRequest
òò> N
request
òòO V
)
òòV W
{
ôô 	
await
öö 
_faqService
öö 
.
öö 
CreateFAQAsync
öö ,
(
öö, -
request
öö- 4
.
öö4 5
Question
öö5 =
,
öö= >
request
öö? F
.
ööF G
Answer
ööG M
,
ööM N
request
ööO V
.
ööV W
Category
ööW _
,
öö_ `
request
ööa h
.
ööh i
Status
ööi o
)
ööo p
;
ööp q
return
õõ 
Ok
õõ 
(
õõ 
new
õõ 
{
õõ 
message
õõ #
=
õõ$ %
$str
õõ& @
}
õõA B
)
õõB C
;
õõC D
}
úú 	
[
ûû 	
HttpPut
ûû	 
(
ûû 
$str
ûû 
)
ûû 
]
ûû 
public
üü 
async
üü 
Task
üü 
<
üü 
IActionResult
üü '
>
üü' (
	UpdateFAQ
üü) 2
(
üü2 3
int
üü3 6
id
üü7 9
,
üü9 :
[
üü; <
FromBody
üü< D
]
üüD E
UpdateFAQRequest
üüF V
request
üüW ^
)
üü^ _
{
†† 	
var
°° 
success
°° 
=
°° 
await
°° 
_faqService
°°  +
.
°°+ ,
UpdateFAQAsync
°°, :
(
°°: ;
id
°°; =
,
°°= >
request
°°? F
.
°°F G
Question
°°G O
,
°°O P
request
°°Q X
.
°°X Y
Answer
°°Y _
,
°°_ `
request
°°a h
.
°°h i
Category
°°i q
,
°°q r
request
°°s z
.
°°z {
Status°°{ Å
)°°Å Ç
;°°Ç É
return
¢¢ 
success
¢¢ 
?
¢¢ 
Ok
¢¢ 
(
¢¢  
new
¢¢  #
{
¢¢$ %
message
¢¢& -
=
¢¢. /
$str
¢¢0 J
}
¢¢K L
)
¢¢L M
:
¢¢N O
NotFound
¢¢P X
(
¢¢X Y
)
¢¢Y Z
;
¢¢Z [
}
££ 	
[
•• 	

HttpDelete
••	 
(
•• 
$str
•• 
)
••  
]
••  !
public
¶¶ 
async
¶¶ 
Task
¶¶ 
<
¶¶ 
IActionResult
¶¶ '
>
¶¶' (
	DeleteFAQ
¶¶) 2
(
¶¶2 3
int
¶¶3 6
id
¶¶7 9
)
¶¶9 :
{
ßß 	
var
®® 
success
®® 
=
®® 
await
®® 
_faqService
®®  +
.
®®+ ,
DeleteFAQAsync
®®, :
(
®®: ;
id
®®; =
)
®®= >
;
®®> ?
return
©© 
success
©© 
?
©© 
Ok
©© 
(
©©  
new
©©  #
{
©©$ %
message
©©& -
=
©©. /
$str
©©0 J
}
©©K L
)
©©L M
:
©©N O
NotFound
©©P X
(
©©X Y
)
©©Y Z
;
©©Z [
}
™™ 	
[
ØØ 	
HttpGet
ØØ	 
(
ØØ 
$str
ØØ 
)
ØØ  
]
ØØ  !
public
∞∞ 
async
∞∞ 
Task
∞∞ 
<
∞∞ 
IActionResult
∞∞ '
>
∞∞' (
GetPromoOffers
∞∞) 7
(
∞∞7 8
)
∞∞8 9
{
±± 	
var
≤≤ 
offers
≤≤ 
=
≤≤ 
await
≤≤ 
_context
≤≤ '
.
≤≤' (
PromoOffers
≤≤( 3
.
≥≥ 
OrderByDescending
≥≥ "
(
≥≥" #
o
≥≥# $
=>
≥≥% '
o
≥≥( )
.
≥≥) *
	CreatedAt
≥≥* 3
)
≥≥3 4
.
¥¥ 
ToListAsync
¥¥ 
(
¥¥ 
)
¥¥ 
;
¥¥ 
return
µµ 
Ok
µµ 
(
µµ 
offers
µµ 
)
µµ 
;
µµ 
}
∂∂ 	
[
∏∏ 	
HttpPost
∏∏	 
(
∏∏ 
$str
∏∏  
)
∏∏  !
]
∏∏! "
public
ππ 
async
ππ 
Task
ππ 
<
ππ 
IActionResult
ππ '
>
ππ' (
CreatePromoOffer
ππ) 9
(
ππ9 :
[
ππ: ;
FromBody
ππ; C
]
ππC D%
CreatePromoOfferRequest
ππE \
request
ππ] d
)
ππd e
{
∫∫ 	
var
ªª 
offer
ªª 
=
ªª 
new
ªª 

PromoOffer
ªª &
{
ºº 
Title
ΩΩ 
=
ΩΩ 
request
ΩΩ 
.
ΩΩ  
Title
ΩΩ  %
,
ΩΩ% &
Description
ææ 
=
ææ 
request
ææ %
.
ææ% &
Description
ææ& 1
,
ææ1 2
Price
øø 
=
øø 
request
øø 
.
øø  
Price
øø  %
,
øø% &
Data
¿¿ 
=
¿¿ 
request
¿¿ 
.
¿¿ 
Data
¿¿ #
,
¿¿# $
Validity
¡¡ 
=
¡¡ 
request
¡¡ "
.
¡¡" #
Validity
¡¡# +
,
¡¡+ ,
Badge
¬¬ 
=
¬¬ 
request
¬¬ 
.
¬¬  
Badge
¬¬  %
,
¬¬% &
Color
√√ 
=
√√ 
request
√√ 
.
√√  
Color
√√  %
??
√√& (
$str
√√) D
,
√√D E
IsActive
ƒƒ 
=
ƒƒ 
true
ƒƒ 
,
ƒƒ  
	CreatedAt
≈≈ 
=
≈≈ 
DateTime
≈≈ $
.
≈≈$ %
UtcNow
≈≈% +
}
∆∆ 
;
∆∆ 
_context
«« 
.
«« 
PromoOffers
««  
.
««  !
Add
««! $
(
««$ %
offer
««% *
)
««* +
;
««+ ,
await
»» 
_context
»» 
.
»» 
SaveChangesAsync
»» +
(
»»+ ,
)
»», -
;
»»- .
return
…… 
Ok
…… 
(
…… 
new
…… 
{
…… 
message
…… #
=
……$ %
$str
……& H
,
……H I
promoOfferID
……J V
=
……W X
offer
……Y ^
.
……^ _
PromoOfferID
……_ k
}
……l m
)
……m n
;
……n o
}
   	
[
ÃÃ 	
HttpPut
ÃÃ	 
(
ÃÃ 
$str
ÃÃ $
)
ÃÃ$ %
]
ÃÃ% &
public
ÕÕ 
async
ÕÕ 
Task
ÕÕ 
<
ÕÕ 
IActionResult
ÕÕ '
>
ÕÕ' (
UpdatePromoOffer
ÕÕ) 9
(
ÕÕ9 :
int
ÕÕ: =
id
ÕÕ> @
,
ÕÕ@ A
[
ÕÕB C
FromBody
ÕÕC K
]
ÕÕK L%
UpdatePromoOfferRequest
ÕÕM d
request
ÕÕe l
)
ÕÕl m
{
ŒŒ 	
var
œœ 
offer
œœ 
=
œœ 
await
œœ 
_context
œœ &
.
œœ& '
PromoOffers
œœ' 2
.
œœ2 3
	FindAsync
œœ3 <
(
œœ< =
id
œœ= ?
)
œœ? @
;
œœ@ A
if
–– 
(
–– 
offer
–– 
==
–– 
null
–– 
)
–– 
return
–– %
NotFound
––& .
(
––. /
new
––/ 2
{
––3 4
message
––5 <
=
––= >
$str
––? V
}
––W X
)
––X Y
;
––Y Z
offer
““ 
.
““ 
Title
““ 
=
““ 
request
““ !
.
““! "
Title
““" '
;
““' (
offer
”” 
.
”” 
Description
”” 
=
”” 
request
””  '
.
””' (
Description
””( 3
;
””3 4
offer
‘‘ 
.
‘‘ 
Price
‘‘ 
=
‘‘ 
request
‘‘ !
.
‘‘! "
Price
‘‘" '
;
‘‘' (
offer
’’ 
.
’’ 
Data
’’ 
=
’’ 
request
’’  
.
’’  !
Data
’’! %
;
’’% &
offer
÷÷ 
.
÷÷ 
Validity
÷÷ 
=
÷÷ 
request
÷÷ $
.
÷÷$ %
Validity
÷÷% -
;
÷÷- .
offer
◊◊ 
.
◊◊ 
Badge
◊◊ 
=
◊◊ 
request
◊◊ !
.
◊◊! "
Badge
◊◊" '
;
◊◊' (
offer
ÿÿ 
.
ÿÿ 
Color
ÿÿ 
=
ÿÿ 
request
ÿÿ !
.
ÿÿ! "
Color
ÿÿ" '
??
ÿÿ( *
offer
ÿÿ+ 0
.
ÿÿ0 1
Color
ÿÿ1 6
;
ÿÿ6 7
offer
ŸŸ 
.
ŸŸ 
IsActive
ŸŸ 
=
ŸŸ 
request
ŸŸ $
.
ŸŸ$ %
IsActive
ŸŸ% -
;
ŸŸ- .
await
€€ 
_context
€€ 
.
€€ 
SaveChangesAsync
€€ +
(
€€+ ,
)
€€, -
;
€€- .
return
‹‹ 
Ok
‹‹ 
(
‹‹ 
new
‹‹ 
{
‹‹ 
message
‹‹ #
=
‹‹$ %
$str
‹‹& H
}
‹‹I J
)
‹‹J K
;
‹‹K L
}
›› 	
[
ﬂﬂ 	

HttpDelete
ﬂﬂ	 
(
ﬂﬂ 
$str
ﬂﬂ '
)
ﬂﬂ' (
]
ﬂﬂ( )
public
‡‡ 
async
‡‡ 
Task
‡‡ 
<
‡‡ 
IActionResult
‡‡ '
>
‡‡' (
DeletePromoOffer
‡‡) 9
(
‡‡9 :
int
‡‡: =
id
‡‡> @
)
‡‡@ A
{
·· 	
var
‚‚ 
offer
‚‚ 
=
‚‚ 
await
‚‚ 
_context
‚‚ &
.
‚‚& '
PromoOffers
‚‚' 2
.
‚‚2 3
	FindAsync
‚‚3 <
(
‚‚< =
id
‚‚= ?
)
‚‚? @
;
‚‚@ A
if
„„ 
(
„„ 
offer
„„ 
==
„„ 
null
„„ 
)
„„ 
return
„„ %
NotFound
„„& .
(
„„. /
new
„„/ 2
{
„„3 4
message
„„5 <
=
„„= >
$str
„„? V
}
„„W X
)
„„X Y
;
„„Y Z
_context
ÂÂ 
.
ÂÂ 
PromoOffers
ÂÂ  
.
ÂÂ  !
Remove
ÂÂ! '
(
ÂÂ' (
offer
ÂÂ( -
)
ÂÂ- .
;
ÂÂ. /
await
ÊÊ 
_context
ÊÊ 
.
ÊÊ 
SaveChangesAsync
ÊÊ +
(
ÊÊ+ ,
)
ÊÊ, -
;
ÊÊ- .
return
ÁÁ 
Ok
ÁÁ 
(
ÁÁ 
new
ÁÁ 
{
ÁÁ 
message
ÁÁ #
=
ÁÁ$ %
$str
ÁÁ& H
}
ÁÁI J
)
ÁÁJ K
;
ÁÁK L
}
ËË 	
[
ÍÍ 	
HttpPost
ÍÍ	 
(
ÍÍ 
$str
ÍÍ &
)
ÍÍ& '
]
ÍÍ' (
public
ÎÎ 
async
ÎÎ 
Task
ÎÎ 
<
ÎÎ 
IActionResult
ÎÎ '
>
ÎÎ' (
AdminTopUpPrepaid
ÎÎ) :
(
ÎÎ: ;
int
ÎÎ; >
id
ÎÎ? A
,
ÎÎA B
[
ÎÎC D
FromBody
ÎÎD L
]
ÎÎL M
AdminTopUpRequest
ÎÎN _
request
ÎÎ` g
)
ÎÎg h
{
ÏÏ 	
var
ÌÌ 
prepaid
ÌÌ 
=
ÌÌ 
await
ÌÌ 
_context
ÌÌ  (
.
ÌÌ( )
PrepaidLoads
ÌÌ) 5
.
ÓÓ 
Include
ÓÓ 
(
ÓÓ 
p
ÓÓ 
=>
ÓÓ 
p
ÓÓ 
.
ÓÓ  
ServiceAccount
ÓÓ  .
)
ÓÓ. /
.
ÔÔ !
FirstOrDefaultAsync
ÔÔ $
(
ÔÔ$ %
p
ÔÔ% &
=>
ÔÔ' )
p
ÔÔ* +
.
ÔÔ+ ,
PrepaidLoadID
ÔÔ, 9
==
ÔÔ: <
id
ÔÔ= ?
)
ÔÔ? @
;
ÔÔ@ A
if
ÒÒ 
(
ÒÒ 
prepaid
ÒÒ 
==
ÒÒ 
null
ÒÒ 
)
ÒÒ  
return
ÒÒ! '
NotFound
ÒÒ( 0
(
ÒÒ0 1
new
ÒÒ1 4
{
ÒÒ5 6
message
ÒÒ7 >
=
ÒÒ? @
$str
ÒÒA \
}
ÒÒ] ^
)
ÒÒ^ _
;
ÒÒ_ `
if
ÚÚ 
(
ÚÚ 
request
ÚÚ 
.
ÚÚ 
Amount
ÚÚ 
<=
ÚÚ !
$num
ÚÚ" #
)
ÚÚ# $
return
ÚÚ% +

BadRequest
ÚÚ, 6
(
ÚÚ6 7
new
ÚÚ7 :
{
ÚÚ; <
message
ÚÚ= D
=
ÚÚE F
$str
ÚÚG f
}
ÚÚg h
)
ÚÚh i
;
ÚÚi j
prepaid
ÙÙ 
.
ÙÙ 

LoadAmount
ÙÙ 
+=
ÙÙ !
request
ÙÙ" )
.
ÙÙ) *
Amount
ÙÙ* 0
;
ÙÙ0 1
prepaid
ıı 
.
ıı 
RemainingBalance
ıı $
=
ıı% &
(
ıı' (
prepaid
ıı( /
.
ıı/ 0
RemainingBalance
ıı0 @
??
ııA C
$num
ııD E
)
ııE F
+
ııG H
request
ııI P
.
ııP Q
Amount
ııQ W
;
ııW X
prepaid
ˆˆ 
.
ˆˆ 
LastReloadBalance
ˆˆ %
=
ˆˆ& '
DateTime
ˆˆ( 0
.
ˆˆ0 1
UtcNow
ˆˆ1 7
;
ˆˆ7 8
await
¯¯ 
_context
¯¯ 
.
¯¯ 
SaveChangesAsync
¯¯ +
(
¯¯+ ,
)
¯¯, -
;
¯¯- .
return
˙˙ 
Ok
˙˙ 
(
˙˙ 
new
˙˙ 
{
˚˚ 
message
¸¸ 
=
¸¸ 
$str
¸¸ -
,
¸¸- .

loadAmount
˝˝ 
=
˝˝ 
prepaid
˝˝ $
.
˝˝$ %

LoadAmount
˝˝% /
,
˝˝/ 0
remainingBalance
˛˛  
=
˛˛! "
prepaid
˛˛# *
.
˛˛* +
RemainingBalance
˛˛+ ;
,
˛˛; <

lastReload
ˇˇ 
=
ˇˇ 
prepaid
ˇˇ $
.
ˇˇ$ %
LastReloadBalance
ˇˇ% 6
}
ÄÄ 
)
ÄÄ 
;
ÄÄ 
}
ÅÅ 	
[
ÉÉ 	
HttpPut
ÉÉ	 
(
ÉÉ 
$str
ÉÉ &
)
ÉÉ& '
]
ÉÉ' (
public
ÑÑ 
async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
IActionResult
ÑÑ '
>
ÑÑ' (!
UpdatePrepaidStatus
ÑÑ) <
(
ÑÑ< =
int
ÑÑ= @
id
ÑÑA C
,
ÑÑC D
[
ÑÑE F
FromBody
ÑÑF N
]
ÑÑN O(
UpdatePrepaidStatusRequest
ÑÑP j
request
ÑÑk r
)
ÑÑr s
{
ÖÖ 	
var
ÜÜ 
prepaid
ÜÜ 
=
ÜÜ 
await
ÜÜ 
_context
ÜÜ  (
.
ÜÜ( )
PrepaidLoads
ÜÜ) 5
.
áá 
Include
áá 
(
áá 
p
áá 
=>
áá 
p
áá 
.
áá  
ServiceAccount
áá  .
)
áá. /
.
àà !
FirstOrDefaultAsync
àà $
(
àà$ %
p
àà% &
=>
àà' )
p
àà* +
.
àà+ ,
PrepaidLoadID
àà, 9
==
àà: <
id
àà= ?
)
àà? @
;
àà@ A
if
ää 
(
ää 
prepaid
ää 
==
ää 
null
ää 
)
ää  
return
ää! '
NotFound
ää( 0
(
ää0 1
new
ää1 4
{
ää5 6
message
ää7 >
=
ää? @
$str
ääA \
}
ää] ^
)
ää^ _
;
ää_ `
prepaid
åå 
.
åå 
ServiceAccount
åå "
.
åå" #
Status
åå# )
=
åå* +
request
åå, 3
.
åå3 4
Status
åå4 :
;
åå: ;
await
çç 
_context
çç 
.
çç 
SaveChangesAsync
çç +
(
çç+ ,
)
çç, -
;
çç- .
return
èè 
Ok
èè 
(
èè 
new
èè 
{
èè 
message
èè #
=
èè$ %
$str
èè& F
,
èèF G
status
èèH N
=
èèO P
request
èèQ X
.
èèX Y
Status
èèY _
}
èè` a
)
èèa b
;
èèb c
}
êê 	
[
íí 	

HttpDelete
íí	 
(
íí 
$str
íí "
)
íí" #
]
íí# $
public
ìì 
async
ìì 
Task
ìì 
<
ìì 
IActionResult
ìì '
>
ìì' ("
DeletePrepaidService
ìì) =
(
ìì= >
int
ìì> A
id
ììB D
)
ììD E
{
îî 	
var
ïï 
prepaid
ïï 
=
ïï 
await
ïï 
_context
ïï  (
.
ïï( )
PrepaidLoads
ïï) 5
.
ññ 
Include
ññ 
(
ññ 
p
ññ 
=>
ññ 
p
ññ 
.
ññ  
ServiceAccount
ññ  .
)
ññ. /
.
óó 
ThenInclude
óó  
(
óó  !
sa
óó! #
=>
óó$ &
sa
óó' )
.
óó) *
Device
óó* 0
)
óó0 1
.
òò !
FirstOrDefaultAsync
òò $
(
òò$ %
p
òò% &
=>
òò' )
p
òò* +
.
òò+ ,
PrepaidLoadID
òò, 9
==
òò: <
id
òò= ?
)
òò? @
;
òò@ A
if
öö 
(
öö 
prepaid
öö 
==
öö 
null
öö 
)
öö  
return
öö! '
NotFound
öö( 0
(
öö0 1
new
öö1 4
{
öö5 6
message
öö7 >
=
öö? @
$str
ööA \
}
öö] ^
)
öö^ _
;
öö_ `
_context
úú 
.
úú 
PrepaidLoads
úú !
.
úú! "
Remove
úú" (
(
úú( )
prepaid
úú) 0
)
úú0 1
;
úú1 2
await
ùù 
_context
ùù 
.
ùù 
SaveChangesAsync
ùù +
(
ùù+ ,
)
ùù, -
;
ùù- .
return
üü 
Ok
üü 
(
üü 
new
üü 
{
üü 
message
üü #
=
üü$ %
$str
üü& L
}
üüM N
)
üüN O
;
üüO P
}
†† 	
[
££ 	
HttpGet
££	 
(
££ 
$str
££ 
)
££ 
]
££ 
public
§§ 
async
§§ 
Task
§§ 
<
§§ 
IActionResult
§§ '
>
§§' (
GetAllPromos
§§) 5
(
§§5 6
)
§§6 7
{
•• 	
var
¶¶ 
promos
¶¶ 
=
¶¶ 
await
¶¶ 
_context
¶¶ '
.
¶¶' (
PrepaidPromos
¶¶( 5
.
ßß 
Include
ßß 
(
ßß 
p
ßß 
=>
ßß 
p
ßß 
.
ßß  
User
ßß  $
)
ßß$ %
.
®® 
Include
®® 
(
®® 
p
®® 
=>
®® 
p
®® 
.
®®  
PrepaidLoad
®®  +
)
®®+ ,
.
©© 
OrderByDescending
©© "
(
©©" #
p
©©# $
=>
©©% '
p
©©( )
.
©©) *
ActivatedAt
©©* 5
)
©©5 6
.
™™ 
Select
™™ 
(
™™ 
p
™™ 
=>
™™ 
new
™™  
{
´´ 
p
¨¨ 
.
¨¨ 
PrepaidPromoID
¨¨ $
,
¨¨$ %
p
≠≠ 
.
≠≠ 
PrepaidLoadID
≠≠ #
,
≠≠# $
p
ÆÆ 
.
ÆÆ 
UserID
ÆÆ 
,
ÆÆ 
Customer
ØØ 
=
ØØ 
p
ØØ  
.
ØØ  !
User
ØØ! %
.
ØØ% &
	FirstName
ØØ& /
+
ØØ0 1
$str
ØØ2 5
+
ØØ6 7
p
ØØ8 9
.
ØØ9 :
User
ØØ: >
.
ØØ> ?
LastName
ØØ? G
,
ØØG H
Email
∞∞ 
=
∞∞ 
p
∞∞ 
.
∞∞ 
User
∞∞ "
.
∞∞" #
Email
∞∞# (
,
∞∞( )
p
±± 
.
±± 

PromoTitle
±±  
,
±±  !
p
≤≤ 
.
≤≤ 
TotalDataMB
≤≤ !
,
≤≤! "
p
≥≥ 
.
≥≥ 
RemainingDataMB
≥≥ %
,
≥≥% &

UsedDataMB
¥¥ 
=
¥¥  
p
¥¥! "
.
¥¥" #
TotalDataMB
¥¥# .
-
¥¥/ 0
p
¥¥1 2
.
¥¥2 3
RemainingDataMB
¥¥3 B
,
¥¥B C
p
µµ 
.
µµ 
ValidityDays
µµ "
,
µµ" #
p
∂∂ 
.
∂∂ 
ActivatedAt
∂∂ !
,
∂∂! "
p
∑∑ 
.
∑∑ 
	ExpiresAt
∑∑ 
,
∑∑  
p
∏∏ 
.
∏∏ 
Status
∏∏ 
}
ππ 
)
ππ 
.
∫∫ 
ToListAsync
∫∫ 
(
∫∫ 
)
∫∫ 
;
∫∫ 
return
ºº 
Ok
ºº 
(
ºº 
promos
ºº 
)
ºº 
;
ºº 
}
ΩΩ 	
[
øø 	
HttpPut
øø	 
(
øø 
$str
øø %
)
øø% &
]
øø& '
public
¿¿ 
async
¿¿ 
Task
¿¿ 
<
¿¿ 
IActionResult
¿¿ '
>
¿¿' (
UpdatePromoStatus
¿¿) :
(
¿¿: ;
int
¿¿; >
id
¿¿? A
,
¿¿A B
[
¿¿C D
FromBody
¿¿D L
]
¿¿L M&
UpdatePromoStatusRequest
¿¿N f
request
¿¿g n
)
¿¿n o
{
¡¡ 	
var
¬¬ 
promo
¬¬ 
=
¬¬ 
await
¬¬ 
_context
¬¬ &
.
¬¬& '
PrepaidPromos
¬¬' 4
.
¬¬4 5
	FindAsync
¬¬5 >
(
¬¬> ?
id
¬¬? A
)
¬¬A B
;
¬¬B C
if
√√ 
(
√√ 
promo
√√ 
==
√√ 
null
√√ 
)
√√ 
return
√√ %
NotFound
√√& .
(
√√. /
new
√√/ 2
{
√√3 4
message
√√5 <
=
√√= >
$str
√√? P
}
√√Q R
)
√√R S
;
√√S T
promo
≈≈ 
.
≈≈ 
Status
≈≈ 
=
≈≈ 
request
≈≈ "
.
≈≈" #
Status
≈≈# )
;
≈≈) *
await
∆∆ 
_context
∆∆ 
.
∆∆ 
SaveChangesAsync
∆∆ +
(
∆∆+ ,
)
∆∆, -
;
∆∆- .
return
»» 
Ok
»» 
(
»» 
new
»» 
{
»» 
message
»» #
=
»»$ %
$str
»»& <
,
»»< =
status
»»> D
=
»»E F
request
»»G N
.
»»N O
Status
»»O U
}
»»V W
)
»»W X
;
»»X Y
}
…… 	
[
ÀÀ 	

HttpDelete
ÀÀ	 
(
ÀÀ 
$str
ÀÀ !
)
ÀÀ! "
]
ÀÀ" #
public
ÃÃ 
async
ÃÃ 
Task
ÃÃ 
<
ÃÃ 
IActionResult
ÃÃ '
>
ÃÃ' (
DeletePromo
ÃÃ) 4
(
ÃÃ4 5
int
ÃÃ5 8
id
ÃÃ9 ;
)
ÃÃ; <
{
ÕÕ 	
var
ŒŒ 
promo
ŒŒ 
=
ŒŒ 
await
ŒŒ 
_context
ŒŒ &
.
ŒŒ& '
PrepaidPromos
ŒŒ' 4
.
ŒŒ4 5
	FindAsync
ŒŒ5 >
(
ŒŒ> ?
id
ŒŒ? A
)
ŒŒA B
;
ŒŒB C
if
œœ 
(
œœ 
promo
œœ 
==
œœ 
null
œœ 
)
œœ 
return
œœ %
NotFound
œœ& .
(
œœ. /
new
œœ/ 2
{
œœ3 4
message
œœ5 <
=
œœ= >
$str
œœ? P
}
œœQ R
)
œœR S
;
œœS T
_context
—— 
.
—— 
PrepaidPromos
—— "
.
——" #
Remove
——# )
(
——) *
promo
——* /
)
——/ 0
;
——0 1
await
““ 
_context
““ 
.
““ 
SaveChangesAsync
““ +
(
““+ ,
)
““, -
;
““- .
return
‘‘ 
Ok
‘‘ 
(
‘‘ 
new
‘‘ 
{
‘‘ 
message
‘‘ #
=
‘‘$ %
$str
‘‘& B
}
‘‘C D
)
‘‘D E
;
‘‘E F
}
’’ 	
[
ÿÿ 	
HttpGet
ÿÿ	 
(
ÿÿ 
$str
ÿÿ  
)
ÿÿ  !
]
ÿÿ! "
public
ŸŸ 
async
ŸŸ 
Task
ŸŸ 
<
ŸŸ 
IActionResult
ŸŸ '
>
ŸŸ' (
GetNotifications
ŸŸ) 9
(
ŸŸ9 :
)
ŸŸ: ;
{
⁄⁄ 	
var
€€ 
userId
€€ 
=
€€ 
User
€€ 
.
€€ 
	FindFirst
€€ '
(
€€' (
System
€€( .
.
€€. /
Security
€€/ 7
.
€€7 8
Claims
€€8 >
.
€€> ?

ClaimTypes
€€? I
.
€€I J
NameIdentifier
€€J X
)
€€X Y
?
€€Y Z
.
€€Z [
Value
€€[ `
;
€€` a
if
‹‹ 
(
‹‹ 
userId
‹‹ 
==
‹‹ 
null
‹‹ 
)
‹‹ 
return
‹‹  &
Unauthorized
‹‹' 3
(
‹‹3 4
)
‹‹4 5
;
‹‹5 6
var
ﬁﬁ 
notifications
ﬁﬁ 
=
ﬁﬁ 
await
ﬁﬁ  %
_context
ﬁﬁ& .
.
ﬁﬁ. /
Notifications
ﬁﬁ/ <
.
ﬂﬂ 
Where
ﬂﬂ 
(
ﬂﬂ 
n
ﬂﬂ 
=>
ﬂﬂ 
n
ﬂﬂ 
.
ﬂﬂ 
UserID
ﬂﬂ $
==
ﬂﬂ% '
userId
ﬂﬂ( .
)
ﬂﬂ. /
.
‡‡ 
OrderByDescending
‡‡ "
(
‡‡" #
n
‡‡# $
=>
‡‡% '
n
‡‡( )
.
‡‡) *
SentAt
‡‡* 0
)
‡‡0 1
.
·· 
ToListAsync
·· 
(
·· 
)
·· 
;
·· 
return
‚‚ 
Ok
‚‚ 
(
‚‚ 
notifications
‚‚ #
)
‚‚# $
;
‚‚$ %
}
„„ 	
[
ÂÂ 	
HttpPost
ÂÂ	 
(
ÂÂ 
$str
ÂÂ !
)
ÂÂ! "
]
ÂÂ" #
public
ÊÊ 
async
ÊÊ 
Task
ÊÊ 
<
ÊÊ 
IActionResult
ÊÊ '
>
ÊÊ' ( 
CreateNotification
ÊÊ) ;
(
ÊÊ; <
[
ÊÊ< =
FromBody
ÊÊ= E
]
ÊÊE F'
CreateNotificationRequest
ÊÊG `
request
ÊÊa h
)
ÊÊh i
{
ÁÁ 	
var
ËË 
userId
ËË 
=
ËË 
User
ËË 
.
ËË 
	FindFirst
ËË '
(
ËË' (
System
ËË( .
.
ËË. /
Security
ËË/ 7
.
ËË7 8
Claims
ËË8 >
.
ËË> ?

ClaimTypes
ËË? I
.
ËËI J
NameIdentifier
ËËJ X
)
ËËX Y
?
ËËY Z
.
ËËZ [
Value
ËË[ `
;
ËË` a
if
ÈÈ 
(
ÈÈ 
userId
ÈÈ 
==
ÈÈ 
null
ÈÈ 
)
ÈÈ 
return
ÈÈ  &
Unauthorized
ÈÈ' 3
(
ÈÈ3 4
)
ÈÈ4 5
;
ÈÈ5 6
var
ÎÎ 
notification
ÎÎ 
=
ÎÎ 
new
ÎÎ "
Notification
ÎÎ# /
{
ÏÏ 
UserID
ÌÌ 
=
ÌÌ 
userId
ÌÌ 
,
ÌÌ  
Message
ÓÓ 
=
ÓÓ 
request
ÓÓ !
.
ÓÓ! "
Message
ÓÓ" )
,
ÓÓ) *
Type
ÔÔ 
=
ÔÔ 
request
ÔÔ 
.
ÔÔ 
Type
ÔÔ #
??
ÔÔ$ &
$str
ÔÔ' -
,
ÔÔ- .
Status
 
=
 
$str
 !
,
! "
SentAt
ÒÒ 
=
ÒÒ 
DateTime
ÒÒ !
.
ÒÒ! "
UtcNow
ÒÒ" (
}
ÚÚ 
;
ÚÚ 
_context
ÙÙ 
.
ÙÙ 
Notifications
ÙÙ "
.
ÙÙ" #
Add
ÙÙ# &
(
ÙÙ& '
notification
ÙÙ' 3
)
ÙÙ3 4
;
ÙÙ4 5
await
ıı 
_context
ıı 
.
ıı 
SaveChangesAsync
ıı +
(
ıı+ ,
)
ıı, -
;
ıı- .
return
ˆˆ 
Ok
ˆˆ 
(
ˆˆ 
new
ˆˆ 
{
ˆˆ 
message
ˆˆ #
=
ˆˆ$ %
$str
ˆˆ& <
,
ˆˆ< =
notificationID
ˆˆ> L
=
ˆˆM N
notification
ˆˆO [
.
ˆˆ[ \
NotificationID
ˆˆ\ j
}
ˆˆk l
)
ˆˆl m
;
ˆˆm n
}
˜˜ 	
[
˘˘ 	
HttpPost
˘˘	 
(
˘˘ 
$str
˘˘ /
)
˘˘/ 0
]
˘˘0 1
public
˙˙ 
async
˙˙ 
Task
˙˙ 
<
˙˙ 
IActionResult
˙˙ '
>
˙˙' (&
MarkAllNotificationsRead
˙˙) A
(
˙˙A B
)
˙˙B C
{
˚˚ 	
var
¸¸ 
userId
¸¸ 
=
¸¸ 
User
¸¸ 
.
¸¸ 
	FindFirst
¸¸ '
(
¸¸' (
System
¸¸( .
.
¸¸. /
Security
¸¸/ 7
.
¸¸7 8
Claims
¸¸8 >
.
¸¸> ?

ClaimTypes
¸¸? I
.
¸¸I J
NameIdentifier
¸¸J X
)
¸¸X Y
?
¸¸Y Z
.
¸¸Z [
Value
¸¸[ `
;
¸¸` a
if
˝˝ 
(
˝˝ 
userId
˝˝ 
==
˝˝ 
null
˝˝ 
)
˝˝ 
return
˝˝  &
Unauthorized
˝˝' 3
(
˝˝3 4
)
˝˝4 5
;
˝˝5 6
var
ˇˇ 
notifications
ˇˇ 
=
ˇˇ 
await
ˇˇ  %
_context
ˇˇ& .
.
ˇˇ. /
Notifications
ˇˇ/ <
.
ÄÄ 
Where
ÄÄ 
(
ÄÄ 
n
ÄÄ 
=>
ÄÄ 
n
ÄÄ 
.
ÄÄ 
UserID
ÄÄ $
==
ÄÄ% '
userId
ÄÄ( .
&&
ÄÄ/ 1
n
ÄÄ2 3
.
ÄÄ3 4
Status
ÄÄ4 :
==
ÄÄ; =
$str
ÄÄ> F
)
ÄÄF G
.
ÅÅ 
ToListAsync
ÅÅ 
(
ÅÅ 
)
ÅÅ 
;
ÅÅ 
foreach
ÉÉ 
(
ÉÉ 
var
ÉÉ 
notification
ÉÉ %
in
ÉÉ& (
notifications
ÉÉ) 6
)
ÉÉ6 7
{
ÑÑ 
notification
ÖÖ 
.
ÖÖ 
Status
ÖÖ #
=
ÖÖ$ %
$str
ÖÖ& ,
;
ÖÖ, -
}
ÜÜ 
await
àà 
_context
àà 
.
àà 
SaveChangesAsync
àà +
(
àà+ ,
)
àà, -
;
àà- .
return
ââ 
Ok
ââ 
(
ââ 
new
ââ 
{
ââ 
message
ââ #
=
ââ$ %
$str
ââ& H
}
ââI J
)
ââJ K
;
ââK L
}
ää 	
[
åå 	

HttpDelete
åå	 
(
åå 
$str
åå (
)
åå( )
]
åå) *
public
çç 
async
çç 
Task
çç 
<
çç 
IActionResult
çç '
>
çç' ( 
DeleteNotification
çç) ;
(
çç; <
int
çç< ?
id
çç@ B
)
ççB C
{
éé 	
var
èè 
notification
èè 
=
èè 
await
èè $
_context
èè% -
.
èè- .
Notifications
èè. ;
.
èè; <
	FindAsync
èè< E
(
èèE F
id
èèF H
)
èèH I
;
èèI J
if
êê 
(
êê 
notification
êê 
==
êê 
null
êê  $
)
êê$ %
return
êê& ,
NotFound
êê- 5
(
êê5 6
)
êê6 7
;
êê7 8
_context
íí 
.
íí 
Notifications
íí "
.
íí" #
Remove
íí# )
(
íí) *
notification
íí* 6
)
íí6 7
;
íí7 8
await
ìì 
_context
ìì 
.
ìì 
SaveChangesAsync
ìì +
(
ìì+ ,
)
ìì, -
;
ìì- .
return
îî 
Ok
îî 
(
îî 
new
îî 
{
îî 
message
îî #
=
îî$ %
$str
îî& <
}
îî= >
)
îî> ?
;
îî? @
}
ïï 	
[
òò 	
HttpGet
òò	 
(
òò 
$str
òò 
)
òò 
]
òò 
public
ôô 
async
ôô 
Task
ôô 
<
ôô 
IActionResult
ôô '
>
ôô' (
GetSettings
ôô) 4
(
ôô4 5
)
ôô5 6
{
öö 	
var
õõ 
settings
õõ 
=
õõ 
await
õõ  
_context
õõ! )
.
õõ) *
SystemSettings
õõ* 8
.
õõ8 9!
FirstOrDefaultAsync
õõ9 L
(
õõL M
)
õõM N
;
õõN O
if
úú 
(
úú 
settings
úú 
==
úú 
null
úú  
)
úú  !
{
ùù 
settings
ûû 
=
ûû 
new
ûû 
SystemSettings
ûû -
(
ûû- .
)
ûû. /
;
ûû/ 0
_context
üü 
.
üü 
SystemSettings
üü '
.
üü' (
Add
üü( +
(
üü+ ,
settings
üü, 4
)
üü4 5
;
üü5 6
await
†† 
_context
†† 
.
†† 
SaveChangesAsync
†† /
(
††/ 0
)
††0 1
;
††1 2
}
°° 
return
¢¢ 
Ok
¢¢ 
(
¢¢ 
settings
¢¢ 
)
¢¢ 
;
¢¢  
}
££ 	
[
•• 	
HttpPut
••	 
(
•• 
$str
•• 
)
•• 
]
•• 
public
¶¶ 
async
¶¶ 
Task
¶¶ 
<
¶¶ 
IActionResult
¶¶ '
>
¶¶' (
UpdateSettings
¶¶) 7
(
¶¶7 8
[
¶¶8 9
FromBody
¶¶9 A
]
¶¶A B)
UpdateSystemSettingsRequest
¶¶C ^
request
¶¶_ f
)
¶¶f g
{
ßß 	
var
®® 
settings
®® 
=
®® 
await
®®  
_context
®®! )
.
®®) *
SystemSettings
®®* 8
.
®®8 9!
FirstOrDefaultAsync
®®9 L
(
®®L M
)
®®M N
;
®®N O
if
©© 
(
©© 
settings
©© 
==
©© 
null
©©  
)
©©  !
{
™™ 
settings
´´ 
=
´´ 
new
´´ 
SystemSettings
´´ -
(
´´- .
)
´´. /
;
´´/ 0
_context
¨¨ 
.
¨¨ 
SystemSettings
¨¨ '
.
¨¨' (
Add
¨¨( +
(
¨¨+ ,
settings
¨¨, 4
)
¨¨4 5
;
¨¨5 6
}
≠≠ 
settings
ØØ 
.
ØØ 
SiteName
ØØ 
=
ØØ 
request
ØØ  '
.
ØØ' (
SiteName
ØØ( 0
??
ØØ1 3
settings
ØØ4 <
.
ØØ< =
SiteName
ØØ= E
;
ØØE F
settings
∞∞ 
.
∞∞ 
	SiteEmail
∞∞ 
=
∞∞  
request
∞∞! (
.
∞∞( )
	SiteEmail
∞∞) 2
??
∞∞3 5
settings
∞∞6 >
.
∞∞> ?
	SiteEmail
∞∞? H
;
∞∞H I
settings
±± 
.
±± 
MaintenanceMode
±± $
=
±±% &
request
±±' .
.
±±. /
MaintenanceMode
±±/ >
??
±±? A
settings
±±B J
.
±±J K
MaintenanceMode
±±K Z
;
±±Z [
settings
≤≤ 
.
≤≤ 
MaxLoginAttempts
≤≤ %
=
≤≤& '
request
≤≤( /
.
≤≤/ 0
MaxLoginAttempts
≤≤0 @
??
≤≤A C
settings
≤≤D L
.
≤≤L M
MaxLoginAttempts
≤≤M ]
;
≤≤] ^
settings
≥≥ 
.
≥≥ 
SessionTimeout
≥≥ #
=
≥≥$ %
request
≥≥& -
.
≥≥- .
SessionTimeout
≥≥. <
??
≥≥= ?
settings
≥≥@ H
.
≥≥H I
SessionTimeout
≥≥I W
;
≥≥W X
settings
¥¥ 
.
¥¥ 
EnableTwoFactor
¥¥ $
=
¥¥% &
request
¥¥' .
.
¥¥. /
EnableTwoFactor
¥¥/ >
??
¥¥? A
settings
¥¥B J
.
¥¥J K
EnableTwoFactor
¥¥K Z
;
¥¥Z [
settings
µµ 
.
µµ 
EnableAuditLogs
µµ $
=
µµ% &
request
µµ' .
.
µµ. /
EnableAuditLogs
µµ/ >
??
µµ? A
settings
µµB J
.
µµJ K
EnableAuditLogs
µµK Z
;
µµZ [
settings
∂∂ 
.
∂∂ 
NotificationEmail
∂∂ &
=
∂∂' (
request
∂∂) 0
.
∂∂0 1
NotificationEmail
∂∂1 B
??
∂∂C E
settings
∂∂F N
.
∂∂N O
NotificationEmail
∂∂O `
;
∂∂` a
settings
∑∑ 
.
∑∑ 
EmailOnNewTickets
∑∑ &
=
∑∑' (
request
∑∑) 0
.
∑∑0 1
EmailOnNewTickets
∑∑1 B
??
∑∑C E
settings
∑∑F N
.
∑∑N O
EmailOnNewTickets
∑∑O `
;
∑∑` a
settings
∏∏ 
.
∏∏ $
EmailOnPaymentReceived
∏∏ +
=
∏∏, -
request
∏∏. 5
.
∏∏5 6$
EmailOnPaymentReceived
∏∏6 L
??
∏∏M O
settings
∏∏P X
.
∏∏X Y$
EmailOnPaymentReceived
∏∏Y o
;
∏∏o p
settings
ππ 
.
ππ !
EmailOnSystemErrors
ππ (
=
ππ) *
request
ππ+ 2
.
ππ2 3!
EmailOnSystemErrors
ππ3 F
??
ππG I
settings
ππJ R
.
ππR S!
EmailOnSystemErrors
ππS f
;
ππf g
settings
∫∫ 
.
∫∫ #
EmailOnSecurityAlerts
∫∫ *
=
∫∫+ ,
request
∫∫- 4
.
∫∫4 5#
EmailOnSecurityAlerts
∫∫5 J
??
∫∫K M
settings
∫∫N V
.
∫∫V W#
EmailOnSecurityAlerts
∫∫W l
;
∫∫l m
settings
ªª 
.
ªª 
	UpdatedAt
ªª 
=
ªª  
DateTime
ªª! )
.
ªª) *
UtcNow
ªª* 0
;
ªª0 1
await
ΩΩ 
_context
ΩΩ 
.
ΩΩ 
SaveChangesAsync
ΩΩ +
(
ΩΩ+ ,
)
ΩΩ, -
;
ΩΩ- .
return
ææ 
Ok
ææ 
(
ææ 
new
ææ 
{
ææ 
message
ææ #
=
ææ$ %
$str
ææ& E
,
ææE F
settings
ææG O
}
ææP Q
)
ææQ R
;
ææR S
}
øø 	
[
¡¡ 	
	Authorize
¡¡	 
(
¡¡ 
Roles
¡¡ 
=
¡¡ 
$str
¡¡ '
)
¡¡' (
]
¡¡( )
[
¬¬ 	
HttpGet
¬¬	 
(
¬¬ 
$str
¬¬ #
)
¬¬# $
]
¬¬$ %
public
√√ 
async
√√ 
Task
√√ 
<
√√ 
IActionResult
√√ '
>
√√' ( 
GetSuperAdminCount
√√) ;
(
√√; <
)
√√< =
{
ƒƒ 	
var
≈≈ 
superAdminRoleId
≈≈  
=
≈≈! "
await
≈≈# (
_context
≈≈) 1
.
≈≈1 2
Roles
≈≈2 7
.
∆∆ 
Where
∆∆ 
(
∆∆ 
r
∆∆ 
=>
∆∆ 
r
∆∆ 
.
∆∆ 
Name
∆∆ "
==
∆∆# %
$str
∆∆& 2
)
∆∆2 3
.
«« 
Select
«« 
(
«« 
r
«« 
=>
«« 
r
«« 
.
«« 
Id
«« !
)
««! "
.
»» !
FirstOrDefaultAsync
»» $
(
»»$ %
)
»»% &
;
»»& '
var
   
count
   
=
   
$num
   
;
   
if
ÀÀ 
(
ÀÀ 
!
ÀÀ 
string
ÀÀ 
.
ÀÀ 
IsNullOrEmpty
ÀÀ %
(
ÀÀ% &
superAdminRoleId
ÀÀ& 6
)
ÀÀ6 7
)
ÀÀ7 8
{
ÃÃ 
count
ÕÕ 
=
ÕÕ 
await
ÕÕ 
_context
ÕÕ &
.
ÕÕ& '
	UserRoles
ÕÕ' 0
.
ŒŒ 

CountAsync
ŒŒ 
(
ŒŒ  
ur
ŒŒ  "
=>
ŒŒ# %
ur
ŒŒ& (
.
ŒŒ( )
RoleId
ŒŒ) /
==
ŒŒ0 2
superAdminRoleId
ŒŒ3 C
)
ŒŒC D
;
ŒŒD E
}
œœ 
var
—— 
	canCreate
—— 
=
—— 
Math
——  
.
——  !
Max
——! $
(
——$ %
$num
——% &
,
——& '
$num
——( )
-
——* +
count
——, 1
)
——1 2
;
——2 3
return
““ 
Ok
““ 
(
““ 
new
““ 
{
““ 
count
““ !
,
““! "
	canCreate
““# ,
}
““- .
)
““. /
;
““/ 0
}
”” 	
[
’’ 	
	Authorize
’’	 
(
’’ 
Roles
’’ 
=
’’ 
$str
’’ '
)
’’' (
]
’’( )
[
÷÷ 	
HttpGet
÷÷	 
(
÷÷ 
$str
÷÷ "
)
÷÷" #
]
÷÷# $
public
◊◊ 
async
◊◊ 
Task
◊◊ 
<
◊◊ 
IActionResult
◊◊ '
>
◊◊' (
GetSuspendedUsers
◊◊) :
(
◊◊: ;
)
◊◊; <
{
ÿÿ 	
var
ŸŸ 
suspendedUsers
ŸŸ 
=
ŸŸ  
await
ŸŸ! &
_context
ŸŸ' /
.
ŸŸ/ 0
LoginAttempts
ŸŸ0 =
.
⁄⁄ 
Where
⁄⁄ 
(
⁄⁄ 
la
⁄⁄ 
=>
⁄⁄ 
la
⁄⁄ 
.
⁄⁄  
LockedUntil
⁄⁄  +
.
⁄⁄+ ,
HasValue
⁄⁄, 4
&&
⁄⁄5 7
la
⁄⁄8 :
.
⁄⁄: ;
LockedUntil
⁄⁄; F
>
⁄⁄G H
DateTime
⁄⁄I Q
.
⁄⁄Q R
UtcNow
⁄⁄R X
)
⁄⁄X Y
.
€€ 
Include
€€ 
(
€€ 
la
€€ 
=>
€€ 
la
€€ !
.
€€! "
User
€€" &
)
€€& '
.
‹‹ 
OrderByDescending
‹‹ "
(
‹‹" #
la
‹‹# %
=>
‹‹& (
la
‹‹) +
.
‹‹+ ,
LockedUntil
‹‹, 7
)
‹‹7 8
.
›› 
Select
›› 
(
›› 
la
›› 
=>
›› 
new
›› !
{
ﬁﬁ 
la
ﬂﬂ 
.
ﬂﬂ 
LoginAttemptID
ﬂﬂ %
,
ﬂﬂ% &
la
‡‡ 
.
‡‡ 
UserID
‡‡ 
,
‡‡ 
UserName
·· 
=
·· 
la
·· !
.
··! "
User
··" &
.
··& '
	FirstName
··' 0
+
··1 2
$str
··3 6
+
··7 8
la
··9 ;
.
··; <
User
··< @
.
··@ A
LastName
··A I
,
··I J
Email
‚‚ 
=
‚‚ 
la
‚‚ 
.
‚‚ 
User
‚‚ #
.
‚‚# $
Email
‚‚$ )
,
‚‚) *
FailedAttempts
„„ "
=
„„# $
la
„„% '
.
„„' (
FailedAttempts
„„( 6
,
„„6 7

LockReason
‰‰ 
=
‰‰  
la
‰‰! #
.
‰‰# $

LockReason
‰‰$ .
,
‰‰. /
LockedUntil
ÂÂ 
=
ÂÂ  !
la
ÂÂ" $
.
ÂÂ$ %
LockedUntil
ÂÂ% 0
,
ÂÂ0 1
RemainingMinutes
ÊÊ $
=
ÊÊ% &
(
ÊÊ' (
int
ÊÊ( +
)
ÊÊ+ ,
Math
ÊÊ, 0
.
ÊÊ0 1
Ceiling
ÊÊ1 8
(
ÊÊ8 9
(
ÊÊ9 :
la
ÊÊ: <
.
ÊÊ< =
LockedUntil
ÊÊ= H
.
ÊÊH I
Value
ÊÊI N
-
ÊÊO P
DateTime
ÊÊQ Y
.
ÊÊY Z
UtcNow
ÊÊZ `
)
ÊÊ` a
.
ÊÊa b
TotalMinutes
ÊÊb n
)
ÊÊn o
}
ÁÁ 
)
ÁÁ 
.
ËË 
ToListAsync
ËË 
(
ËË 
)
ËË 
;
ËË 
return
ÍÍ 
Ok
ÍÍ 
(
ÍÍ 
suspendedUsers
ÍÍ $
)
ÍÍ$ %
;
ÍÍ% &
}
ÎÎ 	
[
ÌÌ 	
	Authorize
ÌÌ	 
(
ÌÌ 
Roles
ÌÌ 
=
ÌÌ 
$str
ÌÌ '
)
ÌÌ' (
]
ÌÌ( )
[
ÓÓ 	
HttpPost
ÓÓ	 
(
ÓÓ 
$str
ÓÓ (
)
ÓÓ( )
]
ÓÓ) *
public
ÔÔ 
async
ÔÔ 
Task
ÔÔ 
<
ÔÔ 
IActionResult
ÔÔ '
>
ÔÔ' (

UnlockUser
ÔÔ) 3
(
ÔÔ3 4
string
ÔÔ4 :
userId
ÔÔ; A
)
ÔÔA B
{
 	
var
ÒÒ 
attempt
ÒÒ 
=
ÒÒ 
await
ÒÒ 
_context
ÒÒ  (
.
ÒÒ( )
LoginAttempts
ÒÒ) 6
.
ÒÒ6 7!
FirstOrDefaultAsync
ÒÒ7 J
(
ÒÒJ K
la
ÒÒK M
=>
ÒÒN P
la
ÒÒQ S
.
ÒÒS T
UserID
ÒÒT Z
==
ÒÒ[ ]
userId
ÒÒ^ d
)
ÒÒd e
;
ÒÒe f
if
ÚÚ 
(
ÚÚ 
attempt
ÚÚ 
==
ÚÚ 
null
ÚÚ 
)
ÚÚ  
return
ÛÛ 
NotFound
ÛÛ 
(
ÛÛ  
new
ÛÛ  #
{
ÛÛ$ %
message
ÛÛ& -
=
ÛÛ. /
$str
ÛÛ0 @
}
ÛÛA B
)
ÛÛB C
;
ÛÛC D
attempt
ıı 
.
ıı 
FailedAttempts
ıı "
=
ıı# $
$num
ıı% &
;
ıı& '
attempt
ˆˆ 
.
ˆˆ 
LockedUntil
ˆˆ 
=
ˆˆ  !
null
ˆˆ" &
;
ˆˆ& '
attempt
˜˜ 
.
˜˜ 

LockReason
˜˜ 
=
˜˜  
null
˜˜! %
;
˜˜% &
await
¯¯ 
_context
¯¯ 
.
¯¯ 
SaveChangesAsync
¯¯ +
(
¯¯+ ,
)
¯¯, -
;
¯¯- .
return
˙˙ 
Ok
˙˙ 
(
˙˙ 
new
˙˙ 
{
˙˙ 
message
˙˙ #
=
˙˙$ %
$str
˙˙& B
}
˙˙C D
)
˙˙D E
;
˙˙E F
}
˚˚ 	
[
˝˝ 	
	Authorize
˝˝	 
(
˝˝ 
Roles
˝˝ 
=
˝˝ 
$str
˝˝ '
)
˝˝' (
]
˝˝( )
[
˛˛ 	
HttpPost
˛˛	 
(
˛˛ 
$str
˛˛ %
)
˛˛% &
]
˛˛& '
public
ˇˇ 
async
ˇˇ 
Task
ˇˇ 
<
ˇˇ 
IActionResult
ˇˇ '
>
ˇˇ' (
CreateSuperAdmin
ˇˇ) 9
(
ˇˇ9 :
[
ˇˇ: ;
FromBody
ˇˇ; C
]
ˇˇC D%
CreateSuperAdminRequest
ˇˇE \
request
ˇˇ] d
)
ˇˇd e
{
ÄÄ 	
if
ÅÅ 
(
ÅÅ 
string
ÅÅ 
.
ÅÅ  
IsNullOrWhiteSpace
ÅÅ )
(
ÅÅ) *
request
ÅÅ* 1
.
ÅÅ1 2
Email
ÅÅ2 7
)
ÅÅ7 8
||
ÅÅ9 ;
string
ÅÅ< B
.
ÅÅB C 
IsNullOrWhiteSpace
ÅÅC U
(
ÅÅU V
request
ÅÅV ]
.
ÅÅ] ^
Password
ÅÅ^ f
)
ÅÅf g
)
ÅÅg h
return
ÇÇ 

BadRequest
ÇÇ !
(
ÇÇ! "
new
ÇÇ" %
{
ÇÇ& '
message
ÇÇ( /
=
ÇÇ0 1
$str
ÇÇ2 S
}
ÇÇT U
)
ÇÇU V
;
ÇÇV W
if
ÑÑ 
(
ÑÑ 
request
ÑÑ 
.
ÑÑ 
Password
ÑÑ  
.
ÑÑ  !
Length
ÑÑ! '
<
ÑÑ( )
$num
ÑÑ* +
)
ÑÑ+ ,
return
ÖÖ 

BadRequest
ÖÖ !
(
ÖÖ! "
new
ÖÖ" %
{
ÖÖ& '
message
ÖÖ( /
=
ÖÖ0 1
$str
ÖÖ2 Z
}
ÖÖ[ \
)
ÖÖ\ ]
;
ÖÖ] ^
var
áá 
existingUser
áá 
=
áá 
await
áá $
_context
áá% -
.
áá- .
Users
áá. 3
.
áá3 4!
FirstOrDefaultAsync
áá4 G
(
ááG H
u
ááH I
=>
ááJ L
u
ááM N
.
ááN O
Email
ááO T
==
ááU W
request
ááX _
.
áá_ `
Email
áá` e
)
ááe f
;
ááf g
if
àà 
(
àà 
existingUser
àà 
!=
àà 
null
àà  $
)
àà$ %
return
ââ 

BadRequest
ââ !
(
ââ! "
new
ââ" %
{
ââ& '
message
ââ( /
=
ââ0 1
$str
ââ2 H
}
ââI J
)
ââJ K
;
ââK L
var
ãã 
newUser
ãã 
=
ãã 
new
ãã 
ApplicationUser
ãã -
{
åå 
UserName
çç 
=
çç 
request
çç "
.
çç" #
Email
çç# (
,
çç( )
Email
éé 
=
éé 
request
éé 
.
éé  
Email
éé  %
,
éé% &
	FirstName
èè 
=
èè 
request
èè #
.
èè# $
	FirstName
èè$ -
??
èè. 0
string
èè1 7
.
èè7 8
Empty
èè8 =
,
èè= >
LastName
êê 
=
êê 
request
êê "
.
êê" #
LastName
êê# +
??
êê, .
string
êê/ 5
.
êê5 6
Empty
êê6 ;
,
êê; <
Role
ëë 
=
ëë 
$str
ëë #
,
ëë# $
EmailConfirmed
íí 
=
íí  
true
íí! %
,
íí% &
Status
ìì 
=
ìì 
$str
ìì !
}
îî 
;
îî 
var
ññ 
userManager
ññ 
=
ññ 
HttpContext
ññ )
.
ññ) *
RequestServices
ññ* 9
.
ññ9 :

GetService
ññ: D
(
ññD E
typeof
ññE K
(
ññK L
	Microsoft
ññL U
.
ññU V

AspNetCore
ññV `
.
ññ` a
Identity
ñña i
.
ññi j
UserManager
ññj u
<
ññu v
ApplicationUserññv Ö
>ññÖ Ü
)ññÜ á
)ññá à
asññâ ã
	Microsoftññå ï
.ññï ñ

AspNetCoreñññ †
.ññ† °
Identityññ° ©
.ññ© ™
UserManagerññ™ µ
<ññµ ∂
ApplicationUserññ∂ ≈
>ññ≈ ∆
;ññ∆ «
if
óó 
(
óó 
userManager
óó 
==
óó 
null
óó #
)
óó# $
return
óó% +

BadRequest
óó, 6
(
óó6 7
new
óó7 :
{
óó; <
message
óó= D
=
óóE F
$str
óóG c
}
óód e
)
óóe f
;
óóf g
var
ôô 
result
ôô 
=
ôô 
await
ôô 
userManager
ôô *
.
ôô* +
CreateAsync
ôô+ 6
(
ôô6 7
newUser
ôô7 >
,
ôô> ?
request
ôô@ G
.
ôôG H
Password
ôôH P
)
ôôP Q
;
ôôQ R
if
öö 
(
öö 
!
öö 
result
öö 
.
öö 
	Succeeded
öö !
)
öö! "
return
õõ 

BadRequest
õõ !
(
õõ! "
new
õõ" %
{
õõ& '
message
õõ( /
=
õõ0 1
string
õõ2 8
.
õõ8 9
Join
õõ9 =
(
õõ= >
$str
õõ> B
,
õõB C
result
õõD J
.
õõJ K
Errors
õõK Q
.
õõQ R
Select
õõR X
(
õõX Y
e
õõY Z
=>
õõ[ ]
e
õõ^ _
.
õõ_ `
Description
õõ` k
)
õõk l
)
õõl m
}
õõn o
)
õõo p
;
õõp q
await
ùù 
userManager
ùù 
.
ùù 
AddToRoleAsync
ùù ,
(
ùù, -
newUser
ùù- 4
,
ùù4 5
$str
ùù6 B
)
ùùB C
;
ùùC D
return
üü 
Ok
üü 
(
üü 
new
üü 
{
üü 
message
üü #
=
üü$ %
$str
üü& G
,
üüG H
userId
üüI O
=
üüP Q
newUser
üüR Y
.
üüY Z
Id
üüZ \
}
üü] ^
)
üü^ _
;
üü_ `
}
†† 	
}
°° 
public
§§ 

class
§§ #
UpdateCustomerRequest
§§ &
{
•• 
public
¶¶ 
string
¶¶ 
	FirstName
¶¶ 
{
¶¶  !
get
¶¶" %
;
¶¶% &
set
¶¶' *
;
¶¶* +
}
¶¶, -
=
¶¶. /
string
¶¶0 6
.
¶¶6 7
Empty
¶¶7 <
;
¶¶< =
public
ßß 
string
ßß 
LastName
ßß 
{
ßß  
get
ßß! $
;
ßß$ %
set
ßß& )
;
ßß) *
}
ßß+ ,
=
ßß- .
string
ßß/ 5
.
ßß5 6
Empty
ßß6 ;
;
ßß; <
public
®® 
string
®® 
Email
®® 
{
®® 
get
®® !
;
®®! "
set
®®# &
;
®®& '
}
®®( )
=
®®* +
string
®®, 2
.
®®2 3
Empty
®®3 8
;
®®8 9
public
©© 
string
©© 
Status
©© 
{
©© 
get
©© "
;
©©" #
set
©©$ '
;
©©' (
}
©©) *
=
©©+ ,
string
©©- 3
.
©©3 4
Empty
©©4 9
;
©©9 :
}
™™ 
public
¨¨ 

class
¨¨  
CreateStaffRequest
¨¨ #
{
≠≠ 
public
ÆÆ 
string
ÆÆ 
Email
ÆÆ 
{
ÆÆ 
get
ÆÆ !
;
ÆÆ! "
set
ÆÆ# &
;
ÆÆ& '
}
ÆÆ( )
=
ÆÆ* +
string
ÆÆ, 2
.
ÆÆ2 3
Empty
ÆÆ3 8
;
ÆÆ8 9
public
ØØ 
string
ØØ 
	FirstName
ØØ 
{
ØØ  !
get
ØØ" %
;
ØØ% &
set
ØØ' *
;
ØØ* +
}
ØØ, -
=
ØØ. /
string
ØØ0 6
.
ØØ6 7
Empty
ØØ7 <
;
ØØ< =
public
∞∞ 
string
∞∞ 
LastName
∞∞ 
{
∞∞  
get
∞∞! $
;
∞∞$ %
set
∞∞& )
;
∞∞) *
}
∞∞+ ,
=
∞∞- .
string
∞∞/ 5
.
∞∞5 6
Empty
∞∞6 ;
;
∞∞; <
public
±± 
string
±± 
Password
±± 
{
±±  
get
±±! $
;
±±$ %
set
±±& )
;
±±) *
}
±±+ ,
=
±±- .
string
±±/ 5
.
±±5 6
Empty
±±6 ;
;
±±; <
public
≤≤ 
string
≤≤ 
Role
≤≤ 
{
≤≤ 
get
≤≤  
;
≤≤  !
set
≤≤" %
;
≤≤% &
}
≤≤' (
=
≤≤) *
$str
≤≤+ 2
;
≤≤2 3
}
≥≥ 
public
µµ 

class
µµ  
UpdateStaffRequest
µµ #
{
∂∂ 
public
∑∑ 
string
∑∑ 
	FirstName
∑∑ 
{
∑∑  !
get
∑∑" %
;
∑∑% &
set
∑∑' *
;
∑∑* +
}
∑∑, -
=
∑∑. /
string
∑∑0 6
.
∑∑6 7
Empty
∑∑7 <
;
∑∑< =
public
∏∏ 
string
∏∏ 
LastName
∏∏ 
{
∏∏  
get
∏∏! $
;
∏∏$ %
set
∏∏& )
;
∏∏) *
}
∏∏+ ,
=
∏∏- .
string
∏∏/ 5
.
∏∏5 6
Empty
∏∏6 ;
;
∏∏; <
public
ππ 
string
ππ 
Status
ππ 
{
ππ 
get
ππ "
;
ππ" #
set
ππ$ '
;
ππ' (
}
ππ) *
=
ππ+ ,
string
ππ- 3
.
ππ3 4
Empty
ππ4 9
;
ππ9 :
public
∫∫ 
string
∫∫ 
Role
∫∫ 
{
∫∫ 
get
∫∫  
;
∫∫  !
set
∫∫" %
;
∫∫% &
}
∫∫' (
=
∫∫) *
string
∫∫+ 1
.
∫∫1 2
Empty
∫∫2 7
;
∫∫7 8
public
ªª 
string
ªª 
?
ªª 
Password
ªª 
{
ªª  !
get
ªª" %
;
ªª% &
set
ªª' *
;
ªª* +
}
ªª, -
}
ºº 
public
ææ 

class
ææ 
UpdatePlanRequest
ææ "
{
øø 
public
¿¿ 
string
¿¿ 
PlanName
¿¿ 
{
¿¿  
get
¿¿! $
;
¿¿$ %
set
¿¿& )
;
¿¿) *
}
¿¿+ ,
=
¿¿- .
string
¿¿/ 5
.
¿¿5 6
Empty
¿¿6 ;
;
¿¿; <
public
¡¡ 
decimal
¡¡ 
?
¡¡ 
	SpeedMbps
¡¡ !
{
¡¡" #
get
¡¡$ '
;
¡¡' (
set
¡¡) ,
;
¡¡, -
}
¡¡. /
public
¬¬ 
decimal
¬¬ 
?
¬¬ 
Price
¬¬ 
{
¬¬ 
get
¬¬  #
;
¬¬# $
set
¬¬% (
;
¬¬( )
}
¬¬* +
}
√√ 
public
≈≈ 

class
≈≈ !
UpdateTicketRequest
≈≈ $
{
∆∆ 
public
«« 
string
«« 
Status
«« 
{
«« 
get
«« "
;
««" #
set
««$ '
;
««' (
}
««) *
=
««+ ,
string
««- 3
.
««3 4
Empty
««4 9
;
««9 :
public
»» 
string
»» 
?
»» 
AssignedStaffID
»» &
{
»»' (
get
»») ,
;
»», -
set
»». 1
;
»»1 2
}
»»3 4
}
…… 
public
ÀÀ 

class
ÀÀ  
ReplyTicketRequest
ÀÀ #
{
ÃÃ 
public
ÕÕ 
string
ÕÕ 
Message
ÕÕ 
{
ÕÕ 
get
ÕÕ  #
;
ÕÕ# $
set
ÕÕ% (
;
ÕÕ( )
}
ÕÕ* +
=
ÕÕ, -
string
ÕÕ. 4
.
ÕÕ4 5
Empty
ÕÕ5 :
;
ÕÕ: ;
}
ŒŒ 
public
–– 

class
–– '
UpdateSubscriptionRequest
–– *
{
—— 
public
““ 
string
““ 
Status
““ 
{
““ 
get
““ "
;
““" #
set
““$ '
;
““' (
}
““) *
=
““+ ,
string
““- 3
.
““3 4
Empty
““4 9
;
““9 :
public
”” 
int
”” 
?
”” 
PlanID
”” 
{
”” 
get
””  
;
””  !
set
””" %
;
””% &
}
””' (
public
‘‘ 
string
‘‘ 
?
‘‘ 
EndDate
‘‘ 
{
‘‘  
get
‘‘! $
;
‘‘$ %
set
‘‘& )
;
‘‘) *
}
‘‘+ ,
}
’’ 
public
◊◊ 

class
◊◊ 
CreateFAQRequest
◊◊ !
{
ÿÿ 
public
ŸŸ 
string
ŸŸ 
Question
ŸŸ 
{
ŸŸ  
get
ŸŸ! $
;
ŸŸ$ %
set
ŸŸ& )
;
ŸŸ) *
}
ŸŸ+ ,
=
ŸŸ- .
string
ŸŸ/ 5
.
ŸŸ5 6
Empty
ŸŸ6 ;
;
ŸŸ; <
public
⁄⁄ 
string
⁄⁄ 
Answer
⁄⁄ 
{
⁄⁄ 
get
⁄⁄ "
;
⁄⁄" #
set
⁄⁄$ '
;
⁄⁄' (
}
⁄⁄) *
=
⁄⁄+ ,
string
⁄⁄- 3
.
⁄⁄3 4
Empty
⁄⁄4 9
;
⁄⁄9 :
public
€€ 
string
€€ 
Category
€€ 
{
€€  
get
€€! $
;
€€$ %
set
€€& )
;
€€) *
}
€€+ ,
=
€€- .
string
€€/ 5
.
€€5 6
Empty
€€6 ;
;
€€; <
public
‹‹ 
string
‹‹ 
Status
‹‹ 
{
‹‹ 
get
‹‹ "
;
‹‹" #
set
‹‹$ '
;
‹‹' (
}
‹‹) *
=
‹‹+ ,
$str
‹‹- 4
;
‹‹4 5
}
›› 
public
ﬂﬂ 

class
ﬂﬂ 
UpdateFAQRequest
ﬂﬂ !
{
‡‡ 
public
·· 
string
·· 
Question
·· 
{
··  
get
··! $
;
··$ %
set
··& )
;
··) *
}
··+ ,
=
··- .
string
··/ 5
.
··5 6
Empty
··6 ;
;
··; <
public
‚‚ 
string
‚‚ 
Answer
‚‚ 
{
‚‚ 
get
‚‚ "
;
‚‚" #
set
‚‚$ '
;
‚‚' (
}
‚‚) *
=
‚‚+ ,
string
‚‚- 3
.
‚‚3 4
Empty
‚‚4 9
;
‚‚9 :
public
„„ 
string
„„ 
Category
„„ 
{
„„  
get
„„! $
;
„„$ %
set
„„& )
;
„„) *
}
„„+ ,
=
„„- .
string
„„/ 5
.
„„5 6
Empty
„„6 ;
;
„„; <
public
‰‰ 
string
‰‰ 
Status
‰‰ 
{
‰‰ 
get
‰‰ "
;
‰‰" #
set
‰‰$ '
;
‰‰' (
}
‰‰) *
=
‰‰+ ,
string
‰‰- 3
.
‰‰3 4
Empty
‰‰4 9
;
‰‰9 :
}
ÂÂ 
public
ÁÁ 

class
ÁÁ 
AdminTopUpRequest
ÁÁ "
{
ËË 
[
ÈÈ 	
Required
ÈÈ	 
]
ÈÈ 
public
ÍÍ 
decimal
ÍÍ 
Amount
ÍÍ 
{
ÍÍ 
get
ÍÍ  #
;
ÍÍ# $
set
ÍÍ% (
;
ÍÍ( )
}
ÍÍ* +
}
ÎÎ 
public
ÌÌ 

class
ÌÌ (
UpdatePrepaidStatusRequest
ÌÌ +
{
ÓÓ 
public
ÔÔ 
string
ÔÔ 
Status
ÔÔ 
{
ÔÔ 
get
ÔÔ "
;
ÔÔ" #
set
ÔÔ$ '
;
ÔÔ' (
}
ÔÔ) *
=
ÔÔ+ ,
string
ÔÔ- 3
.
ÔÔ3 4
Empty
ÔÔ4 9
;
ÔÔ9 :
}
 
public
ÚÚ 

class
ÚÚ &
UpdatePromoStatusRequest
ÚÚ )
{
ÛÛ 
public
ÙÙ 
string
ÙÙ 
Status
ÙÙ 
{
ÙÙ 
get
ÙÙ "
;
ÙÙ" #
set
ÙÙ$ '
;
ÙÙ' (
}
ÙÙ) *
=
ÙÙ+ ,
string
ÙÙ- 3
.
ÙÙ3 4
Empty
ÙÙ4 9
;
ÙÙ9 :
}
ıı 
public
˜˜ 

class
˜˜ %
CreatePromoOfferRequest
˜˜ (
{
¯¯ 
public
˘˘ 
string
˘˘ 
Title
˘˘ 
{
˘˘ 
get
˘˘ !
;
˘˘! "
set
˘˘# &
;
˘˘& '
}
˘˘( )
=
˘˘* +
string
˘˘, 2
.
˘˘2 3
Empty
˘˘3 8
;
˘˘8 9
public
˙˙ 
string
˙˙ 
Description
˙˙ !
{
˙˙" #
get
˙˙$ '
;
˙˙' (
set
˙˙) ,
;
˙˙, -
}
˙˙. /
=
˙˙0 1
string
˙˙2 8
.
˙˙8 9
Empty
˙˙9 >
;
˙˙> ?
[
˚˚ 	
Required
˚˚	 
]
˚˚ 
public
¸¸ 
decimal
¸¸ 
Price
¸¸ 
{
¸¸ 
get
¸¸ "
;
¸¸" #
set
¸¸$ '
;
¸¸' (
}
¸¸) *
public
˝˝ 
string
˝˝ 
Data
˝˝ 
{
˝˝ 
get
˝˝  
;
˝˝  !
set
˝˝" %
;
˝˝% &
}
˝˝' (
=
˝˝) *
string
˝˝+ 1
.
˝˝1 2
Empty
˝˝2 7
;
˝˝7 8
public
˛˛ 
string
˛˛ 
Validity
˛˛ 
{
˛˛  
get
˛˛! $
;
˛˛$ %
set
˛˛& )
;
˛˛) *
}
˛˛+ ,
=
˛˛- .
string
˛˛/ 5
.
˛˛5 6
Empty
˛˛6 ;
;
˛˛; <
public
ˇˇ 
string
ˇˇ 
?
ˇˇ 
Badge
ˇˇ 
{
ˇˇ 
get
ˇˇ "
;
ˇˇ" #
set
ˇˇ$ '
;
ˇˇ' (
}
ˇˇ) *
public
ÄÄ 
string
ÄÄ 
?
ÄÄ 
Color
ÄÄ 
{
ÄÄ 
get
ÄÄ "
;
ÄÄ" #
set
ÄÄ$ '
;
ÄÄ' (
}
ÄÄ) *
}
ÅÅ 
public
ÉÉ 

class
ÉÉ &
CreateActivityLogRequest
ÉÉ )
{
ÑÑ 
public
ÖÖ 
string
ÖÖ 
Action
ÖÖ 
{
ÖÖ 
get
ÖÖ "
;
ÖÖ" #
set
ÖÖ$ '
;
ÖÖ' (
}
ÖÖ) *
=
ÖÖ+ ,
string
ÖÖ- 3
.
ÖÖ3 4
Empty
ÖÖ4 9
;
ÖÖ9 :
public
ÜÜ 
string
ÜÜ 
Description
ÜÜ !
{
ÜÜ" #
get
ÜÜ$ '
;
ÜÜ' (
set
ÜÜ) ,
;
ÜÜ, -
}
ÜÜ. /
=
ÜÜ0 1
string
ÜÜ2 8
.
ÜÜ8 9
Empty
ÜÜ9 >
;
ÜÜ> ?
public
áá 
string
áá 
Type
áá 
{
áá 
get
áá  
;
áá  !
set
áá" %
;
áá% &
}
áá' (
=
áá) *
string
áá+ 1
.
áá1 2
Empty
áá2 7
;
áá7 8
}
àà 
public
ää 

class
ää %
UpdatePromoOfferRequest
ää (
{
ãã 
public
åå 
string
åå 
Title
åå 
{
åå 
get
åå !
;
åå! "
set
åå# &
;
åå& '
}
åå( )
=
åå* +
string
åå, 2
.
åå2 3
Empty
åå3 8
;
åå8 9
public
çç 
string
çç 
Description
çç !
{
çç" #
get
çç$ '
;
çç' (
set
çç) ,
;
çç, -
}
çç. /
=
çç0 1
string
çç2 8
.
çç8 9
Empty
çç9 >
;
çç> ?
[
éé 	
Required
éé	 
]
éé 
public
èè 
decimal
èè 
Price
èè 
{
èè 
get
èè "
;
èè" #
set
èè$ '
;
èè' (
}
èè) *
public
êê 
string
êê 
Data
êê 
{
êê 
get
êê  
;
êê  !
set
êê" %
;
êê% &
}
êê' (
=
êê) *
string
êê+ 1
.
êê1 2
Empty
êê2 7
;
êê7 8
public
ëë 
string
ëë 
Validity
ëë 
{
ëë  
get
ëë! $
;
ëë$ %
set
ëë& )
;
ëë) *
}
ëë+ ,
=
ëë- .
string
ëë/ 5
.
ëë5 6
Empty
ëë6 ;
;
ëë; <
public
íí 
string
íí 
?
íí 
Badge
íí 
{
íí 
get
íí "
;
íí" #
set
íí$ '
;
íí' (
}
íí) *
public
ìì 
string
ìì 
?
ìì 
Color
ìì 
{
ìì 
get
ìì "
;
ìì" #
set
ìì$ '
;
ìì' (
}
ìì) *
[
îî 	
Required
îî	 
]
îî 
public
ïï 
bool
ïï 
IsActive
ïï 
{
ïï 
get
ïï "
;
ïï" #
set
ïï$ '
;
ïï' (
}
ïï) *
=
ïï+ ,
true
ïï- 1
;
ïï1 2
}
ññ 
public
òò 

class
òò 
UpdateRoleRequest
òò "
{
ôô 
public
öö 
string
öö 
[
öö 
]
öö 
?
öö 
Permissions
öö $
{
öö% &
get
öö' *
;
öö* +
set
öö, /
;
öö/ 0
}
öö1 2
}
õõ 
public
ùù 

class
ùù '
CreateNotificationRequest
ùù *
{
ûû 
public
üü 
string
üü 
Message
üü 
{
üü 
get
üü  #
;
üü# $
set
üü% (
;
üü( )
}
üü* +
=
üü, -
string
üü. 4
.
üü4 5
Empty
üü5 :
;
üü: ;
public
†† 
string
†† 
?
†† 
Type
†† 
{
†† 
get
†† !
;
††! "
set
††# &
;
††& '
}
††( )
=
††* +
$str
††, 2
;
††2 3
}
°° 
public
££ 

class
££ )
UpdateSystemSettingsRequest
££ ,
{
§§ 
public
•• 
string
•• 
?
•• 
SiteName
•• 
{
••  !
get
••" %
;
••% &
set
••' *
;
••* +
}
••, -
public
¶¶ 
string
¶¶ 
?
¶¶ 
	SiteEmail
¶¶  
{
¶¶! "
get
¶¶# &
;
¶¶& '
set
¶¶( +
;
¶¶+ ,
}
¶¶- .
public
ßß 
bool
ßß 
?
ßß 
MaintenanceMode
ßß $
{
ßß% &
get
ßß' *
;
ßß* +
set
ßß, /
;
ßß/ 0
}
ßß1 2
public
®® 
int
®® 
?
®® 
MaxLoginAttempts
®® $
{
®®% &
get
®®' *
;
®®* +
set
®®, /
;
®®/ 0
}
®®1 2
public
©© 
int
©© 
?
©© 
SessionTimeout
©© "
{
©©# $
get
©©% (
;
©©( )
set
©©* -
;
©©- .
}
©©/ 0
public
™™ 
bool
™™ 
?
™™ 
EnableTwoFactor
™™ $
{
™™% &
get
™™' *
;
™™* +
set
™™, /
;
™™/ 0
}
™™1 2
public
´´ 
bool
´´ 
?
´´ 
EnableAuditLogs
´´ $
{
´´% &
get
´´' *
;
´´* +
set
´´, /
;
´´/ 0
}
´´1 2
public
¨¨ 
string
¨¨ 
?
¨¨ 
NotificationEmail
¨¨ (
{
¨¨) *
get
¨¨+ .
;
¨¨. /
set
¨¨0 3
;
¨¨3 4
}
¨¨5 6
public
≠≠ 
bool
≠≠ 
?
≠≠ 
EmailOnNewTickets
≠≠ &
{
≠≠' (
get
≠≠) ,
;
≠≠, -
set
≠≠. 1
;
≠≠1 2
}
≠≠3 4
public
ÆÆ 
bool
ÆÆ 
?
ÆÆ $
EmailOnPaymentReceived
ÆÆ +
{
ÆÆ, -
get
ÆÆ. 1
;
ÆÆ1 2
set
ÆÆ3 6
;
ÆÆ6 7
}
ÆÆ8 9
public
ØØ 
bool
ØØ 
?
ØØ !
EmailOnSystemErrors
ØØ (
{
ØØ) *
get
ØØ+ .
;
ØØ. /
set
ØØ0 3
;
ØØ3 4
}
ØØ5 6
public
∞∞ 
bool
∞∞ 
?
∞∞ #
EmailOnSecurityAlerts
∞∞ *
{
∞∞+ ,
get
∞∞- 0
;
∞∞0 1
set
∞∞2 5
;
∞∞5 6
}
∞∞7 8
}
±± 
public
≥≥ 

class
≥≥ %
CreateSuperAdminRequest
≥≥ (
{
¥¥ 
public
µµ 
string
µµ 
Email
µµ 
{
µµ 
get
µµ !
;
µµ! "
set
µµ# &
;
µµ& '
}
µµ( )
=
µµ* +
string
µµ, 2
.
µµ2 3
Empty
µµ3 8
;
µµ8 9
public
∂∂ 
string
∂∂ 
	FirstName
∂∂ 
{
∂∂  !
get
∂∂" %
;
∂∂% &
set
∂∂' *
;
∂∂* +
}
∂∂, -
=
∂∂. /
string
∂∂0 6
.
∂∂6 7
Empty
∂∂7 <
;
∂∂< =
public
∑∑ 
string
∑∑ 
LastName
∑∑ 
{
∑∑  
get
∑∑! $
;
∑∑$ %
set
∑∑& )
;
∑∑) *
}
∑∑+ ,
=
∑∑- .
string
∑∑/ 5
.
∑∑5 6
Empty
∑∑6 ;
;
∑∑; <
public
∏∏ 
string
∏∏ 
Password
∏∏ 
{
∏∏  
get
∏∏! $
;
∏∏$ %
set
∏∏& )
;
∏∏) *
}
∏∏+ ,
=
∏∏- .
string
∏∏/ 5
.
∏∏5 6
Empty
∏∏6 ;
;
∏∏; <
}
ππ 
}∫∫ í(
YE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\ActivityController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
	Authorize 
] 
[		 
ApiController		 
]		 
[

 
Route

 

(


 
$str

 
)

 
]

 
public 

class 
ActivityController #
:$ %
ControllerBase& 4
{ 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
public 
ActivityController !
(! " 
ApplicationDbContext" 6
context7 >
)> ?
{ 	
_context 
= 
context 
; 
} 	
[ 	
HttpPost	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (
Log) ,
(, -
[- .
FromBody. 6
]6 7
ActivityLogRequest8 J
requestK R
)R S
{ 	
var 
userId 
= 
User 
. 
	FindFirst '
(' (
System( .
.. /
Security/ 7
.7 8
Claims8 >
.> ?

ClaimTypes? I
.I J
NameIdentifierJ X
)X Y
?Y Z
.Z [
Value[ `
;` a
if 
( 
string 
. 
IsNullOrWhiteSpace )
() *
userId* 0
)0 1
)1 2
return 
Unauthorized #
(# $
)$ %
;% &
if 
( 
string 
. 
IsNullOrWhiteSpace )
() *
request* 1
.1 2
Action2 8
)8 9
)9 :
return 

BadRequest !
(! "
new" %
{& '
message( /
=0 1
$str2 F
}G H
)H I
;I J
var 
finalAction 
= 
string $
.$ %
IsNullOrWhiteSpace% 7
(7 8
request8 ?
.? @
Details@ G
)G H
? 
request 
. 
Action  
.  !
Trim! %
(% &
)& '
:   
$"   
{   
request   
.   
Action   #
.  # $
Trim  $ (
(  ( )
)  ) *
}  * +
$str  + .
{  . /
request  / 6
.  6 7
Details  7 >
.  > ?
Trim  ? C
(  C D
)  D E
}  E F
"  F G
;  G H
_context"" 
."" 
ActivityLogs"" !
.""! "
Add""" %
(""% &
new""& )
ActivityLog""* 5
{## 
UserID$$ 
=$$ 
userId$$ 
,$$  
Action%% 
=%% 
finalAction%% $
,%%$ %
Type&& 
=&& 
string&& 
.&& 
IsNullOrWhiteSpace&& 0
(&&0 1
request&&1 8
.&&8 9
Type&&9 =
)&&= >
?&&? @
$str&&A N
:&&O P
request&&Q X
.&&X Y
Type&&Y ]
.&&] ^
Trim&&^ b
(&&b c
)&&c d
,&&d e
	IPAddress'' 
='' 
HttpContext'' '
.''' (

Connection''( 2
.''2 3
RemoteIpAddress''3 B
?''B C
.''C D
ToString''D L
(''L M
)''M N
,''N O
	Timestamp(( 
=(( 
DateTime(( $
.(($ %
UtcNow((% +
})) 
))) 
;)) 
await++ 
_context++ 
.++ 
SaveChangesAsync++ +
(+++ ,
)++, -
;++- .
return,, 
Ok,, 
(,, 
new,, 
{,, 
message,, #
=,,$ %
$str,,& 7
},,8 9
),,9 :
;,,: ;
}-- 	
}.. 
public00 

class00 
ActivityLogRequest00 #
{11 
public22 
string22 
Action22 
{22 
get22 "
;22" #
set22$ '
;22' (
}22) *
=22+ ,
string22- 3
.223 4
Empty224 9
;229 :
public33 
string33 
Type33 
{33 
get33  
;33  !
set33" %
;33% &
}33' (
=33) *
$str33+ 8
;338 9
public44 
string44 
?44 
Details44 
{44  
get44! $
;44$ %
set44& )
;44) *
}44+ ,
}55 
}66 ä
gE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Attributes\RequireEmailVerificationAttribute.cs
	namespace 	"
TayoKonnektado_project
  
.  !

Attributes! +
{ 
public		 

class		 -
!RequireEmailVerificationAttribute		 2
:		3 4
	Attribute		5 >
,		> ?%
IAsyncAuthorizationFilter		@ Y
{

 
public 
async 
Task  
OnAuthorizationAsync .
(. /&
AuthorizationFilterContext/ I
contextJ Q
)Q R
{ 	
if 
( 
context 
. 
ActionDescriptor (
.( )
EndpointMetadata) 9
.9 :
Any: =
(= >
em> @
=>A C
emD F
.F G
GetTypeG N
(N O
)O P
==Q S
typeofT Z
(Z [#
AllowAnonymousAttribute[ r
)r s
)s t
)t u
return 
; 
var 
userManager 
= 
context %
.% &
HttpContext& 1
.1 2
RequestServices2 A
.A B
GetRequiredServiceB T
<T U
UserManagerU `
<` a
ApplicationUsera p
>p q
>q r
(r s
)s t
;t u
if 
( 
context 
. 
HttpContext #
.# $
User$ (
.( )
Identity) 1
?1 2
.2 3
IsAuthenticated3 B
==C E
trueF J
)J K
{ 
var 
userId 
= 
context $
.$ %
HttpContext% 0
.0 1
User1 5
.5 6
	FindFirst6 ?
(? @
System@ F
.F G
SecurityG O
.O P
ClaimsP V
.V W

ClaimTypesW a
.a b
NameIdentifierb p
)p q
?q r
.r s
Values x
;x y
if 
( 
! 
string 
. 
IsNullOrEmpty )
() *
userId* 0
)0 1
)1 2
{ 
var 
user 
= 
await $
userManager% 0
.0 1
FindByIdAsync1 >
(> ?
userId? E
)E F
;F G
if 
( 
user 
!= 
null  $
&&% '
!( )
user) -
.- .
EmailConfirmed. <
)< =
{ 
context 
.  
Result  &
=' (
new) ,

JsonResult- 7
(7 8
new8 ;
{< =
message> E
=F G
$strH e
,e f&
requiresEmailVerification	g Ä
=
Å Ç
true
É á
}
à â
)
â ä
{ 

StatusCode &
=' (
$num) ,
} 
; 
return 
; 
}   
}!! 
}"" 
}## 	
}$$ 
}%% 