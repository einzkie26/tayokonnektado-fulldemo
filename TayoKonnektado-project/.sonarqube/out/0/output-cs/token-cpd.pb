‹,
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
}mm ﬂF
WE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\PrepaidUsageService.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 
PrepaidUsageService $
:% &
BackgroundService' 8
{ 
private 
readonly 
IServiceProvider )
_serviceProvider* :
;: ;
private 
readonly 
ILogger  
<  !
PrepaidUsageService! 4
>4 5
_logger6 =
;= >
private 
readonly 
Random 
_random  '
=( )
new* -
(- .
). /
;/ 0
private 
static 
readonly 
TimeSpan  (
Interval) 1
=2 3
TimeSpan4 <
.< =
FromMinutes= H
(H I
$numI J
)J K
;K L
private 
const 
double 
MinMBPerCycle *
=+ ,
$num- 0
;0 1
private 
const 
double 
MaxMBPerCycle *
=+ ,
$num- 1
;1 2
public 
PrepaidUsageService "
(" #
IServiceProvider# 3
serviceProvider4 C
,C D
ILoggerE L
<L M
PrepaidUsageServiceM `
>` a
loggerb h
)h i
{ 	
_serviceProvider 
= 
serviceProvider .
;. /
_logger 
= 
logger 
; 
} 	
	protected   
override   
async    
Task  ! %
ExecuteAsync  & 2
(  2 3
CancellationToken  3 D
stoppingToken  E R
)  R S
{!! 	
await## 
Task## 
.## 
Delay## 
(## 
TimeSpan## %
.##% &
FromSeconds##& 1
(##1 2
$num##2 4
)##4 5
,##5 6
stoppingToken##7 D
)##D E
;##E F
while%% 
(%% 
!%% 
stoppingToken%% !
.%%! "#
IsCancellationRequested%%" 9
)%%9 :
{&& 
try'' 
{(( 
using)) 
var)) 
scope)) #
=))$ %
_serviceProvider))& 6
.))6 7
CreateScope))7 B
())B C
)))C D
;))D E
var** 
context** 
=**  !
scope**" '
.**' (
ServiceProvider**( 7
.**7 8
GetRequiredService**8 J
<**J K 
ApplicationDbContext**K _
>**_ `
(**` a
)**a b
;**b c
var-- 
expiredPromos-- %
=--& '
await--( -
context--. 5
.--5 6
PrepaidPromos--6 C
... 
Where.. 
(.. 
p..  
=>..! #
p..$ %
...% &
Status..& ,
==..- /
$str..0 8
&&..9 ;
p..< =
...= >
	ExpiresAt..> G
<=..H J
DateTime..K S
...S T
UtcNow..T Z
)..Z [
.// 
ToListAsync// $
(//$ %
stoppingToken//% 2
)//2 3
;//3 4
foreach11 
(11 
var11  
ep11! #
in11$ &
expiredPromos11' 4
)114 5
{22 
ep33 
.33 
Status33 !
=33" #
$str33$ -
;33- .
_logger44 
.44  
LogInformation44  .
(44. /
$"44/ 1
$str441 8
{448 9
ep449 ;
.44; <

PromoTitle44< F
}44F G
$str44G K
{44K L
ep44L N
.44N O
PrepaidPromoID44O ]
}44] ^
$str44^ h
"44h i
)44i j
;44j k
}55 
var88 
activePromos88 $
=88% &
await88' ,
context88- 4
.884 5
PrepaidPromos885 B
.99 
Include99  
(99  !
p99! "
=>99# %
p99& '
.99' (
PrepaidLoad99( 3
)993 4
.:: 
ThenInclude:: (
(::( )
pl::) +
=>::, .
pl::/ 1
.::1 2
ServiceAccount::2 @
)::@ A
.;; 
Where;; 
(;; 
p;;  
=>;;! #
p;;$ %
.;;% &
Status;;& ,
==;;- /
$str;;0 8
&&<<! #
p<<$ %
.<<% &
RemainingDataMB<<& 5
><<6 7
$num<<8 9
&&==! #
p==$ %
.==% &
PrepaidLoad==& 1
.==1 2
ServiceAccount==2 @
.==@ A
Status==A G
====H J
$str==K S
&&>>! #
p>>$ %
.>>% &
PrepaidLoad>>& 1
.>>1 2
ServiceAccount>>2 @
.>>@ A
ServiceType>>A L
==>>M O
$str>>P Y
)>>Y Z
.?? 
ToListAsync?? $
(??$ %
stoppingToken??% 2
)??2 3
;??3 4
ifAA 
(AA 
activePromosAA $
.AA$ %
AnyAA% (
(AA( )
)AA) *
)AA* +
{BB 
varDD 
groupedDD #
=DD$ %
activePromosDD& 2
.DD2 3
GroupByDD3 :
(DD: ;
pDD; <
=>DD= ?
pDD@ A
.DDA B
PrepaidLoadIDDDB O
)DDO P
;DDP Q
foreachFF 
(FF  !
varFF! $
groupFF% *
inFF+ -
groupedFF. 5
)FF5 6
{GG 
varII 
deductionMBII  +
=II, -
(II. /
decimalII/ 6
)II6 7
(II7 8
MinMBPerCycleII8 E
+IIF G
(IIH I
_randomIII P
.IIP Q

NextDoubleIIQ [
(II[ \
)II\ ]
*II^ _
(II` a
MaxMBPerCycleIIa n
-IIo p
MinMBPerCycleIIq ~
)II~ 
)	II Ä
)
IIÄ Å
;
IIÅ Ç
varKK 
	remainingKK  )
=KK* +
deductionMBKK, 7
;KK7 8
foreachNN #
(NN$ %
varNN% (
promoNN) .
inNN/ 1
groupNN2 7
.NN7 8
OrderByNN8 ?
(NN? @
pNN@ A
=>NNB D
pNNE F
.NNF G
ActivatedAtNNG R
)NNR S
)NNS T
{OO 
ifPP  "
(PP# $
	remainingPP$ -
<=PP. 0
$numPP1 2
)PP2 3
breakPP4 9
;PP9 :
varRR  #
	deductionRR$ -
=RR. /
MathRR0 4
.RR4 5
MinRR5 8
(RR8 9
	remainingRR9 B
,RRB C
promoRRD I
.RRI J
RemainingDataMBRRJ Y
)RRY Z
;RRZ [
promoSS  %
.SS% &
RemainingDataMBSS& 5
-=SS6 8
	deductionSS9 B
;SSB C
	remainingTT  )
-=TT* ,
	deductionTT- 6
;TT6 7
ifVV  "
(VV# $
promoVV$ )
.VV) *
RemainingDataMBVV* 9
<=VV: <
$numVV= >
)VV> ?
{WW  !
promoXX$ )
.XX) *
RemainingDataMBXX* 9
=XX: ;
$numXX< =
;XX= >
promoYY$ )
.YY) *
StatusYY* 0
=YY1 2
$strYY3 =
;YY= >
_loggerZZ$ +
.ZZ+ ,
LogInformationZZ, :
(ZZ: ;
$"[[( *
$str[[* 1
{[[1 2
promo[[2 7
.[[7 8

PromoTitle[[8 B
}[[B C
$str[[C G
{[[G H
promo[[H M
.[[M N
PrepaidPromoID[[N \
}[[\ ]
$str[[] m
"[[m n
)[[n o
;[[o p
}\\  !
}]] 
}^^ 
await`` 
context`` %
.``% &
SaveChangesAsync``& 6
(``6 7
stoppingToken``7 D
)``D E
;``E F
_loggeraa 
.aa  
LogInformationaa  .
(aa. /
$"bb 
$strbb 6
{bb6 7
activePromosbb7 C
.bbC D
CountbbD I
}bbI J
$strbbJ [
"bb[ \
)bb\ ]
;bb] ^
}cc 
}hh 
catchii 
(ii 
	Exceptionii  
exii! #
)ii# $
{jj 
_loggerkk 
.kk 
LogErrorkk $
(kk$ %
$"kk% '
$strkk' E
{kkE F
exkkF H
.kkH I
MessagekkI P
}kkP Q
"kkQ R
)kkR S
;kkS T
}ll 
awaitnn 
Tasknn 
.nn 
Delaynn  
(nn  !
Intervalnn! )
,nn) *
stoppingTokennn+ 8
)nn8 9
;nn9 :
}oo 
}pp 	
}qq 
}rr Ÿ
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
}33 Ω&
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
};; í¥
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
}≥≥ ∆Ÿ
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
}°° Û*
OE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Services\AdminSeeder.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Services! )
{ 
public 

class 
AdminSeeder 
{ 
public 
static 
async 
Task  
SeedAdminAsync! /
(/ 0
UserManager0 ;
<; <
ApplicationUser< K
>K L
userManagerM X
,X Y
RoleManagerZ e
<e f
IdentityRolef r
>r s
roleManagert 
)	 Ä
{		 	
if

 
(

 
!

 
await

 
roleManager

 "
.

" #
RoleExistsAsync

# 2
(

2 3
$str

3 ?
)

? @
)

@ A
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
$str? K
)K L
)L M
;M N
} 
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
$str3 :
): ;
); <
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
$str? F
)F G
)G H
;H I
} 
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
$str3 :
): ;
); <
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
$str? F
)F G
)G H
;H I
} 
if 
( 
! 
await 
roleManager "
." #
RoleExistsAsync# 2
(2 3
$str3 9
)9 :
): ;
{ 
await 
roleManager !
.! "
CreateAsync" -
(- .
new. 1
IdentityRole2 >
(> ?
$str? E
)E F
)F G
;G H
} 
var 
superAdminEmail 
=  !
$str" <
;< =
var 
superAdminPassword "
=# $
$str% 0
;0 1
var 
superAdminUser 
=  
await! &
userManager' 2
.2 3
FindByEmailAsync3 C
(C D
superAdminEmailD S
)S T
;T U
if 
( 
superAdminUser 
== !
null" &
)& '
{   
superAdminUser!! 
=!!  
new!!! $
ApplicationUser!!% 4
{"" 
UserName## 
=## 
superAdminEmail## .
,##. /
Email$$ 
=$$ 
superAdminEmail$$ +
,$$+ ,
	FirstName%% 
=%% 
$str%%  '
,%%' (
LastName&& 
=&& 
$str&& &
,&&& '
EmailConfirmed'' "
=''# $
true''% )
,'') *
Status(( 
=(( 
$str(( %
,((% &
Role)) 
=)) 
$str)) '
}** 
;** 
var,, 
result,, 
=,, 
await,, "
userManager,,# .
.,,. /
CreateAsync,,/ :
(,,: ;
superAdminUser,,; I
,,,I J
superAdminPassword,,K ]
),,] ^
;,,^ _
if-- 
(-- 
result-- 
.-- 
	Succeeded-- $
)--$ %
{.. 
await// 
userManager// %
.//% &
AddToRoleAsync//& 4
(//4 5
superAdminUser//5 C
,//C D
$str//E Q
)//Q R
;//R S
}00 
}11 
else22 
{33 
var44 
token44 
=44 
await44 !
userManager44" -
.44- .+
GeneratePasswordResetTokenAsync44. M
(44M N
superAdminUser44N \
)44\ ]
;44] ^
await55 
userManager55 !
.55! "
ResetPasswordAsync55" 4
(554 5
superAdminUser555 C
,55C D
token55E J
,55J K
superAdminPassword55L ^
)55^ _
;55_ `
superAdminUser66 
.66 
Role66 #
=66$ %
$str66& 2
;662 3
await77 
userManager77 !
.77! "
UpdateAsync77" -
(77- .
superAdminUser77. <
)77< =
;77= >
if99 
(99 
!99 
await99 
userManager99 &
.99& '
IsInRoleAsync99' 4
(994 5
superAdminUser995 C
,99C D
$str99E Q
)99Q R
)99R S
{:: 
await;; 
userManager;; %
.;;% &
AddToRoleAsync;;& 4
(;;4 5
superAdminUser;;5 C
,;;C D
$str;;E Q
);;Q R
;;;R S
}<< 
}== 
}>> 	
}?? 
}@@ ør
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
}ãã •
PE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Models\PaymentRequest.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Models! '
{ 
public 

class 
PaymentRequest 
{ 
public 
decimal 
Amount 
{ 
get  #
;# $
set% (
;( )
}* +
public 
string 
Description !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
public 
string 
CustomerEmail #
{$ %
get& )
;) *
set+ .
;. /
}0 1
=2 3
string4 :
.: ;
Empty; @
;@ A
public 
string 
CustomerName "
{# $
get% (
;( )
set* -
;- .
}/ 0
=1 2
string3 9
.9 :
Empty: ?
;? @
public		 
string		 
PaymentMethod		 #
{		$ %
get		& )
;		) *
set		+ .
;		. /
}		0 1
=		2 3
$str		4 H
;		H I
}

 
public 

class 
PaymentResponse  
{ 
public 
string 
	PaymentId 
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
;< =
public 
string 
CheckoutUrl !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
public 
string 
Status 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
string- 3
.3 4
Empty4 9
;9 :
} 
} üø
BE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Program.cs
var 
builder 
= 
WebApplication 
. 
CreateBuilder *
(* +
args+ /
)/ 0
;0 1
builder 
. 
Services 
. 
AddControllers 
(  
)  !
. 
AddJsonOptions 
( 
options 
=> 
{ 
options 
. !
JsonSerializerOptions %
.% & 
PropertyNamingPolicy& :
=; <
System= C
.C D
TextD H
.H I
JsonI M
.M N
JsonNamingPolicyN ^
.^ _
	CamelCase_ h
;h i
options 
. !
JsonSerializerOptions %
.% &
DictionaryKeyPolicy& 9
=: ;
System< B
.B C
TextC G
.G H
JsonH L
.L M
JsonNamingPolicyM ]
.] ^
	CamelCase^ g
;g h
options 
. !
JsonSerializerOptions %
.% &'
PropertyNameCaseInsensitive& A
=B C
trueD H
;H I
options 
. !
JsonSerializerOptions %
.% &

Converters& 0
.0 1
Add1 4
(4 5
new5 8 
UtcDateTimeConverter9 M
(M N
)N O
)O P
;P Q
} 
) 
; 
builder 
. 
Services 
. #
AddEndpointsApiExplorer (
(( )
)) *
;* +
builder 
. 
Services 
. 
AddSwaggerGen 
( 
c  
=>! #
{ 
c 
. !
AddSecurityDefinition 
( 
$str $
,$ %
new& )
	Microsoft* 3
.3 4
OpenApi4 ;
.; <
Models< B
.B C!
OpenApiSecuritySchemeC X
{   
Description!! 
=!! 
$str!! t
,!!t u
Name"" 
="" 
$str"" 
,"" 
In## 

=## 
	Microsoft## 
.## 
OpenApi## 
.## 
Models## %
.##% &
ParameterLocation##& 7
.##7 8
Header##8 >
,##> ?
Type$$ 
=$$ 
	Microsoft$$ 
.$$ 
OpenApi$$  
.$$  !
Models$$! '
.$$' (
SecuritySchemeType$$( :
.$$: ;
ApiKey$$; A
,$$A B
Scheme%% 
=%% 
$str%% 
}&& 
)&& 
;&& 
c'' 
.'' "
AddSecurityRequirement'' 
('' 
new''  
	Microsoft''! *
.''* +
OpenApi''+ 2
.''2 3
Models''3 9
.''9 :&
OpenApiSecurityRequirement'': T
{(( 
{)) 	
new** 
	Microsoft** 
.** 
OpenApi** !
.**! "
Models**" (
.**( )!
OpenApiSecurityScheme**) >
{++ 
	Reference,, 
=,, 
new,, 
	Microsoft,,  )
.,,) *
OpenApi,,* 1
.,,1 2
Models,,2 8
.,,8 9
OpenApiReference,,9 I
{-- 
Type.. 
=.. 
	Microsoft.. $
...$ %
OpenApi..% ,
..., -
Models..- 3
...3 4
ReferenceType..4 A
...A B
SecurityScheme..B P
,..P Q
Id// 
=// 
$str// !
}00 
}11 
,11 
new22 
string22 
[22 
]22 
{22 
}22 
}33 	
}44 
)44 
;44 
}55 
)55 
;55 
builder88 
.88 
Services88 
.88 
AddDbContext88 
<88  
ApplicationDbContext88 2
>882 3
(883 4
options884 ;
=>88< >
options99 
.99 
UseSqlServer99 
(99 
builder99  
.99  !
Configuration99! .
.99. /
GetConnectionString99/ B
(99B C
$str99C V
)99V W
)99W X
)99X Y
;99Y Z
builder<< 
.<< 
Services<< 
.<< 
AddIdentity<< 
<<< 
ApplicationUser<< ,
,<<, -
IdentityRole<<. :
><<: ;
(<<; <
options<<< C
=><<D F
{== 
options?? 
.?? 
Password?? 
.?? 
RequireDigit?? !
=??" #
true??$ (
;??( )
options@@ 
.@@ 
Password@@ 
.@@ 
RequireLowercase@@ %
=@@& '
true@@( ,
;@@, -
optionsAA 
.AA 
PasswordAA 
.AA 
RequireUppercaseAA %
=AA& '
trueAA( ,
;AA, -
optionsBB 
.BB 
PasswordBB 
.BB "
RequireNonAlphanumericBB +
=BB, -
trueBB. 2
;BB2 3
optionsCC 
.CC 
PasswordCC 
.CC 
RequiredLengthCC #
=CC$ %
$numCC& (
;CC( )
optionsDD 
.DD 
PasswordDD 
.DD 
RequiredUniqueCharsDD (
=DD) *
$numDD+ ,
;DD, -
optionsGG 
.GG 
LockoutGG 
.GG 
AllowedForNewUsersGG &
=GG' (
trueGG) -
;GG- .
optionsHH 
.HH 
LockoutHH 
.HH #
MaxFailedAccessAttemptsHH +
=HH, -
$numHH. /
;HH/ 0
optionsII 
.II 
LockoutII 
.II "
DefaultLockoutTimeSpanII *
=II+ ,
TimeSpanII- 5
.II5 6
FromMinutesII6 A
(IIA B
$numIIB D
)IID E
;IIE F
}JJ 
)JJ 
.KK $
AddEntityFrameworkStoresKK 
<KK  
ApplicationDbContextKK 2
>KK2 3
(KK3 4
)KK4 5
.LL $
AddDefaultTokenProvidersLL 
(LL 
)LL 
;LL  
varOO 
jwtKeyOO 

=OO 
EnvironmentOO 
.OO "
GetEnvironmentVariableOO /
(OO/ 0
$strOO0 9
)OO9 :
;OO: ;
ifPP 
(PP 
stringPP 

.PP
 
IsNullOrWhiteSpacePP 
(PP 
jwtKeyPP $
)PP$ %
)PP% &
throwQQ 	
newQQ
 %
InvalidOperationExceptionQQ '
(QQ' (
$strQQ( m
)QQm n
;QQn o
builderSS 
.SS 
ServicesSS 
.SS 
AddAuthenticationSS "
(SS" #
optionsSS# *
=>SS+ -
{TT 
optionsUU 
.UU %
DefaultAuthenticateSchemeUU %
=UU& '
JwtBearerDefaultsUU( 9
.UU9 : 
AuthenticationSchemeUU: N
;UUN O
optionsVV 
.VV "
DefaultChallengeSchemeVV "
=VV# $
JwtBearerDefaultsVV% 6
.VV6 7 
AuthenticationSchemeVV7 K
;VVK L
}WW 
)WW 
.XX 
AddJwtBearerXX 
(XX 
optionsXX 
=>XX 
{YY 
optionsZZ 
.ZZ %
TokenValidationParametersZZ %
=ZZ& '
newZZ( +%
TokenValidationParametersZZ, E
{[[ 
ValidateIssuer\\ 
=\\ 
true\\ 
,\\ 
ValidateAudience]] 
=]] 
true]] 
,]]  
ValidateLifetime^^ 
=^^ 
true^^ 
,^^  $
ValidateIssuerSigningKey__  
=__! "
true__# '
,__' (
ValidIssuer`` 
=`` 
builder`` 
.`` 
Configuration`` +
[``+ ,
$str``, 8
]``8 9
,``9 :
ValidAudienceaa 
=aa 
builderaa 
.aa  
Configurationaa  -
[aa- .
$straa. <
]aa< =
,aa= >
IssuerSigningKeybb 
=bb 
newbb  
SymmetricSecurityKeybb 3
(bb3 4
Encodingbb4 <
.bb< =
UTF8bb= A
.bbA B
GetBytesbbB J
(bbJ K
jwtKeybbK Q
)bbQ R
)bbR S
}cc 
;cc 
}dd 
)dd 
.ee 
	AddGoogleee 

(ee
 
optionsee 
=>ee 
{ff 
optionsgg 
.gg 
ClientIdgg 
=gg 
buildergg 
.gg 
Configurationgg ,
[gg, -
$strgg- >
]gg> ?
!gg? @
;gg@ A
optionshh 
.hh 
ClientSecrethh 
=hh 
builderhh "
.hh" #
Configurationhh# 0
[hh0 1
$strhh1 F
]hhF G
!hhG H
;hhH I
}ii 
)ii 
;ii 
builderll 
.ll 
Servicesll 
.ll 
AddCorsll 
(ll 
optionsll  
=>ll! #
{mm 
optionsnn 
.nn 
	AddPolicynn 
(nn 
$strnn %
,nn% &
policyoo 
=>oo 
{pp 	
policyqq 
.qq 
AllowAnyOriginqq !
(qq! "
)qq" #
.rr 
AllowAnyHeaderrr !
(rr! "
)rr" #
.ss 
AllowAnyMethodss !
(ss! "
)ss" #
;ss# $
}tt 	
)tt	 

;tt
 
}uu 
)uu 
;uu 
builderxx 
.xx 
Servicesxx 
.xx 
AddRateLimiterxx 
(xx  
optionsxx  '
=>xx( *
{yy 
optionszz 
.zz 
RejectionStatusCodezz 
=zz  !
StatusCodeszz" -
.zz- .$
Status429TooManyRequestszz. F
;zzF G
options{{ 
.{{ 
	AddPolicy{{ 
({{ 
$str{{ 
,{{ 
httpContext{{ )
=>{{* ,
RateLimitPartition|| 
.|| !
GetFixedWindowLimiter|| 0
(||0 1
partitionKey}} 
:}} 
httpContext}} %
.}}% &

Connection}}& 0
.}}0 1
RemoteIpAddress}}1 @
?}}@ A
.}}A B
ToString}}B J
(}}J K
)}}K L
??}}M O
$str}}P Y
,}}Y Z
factory~~ 
:~~ 
_~~ 
=>~~ 
new~~ )
FixedWindowRateLimiterOptions~~ ;
{ 
PermitLimit
ÄÄ 
=
ÄÄ 
$num
ÄÄ  
,
ÄÄ  !
Window
ÅÅ 
=
ÅÅ 
TimeSpan
ÅÅ !
.
ÅÅ! "
FromMinutes
ÅÅ" -
(
ÅÅ- .
$num
ÅÅ. /
)
ÅÅ/ 0
,
ÅÅ0 1"
QueueProcessingOrder
ÇÇ $
=
ÇÇ% &"
QueueProcessingOrder
ÇÇ' ;
.
ÇÇ; <
OldestFirst
ÇÇ< G
,
ÇÇG H

QueueLimit
ÉÉ 
=
ÉÉ 
$num
ÉÉ 
}
ÑÑ 
)
ÑÑ 
)
ÑÑ 
;
ÑÑ 
}ÖÖ 
)
ÖÖ 
;
ÖÖ 
builderàà 
.
àà 
Services
àà 
.
àà 
	AddScoped
àà 
<
àà $
TayoKonnektado_project
àà 1
.
àà1 2
Services
àà2 :
.
àà: ;
PayMongoService
àà; J
>
ààJ K
(
ààK L
)
ààL M
;
ààM N
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
ââ: ;
TokenService
ââ; G
>
ââG H
(
ââH I
)
ââI J
;
ââJ K
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
EmailService
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
ãã: ;
Admin
ãã; @
.
ãã@ A'
CustomerManagementService
ããA Z
>
ããZ [
(
ãã[ \
)
ãã\ ]
;
ãã] ^
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
åå@ A%
TicketManagementService
ååA X
>
ååX Y
(
ååY Z
)
ååZ [
;
åå[ \
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
çç@ A&
PaymentManagementService
ççA Y
>
ççY Z
(
ççZ [
)
çç[ \
;
çç\ ]
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
éé@ A+
SubscriptionManagementService
ééA ^
>
éé^ _
(
éé_ `
)
éé` a
;
ééa b
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
èè@ A$
StaffManagementService
èèA W
>
èèW X
(
èèX Y
)
èèY Z
;
èèZ [
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
êê@ A
DashboardService
êêA Q
>
êêQ R
(
êêR S
)
êêS T
;
êêT U
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
ëë@ A#
PlanManagementService
ëëA V
>
ëëV W
(
ëëW X
)
ëëX Y
;
ëëY Z
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
íí@ A"
FAQManagementService
ííA U
>
ííU V
(
ííV W
)
ííW X
;
ííX Y
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
ìì: ;!
LoginAttemptService
ìì; N
>
ììN O
(
ììO P
)
ììP Q
;
ììQ R
builderîî 
.
îî 
Services
îî 
.
îî 
AddHostedService
îî !
<
îî! "$
TayoKonnektado_project
îî" 8
.
îî8 9
Services
îî9 A
.
îîA B(
SubscriptionEndDateService
îîB \
>
îî\ ]
(
îî] ^
)
îî^ _
;
îî_ `
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
ïïA B!
PrepaidUsageService
ïïB U
>
ïïU V
(
ïïV W
)
ïïW X
;
ïïX Y
builderññ 
.
ññ 
Services
ññ 
.
ññ 
AddHttpClient
ññ 
(
ññ 
)
ññ  
;
ññ  !
builderóó 
.
óó 
Services
óó 
.
óó 
	Configure
óó 
<
óó 
SecuritySettings
óó +
>
óó+ ,
(
óó, -
builder
óó- 4
.
óó4 5
Configuration
óó5 B
.
óóB C

GetSection
óóC M
(
óóM N
$str
óóN X
)
óóX Y
)
óóY Z
;
óóZ [
builderòò 
.
òò 
Services
òò 
.
òò 
AddSingleton
òò 
<
òò '
IpDeviceReputationService
òò 7
>
òò7 8
(
òò8 9
)
òò9 :
;
òò: ;
builderôô 
.
ôô 
Services
ôô 
.
ôô 
AddHttpClient
ôô 
<
ôô #
PasswordBreachService
ôô 4
>
ôô4 5
(
ôô5 6
)
ôô6 7
;
ôô7 8
varõõ 
app
õõ 
=
õõ 	
builder
õõ
 
.
õõ 
Build
õõ 
(
õõ 
)
õõ 
;
õõ 
appûû 
.
ûû 

UseSwagger
ûû 
(
ûû 
)
ûû 
;
ûû 
appüü 
.
üü 
UseSwaggerUI
üü 
(
üü 
)
üü 
;
üü 
app°° 
.
°° 
UseCors
°° 
(
°° 
$str
°° 
)
°° 
;
°° 
app££ 
.
££ 
UseStaticFiles
££ 
(
££ 
)
££ 
;
££ 
app§§ 
.
§§ 
UseDefaultFiles
§§ 
(
§§ 
)
§§ 
;
§§ 
if¶¶ 
(
¶¶ 
app
¶¶ 
.
¶¶ 
Environment
¶¶ 
.
¶¶ 
IsDevelopment
¶¶ !
(
¶¶! "
)
¶¶" #
)
¶¶# $
{ßß 
}©© 
else™™ 
{´´ 
app
¨¨ 
.
¨¨ !
UseHttpsRedirection
¨¨ 
(
¨¨ 
)
¨¨ 
;
¨¨ 
}≠≠ 
appØØ 
.
ØØ 
UseAuthentication
ØØ 
(
ØØ 
)
ØØ 
;
ØØ 
app∞∞ 
.
∞∞ 
UseRateLimiter
∞∞ 
(
∞∞ 
)
∞∞ 
;
∞∞ 
app±± 
.
±± 
UseMiddleware
±± 
<
±± '
ActivityLoggingMiddleware
±± +
>
±±+ ,
(
±±, -
)
±±- .
;
±±. /
app≤≤ 
.
≤≤ 
UseAuthorization
≤≤ 
(
≤≤ 
)
≤≤ 
;
≤≤ 
app¥¥ 
.
¥¥ 
MapControllers
¥¥ 
(
¥¥ 
)
¥¥ 
;
¥¥ 
app∂∂ 
.
∂∂ 
MapFallback
∂∂ 
(
∂∂ 
async
∂∂ 
context
∂∂ 
=>
∂∂  
{∑∑ 
if
∏∏ 
(
∏∏ 
!
∏∏ 	
context
∏∏	 
.
∏∏ 
Request
∏∏ 
.
∏∏ 
Path
∏∏ 
.
∏∏  
StartsWithSegments
∏∏ 0
(
∏∏0 1
$str
∏∏1 7
)
∏∏7 8
)
∏∏8 9
{
ππ 
context
∫∫ 
.
∫∫ 
Response
∫∫ 
.
∫∫ 
ContentType
∫∫ $
=
∫∫% &
$str
∫∫' 2
;
∫∫2 3
await
ªª 
context
ªª 
.
ªª 
Response
ªª 
.
ªª 
SendFileAsync
ªª ,
(
ªª, -
Path
ªª- 1
.
ªª1 2
Combine
ªª2 9
(
ªª9 :
app
ªª: =
.
ªª= >
Environment
ªª> I
.
ªªI J
WebRootPath
ªªJ U
,
ªªU V
$str
ªªW c
)
ªªc d
)
ªªd e
;
ªªe f
}
ºº 
}ΩΩ 
)
ΩΩ 
;
ΩΩ 
using¿¿ 
(
¿¿ 
var
¿¿ 

scope
¿¿ 
=
¿¿ 
app
¿¿ 
.
¿¿ 
Services
¿¿ 
.
¿¿  
CreateScope
¿¿  +
(
¿¿+ ,
)
¿¿, -
)
¿¿- .
{¡¡ 
var
¬¬ 
userManager
¬¬ 
=
¬¬ 
scope
¬¬ 
.
¬¬ 
ServiceProvider
¬¬ +
.
¬¬+ , 
GetRequiredService
¬¬, >
<
¬¬> ?
UserManager
¬¬? J
<
¬¬J K
ApplicationUser
¬¬K Z
>
¬¬Z [
>
¬¬[ \
(
¬¬\ ]
)
¬¬] ^
;
¬¬^ _
var
√√ 
roleManager
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
RoleManager
√√? J
<
√√J K
IdentityRole
√√K W
>
√√W X
>
√√X Y
(
√√Y Z
)
√√Z [
;
√√[ \
var
ƒƒ 
context
ƒƒ 
=
ƒƒ 
scope
ƒƒ 
.
ƒƒ 
ServiceProvider
ƒƒ '
.
ƒƒ' ( 
GetRequiredService
ƒƒ( :
<
ƒƒ: ;"
ApplicationDbContext
ƒƒ; O
>
ƒƒO P
(
ƒƒP Q
)
ƒƒQ R
;
ƒƒR S
await
≈≈ 	
AdminSeeder
≈≈
 
.
≈≈ 
SeedAdminAsync
≈≈ $
(
≈≈$ %
userManager
≈≈% 0
,
≈≈0 1
roleManager
≈≈2 =
)
≈≈= >
;
≈≈> ?
await
∆∆ 	

PlanSeeder
∆∆
 
.
∆∆ 
SeedPlansAsync
∆∆ #
(
∆∆# $
context
∆∆$ +
)
∆∆+ ,
;
∆∆, -
}«« 
app…… 
.
…… 
Run
…… 
(
…… 
)
…… 	
;
……	 

public–– 
class
–– "
UtcDateTimeConverter
–– !
:
––" #
System
––$ *
.
––* +
Text
––+ /
.
––/ 0
Json
––0 4
.
––4 5
Serialization
––5 B
.
––B C
JsonConverter
––C P
<
––P Q
DateTime
––Q Y
>
––Y Z
{—— 
public
““ 

override
““ 
DateTime
““ 
Read
““ !
(
““! "
ref
““" %
System
““& ,
.
““, -
Text
““- 1
.
““1 2
Json
““2 6
.
““6 7
Utf8JsonReader
““7 E
reader
““F L
,
““L M
Type
““N R
typeToConvert
““S `
,
““` a
System
““b h
.
““h i
Text
““i m
.
““m n
Json
““n r
.
““r s$
JsonSerializerOptions““s à
options““â ê
)““ê ë
{
”” 
var
‘‘ 
dt
‘‘ 
=
‘‘ 
reader
‘‘ 
.
‘‘ 
GetDateTime
‘‘ #
(
‘‘# $
)
‘‘$ %
;
‘‘% &
return
’’ 
DateTime
’’ 
.
’’ 
SpecifyKind
’’ #
(
’’# $
dt
’’$ &
,
’’& '
DateTimeKind
’’( 4
.
’’4 5
Utc
’’5 8
)
’’8 9
;
’’9 :
}
÷÷ 
public
ÿÿ 

override
ÿÿ 
void
ÿÿ 
Write
ÿÿ 
(
ÿÿ 
System
ÿÿ %
.
ÿÿ% &
Text
ÿÿ& *
.
ÿÿ* +
Json
ÿÿ+ /
.
ÿÿ/ 0
Utf8JsonWriter
ÿÿ0 >
writer
ÿÿ? E
,
ÿÿE F
DateTime
ÿÿG O
value
ÿÿP U
,
ÿÿU V
System
ÿÿW ]
.
ÿÿ] ^
Text
ÿÿ^ b
.
ÿÿb c
Json
ÿÿc g
.
ÿÿg h#
JsonSerializerOptions
ÿÿh }
optionsÿÿ~ Ö
)ÿÿÖ Ü
{
ŸŸ 
writer
⁄⁄ 
.
⁄⁄ 
WriteStringValue
⁄⁄ 
(
⁄⁄  
DateTime
⁄⁄  (
.
⁄⁄( )
SpecifyKind
⁄⁄) 4
(
⁄⁄4 5
value
⁄⁄5 :
,
⁄⁄: ;
DateTimeKind
⁄⁄< H
.
⁄⁄H I
Utc
⁄⁄I L
)
⁄⁄L M
)
⁄⁄M N
;
⁄⁄N O
}
€€ 
}‹‹ œ
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
} õ
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
} È
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
} π˚
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
}‡‡ Ùb
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
ModelBuilder$$0 <
modelBuilder$$= I
)$$I J
{%% 	
base&& 
.&& 
OnModelCreating&&  
(&&  !
modelBuilder&&! -
)&&- .
;&&. /
modelBuilder(( 
.(( 
Entity(( 
<((  
Device((  &
>((& '
(((' (
)((( )
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
;**( )
modelBuilder,, 
.,, 
Entity,, 
<,,  
Subscription,,  ,
>,,, -
(,,- .
),,. /
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
;..( )
modelBuilder00 
.00 
Entity00 
<00  
Subscription00  ,
>00, -
(00- .
)00. /
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
;332 3
modelBuilder55 
.55 
Entity55 
<55  
Subscription55  ,
>55, -
(55- .
)55. /
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
;882 3
modelBuilder:: 
.:: 
Entity:: 
<::  
Invoice::  '
>::' (
(::( )
)::) *
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
;==1 2
modelBuilder?? 
.?? 
Entity?? 
<??  
Invoice??  '
>??' (
(??( )
)??) *
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
;BB2 3
modelBuilderDD 
.DD 
EntityDD 
<DD  
PaymentDD  '
>DD' (
(DD( )
)DD) *
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
;GG1 2
modelBuilderII 
.II 
EntityII 
<II  
TicketReplyII  +
>II+ ,
(II, -
)II- .
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
;LL2 3
modelBuilderNN 
.NN 
EntityNN 
<NN  
PrepaidPromoNN  ,
>NN, -
(NN- .
)NN. /
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
;RR2 3
modelBuilderTT 
.TT 
EntityTT 
<TT  
PrepaidPromoTT  ,
>TT, -
(TT- .
)TT. /
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
;XX2 3
modelBuilderZZ 
.ZZ 
EntityZZ 
<ZZ  
RolePermissionZZ  .
>ZZ. /
(ZZ/ 0
)ZZ0 1
.[[ 
HasKey[[ 
([[ 
rp[[ 
=>[[ 
rp[[  
.[[  !
RolePermissionID[[! 1
)[[1 2
;[[2 3
modelBuilder]] 
.]] 
Entity]] 
<]]  
RolePermission]]  .
>]]. /
(]]/ 0
)]]0 1
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
}55 Ú
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
{ 
private 
readonly 
PayMongoService (
_payMongoService) 9
;9 :
public 
PaymentController  
(  !
PayMongoService! 0
payMongoService1 @
)@ A
{ 	
_payMongoService 
= 
payMongoService .
;. /
} 	
[ 	
HttpPost	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (
CreatePayment) 6
(6 7
[7 8
FromBody8 @
]@ A
PaymentRequestB P
requestQ X
)X Y
{ 	
return 
Ok 
( 
new 
{ 
message #
=$ %
$str& C
}D E
)E F
;F G
} 	
} 
} ‡°
YE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\CustomerController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{ 
[ 
	Authorize 
] 
[ $
RequireEmailVerification 
] 
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public 

class 
CustomerController #
:$ %
ControllerBase& 4
{ 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
private 
readonly 
UserManager $
<$ %
ApplicationUser% 4
>4 5
_userManager6 B
;B C
private 
readonly 
PayMongoService (
_payMongoService) 9
;9 :
private 
readonly 
EmailService %
_emailService& 3
;3 4
private 
readonly 
IConfiguration '
_configuration( 6
;6 7
private 
readonly 
IHttpClientFactory +
_httpClientFactory, >
;> ?
public 
CustomerController !
(! " 
ApplicationDbContext" 6
context7 >
,> ?
UserManager@ K
<K L
ApplicationUserL [
>[ \
userManager] h
,h i
PayMongoServicej y
payMongoService	z â
,
â ä
EmailService
ã ó
emailService
ò §
,
§ •
IConfiguration
¶ ¥
configuration
µ ¬
,
¬ √ 
IHttpClientFactory
ƒ ÷
httpClientFactory
◊ Ë
)
Ë È
{ 	
_context 
= 
context 
; 
_userManager 
= 
userManager &
;& '
_payMongoService 
= 
payMongoService .
;. /
_emailService 
= 
emailService (
;( )
_configuration   
=   
configuration   *
;  * +
_httpClientFactory!! 
=!!  
httpClientFactory!!! 2
;!!2 3
}"" 	
[$$ 	
HttpGet$$	 
($$ 
$str$$ 
)$$ 
]$$ 
public%% 
async%% 
Task%% 
<%% 
IActionResult%% '
>%%' (

GetProfile%%) 3
(%%3 4
)%%4 5
{&& 	
var'' 
userId'' 
='' 
User'' 
.'' 
	FindFirst'' '
(''' (
System''( .
.''. /
Security''/ 7
.''7 8
Claims''8 >
.''> ?

ClaimTypes''? I
.''I J
NameIdentifier''J X
)''X Y
?''Y Z
.''Z [
Value''[ `
;''` a
var(( 
user(( 
=(( 
await(( 
_userManager(( )
.(() *
FindByIdAsync((* 7
(((7 8
userId((8 >
!((> ?
)((? @
;((@ A
if)) 
()) 
user)) 
==)) 
null)) 
))) 
return)) $
NotFound))% -
())- .
))). /
;))/ 0
return++ 
Ok++ 
(++ 
new++ 
{++ 
id,, 
=,, 
user,, 
.,, 
Id,, 
,,, 
	firstName-- 
=-- 
user--  
.--  !
	FirstName--! *
,--* +
lastName.. 
=.. 
user.. 
...  
LastName..  (
,..( )
email// 
=// 
user// 
.// 
Email// "
,//" #
birthday00 
=00 
user00 
.00  
Birthday00  (
,00( )
address11 
=11 
user11 
.11 
Address11 &
,11& '
profilePictureUrl22 !
=22" #
user22$ (
.22( )
ProfilePictureUrl22) :
,22: ;
status33 
=33 
user33 
.33 
Status33 $
,33$ %
role44 
=44 
user44 
.44 
Role44  
,44  !
	createdAt55 
=55 
user55  
.55  !
	CreatedAt55! *
}66 
)66 
;66 
}77 	
[99 	
HttpPut99	 
(99 
$str99 
)99 
]99 
public:: 
async:: 
Task:: 
<:: 
IActionResult:: '
>::' (
UpdateProfile::) 6
(::6 7
[::7 8
FromBody::8 @
]::@ A 
UpdateProfileRequest::B V
request::W ^
)::^ _
{;; 	
var<< 
userId<< 
=<< 
User<< 
.<< 
	FindFirst<< '
(<<' (
System<<( .
.<<. /
Security<</ 7
.<<7 8
Claims<<8 >
.<<> ?

ClaimTypes<<? I
.<<I J
NameIdentifier<<J X
)<<X Y
?<<Y Z
.<<Z [
Value<<[ `
;<<` a
var== 
user== 
=== 
await== 
_userManager== )
.==) *
FindByIdAsync==* 7
(==7 8
userId==8 >
!==> ?
)==? @
;==@ A
if>> 
(>> 
user>> 
==>> 
null>> 
)>> 
return>> $
NotFound>>% -
(>>- .
)>>. /
;>>/ 0
user@@ 
.@@ 
	FirstName@@ 
=@@ 
request@@ $
.@@$ %
	FirstName@@% .
;@@. /
userAA 
.AA 
LastNameAA 
=AA 
requestAA #
.AA# $
LastNameAA$ ,
;AA, -
ifBB 
(BB 
!BB 
stringBB 
.BB 
IsNullOrEmptyBB %
(BB% &
requestBB& -
.BB- .
BirthdayBB. 6
)BB6 7
)BB7 8
userCC 
.CC 
BirthdayCC 
=CC 
DateTimeCC  (
.CC( )
ParseCC) .
(CC. /
requestCC/ 6
.CC6 7
BirthdayCC7 ?
)CC? @
;CC@ A
ifDD 
(DD 
!DD 
stringDD 
.DD 
IsNullOrEmptyDD %
(DD% &
requestDD& -
.DD- .
AddressDD. 5
)DD5 6
)DD6 7
userEE 
.EE 
AddressEE 
=EE 
requestEE &
.EE& '
AddressEE' .
;EE. /
awaitGG 
_userManagerGG 
.GG 
UpdateAsyncGG *
(GG* +
userGG+ /
)GG/ 0
;GG0 1
returnII 
OkII 
(II 
newII 
{II 
messageII #
=II$ %
$strII& D
}IIE F
)IIF G
;IIG H
}JJ 	
[LL 	
HttpPutLL	 
(LL 
$strLL  
)LL  !
]LL! "
publicMM 
asyncMM 
TaskMM 
<MM 
IActionResultMM '
>MM' (
UpdateProfilePhotoMM) ;
(MM; <
[MM< =
FromBodyMM= E
]MME F%
UpdateProfilePhotoRequestMMG `
requestMMa h
)MMh i
{NN 	
varOO 
userIdOO 
=OO 
UserOO 
.OO 
	FindFirstOO '
(OO' (
SystemOO( .
.OO. /
SecurityOO/ 7
.OO7 8
ClaimsOO8 >
.OO> ?

ClaimTypesOO? I
.OOI J
NameIdentifierOOJ X
)OOX Y
?OOY Z
.OOZ [
ValueOO[ `
;OO` a
varPP 
userPP 
=PP 
awaitPP 
_userManagerPP )
.PP) *
FindByIdAsyncPP* 7
(PP7 8
userIdPP8 >
!PP> ?
)PP? @
;PP@ A
ifQQ 
(QQ 
userQQ 
==QQ 
nullQQ 
)QQ 
returnQQ $
NotFoundQQ% -
(QQ- .
)QQ. /
;QQ/ 0
userSS 
.SS 
ProfilePictureUrlSS "
=SS# $
requestSS% ,
.SS, -
PhotoUrlSS- 5
;SS5 6
awaitTT 
_userManagerTT 
.TT 
UpdateAsyncTT *
(TT* +
userTT+ /
)TT/ 0
;TT0 1
returnVV 
OkVV 
(VV 
newVV 
{VV 
messageVV #
=VV$ %
$strVV& J
,VVJ K
profilePictureUrlVVL ]
=VV^ _
userVV` d
.VVd e
ProfilePictureUrlVVe v
}VVw x
)VVx y
;VVy z
}WW 	
[YY 	
HttpGetYY	 
(YY 
$strYY 
)YY 
]YY 
publicZZ 
asyncZZ 
TaskZZ 
<ZZ 
IActionResultZZ '
>ZZ' (

GetDevicesZZ) 3
(ZZ3 4
)ZZ4 5
{[[ 	
var\\ 
userId\\ 
=\\ 
User\\ 
.\\ 
	FindFirst\\ '
(\\' (
System\\( .
.\\. /
Security\\/ 7
.\\7 8
Claims\\8 >
.\\> ?

ClaimTypes\\? I
.\\I J
NameIdentifier\\J X
)\\X Y
?\\Y Z
.\\Z [
Value\\[ `
;\\` a
var]] 
devices]] 
=]] 
await]] 
_context]]  (
.]]( )
Devices]]) 0
.]]0 1
Where]]1 6
(]]6 7
d]]7 8
=>]]9 ;
d]]< =
.]]= >
UserID]]> D
==]]E G
userId]]H N
)]]N O
.]]O P
ToListAsync]]P [
(]][ \
)]]\ ]
;]]] ^
return^^ 
Ok^^ 
(^^ 
devices^^ 
)^^ 
;^^ 
}__ 	
[aa 	
HttpGetaa	 
(aa 
$straa 
)aa 
]aa 
publicbb 
asyncbb 
Taskbb 
<bb 
IActionResultbb '
>bb' (

GetTicketsbb) 3
(bb3 4
)bb4 5
{cc 	
vardd 
userIddd 
=dd 
Userdd 
.dd 
	FindFirstdd '
(dd' (
Systemdd( .
.dd. /
Securitydd/ 7
.dd7 8
Claimsdd8 >
.dd> ?

ClaimTypesdd? I
.ddI J
NameIdentifierddJ X
)ddX Y
?ddY Z
.ddZ [
Valuedd[ `
;dd` a
varee 
ticketsee 
=ee 
awaitee 
_contextee  (
.ee( )
SupportTicketsee) 7
.ff 
Includeff 
(ff 
tff 
=>ff 
tff 
.ff  
Repliesff  '
)ff' (
.gg 
ThenIncludegg  
(gg  !
rgg! "
=>gg# %
rgg& '
.gg' (
Usergg( ,
)gg, -
.hh 
Wherehh 
(hh 
thh 
=>hh 
thh 
.hh 
UserIDhh $
==hh% '
userIdhh( .
&&hh/ 1
!hh2 3
thh3 4
.hh4 5
IsHiddenByCustomerhh5 G
)hhG H
.ii 
Selectii 
(ii 
tii 
=>ii 
newii  
{jj 
tkk 
.kk 
TicketIDkk 
,kk 
tll 
.ll 
Subjectll 
,ll 
tmm 
.mm 
Descriptionmm !
,mm! "
tnn 
.nn 
Categorynn 
,nn 
too 
.oo 
Priorityoo 
,oo 
tpp 
.pp 
Statuspp 
,pp 
tqq 
.qq 
AttachmentUrlqq #
,qq# $
trr 
.rr 
	CreatedAtrr 
,rr  
	UpdatedAtss 
=ss 
tss  !
.ss! "
Repliesss" )
.ss) *
Anyss* -
(ss- .
)ss. /
?ss0 1
tss2 3
.ss3 4
Repliesss4 ;
.ss; <
Maxss< ?
(ss? @
rss@ A
=>ssB D
rssE F
.ssF G
	CreatedAtssG P
)ssP Q
:ssR S
tssT U
.ssU V
	CreatedAtssV _
,ss_ `
Repliestt 
=tt 
ttt 
.tt  
Repliestt  '
.tt' (
OrderBytt( /
(tt/ 0
rtt0 1
=>tt2 4
rtt5 6
.tt6 7
	CreatedAttt7 @
)tt@ A
.ttA B
SelectttB H
(ttH I
rttI J
=>ttK M
newttN Q
{uu 
rvv 
.vv 
ReplyIDvv !
,vv! "
rww 
.ww 
Messageww !
,ww! "
rxx 
.xx 
IsAdminReplyxx &
,xx& '
ryy 
.yy 
	CreatedAtyy #
,yy# $
UserNamezz  
=zz! "
rzz# $
.zz$ %
Userzz% )
.zz) *
	FirstNamezz* 3
+zz4 5
$strzz6 9
+zz: ;
rzz< =
.zz= >
Userzz> B
.zzB C
LastNamezzC K
}{{ 
){{ 
.{{ 
ToList{{ 
({{ 
){{ 
}|| 
)|| 
.}} 
OrderByDescending}} "
(}}" #
t}}# $
=>}}% '
t}}( )
.}}) *
	UpdatedAt}}* 3
)}}3 4
.~~ 
ToListAsync~~ 
(~~ 
)~~ 
;~~ 
return 
Ok 
( 
tickets 
) 
; 
}
ÄÄ 	
[
ÇÇ 	
HttpPost
ÇÇ	 
(
ÇÇ 
$str
ÇÇ  
)
ÇÇ  !
]
ÇÇ! "
[
ÉÉ 	
RequestSizeLimit
ÉÉ	 
(
ÉÉ 
$num
ÉÉ 
*
ÉÉ 
$num
ÉÉ #
*
ÉÉ$ %
$num
ÉÉ& *
)
ÉÉ* +
]
ÉÉ+ ,
public
ÑÑ 
async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
IActionResult
ÑÑ '
>
ÑÑ' (
UploadImage
ÑÑ) 4
(
ÑÑ4 5
	IFormFile
ÑÑ5 >
file
ÑÑ? C
)
ÑÑC D
{
ÖÖ 	
if
ÜÜ 
(
ÜÜ 
file
ÜÜ 
==
ÜÜ 
null
ÜÜ 
||
ÜÜ 
file
ÜÜ  $
.
ÜÜ$ %
Length
ÜÜ% +
==
ÜÜ, .
$num
ÜÜ/ 0
)
ÜÜ0 1
return
áá 

BadRequest
áá !
(
áá! "
new
áá" %
{
áá& '
message
áá( /
=
áá0 1
$str
áá2 E
}
ááF G
)
ááG H
;
ááH I
var
ââ 
allowed
ââ 
=
ââ 
new
ââ 
[
ââ 
]
ââ 
{
ââ  !
$str
ââ" .
,
ââ. /
$str
ââ0 ;
,
ââ; <
$str
ââ= H
,
ââH I
$str
ââJ V
}
ââW X
;
ââX Y
if
ää 
(
ää 
!
ää 
allowed
ää 
.
ää 
Contains
ää !
(
ää! "
file
ää" &
.
ää& '
ContentType
ää' 2
.
ää2 3
ToLower
ää3 :
(
ää: ;
)
ää; <
)
ää< =
)
ää= >
return
ãã 

BadRequest
ãã !
(
ãã! "
new
ãã" %
{
ãã& '
message
ãã( /
=
ãã0 1
$str
ãã2 e
}
ããf g
)
ããg h
;
ããh i
if
çç 
(
çç 
file
çç 
.
çç 
Length
çç 
>
çç 
$num
çç 
*
çç  !
$num
çç" &
*
çç' (
$num
çç) -
)
çç- .
return
éé 

BadRequest
éé !
(
éé! "
new
éé" %
{
éé& '
message
éé( /
=
éé0 1
$str
éé2 M
}
ééN O
)
ééO P
;
ééP Q
var
êê 
apiKey
êê 
=
êê 
_configuration
êê '
[
êê' (
$str
êê( 6
]
êê6 7
;
êê7 8
if
ëë 
(
ëë 
string
ëë 
.
ëë 
IsNullOrEmpty
ëë $
(
ëë$ %
apiKey
ëë% +
)
ëë+ ,
)
ëë, -
return
íí 

StatusCode
íí !
(
íí! "
$num
íí" %
,
íí% &
new
íí' *
{
íí+ ,
message
íí- 4
=
íí5 6
$str
íí7 ]
}
íí^ _
)
íí_ `
;
íí` a
using
îî 
var
îî 
ms
îî 
=
îî 
new
îî 
MemoryStream
îî +
(
îî+ ,
)
îî, -
;
îî- .
await
ïï 
file
ïï 
.
ïï 
CopyToAsync
ïï "
(
ïï" #
ms
ïï# %
)
ïï% &
;
ïï& '
var
ññ 
base64
ññ 
=
ññ 
Convert
ññ  
.
ññ  !
ToBase64String
ññ! /
(
ññ/ 0
ms
ññ0 2
.
ññ2 3
ToArray
ññ3 :
(
ññ: ;
)
ññ; <
)
ññ< =
;
ññ= >
using
òò 
var
òò 
form
òò 
=
òò 
new
òò  &
MultipartFormDataContent
òò! 9
(
òò9 :
)
òò: ;
;
òò; <
form
ôô 
.
ôô 
Add
ôô 
(
ôô 
new
ôô 
StringContent
ôô &
(
ôô& '
base64
ôô' -
)
ôô- .
,
ôô. /
$str
ôô0 7
)
ôô7 8
;
ôô8 9
var
õõ 
client
õõ 
=
õõ  
_httpClientFactory
õõ +
.
õõ+ ,
CreateClient
õõ, 8
(
õõ8 9
)
õõ9 :
;
õõ: ;
var
úú 
response
úú 
=
úú 
await
úú  
client
úú! '
.
úú' (
	PostAsync
úú( 1
(
úú1 2
$"
úú2 4
$str
úú4 W
{
úúW X
apiKey
úúX ^
}
úú^ _
"
úú_ `
,
úú` a
form
úúb f
)
úúf g
;
úúg h
if
ûû 
(
ûû 
!
ûû 
response
ûû 
.
ûû !
IsSuccessStatusCode
ûû -
)
ûû- .
return
üü 

StatusCode
üü !
(
üü! "
$num
üü" %
,
üü% &
new
üü' *
{
üü+ ,
message
üü- 4
=
üü5 6
$str
üü7 V
}
üüW X
)
üüX Y
;
üüY Z
var
°° 
json
°° 
=
°° 
await
°° 
response
°° %
.
°°% &
Content
°°& -
.
°°- .
ReadAsStringAsync
°°. ?
(
°°? @
)
°°@ A
;
°°A B
using
¢¢ 
var
¢¢ 
doc
¢¢ 
=
¢¢ 
JsonDocument
¢¢ (
.
¢¢( )
Parse
¢¢) .
(
¢¢. /
json
¢¢/ 3
)
¢¢3 4
;
¢¢4 5
var
££ 
url
££ 
=
££ 
doc
££ 
.
££ 
RootElement
££ %
.
££% &
GetProperty
££& 1
(
££1 2
$str
££2 8
)
££8 9
.
££9 :
GetProperty
££: E
(
££E F
$str
££F K
)
££K L
.
££L M
	GetString
££M V
(
££V W
)
££W X
;
££X Y
return
•• 
Ok
•• 
(
•• 
new
•• 
{
•• 
url
•• 
}
••  !
)
••! "
;
••" #
}
¶¶ 	
[
®® 	
HttpPost
®®	 
(
®® 
$str
®® 
)
®® 
]
®® 
public
©© 
async
©© 
Task
©© 
<
©© 
IActionResult
©© '
>
©©' (
CreateTicket
©©) 5
(
©©5 6
[
©©6 7
FromBody
©©7 ?
]
©©? @!
CreateTicketRequest
©©A T
request
©©U \
)
©©\ ]
{
™™ 	
var
´´ 
userId
´´ 
=
´´ 
User
´´ 
.
´´ 
	FindFirst
´´ '
(
´´' (
System
´´( .
.
´´. /
Security
´´/ 7
.
´´7 8
Claims
´´8 >
.
´´> ?

ClaimTypes
´´? I
.
´´I J
NameIdentifier
´´J X
)
´´X Y
?
´´Y Z
.
´´Z [
Value
´´[ `
;
´´` a
var
¨¨ 
user
¨¨ 
=
¨¨ 
await
¨¨ 
_userManager
¨¨ )
.
¨¨) *
FindByIdAsync
¨¨* 7
(
¨¨7 8
userId
¨¨8 >
!
¨¨> ?
)
¨¨? @
;
¨¨@ A
if
≠≠ 
(
≠≠ 
user
≠≠ 
==
≠≠ 
null
≠≠ 
)
≠≠ 
return
≠≠ $
NotFound
≠≠% -
(
≠≠- .
)
≠≠. /
;
≠≠/ 0
var
ØØ 
ticket
ØØ 
=
ØØ 
new
ØØ 
SupportTicket
ØØ *
{
∞∞ 
UserID
±± 
=
±± 
userId
±± 
!
±±  
,
±±  !
Subject
≤≤ 
=
≤≤ 
request
≤≤ !
.
≤≤! "
Subject
≤≤" )
,
≤≤) *
Description
≥≥ 
=
≥≥ 
request
≥≥ %
.
≥≥% &
Description
≥≥& 1
,
≥≥1 2
Category
¥¥ 
=
¥¥ 
request
¥¥ "
.
¥¥" #
Category
¥¥# +
,
¥¥+ ,
Priority
µµ 
=
µµ 
request
µµ "
.
µµ" #
Priority
µµ# +
,
µµ+ ,
AttachmentUrl
∂∂ 
=
∂∂ 
request
∂∂  '
.
∂∂' (
AttachmentUrl
∂∂( 5
,
∂∂5 6
Status
∑∑ 
=
∑∑ 
$str
∑∑ 
}
∏∏ 
;
∏∏ 
_context
ππ 
.
ππ 
SupportTickets
ππ #
.
ππ# $
Add
ππ$ '
(
ππ' (
ticket
ππ( .
)
ππ. /
;
ππ/ 0
await
∫∫ 
_context
∫∫ 
.
∫∫ 
SaveChangesAsync
∫∫ +
(
∫∫+ ,
)
∫∫, -
;
∫∫- .
var
ºº 

ticketPref
ºº 
=
ºº 
await
ºº "
_context
ºº# +
.
ºº+ ,%
NotificationPreferences
ºº, C
.
ΩΩ !
FirstOrDefaultAsync
ΩΩ $
(
ΩΩ$ %
np
ΩΩ% '
=>
ΩΩ( *
np
ΩΩ+ -
.
ΩΩ- .
UserID
ΩΩ. 4
==
ΩΩ5 7
userId
ΩΩ8 >
&&
ΩΩ? A
np
ΩΩB D
.
ΩΩD E
NotificationType
ΩΩE U
==
ΩΩV X
$str
ΩΩY i
)
ΩΩi j
;
ΩΩj k
if
ææ 
(
ææ 

ticketPref
ææ 
?
ææ 
.
ææ 
EmailEnabled
ææ (
!=
ææ) +
false
ææ, 1
)
ææ1 2
{
øø 
await
¿¿ 
_emailService
¿¿ #
.
¿¿# $
SendEmailAsync
¿¿$ 2
(
¿¿2 3
user
¡¡ 
.
¡¡ 
Email
¡¡ 
!
¡¡ 
,
¡¡  
$str
¬¬ =
,
¬¬= >
$"
√√ 
$str
√√ 
{
√√ 
user
√√ !
.
√√! "
	FirstName
√√" +
}
√√+ ,
$str
√√, R
{
√√R S
ticket
√√S Y
.
√√Y Z
TicketID
√√Z b
}
√√b c
$str√√c ≠
{√√≠ Æ
request√√Æ µ
.√√µ ∂
Subject√√∂ Ω
}√√Ω æ
$str√√æ ›
{√√› ﬁ
request√√ﬁ Â
.√√Â Ê
Category√√Ê Ó
}√√Ó Ô
$str√√Ô é
{√√é è
request√√è ñ
.√√ñ ó
Priority√√ó ü
}√√ü †
$str√√† ∫
"√√∫ ª
)
ƒƒ 
;
ƒƒ 
}
≈≈ 
await
«« 
_emailService
«« 
.
««  
SendEmailAsync
««  .
(
««. /
$str
»» *
,
»»* +
$"
…… 
$str
…… &
{
……& '
ticket
……' -
.
……- .
TicketID
……. 6
}
……6 7
$str
……7 :
{
……: ;
request
……; B
.
……B C
Priority
……C K
}
……K L
$str
……L U
"
……U V
,
……V W
$"
   
$str
   ]
{
  ] ^
ticket
  ^ d
.
  d e
TicketID
  e m
}
  m n
$str  n ç
{  ç é
user  é í
.  í ì
	FirstName  ì ú
}  ú ù
$str  ù û
{  û ü
user  ü £
.  £ §
LastName  § ¨
}  ¨ ≠
$str  ≠ Ø
{  Ø ∞
user  ∞ ¥
.  ¥ µ
Email  µ ∫
}  ∫ ª
$str  ª ⁄
{  ⁄ €
request  € ‚
.  ‚ „
Subject  „ Í
}  Í Î
$str  Î ä
{  ä ã
request  ã í
.  í ì
Category  ì õ
}  õ ú
$str  ú ª
{  ª º
request  º √
.  √ ƒ
Priority  ƒ Ã
}  Ã Õ
$str  Õ Ô
{  Ô 
request   ˜
.  ˜ ¯
Description  ¯ É
}  É Ñ
$str  Ñ Æ
"  Æ Ø
)
ÀÀ 
;
ÀÀ 
var
ÕÕ 
notification
ÕÕ 
=
ÕÕ 
new
ÕÕ "
Notification
ÕÕ# /
{
ŒŒ 
UserID
œœ 
=
œœ 
userId
œœ 
!
œœ  
,
œœ  !
Message
–– 
=
–– 
$"
–– 
$str
–– 1
{
––1 2
ticket
––2 8
.
––8 9
TicketID
––9 A
}
––A B
$str
––B k
"
––k l
,
––l m
Type
—— 
=
—— 
$str
—— 
,
——  
Status
““ 
=
““ 
$str
““ !
}
”” 
;
”” 
_context
‘‘ 
.
‘‘ 
Notifications
‘‘ "
.
‘‘" #
Add
‘‘# &
(
‘‘& '
notification
‘‘' 3
)
‘‘3 4
;
‘‘4 5
await
’’ 
_context
’’ 
.
’’ 
SaveChangesAsync
’’ +
(
’’+ ,
)
’’, -
;
’’- .
return
◊◊ 
Ok
◊◊ 
(
◊◊ 
new
◊◊ 
{
◊◊ 
message
◊◊ #
=
◊◊$ %
$str
◊◊& C
,
◊◊C D
ticketId
◊◊E M
=
◊◊N O
ticket
◊◊P V
.
◊◊V W
TicketID
◊◊W _
}
◊◊` a
)
◊◊a b
;
◊◊b c
}
ÿÿ 	
[
⁄⁄ 	

HttpDelete
⁄⁄	 
(
⁄⁄ 
$str
⁄⁄ "
)
⁄⁄" #
]
⁄⁄# $
public
€€ 
async
€€ 
Task
€€ 
<
€€ 
IActionResult
€€ '
>
€€' (
DeleteTicket
€€) 5
(
€€5 6
int
€€6 9
id
€€: <
)
€€< =
{
‹‹ 	
var
›› 
userId
›› 
=
›› 
User
›› 
.
›› 
	FindFirst
›› '
(
››' (
System
››( .
.
››. /
Security
››/ 7
.
››7 8
Claims
››8 >
.
››> ?

ClaimTypes
››? I
.
››I J
NameIdentifier
››J X
)
››X Y
?
››Y Z
.
››Z [
Value
››[ `
;
››` a
var
ﬁﬁ 
ticket
ﬁﬁ 
=
ﬁﬁ 
await
ﬁﬁ 
_context
ﬁﬁ '
.
ﬁﬁ' (
SupportTickets
ﬁﬁ( 6
.
ﬁﬁ6 7!
FirstOrDefaultAsync
ﬁﬁ7 J
(
ﬁﬁJ K
t
ﬁﬁK L
=>
ﬁﬁM O
t
ﬁﬁP Q
.
ﬁﬁQ R
TicketID
ﬁﬁR Z
==
ﬁﬁ[ ]
id
ﬁﬁ^ `
&&
ﬁﬁa c
t
ﬁﬁd e
.
ﬁﬁe f
UserID
ﬁﬁf l
==
ﬁﬁm o
userId
ﬁﬁp v
)
ﬁﬁv w
;
ﬁﬁw x
if
ﬂﬂ 
(
ﬂﬂ 
ticket
ﬂﬂ 
==
ﬂﬂ 
null
ﬂﬂ 
)
ﬂﬂ 
return
ﬂﬂ  &
NotFound
ﬂﬂ' /
(
ﬂﬂ/ 0
new
ﬂﬂ0 3
{
ﬂﬂ4 5
message
ﬂﬂ6 =
=
ﬂﬂ> ?
$str
ﬂﬂ@ R
}
ﬂﬂS T
)
ﬂﬂT U
;
ﬂﬂU V
if
‡‡ 
(
‡‡ 
ticket
‡‡ 
.
‡‡ 
Status
‡‡ 
!=
‡‡  
$str
‡‡! )
)
‡‡) *
return
‡‡+ 1

BadRequest
‡‡2 <
(
‡‡< =
new
‡‡= @
{
‡‡A B
message
‡‡C J
=
‡‡K L
$str
‡‡M q
}
‡‡r s
)
‡‡s t
;
‡‡t u
ticket
‚‚ 
.
‚‚  
IsHiddenByCustomer
‚‚ %
=
‚‚& '
true
‚‚( ,
;
‚‚, -
await
„„ 
_context
„„ 
.
„„ 
SaveChangesAsync
„„ +
(
„„+ ,
)
„„, -
;
„„- .
return
‰‰ 
Ok
‰‰ 
(
‰‰ 
new
‰‰ 
{
‰‰ 
message
‰‰ #
=
‰‰$ %
$str
‰‰& C
}
‰‰D E
)
‰‰E F
;
‰‰F G
}
ÂÂ 	
[
ÁÁ 	
HttpPost
ÁÁ	 
(
ÁÁ 
$str
ÁÁ &
)
ÁÁ& '
]
ÁÁ' (
public
ËË 
async
ËË 
Task
ËË 
<
ËË 
IActionResult
ËË '
>
ËË' (
ReplyToTicket
ËË) 6
(
ËË6 7
int
ËË7 :
id
ËË; =
,
ËË= >
[
ËË? @
FromBody
ËË@ H
]
ËËH I"
CustomerReplyRequest
ËËJ ^
request
ËË_ f
)
ËËf g
{
ÈÈ 	
var
ÍÍ 
userId
ÍÍ 
=
ÍÍ 
User
ÍÍ 
.
ÍÍ 
	FindFirst
ÍÍ '
(
ÍÍ' (
System
ÍÍ( .
.
ÍÍ. /
Security
ÍÍ/ 7
.
ÍÍ7 8
Claims
ÍÍ8 >
.
ÍÍ> ?

ClaimTypes
ÍÍ? I
.
ÍÍI J
NameIdentifier
ÍÍJ X
)
ÍÍX Y
?
ÍÍY Z
.
ÍÍZ [
Value
ÍÍ[ `
;
ÍÍ` a
var
ÎÎ 
user
ÎÎ 
=
ÎÎ 
await
ÎÎ 
_userManager
ÎÎ )
.
ÎÎ) *
FindByIdAsync
ÎÎ* 7
(
ÎÎ7 8
userId
ÎÎ8 >
!
ÎÎ> ?
)
ÎÎ? @
;
ÎÎ@ A
if
ÏÏ 
(
ÏÏ 
user
ÏÏ 
==
ÏÏ 
null
ÏÏ 
)
ÏÏ 
return
ÏÏ $
NotFound
ÏÏ% -
(
ÏÏ- .
)
ÏÏ. /
;
ÏÏ/ 0
var
ÓÓ 
ticket
ÓÓ 
=
ÓÓ 
await
ÓÓ 
_context
ÓÓ '
.
ÓÓ' (
SupportTickets
ÓÓ( 6
.
ÔÔ 
Include
ÔÔ 
(
ÔÔ 
t
ÔÔ 
=>
ÔÔ 
t
ÔÔ 
.
ÔÔ  
Replies
ÔÔ  '
)
ÔÔ' (
.
 !
FirstOrDefaultAsync
 $
(
$ %
t
% &
=>
' )
t
* +
.
+ ,
TicketID
, 4
==
5 7
id
8 :
&&
; =
t
> ?
.
? @
UserID
@ F
==
G I
userId
J P
)
P Q
;
Q R
if
ÒÒ 
(
ÒÒ 
ticket
ÒÒ 
==
ÒÒ 
null
ÒÒ 
)
ÒÒ 
return
ÒÒ  &
NotFound
ÒÒ' /
(
ÒÒ/ 0
new
ÒÒ0 3
{
ÒÒ4 5
message
ÒÒ6 =
=
ÒÒ> ?
$str
ÒÒ@ R
}
ÒÒS T
)
ÒÒT U
;
ÒÒU V
if
ÚÚ 
(
ÚÚ 
ticket
ÚÚ 
.
ÚÚ 
Status
ÚÚ 
==
ÚÚ  
$str
ÚÚ! )
)
ÚÚ) *
return
ÚÚ+ 1

BadRequest
ÚÚ2 <
(
ÚÚ< =
new
ÚÚ= @
{
ÚÚA B
message
ÚÚC J
=
ÚÚK L
$str
ÚÚM n
}
ÚÚo p
)
ÚÚp q
;
ÚÚq r
var
ÙÙ 
reply
ÙÙ 
=
ÙÙ 
new
ÙÙ 
TicketReply
ÙÙ '
{
ıı 
TicketID
ˆˆ 
=
ˆˆ 
id
ˆˆ 
,
ˆˆ 
UserID
˜˜ 
=
˜˜ 
userId
˜˜ 
!
˜˜  
,
˜˜  !
Message
¯¯ 
=
¯¯ 
request
¯¯ !
.
¯¯! "
Message
¯¯" )
,
¯¯) *
IsAdminReply
˘˘ 
=
˘˘ 
false
˘˘ $
}
˙˙ 
;
˙˙ 
_context
˚˚ 
.
˚˚ 
TicketReplies
˚˚ "
.
˚˚" #
Add
˚˚# &
(
˚˚& '
reply
˚˚' ,
)
˚˚, -
;
˚˚- .
if
˝˝ 
(
˝˝ 
ticket
˝˝ 
.
˝˝ 
Status
˝˝ 
==
˝˝  
$str
˝˝! +
)
˝˝+ ,
ticket
˝˝- 3
.
˝˝3 4
Status
˝˝4 :
=
˝˝; <
$str
˝˝= F
;
˝˝F G
await
ˇˇ 
_context
ˇˇ 
.
ˇˇ 
SaveChangesAsync
ˇˇ +
(
ˇˇ+ ,
)
ˇˇ, -
;
ˇˇ- .
return
ÅÅ 
Ok
ÅÅ 
(
ÅÅ 
new
ÅÅ 
{
ÇÇ 
replyID
ÉÉ 
=
ÉÉ 
reply
ÉÉ 
.
ÉÉ  
ReplyID
ÉÉ  '
,
ÉÉ' (
message
ÑÑ 
=
ÑÑ 
reply
ÑÑ 
.
ÑÑ  
Message
ÑÑ  '
,
ÑÑ' (
isAdminReply
ÖÖ 
=
ÖÖ 
reply
ÖÖ $
.
ÖÖ$ %
IsAdminReply
ÖÖ% 1
,
ÖÖ1 2
	createdAt
ÜÜ 
=
ÜÜ 
reply
ÜÜ !
.
ÜÜ! "
	CreatedAt
ÜÜ" +
,
ÜÜ+ ,
userName
áá 
=
áá 
user
áá 
.
áá  
	FirstName
áá  )
+
áá* +
$str
áá, /
+
áá0 1
user
áá2 6
.
áá6 7
LastName
áá7 ?
}
àà 
)
àà 
;
àà 
}
ââ 	
[
ãã 	
AllowAnonymous
ãã	 
]
ãã 
[
åå 	
HttpGet
åå	 
(
åå 
$str
åå 
)
åå 
]
åå 
public
çç 
async
çç 
Task
çç 
<
çç 
IActionResult
çç '
>
çç' (
GetFAQs
çç) 0
(
çç0 1
)
çç1 2
{
éé 	
var
èè 
faqs
èè 
=
èè 
await
èè 
_context
èè %
.
èè% &
FAQs
èè& *
.
êê 
Where
êê 
(
êê 
f
êê 
=>
êê 
f
êê 
.
êê 
Status
êê $
==
êê% '
$str
êê( 3
)
êê3 4
.
ëë 
OrderBy
ëë 
(
ëë 
f
ëë 
=>
ëë 
f
ëë 
.
ëë  
Category
ëë  (
)
ëë( )
.
íí 
ThenByDescending
íí !
(
íí! "
f
íí" #
=>
íí$ &
f
íí' (
.
íí( )
	CreatedAt
íí) 2
)
íí2 3
.
ìì 
Select
ìì 
(
ìì 
f
ìì 
=>
ìì 
new
ìì  
{
ìì! "
f
ìì# $
.
ìì$ %
FAQID
ìì% *
,
ìì* +
f
ìì, -
.
ìì- .
Question
ìì. 6
,
ìì6 7
f
ìì8 9
.
ìì9 :
Answer
ìì: @
,
ìì@ A
f
ììB C
.
ììC D
Category
ììD L
}
ììM N
)
ììN O
.
îî 
ToListAsync
îî 
(
îî 
)
îî 
;
îî 
return
ïï 
Ok
ïï 
(
ïï 
faqs
ïï 
)
ïï 
;
ïï 
}
ññ 	
[
òò 	
HttpGet
òò	 
(
òò 
$str
òò  
)
òò  !
]
òò! "
public
ôô 
async
ôô 
Task
ôô 
<
ôô 
IActionResult
ôô '
>
ôô' (
GetSubscriptions
ôô) 9
(
ôô9 :
)
ôô: ;
{
öö 	
try
õõ 
{
úú 
var
ùù 
userId
ùù 
=
ùù 
User
ùù !
.
ùù! "
	FindFirst
ùù" +
(
ùù+ ,
System
ùù, 2
.
ùù2 3
Security
ùù3 ;
.
ùù; <
Claims
ùù< B
.
ùùB C

ClaimTypes
ùùC M
.
ùùM N
NameIdentifier
ùùN \
)
ùù\ ]
?
ùù] ^
.
ùù^ _
Value
ùù_ d
;
ùùd e
var
†† 
subscriptions
†† !
=
††" #
await
††$ )
_context
††* 2
.
††2 3
Subscriptions
††3 @
.
°° 
Include
°° 
(
°° 
s
°° 
=>
°° !
s
°°" #
.
°°# $
Plan
°°$ (
)
°°( )
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
¢¢# $
ServiceAccount
¢¢$ 2
)
¢¢2 3
.
££ 
ThenInclude
££ $
(
££$ %
sa
££% '
=>
££( *
sa
££+ -
.
££- .
Device
££. 4
)
££4 5
.
§§ 
Where
§§ 
(
§§ 
s
§§ 
=>
§§ 
s
§§  !
.
§§! "
UserID
§§" (
==
§§) +
userId
§§, 2
)
§§2 3
.
•• 
Select
•• 
(
•• 
s
•• 
=>
••  
new
••! $
{
¶¶ 
s
ßß 
.
ßß 
SubscriptionID
ßß (
,
ßß( )
s
®® 
.
®® 
PlanID
®®  
,
®®  !
s
©© 
.
©© 
UserID
©©  
,
©©  !

DeviceName
™™ "
=
™™# $
s
™™% &
.
™™& '

DeviceName
™™' 1
??
™™2 4
$str
™™5 7
,
™™7 8
s
´´ 
.
´´ 
	StartDate
´´ #
,
´´# $
s
¨¨ 
.
¨¨ 
EndDate
¨¨ !
,
¨¨! "
s
≠≠ 
.
≠≠ 
Status
≠≠  
,
≠≠  !
Plan
ÆÆ 
=
ÆÆ 
new
ÆÆ "
{
ØØ 
s
∞∞ 
.
∞∞ 
Plan
∞∞ "
.
∞∞" #
PlanID
∞∞# )
,
∞∞) *
s
±± 
.
±± 
Plan
±± "
.
±±" #
PlanName
±±# +
,
±±+ ,
s
≤≤ 
.
≤≤ 
Plan
≤≤ "
.
≤≤" #
	SpeedMbps
≤≤# ,
}
≥≥ 
,
≥≥ 

MACAddress
¥¥ "
=
¥¥# $
s
¥¥% &
.
¥¥& '
ServiceAccount
¥¥' 5
.
¥¥5 6
Device
¥¥6 <
.
¥¥< =

MACAddress
¥¥= G
??
¥¥H J
$str
¥¥K M
,
¥¥M N
ServiceType
µµ #
=
µµ$ %
$str
µµ& 4
}
∂∂ 
)
∂∂ 
.
∑∑ 
ToListAsync
∑∑  
(
∑∑  !
)
∑∑! "
;
∑∑" #
var
∫∫ 
prepaidServices
∫∫ #
=
∫∫$ %
await
∫∫& +
_context
∫∫, 4
.
∫∫4 5
PrepaidLoads
∫∫5 A
.
ªª 
Where
ªª 
(
ªª 
p
ªª 
=>
ªª 
p
ªª  !
.
ªª! "
ServiceAccount
ªª" 0
.
ªª0 1
Device
ªª1 7
.
ªª7 8
UserID
ªª8 >
==
ªª? A
userId
ªªB H
)
ªªH I
.
ºº 
Select
ºº 
(
ºº 
p
ºº 
=>
ºº  
new
ºº! $
{
ΩΩ 
SubscriptionID
ææ &
=
ææ' (
p
ææ) *
.
ææ* +
PrepaidLoadID
ææ+ 8
,
ææ8 9
PlanID
øø 
=
øø  
(
øø! "
int
øø" %
?
øø% &
)
øø& '
null
øø' +
,
øø+ ,
UserID
¿¿ 
=
¿¿  
userId
¿¿! '
,
¿¿' (

DeviceName
¡¡ "
=
¡¡# $
$str
¡¡% 3
,
¡¡3 4
	StartDate
¬¬ !
=
¬¬" #
p
¬¬$ %
.
¬¬% &
ServiceAccount
¬¬& 4
.
¬¬4 5
ActivatedAt
¬¬5 @
,
¬¬@ A
EndDate
√√ 
=
√√  !
(
√√" #
DateTime
√√# +
?
√√+ ,
)
√√, -
null
√√- 1
,
√√1 2
Status
ƒƒ 
=
ƒƒ  
p
ƒƒ! "
.
ƒƒ" #
ServiceAccount
ƒƒ# 1
.
ƒƒ1 2
Status
ƒƒ2 8
,
ƒƒ8 9
Plan
≈≈ 
=
≈≈ 
(
≈≈  
object
≈≈  &
?
≈≈& '
)
≈≈' (
null
≈≈( ,
,
≈≈, -

MACAddress
∆∆ "
=
∆∆# $
p
∆∆% &
.
∆∆& '
ServiceAccount
∆∆' 5
.
∆∆5 6
Device
∆∆6 <
.
∆∆< =

MACAddress
∆∆= G
??
∆∆H J
$str
∆∆K M
,
∆∆M N
ServiceType
«« #
=
««$ %
$str
««& /
,
««/ 0
PhoneNumber
»» #
=
»»$ %
p
»»& '
.
»»' (
PhoneNumber
»»( 3
,
»»3 4
RemainingBalance
…… (
=
……) *
p
……+ ,
.
……, -
RemainingBalance
……- =
}
   
)
   
.
ÀÀ 
ToListAsync
ÀÀ  
(
ÀÀ  !
)
ÀÀ! "
;
ÀÀ" #
var
ÕÕ 
allServices
ÕÕ 
=
ÕÕ  !
subscriptions
ÕÕ" /
.
ÕÕ/ 0
Cast
ÕÕ0 4
<
ÕÕ4 5
object
ÕÕ5 ;
>
ÕÕ; <
(
ÕÕ< =
)
ÕÕ= >
.
ÕÕ> ?
Concat
ÕÕ? E
(
ÕÕE F
prepaidServices
ÕÕF U
.
ÕÕU V
Cast
ÕÕV Z
<
ÕÕZ [
object
ÕÕ[ a
>
ÕÕa b
(
ÕÕb c
)
ÕÕc d
)
ÕÕd e
.
ÕÕe f
ToList
ÕÕf l
(
ÕÕl m
)
ÕÕm n
;
ÕÕn o
return
ŒŒ 
Ok
ŒŒ 
(
ŒŒ 
allServices
ŒŒ %
)
ŒŒ% &
;
ŒŒ& '
}
œœ 
catch
–– 
(
–– 
	Exception
–– 
ex
–– 
)
––  
{
—— 
return
““ 

BadRequest
““ !
(
““! "
new
““" %
{
““& '
message
““( /
=
““0 1
$"
““2 4
$str
““4 S
{
““S T
ex
““T V
.
““V W
Message
““W ^
}
““^ _
"
““_ `
}
““a b
)
““b c
;
““c d
}
”” 
}
‘‘ 	
[
÷÷ 	

HttpDelete
÷÷	 
(
÷÷ 
$str
÷÷ "
)
÷÷" #
]
÷÷# $
public
◊◊ 
async
◊◊ 
Task
◊◊ 
<
◊◊ 
IActionResult
◊◊ '
>
◊◊' ("
DeletePrepaidService
◊◊) =
(
◊◊= >
int
◊◊> A
id
◊◊B D
)
◊◊D E
{
ÿÿ 	
var
ŸŸ 
userId
ŸŸ 
=
ŸŸ 
User
ŸŸ 
.
ŸŸ 
	FindFirst
ŸŸ '
(
ŸŸ' (
System
ŸŸ( .
.
ŸŸ. /
Security
ŸŸ/ 7
.
ŸŸ7 8
Claims
ŸŸ8 >
.
ŸŸ> ?

ClaimTypes
ŸŸ? I
.
ŸŸI J
NameIdentifier
ŸŸJ X
)
ŸŸX Y
?
ŸŸY Z
.
ŸŸZ [
Value
ŸŸ[ `
;
ŸŸ` a
var
⁄⁄ 
prepaid
⁄⁄ 
=
⁄⁄ 
await
⁄⁄ 
_context
⁄⁄  (
.
⁄⁄( )
PrepaidLoads
⁄⁄) 5
.
€€ 
Include
€€ 
(
€€ 
p
€€ 
=>
€€ 
p
€€ 
.
€€  
ServiceAccount
€€  .
)
€€. /
.
‹‹ 
ThenInclude
‹‹  
(
‹‹  !
sa
‹‹! #
=>
‹‹$ &
sa
‹‹' )
.
‹‹) *
Device
‹‹* 0
)
‹‹0 1
.
›› !
FirstOrDefaultAsync
›› $
(
››$ %
p
››% &
=>
››' )
p
››* +
.
››+ ,
PrepaidLoadID
››, 9
==
››: <
id
››= ?
&&
››@ B
p
››C D
.
››D E
ServiceAccount
››E S
.
››S T
Device
››T Z
.
››Z [
UserID
››[ a
==
››b d
userId
››e k
)
››k l
;
››l m
if
ﬂﬂ 
(
ﬂﬂ 
prepaid
ﬂﬂ 
==
ﬂﬂ 
null
ﬂﬂ 
)
ﬂﬂ  
return
ﬂﬂ! '
NotFound
ﬂﬂ( 0
(
ﬂﬂ0 1
new
ﬂﬂ1 4
{
ﬂﬂ5 6
message
ﬂﬂ7 >
=
ﬂﬂ? @
$str
ﬂﬂA \
}
ﬂﬂ] ^
)
ﬂﬂ^ _
;
ﬂﬂ_ `
_context
·· 
.
·· 
PrepaidLoads
·· !
.
··! "
Remove
··" (
(
··( )
prepaid
··) 0
)
··0 1
;
··1 2
await
‚‚ 
_context
‚‚ 
.
‚‚ 
SaveChangesAsync
‚‚ +
(
‚‚+ ,
)
‚‚, -
;
‚‚- .
return
„„ 
Ok
„„ 
(
„„ 
new
„„ 
{
„„ 
message
„„ #
=
„„$ %
$str
„„& L
}
„„M N
)
„„N O
;
„„O P
}
‰‰ 	
[
ÊÊ 	
HttpGet
ÊÊ	 
(
ÊÊ 
$str
ÊÊ '
)
ÊÊ' (
]
ÊÊ( )
public
ÁÁ 
async
ÁÁ 
Task
ÁÁ 
<
ÁÁ 
IActionResult
ÁÁ '
>
ÁÁ' (
GetPrepaidBalance
ÁÁ) :
(
ÁÁ: ;
int
ÁÁ; >
id
ÁÁ? A
)
ÁÁA B
{
ËË 	
var
ÈÈ 
userId
ÈÈ 
=
ÈÈ 
User
ÈÈ 
.
ÈÈ 
	FindFirst
ÈÈ '
(
ÈÈ' (
System
ÈÈ( .
.
ÈÈ. /
Security
ÈÈ/ 7
.
ÈÈ7 8
Claims
ÈÈ8 >
.
ÈÈ> ?

ClaimTypes
ÈÈ? I
.
ÈÈI J
NameIdentifier
ÈÈJ X
)
ÈÈX Y
?
ÈÈY Z
.
ÈÈZ [
Value
ÈÈ[ `
;
ÈÈ` a
var
ÍÍ 
prepaid
ÍÍ 
=
ÍÍ 
await
ÍÍ 
_context
ÍÍ  (
.
ÍÍ( )
PrepaidLoads
ÍÍ) 5
.
ÎÎ 
Include
ÎÎ 
(
ÎÎ 
p
ÎÎ 
=>
ÎÎ 
p
ÎÎ 
.
ÎÎ  
ServiceAccount
ÎÎ  .
)
ÎÎ. /
.
ÏÏ 
ThenInclude
ÏÏ  
(
ÏÏ  !
sa
ÏÏ! #
=>
ÏÏ$ &
sa
ÏÏ' )
.
ÏÏ) *
Device
ÏÏ* 0
)
ÏÏ0 1
.
ÌÌ !
FirstOrDefaultAsync
ÌÌ $
(
ÌÌ$ %
p
ÌÌ% &
=>
ÌÌ' )
p
ÌÌ* +
.
ÌÌ+ ,
PrepaidLoadID
ÌÌ, 9
==
ÌÌ: <
id
ÌÌ= ?
&&
ÌÌ@ B
p
ÌÌC D
.
ÌÌD E
ServiceAccount
ÌÌE S
.
ÌÌS T
Device
ÌÌT Z
.
ÌÌZ [
UserID
ÌÌ[ a
==
ÌÌb d
userId
ÌÌe k
)
ÌÌk l
;
ÌÌl m
if
ÔÔ 
(
ÔÔ 
prepaid
ÔÔ 
==
ÔÔ 
null
ÔÔ 
)
ÔÔ  
return
ÔÔ! '
NotFound
ÔÔ( 0
(
ÔÔ0 1
new
ÔÔ1 4
{
ÔÔ5 6
message
ÔÔ7 >
=
ÔÔ? @
$str
ÔÔA \
}
ÔÔ] ^
)
ÔÔ^ _
;
ÔÔ_ `
return
ÒÒ 
Ok
ÒÒ 
(
ÒÒ 
new
ÒÒ 
{
ÚÚ 
prepaidLoadID
ÛÛ 
=
ÛÛ 
prepaid
ÛÛ  '
.
ÛÛ' (
PrepaidLoadID
ÛÛ( 5
,
ÛÛ5 6
phoneNumber
ÙÙ 
=
ÙÙ 
prepaid
ÙÙ %
.
ÙÙ% &
PhoneNumber
ÙÙ& 1
,
ÙÙ1 2

loadAmount
ıı 
=
ıı 
prepaid
ıı $
.
ıı$ %

LoadAmount
ıı% /
,
ıı/ 0
remainingBalance
ˆˆ  
=
ˆˆ! "
prepaid
ˆˆ# *
.
ˆˆ* +
RemainingBalance
ˆˆ+ ;
??
ˆˆ< >
$num
ˆˆ? @
,
ˆˆ@ A

lastReload
˜˜ 
=
˜˜ 
prepaid
˜˜ $
.
˜˜$ %
LastReloadBalance
˜˜% 6
}
¯¯ 
)
¯¯ 
;
¯¯ 
}
˘˘ 	
[
˚˚ 	
HttpPost
˚˚	 
(
˚˚ 
$str
˚˚ *
)
˚˚* +
]
˚˚+ ,
public
¸¸ 
async
¸¸ 
Task
¸¸ 
<
¸¸ 
IActionResult
¸¸ '
>
¸¸' (
BuyPromo
¸¸) 1
(
¸¸1 2
int
¸¸2 5
id
¸¸6 8
,
¸¸8 9
[
¸¸: ;
FromBody
¸¸; C
]
¸¸C D
BuyPromoRequest
¸¸E T
request
¸¸U \
)
¸¸\ ]
{
˝˝ 	
var
˛˛ 
userId
˛˛ 
=
˛˛ 
User
˛˛ 
.
˛˛ 
	FindFirst
˛˛ '
(
˛˛' (
System
˛˛( .
.
˛˛. /
Security
˛˛/ 7
.
˛˛7 8
Claims
˛˛8 >
.
˛˛> ?

ClaimTypes
˛˛? I
.
˛˛I J
NameIdentifier
˛˛J X
)
˛˛X Y
?
˛˛Y Z
.
˛˛Z [
Value
˛˛[ `
;
˛˛` a
var
ˇˇ 
prepaid
ˇˇ 
=
ˇˇ 
await
ˇˇ 
_context
ˇˇ  (
.
ˇˇ( )
PrepaidLoads
ˇˇ) 5
.
ÄÄ 
Include
ÄÄ 
(
ÄÄ 
p
ÄÄ 
=>
ÄÄ 
p
ÄÄ 
.
ÄÄ  
ServiceAccount
ÄÄ  .
)
ÄÄ. /
.
ÅÅ 
ThenInclude
ÅÅ  
(
ÅÅ  !
sa
ÅÅ! #
=>
ÅÅ$ &
sa
ÅÅ' )
.
ÅÅ) *
Device
ÅÅ* 0
)
ÅÅ0 1
.
ÇÇ !
FirstOrDefaultAsync
ÇÇ $
(
ÇÇ$ %
p
ÇÇ% &
=>
ÇÇ' )
p
ÇÇ* +
.
ÇÇ+ ,
PrepaidLoadID
ÇÇ, 9
==
ÇÇ: <
id
ÇÇ= ?
&&
ÇÇ@ B
p
ÇÇC D
.
ÇÇD E
ServiceAccount
ÇÇE S
.
ÇÇS T
Device
ÇÇT Z
.
ÇÇZ [
UserID
ÇÇ[ a
==
ÇÇb d
userId
ÇÇe k
)
ÇÇk l
;
ÇÇl m
if
ÑÑ 
(
ÑÑ 
prepaid
ÑÑ 
==
ÑÑ 
null
ÑÑ 
)
ÑÑ  
return
ÑÑ! '
NotFound
ÑÑ( 0
(
ÑÑ0 1
new
ÑÑ1 4
{
ÑÑ5 6
message
ÑÑ7 >
=
ÑÑ? @
$str
ÑÑA \
}
ÑÑ] ^
)
ÑÑ^ _
;
ÑÑ_ `
if
ÖÖ 
(
ÖÖ 
request
ÖÖ 
.
ÖÖ 
Amount
ÖÖ 
<=
ÖÖ !
$num
ÖÖ" #
)
ÖÖ# $
return
ÖÖ% +

BadRequest
ÖÖ, 6
(
ÖÖ6 7
new
ÖÖ7 :
{
ÖÖ; <
message
ÖÖ= D
=
ÖÖE F
$str
ÖÖG W
}
ÖÖX Y
)
ÖÖY Z
;
ÖÖZ [
if
ÜÜ 
(
ÜÜ 
(
ÜÜ 
prepaid
ÜÜ 
.
ÜÜ 
RemainingBalance
ÜÜ )
??
ÜÜ* ,
$num
ÜÜ- .
)
ÜÜ. /
<
ÜÜ0 1
request
ÜÜ2 9
.
ÜÜ9 :
Amount
ÜÜ: @
)
ÜÜ@ A
return
ÜÜB H

BadRequest
ÜÜI S
(
ÜÜS T
new
ÜÜT W
{
ÜÜX Y
message
ÜÜZ a
=
ÜÜb c
$str
ÜÜd z
}
ÜÜ{ |
)
ÜÜ| }
;
ÜÜ} ~
prepaid
àà 
.
àà 
RemainingBalance
àà $
-=
àà% '
request
àà( /
.
àà/ 0
Amount
àà0 6
;
àà6 7
decimal
ää 
totalDataMB
ää 
=
ää  !
$num
ää" #
;
ää# $
if
ãã 
(
ãã 
!
ãã 
string
ãã 
.
ãã 
IsNullOrEmpty
ãã %
(
ãã% &
request
ãã& -
.
ãã- .
	PromoData
ãã. 7
)
ãã7 8
)
ãã8 9
{
åå 
if
çç 
(
çç 
request
çç 
.
çç 
	PromoData
çç %
.
çç% &
ToLower
çç& -
(
çç- .
)
çç. /
.
çç/ 0
Contains
çç0 8
(
çç8 9
$str
çç9 D
)
ççD E
)
ççE F
totalDataMB
éé 
=
éé  !
$num
éé" (
;
éé( )
else
èè 
{
êê 
var
ëë 
numStr
ëë 
=
ëë  
new
ëë! $
string
ëë% +
(
ëë+ ,
request
ëë, 3
.
ëë3 4
	PromoData
ëë4 =
.
ëë= >
Where
ëë> C
(
ëëC D
c
ëëD E
=>
ëëF H
char
ëëI M
.
ëëM N
IsDigit
ëëN U
(
ëëU V
c
ëëV W
)
ëëW X
||
ëëY [
c
ëë\ ]
==
ëë^ `
$char
ëëa d
)
ëëd e
.
ëëe f
ToArray
ëëf m
(
ëëm n
)
ëën o
)
ëëo p
;
ëëp q
if
íí 
(
íí 
decimal
íí 
.
íí  
TryParse
íí  (
(
íí( )
numStr
íí) /
,
íí/ 0
out
íí1 4
var
íí5 8
gb
íí9 ;
)
íí; <
)
íí< =
totalDataMB
ìì #
=
ìì$ %
gb
ìì& (
*
ìì) *
$num
ìì+ /
;
ìì/ 0
}
îî 
}
ïï 
int
óó 
validityDays
óó 
=
óó 
$num
óó !
;
óó! "
if
òò 
(
òò 
!
òò 
string
òò 
.
òò 
IsNullOrEmpty
òò %
(
òò% &
request
òò& -
.
òò- .
PromoValidity
òò. ;
)
òò; <
)
òò< =
{
ôô 
var
öö 
dayStr
öö 
=
öö 
new
öö  
string
öö! '
(
öö' (
request
öö( /
.
öö/ 0
PromoValidity
öö0 =
.
öö= >
Where
öö> C
(
ööC D
char
ööD H
.
ööH I
IsDigit
ööI P
)
ööP Q
.
ööQ R
ToArray
ööR Y
(
ööY Z
)
ööZ [
)
öö[ \
;
öö\ ]
if
õõ 
(
õõ 
int
õõ 
.
õõ 
TryParse
õõ  
(
õõ  !
dayStr
õõ! '
,
õõ' (
out
õõ) ,
var
õõ- 0
days
õõ1 5
)
õõ5 6
)
õõ6 7
validityDays
õõ8 D
=
õõE F
days
õõG K
;
õõK L
}
úú 
var
ûû 
promo
ûû 
=
ûû 
new
ûû 
PrepaidPromo
ûû (
{
üü 
PrepaidLoadID
†† 
=
†† 
prepaid
††  '
.
††' (
PrepaidLoadID
††( 5
,
††5 6
UserID
°° 
=
°° 
userId
°° 
!
°°  
,
°°  !

PromoTitle
¢¢ 
=
¢¢ 
request
¢¢ $
.
¢¢$ %

PromoTitle
¢¢% /
??
¢¢0 2
$str
¢¢3 B
,
¢¢B C
TotalDataMB
££ 
=
££ 
totalDataMB
££ )
,
££) *
RemainingDataMB
§§ 
=
§§  !
totalDataMB
§§" -
,
§§- .
ValidityDays
•• 
=
•• 
validityDays
•• +
,
••+ ,
ActivatedAt
¶¶ 
=
¶¶ 
DateTime
¶¶ &
.
¶¶& '
UtcNow
¶¶' -
,
¶¶- .
	ExpiresAt
ßß 
=
ßß 
DateTime
ßß $
.
ßß$ %
UtcNow
ßß% +
.
ßß+ ,
AddDays
ßß, 3
(
ßß3 4
validityDays
ßß4 @
)
ßß@ A
,
ßßA B
Status
®® 
=
®® 
$str
®® !
}
©© 
;
©© 
_context
™™ 
.
™™ 
PrepaidPromos
™™ "
.
™™" #
Add
™™# &
(
™™& '
promo
™™' ,
)
™™, -
;
™™- .
var
¨¨ 
invoice
¨¨ 
=
¨¨ 
new
¨¨ 
Invoice
¨¨ %
{
≠≠ 
PrepaidLoadID
ÆÆ 
=
ÆÆ 
prepaid
ÆÆ  '
.
ÆÆ' (
PrepaidLoadID
ÆÆ( 5
,
ÆÆ5 6
UserID
ØØ 
=
ØØ 
userId
ØØ 
!
ØØ  
,
ØØ  !
Amount
∞∞ 
=
∞∞ 
request
∞∞  
.
∞∞  !
Amount
∞∞! '
,
∞∞' (
DueDate
±± 
=
±± 
DateTime
±± "
.
±±" #
UtcNow
±±# )
,
±±) *
Status
≤≤ 
=
≤≤ 
$str
≤≤ 
,
≤≤  
	CreatedAt
≥≥ 
=
≥≥ 
DateTime
≥≥ $
.
≥≥$ %
UtcNow
≥≥% +
}
¥¥ 
;
¥¥ 
_context
µµ 
.
µµ 
Invoices
µµ 
.
µµ 
Add
µµ !
(
µµ! "
invoice
µµ" )
)
µµ) *
;
µµ* +
await
∂∂ 
_context
∂∂ 
.
∂∂ 
SaveChangesAsync
∂∂ +
(
∂∂+ ,
)
∂∂, -
;
∂∂- .
var
∏∏ 
payment
∏∏ 
=
∏∏ 
new
∏∏ 
Payment
∏∏ %
{
ππ 
UserID
∫∫ 
=
∫∫ 
userId
∫∫ 
!
∫∫  
,
∫∫  !
	InvoiceID
ªª 
=
ªª 
invoice
ªª #
.
ªª# $
	InvoiceID
ªª$ -
,
ªª- .

AmountPaid
ºº 
=
ºº 
request
ºº $
.
ºº$ %
Amount
ºº% +
,
ºº+ ,
PaymentMethod
ΩΩ 
=
ΩΩ 
$str
ΩΩ  1
,
ΩΩ1 2
PaymentDate
ææ 
=
ææ 
DateTime
ææ &
.
ææ& '
UtcNow
ææ' -
,
ææ- .
ReferenceNum
øø 
=
øø 
$"
øø !
$str
øø! '
{
øø' (
request
øø( /
.
øø/ 0

PromoTitle
øø0 :
?
øø: ;
.
øø; <
Replace
øø< C
(
øøC D
$str
øøD G
,
øøG H
$str
øøI L
)
øøL M
.
øøM N
ToUpper
øøN U
(
øøU V
)
øøV W
??
øøX Z
$str
øø[ d
}
øød e
$str
øøe f
{
øøf g
DateTime
øøg o
.
øøo p
UtcNow
øøp v
:
øøv w
$strøøw Ö
}øøÖ Ü
"øøÜ á
,øøá à
Status
¿¿ 
=
¿¿ 
$str
¿¿ $
}
¡¡ 
;
¡¡ 
_context
¬¬ 
.
¬¬ 
Payments
¬¬ 
.
¬¬ 
Add
¬¬ !
(
¬¬! "
payment
¬¬" )
)
¬¬) *
;
¬¬* +
await
√√ 
_context
√√ 
.
√√ 
SaveChangesAsync
√√ +
(
√√+ ,
)
√√, -
;
√√- .
return
≈≈ 
Ok
≈≈ 
(
≈≈ 
new
≈≈ 
{
≈≈ 
message
∆∆ 
=
∆∆ 
$str
∆∆ 8
,
∆∆8 9
remainingBalance
««  
=
««! "
prepaid
««# *
.
««* +
RemainingBalance
««+ ;
,
««; <
	paymentId
»» 
=
»» 
payment
»» #
.
»»# $
	PaymentID
»»$ -
,
»»- .
promoId
…… 
=
…… 
promo
…… 
.
……  
PrepaidPromoID
……  .
,
……. /

promoTitle
   
=
   
request
   $
.
  $ %

PromoTitle
  % /
,
  / 0
	promoData
ÀÀ 
=
ÀÀ 
request
ÀÀ #
.
ÀÀ# $
	PromoData
ÀÀ$ -
,
ÀÀ- .
promoValidity
ÃÃ 
=
ÃÃ 
request
ÃÃ  '
.
ÃÃ' (
PromoValidity
ÃÃ( 5
,
ÃÃ5 6
totalDataMB
ÕÕ 
,
ÕÕ 
remainingDataMB
ŒŒ 
=
ŒŒ  !
totalDataMB
ŒŒ" -
}
œœ 
)
œœ 
;
œœ 
}
–– 	
[
““ 	
HttpGet
““	 
(
““ 
$str
““ -
)
““- .
]
““. /
public
”” 
async
”” 
Task
”” 
<
”” 
IActionResult
”” '
>
””' (
GetActivePromos
””) 8
(
””8 9
int
””9 <
id
””= ?
)
””? @
{
‘‘ 	
var
’’ 
userId
’’ 
=
’’ 
User
’’ 
.
’’ 
	FindFirst
’’ '
(
’’' (
System
’’( .
.
’’. /
Security
’’/ 7
.
’’7 8
Claims
’’8 >
.
’’> ?

ClaimTypes
’’? I
.
’’I J
NameIdentifier
’’J X
)
’’X Y
?
’’Y Z
.
’’Z [
Value
’’[ `
;
’’` a
var
÷÷ 
prepaid
÷÷ 
=
÷÷ 
await
÷÷ 
_context
÷÷  (
.
÷÷( )
PrepaidLoads
÷÷) 5
.
◊◊ 
Include
◊◊ 
(
◊◊ 
p
◊◊ 
=>
◊◊ 
p
◊◊ 
.
◊◊  
ServiceAccount
◊◊  .
)
◊◊. /
.
ÿÿ 
ThenInclude
ÿÿ  
(
ÿÿ  !
sa
ÿÿ! #
=>
ÿÿ$ &
sa
ÿÿ' )
.
ÿÿ) *
Device
ÿÿ* 0
)
ÿÿ0 1
.
ŸŸ !
FirstOrDefaultAsync
ŸŸ $
(
ŸŸ$ %
p
ŸŸ% &
=>
ŸŸ' )
p
ŸŸ* +
.
ŸŸ+ ,
PrepaidLoadID
ŸŸ, 9
==
ŸŸ: <
id
ŸŸ= ?
&&
ŸŸ@ B
p
ŸŸC D
.
ŸŸD E
ServiceAccount
ŸŸE S
.
ŸŸS T
Device
ŸŸT Z
.
ŸŸZ [
UserID
ŸŸ[ a
==
ŸŸb d
userId
ŸŸe k
)
ŸŸk l
;
ŸŸl m
if
€€ 
(
€€ 
prepaid
€€ 
==
€€ 
null
€€ 
)
€€  
return
€€! '
NotFound
€€( 0
(
€€0 1
new
€€1 4
{
€€5 6
message
€€7 >
=
€€? @
$str
€€A \
}
€€] ^
)
€€^ _
;
€€_ `
var
›› 
expiredPromos
›› 
=
›› 
await
››  %
_context
››& .
.
››. /
PrepaidPromos
››/ <
.
ﬁﬁ 
Where
ﬁﬁ 
(
ﬁﬁ 
p
ﬁﬁ 
=>
ﬁﬁ 
p
ﬁﬁ 
.
ﬁﬁ 
PrepaidLoadID
ﬁﬁ +
==
ﬁﬁ, .
id
ﬁﬁ/ 1
&&
ﬁﬁ2 4
p
ﬁﬁ5 6
.
ﬁﬁ6 7
UserID
ﬁﬁ7 =
==
ﬁﬁ> @
userId
ﬁﬁA G
&&
ﬁﬁH J
p
ﬁﬁK L
.
ﬁﬁL M
Status
ﬁﬁM S
==
ﬁﬁT V
$str
ﬁﬁW _
&&
ﬁﬁ` b
p
ﬁﬁc d
.
ﬁﬁd e
	ExpiresAt
ﬁﬁe n
<=
ﬁﬁo q
DateTime
ﬁﬁr z
.
ﬁﬁz {
UtcNowﬁﬁ{ Å
)ﬁﬁÅ Ç
.
ﬂﬂ 
ToListAsync
ﬂﬂ 
(
ﬂﬂ 
)
ﬂﬂ 
;
ﬂﬂ 
foreach
‡‡ 
(
‡‡ 
var
‡‡ 
ep
‡‡ 
in
‡‡ 
expiredPromos
‡‡ ,
)
‡‡, -
ep
‡‡. 0
.
‡‡0 1
Status
‡‡1 7
=
‡‡8 9
$str
‡‡: C
;
‡‡C D
if
·· 
(
·· 
expiredPromos
·· 
.
·· 
Any
·· !
(
··! "
)
··" #
)
··# $
await
··% *
_context
··+ 3
.
··3 4
SaveChangesAsync
··4 D
(
··D E
)
··E F
;
··F G
var
„„ 
promos
„„ 
=
„„ 
await
„„ 
_context
„„ '
.
„„' (
PrepaidPromos
„„( 5
.
‰‰ 
Where
‰‰ 
(
‰‰ 
p
‰‰ 
=>
‰‰ 
p
‰‰ 
.
‰‰ 
PrepaidLoadID
‰‰ +
==
‰‰, .
id
‰‰/ 1
&&
‰‰2 4
p
‰‰5 6
.
‰‰6 7
UserID
‰‰7 =
==
‰‰> @
userId
‰‰A G
&&
‰‰H J
p
‰‰K L
.
‰‰L M
Status
‰‰M S
==
‰‰T V
$str
‰‰W _
)
‰‰_ `
.
ÂÂ 
OrderByDescending
ÂÂ "
(
ÂÂ" #
p
ÂÂ# $
=>
ÂÂ% '
p
ÂÂ( )
.
ÂÂ) *
ActivatedAt
ÂÂ* 5
)
ÂÂ5 6
.
ÊÊ 
Select
ÊÊ 
(
ÊÊ 
p
ÊÊ 
=>
ÊÊ 
new
ÊÊ  
{
ÊÊ! "
p
ÁÁ 
.
ÁÁ 
PrepaidPromoID
ÁÁ $
,
ÁÁ$ %
p
ËË 
.
ËË 

PromoTitle
ËË  
,
ËË  !
p
ÈÈ 
.
ÈÈ 
TotalDataMB
ÈÈ !
,
ÈÈ! "
p
ÍÍ 
.
ÍÍ 
RemainingDataMB
ÍÍ %
,
ÍÍ% &
p
ÎÎ 
.
ÎÎ 
ValidityDays
ÎÎ "
,
ÎÎ" #
p
ÏÏ 
.
ÏÏ 
ActivatedAt
ÏÏ !
,
ÏÏ! "
p
ÌÌ 
.
ÌÌ 
	ExpiresAt
ÌÌ 
,
ÌÌ  
p
ÓÓ 
.
ÓÓ 
Status
ÓÓ 
}
ÔÔ 
)
ÔÔ 
.
 
ToListAsync
 
(
 
)
 
;
 
return
ÚÚ 
Ok
ÚÚ 
(
ÚÚ 
promos
ÚÚ 
)
ÚÚ 
;
ÚÚ 
}
ÛÛ 	
[
ıı 	
HttpPost
ıı	 
(
ıı 
$str
ıı ,
)
ıı, -
]
ıı- .
public
ˆˆ 
async
ˆˆ 
Task
ˆˆ 
<
ˆˆ 
IActionResult
ˆˆ '
>
ˆˆ' (
TopUpPrepaidGCash
ˆˆ) :
(
ˆˆ: ;
int
ˆˆ; >
id
ˆˆ? A
,
ˆˆA B
[
ˆˆC D
FromBody
ˆˆD L
]
ˆˆL M
TopUpRequest
ˆˆN Z
request
ˆˆ[ b
)
ˆˆb c
{
˜˜ 	
var
¯¯ 
userId
¯¯ 
=
¯¯ 
User
¯¯ 
.
¯¯ 
	FindFirst
¯¯ '
(
¯¯' (
System
¯¯( .
.
¯¯. /
Security
¯¯/ 7
.
¯¯7 8
Claims
¯¯8 >
.
¯¯> ?

ClaimTypes
¯¯? I
.
¯¯I J
NameIdentifier
¯¯J X
)
¯¯X Y
?
¯¯Y Z
.
¯¯Z [
Value
¯¯[ `
;
¯¯` a
var
˘˘ 
prepaid
˘˘ 
=
˘˘ 
await
˘˘ 
_context
˘˘  (
.
˘˘( )
PrepaidLoads
˘˘) 5
.
˙˙ 
Include
˙˙ 
(
˙˙ 
p
˙˙ 
=>
˙˙ 
p
˙˙ 
.
˙˙  
ServiceAccount
˙˙  .
)
˙˙. /
.
˚˚ 
ThenInclude
˚˚  
(
˚˚  !
sa
˚˚! #
=>
˚˚$ &
sa
˚˚' )
.
˚˚) *
Device
˚˚* 0
)
˚˚0 1
.
¸¸ !
FirstOrDefaultAsync
¸¸ $
(
¸¸$ %
p
¸¸% &
=>
¸¸' )
p
¸¸* +
.
¸¸+ ,
PrepaidLoadID
¸¸, 9
==
¸¸: <
id
¸¸= ?
&&
¸¸@ B
p
¸¸C D
.
¸¸D E
ServiceAccount
¸¸E S
.
¸¸S T
Device
¸¸T Z
.
¸¸Z [
UserID
¸¸[ a
==
¸¸b d
userId
¸¸e k
)
¸¸k l
;
¸¸l m
if
˛˛ 
(
˛˛ 
prepaid
˛˛ 
==
˛˛ 
null
˛˛ 
)
˛˛  
return
˛˛! '
NotFound
˛˛( 0
(
˛˛0 1
new
˛˛1 4
{
˛˛5 6
message
˛˛7 >
=
˛˛? @
$str
˛˛A \
}
˛˛] ^
)
˛˛^ _
;
˛˛_ `
if
ˇˇ 
(
ˇˇ 
request
ˇˇ 
.
ˇˇ 
Amount
ˇˇ 
<=
ˇˇ !
$num
ˇˇ" #
)
ˇˇ# $
return
ˇˇ% +

BadRequest
ˇˇ, 6
(
ˇˇ6 7
new
ˇˇ7 :
{
ˇˇ; <
message
ˇˇ= D
=
ˇˇE F
$str
ˇˇG W
}
ˇˇX Y
)
ˇˇY Z
;
ˇˇZ [
if
ÄÄ 
(
ÄÄ 
request
ÄÄ 
.
ÄÄ 
Amount
ÄÄ 
<
ÄÄ  
$num
ÄÄ! #
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
ÄÄG e
}
ÄÄf g
)
ÄÄg h
;
ÄÄh i
try
ÇÇ 
{
ÉÉ 
var
ÑÑ 
invoice
ÑÑ 
=
ÑÑ 
new
ÑÑ !
Invoice
ÑÑ" )
{
ÖÖ 
PrepaidLoadID
ÜÜ !
=
ÜÜ" #
id
ÜÜ$ &
,
ÜÜ& '
UserID
áá 
=
áá 
userId
áá #
!
áá# $
,
áá$ %
Amount
àà 
=
àà 
request
àà $
.
àà$ %
Amount
àà% +
,
àà+ ,
DueDate
ââ 
=
ââ 
DateTime
ââ &
.
ââ& '
UtcNow
ââ' -
.
ââ- .
	AddMonths
ââ. 7
(
ââ7 8
$num
ââ8 9
)
ââ9 :
,
ââ: ;
Status
ää 
=
ää 
$str
ää &
}
ãã 
;
ãã 
_context
åå 
.
åå 
Invoices
åå !
.
åå! "
Add
åå" %
(
åå% &
invoice
åå& -
)
åå- .
;
åå. /
await
çç 
_context
çç 
.
çç 
SaveChangesAsync
çç /
(
çç/ 0
)
çç0 1
;
çç1 2
var
èè 
(
èè 
sourceId
èè 
,
èè 
checkoutUrl
èè *
)
èè* +
=
èè, -
await
èè. 3
_payMongoService
èè4 D
.
èèD E)
CreateSourceForPrepaidTopUp
èèE `
(
èè` a
request
èèa h
.
èèh i
Amount
èèi o
,
èèo p
id
èèq s
,
èès t
$"
èèu w
$strèèw á
{èèá à
invoiceèèà è
.èèè ê
	InvoiceIDèèê ô
}èèô ö
"èèö õ
)èèõ ú
;èèú ù
if
ëë 
(
ëë 
string
ëë 
.
ëë 
IsNullOrEmpty
ëë (
(
ëë( )
checkoutUrl
ëë) 4
)
ëë4 5
)
ëë5 6
{
íí 
return
ìì 

BadRequest
ìì %
(
ìì% &
new
ìì& )
{
ìì* +
message
ìì, 3
=
ìì4 5
$str
ìì6 W
}
ììX Y
)
ììY Z
;
ììZ [
}
îî 
var
ññ 
payment
ññ 
=
ññ 
new
ññ !
Payment
ññ" )
{
óó 
UserID
òò 
=
òò 
userId
òò #
!
òò# $
,
òò$ %
	InvoiceID
ôô 
=
ôô 
invoice
ôô  '
.
ôô' (
	InvoiceID
ôô( 1
,
ôô1 2

AmountPaid
öö 
=
öö  
request
öö! (
.
öö( )
Amount
öö) /
,
öö/ 0
PaymentMethod
õõ !
=
õõ" #
$str
õõ$ +
,
õõ+ ,
PaymentDate
úú 
=
úú  !
DateTime
úú" *
.
úú* +
UtcNow
úú+ 1
,
úú1 2
ReferenceNum
ùù  
=
ùù! "
sourceId
ùù# +
,
ùù+ ,
Status
ûû 
=
ûû 
$str
ûû &
}
üü 
;
üü 
_context
†† 
.
†† 
Payments
†† !
.
††! "
Add
††" %
(
††% &
payment
††& -
)
††- .
;
††. /
await
°° 
_context
°° 
.
°° 
SaveChangesAsync
°° /
(
°°/ 0
)
°°0 1
;
°°1 2
return
££ 
Ok
££ 
(
££ 
new
££ 
{
££ 
checkoutUrl
££  +
=
££, -
checkoutUrl
££. 9
,
££9 :
	paymentId
££; D
=
££E F
payment
££G N
.
££N O
	PaymentID
££O X
}
££Y Z
)
££Z [
;
££[ \
}
§§ 
catch
•• 
(
•• 
	Exception
•• 
ex
•• 
)
••  
{
¶¶ 
Console
ßß 
.
ßß 
	WriteLine
ßß !
(
ßß! "
$"
ßß" $
$str
ßß$ =
{
ßß= >
ex
ßß> @
.
ßß@ A
Message
ßßA H
}
ßßH I
"
ßßI J
)
ßßJ K
;
ßßK L
return
®® 

BadRequest
®® !
(
®®! "
new
®®" %
{
®®& '
message
®®( /
=
®®0 1
ex
®®2 4
.
®®4 5
Message
®®5 <
}
®®= >
)
®®> ?
;
®®? @
}
©© 
}
™™ 	
[
¨¨ 	
HttpPost
¨¨	 
(
¨¨ 
$str
¨¨ /
)
¨¨/ 0
]
¨¨0 1
public
≠≠ 
async
≠≠ 
Task
≠≠ 
<
≠≠ 
IActionResult
≠≠ '
>
≠≠' ("
CompletePrepaidTopUp
≠≠) =
(
≠≠= >
int
≠≠> A
id
≠≠B D
)
≠≠D E
{
ÆÆ 	
var
ØØ 
userId
ØØ 
=
ØØ 
User
ØØ 
.
ØØ 
	FindFirst
ØØ '
(
ØØ' (
System
ØØ( .
.
ØØ. /
Security
ØØ/ 7
.
ØØ7 8
Claims
ØØ8 >
.
ØØ> ?

ClaimTypes
ØØ? I
.
ØØI J
NameIdentifier
ØØJ X
)
ØØX Y
?
ØØY Z
.
ØØZ [
Value
ØØ[ `
;
ØØ` a
var
∞∞ 
prepaid
∞∞ 
=
∞∞ 
await
∞∞ 
_context
∞∞  (
.
∞∞( )
PrepaidLoads
∞∞) 5
.
±± 
Include
±± 
(
±± 
p
±± 
=>
±± 
p
±± 
.
±±  
ServiceAccount
±±  .
)
±±. /
.
≤≤ 
ThenInclude
≤≤  
(
≤≤  !
sa
≤≤! #
=>
≤≤$ &
sa
≤≤' )
.
≤≤) *
Device
≤≤* 0
)
≤≤0 1
.
≥≥ !
FirstOrDefaultAsync
≥≥ $
(
≥≥$ %
p
≥≥% &
=>
≥≥' )
p
≥≥* +
.
≥≥+ ,
PrepaidLoadID
≥≥, 9
==
≥≥: <
id
≥≥= ?
&&
≥≥@ B
p
≥≥C D
.
≥≥D E
ServiceAccount
≥≥E S
.
≥≥S T
Device
≥≥T Z
.
≥≥Z [
UserID
≥≥[ a
==
≥≥b d
userId
≥≥e k
)
≥≥k l
;
≥≥l m
if
µµ 
(
µµ 
prepaid
µµ 
==
µµ 
null
µµ 
)
µµ  
return
µµ! '
NotFound
µµ( 0
(
µµ0 1
new
µµ1 4
{
µµ5 6
message
µµ7 >
=
µµ? @
$str
µµA \
}
µµ] ^
)
µµ^ _
;
µµ_ `
var
∑∑ 
pendingPayment
∑∑ 
=
∑∑  
await
∑∑! &
_context
∑∑' /
.
∑∑/ 0
Payments
∑∑0 8
.
∏∏ 
Include
∏∏ 
(
∏∏ 
p
∏∏ 
=>
∏∏ 
p
∏∏ 
.
∏∏  
Invoice
∏∏  '
)
∏∏' (
.
ππ 
Where
ππ 
(
ππ 
p
ππ 
=>
ππ 
p
ππ 
.
ππ 
UserID
ππ $
==
ππ% '
userId
ππ( .
&&
ππ/ 1
p
ππ2 3
.
ππ3 4
Status
ππ4 :
==
ππ; =
$str
ππ> G
&&
ππH J
p
ππK L
.
ππL M
Invoice
ππM T
!=
ππU W
null
ππX \
&&
ππ] _
p
ππ` a
.
ππa b
Invoice
ππb i
.
ππi j
PrepaidLoadID
ππj w
==
ππx z
id
ππ{ }
)
ππ} ~
.
∫∫ 
OrderByDescending
∫∫ "
(
∫∫" #
p
∫∫# $
=>
∫∫% '
p
∫∫( )
.
∫∫) *
PaymentDate
∫∫* 5
)
∫∫5 6
.
ªª !
FirstOrDefaultAsync
ªª $
(
ªª$ %
)
ªª% &
;
ªª& '
if
ΩΩ 
(
ΩΩ 
pendingPayment
ΩΩ 
==
ΩΩ !
null
ΩΩ" &
)
ΩΩ& '
{
ææ 
var
øø 
alreadyCompleted
øø $
=
øø% &
await
øø' ,
_context
øø- 5
.
øø5 6
Payments
øø6 >
.
¿¿ 
Include
¿¿ 
(
¿¿ 
p
¿¿ 
=>
¿¿ !
p
¿¿" #
.
¿¿# $
Invoice
¿¿$ +
)
¿¿+ ,
.
¡¡ 
Where
¡¡ 
(
¡¡ 
p
¡¡ 
=>
¡¡ 
p
¡¡  !
.
¡¡! "
UserID
¡¡" (
==
¡¡) +
userId
¡¡, 2
&&
¡¡3 5
p
¡¡6 7
.
¡¡7 8
Status
¡¡8 >
==
¡¡? A
$str
¡¡B M
&&
¡¡N P
p
¡¡Q R
.
¡¡R S
Invoice
¡¡S Z
!=
¡¡[ ]
null
¡¡^ b
&&
¡¡c e
p
¡¡f g
.
¡¡g h
Invoice
¡¡h o
.
¡¡o p
PrepaidLoadID
¡¡p }
==¡¡~ Ä
id¡¡Å É
)¡¡É Ñ
.
¬¬ 
OrderByDescending
¬¬ &
(
¬¬& '
p
¬¬' (
=>
¬¬) +
p
¬¬, -
.
¬¬- .
PaymentDate
¬¬. 9
)
¬¬9 :
.
√√ !
FirstOrDefaultAsync
√√ (
(
√√( )
)
√√) *
;
√√* +
if
≈≈ 
(
≈≈ 
alreadyCompleted
≈≈ $
!=
≈≈% '
null
≈≈( ,
)
≈≈, -
return
∆∆ 
Ok
∆∆ 
(
∆∆ 
new
∆∆ !
{
∆∆" #
status
∆∆$ *
=
∆∆+ ,
$str
∆∆- 8
,
∆∆8 9
message
∆∆: A
=
∆∆B C
$str
∆∆D ]
,
∆∆] ^
amountAdded
∆∆_ j
=
∆∆k l
alreadyCompleted
∆∆m }
.
∆∆} ~

AmountPaid∆∆~ à
,∆∆à â

loadAmount∆∆ä î
=∆∆ï ñ
prepaid∆∆ó û
.∆∆û ü

LoadAmount∆∆ü ©
,∆∆© ™ 
remainingBalance∆∆´ ª
=∆∆º Ω
prepaid∆∆æ ≈
.∆∆≈ ∆ 
RemainingBalance∆∆∆ ÷
,∆∆÷ ◊

lastReload∆∆ÿ ‚
=∆∆„ ‰
prepaid∆∆Â Ï
.∆∆Ï Ì!
LastReloadBalance∆∆Ì ˛
}∆∆ˇ Ä
)∆∆Ä Å
;∆∆Å Ç
return
»» 
Ok
»» 
(
»» 
new
»» 
{
»» 
status
»»  &
=
»»' (
$str
»») 2
,
»»2 3
message
»»4 ;
=
»»< =
$str
»»> _
}
»»` a
)
»»a b
;
»»b c
}
…… 
try
ÀÀ 
{
ÃÃ 
var
ÕÕ 
sourceStatus
ÕÕ  
=
ÕÕ! "
await
ÕÕ# (
_payMongoService
ÕÕ) 9
.
ÕÕ9 :
GetSourceStatus
ÕÕ: I
(
ÕÕI J
pendingPayment
ÕÕJ X
.
ÕÕX Y
ReferenceNum
ÕÕY e
!
ÕÕe f
)
ÕÕf g
;
ÕÕg h
Console
ŒŒ 
.
ŒŒ 
	WriteLine
ŒŒ !
(
ŒŒ! "
$"
ŒŒ" $
$str
ŒŒ$ D
{
ŒŒD E
pendingPayment
ŒŒE S
.
ŒŒS T
ReferenceNum
ŒŒT `
}
ŒŒ` a
$str
ŒŒa c
{
ŒŒc d
sourceStatus
ŒŒd p
}
ŒŒp q
"
ŒŒq r
)
ŒŒr s
;
ŒŒs t
if
–– 
(
–– 
sourceStatus
––  
==
––! #
$str
––$ 0
||
––1 3
sourceStatus
––4 @
==
––A C
$str
––D J
)
––J K
{
—— 
pendingPayment
““ "
.
““" #
Status
““# )
=
““* +
$str
““, 7
;
““7 8
pendingPayment
”” "
.
””" #
PaymentDate
””# .
=
””/ 0
DateTime
””1 9
.
””9 :
UtcNow
””: @
;
””@ A
if
’’ 
(
’’ 
pendingPayment
’’ &
.
’’& '
Invoice
’’' .
!=
’’/ 1
null
’’2 6
)
’’6 7
{
÷÷ 
pendingPayment
◊◊ &
.
◊◊& '
Invoice
◊◊' .
.
◊◊. /
Status
◊◊/ 5
=
◊◊6 7
$str
◊◊8 >
;
◊◊> ?
}
ÿÿ 
var
ŸŸ 
amountAdded
ŸŸ #
=
ŸŸ$ %
pendingPayment
ŸŸ& 4
.
ŸŸ4 5

AmountPaid
ŸŸ5 ?
;
ŸŸ? @
prepaid
⁄⁄ 
.
⁄⁄ 

LoadAmount
⁄⁄ &
+=
⁄⁄' )
amountAdded
⁄⁄* 5
;
⁄⁄5 6
prepaid
€€ 
.
€€ 
RemainingBalance
€€ ,
=
€€- .
(
€€/ 0
prepaid
€€0 7
.
€€7 8
RemainingBalance
€€8 H
??
€€I K
$num
€€L M
)
€€M N
+
€€O P
amountAdded
€€Q \
;
€€\ ]
prepaid
‹‹ 
.
‹‹ 
LastReloadBalance
‹‹ -
=
‹‹. /
DateTime
‹‹0 8
.
‹‹8 9
UtcNow
‹‹9 ?
;
‹‹? @
await
ﬁﬁ 
_context
ﬁﬁ "
.
ﬁﬁ" #
SaveChangesAsync
ﬁﬁ# 3
(
ﬁﬁ3 4
)
ﬁﬁ4 5
;
ﬁﬁ5 6
return
‡‡ 
Ok
‡‡ 
(
‡‡ 
new
‡‡ !
{
·· 
status
‚‚ 
=
‚‚  
$str
‚‚! ,
,
‚‚, -
message
„„ 
=
„„  !
$str
„„" B
,
„„B C
amountAdded
‰‰ #
,
‰‰# $

loadAmount
ÂÂ "
=
ÂÂ# $
prepaid
ÂÂ% ,
.
ÂÂ, -

LoadAmount
ÂÂ- 7
,
ÂÂ7 8
remainingBalance
ÊÊ (
=
ÊÊ) *
prepaid
ÊÊ+ 2
.
ÊÊ2 3
RemainingBalance
ÊÊ3 C
,
ÊÊC D

lastReload
ÁÁ "
=
ÁÁ# $
prepaid
ÁÁ% ,
.
ÁÁ, -
LastReloadBalance
ÁÁ- >
}
ËË 
)
ËË 
;
ËË 
}
ÈÈ 
else
ÍÍ 
if
ÍÍ 
(
ÍÍ 
sourceStatus
ÍÍ %
==
ÍÍ& (
$str
ÍÍ) 4
||
ÍÍ5 7
sourceStatus
ÍÍ8 D
==
ÍÍE G
$str
ÍÍH Q
)
ÍÍQ R
{
ÎÎ 
pendingPayment
ÏÏ "
.
ÏÏ" #
Status
ÏÏ# )
=
ÏÏ* +
$str
ÏÏ, 4
;
ÏÏ4 5
if
ÌÌ 
(
ÌÌ 
pendingPayment
ÌÌ &
.
ÌÌ& '
Invoice
ÌÌ' .
!=
ÌÌ/ 1
null
ÌÌ2 6
)
ÌÌ6 7
pendingPayment
ÓÓ &
.
ÓÓ& '
Invoice
ÓÓ' .
.
ÓÓ. /
Status
ÓÓ/ 5
=
ÓÓ6 7
$str
ÓÓ8 @
;
ÓÓ@ A
await
ÔÔ 
_context
ÔÔ "
.
ÔÔ" #
SaveChangesAsync
ÔÔ# 3
(
ÔÔ3 4
)
ÔÔ4 5
;
ÔÔ5 6
return
 
Ok
 
(
 
new
 !
{
" #
status
$ *
=
+ ,
$str
- 5
,
5 6
message
7 >
=
? @
$str
A d
}
e f
)
f g
;
g h
}
ÒÒ 
else
ÚÚ 
{
ÛÛ 
return
ÙÙ 
Ok
ÙÙ 
(
ÙÙ 
new
ÙÙ !
{
ÙÙ" #
status
ÙÙ$ *
=
ÙÙ+ ,
$str
ÙÙ- 6
,
ÙÙ6 7
message
ÙÙ8 ?
=
ÙÙ@ A
$str
ÙÙB v
}
ÙÙw x
)
ÙÙx y
;
ÙÙy z
}
ıı 
}
ˆˆ 
catch
˜˜ 
(
˜˜ 
	Exception
˜˜ 
ex
˜˜ 
)
˜˜  
{
¯¯ 
Console
˘˘ 
.
˘˘ 
	WriteLine
˘˘ !
(
˘˘! "
$"
˘˘" $
$str
˘˘$ P
{
˘˘P Q
ex
˘˘Q S
.
˘˘S T
Message
˘˘T [
}
˘˘[ \
"
˘˘\ ]
)
˘˘] ^
;
˘˘^ _
return
˙˙ 
Ok
˙˙ 
(
˙˙ 
new
˙˙ 
{
˙˙ 
status
˙˙  &
=
˙˙' (
$str
˙˙) 2
,
˙˙2 3
message
˙˙4 ;
=
˙˙< =
$str
˙˙> r
}
˙˙s t
)
˙˙t u
;
˙˙u v
}
˚˚ 
}
¸¸ 	
[
ÄÄ 	
HttpGet
ÄÄ	 
(
ÄÄ 
$str
ÄÄ 
)
ÄÄ 
]
ÄÄ 
public
ÅÅ 
async
ÅÅ 
Task
ÅÅ 
<
ÅÅ 
IActionResult
ÅÅ '
>
ÅÅ' (
GetInvoices
ÅÅ) 4
(
ÅÅ4 5
)
ÅÅ5 6
{
ÇÇ 	
try
ÉÉ 
{
ÑÑ 
var
ÖÖ 
userId
ÖÖ 
=
ÖÖ 
User
ÖÖ !
.
ÖÖ! "
	FindFirst
ÖÖ" +
(
ÖÖ+ ,
System
ÖÖ, 2
.
ÖÖ2 3
Security
ÖÖ3 ;
.
ÖÖ; <
Claims
ÖÖ< B
.
ÖÖB C

ClaimTypes
ÖÖC M
.
ÖÖM N
NameIdentifier
ÖÖN \
)
ÖÖ\ ]
?
ÖÖ] ^
.
ÖÖ^ _
Value
ÖÖ_ d
;
ÖÖd e
var
ÜÜ 
invoices
ÜÜ 
=
ÜÜ 
await
ÜÜ $
_context
ÜÜ% -
.
ÜÜ- .
Invoices
ÜÜ. 6
.
áá 
Include
áá 
(
áá 
i
áá 
=>
áá !
i
áá" #
.
áá# $
Payments
áá$ ,
)
áá, -
.
àà 
Where
àà 
(
àà 
i
àà 
=>
àà 
i
àà  !
.
àà! "
UserID
àà" (
==
àà) +
userId
àà, 2
)
àà2 3
.
ââ 
OrderByDescending
ââ &
(
ââ& '
i
ââ' (
=>
ââ) +
i
ââ, -
.
ââ- .
	CreatedAt
ââ. 7
)
ââ7 8
.
ää 
Select
ää 
(
ää 
i
ää 
=>
ää  
new
ää! $
{
ãã 
i
åå 
.
åå 
	InvoiceID
åå #
,
åå# $
i
çç 
.
çç 
SubscriptionID
çç (
,
çç( )
i
éé 
.
éé 
UserID
éé  
,
éé  !
i
èè 
.
èè 
Amount
èè  
,
èè  !
i
êê 
.
êê 
DueDate
êê !
,
êê! "
i
ëë 
.
ëë 
Status
ëë  
,
ëë  !
i
íí 
.
íí 
	CreatedAt
íí #
,
íí# $
Payments
ìì  
=
ìì! "
i
ìì# $
.
ìì$ %
Payments
ìì% -
.
ìì- .
Select
ìì. 4
(
ìì4 5
p
ìì5 6
=>
ìì7 9
new
ìì: =
{
ìì> ?
p
ìì@ A
.
ììA B
	PaymentID
ììB K
,
ììK L
p
ììM N
.
ììN O
Status
ììO U
,
ììU V
p
ììW X
.
ììX Y
ReferenceNum
ììY e
}
ììf g
)
ììg h
.
ììh i
ToList
ììi o
(
ììo p
)
ììp q
}
îî 
)
îî 
.
ïï 
ToListAsync
ïï  
(
ïï  !
)
ïï! "
;
ïï" #
return
ññ 
Ok
ññ 
(
ññ 
invoices
ññ "
)
ññ" #
;
ññ# $
}
óó 
catch
òò 
(
òò 
	Exception
òò 
ex
òò 
)
òò  
{
ôô 
return
öö 

StatusCode
öö !
(
öö! "
$num
öö" %
,
öö% &
new
öö' *
{
öö+ ,
message
öö- 4
=
öö5 6
$"
öö7 9
$str
öö9 S
{
ööS T
ex
ööT V
.
ööV W
Message
ööW ^
}
öö^ _
"
öö_ `
}
ööa b
)
ööb c
;
ööc d
}
õõ 
}
úú 	
[
ûû 	
HttpGet
ûû	 
(
ûû 
$str
ûû 
)
ûû 
]
ûû 
public
üü 
async
üü 
Task
üü 
<
üü 
IActionResult
üü '
>
üü' (
GetPayments
üü) 4
(
üü4 5
)
üü5 6
{
†† 	
try
°° 
{
¢¢ 
var
££ 
userId
££ 
=
££ 
User
££ !
.
££! "
	FindFirst
££" +
(
££+ ,
System
££, 2
.
££2 3
Security
££3 ;
.
££; <
Claims
££< B
.
££B C

ClaimTypes
££C M
.
££M N
NameIdentifier
££N \
)
££\ ]
?
££] ^
.
££^ _
Value
££_ d
;
££d e
var
§§ 
payments
§§ 
=
§§ 
await
§§ $
_context
§§% -
.
§§- .
Payments
§§. 6
.
•• 
Where
•• 
(
•• 
p
•• 
=>
•• 
p
••  !
.
••! "
UserID
••" (
==
••) +
userId
••, 2
)
••2 3
.
¶¶ 
OrderByDescending
¶¶ &
(
¶¶& '
p
¶¶' (
=>
¶¶) +
p
¶¶, -
.
¶¶- .
PaymentDate
¶¶. 9
)
¶¶9 :
.
ßß 
Select
ßß 
(
ßß 
p
ßß 
=>
ßß  
new
ßß! $
{
®® 
p
©© 
.
©© 
	PaymentID
©© #
,
©©# $
p
™™ 
.
™™ 
	InvoiceID
™™ #
,
™™# $
p
´´ 
.
´´ 
UserID
´´  
,
´´  !
p
¨¨ 
.
¨¨ 

AmountPaid
¨¨ $
,
¨¨$ %
p
≠≠ 
.
≠≠ 
PaymentMethod
≠≠ '
,
≠≠' (
p
ÆÆ 
.
ÆÆ 
ReferenceNum
ÆÆ &
,
ÆÆ& '
p
ØØ 
.
ØØ 
PaymentDate
ØØ %
,
ØØ% &
p
∞∞ 
.
∞∞ 
Status
∞∞  
}
±± 
)
±± 
.
≤≤ 
ToListAsync
≤≤  
(
≤≤  !
)
≤≤! "
;
≤≤" #
return
≥≥ 
Ok
≥≥ 
(
≥≥ 
payments
≥≥ "
)
≥≥" #
;
≥≥# $
}
¥¥ 
catch
µµ 
(
µµ 
	Exception
µµ 
ex
µµ 
)
µµ  
{
∂∂ 
return
∑∑ 

StatusCode
∑∑ !
(
∑∑! "
$num
∑∑" %
,
∑∑% &
new
∑∑' *
{
∑∑+ ,
message
∑∑- 4
=
∑∑5 6
$"
∑∑7 9
$str
∑∑9 S
{
∑∑S T
ex
∑∑T V
.
∑∑V W
Message
∑∑W ^
}
∑∑^ _
"
∑∑_ `
}
∑∑a b
)
∑∑b c
;
∑∑c d
}
∏∏ 
}
ππ 	
[
ªª 	
HttpPut
ªª	 
(
ªª 
$str
ªª *
)
ªª* +
]
ªª+ ,
public
ºº 
async
ºº 
Task
ºº 
<
ºº 
IActionResult
ºº '
>
ºº' ($
UpdateSubscriptionName
ºº) ?
(
ºº? @
int
ºº@ C
id
ººD F
,
ººF G
[
ººH I
FromBody
ººI Q
]
ººQ R
UpdateNameRequest
ººS d
request
ººe l
)
ººl m
{
ΩΩ 	
var
ææ 
userId
ææ 
=
ææ 
User
ææ 
.
ææ 
	FindFirst
ææ '
(
ææ' (
System
ææ( .
.
ææ. /
Security
ææ/ 7
.
ææ7 8
Claims
ææ8 >
.
ææ> ?

ClaimTypes
ææ? I
.
ææI J
NameIdentifier
ææJ X
)
ææX Y
?
ææY Z
.
ææZ [
Value
ææ[ `
;
ææ` a
var
øø 
subscription
øø 
=
øø 
await
øø $
_context
øø% -
.
øø- .
Subscriptions
øø. ;
.
øø; <!
FirstOrDefaultAsync
øø< O
(
øøO P
s
øøP Q
=>
øøR T
s
øøU V
.
øøV W
SubscriptionID
øøW e
==
øøf h
id
øøi k
&&
øøl n
s
øøo p
.
øøp q
UserID
øøq w
==
øøx z
userIdøø{ Å
)øøÅ Ç
;øøÇ É
if
¿¿ 
(
¿¿ 
subscription
¿¿ 
==
¿¿ 
null
¿¿  $
)
¿¿$ %
return
¿¿& ,
NotFound
¿¿- 5
(
¿¿5 6
)
¿¿6 7
;
¿¿7 8
subscription
¬¬ 
.
¬¬ 

DeviceName
¬¬ #
=
¬¬$ %
request
¬¬& -
.
¬¬- .

DeviceName
¬¬. 8
;
¬¬8 9
await
√√ 
_context
√√ 
.
√√ 
SaveChangesAsync
√√ +
(
√√+ ,
)
√√, -
;
√√- .
return
ƒƒ 
Ok
ƒƒ 
(
ƒƒ 
new
ƒƒ 
{
ƒƒ 
message
ƒƒ #
=
ƒƒ$ %
$str
ƒƒ& ;
}
ƒƒ< =
)
ƒƒ= >
;
ƒƒ> ?
}
≈≈ 	
[
«« 	
HttpPost
««	 
(
«« 
$str
««  
)
««  !
]
««! "
public
»» 
async
»» 
Task
»» 
<
»» 
IActionResult
»» '
>
»»' (
UpgradePlan
»») 4
(
»»4 5
[
»»5 6
FromBody
»»6 >
]
»»> ? 
UpgradePlanRequest
»»@ R
request
»»S Z
)
»»Z [
{
…… 	
var
   
userId
   
=
   
User
   
.
   
	FindFirst
   '
(
  ' (
System
  ( .
.
  . /
Security
  / 7
.
  7 8
Claims
  8 >
.
  > ?

ClaimTypes
  ? I
.
  I J
NameIdentifier
  J X
)
  X Y
?
  Y Z
.
  Z [
Value
  [ `
;
  ` a
var
ÀÀ 
user
ÀÀ 
=
ÀÀ 
await
ÀÀ 
_userManager
ÀÀ )
.
ÀÀ) *
FindByIdAsync
ÀÀ* 7
(
ÀÀ7 8
userId
ÀÀ8 >
!
ÀÀ> ?
)
ÀÀ? @
;
ÀÀ@ A
var
ÃÃ 
subscription
ÃÃ 
=
ÃÃ 
await
ÃÃ $
_context
ÃÃ% -
.
ÃÃ- .
Subscriptions
ÃÃ. ;
.
ÕÕ 
Include
ÕÕ 
(
ÕÕ 
s
ÕÕ 
=>
ÕÕ 
s
ÕÕ 
.
ÕÕ  
Plan
ÕÕ  $
)
ÕÕ$ %
.
ŒŒ !
FirstOrDefaultAsync
ŒŒ $
(
ŒŒ$ %
s
ŒŒ% &
=>
ŒŒ' )
s
ŒŒ* +
.
ŒŒ+ ,
SubscriptionID
ŒŒ, :
==
ŒŒ; =
request
ŒŒ> E
.
ŒŒE F
SubscriptionId
ŒŒF T
&&
ŒŒU W
s
ŒŒX Y
.
ŒŒY Z
UserID
ŒŒZ `
==
ŒŒa c
userId
ŒŒd j
)
ŒŒj k
;
ŒŒk l
if
œœ 
(
œœ 
subscription
œœ 
==
œœ 
null
œœ  $
)
œœ$ %
return
œœ& ,
NotFound
œœ- 5
(
œœ5 6
new
œœ6 9
{
œœ: ;
message
œœ< C
=
œœD E
$"
œœF H
$str
œœH V
{
œœV W
request
œœW ^
.
œœ^ _
SubscriptionId
œœ_ m
}
œœm n
$strœœn â
"œœâ ä
}œœã å
)œœå ç
;œœç é
var
—— 
oldPlan
—— 
=
—— 
subscription
—— &
.
——& '
Plan
——' +
;
——+ ,
var
““ 
newPlan
““ 
=
““ 
await
““ 
_context
““  (
.
““( )
SubscriptionPlans
““) :
.
““: ;
	FindAsync
““; D
(
““D E
request
““E L
.
““L M
	NewPlanId
““M V
)
““V W
;
““W X
if
”” 
(
”” 
newPlan
”” 
==
”” 
null
”” 
)
””  
return
””! '
NotFound
””( 0
(
””0 1
new
””1 4
{
””5 6
message
””7 >
=
””? @
$str
””A Q
}
””R S
)
””S T
;
””T U
var
’’ 

planChange
’’ 
=
’’ 
(
’’ 
oldPlan
’’ %
.
’’% &
	SpeedMbps
’’& /
??
’’0 2
$num
’’3 4
)
’’4 5
<
’’6 7
(
’’8 9
newPlan
’’9 @
.
’’@ A
	SpeedMbps
’’A J
??
’’K M
$num
’’N O
)
’’O P
?
’’Q R
$str
’’S ]
:
’’^ _
$str
’’` l
;
’’l m
subscription
÷÷ 
.
÷÷ 
PlanID
÷÷ 
=
÷÷  !
request
÷÷" )
.
÷÷) *
	NewPlanId
÷÷* 3
;
÷÷3 4
await
◊◊ 
_context
◊◊ 
.
◊◊ 
SaveChangesAsync
◊◊ +
(
◊◊+ ,
)
◊◊, -
;
◊◊- .
var
ŸŸ 
planPref
ŸŸ 
=
ŸŸ 
await
ŸŸ  
_context
ŸŸ! )
.
ŸŸ) *%
NotificationPreferences
ŸŸ* A
.
⁄⁄ !
FirstOrDefaultAsync
⁄⁄ $
(
⁄⁄$ %
np
⁄⁄% '
=>
⁄⁄( *
np
⁄⁄+ -
.
⁄⁄- .
UserID
⁄⁄. 4
==
⁄⁄5 7
userId
⁄⁄8 >
&&
⁄⁄? A
np
⁄⁄B D
.
⁄⁄D E
NotificationType
⁄⁄E U
==
⁄⁄V X
$str
⁄⁄Y f
)
⁄⁄f g
;
⁄⁄g h
if
€€ 
(
€€ 
planPref
€€ 
?
€€ 
.
€€ 
EmailEnabled
€€ &
!=
€€' )
false
€€* /
)
€€/ 0
{
‹‹ 
try
›› 
{
ﬁﬁ 
Console
ﬂﬂ 
.
ﬂﬂ 
	WriteLine
ﬂﬂ %
(
ﬂﬂ% &
$"
ﬂﬂ& (
$str
ﬂﬂ( 9
{
ﬂﬂ9 :
user
ﬂﬂ: >
!
ﬂﬂ> ?
.
ﬂﬂ? @
Email
ﬂﬂ@ E
}
ﬂﬂE F
$str
ﬂﬂF P
{
ﬂﬂP Q

planChange
ﬂﬂQ [
}
ﬂﬂ[ \
"
ﬂﬂ\ ]
)
ﬂﬂ] ^
;
ﬂﬂ^ _
await
‡‡ 
_emailService
‡‡ '
.
‡‡' (
SendEmailAsync
‡‡( 6
(
‡‡6 7
user
·· 
!
·· 
.
·· 
Email
·· #
!
··# $
,
··$ %
$"
‚‚ 
$str
‚‚ 
{
‚‚  

planChange
‚‚  *
.
‚‚* +
ToUpper
‚‚+ 2
(
‚‚2 3
)
‚‚3 4
}
‚‚4 5
$str
‚‚5 F
"
‚‚F G
,
‚‚G H
$"
„„ 
$str
„„  
{
„„  !
user
„„! %
.
„„% &
	FirstName
„„& /
}
„„/ 0
$str
„„0 L
{
„„L M

planChange
„„M W
}
„„W X
$str
„„X f
{
„„f g
oldPlan
„„g n
.
„„n o
PlanName
„„o w
}
„„w x
$str„„x ç
{„„ç é
newPlan„„é ï
.„„ï ñ
PlanName„„ñ û
}„„û ü
$str„„ü ◊
"„„◊ ÿ
)
‰‰ 
;
‰‰ 
Console
ÂÂ 
.
ÂÂ 
	WriteLine
ÂÂ %
(
ÂÂ% &
$str
ÂÂ& @
)
ÂÂ@ A
;
ÂÂA B
}
ÊÊ 
catch
ÁÁ 
(
ÁÁ 
	Exception
ÁÁ  
ex
ÁÁ! #
)
ÁÁ# $
{
ËË 
Console
ÈÈ 
.
ÈÈ 
	WriteLine
ÈÈ %
(
ÈÈ% &
$"
ÈÈ& (
$str
ÈÈ( J
{
ÈÈJ K
ex
ÈÈK M
.
ÈÈM N
Message
ÈÈN U
}
ÈÈU V
"
ÈÈV W
)
ÈÈW X
;
ÈÈX Y
}
ÍÍ 
}
ÎÎ 
return
ÌÌ 
Ok
ÌÌ 
(
ÌÌ 
new
ÌÌ 
{
ÌÌ 
message
ÌÌ #
=
ÌÌ$ %
$"
ÌÌ& (
$str
ÌÌ( -
{
ÌÌ- .

planChange
ÌÌ. 8
}
ÌÌ8 9
$str
ÌÌ9 F
"
ÌÌF G
}
ÌÌH I
)
ÌÌI J
;
ÌÌJ K
}
ÓÓ 	
[
 	
HttpPost
	 
(
 
$str
 )
)
) *
]
* +
public
ÒÒ 
async
ÒÒ 
Task
ÒÒ 
<
ÒÒ 
IActionResult
ÒÒ '
>
ÒÒ' (!
CreatePaymentIntent
ÒÒ) <
(
ÒÒ< =
[
ÒÒ= >
FromBody
ÒÒ> F
]
ÒÒF G(
CreatePaymentIntentRequest
ÒÒH b
request
ÒÒc j
)
ÒÒj k
{
ÚÚ 	
var
ÛÛ 
userId
ÛÛ 
=
ÛÛ 
User
ÛÛ 
.
ÛÛ 
	FindFirst
ÛÛ '
(
ÛÛ' (
System
ÛÛ( .
.
ÛÛ. /
Security
ÛÛ/ 7
.
ÛÛ7 8
Claims
ÛÛ8 >
.
ÛÛ> ?

ClaimTypes
ÛÛ? I
.
ÛÛI J
NameIdentifier
ÛÛJ X
)
ÛÛX Y
?
ÛÛY Z
.
ÛÛZ [
Value
ÛÛ[ `
;
ÛÛ` a
var
ÙÙ 
invoice
ÙÙ 
=
ÙÙ 
await
ÙÙ 
_context
ÙÙ  (
.
ÙÙ( )
Invoices
ÙÙ) 1
.
ÙÙ1 2!
FirstOrDefaultAsync
ÙÙ2 E
(
ÙÙE F
i
ÙÙF G
=>
ÙÙH J
i
ÙÙK L
.
ÙÙL M
	InvoiceID
ÙÙM V
==
ÙÙW Y
request
ÙÙZ a
.
ÙÙa b
	InvoiceId
ÙÙb k
&&
ÙÙl n
i
ÙÙo p
.
ÙÙp q
UserID
ÙÙq w
==
ÙÙx z
userIdÙÙ{ Å
)ÙÙÅ Ç
;ÙÙÇ É
if
ıı 
(
ıı 
invoice
ıı 
==
ıı 
null
ıı 
)
ıı  
return
ıı! '
NotFound
ıı( 0
(
ıı0 1
new
ıı1 4
{
ıı5 6
message
ıı7 >
=
ıı? @
$str
ııA T
}
ııU V
)
ııV W
;
ııW X
var
˜˜ 
paymentIntentId
˜˜ 
=
˜˜  !
await
˜˜" '
_payMongoService
˜˜( 8
.
˜˜8 9!
CreatePaymentIntent
˜˜9 L
(
˜˜L M
invoice
˜˜M T
.
˜˜T U
Amount
˜˜U [
,
˜˜[ \
$"
˜˜] _
$str
˜˜_ h
{
˜˜h i
invoice
˜˜i p
.
˜˜p q
	InvoiceID
˜˜q z
}
˜˜z {
"
˜˜{ |
)
˜˜| }
;
˜˜} ~
return
¯¯ 
Ok
¯¯ 
(
¯¯ 
new
¯¯ 
{
¯¯ 
paymentIntentId
¯¯ +
,
¯¯+ ,
amount
¯¯- 3
=
¯¯4 5
invoice
¯¯6 =
.
¯¯= >
Amount
¯¯> D
}
¯¯E F
)
¯¯F G
;
¯¯G H
}
˘˘ 	
[
˚˚ 	
HttpPost
˚˚	 
(
˚˚ 
$str
˚˚ '
)
˚˚' (
]
˚˚( )
public
¸¸ 
async
¸¸ 
Task
¸¸ 
<
¸¸ 
IActionResult
¸¸ '
>
¸¸' (
SavePaymentMethod
¸¸) :
(
¸¸: ;
[
¸¸; <
FromBody
¸¸< D
]
¸¸D E&
SavePaymentMethodRequest
¸¸F ^
request
¸¸_ f
)
¸¸f g
{
˝˝ 	
var
˛˛ 
userId
˛˛ 
=
˛˛ 
User
˛˛ 
.
˛˛ 
	FindFirst
˛˛ '
(
˛˛' (
System
˛˛( .
.
˛˛. /
Security
˛˛/ 7
.
˛˛7 8
Claims
˛˛8 >
.
˛˛> ?

ClaimTypes
˛˛? I
.
˛˛I J
NameIdentifier
˛˛J X
)
˛˛X Y
?
˛˛Y Z
.
˛˛Z [
Value
˛˛[ `
;
˛˛` a
var
ˇˇ 
details
ˇˇ 
=
ˇˇ 
new
ˇˇ 
PaymentDetails
ˇˇ ,
{
ÄÄ 

CardNumber
ÅÅ 
=
ÅÅ 
request
ÅÅ $
.
ÅÅ$ %

CardNumber
ÅÅ% /
,
ÅÅ/ 0
ExpMonth
ÇÇ 
=
ÇÇ 
request
ÇÇ "
.
ÇÇ" #
ExpMonth
ÇÇ# +
,
ÇÇ+ ,
ExpYear
ÉÉ 
=
ÉÉ 
request
ÉÉ !
.
ÉÉ! "
ExpYear
ÉÉ" )
,
ÉÉ) *
Cvc
ÑÑ 
=
ÑÑ 
request
ÑÑ 
.
ÑÑ 
Cvc
ÑÑ !
}
ÖÖ 
;
ÖÖ 
var
ÜÜ 
paymentMethodId
ÜÜ 
=
ÜÜ  !
await
ÜÜ" '
_payMongoService
ÜÜ( 8
.
ÜÜ8 9!
CreatePaymentMethod
ÜÜ9 L
(
ÜÜL M
$str
ÜÜM S
,
ÜÜS T
details
ÜÜU \
)
ÜÜ\ ]
;
ÜÜ] ^
if
àà 
(
àà 
request
àà 
.
àà 
	IsDefault
àà !
)
àà! "
{
ââ 
var
ää 
existingMethods
ää #
=
ää$ %
await
ää& +
_context
ää, 4
.
ää4 5!
SavedPaymentMethods
ää5 H
.
ääH I
Where
ääI N
(
ääN O
pm
ääO Q
=>
ääR T
pm
ääU W
.
ääW X
UserID
ääX ^
==
ää_ a
userId
ääb h
)
ääh i
.
ääi j
ToListAsync
ääj u
(
ääu v
)
ääv w
;
ääw x
foreach
ãã 
(
ãã 
var
ãã 
method
ãã #
in
ãã$ &
existingMethods
ãã' 6
)
ãã6 7
method
ãã8 >
.
ãã> ?
	IsDefault
ãã? H
=
ããI J
false
ããK P
;
ããP Q
}
åå 
var
éé 
savedMethod
éé 
=
éé 
new
éé ! 
SavedPaymentMethod
éé" 4
{
èè 
UserID
êê 
=
êê 
userId
êê 
!
êê  
,
êê  !%
PayMongoPaymentMethodId
ëë '
=
ëë( )
paymentMethodId
ëë* 9
,
ëë9 :
Type
íí 
=
íí 
$str
íí 
,
íí 
Last4
ìì 
=
ìì 
request
ìì 
.
ìì  

CardNumber
ìì  *
.
ìì* +
	Substring
ìì+ 4
(
ìì4 5
request
ìì5 <
.
ìì< =

CardNumber
ìì= G
.
ììG H
Length
ììH N
-
ììO P
$num
ììQ R
)
ììR S
,
ììS T
Brand
îî 
=
îî 
$str
îî 
,
îî 
ExpMonth
ïï 
=
ïï 
request
ïï "
.
ïï" #
ExpMonth
ïï# +
,
ïï+ ,
ExpYear
ññ 
=
ññ 
request
ññ !
.
ññ! "
ExpYear
ññ" )
,
ññ) *
	IsDefault
óó 
=
óó 
request
óó #
.
óó# $
	IsDefault
óó$ -
}
òò 
;
òò 
_context
ôô 
.
ôô !
SavedPaymentMethods
ôô (
.
ôô( )
Add
ôô) ,
(
ôô, -
savedMethod
ôô- 8
)
ôô8 9
;
ôô9 :
await
öö 
_context
öö 
.
öö 
SaveChangesAsync
öö +
(
öö+ ,
)
öö, -
;
öö- .
return
úú 
Ok
úú 
(
úú 
new
úú 
{
úú 
message
úú #
=
úú$ %
$str
úú& I
,
úúI J
paymentMethodId
úúK Z
=
úú[ \
savedMethod
úú] h
.
úúh i
PaymentMethodID
úúi x
}
úúy z
)
úúz {
;
úú{ |
}
ùù 	
[
üü 	
HttpPost
üü	 
(
üü 
$str
üü %
)
üü% &
]
üü& '
public
†† 
async
†† 
Task
†† 
<
†† 
IActionResult
†† '
>
††' (
SaveGCashMethod
††) 8
(
††8 9
[
††9 :
FromBody
††: B
]
††B C$
SaveGCashMethodRequest
††D Z
request
††[ b
)
††b c
{
°° 	
var
¢¢ 
userId
¢¢ 
=
¢¢ 
User
¢¢ 
.
¢¢ 
	FindFirst
¢¢ '
(
¢¢' (
System
¢¢( .
.
¢¢. /
Security
¢¢/ 7
.
¢¢7 8
Claims
¢¢8 >
.
¢¢> ?

ClaimTypes
¢¢? I
.
¢¢I J
NameIdentifier
¢¢J X
)
¢¢X Y
?
¢¢Y Z
.
¢¢Z [
Value
¢¢[ `
;
¢¢` a
if
•• 
(
•• 
request
•• 
.
•• 
	IsDefault
•• !
)
••! "
{
¶¶ 
var
ßß 
existingMethods
ßß #
=
ßß$ %
await
ßß& +
_context
ßß, 4
.
ßß4 5!
SavedPaymentMethods
ßß5 H
.
ßßH I
Where
ßßI N
(
ßßN O
pm
ßßO Q
=>
ßßR T
pm
ßßU W
.
ßßW X
UserID
ßßX ^
==
ßß_ a
userId
ßßb h
)
ßßh i
.
ßßi j
ToListAsync
ßßj u
(
ßßu v
)
ßßv w
;
ßßw x
foreach
®® 
(
®® 
var
®® 
method
®® #
in
®®$ &
existingMethods
®®' 6
)
®®6 7
method
®®8 >
.
®®> ?
	IsDefault
®®? H
=
®®I J
false
®®K P
;
®®P Q
}
©© 
var
´´ 
savedMethod
´´ 
=
´´ 
new
´´ ! 
SavedPaymentMethod
´´" 4
{
¨¨ 
UserID
≠≠ 
=
≠≠ 
userId
≠≠ 
!
≠≠  
,
≠≠  !%
PayMongoPaymentMethodId
ÆÆ '
=
ÆÆ( )
$str
ÆÆ* 2
+
ÆÆ3 4
Guid
ÆÆ5 9
.
ÆÆ9 :
NewGuid
ÆÆ: A
(
ÆÆA B
)
ÆÆB C
.
ÆÆC D
ToString
ÆÆD L
(
ÆÆL M
)
ÆÆM N
,
ÆÆN O
Type
ØØ 
=
ØØ 
$str
ØØ 
,
ØØ 
Last4
∞∞ 
=
∞∞ 
request
∞∞ 
.
∞∞  
PhoneNumber
∞∞  +
,
∞∞+ ,
	IsDefault
±± 
=
±± 
request
±± #
.
±±# $
	IsDefault
±±$ -
}
≤≤ 
;
≤≤ 
_context
≥≥ 
.
≥≥ !
SavedPaymentMethods
≥≥ (
.
≥≥( )
Add
≥≥) ,
(
≥≥, -
savedMethod
≥≥- 8
)
≥≥8 9
;
≥≥9 :
await
¥¥ 
_context
¥¥ 
.
¥¥ 
SaveChangesAsync
¥¥ +
(
¥¥+ ,
)
¥¥, -
;
¥¥- .
return
∂∂ 
Ok
∂∂ 
(
∂∂ 
new
∂∂ 
{
∂∂ 
message
∂∂ #
=
∂∂$ %
$str
∂∂& G
,
∂∂G H
paymentMethodId
∂∂I X
=
∂∂Y Z
savedMethod
∂∂[ f
.
∂∂f g
PaymentMethodID
∂∂g v
}
∂∂w x
)
∂∂x y
;
∂∂y z
}
∑∑ 	
[
ππ 	
HttpGet
ππ	 
(
ππ 
$str
ππ "
)
ππ" #
]
ππ# $
public
∫∫ 
async
∫∫ 
Task
∫∫ 
<
∫∫ 
IActionResult
∫∫ '
>
∫∫' (
GetPaymentMethods
∫∫) :
(
∫∫: ;
)
∫∫; <
{
ªª 	
var
ºº 
userId
ºº 
=
ºº 
User
ºº 
.
ºº 
	FindFirst
ºº '
(
ºº' (
System
ºº( .
.
ºº. /
Security
ºº/ 7
.
ºº7 8
Claims
ºº8 >
.
ºº> ?

ClaimTypes
ºº? I
.
ººI J
NameIdentifier
ººJ X
)
ººX Y
?
ººY Z
.
ººZ [
Value
ºº[ `
;
ºº` a
var
ΩΩ 
methods
ΩΩ 
=
ΩΩ 
await
ΩΩ 
_context
ΩΩ  (
.
ΩΩ( )!
SavedPaymentMethods
ΩΩ) <
.
ΩΩ< =
Where
ΩΩ= B
(
ΩΩB C
pm
ΩΩC E
=>
ΩΩF H
pm
ΩΩI K
.
ΩΩK L
UserID
ΩΩL R
==
ΩΩS U
userId
ΩΩV \
)
ΩΩ\ ]
.
ΩΩ] ^
ToListAsync
ΩΩ^ i
(
ΩΩi j
)
ΩΩj k
;
ΩΩk l
return
ææ 
Ok
ææ 
(
ææ 
methods
ææ 
)
ææ 
;
ææ 
}
øø 	
[
¡¡ 	

HttpDelete
¡¡	 
(
¡¡ 
$str
¡¡ *
)
¡¡* +
]
¡¡+ ,
public
¬¬ 
async
¬¬ 
Task
¬¬ 
<
¬¬ 
IActionResult
¬¬ '
>
¬¬' (!
DeletePaymentMethod
¬¬) <
(
¬¬< =
int
¬¬= @
id
¬¬A C
)
¬¬C D
{
√√ 	
var
ƒƒ 
userId
ƒƒ 
=
ƒƒ 
User
ƒƒ 
.
ƒƒ 
	FindFirst
ƒƒ '
(
ƒƒ' (
System
ƒƒ( .
.
ƒƒ. /
Security
ƒƒ/ 7
.
ƒƒ7 8
Claims
ƒƒ8 >
.
ƒƒ> ?

ClaimTypes
ƒƒ? I
.
ƒƒI J
NameIdentifier
ƒƒJ X
)
ƒƒX Y
?
ƒƒY Z
.
ƒƒZ [
Value
ƒƒ[ `
;
ƒƒ` a
var
≈≈ 
method
≈≈ 
=
≈≈ 
await
≈≈ 
_context
≈≈ '
.
≈≈' (!
SavedPaymentMethods
≈≈( ;
.
≈≈; <!
FirstOrDefaultAsync
≈≈< O
(
≈≈O P
pm
≈≈P R
=>
≈≈S U
pm
≈≈V X
.
≈≈X Y
PaymentMethodID
≈≈Y h
==
≈≈i k
id
≈≈l n
&&
≈≈o q
pm
≈≈r t
.
≈≈t u
UserID
≈≈u {
==
≈≈| ~
userId≈≈ Ö
)≈≈Ö Ü
;≈≈Ü á
if
∆∆ 
(
∆∆ 
method
∆∆ 
==
∆∆ 
null
∆∆ 
)
∆∆ 
return
∆∆  &
NotFound
∆∆' /
(
∆∆/ 0
)
∆∆0 1
;
∆∆1 2
_context
»» 
.
»» !
SavedPaymentMethods
»» (
.
»»( )
Remove
»») /
(
»»/ 0
method
»»0 6
)
»»6 7
;
»»7 8
await
…… 
_context
…… 
.
…… 
SaveChangesAsync
…… +
(
……+ ,
)
……, -
;
……- .
return
   
Ok
   
(
   
new
   
{
   
message
   #
=
  $ %
$str
  & >
}
  ? @
)
  @ A
;
  A B
}
ÀÀ 	
[
ÕÕ 	
HttpPut
ÕÕ	 
(
ÕÕ 
$str
ÕÕ /
)
ÕÕ/ 0
]
ÕÕ0 1
public
ŒŒ 
async
ŒŒ 
Task
ŒŒ 
<
ŒŒ 
IActionResult
ŒŒ '
>
ŒŒ' (%
SetDefaultPaymentMethod
ŒŒ) @
(
ŒŒ@ A
int
ŒŒA D
id
ŒŒE G
)
ŒŒG H
{
œœ 	
var
–– 
userId
–– 
=
–– 
User
–– 
.
–– 
	FindFirst
–– '
(
––' (
System
––( .
.
––. /
Security
––/ 7
.
––7 8
Claims
––8 >
.
––> ?

ClaimTypes
––? I
.
––I J
NameIdentifier
––J X
)
––X Y
?
––Y Z
.
––Z [
Value
––[ `
;
––` a
var
—— 
methods
—— 
=
—— 
await
—— 
_context
——  (
.
——( )!
SavedPaymentMethods
——) <
.
——< =
Where
——= B
(
——B C
pm
——C E
=>
——F H
pm
——I K
.
——K L
UserID
——L R
==
——S U
userId
——V \
)
——\ ]
.
——] ^
ToListAsync
——^ i
(
——i j
)
——j k
;
——k l
foreach
““ 
(
““ 
var
““ 
method
““ 
in
““  "
methods
““# *
)
““* +
method
““, 2
.
““2 3
	IsDefault
““3 <
=
““= >
method
““? E
.
““E F
PaymentMethodID
““F U
==
““V X
id
““Y [
;
““[ \
await
”” 
_context
”” 
.
”” 
SaveChangesAsync
”” +
(
””+ ,
)
””, -
;
””- .
return
‘‘ 
Ok
‘‘ 
(
‘‘ 
new
‘‘ 
{
‘‘ 
message
‘‘ #
=
‘‘$ %
$str
‘‘& F
}
‘‘G H
)
‘‘H I
;
‘‘I J
}
’’ 	
[
◊◊ 	
HttpPost
◊◊	 
(
◊◊ 
$str
◊◊ #
)
◊◊# $
]
◊◊$ %
public
ÿÿ 
async
ÿÿ 
Task
ÿÿ 
<
ÿÿ 
IActionResult
ÿÿ '
>
ÿÿ' (
ProcessPayment
ÿÿ) 7
(
ÿÿ7 8
[
ÿÿ8 9
FromBody
ÿÿ9 A
]
ÿÿA B#
ProcessPaymentRequest
ÿÿC X
request
ÿÿY `
)
ÿÿ` a
{
ŸŸ 	
var
⁄⁄ 
userId
⁄⁄ 
=
⁄⁄ 
User
⁄⁄ 
.
⁄⁄ 
	FindFirst
⁄⁄ '
(
⁄⁄' (
System
⁄⁄( .
.
⁄⁄. /
Security
⁄⁄/ 7
.
⁄⁄7 8
Claims
⁄⁄8 >
.
⁄⁄> ?

ClaimTypes
⁄⁄? I
.
⁄⁄I J
NameIdentifier
⁄⁄J X
)
⁄⁄X Y
?
⁄⁄Y Z
.
⁄⁄Z [
Value
⁄⁄[ `
;
⁄⁄` a
var
€€ 
invoice
€€ 
=
€€ 
await
€€ 
_context
€€  (
.
€€( )
Invoices
€€) 1
.
€€1 2!
FirstOrDefaultAsync
€€2 E
(
€€E F
i
€€F G
=>
€€H J
i
€€K L
.
€€L M
	InvoiceID
€€M V
==
€€W Y
request
€€Z a
.
€€a b
	InvoiceId
€€b k
&&
€€l n
i
€€o p
.
€€p q
UserID
€€q w
==
€€x z
userId€€{ Å
)€€Å Ç
;€€Ç É
if
‹‹ 
(
‹‹ 
invoice
‹‹ 
==
‹‹ 
null
‹‹ 
)
‹‹  
return
‹‹! '
NotFound
‹‹( 0
(
‹‹0 1
new
‹‹1 4
{
‹‹5 6
message
‹‹7 >
=
‹‹? @
$str
‹‹A T
}
‹‹U V
)
‹‹V W
;
‹‹W X
if
›› 
(
›› 
invoice
›› 
.
›› 
Status
›› 
!=
›› !
$str
››" +
)
››+ ,
return
››- 3

BadRequest
››4 >
(
››> ?
new
››? B
{
››C D
message
››E L
=
››M N
$str
››O g
}
››h i
)
››i j
;
››j k
var
‡‡ 
completedPayment
‡‡  
=
‡‡! "
await
‡‡# (
_context
‡‡) 1
.
‡‡1 2
Payments
‡‡2 :
.
‡‡: ;!
FirstOrDefaultAsync
‡‡; N
(
‡‡N O
p
‡‡O P
=>
‡‡Q S
p
‡‡T U
.
‡‡U V
	InvoiceID
‡‡V _
==
‡‡` b
request
‡‡c j
.
‡‡j k
	InvoiceId
‡‡k t
&&
‡‡u w
p
‡‡x y
.
‡‡y z
Status‡‡z Ä
==‡‡Å É
$str‡‡Ñ è
)‡‡è ê
;‡‡ê ë
if
·· 
(
·· 
completedPayment
··  
!=
··! #
null
··$ (
)
··( )
return
··* 0

BadRequest
··1 ;
(
··; <
new
··< ?
{
··@ A
message
··B I
=
··J K
$str
··L p
}
··q r
)
··r s
;
··s t
var
‰‰ 
stalePending
‰‰ 
=
‰‰ 
await
‰‰ $
_context
‰‰% -
.
‰‰- .
Payments
‰‰. 6
.
‰‰6 7!
FirstOrDefaultAsync
‰‰7 J
(
‰‰J K
p
‰‰K L
=>
‰‰M O
p
‰‰P Q
.
‰‰Q R
	InvoiceID
‰‰R [
==
‰‰\ ^
request
‰‰_ f
.
‰‰f g
	InvoiceId
‰‰g p
&&
‰‰q s
p
‰‰t u
.
‰‰u v
Status
‰‰v |
==
‰‰} 
$str‰‰Ä â
)‰‰â ä
;‰‰ä ã
if
ÂÂ 
(
ÂÂ 
stalePending
ÂÂ 
!=
ÂÂ 
null
ÂÂ  $
)
ÂÂ$ %
_context
ÂÂ& .
.
ÂÂ. /
Payments
ÂÂ/ 7
.
ÂÂ7 8
Remove
ÂÂ8 >
(
ÂÂ> ?
stalePending
ÂÂ? K
)
ÂÂK L
;
ÂÂL M
var
ËË 
(
ËË 
sourceId
ËË 
,
ËË 
checkoutUrl
ËË &
)
ËË& '
=
ËË( )
await
ËË* /
_payMongoService
ËË0 @
.
ËË@ A
CreateSource
ËËA M
(
ËËM N
invoice
ËËN U
.
ËËU V
Amount
ËËV \
,
ËË\ ]
$"
ËË^ `
$str
ËË` i
{
ËËi j
invoice
ËËj q
.
ËËq r
	InvoiceID
ËËr {
}
ËË{ |
"
ËË| }
)
ËË} ~
;
ËË~ 
var
ÎÎ 
payment
ÎÎ 
=
ÎÎ 
new
ÎÎ 
Payment
ÎÎ %
{
ÏÏ 
UserID
ÌÌ 
=
ÌÌ 
userId
ÌÌ 
!
ÌÌ  
,
ÌÌ  !
	InvoiceID
ÓÓ 
=
ÓÓ 
request
ÓÓ #
.
ÓÓ# $
	InvoiceId
ÓÓ$ -
,
ÓÓ- .

AmountPaid
ÔÔ 
=
ÔÔ 
invoice
ÔÔ $
.
ÔÔ$ %
Amount
ÔÔ% +
,
ÔÔ+ ,
PaymentMethod
 
=
 
$str
  '
,
' (
PaymentDate
ÒÒ 
=
ÒÒ 
DateTime
ÒÒ &
.
ÒÒ& '
UtcNow
ÒÒ' -
,
ÒÒ- .
ReferenceNum
ÚÚ 
=
ÚÚ 
sourceId
ÚÚ '
,
ÚÚ' (
Status
ÛÛ 
=
ÛÛ 
$str
ÛÛ "
}
ÙÙ 
;
ÙÙ 
_context
ıı 
.
ıı 
Payments
ıı 
.
ıı 
Add
ıı !
(
ıı! "
payment
ıı" )
)
ıı) *
;
ıı* +
await
ˆˆ 
_context
ˆˆ 
.
ˆˆ 
SaveChangesAsync
ˆˆ +
(
ˆˆ+ ,
)
ˆˆ, -
;
ˆˆ- .
return
¯¯ 
Ok
¯¯ 
(
¯¯ 
new
¯¯ 
{
¯¯ 
message
¯¯ #
=
¯¯$ %
$str
¯¯& A
,
¯¯A B
	paymentId
¯¯C L
=
¯¯M N
payment
¯¯O V
.
¯¯V W
	PaymentID
¯¯W `
,
¯¯` a
checkoutUrl
¯¯b m
}
¯¯n o
)
¯¯o p
;
¯¯p q
}
˘˘ 	
[
˚˚ 	
HttpPost
˚˚	 
(
˚˚ 
$str
˚˚ .
)
˚˚. /
]
˚˚/ 0
public
¸¸ 
async
¸¸ 
Task
¸¸ 
<
¸¸ 
IActionResult
¸¸ '
>
¸¸' ("
CancelPendingPayment
¸¸) =
(
¸¸= >
int
¸¸> A
	invoiceId
¸¸B K
)
¸¸K L
{
˝˝ 	
var
˛˛ 
userId
˛˛ 
=
˛˛ 
User
˛˛ 
.
˛˛ 
	FindFirst
˛˛ '
(
˛˛' (
System
˛˛( .
.
˛˛. /
Security
˛˛/ 7
.
˛˛7 8
Claims
˛˛8 >
.
˛˛> ?

ClaimTypes
˛˛? I
.
˛˛I J
NameIdentifier
˛˛J X
)
˛˛X Y
?
˛˛Y Z
.
˛˛Z [
Value
˛˛[ `
;
˛˛` a
var
ˇˇ 
payment
ˇˇ 
=
ˇˇ 
await
ˇˇ 
_context
ˇˇ  (
.
ˇˇ( )
Payments
ˇˇ) 1
.
ˇˇ1 2!
FirstOrDefaultAsync
ˇˇ2 E
(
ˇˇE F
p
ˇˇF G
=>
ˇˇH J
p
ˇˇK L
.
ˇˇL M
	InvoiceID
ˇˇM V
==
ˇˇW Y
	invoiceId
ˇˇZ c
&&
ˇˇd f
p
ˇˇg h
.
ˇˇh i
UserID
ˇˇi o
==
ˇˇp r
userId
ˇˇs y
&&
ˇˇz |
p
ˇˇ} ~
.
ˇˇ~ 
Statusˇˇ Ö
==ˇˇÜ à
$strˇˇâ í
)ˇˇí ì
;ˇˇì î
if
ÄÄ 
(
ÄÄ 
payment
ÄÄ 
==
ÄÄ 
null
ÄÄ 
)
ÄÄ  
return
ÄÄ! '
NotFound
ÄÄ( 0
(
ÄÄ0 1
new
ÄÄ1 4
{
ÄÄ5 6
message
ÄÄ7 >
=
ÄÄ? @
$str
ÄÄA [
}
ÄÄ\ ]
)
ÄÄ] ^
;
ÄÄ^ _
_context
ÇÇ 
.
ÇÇ 
Payments
ÇÇ 
.
ÇÇ 
Remove
ÇÇ $
(
ÇÇ$ %
payment
ÇÇ% ,
)
ÇÇ, -
;
ÇÇ- .
await
ÉÉ 
_context
ÉÉ 
.
ÉÉ 
SaveChangesAsync
ÉÉ +
(
ÉÉ+ ,
)
ÉÉ, -
;
ÉÉ- .
return
ÖÖ 
Ok
ÖÖ 
(
ÖÖ 
new
ÖÖ 
{
ÖÖ 
message
ÖÖ #
=
ÖÖ$ %
$str
ÖÖ& 9
}
ÖÖ: ;
)
ÖÖ; <
;
ÖÖ< =
}
ÜÜ 	
[
àà 	
AllowAnonymous
àà	 
]
àà 
[
ââ 	
HttpPost
ââ	 
(
ââ 
$str
ââ $
)
ââ$ %
]
ââ% &
public
ää 
async
ää 
Task
ää 
<
ää 
IActionResult
ää '
>
ää' (
PayMongoWebhook
ää) 8
(
ää8 9
[
ää9 :
FromBody
ää: B
]
ääB C
JsonElement
ääD O
webhookData
ääP [
)
ää[ \
{
ãã 	
try
åå 
{
çç 
var
éé 
	eventType
éé 
=
éé 
webhookData
éé  +
.
éé+ ,
GetProperty
éé, 7
(
éé7 8
$str
éé8 >
)
éé> ?
.
éé? @
GetProperty
éé@ K
(
ééK L
$str
ééL X
)
ééX Y
.
ééY Z
GetProperty
ééZ e
(
éée f
$str
ééf l
)
éél m
.
éém n
	GetString
één w
(
ééw x
)
ééx y
;
ééy z
if
êê 
(
êê 
	eventType
êê 
==
êê  
$str
êê! /
)
êê/ 0
{
ëë 
var
íí 
paymentIntentId
íí '
=
íí( )
webhookData
íí* 5
.
íí5 6
GetProperty
íí6 A
(
ííA B
$str
ííB H
)
ííH I
.
ííI J
GetProperty
ííJ U
(
ííU V
$str
ííV b
)
ííb c
.
ííc d
GetProperty
ííd o
(
íío p
$str
ííp v
)
íív w
.
ííw x
GetPropertyííx É
(ííÉ Ñ
$strííÑ ê
)ííê ë
.ííë í
GetPropertyííí ù
(ííù û
$strííû ±
)íí± ≤
.íí≤ ≥
	GetStringíí≥ º
(ííº Ω
)ííΩ æ
;ííæ ø
var
ìì 
payment
ìì 
=
ìì  !
await
ìì" '
_context
ìì( 0
.
ìì0 1
Payments
ìì1 9
.
ìì9 :
Include
ìì: A
(
ììA B
p
ììB C
=>
ììD F
p
ììG H
.
ììH I
Invoice
ììI P
)
ììP Q
.
ììQ R!
FirstOrDefaultAsync
ììR e
(
ììe f
p
ììf g
=>
ììh j
p
ììk l
.
ììl m
ReferenceNum
ììm y
==
ììz |
paymentIntentIdìì} å
)ììå ç
;ììç é
if
îî 
(
îî 
payment
îî 
!=
îî  "
null
îî# '
)
îî' (
{
ïï 
Console
ññ 
.
ññ  
	WriteLine
ññ  )
(
ññ) *
$"
ññ* ,
$str
ññ, 4
{
ññ4 5
payment
ññ5 <
.
ññ< =
	PaymentID
ññ= F
}
ññF G
$str
ññG ~
"
ññ~ 
)ññ Ä
;ññÄ Å
}
óó 
}
òò 
return
öö 
Ok
öö 
(
öö 
)
öö 
;
öö 
}
õõ 
catch
úú 
(
úú 
	Exception
úú 
ex
úú 
)
úú  
{
ùù 
Console
ûû 
.
ûû 
	WriteLine
ûû !
(
ûû! "
$"
ûû" $
$str
ûû$ 3
{
ûû3 4
ex
ûû4 6
.
ûû6 7
Message
ûû7 >
}
ûû> ?
"
ûû? @
)
ûû@ A
;
ûûA B
return
üü 
Ok
üü 
(
üü 
)
üü 
;
üü 
}
†† 
}
°° 	
[
££ 	
HttpPost
££	 
(
££ 
$str
££ 3
)
££3 4
]
££4 5
public
§§ 
async
§§ 
Task
§§ 
<
§§ 
IActionResult
§§ '
>
§§' (
SyncPaymentStatus
§§) :
(
§§: ;
int
§§; >
	invoiceId
§§? H
)
§§H I
{
•• 	
var
¶¶ 
userId
¶¶ 
=
¶¶ 
User
¶¶ 
.
¶¶ 
	FindFirst
¶¶ '
(
¶¶' (
System
¶¶( .
.
¶¶. /
Security
¶¶/ 7
.
¶¶7 8
Claims
¶¶8 >
.
¶¶> ?

ClaimTypes
¶¶? I
.
¶¶I J
NameIdentifier
¶¶J X
)
¶¶X Y
?
¶¶Y Z
.
¶¶Z [
Value
¶¶[ `
;
¶¶` a
var
ßß 
payment
ßß 
=
ßß 
await
ßß 
_context
ßß  (
.
ßß( )
Payments
ßß) 1
.
ßß1 2
Include
ßß2 9
(
ßß9 :
p
ßß: ;
=>
ßß< >
p
ßß? @
.
ßß@ A
Invoice
ßßA H
)
ßßH I
.
®® !
FirstOrDefaultAsync
®® $
(
®®$ %
p
®®% &
=>
®®' )
p
®®* +
.
®®+ ,
	InvoiceID
®®, 5
==
®®6 8
	invoiceId
®®9 B
&&
®®C E
p
®®F G
.
®®G H
UserID
®®H N
==
®®O Q
userId
®®R X
)
®®X Y
;
®®Y Z
if
™™ 
(
™™ 
payment
™™ 
==
™™ 
null
™™ 
)
™™  
return
™™! '
NotFound
™™( 0
(
™™0 1
new
™™1 4
{
™™5 6
message
™™7 >
=
™™? @
$str
™™A T
}
™™U V
)
™™V W
;
™™W X
if
≠≠ 
(
≠≠ 
payment
≠≠ 
.
≠≠ 
Status
≠≠ 
==
≠≠ !
$str
≠≠" -
)
≠≠- .
return
ÆÆ 
Ok
ÆÆ 
(
ÆÆ 
new
ÆÆ 
{
ÆÆ 
message
ÆÆ  '
=
ÆÆ( )
$str
ÆÆ* G
,
ÆÆG H
status
ÆÆI O
=
ÆÆP Q
$str
ÆÆR ]
}
ÆÆ^ _
)
ÆÆ_ `
;
ÆÆ` a
return
±± 
Ok
±± 
(
±± 
new
±± 
{
±± 
message
±± #
=
±±$ %
$str
±±& W
,
±±W X
status
±±Y _
=
±±` a
payment
±±b i
.
±±i j
Status
±±j p
}
±±q r
)
±±r s
;
±±s t
}
≤≤ 	
[
¥¥ 	
HttpGet
¥¥	 
(
¥¥ 
$str
¥¥ 
)
¥¥ 
]
¥¥ 
public
µµ 
async
µµ 
Task
µµ 
<
µµ 
IActionResult
µµ '
>
µµ' (
	GetAddons
µµ) 2
(
µµ2 3
)
µµ3 4
{
∂∂ 	
var
∑∑ 
addons
∑∑ 
=
∑∑ 
await
∑∑ 
_context
∑∑ '
.
∑∑' (
Addons
∑∑( .
.
∑∑. /
ToListAsync
∑∑/ :
(
∑∑: ;
)
∑∑; <
;
∑∑< =
return
∏∏ 
Ok
∏∏ 
(
∏∏ 
addons
∏∏ 
)
∏∏ 
;
∏∏ 
}
ππ 	
[
ªª 	
HttpGet
ªª	 
(
ªª 
$str
ªª 
)
ªª 
]
ªª  
public
ºº 
async
ºº 
Task
ºº 
<
ºº 
IActionResult
ºº '
>
ºº' (
GetUserAddons
ºº) 6
(
ºº6 7
)
ºº7 8
{
ΩΩ 	
var
ææ 
userId
ææ 
=
ææ 
User
ææ 
.
ææ 
	FindFirst
ææ '
(
ææ' (
System
ææ( .
.
ææ. /
Security
ææ/ 7
.
ææ7 8
Claims
ææ8 >
.
ææ> ?

ClaimTypes
ææ? I
.
ææI J
NameIdentifier
ææJ X
)
ææX Y
?
ææY Z
.
ææZ [
Value
ææ[ `
;
ææ` a
var
øø 

userAddons
øø 
=
øø 
await
øø "
_context
øø# +
.
øø+ ,

UserAddons
øø, 6
.
¿¿ 
Where
¿¿ 
(
¿¿ 
ua
¿¿ 
=>
¿¿ 
ua
¿¿ 
.
¿¿  
UserID
¿¿  &
==
¿¿' )
userId
¿¿* 0
)
¿¿0 1
.
¡¡ 
Select
¡¡ 
(
¡¡ 
ua
¡¡ 
=>
¡¡ 
new
¡¡ !
{
¬¬ 
ua
√√ 
.
√√ 
UserAddonID
√√ "
,
√√" #
ua
ƒƒ 
.
ƒƒ 
AddonID
ƒƒ 
,
ƒƒ 
ua
≈≈ 
.
≈≈ 
ActivatedAt
≈≈ "
,
≈≈" #
ua
∆∆ 
.
∆∆ 
NextBillingDate
∆∆ &
,
∆∆& '
ua
«« 
.
«« 
Status
«« 
,
«« 
Addon
»» 
=
»» 
new
»» 
{
…… 
ua
   
.
   
Addon
    
.
    !
AddonID
  ! (
,
  ( )
ua
ÀÀ 
.
ÀÀ 
Addon
ÀÀ  
.
ÀÀ  !
Name
ÀÀ! %
,
ÀÀ% &
ua
ÃÃ 
.
ÃÃ 
Addon
ÃÃ  
.
ÃÃ  !
Description
ÃÃ! ,
,
ÃÃ, -
ua
ÕÕ 
.
ÕÕ 
Addon
ÕÕ  
.
ÕÕ  !
Price
ÕÕ! &
,
ÕÕ& '
ua
ŒŒ 
.
ŒŒ 
Addon
ŒŒ  
.
ŒŒ  !
BillingType
ŒŒ! ,
,
ŒŒ, -
ua
œœ 
.
œœ 
Addon
œœ  
.
œœ  !
Icon
œœ! %
,
œœ% &
ua
–– 
.
–– 
Addon
––  
.
––  !
Features
––! )
}
—— 
}
““ 
)
““ 
.
”” 
ToListAsync
”” 
(
”” 
)
”” 
;
”” 
return
‘‘ 
Ok
‘‘ 
(
‘‘ 

userAddons
‘‘  
)
‘‘  !
;
‘‘! "
}
’’ 	
[
◊◊ 	
HttpPost
◊◊	 
(
◊◊ 
$str
◊◊ 
)
◊◊ 
]
◊◊ 
public
ÿÿ 
async
ÿÿ 
Task
ÿÿ 
<
ÿÿ 
IActionResult
ÿÿ '
>
ÿÿ' (
AddAddon
ÿÿ) 1
(
ÿÿ1 2
[
ÿÿ2 3
FromBody
ÿÿ3 ;
]
ÿÿ; <
AddAddonRequest
ÿÿ= L
request
ÿÿM T
)
ÿÿT U
{
ŸŸ 	
var
⁄⁄ 
userId
⁄⁄ 
=
⁄⁄ 
User
⁄⁄ 
.
⁄⁄ 
	FindFirst
⁄⁄ '
(
⁄⁄' (
System
⁄⁄( .
.
⁄⁄. /
Security
⁄⁄/ 7
.
⁄⁄7 8
Claims
⁄⁄8 >
.
⁄⁄> ?

ClaimTypes
⁄⁄? I
.
⁄⁄I J
NameIdentifier
⁄⁄J X
)
⁄⁄X Y
?
⁄⁄Y Z
.
⁄⁄Z [
Value
⁄⁄[ `
;
⁄⁄` a
var
€€ 
addon
€€ 
=
€€ 
await
€€ 
_context
€€ &
.
€€& '
Addons
€€' -
.
€€- .
	FindAsync
€€. 7
(
€€7 8
request
€€8 ?
.
€€? @
AddonId
€€@ G
)
€€G H
;
€€H I
if
‹‹ 
(
‹‹ 
addon
‹‹ 
==
‹‹ 
null
‹‹ 
)
‹‹ 
return
‹‹ %
NotFound
‹‹& .
(
‹‹. /
new
‹‹/ 2
{
‹‹3 4
message
‹‹5 <
=
‹‹= >
$str
‹‹? P
}
‹‹Q R
)
‹‹R S
;
‹‹S T
var
ﬁﬁ 
existing
ﬁﬁ 
=
ﬁﬁ 
await
ﬁﬁ  
_context
ﬁﬁ! )
.
ﬁﬁ) *

UserAddons
ﬁﬁ* 4
.
ﬁﬁ4 5!
FirstOrDefaultAsync
ﬁﬁ5 H
(
ﬁﬁH I
ua
ﬁﬁI K
=>
ﬁﬁL N
ua
ﬁﬁO Q
.
ﬁﬁQ R
UserID
ﬁﬁR X
==
ﬁﬁY [
userId
ﬁﬁ\ b
&&
ﬁﬁc e
ua
ﬁﬁf h
.
ﬁﬁh i
AddonID
ﬁﬁi p
==
ﬁﬁq s
request
ﬁﬁt {
.
ﬁﬁ{ |
AddonIdﬁﬁ| É
&&ﬁﬁÑ Ü
uaﬁﬁá â
.ﬁﬁâ ä
Statusﬁﬁä ê
==ﬁﬁë ì
$strﬁﬁî ú
)ﬁﬁú ù
;ﬁﬁù û
if
ﬂﬂ 
(
ﬂﬂ 
existing
ﬂﬂ 
!=
ﬂﬂ 
null
ﬂﬂ  
)
ﬂﬂ  !
return
ﬂﬂ" (

BadRequest
ﬂﬂ) 3
(
ﬂﬂ3 4
new
ﬂﬂ4 7
{
ﬂﬂ8 9
message
ﬂﬂ: A
=
ﬂﬂB C
$str
ﬂﬂD Z
}
ﬂﬂ[ \
)
ﬂﬂ\ ]
;
ﬂﬂ] ^
var
·· 
	userAddon
·· 
=
·· 
new
·· 
	UserAddon
··  )
{
‚‚ 
UserID
„„ 
=
„„ 
userId
„„ 
!
„„  
,
„„  !
AddonID
‰‰ 
=
‰‰ 
request
‰‰ !
.
‰‰! "
AddonId
‰‰" )
,
‰‰) *
NextBillingDate
ÂÂ 
=
ÂÂ  !
addon
ÂÂ" '
.
ÂÂ' (
BillingType
ÂÂ( 3
==
ÂÂ4 6
$str
ÂÂ7 @
?
ÂÂA B
DateTime
ÂÂC K
.
ÂÂK L
UtcNow
ÂÂL R
.
ÂÂR S
	AddMonths
ÂÂS \
(
ÂÂ\ ]
$num
ÂÂ] ^
)
ÂÂ^ _
:
ÂÂ` a
null
ÂÂb f
}
ÊÊ 
;
ÊÊ 
_context
ÁÁ 
.
ÁÁ 

UserAddons
ÁÁ 
.
ÁÁ  
Add
ÁÁ  #
(
ÁÁ# $
	userAddon
ÁÁ$ -
)
ÁÁ- .
;
ÁÁ. /
await
ËË 
_context
ËË 
.
ËË 
SaveChangesAsync
ËË +
(
ËË+ ,
)
ËË, -
;
ËË- .
return
ÍÍ 
Ok
ÍÍ 
(
ÍÍ 
new
ÍÍ 
{
ÍÍ 
message
ÍÍ #
=
ÍÍ$ %
$str
ÍÍ& @
,
ÍÍ@ A
userAddonId
ÍÍB M
=
ÍÍN O
	userAddon
ÍÍP Y
.
ÍÍY Z
UserAddonID
ÍÍZ e
}
ÍÍf g
)
ÍÍg h
;
ÍÍh i
}
ÎÎ 	
[
ÌÌ 	

HttpDelete
ÌÌ	 
(
ÌÌ 
$str
ÌÌ &
)
ÌÌ& '
]
ÌÌ' (
public
ÓÓ 
async
ÓÓ 
Task
ÓÓ 
<
ÓÓ 
IActionResult
ÓÓ '
>
ÓÓ' (
RemoveAddon
ÓÓ) 4
(
ÓÓ4 5
int
ÓÓ5 8
id
ÓÓ9 ;
)
ÓÓ; <
{
ÔÔ 	
var
 
userId
 
=
 
User
 
.
 
	FindFirst
 '
(
' (
System
( .
.
. /
Security
/ 7
.
7 8
Claims
8 >
.
> ?

ClaimTypes
? I
.
I J
NameIdentifier
J X
)
X Y
?
Y Z
.
Z [
Value
[ `
;
` a
var
ÒÒ 
	userAddon
ÒÒ 
=
ÒÒ 
await
ÒÒ !
_context
ÒÒ" *
.
ÒÒ* +

UserAddons
ÒÒ+ 5
.
ÒÒ5 6!
FirstOrDefaultAsync
ÒÒ6 I
(
ÒÒI J
ua
ÒÒJ L
=>
ÒÒM O
ua
ÒÒP R
.
ÒÒR S
UserAddonID
ÒÒS ^
==
ÒÒ_ a
id
ÒÒb d
&&
ÒÒe g
ua
ÒÒh j
.
ÒÒj k
UserID
ÒÒk q
==
ÒÒr t
userId
ÒÒu {
)
ÒÒ{ |
;
ÒÒ| }
if
ÚÚ 
(
ÚÚ 
	userAddon
ÚÚ 
==
ÚÚ 
null
ÚÚ !
)
ÚÚ! "
return
ÚÚ# )
NotFound
ÚÚ* 2
(
ÚÚ2 3
)
ÚÚ3 4
;
ÚÚ4 5
	userAddon
ÙÙ 
.
ÙÙ 
Status
ÙÙ 
=
ÙÙ 
$str
ÙÙ *
;
ÙÙ* +
await
ıı 
_context
ıı 
.
ıı 
SaveChangesAsync
ıı +
(
ıı+ ,
)
ıı, -
;
ıı- .
return
ˆˆ 
Ok
ˆˆ 
(
ˆˆ 
new
ˆˆ 
{
ˆˆ 
message
ˆˆ #
=
ˆˆ$ %
$str
ˆˆ& B
}
ˆˆC D
)
ˆˆD E
;
ˆˆE F
}
˜˜ 	
[
˘˘ 	
HttpPost
˘˘	 
(
˘˘ 
$str
˘˘ $
)
˘˘$ %
]
˘˘% &
public
˙˙ 
async
˙˙ 
Task
˙˙ 
<
˙˙ 
IActionResult
˙˙ '
>
˙˙' (
GenerateInvoice
˙˙) 8
(
˙˙8 9
)
˙˙9 :
{
˚˚ 	
try
¸¸ 
{
˝˝ 
var
˛˛ 
userId
˛˛ 
=
˛˛ 
User
˛˛ !
.
˛˛! "
	FindFirst
˛˛" +
(
˛˛+ ,
System
˛˛, 2
.
˛˛2 3
Security
˛˛3 ;
.
˛˛; <
Claims
˛˛< B
.
˛˛B C

ClaimTypes
˛˛C M
.
˛˛M N
NameIdentifier
˛˛N \
)
˛˛\ ]
?
˛˛] ^
.
˛˛^ _
Value
˛˛_ d
;
˛˛d e
var
ˇˇ 
subscriptions
ˇˇ !
=
ˇˇ" #
await
ˇˇ$ )
_context
ˇˇ* 2
.
ˇˇ2 3
Subscriptions
ˇˇ3 @
.
ÄÄ 
Where
ÄÄ 
(
ÄÄ 
s
ÄÄ 
=>
ÄÄ 
s
ÄÄ  !
.
ÄÄ! "
UserID
ÄÄ" (
==
ÄÄ) +
userId
ÄÄ, 2
&&
ÄÄ3 5
s
ÄÄ6 7
.
ÄÄ7 8
Status
ÄÄ8 >
==
ÄÄ? A
$str
ÄÄB J
)
ÄÄJ K
.
ÅÅ 
Select
ÅÅ 
(
ÅÅ 
s
ÅÅ 
=>
ÅÅ  
new
ÅÅ! $
{
ÅÅ% &
s
ÅÅ' (
.
ÅÅ( )
SubscriptionID
ÅÅ) 7
,
ÅÅ7 8
s
ÅÅ9 :
.
ÅÅ: ;
PlanID
ÅÅ; A
}
ÅÅB C
)
ÅÅC D
.
ÇÇ 
ToListAsync
ÇÇ  
(
ÇÇ  !
)
ÇÇ! "
;
ÇÇ" #
if
ÉÉ 
(
ÉÉ 
subscriptions
ÉÉ !
.
ÉÉ! "
Count
ÉÉ" '
==
ÉÉ( *
$num
ÉÉ+ ,
)
ÉÉ, -
return
ÉÉ. 4
NotFound
ÉÉ5 =
(
ÉÉ= >
new
ÉÉ> A
{
ÉÉB C
message
ÉÉD K
=
ÉÉL M
$str
ÉÉN f
}
ÉÉg h
)
ÉÉh i
;
ÉÉi j
var
ÖÖ 
generatedInvoices
ÖÖ %
=
ÖÖ& '
new
ÖÖ( +
List
ÖÖ, 0
<
ÖÖ0 1
object
ÖÖ1 7
>
ÖÖ7 8
(
ÖÖ8 9
)
ÖÖ9 :
;
ÖÖ: ;
foreach
ÜÜ 
(
ÜÜ 
var
ÜÜ 
subscription
ÜÜ )
in
ÜÜ* ,
subscriptions
ÜÜ- :
)
ÜÜ: ;
{
áá 
var
àà 
existingInvoice
àà '
=
àà( )
await
àà* /
_context
àà0 8
.
àà8 9
Invoices
àà9 A
.
ââ !
FirstOrDefaultAsync
ââ ,
(
ââ, -
i
ââ- .
=>
ââ/ 1
i
ââ2 3
.
ââ3 4
SubscriptionID
ââ4 B
==
ââC E
subscription
ââF R
.
ââR S
SubscriptionID
ââS a
&&
ââb d
i
ââe f
.
ââf g
Status
ââg m
==
âân p
$str
ââq z
)
ââz {
;
ââ{ |
if
ää 
(
ää 
existingInvoice
ää '
!=
ää( *
null
ää+ /
)
ää/ 0
{
ãã 
generatedInvoices
åå )
.
åå) *
Add
åå* -
(
åå- .
new
åå. 1
{
åå2 3
invoice
åå4 ;
=
åå< =
existingInvoice
åå> M
,
ååM N
message
ååO V
=
ååW X
$str
ååY q
}
åår s
)
åås t
;
ååt u
continue
çç  
;
çç  !
}
éé 
var
êê 
plan
êê 
=
êê 
await
êê $
_context
êê% -
.
êê- .
SubscriptionPlans
êê. ?
.
ëë 
Where
ëë 
(
ëë 
p
ëë  
=>
ëë! #
p
ëë$ %
.
ëë% &
PlanID
ëë& ,
==
ëë- /
subscription
ëë0 <
.
ëë< =
PlanID
ëë= C
)
ëëC D
.
íí 
Select
íí 
(
íí  
p
íí  !
=>
íí" $
new
íí% (
{
íí) *
p
íí+ ,
.
íí, -
Price
íí- 2
}
íí3 4
)
íí4 5
.
ìì !
FirstOrDefaultAsync
ìì ,
(
ìì, -
)
ìì- .
;
ìì. /
var
îî 
invoice
îî 
=
îî  !
new
îî" %
Invoice
îî& -
{
ïï 
SubscriptionID
ññ &
=
ññ' (
subscription
ññ) 5
.
ññ5 6
SubscriptionID
ññ6 D
,
ññD E
UserID
óó 
=
óó  
userId
óó! '
!
óó' (
,
óó( )
Amount
òò 
=
òò  
plan
òò! %
?
òò% &
.
òò& '
Price
òò' ,
??
òò- /
$num
òò0 8
,
òò8 9
DueDate
ôô 
=
ôô  !
DateTime
ôô" *
.
ôô* +
UtcNow
ôô+ 1
.
ôô1 2
	AddMonths
ôô2 ;
(
ôô; <
$num
ôô< =
)
ôô= >
,
ôô> ?
Status
öö 
=
öö  
$str
öö! *
}
õõ 
;
õõ 
_context
úú 
.
úú 
Invoices
úú %
.
úú% &
Add
úú& )
(
úú) *
invoice
úú* 1
)
úú1 2
;
úú2 3
generatedInvoices
ùù %
.
ùù% &
Add
ùù& )
(
ùù) *
new
ùù* -
{
ùù. /
invoice
ùù0 7
,
ùù7 8
message
ùù9 @
=
ùùA B
$str
ùùC V
}
ùùW X
)
ùùX Y
;
ùùY Z
}
ûû 
await
üü 
_context
üü 
.
üü 
SaveChangesAsync
üü /
(
üü/ 0
)
üü0 1
;
üü1 2
return
°° 
Ok
°° 
(
°° 
new
°° 
{
°° 
message
°°  '
=
°°( )
$str
°°* >
,
°°> ?
invoices
°°@ H
=
°°I J
generatedInvoices
°°K \
}
°°] ^
)
°°^ _
;
°°_ `
}
¢¢ 
catch
££ 
(
££ 
	Exception
££ 
ex
££ 
)
££  
{
§§ 
return
•• 

StatusCode
•• !
(
••! "
$num
••" %
,
••% &
new
••' *
{
••+ ,
message
••- 4
=
••5 6
$"
••7 9
$str
••9 U
{
••U V
ex
••V X
.
••X Y
Message
••Y `
}
••` a
"
••a b
}
••c d
)
••d e
;
••e f
}
¶¶ 
}
ßß 	
[
©© 	
HttpGet
©©	 
(
©© 
$str
©©  
)
©©  !
]
©©! "
public
™™ 
async
™™ 
Task
™™ 
<
™™ 
IActionResult
™™ '
>
™™' (
GetNotifications
™™) 9
(
™™9 :
)
™™: ;
{
´´ 	
var
¨¨ 
userId
¨¨ 
=
¨¨ 
User
¨¨ 
.
¨¨ 
	FindFirst
¨¨ '
(
¨¨' (
System
¨¨( .
.
¨¨. /
Security
¨¨/ 7
.
¨¨7 8
Claims
¨¨8 >
.
¨¨> ?

ClaimTypes
¨¨? I
.
¨¨I J
NameIdentifier
¨¨J X
)
¨¨X Y
?
¨¨Y Z
.
¨¨Z [
Value
¨¨[ `
;
¨¨` a
var
≠≠ 
notifications
≠≠ 
=
≠≠ 
await
≠≠  %
_context
≠≠& .
.
≠≠. /
Notifications
≠≠/ <
.
ÆÆ 
Where
ÆÆ 
(
ÆÆ 
n
ÆÆ 
=>
ÆÆ 
n
ÆÆ 
.
ÆÆ 
UserID
ÆÆ $
==
ÆÆ% '
userId
ÆÆ( .
)
ÆÆ. /
.
ØØ 
OrderByDescending
ØØ "
(
ØØ" #
n
ØØ# $
=>
ØØ% '
n
ØØ( )
.
ØØ) *
SentAt
ØØ* 0
)
ØØ0 1
.
∞∞ 
Take
∞∞ 
(
∞∞ 
$num
∞∞ 
)
∞∞ 
.
±± 
ToListAsync
±± 
(
±± 
)
±± 
;
±± 
return
≤≤ 
Ok
≤≤ 
(
≤≤ 
notifications
≤≤ #
)
≤≤# $
;
≤≤$ %
}
≥≥ 	
[
µµ 	
HttpPut
µµ	 
(
µµ 
$str
µµ *
)
µµ* +
]
µµ+ ,
public
∂∂ 
async
∂∂ 
Task
∂∂ 
<
∂∂ 
IActionResult
∂∂ '
>
∂∂' ($
MarkNotificationAsRead
∂∂) ?
(
∂∂? @
int
∂∂@ C
id
∂∂D F
)
∂∂F G
{
∑∑ 	
var
∏∏ 
userId
∏∏ 
=
∏∏ 
User
∏∏ 
.
∏∏ 
	FindFirst
∏∏ '
(
∏∏' (
System
∏∏( .
.
∏∏. /
Security
∏∏/ 7
.
∏∏7 8
Claims
∏∏8 >
.
∏∏> ?

ClaimTypes
∏∏? I
.
∏∏I J
NameIdentifier
∏∏J X
)
∏∏X Y
?
∏∏Y Z
.
∏∏Z [
Value
∏∏[ `
;
∏∏` a
var
ππ 
notification
ππ 
=
ππ 
await
ππ $
_context
ππ% -
.
ππ- .
Notifications
ππ. ;
.
ππ; <!
FirstOrDefaultAsync
ππ< O
(
ππO P
n
ππP Q
=>
ππR T
n
ππU V
.
ππV W
NotificationID
ππW e
==
ππf h
id
ππi k
&&
ππl n
n
ππo p
.
ππp q
UserID
ππq w
==
ππx z
userIdππ{ Å
)ππÅ Ç
;ππÇ É
if
∫∫ 
(
∫∫ 
notification
∫∫ 
==
∫∫ 
null
∫∫  $
)
∫∫$ %
return
∫∫& ,
NotFound
∫∫- 5
(
∫∫5 6
)
∫∫6 7
;
∫∫7 8
notification
ªª 
.
ªª 
Status
ªª 
=
ªª  !
$str
ªª" (
;
ªª( )
await
ºº 
_context
ºº 
.
ºº 
SaveChangesAsync
ºº +
(
ºº+ ,
)
ºº, -
;
ºº- .
return
ΩΩ 
Ok
ΩΩ 
(
ΩΩ 
new
ΩΩ 
{
ΩΩ 
message
ΩΩ #
=
ΩΩ$ %
$str
ΩΩ& C
}
ΩΩD E
)
ΩΩE F
;
ΩΩF G
}
ææ 	
[
¿¿ 	

HttpDelete
¿¿	 
(
¿¿ 
$str
¿¿ (
)
¿¿( )
]
¿¿) *
public
¡¡ 
async
¡¡ 
Task
¡¡ 
<
¡¡ 
IActionResult
¡¡ '
>
¡¡' ( 
DeleteNotification
¡¡) ;
(
¡¡; <
int
¡¡< ?
id
¡¡@ B
)
¡¡B C
{
¬¬ 	
var
√√ 
userId
√√ 
=
√√ 
User
√√ 
.
√√ 
	FindFirst
√√ '
(
√√' (
System
√√( .
.
√√. /
Security
√√/ 7
.
√√7 8
Claims
√√8 >
.
√√> ?

ClaimTypes
√√? I
.
√√I J
NameIdentifier
√√J X
)
√√X Y
?
√√Y Z
.
√√Z [
Value
√√[ `
;
√√` a
var
ƒƒ 
notification
ƒƒ 
=
ƒƒ 
await
ƒƒ $
_context
ƒƒ% -
.
ƒƒ- .
Notifications
ƒƒ. ;
.
ƒƒ; <!
FirstOrDefaultAsync
ƒƒ< O
(
ƒƒO P
n
ƒƒP Q
=>
ƒƒR T
n
ƒƒU V
.
ƒƒV W
NotificationID
ƒƒW e
==
ƒƒf h
id
ƒƒi k
&&
ƒƒl n
n
ƒƒo p
.
ƒƒp q
UserID
ƒƒq w
==
ƒƒx z
userIdƒƒ{ Å
)ƒƒÅ Ç
;ƒƒÇ É
if
≈≈ 
(
≈≈ 
notification
≈≈ 
==
≈≈ 
null
≈≈  $
)
≈≈$ %
return
≈≈& ,
NotFound
≈≈- 5
(
≈≈5 6
)
≈≈6 7
;
≈≈7 8
_context
∆∆ 
.
∆∆ 
Notifications
∆∆ "
.
∆∆" #
Remove
∆∆# )
(
∆∆) *
notification
∆∆* 6
)
∆∆6 7
;
∆∆7 8
await
«« 
_context
«« 
.
«« 
SaveChangesAsync
«« +
(
««+ ,
)
««, -
;
««- .
return
»» 
Ok
»» 
(
»» 
new
»» 
{
»» 
message
»» #
=
»»$ %
$str
»»& <
}
»»= >
)
»»> ?
;
»»? @
}
…… 	
[
ÀÀ 	
HttpPost
ÀÀ	 
(
ÀÀ 
$str
ÀÀ #
)
ÀÀ# $
]
ÀÀ$ %
public
ÃÃ 
async
ÃÃ 
Task
ÃÃ 
<
ÃÃ 
IActionResult
ÃÃ '
>
ÃÃ' (
ChangePassword
ÃÃ) 7
(
ÃÃ7 8
[
ÃÃ8 9
FromBody
ÃÃ9 A
]
ÃÃA B#
ChangePasswordRequest
ÃÃC X
request
ÃÃY `
)
ÃÃ` a
{
ÕÕ 	
var
ŒŒ 
userId
ŒŒ 
=
ŒŒ 
User
ŒŒ 
.
ŒŒ 
	FindFirst
ŒŒ '
(
ŒŒ' (
System
ŒŒ( .
.
ŒŒ. /
Security
ŒŒ/ 7
.
ŒŒ7 8
Claims
ŒŒ8 >
.
ŒŒ> ?

ClaimTypes
ŒŒ? I
.
ŒŒI J
NameIdentifier
ŒŒJ X
)
ŒŒX Y
?
ŒŒY Z
.
ŒŒZ [
Value
ŒŒ[ `
;
ŒŒ` a
var
œœ 
user
œœ 
=
œœ 
await
œœ 
_userManager
œœ )
.
œœ) *
FindByIdAsync
œœ* 7
(
œœ7 8
userId
œœ8 >
!
œœ> ?
)
œœ? @
;
œœ@ A
if
–– 
(
–– 
user
–– 
==
–– 
null
–– 
)
–– 
return
–– $
NotFound
––% -
(
––- .
new
––. 1
{
––2 3
message
––4 ;
=
––< =
$str
––> N
}
––O P
)
––P Q
;
––Q R
var
““ $
isCurrentPasswordValid
““ &
=
““' (
await
““) .
_userManager
““/ ;
.
““; < 
CheckPasswordAsync
““< N
(
““N O
user
““O S
,
““S T
request
““U \
.
““\ ]
CurrentPassword
““] l
)
““l m
;
““m n
if
”” 
(
”” 
!
”” $
isCurrentPasswordValid
”” '
)
””' (
return
””) /

BadRequest
””0 :
(
””: ;
new
””; >
{
””? @
message
””A H
=
””I J
$str
””K j
}
””k l
)
””l m
;
””m n
var
’’ 
result
’’ 
=
’’ 
await
’’ 
_userManager
’’ +
.
’’+ ,!
ChangePasswordAsync
’’, ?
(
’’? @
user
’’@ D
,
’’D E
request
’’F M
.
’’M N
CurrentPassword
’’N ]
,
’’] ^
request
’’_ f
.
’’f g
NewPassword
’’g r
)
’’r s
;
’’s t
if
÷÷ 
(
÷÷ 
!
÷÷ 
result
÷÷ 
.
÷÷ 
	Succeeded
÷÷ !
)
÷÷! "
{
◊◊ 
var
ÿÿ 
errors
ÿÿ 
=
ÿÿ 
string
ÿÿ #
.
ÿÿ# $
Join
ÿÿ$ (
(
ÿÿ( )
$str
ÿÿ) -
,
ÿÿ- .
result
ÿÿ/ 5
.
ÿÿ5 6
Errors
ÿÿ6 <
.
ÿÿ< =
Select
ÿÿ= C
(
ÿÿC D
e
ÿÿD E
=>
ÿÿF H
e
ÿÿI J
.
ÿÿJ K
Description
ÿÿK V
)
ÿÿV W
)
ÿÿW X
;
ÿÿX Y
return
ŸŸ 

BadRequest
ŸŸ !
(
ŸŸ! "
new
ŸŸ" %
{
ŸŸ& '
message
ŸŸ( /
=
ŸŸ0 1
errors
ŸŸ2 8
}
ŸŸ9 :
)
ŸŸ: ;
;
ŸŸ; <
}
⁄⁄ 
var
›› 
passwordPref
›› 
=
›› 
await
›› $
_context
››% -
.
››- .%
NotificationPreferences
››. E
.
ﬁﬁ !
FirstOrDefaultAsync
ﬁﬁ $
(
ﬁﬁ$ %
np
ﬁﬁ% '
=>
ﬁﬁ( *
np
ﬁﬁ+ -
.
ﬁﬁ- .
UserID
ﬁﬁ. 4
==
ﬁﬁ5 7
userId
ﬁﬁ8 >
&&
ﬁﬁ? A
np
ﬁﬁB D
.
ﬁﬁD E
NotificationType
ﬁﬁE U
==
ﬁﬁV X
$str
ﬁﬁY j
)
ﬁﬁj k
;
ﬁﬁk l
if
ﬂﬂ 
(
ﬂﬂ 
passwordPref
ﬂﬂ 
?
ﬂﬂ 
.
ﬂﬂ 
EmailEnabled
ﬂﬂ *
!=
ﬂﬂ+ -
false
ﬂﬂ. 3
)
ﬂﬂ3 4
{
‡‡ 
await
·· 
_emailService
·· #
.
··# $
SendEmailAsync
··$ 2
(
··2 3
user
‚‚ 
.
‚‚ 
Email
‚‚ 
!
‚‚ 
,
‚‚  
$str
„„ 7
,
„„7 8
$"
‰‰ 
$str
‰‰ 
{
‰‰ 
user
‰‰ !
.
‰‰! "
	FirstName
‰‰" +
}
‰‰+ ,
$str‰‰, ≠
"‰‰≠ Æ
)
ÂÂ 
;
ÂÂ 
}
ÊÊ 
return
ËË 
Ok
ËË 
(
ËË 
new
ËË 
{
ËË 
message
ËË #
=
ËË$ %
$str
ËË& E
}
ËËF G
)
ËËG H
;
ËËH I
}
ÈÈ 	
[
ÎÎ 	
HttpGet
ÎÎ	 
(
ÎÎ 
$str
ÎÎ  
)
ÎÎ  !
]
ÎÎ! "
public
ÏÏ 
async
ÏÏ 
Task
ÏÏ 
<
ÏÏ 
IActionResult
ÏÏ '
>
ÏÏ' (
GetLoginHistory
ÏÏ) 8
(
ÏÏ8 9
)
ÏÏ9 :
{
ÌÌ 	
var
ÓÓ 
userId
ÓÓ 
=
ÓÓ 
User
ÓÓ 
.
ÓÓ 
	FindFirst
ÓÓ '
(
ÓÓ' (
System
ÓÓ( .
.
ÓÓ. /
Security
ÓÓ/ 7
.
ÓÓ7 8
Claims
ÓÓ8 >
.
ÓÓ> ?

ClaimTypes
ÓÓ? I
.
ÓÓI J
NameIdentifier
ÓÓJ X
)
ÓÓX Y
?
ÓÓY Z
.
ÓÓZ [
Value
ÓÓ[ `
;
ÓÓ` a
var
ÔÔ 
loginHistory
ÔÔ 
=
ÔÔ 
await
ÔÔ $
_context
ÔÔ% -
.
ÔÔ- .
LoginHistory
ÔÔ. :
.
 
Where
 
(
 
lh
 
=>
 
lh
 
.
  
UserID
  &
==
' )
userId
* 0
)
0 1
.
ÒÒ 
OrderByDescending
ÒÒ "
(
ÒÒ" #
lh
ÒÒ# %
=>
ÒÒ& (
lh
ÒÒ) +
.
ÒÒ+ ,
	LoginTime
ÒÒ, 5
)
ÒÒ5 6
.
ÚÚ 
Take
ÚÚ 
(
ÚÚ 
$num
ÚÚ 
)
ÚÚ 
.
ÛÛ 
Select
ÛÛ 
(
ÛÛ 
lh
ÛÛ 
=>
ÛÛ 
new
ÛÛ !
{
ÙÙ 
lh
ıı 
.
ıı 
LoginHistoryID
ıı %
,
ıı% &
lh
ˆˆ 
.
ˆˆ 
Device
ˆˆ 
,
ˆˆ 
lh
˜˜ 
.
˜˜ 
Location
˜˜ 
,
˜˜  
lh
¯¯ 
.
¯¯ 
	LoginTime
¯¯  
,
¯¯  !
lh
˘˘ 
.
˘˘ 
	IPAddress
˘˘  
,
˘˘  !
Current
˙˙ 
=
˙˙ 
lh
˙˙  
.
˙˙  !
	LoginTime
˙˙! *
>
˙˙+ ,
DateTime
˙˙- 5
.
˙˙5 6
UtcNow
˙˙6 <
.
˙˙< =
AddHours
˙˙= E
(
˙˙E F
-
˙˙F G
$num
˙˙G H
)
˙˙H I
}
˚˚ 
)
˚˚ 
.
¸¸ 
ToListAsync
¸¸ 
(
¸¸ 
)
¸¸ 
;
¸¸ 
return
˝˝ 
Ok
˝˝ 
(
˝˝ 
loginHistory
˝˝ "
)
˝˝" #
;
˝˝# $
}
˛˛ 	
[
Ä	Ä	 	
HttpPost
Ä	Ä		 
(
Ä	Ä	 
$str
Ä	Ä	 
)
Ä	Ä	 
]
Ä	Ä	  
public
Å	Å	 
async
Å	Å	 
Task
Å	Å	 
<
Å	Å	 
IActionResult
Å	Å	 '
>
Å	Å	' (
	Enable2FA
Å	Å	) 2
(
Å	Å	2 3
)
Å	Å	3 4
{
Ç	Ç	 	
var
É	É	 
userId
É	É	 
=
É	É	 
User
É	É	 
.
É	É	 
	FindFirst
É	É	 '
(
É	É	' (
System
É	É	( .
.
É	É	. /
Security
É	É	/ 7
.
É	É	7 8
Claims
É	É	8 >
.
É	É	> ?

ClaimTypes
É	É	? I
.
É	É	I J
NameIdentifier
É	É	J X
)
É	É	X Y
?
É	É	Y Z
.
É	É	Z [
Value
É	É	[ `
;
É	É	` a
var
Ñ	Ñ	 
user
Ñ	Ñ	 
=
Ñ	Ñ	 
await
Ñ	Ñ	 
_userManager
Ñ	Ñ	 )
.
Ñ	Ñ	) *
FindByIdAsync
Ñ	Ñ	* 7
(
Ñ	Ñ	7 8
userId
Ñ	Ñ	8 >
!
Ñ	Ñ	> ?
)
Ñ	Ñ	? @
;
Ñ	Ñ	@ A
if
Ö	Ö	 
(
Ö	Ö	 
user
Ö	Ö	 
==
Ö	Ö	 
null
Ö	Ö	 
)
Ö	Ö	 
return
Ö	Ö	 $
NotFound
Ö	Ö	% -
(
Ö	Ö	- .
new
Ö	Ö	. 1
{
Ö	Ö	2 3
message
Ö	Ö	4 ;
=
Ö	Ö	< =
$str
Ö	Ö	> N
}
Ö	Ö	O P
)
Ö	Ö	P Q
;
Ö	Ö	Q R
var
á	á	 
code
á	á	 
=
á	á	 
new
á	á	 
Random
á	á	 !
(
á	á	! "
)
á	á	" #
.
á	á	# $
Next
á	á	$ (
(
á	á	( )
$num
á	á	) /
,
á	á	/ 0
$num
á	á	1 7
)
á	á	7 8
.
á	á	8 9
ToString
á	á	9 A
(
á	á	A B
)
á	á	B C
;
á	á	C D
_context
à	à	 
.
à	à	 
VerificationCodes
à	à	 &
.
à	à	& '
Add
à	à	' *
(
à	à	* +
new
à	à	+ .
VerificationCode
à	à	/ ?
{
â	â	 
Email
ä	ä	 
=
ä	ä	 
user
ä	ä	 
.
ä	ä	 
Email
ä	ä	 "
!
ä	ä	" #
,
ä	ä	# $
Code
ã	ã	 
=
ã	ã	 
code
ã	ã	 
,
ã	ã	 
	ExpiresAt
å	å	 
=
å	å	 
DateTime
å	å	 $
.
å	å	$ %
UtcNow
å	å	% +
.
å	å	+ ,

AddMinutes
å	å	, 6
(
å	å	6 7
$num
å	å	7 9
)
å	å	9 :
}
ç	ç	 
)
ç	ç	 
;
ç	ç	 
await
é	é	 
_context
é	é	 
.
é	é	 
SaveChangesAsync
é	é	 +
(
é	é	+ ,
)
é	é	, -
;
é	é	- .
await
è	è	 
_emailService
è	è	 
.
è	è	  
SendEmailAsync
è	è	  .
(
è	è	. /
user
è	è	/ 3
.
è	è	3 4
Email
è	è	4 9
!
è	è	9 :
,
è	è	: ;
$str
è	è	< Y
,
è	è	Y Z
$"
è	è	[ ]
$str
è	è	] x
{
è	è	x y
code
è	è	y }
}
è	è	} ~
"
è	è	~ 
)è	è	 Ä
;è	è	Ä Å
return
ë	ë	 
Ok
ë	ë	 
(
ë	ë	 
new
ë	ë	 
{
ë	ë	 
message
ë	ë	 #
=
ë	ë	$ %
$str
ë	ë	& L
}
ë	ë	M N
)
ë	ë	N O
;
ë	ë	O P
}
í	í	 	
[
î	î	 	
HttpPost
î	î		 
(
î	î	 
$str
î	î	 $
)
î	î	$ %
]
î	î	% &
public
ï	ï	 
async
ï	ï	 
Task
ï	ï	 
<
ï	ï	 
IActionResult
ï	ï	 '
>
ï	ï	' (
Verify2FASetup
ï	ï	) 7
(
ï	ï	7 8
[
ï	ï	8 9
FromBody
ï	ï	9 A
]
ï	ï	A B
VerifyCodeRequest
ï	ï	C T
request
ï	ï	U \
)
ï	ï	\ ]
{
ñ	ñ	 	
var
ó	ó	 
userId
ó	ó	 
=
ó	ó	 
User
ó	ó	 
.
ó	ó	 
	FindFirst
ó	ó	 '
(
ó	ó	' (
System
ó	ó	( .
.
ó	ó	. /
Security
ó	ó	/ 7
.
ó	ó	7 8
Claims
ó	ó	8 >
.
ó	ó	> ?

ClaimTypes
ó	ó	? I
.
ó	ó	I J
NameIdentifier
ó	ó	J X
)
ó	ó	X Y
?
ó	ó	Y Z
.
ó	ó	Z [
Value
ó	ó	[ `
;
ó	ó	` a
var
ò	ò	 
user
ò	ò	 
=
ò	ò	 
await
ò	ò	 
_userManager
ò	ò	 )
.
ò	ò	) *
FindByIdAsync
ò	ò	* 7
(
ò	ò	7 8
userId
ò	ò	8 >
!
ò	ò	> ?
)
ò	ò	? @
;
ò	ò	@ A
if
ô	ô	 
(
ô	ô	 
user
ô	ô	 
==
ô	ô	 
null
ô	ô	 
)
ô	ô	 
return
ô	ô	 $
NotFound
ô	ô	% -
(
ô	ô	- .
new
ô	ô	. 1
{
ô	ô	2 3
message
ô	ô	4 ;
=
ô	ô	< =
$str
ô	ô	> N
}
ô	ô	O P
)
ô	ô	P Q
;
ô	ô	Q R
var
õ	õ	 
verification
õ	õ	 
=
õ	õ	 
await
õ	õ	 $
_context
õ	õ	% -
.
õ	õ	- .
VerificationCodes
õ	õ	. ?
.
ú	ú	 !
FirstOrDefaultAsync
ú	ú	 $
(
ú	ú	$ %
v
ú	ú	% &
=>
ú	ú	' )
v
ú	ú	* +
.
ú	ú	+ ,
Email
ú	ú	, 1
==
ú	ú	2 4
user
ú	ú	5 9
.
ú	ú	9 :
Email
ú	ú	: ?
&&
ú	ú	@ B
v
ú	ú	C D
.
ú	ú	D E
Code
ú	ú	E I
==
ú	ú	J L
request
ú	ú	M T
.
ú	ú	T U
Code
ú	ú	U Y
&&
ú	ú	Z \
!
ú	ú	] ^
v
ú	ú	^ _
.
ú	ú	_ `
IsUsed
ú	ú	` f
&&
ú	ú	g i
v
ú	ú	j k
.
ú	ú	k l
	ExpiresAt
ú	ú	l u
>
ú	ú	v w
DateTimeú	ú	x Ä
.ú	ú	Ä Å
UtcNowú	ú	Å á
)ú	ú	á à
;ú	ú	à â
if
ù	ù	 
(
ù	ù	 
verification
ù	ù	 
==
ù	ù	 
null
ù	ù	  $
)
ù	ù	$ %
return
ù	ù	& ,

BadRequest
ù	ù	- 7
(
ù	ù	7 8
new
ù	ù	8 ;
{
ù	ù	< =
message
ù	ù	> E
=
ù	ù	F G
$str
ù	ù	H a
}
ù	ù	b c
)
ù	ù	c d
;
ù	ù	d e
await
ü	ü	 
_context
ü	ü	 
.
ü	ü	 
Users
ü	ü	  
.
ü	ü	  !
Where
ü	ü	! &
(
ü	ü	& '
u
ü	ü	' (
=>
ü	ü	) +
u
ü	ü	, -
.
ü	ü	- .
Id
ü	ü	. 0
==
ü	ü	1 3
userId
ü	ü	4 :
)
ü	ü	: ;
.
ü	ü	; < 
ExecuteUpdateAsync
ü	ü	< N
(
ü	ü	N O
u
ü	ü	O P
=>
ü	ü	Q S
u
ü	ü	T U
.
ü	ü	U V
SetProperty
ü	ü	V a
(
ü	ü	a b
p
ü	ü	b c
=>
ü	ü	d f
p
ü	ü	g h
.
ü	ü	h i
TwoFactorEnabled
ü	ü	i y
,
ü	ü	y z
true
ü	ü	{ 
)ü	ü	 Ä
)ü	ü	Ä Å
;ü	ü	Å Ç
verification
°	°	 
.
°	°	 
IsUsed
°	°	 
=
°	°	  !
true
°	°	" &
;
°	°	& '
await
¢	¢	 
_context
¢	¢	 
.
¢	¢	 
SaveChangesAsync
¢	¢	 +
(
¢	¢	+ ,
)
¢	¢	, -
;
¢	¢	- .
return
§	§	 
Ok
§	§	 
(
§	§	 
new
§	§	 
{
§	§	 
message
§	§	 #
=
§	§	$ %
$str
§	§	& V
}
§	§	W X
)
§	§	X Y
;
§	§	Y Z
}
•	•	 	
[
ß	ß	 	
HttpPost
ß	ß		 
(
ß	ß	 
$str
ß	ß	 
)
ß	ß	  
]
ß	ß	  !
public
®	®	 
async
®	®	 
Task
®	®	 
<
®	®	 
IActionResult
®	®	 '
>
®	®	' (

Disable2FA
®	®	) 3
(
®	®	3 4
)
®	®	4 5
{
©	©	 	
var
™	™	 
userId
™	™	 
=
™	™	 
User
™	™	 
.
™	™	 
	FindFirst
™	™	 '
(
™	™	' (
System
™	™	( .
.
™	™	. /
Security
™	™	/ 7
.
™	™	7 8
Claims
™	™	8 >
.
™	™	> ?

ClaimTypes
™	™	? I
.
™	™	I J
NameIdentifier
™	™	J X
)
™	™	X Y
?
™	™	Y Z
.
™	™	Z [
Value
™	™	[ `
;
™	™	` a
var
´	´	 
user
´	´	 
=
´	´	 
await
´	´	 
_userManager
´	´	 )
.
´	´	) *
FindByIdAsync
´	´	* 7
(
´	´	7 8
userId
´	´	8 >
!
´	´	> ?
)
´	´	? @
;
´	´	@ A
if
¨	¨	 
(
¨	¨	 
user
¨	¨	 
==
¨	¨	 
null
¨	¨	 
)
¨	¨	 
return
¨	¨	 $
NotFound
¨	¨	% -
(
¨	¨	- .
new
¨	¨	. 1
{
¨	¨	2 3
message
¨	¨	4 ;
=
¨	¨	< =
$str
¨	¨	> N
}
¨	¨	O P
)
¨	¨	P Q
;
¨	¨	Q R
var
Æ	Æ	 
code
Æ	Æ	 
=
Æ	Æ	 
new
Æ	Æ	 
Random
Æ	Æ	 !
(
Æ	Æ	! "
)
Æ	Æ	" #
.
Æ	Æ	# $
Next
Æ	Æ	$ (
(
Æ	Æ	( )
$num
Æ	Æ	) /
,
Æ	Æ	/ 0
$num
Æ	Æ	1 7
)
Æ	Æ	7 8
.
Æ	Æ	8 9
ToString
Æ	Æ	9 A
(
Æ	Æ	A B
)
Æ	Æ	B C
;
Æ	Æ	C D
_context
Ø	Ø	 
.
Ø	Ø	 
VerificationCodes
Ø	Ø	 &
.
Ø	Ø	& '
Add
Ø	Ø	' *
(
Ø	Ø	* +
new
Ø	Ø	+ .
VerificationCode
Ø	Ø	/ ?
{
∞	∞	 
Email
±	±	 
=
±	±	 
user
±	±	 
.
±	±	 
Email
±	±	 "
!
±	±	" #
,
±	±	# $
Code
≤	≤	 
=
≤	≤	 
code
≤	≤	 
,
≤	≤	 
	ExpiresAt
≥	≥	 
=
≥	≥	 
DateTime
≥	≥	 $
.
≥	≥	$ %
UtcNow
≥	≥	% +
.
≥	≥	+ ,

AddMinutes
≥	≥	, 6
(
≥	≥	6 7
$num
≥	≥	7 9
)
≥	≥	9 :
}
¥	¥	 
)
¥	¥	 
;
¥	¥	 
await
µ	µ	 
_context
µ	µ	 
.
µ	µ	 
SaveChangesAsync
µ	µ	 +
(
µ	µ	+ ,
)
µ	µ	, -
;
µ	µ	- .
await
∂	∂	 
_emailService
∂	∂	 
.
∂	∂	  
SendEmailAsync
∂	∂	  .
(
∂	∂	. /
user
∂	∂	/ 3
.
∂	∂	3 4
Email
∂	∂	4 9
!
∂	∂	9 :
,
∂	∂	: ;
$str
∂	∂	< Z
,
∂	∂	Z [
$"
∂	∂	\ ^
$str∂	∂	^ à
{∂	∂	à â
code∂	∂	â ç
}∂	∂	ç é
"∂	∂	é è
)∂	∂	è ê
;∂	∂	ê ë
return
∏	∏	 
Ok
∏	∏	 
(
∏	∏	 
new
∏	∏	 
{
∏	∏	 
message
∏	∏	 #
=
∏	∏	$ %
$str
∏	∏	& L
}
∏	∏	M N
)
∏	∏	N O
;
∏	∏	O P
}
π	π	 	
[
ª	ª	 	
HttpPost
ª	ª		 
(
ª	ª	 
$str
ª	ª	 &
)
ª	ª	& '
]
ª	ª	' (
public
º	º	 
async
º	º	 
Task
º	º	 
<
º	º	 
IActionResult
º	º	 '
>
º	º	' (
VerifyDisable2FA
º	º	) 9
(
º	º	9 :
[
º	º	: ;
FromBody
º	º	; C
]
º	º	C D
VerifyCodeRequest
º	º	E V
request
º	º	W ^
)
º	º	^ _
{
Ω	Ω	 	
var
æ	æ	 
userId
æ	æ	 
=
æ	æ	 
User
æ	æ	 
.
æ	æ	 
	FindFirst
æ	æ	 '
(
æ	æ	' (
System
æ	æ	( .
.
æ	æ	. /
Security
æ	æ	/ 7
.
æ	æ	7 8
Claims
æ	æ	8 >
.
æ	æ	> ?

ClaimTypes
æ	æ	? I
.
æ	æ	I J
NameIdentifier
æ	æ	J X
)
æ	æ	X Y
?
æ	æ	Y Z
.
æ	æ	Z [
Value
æ	æ	[ `
;
æ	æ	` a
var
ø	ø	 
user
ø	ø	 
=
ø	ø	 
await
ø	ø	 
_userManager
ø	ø	 )
.
ø	ø	) *
FindByIdAsync
ø	ø	* 7
(
ø	ø	7 8
userId
ø	ø	8 >
!
ø	ø	> ?
)
ø	ø	? @
;
ø	ø	@ A
if
¿	¿	 
(
¿	¿	 
user
¿	¿	 
==
¿	¿	 
null
¿	¿	 
)
¿	¿	 
return
¿	¿	 $
NotFound
¿	¿	% -
(
¿	¿	- .
new
¿	¿	. 1
{
¿	¿	2 3
message
¿	¿	4 ;
=
¿	¿	< =
$str
¿	¿	> N
}
¿	¿	O P
)
¿	¿	P Q
;
¿	¿	Q R
var
¬	¬	 
verification
¬	¬	 
=
¬	¬	 
await
¬	¬	 $
_context
¬	¬	% -
.
¬	¬	- .
VerificationCodes
¬	¬	. ?
.
√	√	 !
FirstOrDefaultAsync
√	√	 $
(
√	√	$ %
v
√	√	% &
=>
√	√	' )
v
√	√	* +
.
√	√	+ ,
Email
√	√	, 1
==
√	√	2 4
user
√	√	5 9
.
√	√	9 :
Email
√	√	: ?
&&
√	√	@ B
v
√	√	C D
.
√	√	D E
Code
√	√	E I
==
√	√	J L
request
√	√	M T
.
√	√	T U
Code
√	√	U Y
&&
√	√	Z \
!
√	√	] ^
v
√	√	^ _
.
√	√	_ `
IsUsed
√	√	` f
&&
√	√	g i
v
√	√	j k
.
√	√	k l
	ExpiresAt
√	√	l u
>
√	√	v w
DateTime√	√	x Ä
.√	√	Ä Å
UtcNow√	√	Å á
)√	√	á à
;√	√	à â
if
ƒ	ƒ	 
(
ƒ	ƒ	 
verification
ƒ	ƒ	 
==
ƒ	ƒ	 
null
ƒ	ƒ	  $
)
ƒ	ƒ	$ %
return
ƒ	ƒ	& ,

BadRequest
ƒ	ƒ	- 7
(
ƒ	ƒ	7 8
new
ƒ	ƒ	8 ;
{
ƒ	ƒ	< =
message
ƒ	ƒ	> E
=
ƒ	ƒ	F G
$str
ƒ	ƒ	H a
}
ƒ	ƒ	b c
)
ƒ	ƒ	c d
;
ƒ	ƒ	d e
await
«	«	 
_context
«	«	 
.
«	«	 
Users
«	«	  
.
«	«	  !
Where
«	«	! &
(
«	«	& '
u
«	«	' (
=>
«	«	) +
u
«	«	, -
.
«	«	- .
Id
«	«	. 0
==
«	«	1 3
userId
«	«	4 :
)
«	«	: ;
.
«	«	; < 
ExecuteUpdateAsync
«	«	< N
(
«	«	N O
u
«	«	O P
=>
«	«	Q S
u
«	«	T U
.
«	«	U V
SetProperty
«	«	V a
(
«	«	a b
p
«	«	b c
=>
«	«	d f
p
«	«	g h
.
«	«	h i
TwoFactorEnabled
«	«	i y
,
«	«	y z
false«	«	{ Ä
)«	«	Ä Å
)«	«	Å Ç
;«	«	Ç É
verification
…	…	 
.
…	…	 
IsUsed
…	…	 
=
…	…	  !
true
…	…	" &
;
…	…	& '
await
 	 	 
_context
 	 	 
.
 	 	 
SaveChangesAsync
 	 	 +
(
 	 	+ ,
)
 	 	, -
;
 	 	- .
return
Ã	Ã	 
Ok
Ã	Ã	 
(
Ã	Ã	 
new
Ã	Ã	 
{
Ã	Ã	 
message
Ã	Ã	 #
=
Ã	Ã	$ %
$str
Ã	Ã	& W
}
Ã	Ã	X Y
)
Ã	Ã	Y Z
;
Ã	Ã	Z [
}
Õ	Õ	 	
[
œ	œ	 	
HttpGet
œ	œ		 
(
œ	œ	 
$str
œ	œ	 
)
œ	œ	 
]
œ	œ	 
public
–	–	 
async
–	–	 
Task
–	–	 
<
–	–	 
IActionResult
–	–	 '
>
–	–	' (
Get2FAStatus
–	–	) 5
(
–	–	5 6
)
–	–	6 7
{
—	—	 	
var
“	“	 
userId
“	“	 
=
“	“	 
User
“	“	 
.
“	“	 
	FindFirst
“	“	 '
(
“	“	' (
System
“	“	( .
.
“	“	. /
Security
“	“	/ 7
.
“	“	7 8
Claims
“	“	8 >
.
“	“	> ?

ClaimTypes
“	“	? I
.
“	“	I J
NameIdentifier
“	“	J X
)
“	“	X Y
?
“	“	Y Z
.
“	“	Z [
Value
“	“	[ `
;
“	“	` a
var
”	”	 
user
”	”	 
=
”	”	 
await
”	”	 
_userManager
”	”	 )
.
”	”	) *
FindByIdAsync
”	”	* 7
(
”	”	7 8
userId
”	”	8 >
!
”	”	> ?
)
”	”	? @
;
”	”	@ A
if
‘	‘	 
(
‘	‘	 
user
‘	‘	 
==
‘	‘	 
null
‘	‘	 
)
‘	‘	 
return
‘	‘	 $
NotFound
‘	‘	% -
(
‘	‘	- .
new
‘	‘	. 1
{
‘	‘	2 3
message
‘	‘	4 ;
=
‘	‘	< =
$str
‘	‘	> N
}
‘	‘	O P
)
‘	‘	P Q
;
‘	‘	Q R
return
÷	÷	 
Ok
÷	÷	 
(
÷	÷	 
new
÷	÷	 
{
÷	÷	 
twoFactorEnabled
÷	÷	 ,
=
÷	÷	- .
user
÷	÷	/ 3
.
÷	÷	3 4
TwoFactorEnabled
÷	÷	4 D
}
÷	÷	E F
)
÷	÷	F G
;
÷	÷	G H
}
◊	◊	 	
[
Ÿ	Ÿ	 	
HttpPost
Ÿ	Ÿ		 
(
Ÿ	Ÿ	 
$str
Ÿ	Ÿ	 $
)
Ÿ	Ÿ	$ %
]
Ÿ	Ÿ	% &
public
⁄	⁄	 
async
⁄	⁄	 
Task
⁄	⁄	 
<
⁄	⁄	 
IActionResult
⁄	⁄	 '
>
⁄	⁄	' (
SetSecurityPin
⁄	⁄	) 7
(
⁄	⁄	7 8
[
⁄	⁄	8 9
FromBody
⁄	⁄	9 A
]
⁄	⁄	A B
SetPinRequest
⁄	⁄	C P
request
⁄	⁄	Q X
)
⁄	⁄	X Y
{
€	€	 	
var
‹	‹	 
userId
‹	‹	 
=
‹	‹	 
User
‹	‹	 
.
‹	‹	 
	FindFirst
‹	‹	 '
(
‹	‹	' (
System
‹	‹	( .
.
‹	‹	. /
Security
‹	‹	/ 7
.
‹	‹	7 8
Claims
‹	‹	8 >
.
‹	‹	> ?

ClaimTypes
‹	‹	? I
.
‹	‹	I J
NameIdentifier
‹	‹	J X
)
‹	‹	X Y
?
‹	‹	Y Z
.
‹	‹	Z [
Value
‹	‹	[ `
;
‹	‹	` a
var
›	›	 
user
›	›	 
=
›	›	 
await
›	›	 
_userManager
›	›	 )
.
›	›	) *
FindByIdAsync
›	›	* 7
(
›	›	7 8
userId
›	›	8 >
!
›	›	> ?
)
›	›	? @
;
›	›	@ A
if
ﬁ	ﬁ	 
(
ﬁ	ﬁ	 
user
ﬁ	ﬁ	 
==
ﬁ	ﬁ	 
null
ﬁ	ﬁ	 
)
ﬁ	ﬁ	 
return
ﬁ	ﬁ	 $
NotFound
ﬁ	ﬁ	% -
(
ﬁ	ﬁ	- .
new
ﬁ	ﬁ	. 1
{
ﬁ	ﬁ	2 3
message
ﬁ	ﬁ	4 ;
=
ﬁ	ﬁ	< =
$str
ﬁ	ﬁ	> N
}
ﬁ	ﬁ	O P
)
ﬁ	ﬁ	P Q
;
ﬁ	ﬁ	Q R
user
‡	‡	 
.
‡	‡	 
SecurityPin
‡	‡	 
=
‡	‡	 
request
‡	‡	 &
.
‡	‡	& '
Pin
‡	‡	' *
;
‡	‡	* +
user
·	·	 
.
·	·	 "
PinProtectionEnabled
·	·	 %
=
·	·	& '
true
·	·	( ,
;
·	·	, -
await
‚	‚	 
_userManager
‚	‚	 
.
‚	‚	 
UpdateAsync
‚	‚	 *
(
‚	‚	* +
user
‚	‚	+ /
)
‚	‚	/ 0
;
‚	‚	0 1
return
„	„	 
Ok
„	„	 
(
„	„	 
new
„	„	 
{
„	„	 
message
„	„	 #
=
„	„	$ %
$str
„	„	& E
}
„	„	F G
)
„	„	G H
;
„	„	H I
}
‰	‰	 	
[
Ê	Ê	 	
HttpPost
Ê	Ê		 
(
Ê	Ê	 
$str
Ê	Ê	 '
)
Ê	Ê	' (
]
Ê	Ê	( )
public
Á	Á	 
async
Á	Á	 
Task
Á	Á	 
<
Á	Á	 
IActionResult
Á	Á	 '
>
Á	Á	' (
VerifySecurityPin
Á	Á	) :
(
Á	Á	: ;
[
Á	Á	; <
FromBody
Á	Á	< D
]
Á	Á	D E
VerifyPinRequest
Á	Á	F V
request
Á	Á	W ^
)
Á	Á	^ _
{
Ë	Ë	 	
var
È	È	 
userId
È	È	 
=
È	È	 
User
È	È	 
.
È	È	 
	FindFirst
È	È	 '
(
È	È	' (
System
È	È	( .
.
È	È	. /
Security
È	È	/ 7
.
È	È	7 8
Claims
È	È	8 >
.
È	È	> ?

ClaimTypes
È	È	? I
.
È	È	I J
NameIdentifier
È	È	J X
)
È	È	X Y
?
È	È	Y Z
.
È	È	Z [
Value
È	È	[ `
;
È	È	` a
var
Í	Í	 
user
Í	Í	 
=
Í	Í	 
await
Í	Í	 
_userManager
Í	Í	 )
.
Í	Í	) *
FindByIdAsync
Í	Í	* 7
(
Í	Í	7 8
userId
Í	Í	8 >
!
Í	Í	> ?
)
Í	Í	? @
;
Í	Í	@ A
if
Î	Î	 
(
Î	Î	 
user
Î	Î	 
==
Î	Î	 
null
Î	Î	 
)
Î	Î	 
return
Î	Î	 $
NotFound
Î	Î	% -
(
Î	Î	- .
new
Î	Î	. 1
{
Î	Î	2 3
message
Î	Î	4 ;
=
Î	Î	< =
$str
Î	Î	> N
}
Î	Î	O P
)
Î	Î	P Q
;
Î	Î	Q R
if
Ì	Ì	 
(
Ì	Ì	 
user
Ì	Ì	 
.
Ì	Ì	 
SecurityPin
Ì	Ì	  
!=
Ì	Ì	! #
request
Ì	Ì	$ +
.
Ì	Ì	+ ,
Pin
Ì	Ì	, /
)
Ì	Ì	/ 0
return
Ó	Ó	 

BadRequest
Ó	Ó	 !
(
Ó	Ó	! "
new
Ó	Ó	" %
{
Ó	Ó	& '
message
Ó	Ó	( /
=
Ó	Ó	0 1
$str
Ó	Ó	2 ?
}
Ó	Ó	@ A
)
Ó	Ó	A B
;
Ó	Ó	B C
return
		 
Ok
		 
(
		 
new
		 
{
		 
message
		 #
=
		$ %
$str
		& A
}
		B C
)
		C D
;
		D E
}
Ò	Ò	 	
[
Û	Û	 	
HttpPost
Û	Û		 
(
Û	Û	 
$str
Û	Û	 )
)
Û	Û	) *
]
Û	Û	* +
public
Ù	Ù	 
async
Ù	Ù	 
Task
Ù	Ù	 
<
Ù	Ù	 
IActionResult
Ù	Ù	 '
>
Ù	Ù	' (!
TogglePinProtection
Ù	Ù	) <
(
Ù	Ù	< =
)
Ù	Ù	= >
{
ı	ı	 	
var
ˆ	ˆ	 
userId
ˆ	ˆ	 
=
ˆ	ˆ	 
User
ˆ	ˆ	 
.
ˆ	ˆ	 
	FindFirst
ˆ	ˆ	 '
(
ˆ	ˆ	' (
System
ˆ	ˆ	( .
.
ˆ	ˆ	. /
Security
ˆ	ˆ	/ 7
.
ˆ	ˆ	7 8
Claims
ˆ	ˆ	8 >
.
ˆ	ˆ	> ?

ClaimTypes
ˆ	ˆ	? I
.
ˆ	ˆ	I J
NameIdentifier
ˆ	ˆ	J X
)
ˆ	ˆ	X Y
?
ˆ	ˆ	Y Z
.
ˆ	ˆ	Z [
Value
ˆ	ˆ	[ `
;
ˆ	ˆ	` a
var
˜	˜	 
user
˜	˜	 
=
˜	˜	 
await
˜	˜	 
_userManager
˜	˜	 )
.
˜	˜	) *
FindByIdAsync
˜	˜	* 7
(
˜	˜	7 8
userId
˜	˜	8 >
!
˜	˜	> ?
)
˜	˜	? @
;
˜	˜	@ A
if
¯	¯	 
(
¯	¯	 
user
¯	¯	 
==
¯	¯	 
null
¯	¯	 
)
¯	¯	 
return
¯	¯	 $
NotFound
¯	¯	% -
(
¯	¯	- .
new
¯	¯	. 1
{
¯	¯	2 3
message
¯	¯	4 ;
=
¯	¯	< =
$str
¯	¯	> N
}
¯	¯	O P
)
¯	¯	P Q
;
¯	¯	Q R
if
˚	˚	 
(
˚	˚	 
user
˚	˚	 
.
˚	˚	 "
PinProtectionEnabled
˚	˚	 )
)
˚	˚	) *
{
¸	¸	 
var
˝	˝	 
code
˝	˝	 
=
˝	˝	 
new
˝	˝	 
Random
˝	˝	 %
(
˝	˝	% &
)
˝	˝	& '
.
˝	˝	' (
Next
˝	˝	( ,
(
˝	˝	, -
$num
˝	˝	- 3
,
˝	˝	3 4
$num
˝	˝	5 ;
)
˝	˝	; <
.
˝	˝	< =
ToString
˝	˝	= E
(
˝	˝	E F
)
˝	˝	F G
;
˝	˝	G H
_context
˛	˛	 
.
˛	˛	 
VerificationCodes
˛	˛	 *
.
˛	˛	* +
Add
˛	˛	+ .
(
˛	˛	. /
new
˛	˛	/ 2
VerificationCode
˛	˛	3 C
{
ˇ	ˇ	 
Email
Ä
Ä
 
=
Ä
Ä
 
user
Ä
Ä
  
.
Ä
Ä
  !
Email
Ä
Ä
! &
!
Ä
Ä
& '
,
Ä
Ä
' (
Code
Å
Å
 
=
Å
Å
 
code
Å
Å
 
,
Å
Å
  
	ExpiresAt
Ç
Ç
 
=
Ç
Ç
 
DateTime
Ç
Ç
  (
.
Ç
Ç
( )
UtcNow
Ç
Ç
) /
.
Ç
Ç
/ 0

AddMinutes
Ç
Ç
0 :
(
Ç
Ç
: ;
$num
Ç
Ç
; =
)
Ç
Ç
= >
}
É
É
 
)
É
É
 
;
É
É
 
await
Ñ
Ñ
 
_context
Ñ
Ñ
 
.
Ñ
Ñ
 
SaveChangesAsync
Ñ
Ñ
 /
(
Ñ
Ñ
/ 0
)
Ñ
Ñ
0 1
;
Ñ
Ñ
1 2
await
Ö
Ö
 
_emailService
Ö
Ö
 #
.
Ö
Ö
# $
SendEmailAsync
Ö
Ö
$ 2
(
Ö
Ö
2 3
user
Ö
Ö
3 7
.
Ö
Ö
7 8
Email
Ö
Ö
8 =
!
Ö
Ö
= >
,
Ö
Ö
> ?
$str
Ö
Ö
@ i
,
Ö
Ö
i j
$"
Ö
Ö
k m
$strÖ
Ö
m ¢
{Ö
Ö
¢ £
codeÖ
Ö
£ ß
}Ö
Ö
ß ®
"Ö
Ö
® ©
)Ö
Ö
© ™
;Ö
Ö
™ ´
return
á
á
 
Ok
á
á
 
(
á
á
 
new
á
á
 
{
á
á
 "
requiresVerification
á
á
  4
=
á
á
5 6
true
á
á
7 ;
,
á
á
; <
message
á
á
= D
=
á
á
E F
$str
á
á
G m
}
á
á
n o
)
á
á
o p
;
á
á
p q
}
à
à
 
else
â
â
 
{
ä
ä
 
user
å
å
 
.
å
å
 "
PinProtectionEnabled
å
å
 )
=
å
å
* +
true
å
å
, 0
;
å
å
0 1
await
ç
ç
 
_userManager
ç
ç
 "
.
ç
ç
" #
UpdateAsync
ç
ç
# .
(
ç
ç
. /
user
ç
ç
/ 3
)
ç
ç
3 4
;
ç
ç
4 5
return
é
é
 
Ok
é
é
 
(
é
é
 
new
é
é
 
{
é
é
 "
pinProtectionEnabled
é
é
  4
=
é
é
5 6
true
é
é
7 ;
}
é
é
< =
)
é
é
= >
;
é
é
> ?
}
è
è
 
}
ê
ê
 	
[
í
í
 	
HttpPost
í
í
	 
(
í
í
 
$str
í
í
 &
)
í
í
& '
]
í
í
' (
public
ì
ì
 
async
ì
ì
 
Task
ì
ì
 
<
ì
ì
 
IActionResult
ì
ì
 '
>
ì
ì
' (
VerifyDisablePin
ì
ì
) 9
(
ì
ì
9 :
[
ì
ì
: ;
FromBody
ì
ì
; C
]
ì
ì
C D
VerifyCodeRequest
ì
ì
E V
request
ì
ì
W ^
)
ì
ì
^ _
{
î
î
 	
var
ï
ï
 
userId
ï
ï
 
=
ï
ï
 
User
ï
ï
 
.
ï
ï
 
	FindFirst
ï
ï
 '
(
ï
ï
' (
System
ï
ï
( .
.
ï
ï
. /
Security
ï
ï
/ 7
.
ï
ï
7 8
Claims
ï
ï
8 >
.
ï
ï
> ?

ClaimTypes
ï
ï
? I
.
ï
ï
I J
NameIdentifier
ï
ï
J X
)
ï
ï
X Y
?
ï
ï
Y Z
.
ï
ï
Z [
Value
ï
ï
[ `
;
ï
ï
` a
var
ñ
ñ
 
user
ñ
ñ
 
=
ñ
ñ
 
await
ñ
ñ
 
_userManager
ñ
ñ
 )
.
ñ
ñ
) *
FindByIdAsync
ñ
ñ
* 7
(
ñ
ñ
7 8
userId
ñ
ñ
8 >
!
ñ
ñ
> ?
)
ñ
ñ
? @
;
ñ
ñ
@ A
if
ó
ó
 
(
ó
ó
 
user
ó
ó
 
==
ó
ó
 
null
ó
ó
 
)
ó
ó
 
return
ó
ó
 $
NotFound
ó
ó
% -
(
ó
ó
- .
new
ó
ó
. 1
{
ó
ó
2 3
message
ó
ó
4 ;
=
ó
ó
< =
$str
ó
ó
> N
}
ó
ó
O P
)
ó
ó
P Q
;
ó
ó
Q R
var
ô
ô
 
verification
ô
ô
 
=
ô
ô
 
await
ô
ô
 $
_context
ô
ô
% -
.
ô
ô
- .
VerificationCodes
ô
ô
. ?
.
ö
ö
 !
FirstOrDefaultAsync
ö
ö
 $
(
ö
ö
$ %
v
ö
ö
% &
=>
ö
ö
' )
v
ö
ö
* +
.
ö
ö
+ ,
Email
ö
ö
, 1
==
ö
ö
2 4
user
ö
ö
5 9
.
ö
ö
9 :
Email
ö
ö
: ?
&&
ö
ö
@ B
v
ö
ö
C D
.
ö
ö
D E
Code
ö
ö
E I
==
ö
ö
J L
request
ö
ö
M T
.
ö
ö
T U
Code
ö
ö
U Y
&&
ö
ö
Z \
!
ö
ö
] ^
v
ö
ö
^ _
.
ö
ö
_ `
IsUsed
ö
ö
` f
&&
ö
ö
g i
v
ö
ö
j k
.
ö
ö
k l
	ExpiresAt
ö
ö
l u
>
ö
ö
v w
DateTimeö
ö
x Ä
.ö
ö
Ä Å
UtcNowö
ö
Å á
)ö
ö
á à
;ö
ö
à â
if
õ
õ
 
(
õ
õ
 
verification
õ
õ
 
==
õ
õ
 
null
õ
õ
  $
)
õ
õ
$ %
return
õ
õ
& ,

BadRequest
õ
õ
- 7
(
õ
õ
7 8
new
õ
õ
8 ;
{
õ
õ
< =
message
õ
õ
> E
=
õ
õ
F G
$str
õ
õ
H a
}
õ
õ
b c
)
õ
õ
c d
;
õ
õ
d e
user
ù
ù
 
.
ù
ù
 "
PinProtectionEnabled
ù
ù
 %
=
ù
ù
& '
false
ù
ù
( -
;
ù
ù
- .
await
û
û
 
_userManager
û
û
 
.
û
û
 
UpdateAsync
û
û
 *
(
û
û
* +
user
û
û
+ /
)
û
û
/ 0
;
û
û
0 1
verification
ü
ü
 
.
ü
ü
 
IsUsed
ü
ü
 
=
ü
ü
  !
true
ü
ü
" &
;
ü
ü
& '
await
†
†
 
_context
†
†
 
.
†
†
 
SaveChangesAsync
†
†
 +
(
†
†
+ ,
)
†
†
, -
;
†
†
- .
return
¢
¢
 
Ok
¢
¢
 
(
¢
¢
 
new
¢
¢
 
{
¢
¢
 "
pinProtectionEnabled
¢
¢
 0
=
¢
¢
1 2
false
¢
¢
3 8
,
¢
¢
8 9
message
¢
¢
: A
=
¢
¢
B C
$str
¢
¢
D j
}
¢
¢
k l
)
¢
¢
l m
;
¢
¢
m n
}
£
£
 	
[
•
•
 	
HttpGet
•
•
	 
(
•
•
 
$str
•
•
 
)
•
•
 
]
•
•
 
public
¶
¶
 
async
¶
¶
 
Task
¶
¶
 
<
¶
¶
 
IActionResult
¶
¶
 '
>
¶
¶
' (
GetPinStatus
¶
¶
) 5
(
¶
¶
5 6
)
¶
¶
6 7
{
ß
ß
 	
var
®
®
 
userId
®
®
 
=
®
®
 
User
®
®
 
.
®
®
 
	FindFirst
®
®
 '
(
®
®
' (
System
®
®
( .
.
®
®
. /
Security
®
®
/ 7
.
®
®
7 8
Claims
®
®
8 >
.
®
®
> ?

ClaimTypes
®
®
? I
.
®
®
I J
NameIdentifier
®
®
J X
)
®
®
X Y
?
®
®
Y Z
.
®
®
Z [
Value
®
®
[ `
;
®
®
` a
var
©
©
 
user
©
©
 
=
©
©
 
await
©
©
 
_userManager
©
©
 )
.
©
©
) *
FindByIdAsync
©
©
* 7
(
©
©
7 8
userId
©
©
8 >
!
©
©
> ?
)
©
©
? @
;
©
©
@ A
if
™
™
 
(
™
™
 
user
™
™
 
==
™
™
 
null
™
™
 
)
™
™
 
return
™
™
 $
NotFound
™
™
% -
(
™
™
- .
new
™
™
. 1
{
™
™
2 3
message
™
™
4 ;
=
™
™
< =
$str
™
™
> N
}
™
™
O P
)
™
™
P Q
;
™
™
Q R
return
¨
¨
 
Ok
¨
¨
 
(
¨
¨
 
new
¨
¨
 
{
¨
¨
 "
pinProtectionEnabled
≠
≠
 $
=
≠
≠
% &
user
≠
≠
' +
.
≠
≠
+ ,"
PinProtectionEnabled
≠
≠
, @
,
≠
≠
@ A
	hasPinSet
Æ
Æ
 
=
Æ
Æ
 
!
Æ
Æ
 
string
Æ
Æ
 #
.
Æ
Æ
# $
IsNullOrEmpty
Æ
Æ
$ 1
(
Æ
Æ
1 2
user
Æ
Æ
2 6
.
Æ
Æ
6 7
SecurityPin
Æ
Æ
7 B
)
Æ
Æ
B C
}
Ø
Ø
 
)
Ø
Ø
 
;
Ø
Ø
 
}
∞
∞
 	
[
≤
≤
 	
HttpGet
≤
≤
	 
(
≤
≤
 
$str
≤
≤
 +
)
≤
≤
+ ,
]
≤
≤
, -
public
≥
≥
 
async
≥
≥
 
Task
≥
≥
 
<
≥
≥
 
IActionResult
≥
≥
 '
>
≥
≥
' ((
GetNotificationPreferences
≥
≥
) C
(
≥
≥
C D
)
≥
≥
D E
{
¥
¥
 	
var
µ
µ
 
userId
µ
µ
 
=
µ
µ
 
User
µ
µ
 
.
µ
µ
 
	FindFirst
µ
µ
 '
(
µ
µ
' (
System
µ
µ
( .
.
µ
µ
. /
Security
µ
µ
/ 7
.
µ
µ
7 8
Claims
µ
µ
8 >
.
µ
µ
> ?

ClaimTypes
µ
µ
? I
.
µ
µ
I J
NameIdentifier
µ
µ
J X
)
µ
µ
X Y
?
µ
µ
Y Z
.
µ
µ
Z [
Value
µ
µ
[ `
;
µ
µ
` a
var
∂
∂
 
preferences
∂
∂
 
=
∂
∂
 
await
∂
∂
 #
_context
∂
∂
$ ,
.
∂
∂
, -%
NotificationPreferences
∂
∂
- D
.
∑
∑
 
Where
∑
∑
 
(
∑
∑
 
np
∑
∑
 
=>
∑
∑
 
np
∑
∑
 
.
∑
∑
  
UserID
∑
∑
  &
==
∑
∑
' )
userId
∑
∑
* 0
)
∑
∑
0 1
.
∏
∏
 
ToDictionaryAsync
∏
∏
 "
(
∏
∏
" #
np
∏
∏
# %
=>
∏
∏
& (
np
∏
∏
) +
.
∏
∏
+ ,
NotificationType
∏
∏
, <
,
∏
∏
< =
np
∏
∏
> @
=>
∏
∏
A C
np
∏
∏
D F
.
∏
∏
F G
EmailEnabled
∏
∏
G S
)
∏
∏
S T
;
∏
∏
T U
return
π
π
 
Ok
π
π
 
(
π
π
 
preferences
π
π
 !
)
π
π
! "
;
π
π
" #
}
∫
∫
 	
[
º
º
 	
HttpPost
º
º
	 
(
º
º
 
$str
º
º
 ,
)
º
º
, -
]
º
º
- .
public
Ω
Ω
 
async
Ω
Ω
 
Task
Ω
Ω
 
<
Ω
Ω
 
IActionResult
Ω
Ω
 '
>
Ω
Ω
' (+
UpdateNotificationPreferences
Ω
Ω
) F
(
Ω
Ω
F G
[
Ω
Ω
G H
FromBody
Ω
Ω
H P
]
Ω
Ω
P Q

Dictionary
Ω
Ω
R \
<
Ω
Ω
\ ]
string
Ω
Ω
] c
,
Ω
Ω
c d
bool
Ω
Ω
e i
>
Ω
Ω
i j
preferences
Ω
Ω
k v
)
Ω
Ω
v w
{
æ
æ
 	
var
ø
ø
 
userId
ø
ø
 
=
ø
ø
 
User
ø
ø
 
.
ø
ø
 
	FindFirst
ø
ø
 '
(
ø
ø
' (
System
ø
ø
( .
.
ø
ø
. /
Security
ø
ø
/ 7
.
ø
ø
7 8
Claims
ø
ø
8 >
.
ø
ø
> ?

ClaimTypes
ø
ø
? I
.
ø
ø
I J
NameIdentifier
ø
ø
J X
)
ø
ø
X Y
?
ø
ø
Y Z
.
ø
ø
Z [
Value
ø
ø
[ `
;
ø
ø
` a
foreach
¡
¡
 
(
¡
¡
 
var
¡
¡
 
pref
¡
¡
 
in
¡
¡
  
preferences
¡
¡
! ,
)
¡
¡
, -
{
¬
¬
 
var
√
√
 
existing
√
√
 
=
√
√
 
await
√
√
 $
_context
√
√
% -
.
√
√
- .%
NotificationPreferences
√
√
. E
.
ƒ
ƒ
 !
FirstOrDefaultAsync
ƒ
ƒ
 (
(
ƒ
ƒ
( )
np
ƒ
ƒ
) +
=>
ƒ
ƒ
, .
np
ƒ
ƒ
/ 1
.
ƒ
ƒ
1 2
UserID
ƒ
ƒ
2 8
==
ƒ
ƒ
9 ;
userId
ƒ
ƒ
< B
&&
ƒ
ƒ
C E
np
ƒ
ƒ
F H
.
ƒ
ƒ
H I
NotificationType
ƒ
ƒ
I Y
==
ƒ
ƒ
Z \
pref
ƒ
ƒ
] a
.
ƒ
ƒ
a b
Key
ƒ
ƒ
b e
)
ƒ
ƒ
e f
;
ƒ
ƒ
f g
if
∆
∆
 
(
∆
∆
 
existing
∆
∆
 
!=
∆
∆
 
null
∆
∆
  $
)
∆
∆
$ %
{
«
«
 
existing
»
»
 
.
»
»
 
EmailEnabled
»
»
 )
=
»
»
* +
pref
»
»
, 0
.
»
»
0 1
Value
»
»
1 6
;
»
»
6 7
existing
…
…
 
.
…
…
 
	UpdatedAt
…
…
 &
=
…
…
' (
DateTime
…
…
) 1
.
…
…
1 2
UtcNow
…
…
2 8
;
…
…
8 9
}
 
 
 
else
À
À
 
{
Ã
Ã
 
_context
Õ
Õ
 
.
Õ
Õ
 %
NotificationPreferences
Õ
Õ
 4
.
Õ
Õ
4 5
Add
Õ
Õ
5 8
(
Õ
Õ
8 9
new
Õ
Õ
9 <$
NotificationPreference
Õ
Õ
= S
{
Œ
Œ
 
UserID
œ
œ
 
=
œ
œ
  
userId
œ
œ
! '
!
œ
œ
' (
,
œ
œ
( )
NotificationType
–
–
 (
=
–
–
) *
pref
–
–
+ /
.
–
–
/ 0
Key
–
–
0 3
,
–
–
3 4
EmailEnabled
—
—
 $
=
—
—
% &
pref
—
—
' +
.
—
—
+ ,
Value
—
—
, 1
}
“
“
 
)
“
“
 
;
“
“
 
}
”
”
 
}
‘
‘
 
await
÷
÷
 
_context
÷
÷
 
.
÷
÷
 
SaveChangesAsync
÷
÷
 +
(
÷
÷
+ ,
)
÷
÷
, -
;
÷
÷
- .
return
◊
◊
 
Ok
◊
◊
 
(
◊
◊
 
new
◊
◊
 
{
◊
◊
 
message
◊
◊
 #
=
◊
◊
$ %
$str
◊
◊
& U
}
◊
◊
V W
)
◊
◊
W X
;
◊
◊
X Y
}
ÿ
ÿ
 	
}
Ÿ
Ÿ
 
public
€
€
 

class
€
€
 "
UpdateProfileRequest
€
€
 %
{
‹
‹
 
public
›
›
 
string
›
›
 
	FirstName
›
›
 
{
›
›
  !
get
›
›
" %
;
›
›
% &
set
›
›
' *
;
›
›
* +
}
›
›
, -
=
›
›
. /
string
›
›
0 6
.
›
›
6 7
Empty
›
›
7 <
;
›
›
< =
public
ﬁ
ﬁ
 
string
ﬁ
ﬁ
 
LastName
ﬁ
ﬁ
 
{
ﬁ
ﬁ
  
get
ﬁ
ﬁ
! $
;
ﬁ
ﬁ
$ %
set
ﬁ
ﬁ
& )
;
ﬁ
ﬁ
) *
}
ﬁ
ﬁ
+ ,
=
ﬁ
ﬁ
- .
string
ﬁ
ﬁ
/ 5
.
ﬁ
ﬁ
5 6
Empty
ﬁ
ﬁ
6 ;
;
ﬁ
ﬁ
; <
public
ﬂ
ﬂ
 
string
ﬂ
ﬂ
 
?
ﬂ
ﬂ
 
Birthday
ﬂ
ﬂ
 
{
ﬂ
ﬂ
  !
get
ﬂ
ﬂ
" %
;
ﬂ
ﬂ
% &
set
ﬂ
ﬂ
' *
;
ﬂ
ﬂ
* +
}
ﬂ
ﬂ
, -
public
‡
‡
 
string
‡
‡
 
?
‡
‡
 
Address
‡
‡
 
{
‡
‡
  
get
‡
‡
! $
;
‡
‡
$ %
set
‡
‡
& )
;
‡
‡
) *
}
‡
‡
+ ,
}
·
·
 
public
„
„
 

class
„
„
 '
UpdateProfilePhotoRequest
„
„
 *
{
‰
‰
 
public
Â
Â
 
string
Â
Â
 
?
Â
Â
 
PhotoUrl
Â
Â
 
{
Â
Â
  !
get
Â
Â
" %
;
Â
Â
% &
set
Â
Â
' *
;
Â
Â
* +
}
Â
Â
, -
}
Ê
Ê
 
public
Ë
Ë
 

class
Ë
Ë
 !
CreateTicketRequest
Ë
Ë
 $
{
È
È
 
public
Í
Í
 
string
Í
Í
 
Subject
Í
Í
 
{
Í
Í
 
get
Í
Í
  #
;
Í
Í
# $
set
Í
Í
% (
;
Í
Í
( )
}
Í
Í
* +
=
Í
Í
, -
string
Í
Í
. 4
.
Í
Í
4 5
Empty
Í
Í
5 :
;
Í
Í
: ;
public
Î
Î
 
string
Î
Î
 
Description
Î
Î
 !
{
Î
Î
" #
get
Î
Î
$ '
;
Î
Î
' (
set
Î
Î
) ,
;
Î
Î
, -
}
Î
Î
. /
=
Î
Î
0 1
string
Î
Î
2 8
.
Î
Î
8 9
Empty
Î
Î
9 >
;
Î
Î
> ?
public
Ï
Ï
 
string
Ï
Ï
 
Category
Ï
Ï
 
{
Ï
Ï
  
get
Ï
Ï
! $
;
Ï
Ï
$ %
set
Ï
Ï
& )
;
Ï
Ï
) *
}
Ï
Ï
+ ,
=
Ï
Ï
- .
string
Ï
Ï
/ 5
.
Ï
Ï
5 6
Empty
Ï
Ï
6 ;
;
Ï
Ï
; <
public
Ì
Ì
 
string
Ì
Ì
 
Priority
Ì
Ì
 
{
Ì
Ì
  
get
Ì
Ì
! $
;
Ì
Ì
$ %
set
Ì
Ì
& )
;
Ì
Ì
) *
}
Ì
Ì
+ ,
=
Ì
Ì
- .
string
Ì
Ì
/ 5
.
Ì
Ì
5 6
Empty
Ì
Ì
6 ;
;
Ì
Ì
; <
public
Ó
Ó
 
string
Ó
Ó
 
?
Ó
Ó
 
AttachmentUrl
Ó
Ó
 $
{
Ó
Ó
% &
get
Ó
Ó
' *
;
Ó
Ó
* +
set
Ó
Ó
, /
;
Ó
Ó
/ 0
}
Ó
Ó
1 2
}
Ô
Ô
 
public
Ò
Ò
 

class
Ò
Ò
 "
CustomerReplyRequest
Ò
Ò
 %
{
Ú
Ú
 
public
Û
Û
 
string
Û
Û
 
Message
Û
Û
 
{
Û
Û
 
get
Û
Û
  #
;
Û
Û
# $
set
Û
Û
% (
;
Û
Û
( )
}
Û
Û
* +
=
Û
Û
, -
string
Û
Û
. 4
.
Û
Û
4 5
Empty
Û
Û
5 :
;
Û
Û
: ;
}
Ù
Ù
 
public
ˆ
ˆ
 

class
ˆ
ˆ
  
UpgradePlanRequest
ˆ
ˆ
 #
{
˜
˜
 
public
¯
¯
 
int
¯
¯
 
SubscriptionId
¯
¯
 !
{
¯
¯
" #
get
¯
¯
$ '
;
¯
¯
' (
set
¯
¯
) ,
;
¯
¯
, -
}
¯
¯
. /
public
˘
˘
 
int
˘
˘
 
	NewPlanId
˘
˘
 
{
˘
˘
 
get
˘
˘
 "
;
˘
˘
" #
set
˘
˘
$ '
;
˘
˘
' (
}
˘
˘
) *
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
 (
CreatePaymentIntentRequest
¸
¸
 +
{
˝
˝
 
public
˛
˛
 
int
˛
˛
 
	InvoiceId
˛
˛
 
{
˛
˛
 
get
˛
˛
 "
;
˛
˛
" #
set
˛
˛
$ '
;
˛
˛
' (
}
˛
˛
) *
}
ˇ
ˇ
 
public
ÅÅ 

class
ÅÅ #
ProcessPaymentRequest
ÅÅ &
{
ÇÇ 
public
ÉÉ 
int
ÉÉ 
	InvoiceId
ÉÉ 
{
ÉÉ 
get
ÉÉ "
;
ÉÉ" #
set
ÉÉ$ '
;
ÉÉ' (
}
ÉÉ) *
public
ÑÑ 
string
ÑÑ 
PaymentMethod
ÑÑ #
{
ÑÑ$ %
get
ÑÑ& )
;
ÑÑ) *
set
ÑÑ+ .
;
ÑÑ. /
}
ÑÑ0 1
=
ÑÑ2 3
string
ÑÑ4 :
.
ÑÑ: ;
Empty
ÑÑ; @
;
ÑÑ@ A
public
ÖÖ 
string
ÖÖ 
?
ÖÖ 
PaymentIntentId
ÖÖ &
{
ÖÖ' (
get
ÖÖ) ,
;
ÖÖ, -
set
ÖÖ. 1
;
ÖÖ1 2
}
ÖÖ3 4
public
ÜÜ 
string
ÜÜ 
?
ÜÜ 

CardNumber
ÜÜ !
{
ÜÜ" #
get
ÜÜ$ '
;
ÜÜ' (
set
ÜÜ) ,
;
ÜÜ, -
}
ÜÜ. /
public
áá 
int
áá 
ExpMonth
áá 
{
áá 
get
áá !
;
áá! "
set
áá# &
;
áá& '
}
áá( )
public
àà 
int
àà 
ExpYear
àà 
{
àà 
get
àà  
;
àà  !
set
àà" %
;
àà% &
}
àà' (
public
ââ 
string
ââ 
?
ââ 
Cvc
ââ 
{
ââ 
get
ââ  
;
ââ  !
set
ââ" %
;
ââ% &
}
ââ' (
}
ää 
public
åå 

class
åå &
SavePaymentMethodRequest
åå )
{
çç 
public
éé 
string
éé 

CardNumber
éé  
{
éé! "
get
éé# &
;
éé& '
set
éé( +
;
éé+ ,
}
éé- .
=
éé/ 0
string
éé1 7
.
éé7 8
Empty
éé8 =
;
éé= >
public
èè 
int
èè 
ExpMonth
èè 
{
èè 
get
èè !
;
èè! "
set
èè# &
;
èè& '
}
èè( )
public
êê 
int
êê 
ExpYear
êê 
{
êê 
get
êê  
;
êê  !
set
êê" %
;
êê% &
}
êê' (
public
ëë 
string
ëë 
Cvc
ëë 
{
ëë 
get
ëë 
;
ëë  
set
ëë! $
;
ëë$ %
}
ëë& '
=
ëë( )
string
ëë* 0
.
ëë0 1
Empty
ëë1 6
;
ëë6 7
public
íí 
bool
íí 
	IsDefault
íí 
{
íí 
get
íí  #
;
íí# $
set
íí% (
;
íí( )
}
íí* +
}
ìì 
public
ïï 

class
ïï $
SaveGCashMethodRequest
ïï '
{
ññ 
public
óó 
string
óó 
PhoneNumber
óó !
{
óó" #
get
óó$ '
;
óó' (
set
óó) ,
;
óó, -
}
óó. /
=
óó0 1
string
óó2 8
.
óó8 9
Empty
óó9 >
;
óó> ?
public
òò 
bool
òò 
	IsDefault
òò 
{
òò 
get
òò  #
;
òò# $
set
òò% (
;
òò( )
}
òò* +
}
ôô 
public
õõ 

class
õõ '
ConfirmGCashMethodRequest
õõ *
{
úú 
public
ùù 
string
ùù 
PhoneNumber
ùù !
{
ùù" #
get
ùù$ '
;
ùù' (
set
ùù) ,
;
ùù, -
}
ùù. /
=
ùù0 1
string
ùù2 8
.
ùù8 9
Empty
ùù9 >
;
ùù> ?
public
ûû 
bool
ûû 
	IsDefault
ûû 
{
ûû 
get
ûû  #
;
ûû# $
set
ûû% (
;
ûû( )
}
ûû* +
}
üü 
public
°° 

class
°° 
AddAddonRequest
°°  
{
¢¢ 
public
££ 
int
££ 
AddonId
££ 
{
££ 
get
££  
;
££  !
set
££" %
;
££% &
}
££' (
}
§§ 
public
¶¶ 

class
¶¶ 
UpdateNameRequest
¶¶ "
{
ßß 
public
®® 
string
®® 

DeviceName
®®  
{
®®! "
get
®®# &
;
®®& '
set
®®( +
;
®®+ ,
}
®®- .
=
®®/ 0
string
®®1 7
.
®®7 8
Empty
®®8 =
;
®®= >
}
©© 
public
´´ 

class
´´ #
ChangePasswordRequest
´´ &
{
¨¨ 
public
≠≠ 
string
≠≠ 
CurrentPassword
≠≠ %
{
≠≠& '
get
≠≠( +
;
≠≠+ ,
set
≠≠- 0
;
≠≠0 1
}
≠≠2 3
=
≠≠4 5
string
≠≠6 <
.
≠≠< =
Empty
≠≠= B
;
≠≠B C
public
ÆÆ 
string
ÆÆ 
NewPassword
ÆÆ !
{
ÆÆ" #
get
ÆÆ$ '
;
ÆÆ' (
set
ÆÆ) ,
;
ÆÆ, -
}
ÆÆ. /
=
ÆÆ0 1
string
ÆÆ2 8
.
ÆÆ8 9
Empty
ÆÆ9 >
;
ÆÆ> ?
}
ØØ 
public
±± 

class
±± 
VerifyCodeRequest
±± "
{
≤≤ 
public
≥≥ 
string
≥≥ 
Code
≥≥ 
{
≥≥ 
get
≥≥  
;
≥≥  !
set
≥≥" %
;
≥≥% &
}
≥≥' (
=
≥≥) *
string
≥≥+ 1
.
≥≥1 2
Empty
≥≥2 7
;
≥≥7 8
}
¥¥ 
public
∂∂ 

class
∂∂ 
SetPinRequest
∂∂ 
{
∑∑ 
public
∏∏ 
string
∏∏ 
Pin
∏∏ 
{
∏∏ 
get
∏∏ 
;
∏∏  
set
∏∏! $
;
∏∏$ %
}
∏∏& '
=
∏∏( )
string
∏∏* 0
.
∏∏0 1
Empty
∏∏1 6
;
∏∏6 7
}
ππ 
public
ªª 

class
ªª 
VerifyPinRequest
ªª !
{
ºº 
public
ΩΩ 
string
ΩΩ 
Pin
ΩΩ 
{
ΩΩ 
get
ΩΩ 
;
ΩΩ  
set
ΩΩ! $
;
ΩΩ$ %
}
ΩΩ& '
=
ΩΩ( )
string
ΩΩ* 0
.
ΩΩ0 1
Empty
ΩΩ1 6
;
ΩΩ6 7
}
ææ 
public
¿¿ 

class
¿¿ 
TopUpRequest
¿¿ 
{
¡¡ 
public
¬¬ 
decimal
¬¬ 
Amount
¬¬ 
{
¬¬ 
get
¬¬  #
;
¬¬# $
set
¬¬% (
;
¬¬( )
}
¬¬* +
}
√√ 
public
≈≈ 

class
≈≈ 
BuyPromoRequest
≈≈  
{
∆∆ 
public
«« 
decimal
«« 
Amount
«« 
{
«« 
get
««  #
;
««# $
set
««% (
;
««( )
}
««* +
public
»» 
string
»» 
?
»» 

PromoTitle
»» !
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
»». /
public
…… 
string
…… 
?
…… 
	PromoData
……  
{
……! "
get
……# &
;
……& '
set
……( +
;
……+ ,
}
……- .
public
   
string
   
?
   
PromoValidity
   $
{
  % &
get
  ' *
;
  * +
set
  , /
;
  / 0
}
  1 2
}
ÀÀ 
}ÃÃ ’–
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
private 
readonly 
UserManager $
<$ %
ApplicationUser% 4
>4 5
_userManager6 B
;B C
private 
readonly 
TokenService %
_tokenService& 3
;3 4
private 
readonly 
EmailService %
_emailService& 3
;3 4
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
private 
readonly 
IConfiguration '
_configuration( 6
;6 7
private 
readonly 
IHttpClientFactory +
_httpClientFactory, >
;> ?
private 
readonly 
LoginAttemptService , 
_loginAttemptService- A
;A B
private 
readonly %
IpDeviceReputationService 2&
_ipDeviceReputationService3 M
;M N
private 
readonly !
PasswordBreachService ."
_passwordBreachService/ E
;E F
public 
AuthController 
( 
UserManager   
<   
ApplicationUser   '
>  ' (
userManager  ) 4
,  4 5
TokenService!! 
tokenService!! %
,!!% &
EmailService"" 
emailService"" %
,""% & 
ApplicationDbContext##  
context##! (
,##( )
IConfiguration$$ 
configuration$$ (
,$$( )
IHttpClientFactory%% 
httpClientFactory%% 0
,%%0 1
LoginAttemptService&& 
loginAttemptService&&  3
,&&3 4%
IpDeviceReputationService'' %%
ipDeviceReputationService''& ?
,''? @!
PasswordBreachService(( !!
passwordBreachService((" 7
)((7 8
{)) 	
_userManager** 
=** 
userManager** &
;**& '
_tokenService++ 
=++ 
tokenService++ (
;++( )
_emailService,, 
=,, 
emailService,, (
;,,( )
_context-- 
=-- 
context-- 
;-- 
_configuration.. 
=.. 
configuration.. *
;..* +
_httpClientFactory// 
=//  
httpClientFactory//! 2
;//2 3 
_loginAttemptService00  
=00! "
loginAttemptService00# 6
;006 7&
_ipDeviceReputationService11 &
=11' (%
ipDeviceReputationService11) B
;11B C"
_passwordBreachService22 "
=22# $!
passwordBreachService22% :
;22: ;
}33 	
[55 	
HttpPost55	 
(55 
$str55 
)55 
]55 
public66 
async66 
Task66 
<66 
IActionResult66 '
>66' (
Register66) 1
(661 2
[662 3
FromBody663 ;
]66; <
RegisterRequest66= L
request66M T
)66T U
{77 	
try88 
{99 
var:: 
	userAgent:: 
=:: 
Request::  '
.::' (
Headers::( /
[::/ 0
$str::0 <
]::< =
.::= >
ToString::> F
(::F G
)::G H
;::H I
var;; 
	ipAddress;; 
=;; 
HttpContext;;  +
.;;+ ,

Connection;;, 6
.;;6 7
RemoteIpAddress;;7 F
?;;F G
.;;G H
ToString;;H P
(;;P Q
);;Q R
;;;R S
if<< 
(<< &
_ipDeviceReputationService<< .
.<<. /
	IsBlocked<</ 8
(<<8 9
	ipAddress<<9 B
,<<B C
	userAgent<<D M
,<<M N
out<<O R
var<<S V
blockReason<<W b
)<<b c
)<<c d
return== 

StatusCode== %
(==% &
$num==& )
,==) *
new==+ .
{==/ 0
message==1 8
===9 :
$"==; =
$str=== M
{==M N
blockReason==N Y
}==Y Z
$str==Z s
"==s t
}==u v
)==v w
;==w x
if?? 
(?? 
!?? 
await??  
VerifyReCaptchaAsync?? /
(??/ 0
request??0 7
.??7 8
CaptchaToken??8 D
)??D E
)??E F
return@@ 

BadRequest@@ %
(@@% &
new@@& )
{@@* +
message@@, 3
=@@4 5
$str@@6 S
}@@T U
)@@U V
;@@V W
ifBB 
(BB 
!BB 
requestBB 
.BB 
EmailBB "
.BB" #
EndsWithBB# +
(BB+ ,
$strBB, 8
,BB8 9
StringComparisonBB: J
.BBJ K
OrdinalIgnoreCaseBBK \
)BB\ ]
)BB] ^
returnCC 

BadRequestCC %
(CC% &
newCC& )
{CC* +
messageCC, 3
=CC4 5
$strCC6 X
}CCY Z
)CCZ [
;CC[ \
ifEE 
(EE 
awaitEE "
_passwordBreachServiceEE 0
.EE0 1
IsBreachedAsyncEE1 @
(EE@ A
requestEEA H
.EEH I
PasswordEEI Q
)EEQ R
)EER S
returnFF 

BadRequestFF %
(FF% &
newFF& )
{FF* +
messageFF, 3
=FF4 5
$str	FF6 Ä
}
FFÅ Ç
)
FFÇ É
;
FFÉ Ñ
varHH 
existingUserHH  
=HH! "
awaitHH# (
_userManagerHH) 5
.HH5 6
FindByEmailAsyncHH6 F
(HHF G
requestHHG N
.HHN O
EmailHHO T
)HHT U
;HHU V
ifII 
(II 
existingUserII  
!=II! #
nullII$ (
)II( )
returnJJ 

BadRequestJJ %
(JJ% &
newJJ& )
{JJ* +
messageJJ, 3
=JJ4 5
$strJJ6 s
}JJt u
)JJu v
;JJv w
varLL 
userLL 
=LL 
newLL 
ApplicationUserLL .
{MM 
UserNameNN 
=NN 
requestNN &
.NN& '
EmailNN' ,
,NN, -
EmailOO 
=OO 
requestOO #
.OO# $
EmailOO$ )
,OO) *
	FirstNamePP 
=PP 
requestPP  '
.PP' (
	FirstNamePP( 1
,PP1 2
LastNameQQ 
=QQ 
requestQQ &
.QQ& '
LastNameQQ' /
,QQ/ 0
BirthdayRR 
=RR 
requestRR &
.RR& '
BirthdayRR' /
,RR/ 0
AddressSS 
=SS 
requestSS %
.SS% &
AddressSS& -
,SS- .
StatusTT 
=TT 
$strTT &
}UU 
;UU 
varVV 
resultVV 
=VV 
awaitVV "
_userManagerVV# /
.VV/ 0
CreateAsyncVV0 ;
(VV; <
userVV< @
,VV@ A
requestVVB I
.VVI J
PasswordVVJ R
)VVR S
;VVS T
ifXX 
(XX 
!XX 
resultXX 
.XX 
	SucceededXX %
)XX% &
{YY 
varZZ 
errorsZZ 
=ZZ  
stringZZ! '
.ZZ' (
JoinZZ( ,
(ZZ, -
$strZZ- 1
,ZZ1 2
resultZZ3 9
.ZZ9 :
ErrorsZZ: @
.ZZ@ A
SelectZZA G
(ZZG H
eZZH I
=>ZZJ L
eZZM N
.ZZN O
DescriptionZZO Z
)ZZZ [
)ZZ[ \
;ZZ\ ]
return[[ 

BadRequest[[ %
([[% &
new[[& )
{[[* +
message[[, 3
=[[4 5
errors[[6 <
}[[= >
)[[> ?
;[[? @
}\\ 
var^^ 
code^^ 
=^^ 
new^^ 
Random^^ %
(^^% &
)^^& '
.^^' (
Next^^( ,
(^^, -
$num^^- 3
,^^3 4
$num^^5 ;
)^^; <
.^^< =
ToString^^= E
(^^E F
)^^F G
;^^G H
_context__ 
.__ 
VerificationCodes__ *
.__* +
Add__+ .
(__. /
new__/ 2
VerificationCode__3 C
{`` 
Emailaa 
=aa 
requestaa #
.aa# $
Emailaa$ )
,aa) *
Codebb 
=bb 
codebb 
,bb  
	ExpiresAtcc 
=cc 
DateTimecc  (
.cc( )
UtcNowcc) /
.cc/ 0

AddMinutescc0 :
(cc: ;
$numcc; =
)cc= >
}dd 
)dd 
;dd 
_contextff 
.ff 
OnboardingStatusesff +
.ff+ ,
Addff, /
(ff/ 0
newff0 3
OnboardingStatusff4 D
{gg 
UserIDhh 
=hh 
userhh !
.hh! "
Idhh" $
}ii 
)ii 
;ii 
awaitkk 
_contextkk 
.kk 
SaveChangesAsynckk /
(kk/ 0
)kk0 1
;kk1 2
awaitll 
_emailServicell #
.ll# $%
SendVerificationCodeAsyncll$ =
(ll= >
requestll> E
.llE F
EmailllF K
,llK L
codellM Q
)llQ R
;llR S
awaitnn 
LogActivityAsyncnn &
(nn& '
usernn' +
.nn+ ,
Idnn, .
,nn. /
$strnn0 D
,nnD E
$strnnF N
)nnN O
;nnO P&
_ipDeviceReputationServicepp *
.pp* +
RegisterSuccesspp+ :
(pp: ;
	ipAddresspp; D
,ppD E
	userAgentppF O
)ppO P
;ppP Q
returnrr 
Okrr 
(rr 
newrr 
{rr 
messagerr  '
=rr( )
$strrr* s
}rrt u
)rru v
;rrv w
}ss 
catchtt 
(tt 
	Exceptiontt 
extt 
)tt  
{uu 
returnvv 

BadRequestvv !
(vv! "
newvv" %
{vv& '
messagevv( /
=vv0 1
$"vv2 4
$strvv4 I
{vvI J
exvvJ L
.vvL M
MessagevvM T
}vvT U
"vvU V
}vvW X
)vvX Y
;vvY Z
}ww 
}xx 	
[zz 	
HttpPostzz	 
(zz 
$strzz  
)zz  !
]zz! "
public{{ 
async{{ 
Task{{ 
<{{ 
IActionResult{{ '
>{{' (
VerifyEmail{{) 4
({{4 5
[{{5 6
FromBody{{6 >
]{{> ?
VerifyEmailRequest{{@ R
request{{S Z
){{Z [
{|| 	
var}} 
verification}} 
=}} 
await}} $
_context}}% -
.}}- .
VerificationCodes}}. ?
.~~ 
FirstOrDefaultAsync~~ $
(~~$ %
v~~% &
=>~~' )
v~~* +
.~~+ ,
Email~~, 1
==~~2 4
request~~5 <
.~~< =
Email~~= B
&&~~C E
v~~F G
.~~G H
Code~~H L
==~~M O
request~~P W
.~~W X
Code~~X \
&&~~] _
!~~` a
v~~a b
.~~b c
IsUsed~~c i
&&~~j l
v~~m n
.~~n o
	ExpiresAt~~o x
>~~y z
DateTime	~~{ É
.
~~É Ñ
UtcNow
~~Ñ ä
)
~~ä ã
;
~~ã å
if
ÄÄ 
(
ÄÄ 
verification
ÄÄ 
==
ÄÄ 
null
ÄÄ  $
)
ÄÄ$ %
return
ÅÅ 

BadRequest
ÅÅ !
(
ÅÅ! "
new
ÅÅ" %
{
ÅÅ& '
message
ÅÅ( /
=
ÅÅ0 1
$str
ÅÅ2 X
}
ÅÅY Z
)
ÅÅZ [
;
ÅÅ[ \
var
ÉÉ 
user
ÉÉ 
=
ÉÉ 
await
ÉÉ 
_userManager
ÉÉ )
.
ÉÉ) *
FindByEmailAsync
ÉÉ* :
(
ÉÉ: ;
request
ÉÉ; B
.
ÉÉB C
Email
ÉÉC H
)
ÉÉH I
;
ÉÉI J
if
ÑÑ 
(
ÑÑ 
user
ÑÑ 
==
ÑÑ 
null
ÑÑ 
)
ÑÑ 
return
ÖÖ 
NotFound
ÖÖ 
(
ÖÖ  
new
ÖÖ  #
{
ÖÖ$ %
message
ÖÖ& -
=
ÖÖ. /
$str
ÖÖ0 @
}
ÖÖA B
)
ÖÖB C
;
ÖÖC D
user
áá 
.
áá 
EmailConfirmed
áá 
=
áá  !
true
áá" &
;
áá& '
user
àà 
.
àà 
Status
àà 
=
àà 
$str
àà "
;
àà" #
await
ââ 
_userManager
ââ 
.
ââ 
UpdateAsync
ââ *
(
ââ* +
user
ââ+ /
)
ââ/ 0
;
ââ0 1
verification
ãã 
.
ãã 
IsUsed
ãã 
=
ãã  !
true
ãã" &
;
ãã& '
var
çç 

onboarding
çç 
=
çç 
await
çç "
_context
çç# +
.
çç+ , 
OnboardingStatuses
çç, >
.
çç> ?!
FirstOrDefaultAsync
çç? R
(
ççR S
o
ççS T
=>
ççU W
o
ççX Y
.
ççY Z
UserID
ççZ `
==
çça c
user
ççd h
.
ççh i
Id
ççi k
)
ççk l
;
ççl m
if
éé 
(
éé 

onboarding
éé 
!=
éé 
null
éé "
)
éé" #

onboarding
èè 
.
èè 
IsEmailVerified
èè *
=
èè+ ,
true
èè- 1
;
èè1 2
await
ëë 
_context
ëë 
.
ëë 
SaveChangesAsync
ëë +
(
ëë+ ,
)
ëë, -
;
ëë- .
return
ìì 
Ok
ìì 
(
ìì 
new
ìì 
{
ìì 
message
ìì #
=
ìì$ %
$str
ìì& C
}
ììD E
)
ììE F
;
ììF G
}
îî 	
[
ññ 	
HttpPost
ññ	 
(
ññ 
$str
ññ 
)
ññ  
]
ññ  !
public
óó 
async
óó 
Task
óó 
<
óó 
IActionResult
óó '
>
óó' (

ResendCode
óó) 3
(
óó3 4
[
óó4 5
FromBody
óó5 =
]
óó= >
string
óó? E
email
óóF K
)
óóK L
{
òò 	
var
ôô 
code
ôô 
=
ôô 
new
ôô 
Random
ôô !
(
ôô! "
)
ôô" #
.
ôô# $
Next
ôô$ (
(
ôô( )
$num
ôô) /
,
ôô/ 0
$num
ôô1 7
)
ôô7 8
.
ôô8 9
ToString
ôô9 A
(
ôôA B
)
ôôB C
;
ôôC D
_context
öö 
.
öö 
VerificationCodes
öö &
.
öö& '
Add
öö' *
(
öö* +
new
öö+ .
VerificationCode
öö/ ?
{
õõ 
Email
úú 
=
úú 
email
úú 
,
úú 
Code
ùù 
=
ùù 
code
ùù 
,
ùù 
	ExpiresAt
ûû 
=
ûû 
DateTime
ûû $
.
ûû$ %
UtcNow
ûû% +
.
ûû+ ,

AddMinutes
ûû, 6
(
ûû6 7
$num
ûû7 9
)
ûû9 :
}
üü 
)
üü 
;
üü 
await
†† 
_context
†† 
.
†† 
SaveChangesAsync
†† +
(
††+ ,
)
††, -
;
††- .
await
°° 
_emailService
°° 
.
°°  '
SendVerificationCodeAsync
°°  9
(
°°9 :
email
°°: ?
,
°°? @
code
°°A E
)
°°E F
;
°°F G
return
££ 
Ok
££ 
(
££ 
new
££ 
{
££ 
message
££ #
=
££$ %
$str
££& >
}
££? @
)
££@ A
;
££A B
}
§§ 	
[
¶¶ 	
HttpPost
¶¶	 
(
¶¶ 
$str
¶¶ 
)
¶¶ 
]
¶¶ 
public
ßß 
async
ßß 
Task
ßß 
<
ßß 
IActionResult
ßß '
>
ßß' (
Login
ßß) .
(
ßß. /
[
ßß/ 0
FromBody
ßß0 8
]
ßß8 9
LoginRequest
ßß: F
request
ßßG N
)
ßßN O
{
®® 	
var
©© 
	userAgent
©© 
=
©© 
Request
©© #
.
©©# $
Headers
©©$ +
[
©©+ ,
$str
©©, 8
]
©©8 9
.
©©9 :
ToString
©©: B
(
©©B C
)
©©C D
;
©©D E
var
™™ 
	ipAddress
™™ 
=
™™ 
HttpContext
™™ '
.
™™' (

Connection
™™( 2
.
™™2 3
RemoteIpAddress
™™3 B
?
™™B C
.
™™C D
ToString
™™D L
(
™™L M
)
™™M N
;
™™N O
if
´´ 
(
´´ (
_ipDeviceReputationService
´´ *
.
´´* +
	IsBlocked
´´+ 4
(
´´4 5
	ipAddress
´´5 >
,
´´> ?
	userAgent
´´@ I
,
´´I J
out
´´K N
var
´´O R
blockReason
´´S ^
)
´´^ _
)
´´_ `
return
¨¨ 

StatusCode
¨¨ !
(
¨¨! "
$num
¨¨" %
,
¨¨% &
new
¨¨' *
{
¨¨+ ,
message
¨¨- 4
=
¨¨5 6
$"
¨¨7 9
$str
¨¨9 I
{
¨¨I J
blockReason
¨¨J U
}
¨¨U V
$str
¨¨V o
"
¨¨o p
}
¨¨q r
)
¨¨r s
;
¨¨s t
if
ÆÆ 
(
ÆÆ 
!
ÆÆ 
await
ÆÆ "
VerifyReCaptchaAsync
ÆÆ +
(
ÆÆ+ ,
request
ÆÆ, 3
.
ÆÆ3 4
CaptchaToken
ÆÆ4 @
)
ÆÆ@ A
)
ÆÆA B
return
ØØ 

BadRequest
ØØ !
(
ØØ! "
new
ØØ" %
{
ØØ& '
message
ØØ( /
=
ØØ0 1
$str
ØØ2 O
}
ØØP Q
)
ØØQ R
;
ØØR S
var
±± 
user
±± 
=
±± 
await
±± 
_userManager
±± )
.
±±) *
FindByEmailAsync
±±* :
(
±±: ;
request
±±; B
.
±±B C
Email
±±C H
)
±±H I
;
±±I J
if
≤≤ 
(
≤≤ 
user
≤≤ 
==
≤≤ 
null
≤≤ 
)
≤≤ 
{
≥≥ (
_ipDeviceReputationService
¥¥ *
.
¥¥* +
RegisterFailure
¥¥+ :
(
¥¥: ;
	ipAddress
¥¥; D
,
¥¥D E
	userAgent
¥¥F O
)
¥¥O P
;
¥¥P Q
return
µµ 
Unauthorized
µµ #
(
µµ# $
new
µµ$ '
{
µµ( )
message
µµ* 1
=
µµ2 3
$str
µµ4 I
}
µµJ K
)
µµK L
;
µµL M
}
∂∂ 
var
ππ 
lockoutCheck
ππ 
=
ππ 
await
ππ $"
_loginAttemptService
ππ% 9
.
ππ9 :$
CheckLoginAttemptAsync
ππ: P
(
ππP Q
user
ππQ U
.
ππU V
Id
ππV X
)
ππX Y
;
ππY Z
if
∫∫ 
(
∫∫ 
lockoutCheck
∫∫ 
.
∫∫ 
isLocked
∫∫ %
)
∫∫% &
return
ªª 
Unauthorized
ªª #
(
ªª# $
new
ªª$ '
{
ªª( )
message
ªª* 1
=
ªª2 3
$"
ªª4 6
$str
ªª6 y
{
ªªy z
lockoutCheckªªz Ü
.ªªÜ á
messageªªá é
}ªªé è
"ªªè ê
}ªªë í
)ªªí ì
;ªªì î
if
ΩΩ 
(
ΩΩ 
!
ΩΩ 
await
ΩΩ 
_userManager
ΩΩ #
.
ΩΩ# $ 
CheckPasswordAsync
ΩΩ$ 6
(
ΩΩ6 7
user
ΩΩ7 ;
,
ΩΩ; <
request
ΩΩ= D
.
ΩΩD E
Password
ΩΩE M
)
ΩΩM N
)
ΩΩN O
{
ææ 
await
¿¿ "
_loginAttemptService
¿¿ *
.
¿¿* +&
RecordFailedAttemptAsync
¿¿+ C
(
¿¿C D
user
¿¿D H
.
¿¿H I
Id
¿¿I K
)
¿¿K L
;
¿¿L M(
_ipDeviceReputationService
¡¡ *
.
¡¡* +
RegisterFailure
¡¡+ :
(
¡¡: ;
	ipAddress
¡¡; D
,
¡¡D E
	userAgent
¡¡F O
)
¡¡O P
;
¡¡P Q
return
¬¬ 
Unauthorized
¬¬ #
(
¬¬# $
new
¬¬$ '
{
¬¬( )
message
¬¬* 1
=
¬¬2 3
$str
¬¬4 I
}
¬¬J K
)
¬¬K L
;
¬¬L M
}
√√ 
if
≈≈ 
(
≈≈ 
!
≈≈ 
user
≈≈ 
.
≈≈ 
EmailConfirmed
≈≈ $
)
≈≈$ %
{
∆∆ 
var
»» 
code
»» 
=
»» 
new
»» 
Random
»» %
(
»»% &
)
»»& '
.
»»' (
Next
»»( ,
(
»», -
$num
»»- 3
,
»»3 4
$num
»»5 ;
)
»»; <
.
»»< =
ToString
»»= E
(
»»E F
)
»»F G
;
»»G H
_context
…… 
.
…… 
VerificationCodes
…… *
.
……* +
Add
……+ .
(
……. /
new
……/ 2
VerificationCode
……3 C
{
   
Email
ÀÀ 
=
ÀÀ 
request
ÀÀ #
.
ÀÀ# $
Email
ÀÀ$ )
,
ÀÀ) *
Code
ÃÃ 
=
ÃÃ 
code
ÃÃ 
,
ÃÃ  
	ExpiresAt
ÕÕ 
=
ÕÕ 
DateTime
ÕÕ  (
.
ÕÕ( )
UtcNow
ÕÕ) /
.
ÕÕ/ 0

AddMinutes
ÕÕ0 :
(
ÕÕ: ;
$num
ÕÕ; =
)
ÕÕ= >
}
ŒŒ 
)
ŒŒ 
;
ŒŒ 
await
œœ 
_context
œœ 
.
œœ 
SaveChangesAsync
œœ /
(
œœ/ 0
)
œœ0 1
;
œœ1 2
await
–– 
_emailService
–– #
.
––# $'
SendVerificationCodeAsync
––$ =
(
––= >
request
––> E
.
––E F
Email
––F K
,
––K L
code
––M Q
)
––Q R
;
––R S
return
““ 
Ok
““ 
(
““ 
new
““ 
{
““ '
requiresEmailVerification
”” -
=
””. /
true
””0 4
,
””4 5
email
‘‘ 
=
‘‘ 
request
‘‘ #
.
‘‘# $
Email
‘‘$ )
,
‘‘) *
message
’’ 
=
’’ 
$str
’’ f
}
÷÷ 
)
÷÷ 
;
÷÷ 
}
◊◊ 
if
ŸŸ 
(
ŸŸ 
user
ŸŸ 
.
ŸŸ 
Status
ŸŸ 
==
ŸŸ 
$str
ŸŸ *
)
ŸŸ* +
return
⁄⁄ 
Unauthorized
⁄⁄ #
(
⁄⁄# $
new
⁄⁄$ '
{
⁄⁄( )
message
⁄⁄* 1
=
⁄⁄2 3
$str
⁄⁄4 n
}
⁄⁄o p
)
⁄⁄p q
;
⁄⁄q r
var
‹‹ 
roles
‹‹ 
=
‹‹ 
await
‹‹ 
_userManager
‹‹ *
.
‹‹* +
GetRolesAsync
‹‹+ 8
(
‹‹8 9
user
‹‹9 =
)
‹‹= >
;
‹‹> ?
var
›› 
role
›› 
=
›› 
roles
›› 
.
›› 
FirstOrDefault
›› +
(
››+ ,
)
››, -
??
››. 0
user
››1 5
.
››5 6
Role
››6 :
;
››: ;
if
ﬂﬂ 
(
ﬂﬂ 
(
ﬂﬂ 
role
ﬂﬂ 
==
ﬂﬂ 
$str
ﬂﬂ  
||
ﬂﬂ! #
role
ﬂﬂ$ (
==
ﬂﬂ) +
$str
ﬂﬂ, 3
||
ﬂﬂ4 6
role
ﬂﬂ7 ;
==
ﬂﬂ< >
$str
ﬂﬂ? K
)
ﬂﬂK L
&&
ﬂﬂM O
user
ﬂﬂP T
.
ﬂﬂT U
Status
ﬂﬂU [
==
ﬂﬂ\ ^
$str
ﬂﬂ_ i
)
ﬂﬂi j
return
‡‡ 
Unauthorized
‡‡ #
(
‡‡# $
new
‡‡$ '
{
‡‡( )
message
‡‡* 1
=
‡‡2 3
$str
‡‡4 m
}
‡‡n o
)
‡‡o p
;
‡‡p q
var
‚‚ 
dbUser
‚‚ 
=
‚‚ 
await
‚‚ 
_context
‚‚ '
.
‚‚' (
Users
‚‚( -
.
‚‚- .
AsNoTracking
‚‚. :
(
‚‚: ;
)
‚‚; <
.
‚‚< =!
FirstOrDefaultAsync
‚‚= P
(
‚‚P Q
u
‚‚Q R
=>
‚‚S U
u
‚‚V W
.
‚‚W X
Id
‚‚X Z
==
‚‚[ ]
user
‚‚^ b
.
‚‚b c
Id
‚‚c e
)
‚‚e f
;
‚‚f g
if
‰‰ 
(
‰‰ 
dbUser
‰‰ 
?
‰‰ 
.
‰‰ 
TwoFactorEnabled
‰‰ (
==
‰‰) +
true
‰‰, 0
)
‰‰0 1
{
ÂÂ 
var
ÊÊ 
code
ÊÊ 
=
ÊÊ 
new
ÊÊ 
Random
ÊÊ %
(
ÊÊ% &
)
ÊÊ& '
.
ÊÊ' (
Next
ÊÊ( ,
(
ÊÊ, -
$num
ÊÊ- 3
,
ÊÊ3 4
$num
ÊÊ5 ;
)
ÊÊ; <
.
ÊÊ< =
ToString
ÊÊ= E
(
ÊÊE F
)
ÊÊF G
;
ÊÊG H
_context
ÁÁ 
.
ÁÁ 
VerificationCodes
ÁÁ *
.
ÁÁ* +
Add
ÁÁ+ .
(
ÁÁ. /
new
ÁÁ/ 2
VerificationCode
ÁÁ3 C
{
ËË 
Email
ÈÈ 
=
ÈÈ 
user
ÈÈ  
.
ÈÈ  !
Email
ÈÈ! &
!
ÈÈ& '
,
ÈÈ' (
Code
ÍÍ 
=
ÍÍ 
code
ÍÍ 
,
ÍÍ  
	ExpiresAt
ÎÎ 
=
ÎÎ 
DateTime
ÎÎ  (
.
ÎÎ( )
UtcNow
ÎÎ) /
.
ÎÎ/ 0

AddMinutes
ÎÎ0 :
(
ÎÎ: ;
$num
ÎÎ; =
)
ÎÎ= >
}
ÏÏ 
)
ÏÏ 
;
ÏÏ 
await
ÌÌ 
_context
ÌÌ 
.
ÌÌ 
SaveChangesAsync
ÌÌ /
(
ÌÌ/ 0
)
ÌÌ0 1
;
ÌÌ1 2
await
ÓÓ 
_emailService
ÓÓ #
.
ÓÓ# $
SendEmailAsync
ÓÓ$ 2
(
ÓÓ2 3
user
ÓÓ3 7
.
ÓÓ7 8
Email
ÓÓ8 =
!
ÓÓ= >
,
ÓÓ> ?
$str
ÓÓ@ e
,
ÓÓe f
$"
ÓÓg i
$strÓÓi ä
{ÓÓä ã
codeÓÓã è
}ÓÓè ê
"ÓÓê ë
)ÓÓë í
;ÓÓí ì
return
 
Ok
 
(
 
new
 
{
 
requiresTwoFactor
  1
=
2 3
true
4 8
,
8 9
email
: ?
=
@ A
user
B F
.
F G
Email
G L
,
L M
message
N U
=
V W
$str
X ~
} Ä
)Ä Å
;Å Ç
}
ÒÒ 
var
ÛÛ 
device
ÛÛ 
=
ÛÛ $
GetDeviceFromUserAgent
ÛÛ /
(
ÛÛ/ 0
	userAgent
ÛÛ0 9
)
ÛÛ9 :
;
ÛÛ: ;
var
ÙÙ 
location
ÙÙ 
=
ÙÙ 
$str
ÙÙ (
;
ÙÙ( )
_context
ˆˆ 
.
ˆˆ 
LoginHistory
ˆˆ !
.
ˆˆ! "
Add
ˆˆ" %
(
ˆˆ% &
new
ˆˆ& )
LoginHistory
ˆˆ* 6
{
˜˜ 
UserID
¯¯ 
=
¯¯ 
user
¯¯ 
.
¯¯ 
Id
¯¯  
,
¯¯  !
Device
˘˘ 
=
˘˘ 
device
˘˘ 
,
˘˘  
Location
˙˙ 
=
˙˙ 
location
˙˙ #
,
˙˙# $
	IPAddress
˚˚ 
=
˚˚ 
	ipAddress
˚˚ %
,
˚˚% &
	LoginTime
¸¸ 
=
¸¸ 
DateTime
¸¸ $
.
¸¸$ %
UtcNow
¸¸% +
}
˝˝ 
)
˝˝ 
;
˝˝ 
await
˛˛ 
_context
˛˛ 
.
˛˛ 
SaveChangesAsync
˛˛ +
(
˛˛+ ,
)
˛˛, -
;
˛˛- .
var
ÄÄ 
isNewDevice
ÄÄ 
=
ÄÄ 
!
ÄÄ 
await
ÄÄ $
_context
ÄÄ% -
.
ÄÄ- .
LoginHistory
ÄÄ. :
.
ÅÅ 
AnyAsync
ÅÅ 
(
ÅÅ 
lh
ÅÅ 
=>
ÅÅ 
lh
ÅÅ  "
.
ÅÅ" #
UserID
ÅÅ# )
==
ÅÅ* ,
user
ÅÅ- 1
.
ÅÅ1 2
Id
ÅÅ2 4
&&
ÅÅ5 7
lh
ÅÅ8 :
.
ÅÅ: ;
Device
ÅÅ; A
==
ÅÅB D
device
ÅÅE K
&&
ÅÅL N
lh
ÅÅO Q
.
ÅÅQ R
	LoginTime
ÅÅR [
<
ÅÅ\ ]
DateTime
ÅÅ^ f
.
ÅÅf g
UtcNow
ÅÅg m
.
ÅÅm n

AddMinutes
ÅÅn x
(
ÅÅx y
-
ÅÅy z
$num
ÅÅz {
)
ÅÅ{ |
)
ÅÅ| }
;
ÅÅ} ~
if
ÉÉ 
(
ÉÉ 
isNewDevice
ÉÉ 
)
ÉÉ 
{
ÑÑ 
var
ÖÖ 
	loginPref
ÖÖ 
=
ÖÖ 
await
ÖÖ  %
_context
ÖÖ& .
.
ÖÖ. /%
NotificationPreferences
ÖÖ/ F
.
ÜÜ !
FirstOrDefaultAsync
ÜÜ (
(
ÜÜ( )
np
ÜÜ) +
=>
ÜÜ, .
np
ÜÜ/ 1
.
ÜÜ1 2
UserID
ÜÜ2 8
==
ÜÜ9 ;
user
ÜÜ< @
.
ÜÜ@ A
Id
ÜÜA C
&&
ÜÜD F
np
ÜÜG I
.
ÜÜI J
NotificationType
ÜÜJ Z
==
ÜÜ[ ]
$str
ÜÜ^ i
)
ÜÜi j
;
ÜÜj k
if
áá 
(
áá 
	loginPref
áá 
?
áá 
.
áá 
EmailEnabled
áá +
!=
áá, .
false
áá/ 4
)
áá4 5
{
àà 
await
ââ 
_emailService
ââ '
.
ââ' (
SendEmailAsync
ââ( 6
(
ââ6 7
user
ää 
.
ää 
Email
ää "
!
ää" #
,
ää# $
$str
ãã ;
,
ãã; <
$"
åå 
$str
åå  
{
åå  !
user
åå! %
.
åå% &
	FirstName
åå& /
}
åå/ 0
$stråå0 É
{ååÉ Ñ
deviceååÑ ä
}ååä ã
$strååã ™
{åå™ ´
locationåå´ ≥
}åå≥ ¥
$stråå¥ œ
{ååœ –
DateTimeåå– ÿ
.ååÿ Ÿ
UtcNowååŸ ﬂ
:ååﬂ ‡
$stråå‡ Û
}ååÛ Ù
$strååÙ ª
"ååª º
)
çç 
;
çç 
}
éé 
}
èè 
await
íí "
_loginAttemptService
íí &
.
íí& ' 
ResetAttemptsAsync
íí' 9
(
íí9 :
user
íí: >
.
íí> ?
Id
íí? A
)
ííA B
;
ííB C(
_ipDeviceReputationService
ìì &
.
ìì& '
RegisterSuccess
ìì' 6
(
ìì6 7
	ipAddress
ìì7 @
,
ìì@ A
	userAgent
ììB K
)
ììK L
;
ììL M
var
ïï 
token
ïï 
=
ïï 
await
ïï 
_tokenService
ïï +
.
ïï+ , 
GenerateTokenAsync
ïï, >
(
ïï> ?
user
ïï? C
.
ïïC D
Email
ïïD I
!
ïïI J
,
ïïJ K
user
ïïL P
.
ïïP Q
Id
ïïQ S
,
ïïS T
role
ïïU Y
)
ïïY Z
;
ïïZ [
var
óó 
settings
óó 
=
óó 
await
óó  
_context
óó! )
.
óó) *
SystemSettings
óó* 8
.
óó8 9!
FirstOrDefaultAsync
óó9 L
(
óóL M
)
óóM N
;
óóN O
var
òò #
sessionTimeoutMinutes
òò %
=
òò& '
settings
òò( 0
?
òò0 1
.
òò1 2
SessionTimeout
òò2 @
??
òòA C
$num
òòD F
;
òòF G
await
öö 
LogActivityAsync
öö "
(
öö" #
user
öö# '
.
öö' (
Id
öö( *
,
öö* +
$str
öö, 7
,
öö7 8
$str
öö9 @
)
öö@ A
;
ööA B
return
úú 
Ok
úú 
(
úú 
new
úú 
AuthResponse
úú &
{
ùù 
Token
ûû 
=
ûû 
token
ûû 
,
ûû 
Email
üü 
=
üü 
user
üü 
.
üü 
Email
üü "
!
üü" #
,
üü# $
Role
†† 
=
†† 
role
†† 
,
†† 

Expiration
°° 
=
°° 
DateTime
°° %
.
°°% &
UtcNow
°°& ,
.
°°, -

AddMinutes
°°- 7
(
°°7 8#
sessionTimeoutMinutes
°°8 M
)
°°M N
}
¢¢ 
)
¢¢ 
;
¢¢ 
}
££ 	
private
•• 
async
•• 
Task
•• 
<
•• 
bool
•• 
>
••  "
VerifyReCaptchaAsync
••! 5
(
••5 6
string
••6 <
?
••< =
captchaToken
••> J
)
••J K
{
¶¶ 	
if
ßß 
(
ßß 
string
ßß 
.
ßß  
IsNullOrWhiteSpace
ßß )
(
ßß) *
captchaToken
ßß* 6
)
ßß6 7
)
ßß7 8
return
®® 
false
®® 
;
®® 
var
™™ 
	secretKey
™™ 
=
™™ 
_configuration
™™ *
[
™™* +
$str
™™+ @
]
™™@ A
;
™™A B
var
´´ 
	verifyUrl
´´ 
=
´´ 
_configuration
´´ *
[
´´* +
$str
´´+ @
]
´´@ A
??
´´B D
$str
´´E v
;
´´v w
if
≠≠ 
(
≠≠ 
string
≠≠ 
.
≠≠  
IsNullOrWhiteSpace
≠≠ )
(
≠≠) *
	secretKey
≠≠* 3
)
≠≠3 4
)
≠≠4 5
return
ÆÆ 
false
ÆÆ 
;
ÆÆ 
var
∞∞ 

httpClient
∞∞ 
=
∞∞  
_httpClientFactory
∞∞ /
.
∞∞/ 0
CreateClient
∞∞0 <
(
∞∞< =
)
∞∞= >
;
∞∞> ?
var
±± 
content
±± 
=
±± 
new
±± #
FormUrlEncodedContent
±± 3
(
±±3 4
new
±±4 7

Dictionary
±±8 B
<
±±B C
string
±±C I
,
±±I J
string
±±K Q
>
±±Q R
{
≤≤ 
[
≥≥ 
$str
≥≥ 
]
≥≥ 
=
≥≥ 
	secretKey
≥≥ &
,
≥≥& '
[
¥¥ 
$str
¥¥ 
]
¥¥ 
=
¥¥ 
captchaToken
¥¥ +
,
¥¥+ ,
[
µµ 
$str
µµ 
]
µµ 
=
µµ 
HttpContext
µµ *
.
µµ* +

Connection
µµ+ 5
.
µµ5 6
RemoteIpAddress
µµ6 E
?
µµE F
.
µµF G
ToString
µµG O
(
µµO P
)
µµP Q
??
µµR T
string
µµU [
.
µµ[ \
Empty
µµ\ a
}
∂∂ 
)
∂∂ 
;
∂∂ 
var
∏∏ 
response
∏∏ 
=
∏∏ 
await
∏∏  

httpClient
∏∏! +
.
∏∏+ ,
	PostAsync
∏∏, 5
(
∏∏5 6
	verifyUrl
∏∏6 ?
,
∏∏? @
content
∏∏A H
)
∏∏H I
;
∏∏I J
if
ππ 
(
ππ 
!
ππ 
response
ππ 
.
ππ !
IsSuccessStatusCode
ππ -
)
ππ- .
return
∫∫ 
false
∫∫ 
;
∫∫ 
var
ºº 
responseJson
ºº 
=
ºº 
await
ºº $
response
ºº% -
.
ºº- .
Content
ºº. 5
.
ºº5 6
ReadAsStringAsync
ºº6 G
(
ººG H
)
ººH I
;
ººI J
var
ΩΩ 
result
ΩΩ 
=
ΩΩ 
JsonSerializer
ΩΩ '
.
ΩΩ' (
Deserialize
ΩΩ( 3
<
ΩΩ3 4+
ReCaptchaVerificationResponse
ΩΩ4 Q
>
ΩΩQ R
(
ΩΩR S
responseJson
ΩΩS _
,
ΩΩ_ `
new
ΩΩa d#
JsonSerializerOptions
ΩΩe z
{
ææ )
PropertyNameCaseInsensitive
øø +
=
øø, -
true
øø. 2
}
¿¿ 
)
¿¿ 
;
¿¿ 
return
¬¬ 
result
¬¬ 
?
¬¬ 
.
¬¬ 
Success
¬¬ "
==
¬¬# %
true
¬¬& *
;
¬¬* +
}
√√ 	
private
≈≈ 
sealed
≈≈ 
class
≈≈ +
ReCaptchaVerificationResponse
≈≈ :
{
∆∆ 	
public
«« 
bool
«« 
Success
«« 
{
««  !
get
««" %
;
««% &
set
««' *
;
««* +
}
««, -
[
…… 
JsonPropertyName
…… 
(
…… 
$str
…… +
)
……+ ,
]
……, -
public
   
string
   
[
   
]
   
?
   

ErrorCodes
   '
{
  ( )
get
  * -
;
  - .
set
  / 2
;
  2 3
}
  4 5
}
ÀÀ 	
[
ÕÕ 	
HttpPost
ÕÕ	 
(
ÕÕ 
$str
ÕÕ $
)
ÕÕ$ %
]
ÕÕ% &
public
ŒŒ 
async
ŒŒ 
Task
ŒŒ 
<
ŒŒ 
IActionResult
ŒŒ '
>
ŒŒ' (
Verify2FALogin
ŒŒ) 7
(
ŒŒ7 8
[
ŒŒ8 9
FromBody
ŒŒ9 A
]
ŒŒA B#
Verify2FALoginRequest
ŒŒC X
request
ŒŒY `
)
ŒŒ` a
{
œœ 	
var
–– 
	userAgent
–– 
=
–– 
Request
–– #
.
––# $
Headers
––$ +
[
––+ ,
$str
––, 8
]
––8 9
.
––9 :
ToString
––: B
(
––B C
)
––C D
;
––D E
var
—— 
	ipAddress
—— 
=
—— 
HttpContext
—— '
.
——' (

Connection
——( 2
.
——2 3
RemoteIpAddress
——3 B
?
——B C
.
——C D
ToString
——D L
(
——L M
)
——M N
;
——N O
if
““ 
(
““ (
_ipDeviceReputationService
““ *
.
““* +
	IsBlocked
““+ 4
(
““4 5
	ipAddress
““5 >
,
““> ?
	userAgent
““@ I
,
““I J
out
““K N
var
““O R
blockReason
““S ^
)
““^ _
)
““_ `
return
”” 

StatusCode
”” !
(
””! "
$num
””" %
,
””% &
new
””' *
{
””+ ,
message
””- 4
=
””5 6
$"
””7 9
$str
””9 I
{
””I J
blockReason
””J U
}
””U V
$str
””V o
"
””o p
}
””q r
)
””r s
;
””s t
var
’’ 
user
’’ 
=
’’ 
await
’’ 
_userManager
’’ )
.
’’) *
FindByEmailAsync
’’* :
(
’’: ;
request
’’; B
.
’’B C
Email
’’C H
)
’’H I
;
’’I J
if
÷÷ 
(
÷÷ 
user
÷÷ 
==
÷÷ 
null
÷÷ 
)
÷÷ 
return
÷÷ $
Unauthorized
÷÷% 1
(
÷÷1 2
new
÷÷2 5
{
÷÷6 7
message
÷÷8 ?
=
÷÷@ A
$str
÷÷B R
}
÷÷S T
)
÷÷T U
;
÷÷U V
var
ÿÿ 
verification
ÿÿ 
=
ÿÿ 
await
ÿÿ $
_context
ÿÿ% -
.
ÿÿ- .
VerificationCodes
ÿÿ. ?
.
ŸŸ !
FirstOrDefaultAsync
ŸŸ $
(
ŸŸ$ %
v
ŸŸ% &
=>
ŸŸ' )
v
ŸŸ* +
.
ŸŸ+ ,
Email
ŸŸ, 1
==
ŸŸ2 4
request
ŸŸ5 <
.
ŸŸ< =
Email
ŸŸ= B
&&
ŸŸC E
v
ŸŸF G
.
ŸŸG H
Code
ŸŸH L
==
ŸŸM O
request
ŸŸP W
.
ŸŸW X
Code
ŸŸX \
&&
ŸŸ] _
!
ŸŸ` a
v
ŸŸa b
.
ŸŸb c
IsUsed
ŸŸc i
&&
ŸŸj l
v
ŸŸm n
.
ŸŸn o
	ExpiresAt
ŸŸo x
>
ŸŸy z
DateTimeŸŸ{ É
.ŸŸÉ Ñ
UtcNowŸŸÑ ä
)ŸŸä ã
;ŸŸã å
if
⁄⁄ 
(
⁄⁄ 
verification
⁄⁄ 
==
⁄⁄ 
null
⁄⁄  $
)
⁄⁄$ %
return
⁄⁄& ,

BadRequest
⁄⁄- 7
(
⁄⁄7 8
new
⁄⁄8 ;
{
⁄⁄< =
message
⁄⁄> E
=
⁄⁄F G
$str
⁄⁄H n
}
⁄⁄o p
)
⁄⁄p q
;
⁄⁄q r
verification
‹‹ 
.
‹‹ 
IsUsed
‹‹ 
=
‹‹  !
true
‹‹" &
;
‹‹& '
var
ﬁﬁ 
device
ﬁﬁ 
=
ﬁﬁ $
GetDeviceFromUserAgent
ﬁﬁ /
(
ﬁﬁ/ 0
	userAgent
ﬁﬁ0 9
)
ﬁﬁ9 :
;
ﬁﬁ: ;
var
ﬂﬂ 
location
ﬂﬂ 
=
ﬂﬂ 
$str
ﬂﬂ (
;
ﬂﬂ( )
_context
·· 
.
·· 
LoginHistory
·· !
.
··! "
Add
··" %
(
··% &
new
··& )
LoginHistory
··* 6
{
‚‚ 
UserID
„„ 
=
„„ 
user
„„ 
.
„„ 
Id
„„  
,
„„  !
Device
‰‰ 
=
‰‰ 
device
‰‰ 
,
‰‰  
Location
ÂÂ 
=
ÂÂ 
location
ÂÂ #
,
ÂÂ# $
	IPAddress
ÊÊ 
=
ÊÊ 
	ipAddress
ÊÊ %
,
ÊÊ% &
	LoginTime
ÁÁ 
=
ÁÁ 
DateTime
ÁÁ $
.
ÁÁ$ %
UtcNow
ÁÁ% +
}
ËË 
)
ËË 
;
ËË 
await
ÈÈ 
_context
ÈÈ 
.
ÈÈ 
SaveChangesAsync
ÈÈ +
(
ÈÈ+ ,
)
ÈÈ, -
;
ÈÈ- .
await
ÏÏ "
_loginAttemptService
ÏÏ &
.
ÏÏ& ' 
ResetAttemptsAsync
ÏÏ' 9
(
ÏÏ9 :
user
ÏÏ: >
.
ÏÏ> ?
Id
ÏÏ? A
)
ÏÏA B
;
ÏÏB C(
_ipDeviceReputationService
ÌÌ &
.
ÌÌ& '
RegisterSuccess
ÌÌ' 6
(
ÌÌ6 7
	ipAddress
ÌÌ7 @
,
ÌÌ@ A
	userAgent
ÌÌB K
)
ÌÌK L
;
ÌÌL M
var
ÔÔ 
roles
ÔÔ 
=
ÔÔ 
await
ÔÔ 
_userManager
ÔÔ *
.
ÔÔ* +
GetRolesAsync
ÔÔ+ 8
(
ÔÔ8 9
user
ÔÔ9 =
)
ÔÔ= >
;
ÔÔ> ?
var
 
role
 
=
 
roles
 
.
 
FirstOrDefault
 +
(
+ ,
)
, -
??
. 0
user
1 5
.
5 6
Role
6 :
;
: ;
var
ÒÒ 
token
ÒÒ 
=
ÒÒ 
await
ÒÒ 
_tokenService
ÒÒ +
.
ÒÒ+ , 
GenerateTokenAsync
ÒÒ, >
(
ÒÒ> ?
user
ÒÒ? C
.
ÒÒC D
Email
ÒÒD I
!
ÒÒI J
,
ÒÒJ K
user
ÒÒL P
.
ÒÒP Q
Id
ÒÒQ S
,
ÒÒS T
role
ÒÒU Y
)
ÒÒY Z
;
ÒÒZ [
var
ÛÛ 
settings
ÛÛ 
=
ÛÛ 
await
ÛÛ  
_context
ÛÛ! )
.
ÛÛ) *
SystemSettings
ÛÛ* 8
.
ÛÛ8 9!
FirstOrDefaultAsync
ÛÛ9 L
(
ÛÛL M
)
ÛÛM N
;
ÛÛN O
var
ÙÙ #
sessionTimeoutMinutes
ÙÙ %
=
ÙÙ& '
settings
ÙÙ( 0
?
ÙÙ0 1
.
ÙÙ1 2
SessionTimeout
ÙÙ2 @
??
ÙÙA C
$num
ÙÙD F
;
ÙÙF G
await
ˆˆ 
LogActivityAsync
ˆˆ "
(
ˆˆ" #
user
ˆˆ# '
.
ˆˆ' (
Id
ˆˆ( *
,
ˆˆ* +
$str
ˆˆ, H
,
ˆˆH I
$str
ˆˆJ Q
)
ˆˆQ R
;
ˆˆR S
return
¯¯ 
Ok
¯¯ 
(
¯¯ 
new
¯¯ 
AuthResponse
¯¯ &
{
˘˘ 
Token
˙˙ 
=
˙˙ 
token
˙˙ 
,
˙˙ 
Email
˚˚ 
=
˚˚ 
user
˚˚ 
.
˚˚ 
Email
˚˚ "
!
˚˚" #
,
˚˚# $
Role
¸¸ 
=
¸¸ 
role
¸¸ 
,
¸¸ 

Expiration
˝˝ 
=
˝˝ 
DateTime
˝˝ %
.
˝˝% &
UtcNow
˝˝& ,
.
˝˝, -

AddMinutes
˝˝- 7
(
˝˝7 8#
sessionTimeoutMinutes
˝˝8 M
)
˝˝M N
}
˛˛ 
)
˛˛ 
;
˛˛ 
}
ˇˇ 	
private
ÅÅ 
string
ÅÅ $
GetDeviceFromUserAgent
ÅÅ -
(
ÅÅ- .
string
ÅÅ. 4
	userAgent
ÅÅ5 >
)
ÅÅ> ?
{
ÇÇ 	
if
ÉÉ 
(
ÉÉ 
string
ÉÉ 
.
ÉÉ 
IsNullOrEmpty
ÉÉ $
(
ÉÉ$ %
	userAgent
ÉÉ% .
)
ÉÉ. /
)
ÉÉ/ 0
return
ÑÑ 
$str
ÑÑ '
;
ÑÑ' (
var
ÜÜ 
rules
ÜÜ 
=
ÜÜ 
new
ÜÜ 
(
ÜÜ 
string
ÜÜ #
[
ÜÜ# $
]
ÜÜ$ %
MustContain
ÜÜ& 1
,
ÜÜ1 2
string
ÜÜ3 9
Result
ÜÜ: @
)
ÜÜ@ A
[
ÜÜA B
]
ÜÜB C
{
áá 
(
àà 
new
àà 
[
àà 
]
àà 
{
àà 
$str
àà !
,
àà! "
$str
àà# ,
}
àà- .
,
àà. /
$str
àà0 C
)
ààC D
,
ààD E
(
ââ 
new
ââ 
[
ââ 
]
ââ 
{
ââ 
$str
ââ !
,
ââ! "
$str
ââ# (
}
ââ) *
,
ââ* +
$str
ââ, ;
)
ââ; <
,
ââ< =
(
ää 
new
ää 
[
ää 
]
ää 
{
ää 
$str
ää !
,
ää! "
$str
ää# ,
}
ää- .
,
ää. /
$str
ää0 C
)
ääC D
,
ääD E
(
ãã 
new
ãã 
[
ãã 
]
ãã 
{
ãã 
$str
ãã !
,
ãã! "
$str
ãã# +
}
ãã, -
,
ãã- .
$str
ãã/ A
)
ããA B
,
ããB C
(
åå 
new
åå 
[
åå 
]
åå 
{
åå 
$str
åå !
,
åå! "
$str
åå# )
}
åå* +
,
åå+ ,
$str
åå- =
)
åå= >
,
åå> ?
(
çç 
new
çç 
[
çç 
]
çç 
{
çç 
$str
çç "
}
çç# $
,
çç$ %
$str
çç& 7
)
çç7 8
,
çç8 9
(
éé 
new
éé 
[
éé 
]
éé 
{
éé 
$str
éé 
}
éé  !
,
éé! "
$str
éé# 3
)
éé3 4
}
èè 
;
èè 
foreach
ëë 
(
ëë 
var
ëë 
rule
ëë 
in
ëë  
rules
ëë! &
)
ëë& '
{
íí 
if
ìì 
(
ìì 
rule
ìì 
.
ìì 
MustContain
ìì $
.
ìì$ %
All
ìì% (
(
ìì( )
token
ìì) .
=>
ìì/ 1
	userAgent
ìì2 ;
.
ìì; <
Contains
ìì< D
(
ììD E
token
ììE J
,
ììJ K
StringComparison
ììL \
.
ìì\ ]
OrdinalIgnoreCase
ìì] n
)
ììn o
)
ììo p
)
ììp q
return
îî 
rule
îî 
.
îî  
Result
îî  &
;
îî& '
}
ïï 
return
óó 
$str
óó #
;
óó# $
}
òò 	
[
öö 	
HttpPost
öö	 
(
öö 
$str
öö  
)
öö  !
]
öö! "
public
õõ 
async
õõ 
Task
õõ 
<
õõ 
IActionResult
õõ '
>
õõ' (
GoogleLogin
õõ) 4
(
õõ4 5
[
õõ5 6
FromBody
õõ6 >
]
õõ> ? 
GoogleLoginRequest
õõ@ R
request
õõS Z
)
õõZ [
{
úú 	
var
ùù 
user
ùù 
=
ùù 
await
ùù 
_userManager
ùù )
.
ùù) *
FindByEmailAsync
ùù* :
(
ùù: ;
request
ùù; B
.
ùùB C
Email
ùùC H
)
ùùH I
;
ùùI J
if
üü 
(
üü 
user
üü 
==
üü 
null
üü 
)
üü 
{
†† 
user
°° 
=
°° 
new
°° 
ApplicationUser
°° *
{
¢¢ 
UserName
££ 
=
££ 
request
££ &
.
££& '
Email
££' ,
,
££, -
Email
§§ 
=
§§ 
request
§§ #
.
§§# $
Email
§§$ )
,
§§) *
	FirstName
•• 
=
•• 
request
••  '
.
••' (
	FirstName
••( 1
,
••1 2
LastName
¶¶ 
=
¶¶ 
request
¶¶ &
.
¶¶& '
LastName
¶¶' /
,
¶¶/ 0
EmailConfirmed
ßß "
=
ßß# $
true
ßß% )
,
ßß) *
Status
®® 
=
®® 
$str
®® %
}
©© 
;
©© 
var
´´ 
result
´´ 
=
´´ 
await
´´ "
_userManager
´´# /
.
´´/ 0
CreateAsync
´´0 ;
(
´´; <
user
´´< @
)
´´@ A
;
´´A B
if
¨¨ 
(
¨¨ 
!
¨¨ 
result
¨¨ 
.
¨¨ 
	Succeeded
¨¨ %
)
¨¨% &
return
≠≠ 

BadRequest
≠≠ %
(
≠≠% &
result
≠≠& ,
.
≠≠, -
Errors
≠≠- 3
)
≠≠3 4
;
≠≠4 5
_context
ØØ 
.
ØØ  
OnboardingStatuses
ØØ +
.
ØØ+ ,
Add
ØØ, /
(
ØØ/ 0
new
ØØ0 3
OnboardingStatus
ØØ4 D
{
∞∞ 
UserID
±± 
=
±± 
user
±± !
.
±±! "
Id
±±" $
,
±±$ %
IsEmailVerified
≤≤ #
=
≤≤$ %
true
≤≤& *
}
≥≥ 
)
≥≥ 
;
≥≥ 
await
¥¥ 
_context
¥¥ 
.
¥¥ 
SaveChangesAsync
¥¥ /
(
¥¥/ 0
)
¥¥0 1
;
¥¥1 2
}
µµ 
await
∏∏ "
_loginAttemptService
∏∏ &
.
∏∏& ' 
ResetAttemptsAsync
∏∏' 9
(
∏∏9 :
user
∏∏: >
.
∏∏> ?
Id
∏∏? A
)
∏∏A B
;
∏∏B C
var
∫∫ 
roles
∫∫ 
=
∫∫ 
await
∫∫ 
_userManager
∫∫ *
.
∫∫* +
GetRolesAsync
∫∫+ 8
(
∫∫8 9
user
∫∫9 =
)
∫∫= >
;
∫∫> ?
var
ªª 
role
ªª 
=
ªª 
roles
ªª 
.
ªª 
FirstOrDefault
ªª +
(
ªª+ ,
)
ªª, -
??
ªª. 0
user
ªª1 5
.
ªª5 6
Role
ªª6 :
;
ªª: ;
var
ΩΩ 
token
ΩΩ 
=
ΩΩ 
await
ΩΩ 
_tokenService
ΩΩ +
.
ΩΩ+ , 
GenerateTokenAsync
ΩΩ, >
(
ΩΩ> ?
user
ΩΩ? C
.
ΩΩC D
Email
ΩΩD I
!
ΩΩI J
,
ΩΩJ K
user
ΩΩL P
.
ΩΩP Q
Id
ΩΩQ S
,
ΩΩS T
role
ΩΩU Y
)
ΩΩY Z
;
ΩΩZ [
var
øø 
settings
øø 
=
øø 
await
øø  
_context
øø! )
.
øø) *
SystemSettings
øø* 8
.
øø8 9!
FirstOrDefaultAsync
øø9 L
(
øøL M
)
øøM N
;
øøN O
var
¿¿ #
sessionTimeoutMinutes
¿¿ %
=
¿¿& '
settings
¿¿( 0
?
¿¿0 1
.
¿¿1 2
SessionTimeout
¿¿2 @
??
¿¿A C
$num
¿¿D F
;
¿¿F G
await
¬¬ 
LogActivityAsync
¬¬ "
(
¬¬" #
user
¬¬# '
.
¬¬' (
Id
¬¬( *
,
¬¬* +
$str
¬¬, C
,
¬¬C D
$str
¬¬E L
)
¬¬L M
;
¬¬M N
return
ƒƒ 
Ok
ƒƒ 
(
ƒƒ 
new
ƒƒ 
AuthResponse
ƒƒ &
{
≈≈ 
Token
∆∆ 
=
∆∆ 
token
∆∆ 
,
∆∆ 
Email
«« 
=
«« 
user
«« 
.
«« 
Email
«« "
!
««" #
,
««# $
Role
»» 
=
»» 
role
»» 
,
»» 

Expiration
…… 
=
…… 
DateTime
…… %
.
……% &
UtcNow
……& ,
.
……, -

AddMinutes
……- 7
(
……7 8#
sessionTimeoutMinutes
……8 M
)
……M N
}
   
)
   
;
   
}
ÀÀ 	
private
ÕÕ 
async
ÕÕ 
Task
ÕÕ 
LogActivityAsync
ÕÕ +
(
ÕÕ+ ,
string
ÕÕ, 2
userId
ÕÕ3 9
,
ÕÕ9 :
string
ÕÕ; A
action
ÕÕB H
,
ÕÕH I
string
ÕÕJ P
type
ÕÕQ U
)
ÕÕU V
{
ŒŒ 	
if
œœ 
(
œœ 
string
œœ 
.
œœ  
IsNullOrWhiteSpace
œœ )
(
œœ) *
userId
œœ* 0
)
œœ0 1
||
œœ2 4
string
œœ5 ;
.
œœ; < 
IsNullOrWhiteSpace
œœ< N
(
œœN O
action
œœO U
)
œœU V
)
œœV W
return
–– 
;
–– 
try
““ 
{
”” 
_context
‘‘ 
.
‘‘ 
ActivityLogs
‘‘ %
.
‘‘% &
Add
‘‘& )
(
‘‘) *
new
‘‘* -
ActivityLog
‘‘. 9
{
’’ 
UserID
÷÷ 
=
÷÷ 
userId
÷÷ #
,
÷÷# $
Action
◊◊ 
=
◊◊ 
action
◊◊ #
,
◊◊# $
Type
ÿÿ 
=
ÿÿ 
string
ÿÿ !
.
ÿÿ! " 
IsNullOrWhiteSpace
ÿÿ" 4
(
ÿÿ4 5
type
ÿÿ5 9
)
ÿÿ9 :
?
ÿÿ; <
$str
ÿÿ= E
:
ÿÿF G
type
ÿÿH L
,
ÿÿL M
	IPAddress
ŸŸ 
=
ŸŸ 
HttpContext
ŸŸ  +
.
ŸŸ+ ,

Connection
ŸŸ, 6
.
ŸŸ6 7
RemoteIpAddress
ŸŸ7 F
?
ŸŸF G
.
ŸŸG H
ToString
ŸŸH P
(
ŸŸP Q
)
ŸŸQ R
,
ŸŸR S
	Timestamp
⁄⁄ 
=
⁄⁄ 
DateTime
⁄⁄  (
.
⁄⁄( )
UtcNow
⁄⁄) /
}
€€ 
)
€€ 
;
€€ 
await
›› 
_context
›› 
.
›› 
SaveChangesAsync
›› /
(
››/ 0
)
››0 1
;
››1 2
}
ﬁﬁ 
catch
ﬂﬂ 
{
‡‡ 
}
‚‚ 
}
„„ 	
[
ÂÂ 	
	Authorize
ÂÂ	 
]
ÂÂ 
[
ÊÊ 	&
RequireEmailVerification
ÊÊ	 !
]
ÊÊ! "
[
ÁÁ 	
HttpPost
ÁÁ	 
(
ÁÁ 
$str
ÁÁ '
)
ÁÁ' (
]
ÁÁ( )
public
ËË 
async
ËË 
Task
ËË 
<
ËË 
IActionResult
ËË '
>
ËË' (
SelectServiceType
ËË) :
(
ËË: ;
[
ËË; <
FromBody
ËË< D
]
ËËD E&
SelectServiceTypeRequest
ËËF ^
request
ËË_ f
)
ËËf g
{
ÈÈ 	
var
ÍÍ 
userId
ÍÍ 
=
ÍÍ 
User
ÍÍ 
.
ÍÍ 
	FindFirst
ÍÍ '
(
ÍÍ' (
System
ÍÍ( .
.
ÍÍ. /
Security
ÍÍ/ 7
.
ÍÍ7 8
Claims
ÍÍ8 >
.
ÍÍ> ?

ClaimTypes
ÍÍ? I
.
ÍÍI J
NameIdentifier
ÍÍJ X
)
ÍÍX Y
?
ÍÍY Z
.
ÍÍZ [
Value
ÍÍ[ `
;
ÍÍ` a
var
ÎÎ 
activeSubCount
ÎÎ 
=
ÎÎ  
await
ÎÎ! &
_context
ÎÎ' /
.
ÎÎ/ 0
Subscriptions
ÎÎ0 =
.
ÏÏ 

CountAsync
ÏÏ 
(
ÏÏ 
s
ÏÏ 
=>
ÏÏ  
s
ÏÏ! "
.
ÏÏ" #
UserID
ÏÏ# )
==
ÏÏ* ,
userId
ÏÏ- 3
&&
ÏÏ4 6
s
ÏÏ7 8
.
ÏÏ8 9
Status
ÏÏ9 ?
==
ÏÏ@ B
$str
ÏÏC K
)
ÏÏK L
;
ÏÏL M
var
ÌÌ 
activePrepCount
ÌÌ 
=
ÌÌ  !
await
ÌÌ" '
_context
ÌÌ( 0
.
ÌÌ0 1
Devices
ÌÌ1 8
.
ÓÓ 
Where
ÓÓ 
(
ÓÓ 
d
ÓÓ 
=>
ÓÓ 
d
ÓÓ 
.
ÓÓ 
UserID
ÓÓ $
==
ÓÓ% '
userId
ÓÓ( .
)
ÓÓ. /
.
ÔÔ 

SelectMany
ÔÔ 
(
ÔÔ 
d
ÔÔ 
=>
ÔÔ  
d
ÔÔ! "
.
ÔÔ" #
ServiceAccounts
ÔÔ# 2
)
ÔÔ2 3
.
 
Where
 
(
 
sa
 
=>
 
sa
 
.
  
Status
  &
==
' )
$str
* 2
&&
3 5
sa
6 8
.
8 9
ServiceType
9 D
==
E G
$str
H Q
)
Q R
.
ÒÒ 

CountAsync
ÒÒ 
(
ÒÒ 
)
ÒÒ 
;
ÒÒ 
if
ÛÛ 
(
ÛÛ 
activeSubCount
ÛÛ 
+
ÛÛ  
activePrepCount
ÛÛ! 0
>=
ÛÛ1 3
$num
ÛÛ4 5
)
ÛÛ5 6
return
ÙÙ 

BadRequest
ÙÙ !
(
ÙÙ! "
new
ÙÙ" %
{
ÙÙ& '
message
ÙÙ( /
=
ÙÙ0 1
$str
ÙÙ2 l
}
ÙÙm n
)
ÙÙn o
;
ÙÙo p
var
ˆˆ 

onboarding
ˆˆ 
=
ˆˆ 
await
ˆˆ "
_context
ˆˆ# +
.
ˆˆ+ , 
OnboardingStatuses
ˆˆ, >
.
ˆˆ> ?!
FirstOrDefaultAsync
ˆˆ? R
(
ˆˆR S
o
ˆˆS T
=>
ˆˆU W
o
ˆˆX Y
.
ˆˆY Z
UserID
ˆˆZ `
==
ˆˆa c
userId
ˆˆd j
)
ˆˆj k
;
ˆˆk l
if
¯¯ 
(
¯¯ 

onboarding
¯¯ 
==
¯¯ 
null
¯¯ "
)
¯¯" #
return
˘˘ 
NotFound
˘˘ 
(
˘˘  
new
˘˘  #
{
˘˘$ %
message
˘˘& -
=
˘˘. /
$str
˘˘0 M
}
˘˘N O
)
˘˘O P
;
˘˘P Q

onboarding
˚˚ 
.
˚˚ $
HasSelectedServiceType
˚˚ -
=
˚˚. /
true
˚˚0 4
;
˚˚4 5
await
¸¸ 
_context
¸¸ 
.
¸¸ 
SaveChangesAsync
¸¸ +
(
¸¸+ ,
)
¸¸, -
;
¸¸- .
return
˛˛ 
Ok
˛˛ 
(
˛˛ 
new
˛˛ 
{
˛˛ 
message
˛˛ #
=
˛˛$ %
$str
˛˛& J
}
˛˛K L
)
˛˛L M
;
˛˛M N
}
ˇˇ 	
[
ÅÅ 	
	Authorize
ÅÅ	 
]
ÅÅ 
[
ÇÇ 	&
RequireEmailVerification
ÇÇ	 !
]
ÇÇ! "
[
ÉÉ 	
HttpGet
ÉÉ	 
(
ÉÉ 
$str
ÉÉ $
)
ÉÉ$ %
]
ÉÉ% &
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
GetOnboardingStatus
ÑÑ) <
(
ÑÑ< =
)
ÑÑ= >
{
ÖÖ 	
var
ÜÜ 
userId
ÜÜ 
=
ÜÜ 
User
ÜÜ 
.
ÜÜ 
	FindFirst
ÜÜ '
(
ÜÜ' (
System
ÜÜ( .
.
ÜÜ. /
Security
ÜÜ/ 7
.
ÜÜ7 8
Claims
ÜÜ8 >
.
ÜÜ> ?

ClaimTypes
ÜÜ? I
.
ÜÜI J
NameIdentifier
ÜÜJ X
)
ÜÜX Y
?
ÜÜY Z
.
ÜÜZ [
Value
ÜÜ[ `
;
ÜÜ` a
var
àà #
hasActiveSubscription
àà %
=
àà& '
await
àà( -
_context
àà. 6
.
àà6 7
Subscriptions
àà7 D
.
ââ 
AnyAsync
ââ 
(
ââ 
s
ââ 
=>
ââ 
s
ââ  
.
ââ  !
UserID
ââ! '
==
ââ( *
userId
ââ+ 1
&&
ââ2 4
s
ââ5 6
.
ââ6 7
Status
ââ7 =
==
ââ> @
$str
ââA I
)
ââI J
;
ââJ K
var
ãã 
hasActivePrepaid
ãã  
=
ãã! "
await
ãã# (
_context
ãã) 1
.
ãã1 2
Devices
ãã2 9
.
åå 
Where
åå 
(
åå 
d
åå 
=>
åå 
d
åå 
.
åå 
UserID
åå $
==
åå% '
userId
åå( .
)
åå. /
.
çç 

SelectMany
çç 
(
çç 
d
çç 
=>
çç  
d
çç! "
.
çç" #
ServiceAccounts
çç# 2
)
çç2 3
.
éé 
Where
éé 
(
éé 
sa
éé 
=>
éé 
sa
éé 
.
éé  
Status
éé  &
==
éé' )
$str
éé* 2
)
éé2 3
.
èè 

SelectMany
èè 
(
èè 
sa
èè 
=>
èè !
sa
èè" $
.
èè$ %
PrepaidLoads
èè% 1
)
èè1 2
.
êê 
AnyAsync
êê 
(
êê 
)
êê 
;
êê 
var
íí 
hasActivePlan
íí 
=
íí #
hasActiveSubscription
íí  5
||
íí6 8
hasActivePrepaid
íí9 I
;
ííI J
var
îî 

onboarding
îî 
=
îî 
await
îî "
_context
îî# +
.
îî+ , 
OnboardingStatuses
îî, >
.
îî> ?!
FirstOrDefaultAsync
îî? R
(
îîR S
o
îîS T
=>
îîU W
o
îîX Y
.
îîY Z
UserID
îîZ `
==
îîa c
userId
îîd j
)
îîj k
;
îîk l
if
ññ 
(
ññ 

onboarding
ññ 
==
ññ 
null
ññ "
)
ññ" #
{
óó 
return
òò 
Ok
òò 
(
òò 
new
òò 
{
ôô $
hasSelectedServiceType
öö *
=
öö+ ,
false
öö- 2
,
öö2 3!
hasRegisteredDevice
õõ '
=
õõ( )
false
õõ* /
,
õõ/ 0"
hasCompletedTutorial
úú (
=
úú) *
false
úú+ 0
,
úú0 1
hasActivePlan
ùù !
}
ûû 
)
ûû 
;
ûû 
}
üü 
return
°° 
Ok
°° 
(
°° 
new
°° 
{
¢¢ $
hasSelectedServiceType
££ &
=
££' (

onboarding
££) 3
.
££3 4$
HasSelectedServiceType
££4 J
,
££J K!
hasRegisteredDevice
§§ #
=
§§$ %

onboarding
§§& 0
.
§§0 1!
HasRegisteredDevice
§§1 D
,
§§D E"
hasCompletedTutorial
•• $
=
••% &

onboarding
••' 1
.
••1 2"
HasCompletedTutorial
••2 F
,
••F G
hasActivePlan
¶¶ 
}
ßß 
)
ßß 
;
ßß 
}
®® 	
[
™™ 	
	Authorize
™™	 
]
™™ 
[
´´ 	&
RequireEmailVerification
´´	 !
]
´´! "
[
¨¨ 	
HttpPost
¨¨	 
(
¨¨ 
$str
¨¨ #
)
¨¨# $
]
¨¨$ %
public
≠≠ 
async
≠≠ 
Task
≠≠ 
<
≠≠ 
IActionResult
≠≠ '
>
≠≠' (
RegisterDevice
≠≠) 7
(
≠≠7 8
[
≠≠8 9
FromBody
≠≠9 A
]
≠≠A B#
RegisterDeviceRequest
≠≠C X
request
≠≠Y `
)
≠≠` a
{
ÆÆ 	
try
ØØ 
{
∞∞ 
var
±± 
userId
±± 
=
±± 
User
±± !
.
±±! "
	FindFirst
±±" +
(
±±+ ,
System
±±, 2
.
±±2 3
Security
±±3 ;
.
±±; <
Claims
±±< B
.
±±B C

ClaimTypes
±±C M
.
±±M N
NameIdentifier
±±N \
)
±±\ ]
?
±±] ^
.
±±^ _
Value
±±_ d
;
±±d e
var
≥≥ %
activeSubscriptionCount
≥≥ +
=
≥≥, -
await
≥≥. 3
_context
≥≥4 <
.
≥≥< =
Subscriptions
≥≥= J
.
¥¥ 

CountAsync
¥¥ 
(
¥¥  
s
¥¥  !
=>
¥¥" $
s
¥¥% &
.
¥¥& '
UserID
¥¥' -
==
¥¥. 0
userId
¥¥1 7
&&
¥¥8 :
s
¥¥; <
.
¥¥< =
Status
¥¥= C
==
¥¥D F
$str
¥¥G O
)
¥¥O P
;
¥¥P Q
var
µµ  
activePrepaidCount
µµ &
=
µµ' (
await
µµ) .
_context
µµ/ 7
.
µµ7 8
Devices
µµ8 ?
.
∂∂ 
Where
∂∂ 
(
∂∂ 
d
∂∂ 
=>
∂∂ 
d
∂∂  !
.
∂∂! "
UserID
∂∂" (
==
∂∂) +
userId
∂∂, 2
)
∂∂2 3
.
∑∑ 

SelectMany
∑∑ 
(
∑∑  
d
∑∑  !
=>
∑∑" $
d
∑∑% &
.
∑∑& '
ServiceAccounts
∑∑' 6
)
∑∑6 7
.
∏∏ 
Where
∏∏ 
(
∏∏ 
sa
∏∏ 
=>
∏∏  
sa
∏∏! #
.
∏∏# $
Status
∏∏$ *
==
∏∏+ -
$str
∏∏. 6
&&
∏∏7 9
sa
∏∏: <
.
∏∏< =
ServiceType
∏∏= H
==
∏∏I K
$str
∏∏L U
)
∏∏U V
.
ππ 

CountAsync
ππ 
(
ππ  
)
ππ  !
;
ππ! "
var
∫∫ !
totalActiveServices
∫∫ '
=
∫∫( )%
activeSubscriptionCount
∫∫* A
+
∫∫B C 
activePrepaidCount
∫∫D V
;
∫∫V W
if
ºº 
(
ºº !
totalActiveServices
ºº '
>=
ºº( *
$num
ºº+ ,
)
ºº, -
return
ΩΩ 

BadRequest
ΩΩ %
(
ΩΩ% &
new
ΩΩ& )
{
ΩΩ* +
message
ΩΩ, 3
=
ΩΩ4 5
$str
ΩΩ6 p
}
ΩΩq r
)
ΩΩr s
;
ΩΩs t
var
øø 
serviceType
øø 
=
øø  !
request
øø" )
.
øø) *
ServiceType
øø* 5
??
øø6 8
$str
øø9 G
;
øøG H
if
¡¡ 
(
¡¡ 
serviceType
¡¡ 
==
¡¡  "
$str
¡¡# ,
&&
¡¡- /
string
¡¡0 6
.
¡¡6 7 
IsNullOrWhiteSpace
¡¡7 I
(
¡¡I J
request
¡¡J Q
.
¡¡Q R
PhoneNumber
¡¡R ]
)
¡¡] ^
)
¡¡^ _
{
¬¬ 
return
√√ 

BadRequest
√√ %
(
√√% &
new
√√& )
{
√√* +
message
√√, 3
=
√√4 5
$str
√√6 i
}
√√j k
)
√√k l
;
√√l m
}
ƒƒ 
var
≈≈ 

macAddress
≈≈ 
=
≈≈  
request
≈≈! (
.
≈≈( )

MacAddress
≈≈) 3
;
≈≈3 4
if
∆∆ 
(
∆∆ 
serviceType
∆∆ 
==
∆∆  "
$str
∆∆# ,
&&
∆∆- /
string
∆∆0 6
.
∆∆6 7 
IsNullOrWhiteSpace
∆∆7 I
(
∆∆I J

macAddress
∆∆J T
)
∆∆T U
)
∆∆U V
{
«« 

macAddress
»» 
=
»»  
$"
»»! #
$str
»»# &
{
»»& '
DateTime
»»' /
.
»»/ 0
UtcNow
»»0 6
:
»»6 7
$str
»»7 =
}
»»= >
$str
»»> ?
{
»»? @
new
»»@ C
Random
»»D J
(
»»J K
)
»»K L
.
»»L M
Next
»»M Q
(
»»Q R
$num
»»R V
,
»»V W
$num
»»X \
)
»»\ ]
:
»»] ^
$str
»»^ `
}
»»` a
$str
»»a b
{
»»b c
new
»»c f
Random
»»g m
(
»»m n
)
»»n o
.
»»o p
Next
»»p t
(
»»t u
$num
»»u y
,
»»y z
$num
»»{ 
)»» Ä
:»»Ä Å
$str»»Å É
}»»É Ñ
$str»»Ñ Ö
{»»Ö Ü
new»»Ü â
Random»»ä ê
(»»ê ë
)»»ë í
.»»í ì
Next»»ì ó
(»»ó ò
$num»»ò ú
,»»ú ù
$num»»û ¢
)»»¢ £
:»»£ §
$str»»§ ¶
}»»¶ ß
$str»»ß ®
{»»® ©
new»»© ¨
Random»»≠ ≥
(»»≥ ¥
)»»¥ µ
.»»µ ∂
Next»»∂ ∫
(»»∫ ª
$num»»ª ø
,»»ø ¿
$num»»¡ ≈
)»»≈ ∆
:»»∆ «
$str»»« …
}»»…  
"»»  À
;»»À Ã
}
…… 
var
ÀÀ 
device
ÀÀ 
=
ÀÀ 
new
ÀÀ  
Device
ÀÀ! '
{
ÃÃ 
UserID
ÕÕ 
=
ÕÕ 
userId
ÕÕ #
!
ÕÕ# $
,
ÕÕ$ %

MACAddress
ŒŒ 
=
ŒŒ  

macAddress
ŒŒ! +
,
ŒŒ+ ,
Status
œœ 
=
œœ 
$str
œœ %
,
œœ% &

DeviceType
–– 
=
––  
$str
––! '
}
—— 
;
—— 
_context
““ 
.
““ 
Devices
““  
.
““  !
Add
““! $
(
““$ %
device
““% +
)
““+ ,
;
““, -
await
”” 
_context
”” 
.
”” 
SaveChangesAsync
”” /
(
””/ 0
)
””0 1
;
””1 2
var
’’ 
serviceAccount
’’ "
=
’’# $
new
’’% (
ServiceAccount
’’) 7
{
÷÷ 
DeviceID
◊◊ 
=
◊◊ 
device
◊◊ %
.
◊◊% &
DeviceID
◊◊& .
,
◊◊. /
ServiceType
ÿÿ 
=
ÿÿ  !
serviceType
ÿÿ" -
,
ÿÿ- .
Status
ŸŸ 
=
ŸŸ 
$str
ŸŸ %
}
⁄⁄ 
;
⁄⁄ 
_context
€€ 
.
€€ 
ServiceAccounts
€€ (
.
€€( )
Add
€€) ,
(
€€, -
serviceAccount
€€- ;
)
€€; <
;
€€< =
await
‹‹ 
_context
‹‹ 
.
‹‹ 
SaveChangesAsync
‹‹ /
(
‹‹/ 0
)
‹‹0 1
;
‹‹1 2
if
ﬁﬁ 
(
ﬁﬁ 
serviceType
ﬁﬁ 
==
ﬁﬁ  "
$str
ﬁﬁ# ,
)
ﬁﬁ, -
{
ﬂﬂ 
var
‡‡ 
prepaidLoad
‡‡ #
=
‡‡$ %
new
‡‡& )
PrepaidLoad
‡‡* 5
{
·· 
ServiceAccountID
‚‚ (
=
‚‚) *
serviceAccount
‚‚+ 9
.
‚‚9 :
ServiceAccountID
‚‚: J
,
‚‚J K
PhoneNumber
„„ #
=
„„$ %
request
„„& -
.
„„- .
PhoneNumber
„„. 9
,
„„9 :

LoadAmount
‰‰ "
=
‰‰# $
$num
‰‰% &
,
‰‰& '
RemainingBalance
ÂÂ (
=
ÂÂ) *
$num
ÂÂ+ ,
}
ÊÊ 
;
ÊÊ 
_context
ÁÁ 
.
ÁÁ 
PrepaidLoads
ÁÁ )
.
ÁÁ) *
Add
ÁÁ* -
(
ÁÁ- .
prepaidLoad
ÁÁ. 9
)
ÁÁ9 :
;
ÁÁ: ;
await
ËË 
_context
ËË "
.
ËË" #
SaveChangesAsync
ËË# 3
(
ËË3 4
)
ËË4 5
;
ËË5 6
}
ÈÈ 
else
ÍÍ 
{
ÎÎ 
int
ÏÏ 
planId
ÏÏ 
;
ÏÏ 
if
ÌÌ 
(
ÌÌ 
request
ÌÌ 
.
ÌÌ  
PlanID
ÌÌ  &
.
ÌÌ& '
HasValue
ÌÌ' /
)
ÌÌ/ 0
{
ÓÓ 
planId
ÔÔ 
=
ÔÔ  
request
ÔÔ! (
.
ÔÔ( )
PlanID
ÔÔ) /
.
ÔÔ/ 0
Value
ÔÔ0 5
;
ÔÔ5 6
}
 
else
ÒÒ 
{
ÚÚ 
var
ÛÛ 
	macSuffix
ÛÛ %
=
ÛÛ& '
request
ÛÛ( /
.
ÛÛ/ 0

MacAddress
ÛÛ0 :
.
ÛÛ: ;
Replace
ÛÛ; B
(
ÛÛB C
$str
ÛÛC F
,
ÛÛF G
$str
ÛÛH J
)
ÛÛJ K
.
ÛÛK L
ToUpper
ÛÛL S
(
ÛÛS T
)
ÛÛT U
.
ÛÛU V
	Substring
ÛÛV _
(
ÛÛ_ `
request
ÛÛ` g
.
ÛÛg h

MacAddress
ÛÛh r
.
ÛÛr s
Replace
ÛÛs z
(
ÛÛz {
$str
ÛÛ{ ~
,
ÛÛ~ 
$strÛÛÄ Ç
)ÛÛÇ É
.ÛÛÉ Ñ
LengthÛÛÑ ä
-ÛÛã å
$numÛÛç é
)ÛÛé è
;ÛÛè ê
int
ÙÙ 
	speedMbps
ÙÙ %
=
ÙÙ& '
	macSuffix
ÙÙ( 1
switch
ÙÙ2 8
{
ıı 
$str
ˆˆ  
=>
ˆˆ! #
$num
ˆˆ$ &
,
ˆˆ& '
$str
˜˜  
=>
˜˜! #
$num
˜˜$ '
,
˜˜' (
$str
¯¯  
=>
¯¯! #
$num
¯¯$ '
,
¯¯' (
$str
˘˘  
=>
˘˘! #
$num
˘˘$ '
,
˘˘' (
_
˙˙ 
=>
˙˙  
$num
˙˙! "
}
˚˚ 
;
˚˚ 
if
˝˝ 
(
˝˝ 
	speedMbps
˝˝ %
==
˝˝& (
$num
˝˝) *
)
˝˝* +
return
˛˛ "

BadRequest
˛˛# -
(
˛˛- .
new
˛˛. 1
{
˛˛2 3
message
˛˛4 ;
=
˛˛< =
$str˛˛> ñ
}˛˛ó ò
)˛˛ò ô
;˛˛ô ö
var
ÄÄ 
plan
ÄÄ  
=
ÄÄ! "
await
ÄÄ# (
_context
ÄÄ) 1
.
ÄÄ1 2
SubscriptionPlans
ÄÄ2 C
.
ÅÅ 
AsNoTracking
ÅÅ )
(
ÅÅ) *
)
ÅÅ* +
.
ÇÇ 
Where
ÇÇ "
(
ÇÇ" #
p
ÇÇ# $
=>
ÇÇ% '
p
ÇÇ( )
.
ÇÇ) *
	SpeedMbps
ÇÇ* 3
==
ÇÇ4 6
	speedMbps
ÇÇ7 @
)
ÇÇ@ A
.
ÉÉ 
Select
ÉÉ #
(
ÉÉ# $
p
ÉÉ$ %
=>
ÉÉ& (
new
ÉÉ) ,
{
ÉÉ- .
p
ÉÉ/ 0
.
ÉÉ0 1
PlanID
ÉÉ1 7
}
ÉÉ8 9
)
ÉÉ9 :
.
ÑÑ !
FirstOrDefaultAsync
ÑÑ 0
(
ÑÑ0 1
)
ÑÑ1 2
;
ÑÑ2 3
if
ÖÖ 
(
ÖÖ 
plan
ÖÖ  
==
ÖÖ! #
null
ÖÖ$ (
)
ÖÖ( )
return
ÜÜ "

BadRequest
ÜÜ# -
(
ÜÜ- .
new
ÜÜ. 1
{
ÜÜ2 3
message
ÜÜ4 ;
=
ÜÜ< =
$"
ÜÜ> @
$strÜÜ@ ä
"ÜÜä ã
}ÜÜå ç
)ÜÜç é
;ÜÜé è
planId
áá 
=
áá  
plan
áá! %
.
áá% &
PlanID
áá& ,
;
áá, -
}
àà 
var
ää 
subscription
ää $
=
ää% &
new
ää' *
Subscription
ää+ 7
{
ãã 
ServiceAccountID
åå (
=
åå) *
serviceAccount
åå+ 9
.
åå9 :
ServiceAccountID
åå: J
,
ååJ K
PlanID
çç 
=
çç  
planId
çç! '
,
çç' (
UserID
éé 
=
éé  
userId
éé! '
!
éé' (
,
éé( )
	StartDate
èè !
=
èè" #
DateTime
èè$ ,
.
èè, -
UtcNow
èè- 3
,
èè3 4
Status
êê 
=
êê  
$str
êê! )
}
ëë 
;
ëë 
_context
íí 
.
íí 
Subscriptions
íí *
.
íí* +
Add
íí+ .
(
íí. /
subscription
íí/ ;
)
íí; <
;
íí< =
}
ìì 
var
ïï 

onboarding
ïï 
=
ïï  
await
ïï! &
_context
ïï' /
.
ïï/ 0 
OnboardingStatuses
ïï0 B
.
ïïB C!
FirstOrDefaultAsync
ïïC V
(
ïïV W
o
ïïW X
=>
ïïY [
o
ïï\ ]
.
ïï] ^
UserID
ïï^ d
==
ïïe g
userId
ïïh n
)
ïïn o
;
ïïo p
if
ññ 
(
ññ 

onboarding
ññ 
!=
ññ !
null
ññ" &
)
ññ& '

onboarding
óó 
.
óó !
HasRegisteredDevice
óó 2
=
óó3 4
true
óó5 9
;
óó9 :
await
ôô 
_context
ôô 
.
ôô 
SaveChangesAsync
ôô /
(
ôô/ 0
)
ôô0 1
;
ôô1 2
return
õõ 
Ok
õõ 
(
õõ 
new
õõ 
{
õõ 
message
õõ  '
=
õõ( )
$str
õõ* J
,
õõJ K
deviceId
õõL T
=
õõU V
device
õõW ]
.
õõ] ^
DeviceID
õõ^ f
,
õõf g
serviceType
õõh s
}
õõt u
)
õõu v
;
õõv w
}
úú 
catch
ùù 
(
ùù 
	Exception
ùù 
ex
ùù 
)
ùù  
{
ûû 
return
üü 

BadRequest
üü !
(
üü! "
new
üü" %
{
üü& '
message
üü( /
=
üü0 1
$"
üü2 4
$str
üü4 O
{
üüO P
ex
üüP R
.
üüR S
Message
üüS Z
}
üüZ [
"
üü[ \
}
üü] ^
)
üü^ _
;
üü_ `
}
†† 
}
°° 	
[
££ 	
	Authorize
££	 
]
££ 
[
§§ 	&
RequireEmailVerification
§§	 !
]
§§! "
[
•• 	
HttpPost
••	 
(
•• 
$str
•• %
)
••% &
]
••& '
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
CompleteTutorial
¶¶) 9
(
¶¶9 :
)
¶¶: ;
{
ßß 	
var
®® 
userId
®® 
=
®® 
User
®® 
.
®® 
	FindFirst
®® '
(
®®' (
System
®®( .
.
®®. /
Security
®®/ 7
.
®®7 8
Claims
®®8 >
.
®®> ?

ClaimTypes
®®? I
.
®®I J
NameIdentifier
®®J X
)
®®X Y
?
®®Y Z
.
®®Z [
Value
®®[ `
;
®®` a
var
©© 
activeSubCount
©© 
=
©©  
await
©©! &
_context
©©' /
.
©©/ 0
Subscriptions
©©0 =
.
™™ 

CountAsync
™™ 
(
™™ 
s
™™ 
=>
™™  
s
™™! "
.
™™" #
UserID
™™# )
==
™™* ,
userId
™™- 3
&&
™™4 6
s
™™7 8
.
™™8 9
Status
™™9 ?
==
™™@ B
$str
™™C K
)
™™K L
;
™™L M
var
´´ 
activePrepCount
´´ 
=
´´  !
await
´´" '
_context
´´( 0
.
´´0 1
Devices
´´1 8
.
¨¨ 
Where
¨¨ 
(
¨¨ 
d
¨¨ 
=>
¨¨ 
d
¨¨ 
.
¨¨ 
UserID
¨¨ $
==
¨¨% '
userId
¨¨( .
)
¨¨. /
.
≠≠ 

SelectMany
≠≠ 
(
≠≠ 
d
≠≠ 
=>
≠≠  
d
≠≠! "
.
≠≠" #
ServiceAccounts
≠≠# 2
)
≠≠2 3
.
ÆÆ 
Where
ÆÆ 
(
ÆÆ 
sa
ÆÆ 
=>
ÆÆ 
sa
ÆÆ 
.
ÆÆ  
Status
ÆÆ  &
==
ÆÆ' )
$str
ÆÆ* 2
&&
ÆÆ3 5
sa
ÆÆ6 8
.
ÆÆ8 9
ServiceType
ÆÆ9 D
==
ÆÆE G
$str
ÆÆH Q
)
ÆÆQ R
.
ØØ 

CountAsync
ØØ 
(
ØØ 
)
ØØ 
;
ØØ 
if
±± 
(
±± 
activeSubCount
±± 
+
±±  
activePrepCount
±±! 0
>=
±±1 3
$num
±±4 5
)
±±5 6
return
≤≤ 

BadRequest
≤≤ !
(
≤≤! "
new
≤≤" %
{
≤≤& '
message
≤≤( /
=
≤≤0 1
$str
≤≤2 l
}
≤≤m n
)
≤≤n o
;
≤≤o p
var
¥¥ 

onboarding
¥¥ 
=
¥¥ 
await
¥¥ "
_context
¥¥# +
.
¥¥+ , 
OnboardingStatuses
¥¥, >
.
¥¥> ?!
FirstOrDefaultAsync
¥¥? R
(
¥¥R S
o
¥¥S T
=>
¥¥U W
o
¥¥X Y
.
¥¥Y Z
UserID
¥¥Z `
==
¥¥a c
userId
¥¥d j
)
¥¥j k
;
¥¥k l
if
µµ 
(
µµ 

onboarding
µµ 
==
µµ 
null
µµ "
)
µµ" #
return
∂∂ 
NotFound
∂∂ 
(
∂∂  
new
∂∂  #
{
∂∂$ %
message
∂∂& -
=
∂∂. /
$str
∂∂0 M
}
∂∂N O
)
∂∂O P
;
∂∂P Q

onboarding
∏∏ 
.
∏∏ "
HasCompletedTutorial
∏∏ +
=
∏∏, -
true
∏∏. 2
;
∏∏2 3
await
ππ 
_context
ππ 
.
ππ 
SaveChangesAsync
ππ +
(
ππ+ ,
)
ππ, -
;
ππ- .
return
ªª 
Ok
ªª 
(
ªª 
new
ªª 
{
ªª 
message
ªª #
=
ªª$ %
$str
ªª& G
}
ªªH I
)
ªªI J
;
ªªJ K
}
ºº 	
[
ææ 	
HttpPost
ææ	 
(
ææ 
$str
ææ #
)
ææ# $
]
ææ$ %
public
øø 
async
øø 
Task
øø 
<
øø 
IActionResult
øø '
>
øø' (
ForgotPassword
øø) 7
(
øø7 8
[
øø8 9
FromBody
øø9 A
]
øøA B 
VerifyEmailRequest
øøC U
request
øøV ]
)
øø] ^
{
¿¿ 	
var
¡¡ 
user
¡¡ 
=
¡¡ 
await
¡¡ 
_userManager
¡¡ )
.
¡¡) *
FindByEmailAsync
¡¡* :
(
¡¡: ;
request
¡¡; B
.
¡¡B C
Email
¡¡C H
)
¡¡H I
;
¡¡I J
if
¬¬ 
(
¬¬ 
user
¬¬ 
==
¬¬ 
null
¬¬ 
)
¬¬ 
return
√√ 
Ok
√√ 
(
√√ 
new
√√ 
{
√√ 
message
√√  '
=
√√( )
$str
√√* [
}
√√\ ]
)
√√] ^
;
√√^ _
var
≈≈ 
code
≈≈ 
=
≈≈ 
new
≈≈ 
Random
≈≈ !
(
≈≈! "
)
≈≈" #
.
≈≈# $
Next
≈≈$ (
(
≈≈( )
$num
≈≈) /
,
≈≈/ 0
$num
≈≈1 7
)
≈≈7 8
.
≈≈8 9
ToString
≈≈9 A
(
≈≈A B
)
≈≈B C
;
≈≈C D
_context
∆∆ 
.
∆∆ 
VerificationCodes
∆∆ &
.
∆∆& '
Add
∆∆' *
(
∆∆* +
new
∆∆+ .
VerificationCode
∆∆/ ?
{
«« 
Email
»» 
=
»» 
request
»» 
.
»»  
Email
»»  %
,
»»% &
Code
…… 
=
…… 
code
…… 
,
…… 
	ExpiresAt
   
=
   
DateTime
   $
.
  $ %
UtcNow
  % +
.
  + ,

AddMinutes
  , 6
(
  6 7
$num
  7 9
)
  9 :
}
ÀÀ 
)
ÀÀ 
;
ÀÀ 
await
ÃÃ 
_context
ÃÃ 
.
ÃÃ 
SaveChangesAsync
ÃÃ +
(
ÃÃ+ ,
)
ÃÃ, -
;
ÃÃ- .
await
ÕÕ 
_emailService
ÕÕ 
.
ÕÕ  '
SendVerificationCodeAsync
ÕÕ  9
(
ÕÕ9 :
request
ÕÕ: A
.
ÕÕA B
Email
ÕÕB G
,
ÕÕG H
code
ÕÕI M
)
ÕÕM N
;
ÕÕN O
return
œœ 
Ok
œœ 
(
œœ 
new
œœ 
{
œœ 
message
œœ #
=
œœ$ %
$str
œœ& E
}
œœF G
)
œœG H
;
œœH I
}
–– 	
[
““ 	
HttpPost
““	 
(
““ 
$str
““ "
)
““" #
]
““# $
public
”” 
async
”” 
Task
”” 
<
”” 
IActionResult
”” '
>
””' (
ResetPassword
””) 6
(
””6 7
[
””7 8
FromBody
””8 @
]
””@ A"
ResetPasswordRequest
””B V
request
””W ^
)
””^ _
{
‘‘ 	
var
’’ 
	userAgent
’’ 
=
’’ 
Request
’’ #
.
’’# $
Headers
’’$ +
[
’’+ ,
$str
’’, 8
]
’’8 9
.
’’9 :
ToString
’’: B
(
’’B C
)
’’C D
;
’’D E
var
÷÷ 
	ipAddress
÷÷ 
=
÷÷ 
HttpContext
÷÷ '
.
÷÷' (

Connection
÷÷( 2
.
÷÷2 3
RemoteIpAddress
÷÷3 B
?
÷÷B C
.
÷÷C D
ToString
÷÷D L
(
÷÷L M
)
÷÷M N
;
÷÷N O
if
◊◊ 
(
◊◊ (
_ipDeviceReputationService
◊◊ *
.
◊◊* +
	IsBlocked
◊◊+ 4
(
◊◊4 5
	ipAddress
◊◊5 >
,
◊◊> ?
	userAgent
◊◊@ I
,
◊◊I J
out
◊◊K N
var
◊◊O R
blockReason
◊◊S ^
)
◊◊^ _
)
◊◊_ `
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
ÿÿ9 I
{
ÿÿI J
blockReason
ÿÿJ U
}
ÿÿU V
$str
ÿÿV o
"
ÿÿo p
}
ÿÿq r
)
ÿÿr s
;
ÿÿs t
var
⁄⁄ 
verification
⁄⁄ 
=
⁄⁄ 
await
⁄⁄ $
_context
⁄⁄% -
.
⁄⁄- .
VerificationCodes
⁄⁄. ?
.
€€ !
FirstOrDefaultAsync
€€ $
(
€€$ %
v
€€% &
=>
€€' )
v
€€* +
.
€€+ ,
Email
€€, 1
==
€€2 4
request
€€5 <
.
€€< =
Email
€€= B
&&
€€C E
v
€€F G
.
€€G H
Code
€€H L
==
€€M O
request
€€P W
.
€€W X
Code
€€X \
&&
€€] _
!
€€` a
v
€€a b
.
€€b c
IsUsed
€€c i
&&
€€j l
v
€€m n
.
€€n o
	ExpiresAt
€€o x
>
€€y z
DateTime€€{ É
.€€É Ñ
UtcNow€€Ñ ä
)€€ä ã
;€€ã å
if
›› 
(
›› 
verification
›› 
==
›› 
null
››  $
)
››$ %
{
ﬁﬁ (
_ipDeviceReputationService
ﬂﬂ *
.
ﬂﬂ* +
RegisterFailure
ﬂﬂ+ :
(
ﬂﬂ: ;
	ipAddress
ﬂﬂ; D
,
ﬂﬂD E
	userAgent
ﬂﬂF O
)
ﬂﬂO P
;
ﬂﬂP Q
return
‡‡ 

BadRequest
‡‡ !
(
‡‡! "
new
‡‡" %
{
‡‡& '
message
‡‡( /
=
‡‡0 1
$str
‡‡2 Q
}
‡‡R S
)
‡‡S T
;
‡‡T U
}
·· 
var
„„ 
user
„„ 
=
„„ 
await
„„ 
_userManager
„„ )
.
„„) *
FindByEmailAsync
„„* :
(
„„: ;
request
„„; B
.
„„B C
Email
„„C H
)
„„H I
;
„„I J
if
‰‰ 
(
‰‰ 
user
‰‰ 
==
‰‰ 
null
‰‰ 
)
‰‰ 
{
ÂÂ (
_ipDeviceReputationService
ÊÊ *
.
ÊÊ* +
RegisterFailure
ÊÊ+ :
(
ÊÊ: ;
	ipAddress
ÊÊ; D
,
ÊÊD E
	userAgent
ÊÊF O
)
ÊÊO P
;
ÊÊP Q
return
ÁÁ 
NotFound
ÁÁ 
(
ÁÁ  
new
ÁÁ  #
{
ÁÁ$ %
message
ÁÁ& -
=
ÁÁ. /
$str
ÁÁ0 @
}
ÁÁA B
)
ÁÁB C
;
ÁÁC D
}
ËË 
if
ÍÍ 
(
ÍÍ 
await
ÍÍ $
_passwordBreachService
ÍÍ ,
.
ÍÍ, -
IsBreachedAsync
ÍÍ- <
(
ÍÍ< =
request
ÍÍ= D
.
ÍÍD E
NewPassword
ÍÍE P
)
ÍÍP Q
)
ÍÍQ R
return
ÎÎ 

BadRequest
ÎÎ !
(
ÎÎ! "
new
ÎÎ" %
{
ÎÎ& '
message
ÎÎ( /
=
ÎÎ0 1
$strÎÎ2 Ä
}ÎÎÅ Ç
)ÎÎÇ É
;ÎÎÉ Ñ
var
ÌÌ 
token
ÌÌ 
=
ÌÌ 
await
ÌÌ 
_userManager
ÌÌ *
.
ÌÌ* +-
GeneratePasswordResetTokenAsync
ÌÌ+ J
(
ÌÌJ K
user
ÌÌK O
)
ÌÌO P
;
ÌÌP Q
var
ÓÓ 
result
ÓÓ 
=
ÓÓ 
await
ÓÓ 
_userManager
ÓÓ +
.
ÓÓ+ , 
ResetPasswordAsync
ÓÓ, >
(
ÓÓ> ?
user
ÓÓ? C
,
ÓÓC D
token
ÓÓE J
,
ÓÓJ K
request
ÓÓL S
.
ÓÓS T
NewPassword
ÓÓT _
)
ÓÓ_ `
;
ÓÓ` a
if
 
(
 
!
 
result
 
.
 
	Succeeded
 !
)
! "
{
ÒÒ (
_ipDeviceReputationService
ÚÚ *
.
ÚÚ* +
RegisterFailure
ÚÚ+ :
(
ÚÚ: ;
	ipAddress
ÚÚ; D
,
ÚÚD E
	userAgent
ÚÚF O
)
ÚÚO P
;
ÚÚP Q
return
ÛÛ 

BadRequest
ÛÛ !
(
ÛÛ! "
new
ÛÛ" %
{
ÛÛ& '
message
ÛÛ( /
=
ÛÛ0 1
string
ÛÛ2 8
.
ÛÛ8 9
Join
ÛÛ9 =
(
ÛÛ= >
$str
ÛÛ> B
,
ÛÛB C
result
ÛÛD J
.
ÛÛJ K
Errors
ÛÛK Q
.
ÛÛQ R
Select
ÛÛR X
(
ÛÛX Y
e
ÛÛY Z
=>
ÛÛ[ ]
e
ÛÛ^ _
.
ÛÛ_ `
Description
ÛÛ` k
)
ÛÛk l
)
ÛÛl m
}
ÛÛn o
)
ÛÛo p
;
ÛÛp q
}
ÙÙ 
verification
ˆˆ 
.
ˆˆ 
IsUsed
ˆˆ 
=
ˆˆ  !
true
ˆˆ" &
;
ˆˆ& '
await
˜˜ 
_context
˜˜ 
.
˜˜ 
SaveChangesAsync
˜˜ +
(
˜˜+ ,
)
˜˜, -
;
˜˜- .(
_ipDeviceReputationService
˘˘ &
.
˘˘& '
RegisterSuccess
˘˘' 6
(
˘˘6 7
	ipAddress
˘˘7 @
,
˘˘@ A
	userAgent
˘˘B K
)
˘˘K L
;
˘˘L M
return
˚˚ 
Ok
˚˚ 
(
˚˚ 
new
˚˚ 
{
˚˚ 
message
˚˚ #
=
˚˚$ %
$str
˚˚& C
}
˚˚D E
)
˚˚E F
;
˚˚F G
}
¸¸ 	
}
˝˝ 
public
ˇˇ 

class
ˇˇ #
RegisterDeviceRequest
ˇˇ &
{
ÄÄ 
public
ÅÅ 
string
ÅÅ 
?
ÅÅ 

MacAddress
ÅÅ !
{
ÅÅ" #
get
ÅÅ$ '
;
ÅÅ' (
set
ÅÅ) ,
;
ÅÅ, -
}
ÅÅ. /
public
ÇÇ 
string
ÇÇ 
ServiceType
ÇÇ !
{
ÇÇ" #
get
ÇÇ$ '
;
ÇÇ' (
set
ÇÇ) ,
;
ÇÇ, -
}
ÇÇ. /
=
ÇÇ0 1
string
ÇÇ2 8
.
ÇÇ8 9
Empty
ÇÇ9 >
;
ÇÇ> ?
public
ÉÉ 
int
ÉÉ 
?
ÉÉ 
PlanID
ÉÉ 
{
ÉÉ 
get
ÉÉ  
;
ÉÉ  !
set
ÉÉ" %
;
ÉÉ% &
}
ÉÉ' (
public
ÑÑ 
string
ÑÑ 
?
ÑÑ 
PhoneNumber
ÑÑ "
{
ÑÑ# $
get
ÑÑ% (
;
ÑÑ( )
set
ÑÑ* -
;
ÑÑ- .
}
ÑÑ/ 0
}
ÖÖ 
public
áá 

class
áá #
Verify2FALoginRequest
áá &
{
àà 
public
ââ 
string
ââ 
Email
ââ 
{
ââ 
get
ââ !
;
ââ! "
set
ââ# &
;
ââ& '
}
ââ( )
=
ââ* +
string
ââ, 2
.
ââ2 3
Empty
ââ3 8
;
ââ8 9
public
ää 
string
ää 
Code
ää 
{
ää 
get
ää  
;
ää  !
set
ää" %
;
ää% &
}
ää' (
=
ää) *
string
ää+ 1
.
ää1 2
Empty
ää2 7
;
ää7 8
}
ãã 
}åå Êº
VE:\projects\sharp_tayokonnektado\TayoKonnektado-project\Controllers\AdminController.cs
	namespace 	"
TayoKonnektado_project
  
.  !
Controllers! ,
{		 
[

 
	Authorize

 
(

 
Roles

 
=

 
$str

 /
)

/ 0
]

0 1
[ 
ApiController 
] 
[ 
Route 

(
 
$str 
) 
] 
public 

class 
AdminController  
:! "
ControllerBase# 1
{ 
private 
readonly  
ApplicationDbContext -
_context. 6
;6 7
private 
readonly %
CustomerManagementService 2
_customerService3 C
;C D
private 
readonly #
TicketManagementService 0
_ticketService1 ?
;? @
private 
readonly $
PaymentManagementService 1
_paymentService2 A
;A B
private 
readonly )
SubscriptionManagementService 6 
_subscriptionService7 K
;K L
private 
readonly "
StaffManagementService /
_staffService0 =
;= >
private 
readonly 
DashboardService )
_dashboardService* ;
;; <
private 
readonly !
PlanManagementService .
_planService/ ;
;; <
private 
readonly  
FAQManagementService -
_faqService. 9
;9 :
public 
AdminController 
(  
ApplicationDbContext  
context! (
,( )%
CustomerManagementService %
customerService& 5
,5 6#
TicketManagementService #
ticketService$ 1
,1 2$
PaymentManagementService $
paymentService% 3
,3 4)
SubscriptionManagementService )
subscriptionService* =
,= >"
StaffManagementService "
staffService# /
,/ 0
DashboardService   
dashboardService   -
,  - .!
PlanManagementService!! !
planService!!" -
,!!- . 
FAQManagementService""  

faqService""! +
)""+ ,
{## 	
_context$$ 
=$$ 
context$$ 
;$$ 
_customerService%% 
=%% 
customerService%% .
;%%. /
_ticketService&& 
=&& 
ticketService&& *
;&&* +
_paymentService'' 
='' 
paymentService'' ,
;'', - 
_subscriptionService((  
=((! "
subscriptionService((# 6
;((6 7
_staffService)) 
=)) 
staffService)) (
;))( )
_dashboardService** 
=** 
dashboardService**  0
;**0 1
_planService++ 
=++ 
planService++ &
;++& '
_faqService,, 
=,, 

faqService,, $
;,,$ %
}-- 	
[// 	
	Authorize//	 
(// 
Roles// 
=// 
$str// -
)//- .
]//. /
[00 	
HttpGet00	 
(00 
$str00 
)00 
]00 
public11 
async11 
Task11 
<11 
IActionResult11 '
>11' (
GetCustomers11) 5
(115 6
)116 7
=>118 :
Ok11; =
(11= >
await11> C
_customerService11D T
.11T U 
GetAllCustomersAsync11U i
(11i j
)11j k
)11k l
;11l m
[33 	
	Authorize33	 
(33 
Roles33 
=33 
$str33 -
)33- .
]33. /
[44 	
HttpGet44	 
(44 
$str44 !
)44! "
]44" #
public55 
async55 
Task55 
<55 
IActionResult55 '
>55' (
GetCustomer55) 4
(554 5
string555 ;
id55< >
)55> ?
{66 	
var77 
customer77 
=77 
await77  
_customerService77! 1
.771 2 
GetCustomerByIdAsync772 F
(77F G
id77G I
)77I J
;77J K
return88 
customer88 
==88 
null88 #
?88$ %
NotFound88& .
(88. /
)88/ 0
:881 2
Ok883 5
(885 6
customer886 >
)88> ?
;88? @
}99 	
[;; 	
	Authorize;;	 
(;; 
Roles;; 
=;; 
$str;; -
);;- .
];;. /
[<< 	
HttpPut<<	 
(<< 
$str<< !
)<<! "
]<<" #
public== 
async== 
Task== 
<== 
IActionResult== '
>==' (
UpdateCustomer==) 7
(==7 8
string==8 >
id==? A
,==A B
[==C D
FromBody==D L
]==L M!
UpdateCustomerRequest==N c
request==d k
)==k l
{>> 	
var?? 
success?? 
=?? 
await?? 
_customerService??  0
.??0 1
UpdateCustomerAsync??1 D
(??D E
id??E G
,??G H
request??I P
.??P Q
	FirstName??Q Z
,??Z [
request??\ c
.??c d
LastName??d l
,??l m
request??n u
.??u v
Email??v {
,??{ |
request	??} Ñ
.
??Ñ Ö
Status
??Ö ã
)
??ã å
;
??å ç
return@@ 
success@@ 
?@@ 
Ok@@ 
(@@  
new@@  #
{@@$ %
message@@& -
=@@. /
$str@@0 O
}@@P Q
)@@Q R
:@@S T
NotFound@@U ]
(@@] ^
)@@^ _
;@@_ `
}AA 	
[CC 	
	AuthorizeCC	 
(CC 
RolesCC 
=CC 
$strCC '
)CC' (
]CC( )
[DD 	

HttpDeleteDD	 
(DD 
$strDD $
)DD$ %
]DD% &
publicEE 
asyncEE 
TaskEE 
<EE 
IActionResultEE '
>EE' (
DeleteCustomerEE) 7
(EE7 8
stringEE8 >
idEE? A
)EEA B
{FF 	
varGG 
successGG 
=GG 
awaitGG 
_customerServiceGG  0
.GG0 1
DeleteCustomerAsyncGG1 D
(GGD E
idGGE G
)GGG H
;GGH I
returnHH 
successHH 
?HH 
OkHH 
(HH  
newHH  #
{HH$ %
messageHH& -
=HH. /
$strHH0 O
}HHP Q
)HHQ R
:HHS T
NotFoundHHU ]
(HH] ^
)HH^ _
;HH_ `
}II 	
[KK 	
	AuthorizeKK	 
(KK 
RolesKK 
=KK 
$strKK 3
)KK3 4
]KK4 5
[LL 	
HttpGetLL	 
(LL 
$strLL 
)LL 
]LL 
publicMM 
asyncMM 
TaskMM 
<MM 
IActionResultMM '
>MM' (
GetAllTicketsMM) 6
(MM6 7
)MM7 8
=>MM9 ;
OkMM< >
(MM> ?
awaitMM? D
_ticketServiceMME S
.MMS T
GetAllTicketsAsyncMMT f
(MMf g
)MMg h
)MMh i
;MMi j
[OO 	
HttpPutOO	 
(OO 
$strOO 
)OO  
]OO  !
publicPP 
asyncPP 
TaskPP 
<PP 
IActionResultPP '
>PP' (
UpdateTicketPP) 5
(PP5 6
intPP6 9
idPP: <
,PP< =
[PP> ?
FromBodyPP? G
]PPG H
UpdateTicketRequestPPI \
requestPP] d
)PPd e
{QQ 	
varRR 
successRR 
=RR 
awaitRR 
_ticketServiceRR  .
.RR. /
UpdateTicketAsyncRR/ @
(RR@ A
idRRA C
,RRC D
requestRRE L
.RRL M
StatusRRM S
,RRS T
requestRRU \
.RR\ ]
AssignedStaffIDRR] l
)RRl m
;RRm n
returnSS 
successSS 
?SS 
OkSS 
(SS  
newSS  #
{SS$ %
messageSS& -
=SS. /
$strSS0 M
}SSN O
)SSO P
:SSQ R
NotFoundSSS [
(SS[ \
)SS\ ]
;SS] ^
}TT 	
[VV 	
HttpPostVV	 
(VV 
$strVV &
)VV& '
]VV' (
publicWW 
asyncWW 
TaskWW 
<WW 
IActionResultWW '
>WW' (
ReplyToTicketWW) 6
(WW6 7
intWW7 :
idWW; =
,WW= >
[WW? @
FromBodyWW@ H
]WWH I
ReplyTicketRequestWWJ \
requestWW] d
)WWd e
{XX 	
varYY 
userIdYY 
=YY 
UserYY 
.YY 
	FindFirstYY '
(YY' (
SystemYY( .
.YY. /
SecurityYY/ 7
.YY7 8
ClaimsYY8 >
.YY> ?

ClaimTypesYY? I
.YYI J
NameIdentifierYYJ X
)YYX Y
?YYY Z
.YYZ [
ValueYY[ `
;YY` a
ifZZ 
(ZZ 
userIdZZ 
==ZZ 
nullZZ 
)ZZ 
returnZZ  &
UnauthorizedZZ' 3
(ZZ3 4
)ZZ4 5
;ZZ5 6
var\\ 
success\\ 
=\\ 
await\\ 
_ticketService\\  .
.\\. /
ReplyToTicketAsync\\/ A
(\\A B
id\\B D
,\\D E
userId\\F L
,\\L M
request\\N U
.\\U V
Message\\V ]
)\\] ^
;\\^ _
return]] 
success]] 
?]] 
Ok]] 
(]]  
new]]  #
{]]$ %
message]]& -
=]]. /
$str]]0 I
}]]J K
)]]K L
:]]M N
NotFound]]O W
(]]W X
)]]X Y
;]]Y Z
}^^ 	
[`` 	
HttpPost``	 
(`` 
$str`` (
)``( )
]``) *
publicaa 
asyncaa 
Taskaa 
<aa 
IActionResultaa '
>aa' (
ArchiveTicketaa) 6
(aa6 7
intaa7 :
idaa; =
)aa= >
{bb 	
varcc 
successcc 
=cc 
awaitcc 
_ticketServicecc  .
.cc. /
ArchiveTicketAsynccc/ A
(ccA B
idccB D
)ccD E
;ccE F
returndd 
successdd 
?dd 
Okdd 
(dd  
newdd  #
{dd$ %
messagedd& -
=dd. /
$strdd0 N
}ddO P
)ddP Q
:ddR S

BadRequestddT ^
(dd^ _
newdd_ b
{ddc d
messagedde l
=ddm n
$str	ddo î
}
ddï ñ
)
ddñ ó
;
ddó ò
}ee 	
[gg 	
HttpPostgg	 
(gg 
$strgg *
)gg* +
]gg+ ,
publichh 
asynchh 
Taskhh 
<hh 
IActionResulthh '
>hh' (
UnarchiveTickethh) 8
(hh8 9
inthh9 <
idhh= ?
)hh? @
{ii 	
varjj 
successjj 
=jj 
awaitjj 
_ticketServicejj  .
.jj. / 
UnarchiveTicketAsyncjj/ C
(jjC D
idjjD F
)jjF G
;jjG H
returnkk 
successkk 
?kk 
Okkk 
(kk  
newkk  #
{kk$ %
messagekk& -
=kk. /
$strkk0 N
}kkO P
)kkP Q
:kkR S
NotFoundkkT \
(kk\ ]
)kk] ^
;kk^ _
}ll 	
[nn 	

HttpDeletenn	 
(nn 
$strnn "
)nn" #
]nn# $
publicoo 
asyncoo 
Taskoo 
<oo 
IActionResultoo '
>oo' (
DeleteTicketoo) 5
(oo5 6
intoo6 9
idoo: <
)oo< =
{pp 	
varqq 
successqq 
=qq 
awaitqq 
_ticketServiceqq  .
.qq. /
DeleteTicketAsyncqq/ @
(qq@ A
idqqA C
)qqC D
;qqD E
returnrr 
successrr 
?rr 
Okrr 
(rr  
newrr  #
{rr$ %
messagerr& -
=rr. /
$strrr0 M
}rrN O
)rrO P
:rrQ R

BadRequestrrS ]
(rr] ^
newrr^ a
{rrb c
messagerrd k
=rrl m
$str	rrn í
}
rrì î
)
rrî ï
;
rrï ñ
}ss 	
[uu 	
	Authorizeuu	 
(uu 
Rolesuu 
=uu 
$struu 3
)uu3 4
]uu4 5
[vv 	
HttpGetvv	 
(vv 
$strvv 
)vv 
]vv 
publicww 
asyncww 
Taskww 
<ww 
IActionResultww '
>ww' (
GetAllPaymentsww) 7
(ww7 8
)ww8 9
=>ww: <
Okww= ?
(ww? @
awaitww@ E
_paymentServicewwF U
.wwU V
GetAllPaymentsAsyncwwV i
(wwi j
)wwj k
)wwk l
;wwl m
[yy 	
HttpPostyy	 
(yy 
$stryy )
)yy) *
]yy* +
publiczz 
asynczz 
Taskzz 
<zz 
IActionResultzz '
>zz' (
ApprovePaymentzz) 7
(zz7 8
intzz8 ;
idzz< >
)zz> ?
{{{ 	
var|| 
(|| 
success|| 
,|| 
message|| !
)||! "
=||# $
await||% *
_paymentService||+ :
.||: ;
ApprovePaymentAsync||; N
(||N O
id||O Q
)||Q R
;||R S
return}} 
success}} 
?}} 
Ok}} 
(}}  
new}}  #
{}}$ %
message}}& -
}}}. /
)}}/ 0
:}}1 2

BadRequest}}3 =
(}}= >
new}}> A
{}}B C
message}}D K
}}}L M
)}}M N
;}}N O
}~~ 	
[
ÄÄ 	
HttpPost
ÄÄ	 
(
ÄÄ 
$str
ÄÄ )
)
ÄÄ) *
]
ÄÄ* +
public
ÅÅ 
async
ÅÅ 
Task
ÅÅ 
<
ÅÅ 
IActionResult
ÅÅ '
>
ÅÅ' (
ConfirmPayment
ÅÅ) 7
(
ÅÅ7 8
int
ÅÅ8 ;
id
ÅÅ< >
)
ÅÅ> ?
=>
ÅÅ@ B
await
ÅÅC H
ApprovePayment
ÅÅI W
(
ÅÅW X
id
ÅÅX Z
)
ÅÅZ [
;
ÅÅ[ \
[
ÉÉ 	
HttpPost
ÉÉ	 
(
ÉÉ 
$str
ÉÉ (
)
ÉÉ( )
]
ÉÉ) *
public
ÑÑ 
async
ÑÑ 
Task
ÑÑ 
<
ÑÑ 
IActionResult
ÑÑ '
>
ÑÑ' (
RejectPayment
ÑÑ) 6
(
ÑÑ6 7
int
ÑÑ7 :
id
ÑÑ; =
)
ÑÑ= >
{
ÖÖ 	
var
ÜÜ 
success
ÜÜ 
=
ÜÜ 
await
ÜÜ 
_paymentService
ÜÜ  /
.
ÜÜ/ 0 
RejectPaymentAsync
ÜÜ0 B
(
ÜÜB C
id
ÜÜC E
)
ÜÜE F
;
ÜÜF G
return
áá 
success
áá 
?
áá 
Ok
áá 
(
áá  
new
áá  #
{
áá$ %
message
áá& -
=
áá. /
$str
áá0 B
}
ááC D
)
ááD E
:
ááF G

BadRequest
ááH R
(
ááR S
new
ááS V
{
ááW X
message
ááY `
=
ááa b
$str
áác {
}
áá| }
)
áá} ~
;
áá~ 
}
àà 	
[
ää 	
HttpPost
ää	 
(
ää 
$str
ää )
)
ää) *
]
ää* +
public
ãã 
async
ãã 
Task
ãã 
<
ãã 
IActionResult
ãã '
>
ãã' (
ArchivePayment
ãã) 7
(
ãã7 8
int
ãã8 ;
id
ãã< >
)
ãã> ?
{
åå 	
var
çç 
success
çç 
=
çç 
await
çç 
_paymentService
çç  /
.
çç/ 0!
ArchivePaymentAsync
çç0 C
(
ççC D
id
ççD F
)
ççF G
;
ççG H
return
éé 
success
éé 
?
éé 
Ok
éé 
(
éé  
new
éé  #
{
éé$ %
message
éé& -
=
éé. /
$str
éé0 B
}
ééC D
)
ééD E
:
ééF G
NotFound
ééH P
(
ééP Q
)
ééQ R
;
ééR S
}
èè 	
[
ëë 	
HttpPost
ëë	 
(
ëë 
$str
ëë +
)
ëë+ ,
]
ëë, -
public
íí 
async
íí 
Task
íí 
<
íí 
IActionResult
íí '
>
íí' (
UnarchivePayment
íí) 9
(
íí9 :
int
íí: =
id
íí> @
)
íí@ A
{
ìì 	
var
îî 
success
îî 
=
îî 
await
îî 
_paymentService
îî  /
.
îî/ 0#
UnarchivePaymentAsync
îî0 E
(
îîE F
id
îîF H
)
îîH I
;
îîI J
return
ïï 
success
ïï 
?
ïï 
Ok
ïï 
(
ïï  
new
ïï  #
{
ïï$ %
message
ïï& -
=
ïï. /
$str
ïï0 B
}
ïïC D
)
ïïD E
:
ïïF G
NotFound
ïïH P
(
ïïP Q
)
ïïQ R
;
ïïR S
}
ññ 	
[
òò 	

HttpDelete
òò	 
(
òò 
$str
òò #
)
òò# $
]
òò$ %
public
ôô 
async
ôô 
Task
ôô 
<
ôô 
IActionResult
ôô '
>
ôô' (
DeletePayment
ôô) 6
(
ôô6 7
int
ôô7 :
id
ôô; =
)
ôô= >
{
öö 	
var
õõ 
success
õõ 
=
õõ 
await
õõ 
_paymentService
õõ  /
.
õõ/ 0 
DeletePaymentAsync
õõ0 B
(
õõB C
id
õõC E
)
õõE F
;
õõF G
return
úú 
success
úú 
?
úú 
Ok
úú 
(
úú  
new
úú  #
{
úú$ %
message
úú& -
=
úú. /
$str
úú0 A
}
úúB C
)
úúC D
:
úúE F

BadRequest
úúG Q
(
úúQ R
new
úúR U
{
úúV W
message
úúX _
=
úú` a
$strúúb â
}úúä ã
)úúã å
;úúå ç
}
ùù 	
[
üü 	
	Authorize
üü	 
(
üü 
Roles
üü 
=
üü 
$str
üü 3
)
üü3 4
]
üü4 5
[
†† 	
HttpGet
††	 
(
†† 
$str
††  
)
††  !
]
††! "
public
°° 
async
°° 
Task
°° 
<
°° 
IActionResult
°° '
>
°°' (!
GetAllSubscriptions
°°) <
(
°°< =
)
°°= >
=>
°°? A
Ok
°°B D
(
°°D E
await
°°E J"
_subscriptionService
°°K _
.
°°_ `&
GetAllSubscriptionsAsync
°°` x
(
°°x y
)
°°y z
)
°°z {
;
°°{ |
[
££ 	
HttpPut
££	 
(
££ 
$str
££ %
)
££% &
]
££& '
public
§§ 
async
§§ 
Task
§§ 
<
§§ 
IActionResult
§§ '
>
§§' ( 
UpdateSubscription
§§) ;
(
§§; <
int
§§< ?
id
§§@ B
,
§§B C
[
§§D E
FromBody
§§E M
]
§§M N'
UpdateSubscriptionRequest
§§O h
request
§§i p
)
§§p q
{
•• 	
try
¶¶ 
{
ßß 
var
®® 
success
®® 
=
®® 
await
®® #"
_subscriptionService
®®$ 8
.
®®8 9%
UpdateSubscriptionAsync
®®9 P
(
®®P Q
id
®®Q S
,
®®S T
request
®®U \
.
®®\ ]
Status
®®] c
,
®®c d
request
®®e l
.
®®l m
PlanID
®®m s
,
®®s t
request
®®u |
.
®®| }
EndDate®®} Ñ
)®®Ñ Ö
;®®Ö Ü
return
©© 
success
©© 
?
©©  
Ok
©©! #
(
©©# $
new
©©$ '
{
©©( )
message
©©* 1
=
©©2 3
$str
©©4 W
}
©©X Y
)
©©Y Z
:
©©[ \
NotFound
©©] e
(
©©e f
)
©©f g
;
©©g h
}
™™ 
catch
´´ 
(
´´ 
	Exception
´´ 
ex
´´ 
)
´´  
{
¨¨ 
return
≠≠ 

BadRequest
≠≠ !
(
≠≠! "
new
≠≠" %
{
≠≠& '
message
≠≠( /
=
≠≠0 1
ex
≠≠2 4
.
≠≠4 5
Message
≠≠5 <
}
≠≠= >
)
≠≠> ?
;
≠≠? @
}
ÆÆ 
}
ØØ 	
[
±± 	

HttpDelete
±±	 
(
±± 
$str
±± (
)
±±( )
]
±±) *
public
≤≤ 
async
≤≤ 
Task
≤≤ 
<
≤≤ 
IActionResult
≤≤ '
>
≤≤' ( 
DeleteSubscription
≤≤) ;
(
≤≤; <
int
≤≤< ?
id
≤≤@ B
)
≤≤B C
{
≥≥ 	
try
¥¥ 
{
µµ 
var
∂∂ 
success
∂∂ 
=
∂∂ 
await
∂∂ #"
_subscriptionService
∂∂$ 8
.
∂∂8 9%
DeleteSubscriptionAsync
∂∂9 P
(
∂∂P Q
id
∂∂Q S
)
∂∂S T
;
∂∂T U
if
∑∑ 
(
∑∑ 
!
∑∑ 
success
∑∑ 
)
∑∑ 
{
∏∏ 
return
ππ 
NotFound
ππ #
(
ππ# $
new
ππ$ '
{
ππ( )
message
ππ* 1
=
ππ2 3
$str
ππ4 L
}
ππM N
)
ππN O
;
ππO P
}
∫∫ 
return
ªª 
Ok
ªª 
(
ªª 
new
ªª 
{
ªª 
message
ªª  '
=
ªª( )
$str
ªª* M
}
ªªN O
)
ªªO P
;
ªªP Q
}
ºº 
catch
ΩΩ 
(
ΩΩ 
	Exception
ΩΩ 
ex
ΩΩ 
)
ΩΩ  
{
ææ 
Console
øø 
.
øø 
	WriteLine
øø !
(
øø! "
$"
øø" $
$str
øø$ ?
{
øø? @
ex
øø@ B
.
øøB C
Message
øøC J
}
øøJ K
$str
øøK M
{
øøM N
ex
øøN P
.
øøP Q
InnerException
øøQ _
?
øø_ `
.
øø` a
Message
øøa h
}
øøh i
"
øøi j
)
øøj k
;
øøk l
return
¿¿ 

BadRequest
¿¿ !
(
¿¿! "
new
¿¿" %
{
¿¿& '
message
¿¿( /
=
¿¿0 1
ex
¿¿2 4
.
¿¿4 5
InnerException
¿¿5 C
?
¿¿C D
.
¿¿D E
Message
¿¿E L
??
¿¿M O
ex
¿¿P R
.
¿¿R S
Message
¿¿S Z
}
¿¿[ \
)
¿¿\ ]
;
¿¿] ^
}
¡¡ 
}
¬¬ 	
[
≈≈ 	
	Authorize
≈≈	 
(
≈≈ 
Roles
≈≈ 
=
≈≈ 
$str
≈≈ -
)
≈≈- .
]
≈≈. /
[
∆∆ 	
HttpGet
∆∆	 
(
∆∆ 
$str
∆∆ "
)
∆∆" #
]
∆∆# $
public
«« 
async
«« 
Task
«« 
<
«« 
IActionResult
«« '
>
««' (
GetDashboardStats
««) :
(
««: ;
)
««; <
=>
««= ?
Ok
««@ B
(
««B C
await
««C H
_dashboardService
««I Z
.
««Z [$
GetDashboardStatsAsync
««[ q
(
««q r
)
««r s
)
««s t
;
««t u
[
…… 	
HttpGet
……	 
(
…… 
$str
…… "
)
……" #
]
……# $
public
   
async
   
Task
   
<
   
IActionResult
   '
>
  ' (
GetActiveServices
  ) :
(
  : ;
)
  ; <
=>
  = ?
Ok
  @ B
(
  B C
await
  C H
_dashboardService
  I Z
.
  Z [$
GetActiveServicesAsync
  [ q
(
  q r
)
  r s
)
  s t
;
  t u
[
ÃÃ 	
HttpGet
ÃÃ	 
(
ÃÃ 
$str
ÃÃ 
)
ÃÃ 
]
ÃÃ 
public
ÕÕ 
async
ÕÕ 
Task
ÕÕ 
<
ÕÕ 
IActionResult
ÕÕ '
>
ÕÕ' (
GetAllInvoices
ÕÕ) 7
(
ÕÕ7 8
)
ÕÕ8 9
=>
ÕÕ: <
Ok
ÕÕ= ?
(
ÕÕ? @
await
ÕÕ@ E
_dashboardService
ÕÕF W
.
ÕÕW X!
GetAllInvoicesAsync
ÕÕX k
(
ÕÕk l
)
ÕÕl m
)
ÕÕm n
;
ÕÕn o
[
œœ 	
HttpGet
œœ	 
(
œœ 
$str
œœ (
)
œœ( )
]
œœ) *
public
–– 
async
–– 
Task
–– 
<
–– 
IActionResult
–– '
>
––' ($
GetPaymentMethodsStats
––) ?
(
––? @
)
––@ A
=>
––B D
Ok
––E G
(
––G H
await
––H M
_dashboardService
––N _
.
––_ `)
GetPaymentMethodsStatsAsync
––` {
(
––{ |
)
––| }
)
––} ~
;
––~ 
[
““ 	
	Authorize
““	 
(
““ 
Roles
““ 
=
““ 
$str
““ -
)
““- .
]
““. /
[
”” 	
HttpGet
””	 
(
”” 
$str
””  
)
””  !
]
””! "
public
‘‘ 
async
‘‘ 
Task
‘‘ 
<
‘‘ 
IActionResult
‘‘ '
>
‘‘' (
GetActivityLogs
‘‘) 8
(
‘‘8 9
[
‘‘9 :
	FromQuery
‘‘: C
]
‘‘C D
DateTime
‘‘E M
?
‘‘M N
since
‘‘O T
=
‘‘U V
null
‘‘W [
)
‘‘[ \
{
’’ 	
Response
÷÷ 
.
÷÷ 
Headers
÷÷ 
.
÷÷ 
CacheControl
÷÷ )
=
÷÷* +
$str
÷÷, Q
;
÷÷Q R
Response
◊◊ 
.
◊◊ 
Headers
◊◊ 
.
◊◊ 
Pragma
◊◊ #
=
◊◊$ %
$str
◊◊& 0
;
◊◊0 1
Response
ÿÿ 
.
ÿÿ 
Headers
ÿÿ 
.
ÿÿ 
Expires
ÿÿ $
=
ÿÿ% &
$str
ÿÿ' *
;
ÿÿ* +
return
⁄⁄ 
Ok
⁄⁄ 
(
⁄⁄ 
await
⁄⁄ 
_dashboardService
⁄⁄ -
.
⁄⁄- ."
GetActivityLogsAsync
⁄⁄. B
(
⁄⁄B C
since
⁄⁄C H
)
⁄⁄H I
)
⁄⁄I J
;
⁄⁄J K
}
€€ 	
[
›› 	
	Authorize
››	 
(
›› 
Roles
›› 
=
›› 
$str
›› -
)
››- .
]
››. /
[
ﬁﬁ 	

HttpDelete
ﬁﬁ	 
(
ﬁﬁ 
$str
ﬁﬁ (
)
ﬁﬁ( )
]
ﬁﬁ) *
public
ﬂﬂ 
async
ﬂﬂ 
Task
ﬂﬂ 
<
ﬂﬂ 
IActionResult
ﬂﬂ '
>
ﬂﬂ' (
DeleteActivityLog
ﬂﬂ) :
(
ﬂﬂ: ;
int
ﬂﬂ; >
id
ﬂﬂ? A
)
ﬂﬂA B
{
‡‡ 	
var
·· 
log
·· 
=
·· 
await
·· 
_context
·· $
.
··$ %
ActivityLogs
··% 1
.
··1 2
	FindAsync
··2 ;
(
··; <
id
··< >
)
··> ?
;
··? @
if
‚‚ 
(
‚‚ 
log
‚‚ 
==
‚‚ 
null
‚‚ 
)
‚‚ 
return
‚‚ #
NotFound
‚‚$ ,
(
‚‚, -
)
‚‚- .
;
‚‚. /
_context
„„ 
.
„„ 
ActivityLogs
„„ !
.
„„! "
Remove
„„" (
(
„„( )
log
„„) ,
)
„„, -
;
„„- .
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
ÂÂ& <
}
ÂÂ= >
)
ÂÂ> ?
;
ÂÂ? @
}
ÊÊ 	
[
ËË 	
HttpPost
ËË	 
(
ËË 
$str
ËË !
)
ËË! "
]
ËË" #
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
ÈÈ' (
CreateActivityLog
ÈÈ) :
(
ÈÈ: ;
[
ÈÈ; <
FromBody
ÈÈ< D
]
ÈÈD E&
CreateActivityLogRequest
ÈÈF ^
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
ÎÎ` a
if
ÏÏ 
(
ÏÏ 
string
ÏÏ 
.
ÏÏ  
IsNullOrWhiteSpace
ÏÏ )
(
ÏÏ) *
userId
ÏÏ* 0
)
ÏÏ0 1
)
ÏÏ1 2
return
ÌÌ 
Unauthorized
ÌÌ #
(
ÌÌ# $
)
ÌÌ$ %
;
ÌÌ% &
var
ÔÔ 

actionText
ÔÔ 
=
ÔÔ 
!
ÔÔ 
string
ÔÔ $
.
ÔÔ$ % 
IsNullOrWhiteSpace
ÔÔ% 7
(
ÔÔ7 8
request
ÔÔ8 ?
.
ÔÔ? @
Action
ÔÔ@ F
)
ÔÔF G
?
 
request
 
.
 
Action
  
:
ÒÒ 
request
ÒÒ 
.
ÒÒ 
Description
ÒÒ %
;
ÒÒ% &
if
ÛÛ 
(
ÛÛ 
string
ÛÛ 
.
ÛÛ  
IsNullOrWhiteSpace
ÛÛ )
(
ÛÛ) *

actionText
ÛÛ* 4
)
ÛÛ4 5
)
ÛÛ5 6
return
ÙÙ 

BadRequest
ÙÙ !
(
ÙÙ! "
new
ÙÙ" %
{
ÙÙ& '
message
ÙÙ( /
=
ÙÙ0 1
$str
ÙÙ2 U
}
ÙÙV W
)
ÙÙW X
;
ÙÙX Y
var
ˆˆ 
activityLog
ˆˆ 
=
ˆˆ 
new
ˆˆ !
ActivityLog
ˆˆ" -
{
˜˜ 
UserID
¯¯ 
=
¯¯ 
userId
¯¯ 
,
¯¯  
Action
˘˘ 
=
˘˘ 

actionText
˘˘ #
,
˘˘# $
Type
˙˙ 
=
˙˙ 
string
˙˙ 
.
˙˙  
IsNullOrWhiteSpace
˙˙ 0
(
˙˙0 1
request
˙˙1 8
.
˙˙8 9
Type
˙˙9 =
)
˙˙= >
?
˙˙? @
$str
˙˙A I
:
˙˙J K
request
˙˙L S
.
˙˙S T
Type
˙˙T X
,
˙˙X Y
	IPAddress
˚˚ 
=
˚˚ 
HttpContext
˚˚ '
.
˚˚' (

Connection
˚˚( 2
.
˚˚2 3
RemoteIpAddress
˚˚3 B
?
˚˚B C
.
˚˚C D
ToString
˚˚D L
(
˚˚L M
)
˚˚M N
,
˚˚N O
	Timestamp
¸¸ 
=
¸¸ 
DateTime
¸¸ $
.
¸¸$ %
UtcNow
¸¸% +
}
˝˝ 
;
˝˝ 
_context
ˇˇ 
.
ˇˇ 
ActivityLogs
ˇˇ !
.
ˇˇ! "
Add
ˇˇ" %
(
ˇˇ% &
activityLog
ˇˇ& 1
)
ˇˇ1 2
;
ˇˇ2 3
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
ÇÇ 
message
ÇÇ #
=
ÇÇ$ %
$str
ÇÇ& D
}
ÇÇE F
)
ÇÇF G
;
ÇÇG H
}
ÉÉ 	
[
ÜÜ 	
HttpGet
ÜÜ	 
(
ÜÜ 
$str
ÜÜ 
)
ÜÜ 
]
ÜÜ 
public
áá 
async
áá 
Task
áá 
<
áá 
IActionResult
áá '
>
áá' (
GetPlans
áá) 1
(
áá1 2
)
áá2 3
=>
áá4 6
Ok
áá7 9
(
áá9 :
await
áá: ?
_planService
áá@ L
.
ááL M
GetAllPlansAsync
ááM ]
(
áá] ^
)
áá^ _
)
áá_ `
;
áá` a
[
ââ 	
	Authorize
ââ	 
(
ââ 
Roles
ââ 
=
ââ 
$str
ââ -
)
ââ- .
]
ââ. /
[
ää 	
HttpPut
ää	 
(
ää 
$str
ää 
)
ää 
]
ää 
public
ãã 
async
ãã 
Task
ãã 
<
ãã 
IActionResult
ãã '
>
ãã' (

UpdatePlan
ãã) 3
(
ãã3 4
int
ãã4 7
id
ãã8 :
,
ãã: ;
[
ãã< =
FromBody
ãã= E
]
ããE F
UpdatePlanRequest
ããG X
request
ããY `
)
ãã` a
{
åå 	
var
çç 
success
çç 
=
çç 
await
çç 
_planService
çç  ,
.
çç, -
UpdatePlanAsync
çç- <
(
çç< =
id
çç= ?
,
çç? @
request
ççA H
.
ççH I
PlanName
ççI Q
,
ççQ R
request
ççS Z
.
ççZ [
	SpeedMbps
çç[ d
??
ççe g
$num
ççh i
,
ççi j
request
ççk r
.
ççr s
Price
ççs x
??
ççy {
$num
çç| }
)
çç} ~
;
çç~ 
return
éé 
success
éé 
?
éé 
Ok
éé 
(
éé  
new
éé  #
{
éé$ %
message
éé& -
=
éé. /
$str
éé0 K
}
ééL M
)
ééM N
:
ééO P
NotFound
ééQ Y
(
ééY Z
)
ééZ [
;
éé[ \
}
èè 	
[
ëë 	
	Authorize
ëë	 
(
ëë 
Roles
ëë 
=
ëë 
$str
ëë -
)
ëë- .
]
ëë. /
[
íí 	

HttpDelete
íí	 
(
íí 
$str
íí  
)
íí  !
]
íí! "
public
ìì 
async
ìì 
Task
ìì 
<
ìì 
IActionResult
ìì '
>
ìì' (

DeletePlan
ìì) 3
(
ìì3 4
int
ìì4 7
id
ìì8 :
)
ìì: ;
{
îî 	
var
ïï 
success
ïï 
=
ïï 
await
ïï 
_planService
ïï  ,
.
ïï, -
DeletePlanAsync
ïï- <
(
ïï< =
id
ïï= ?
)
ïï? @
;
ïï@ A
return
ññ 
success
ññ 
?
ññ 
Ok
ññ 
(
ññ  
new
ññ  #
{
ññ$ %
message
ññ& -
=
ññ. /
$str
ññ0 K
}
ññL M
)
ññM N
:
ññO P
NotFound
ññQ Y
(
ññY Z
)
ññZ [
;
ññ[ \
}
óó 	
[
öö 	
	Authorize
öö	 
(
öö 
Roles
öö 
=
öö 
$str
öö '
)
öö' (
]
öö( )
[
õõ 	
HttpGet
õõ	 
(
õõ 
$str
õõ 
)
õõ 
]
õõ 
public
úú 
async
úú 
Task
úú 
<
úú 
IActionResult
úú '
>
úú' (
GetStaff
úú) 1
(
úú1 2
)
úú2 3
=>
úú4 6
Ok
úú7 9
(
úú9 :
await
úú: ?
_staffService
úú@ M
.
úúM N
GetAllStaffAsync
úúN ^
(
úú^ _
)
úú_ `
)
úú` a
;
úúa b
[
ûû 	
	Authorize
ûû	 
(
ûû 
Roles
ûû 
=
ûû 
$str
ûû '
)
ûû' (
]
ûû( )
[
üü 	
HttpPost
üü	 
(
üü 
$str
üü 
)
üü 
]
üü 
public
†† 
async
†† 
Task
†† 
<
†† 
IActionResult
†† '
>
††' (
CreateStaff
††) 4
(
††4 5
[
††5 6
FromBody
††6 >
]
††> ? 
CreateStaffRequest
††@ R
request
††S Z
)
††Z [
{
°° 	
var
¢¢ 
(
¢¢ 
success
¢¢ 
,
¢¢ 
message
¢¢ !
)
¢¢! "
=
¢¢# $
await
¢¢% *
_staffService
¢¢+ 8
.
¢¢8 9
CreateStaffAsync
¢¢9 I
(
¢¢I J
request
¢¢J Q
.
¢¢Q R
Email
¢¢R W
,
¢¢W X
request
¢¢Y `
.
¢¢` a
	FirstName
¢¢a j
,
¢¢j k
request
¢¢l s
.
¢¢s t
LastName
¢¢t |
,
¢¢| }
request¢¢~ Ö
.¢¢Ö Ü
Password¢¢Ü é
,¢¢é è
request¢¢ê ó
.¢¢ó ò
Role¢¢ò ú
)¢¢ú ù
;¢¢ù û
return
££ 
success
££ 
?
££ 
Ok
££ 
(
££  
new
££  #
{
££$ %
message
££& -
}
££. /
)
££/ 0
:
££1 2

BadRequest
££3 =
(
££= >
new
££> A
{
££B C
message
££D K
}
££L M
)
££M N
;
££N O
}
§§ 	
[
¶¶ 	
	Authorize
¶¶	 
(
¶¶ 
Roles
¶¶ 
=
¶¶ 
$str
¶¶ '
)
¶¶' (
]
¶¶( )
[
ßß 	
HttpPut
ßß	 
(
ßß 
$str
ßß 
)
ßß 
]
ßß 
public
®® 
async
®® 
Task
®® 
<
®® 
IActionResult
®® '
>
®®' (
UpdateStaff
®®) 4
(
®®4 5
string
®®5 ;
id
®®< >
,
®®> ?
[
®®@ A
FromBody
®®A I
]
®®I J 
UpdateStaffRequest
®®K ]
request
®®^ e
)
®®e f
{
©© 	
var
™™ 
success
™™ 
=
™™ 
await
™™ 
_staffService
™™  -
.
™™- .
UpdateStaffAsync
™™. >
(
™™> ?
id
™™? A
,
™™A B
request
™™C J
.
™™J K
	FirstName
™™K T
,
™™T U
request
™™V ]
.
™™] ^
LastName
™™^ f
,
™™f g
request
™™h o
.
™™o p
Status
™™p v
,
™™v w
request
™™x 
.™™ Ä
Role™™Ä Ñ
,™™Ñ Ö
request™™Ü ç
.™™ç é
Password™™é ñ
)™™ñ ó
;™™ó ò
return
´´ 
success
´´ 
?
´´ 
Ok
´´ 
(
´´  
new
´´  #
{
´´$ %
message
´´& -
=
´´. /
$str
´´0 L
}
´´M N
)
´´N O
:
´´P Q
NotFound
´´R Z
(
´´Z [
)
´´[ \
;
´´\ ]
}
¨¨ 	
[
ÆÆ 	
	Authorize
ÆÆ	 
(
ÆÆ 
Roles
ÆÆ 
=
ÆÆ 
$str
ÆÆ '
)
ÆÆ' (
]
ÆÆ( )
[
ØØ 	

HttpDelete
ØØ	 
(
ØØ 
$str
ØØ  
)
ØØ  !
]
ØØ! "
public
∞∞ 
async
∞∞ 
Task
∞∞ 
<
∞∞ 
IActionResult
∞∞ '
>
∞∞' (
DeleteStaff
∞∞) 4
(
∞∞4 5
string
∞∞5 ;
id
∞∞< >
)
∞∞> ?
{
±± 	
var
≤≤ 
user
≤≤ 
=
≤≤ 
await
≤≤ 
_context
≤≤ %
.
≤≤% &
Users
≤≤& +
.
≤≤+ ,
	FindAsync
≤≤, 5
(
≤≤5 6
id
≤≤6 8
)
≤≤8 9
;
≤≤9 :
if
≥≥ 
(
≥≥ 
user
≥≥ 
==
≥≥ 
null
≥≥ 
)
≥≥ 
return
≥≥ $
NotFound
≥≥% -
(
≥≥- .
new
≥≥. 1
{
≥≥2 3
message
≥≥4 ;
=
≥≥< =
$str
≥≥> O
}
≥≥P Q
)
≥≥Q R
;
≥≥R S
if
µµ 
(
µµ 
user
µµ 
.
µµ 
Role
µµ 
==
µµ 
$str
µµ )
)
µµ) *
{
∂∂ 
var
∑∑ 
superAdminCount
∑∑ #
=
∑∑$ %
await
∑∑& +
_context
∑∑, 4
.
∑∑4 5
Users
∑∑5 :
.
∑∑: ;

CountAsync
∑∑; E
(
∑∑E F
u
∑∑F G
=>
∑∑H J
u
∑∑K L
.
∑∑L M
Role
∑∑M Q
==
∑∑R T
$str
∑∑U a
)
∑∑a b
;
∑∑b c
if
∏∏ 
(
∏∏ 
superAdminCount
∏∏ #
<=
∏∏$ &
$num
∏∏' (
)
∏∏( )
return
ππ 

BadRequest
ππ %
(
ππ% &
new
ππ& )
{
ππ* +
message
ππ, 3
=
ππ4 5
$str
ππ6 q
}
ππr s
)
ππs t
;
ππt u
}
∫∫ 
var
ºº 
success
ºº 
=
ºº 
await
ºº 
_staffService
ºº  -
.
ºº- .
DeleteStaffAsync
ºº. >
(
ºº> ?
id
ºº? A
)
ººA B
;
ººB C
return
ΩΩ 
success
ΩΩ 
?
ΩΩ 
Ok
ΩΩ 
(
ΩΩ  
new
ΩΩ  #
{
ΩΩ$ %
message
ΩΩ& -
=
ΩΩ. /
$str
ΩΩ0 L
}
ΩΩM N
)
ΩΩN O
:
ΩΩP Q
NotFound
ΩΩR Z
(
ΩΩZ [
)
ΩΩ[ \
;
ΩΩ\ ]
}
ææ 	
[
¿¿ 	
	Authorize
¿¿	 
(
¿¿ 
Roles
¿¿ 
=
¿¿ 
$str
¿¿ '
)
¿¿' (
]
¿¿( )
[
¡¡ 	
HttpPut
¡¡	 
(
¡¡ 
$str
¡¡ #
)
¡¡# $
]
¡¡$ %
public
¬¬ 
async
¬¬ 
Task
¬¬ 
<
¬¬ 
IActionResult
¬¬ '
>
¬¬' (

UpdateRole
¬¬) 3
(
¬¬3 4
string
¬¬4 :
roleName
¬¬; C
,
¬¬C D
[
¬¬E F
FromBody
¬¬F N
]
¬¬N O
UpdateRoleRequest
¬¬P a
request
¬¬b i
)
¬¬i j
{
√√ 	
if
ƒƒ 
(
ƒƒ 
string
ƒƒ 
.
ƒƒ  
IsNullOrWhiteSpace
ƒƒ )
(
ƒƒ) *
roleName
ƒƒ* 2
)
ƒƒ2 3
||
ƒƒ4 6
request
ƒƒ7 >
?
ƒƒ> ?
.
ƒƒ? @
Permissions
ƒƒ@ K
==
ƒƒL N
null
ƒƒO S
)
ƒƒS T
return
≈≈ 

BadRequest
≈≈ !
(
≈≈! "
new
≈≈" %
{
≈≈& '
message
≈≈( /
=
≈≈0 1
$str
≈≈2 O
}
≈≈P Q
)
≈≈Q R
;
≈≈R S
try
«« 
{
»» 
var
…… !
existingPermissions
…… '
=
……( )
await
……* /
_context
……0 8
.
……8 9
RolePermissions
……9 H
.
   
Where
   
(
   
rp
   
=>
    
rp
  ! #
.
  # $
RoleName
  $ ,
==
  - /
roleName
  0 8
)
  8 9
.
ÀÀ 
ToListAsync
ÀÀ  
(
ÀÀ  !
)
ÀÀ! "
;
ÀÀ" #
_context
ÕÕ 
.
ÕÕ 
RolePermissions
ÕÕ (
.
ÕÕ( )
RemoveRange
ÕÕ) 4
(
ÕÕ4 5!
existingPermissions
ÕÕ5 H
)
ÕÕH I
;
ÕÕI J
var
œœ 
newPermissions
œœ "
=
œœ# $
request
œœ% ,
.
œœ, -
Permissions
œœ- 8
.
œœ8 9
Select
œœ9 ?
(
œœ? @
p
œœ@ A
=>
œœB D
new
œœE H
RolePermission
œœI W
{
–– 
RoleName
—— 
=
—— 
roleName
—— '
,
——' (
PermissionName
““ "
=
““# $
p
““% &
,
““& '
	CreatedAt
”” 
=
”” 
DateTime
””  (
.
””( )
UtcNow
””) /
}
‘‘ 
)
‘‘ 
.
‘‘ 
ToList
‘‘ 
(
‘‘ 
)
‘‘ 
;
‘‘ 
_context
÷÷ 
.
÷÷ 
RolePermissions
÷÷ (
.
÷÷( )
AddRange
÷÷) 1
(
÷÷1 2
newPermissions
÷÷2 @
)
÷÷@ A
;
÷÷A B
await
◊◊ 
_context
◊◊ 
.
◊◊ 
SaveChangesAsync
◊◊ /
(
◊◊/ 0
)
◊◊0 1
;
◊◊1 2
return
ŸŸ 
Ok
ŸŸ 
(
ŸŸ 
new
ŸŸ 
{
ŸŸ 
message
ŸŸ  '
=
ŸŸ( )
$str
ŸŸ* Q
}
ŸŸR S
)
ŸŸS T
;
ŸŸT U
}
⁄⁄ 
catch
€€ 
(
€€ 
	Exception
€€ 
ex
€€ 
)
€€  
{
‹‹ 
return
›› 

BadRequest
›› !
(
››! "
new
››" %
{
››& '
message
››( /
=
››0 1
ex
››2 4
.
››4 5
Message
››5 <
}
››= >
)
››> ?
;
››? @
}
ﬁﬁ 
}
ﬂﬂ 	
[
·· 	
	Authorize
··	 
(
·· 
Roles
·· 
=
·· 
$str
·· 3
)
··3 4
]
··4 5
[
‚‚ 	
HttpGet
‚‚	 
(
‚‚ 
$str
‚‚ 
)
‚‚ 
]
‚‚ 
public
„„ 
async
„„ 
Task
„„ 
<
„„ 
IActionResult
„„ '
>
„„' (
GetRoles
„„) 1
(
„„1 2
)
„„2 3
{
‰‰ 	
var
ÂÂ 

adminUsers
ÂÂ 
=
ÂÂ 
await
ÂÂ "
_context
ÂÂ# +
.
ÂÂ+ ,
Users
ÂÂ, 1
.
ÊÊ 
Where
ÊÊ 
(
ÊÊ 
u
ÊÊ 
=>
ÊÊ 
u
ÊÊ 
.
ÊÊ 
Role
ÊÊ "
==
ÊÊ# %
$str
ÊÊ& -
)
ÊÊ- .
.
ÁÁ 
Select
ÁÁ 
(
ÁÁ 
u
ÁÁ 
=>
ÁÁ 
new
ÁÁ  
{
ÁÁ! "
id
ÁÁ# %
=
ÁÁ& '
u
ÁÁ( )
.
ÁÁ) *
Id
ÁÁ* ,
,
ÁÁ, -
name
ÁÁ. 2
=
ÁÁ3 4
$"
ÁÁ5 7
{
ÁÁ7 8
u
ÁÁ8 9
.
ÁÁ9 :
	FirstName
ÁÁ: C
}
ÁÁC D
$str
ÁÁD E
{
ÁÁE F
u
ÁÁF G
.
ÁÁG H
LastName
ÁÁH P
}
ÁÁP Q
"
ÁÁQ R
,
ÁÁR S
email
ÁÁT Y
=
ÁÁZ [
u
ÁÁ\ ]
.
ÁÁ] ^
Email
ÁÁ^ c
}
ÁÁd e
)
ÁÁe f
.
ËË 
ToListAsync
ËË 
(
ËË 
)
ËË 
;
ËË 
var
ÍÍ 

staffUsers
ÍÍ 
=
ÍÍ 
await
ÍÍ "
_context
ÍÍ# +
.
ÍÍ+ ,
Users
ÍÍ, 1
.
ÎÎ 
Where
ÎÎ 
(
ÎÎ 
u
ÎÎ 
=>
ÎÎ 
u
ÎÎ 
.
ÎÎ 
Role
ÎÎ "
==
ÎÎ# %
$str
ÎÎ& -
)
ÎÎ- .
.
ÏÏ 
Select
ÏÏ 
(
ÏÏ 
u
ÏÏ 
=>
ÏÏ 
new
ÏÏ  
{
ÏÏ! "
id
ÏÏ# %
=
ÏÏ& '
u
ÏÏ( )
.
ÏÏ) *
Id
ÏÏ* ,
,
ÏÏ, -
name
ÏÏ. 2
=
ÏÏ3 4
$"
ÏÏ5 7
{
ÏÏ7 8
u
ÏÏ8 9
.
ÏÏ9 :
	FirstName
ÏÏ: C
}
ÏÏC D
$str
ÏÏD E
{
ÏÏE F
u
ÏÏF G
.
ÏÏG H
LastName
ÏÏH P
}
ÏÏP Q
"
ÏÏQ R
,
ÏÏR S
email
ÏÏT Y
=
ÏÏZ [
u
ÏÏ\ ]
.
ÏÏ] ^
Email
ÏÏ^ c
}
ÏÏd e
)
ÏÏe f
.
ÌÌ 
ToListAsync
ÌÌ 
(
ÌÌ 
)
ÌÌ 
;
ÌÌ 
var
ÔÔ 
adminPermissions
ÔÔ  
=
ÔÔ! "
await
ÔÔ# (
_context
ÔÔ) 1
.
ÔÔ1 2
RolePermissions
ÔÔ2 A
.
 
Where
 
(
 
rp
 
=>
 
rp
 
.
  
RoleName
  (
==
) +
$str
, 3
)
3 4
.
ÒÒ 
Select
ÒÒ 
(
ÒÒ 
rp
ÒÒ 
=>
ÒÒ 
rp
ÒÒ  
.
ÒÒ  !
PermissionName
ÒÒ! /
)
ÒÒ/ 0
.
ÚÚ 
ToListAsync
ÚÚ 
(
ÚÚ 
)
ÚÚ 
;
ÚÚ 
var
ÙÙ 
staffPermissions
ÙÙ  
=
ÙÙ! "
await
ÙÙ# (
_context
ÙÙ) 1
.
ÙÙ1 2
RolePermissions
ÙÙ2 A
.
ıı 
Where
ıı 
(
ıı 
rp
ıı 
=>
ıı 
rp
ıı 
.
ıı  
RoleName
ıı  (
==
ıı) +
$str
ıı, 3
)
ıı3 4
.
ˆˆ 
Select
ˆˆ 
(
ˆˆ 
rp
ˆˆ 
=>
ˆˆ 
rp
ˆˆ  
.
ˆˆ  !
PermissionName
ˆˆ! /
)
ˆˆ/ 0
.
˜˜ 
ToListAsync
˜˜ 
(
˜˜ 
)
˜˜ 
;
˜˜ 
var
˘˘ 
roles
˘˘ 
=
˘˘ 
new
˘˘ 
object
˘˘ "
[
˘˘" #
]
˘˘# $
{
˙˙ 
new
˚˚ 
{
¸¸ 
id
˝˝ 
=
˝˝ 
$num
˝˝ 
,
˝˝ 
name
˛˛ 
=
˛˛ 
$str
˛˛ "
,
˛˛" #
users
ˇˇ 
=
ˇˇ 

adminUsers
ˇˇ &
.
ˇˇ& '
Count
ˇˇ' ,
,
ˇˇ, -
members
ÄÄ 
=
ÄÄ 

adminUsers
ÄÄ (
,
ÄÄ( )
permissions
ÅÅ 
=
ÅÅ  !
adminPermissions
ÅÅ" 2
.
ÅÅ2 3
Count
ÅÅ3 8
>
ÅÅ9 :
$num
ÅÅ; <
?
ÅÅ= >
adminPermissions
ÅÅ? O
:
ÅÅP Q
new
ÅÅR U
List
ÅÅV Z
<
ÅÅZ [
string
ÅÅ[ a
>
ÅÅa b
(
ÅÅb c
)
ÅÅc d
,
ÅÅd e
color
ÇÇ 
=
ÇÇ 
$str
ÇÇ !
}
ÉÉ 
,
ÉÉ 
new
ÑÑ 
{
ÖÖ 
id
ÜÜ 
=
ÜÜ 
$num
ÜÜ 
,
ÜÜ 
name
áá 
=
áá 
$str
áá "
,
áá" #
users
àà 
=
àà 

staffUsers
àà &
.
àà& '
Count
àà' ,
,
àà, -
members
ââ 
=
ââ 

staffUsers
ââ (
,
ââ( )
permissions
ää 
=
ää  !
staffPermissions
ää" 2
.
ää2 3
Count
ää3 8
>
ää9 :
$num
ää; <
?
ää= >
staffPermissions
ää? O
:
ääP Q
new
ääR U
List
ääV Z
<
ääZ [
string
ää[ a
>
ääa b
(
ääb c
)
ääc d
,
ääd e
color
ãã 
=
ãã 
$str
ãã "
}
åå 
}
çç 
;
çç 
return
èè 
Ok
èè 
(
èè 
roles
èè 
)
èè 
;
èè 
}
êê 	
[
ìì 	
HttpGet
ìì	 
(
ìì 
$str
ìì 
)
ìì 
]
ìì 
public
îî 
async
îî 
Task
îî 
<
îî 
IActionResult
îî '
>
îî' (
GetFAQs
îî) 0
(
îî0 1
)
îî1 2
=>
îî3 5
Ok
îî6 8
(
îî8 9
await
îî9 >
_faqService
îî? J
.
îîJ K
GetAllFAQsAsync
îîK Z
(
îîZ [
)
îî[ \
)
îî\ ]
;
îî] ^
[
ññ 	
HttpPost
ññ	 
(
ññ 
$str
ññ 
)
ññ 
]
ññ 
public
óó 
async
óó 
Task
óó 
<
óó 
IActionResult
óó '
>
óó' (
	CreateFAQ
óó) 2
(
óó2 3
[
óó3 4
FromBody
óó4 <
]
óó< =
CreateFAQRequest
óó> N
request
óóO V
)
óóV W
{
òò 	
await
ôô 
_faqService
ôô 
.
ôô 
CreateFAQAsync
ôô ,
(
ôô, -
request
ôô- 4
.
ôô4 5
Question
ôô5 =
,
ôô= >
request
ôô? F
.
ôôF G
Answer
ôôG M
,
ôôM N
request
ôôO V
.
ôôV W
Category
ôôW _
,
ôô_ `
request
ôôa h
.
ôôh i
Status
ôôi o
)
ôôo p
;
ôôp q
return
öö 
Ok
öö 
(
öö 
new
öö 
{
öö 
message
öö #
=
öö$ %
$str
öö& @
}
ööA B
)
ööB C
;
ööC D
}
õõ 	
[
ùù 	
HttpPut
ùù	 
(
ùù 
$str
ùù 
)
ùù 
]
ùù 
public
ûû 
async
ûû 
Task
ûû 
<
ûû 
IActionResult
ûû '
>
ûû' (
	UpdateFAQ
ûû) 2
(
ûû2 3
int
ûû3 6
id
ûû7 9
,
ûû9 :
[
ûû; <
FromBody
ûû< D
]
ûûD E
UpdateFAQRequest
ûûF V
request
ûûW ^
)
ûû^ _
{
üü 	
var
†† 
success
†† 
=
†† 
await
†† 
_faqService
††  +
.
††+ ,
UpdateFAQAsync
††, :
(
††: ;
id
††; =
,
††= >
request
††? F
.
††F G
Question
††G O
,
††O P
request
††Q X
.
††X Y
Answer
††Y _
,
††_ `
request
††a h
.
††h i
Category
††i q
,
††q r
request
††s z
.
††z {
Status††{ Å
)††Å Ç
;††Ç É
return
°° 
success
°° 
?
°° 
Ok
°° 
(
°°  
new
°°  #
{
°°$ %
message
°°& -
=
°°. /
$str
°°0 J
}
°°K L
)
°°L M
:
°°N O
NotFound
°°P X
(
°°X Y
)
°°Y Z
;
°°Z [
}
¢¢ 	
[
§§ 	

HttpDelete
§§	 
(
§§ 
$str
§§ 
)
§§  
]
§§  !
public
•• 
async
•• 
Task
•• 
<
•• 
IActionResult
•• '
>
••' (
	DeleteFAQ
••) 2
(
••2 3
int
••3 6
id
••7 9
)
••9 :
{
¶¶ 	
var
ßß 
success
ßß 
=
ßß 
await
ßß 
_faqService
ßß  +
.
ßß+ ,
DeleteFAQAsync
ßß, :
(
ßß: ;
id
ßß; =
)
ßß= >
;
ßß> ?
return
®® 
success
®® 
?
®® 
Ok
®® 
(
®®  
new
®®  #
{
®®$ %
message
®®& -
=
®®. /
$str
®®0 J
}
®®K L
)
®®L M
:
®®N O
NotFound
®®P X
(
®®X Y
)
®®Y Z
;
®®Z [
}
©© 	
[
ÆÆ 	
HttpGet
ÆÆ	 
(
ÆÆ 
$str
ÆÆ 
)
ÆÆ  
]
ÆÆ  !
public
ØØ 
async
ØØ 
Task
ØØ 
<
ØØ 
IActionResult
ØØ '
>
ØØ' (
GetPromoOffers
ØØ) 7
(
ØØ7 8
)
ØØ8 9
{
∞∞ 	
var
±± 
offers
±± 
=
±± 
await
±± 
_context
±± '
.
±±' (
PromoOffers
±±( 3
.
≤≤ 
OrderByDescending
≤≤ "
(
≤≤" #
o
≤≤# $
=>
≤≤% '
o
≤≤( )
.
≤≤) *
	CreatedAt
≤≤* 3
)
≤≤3 4
.
≥≥ 
ToListAsync
≥≥ 
(
≥≥ 
)
≥≥ 
;
≥≥ 
return
¥¥ 
Ok
¥¥ 
(
¥¥ 
offers
¥¥ 
)
¥¥ 
;
¥¥ 
}
µµ 	
[
∑∑ 	
HttpPost
∑∑	 
(
∑∑ 
$str
∑∑  
)
∑∑  !
]
∑∑! "
public
∏∏ 
async
∏∏ 
Task
∏∏ 
<
∏∏ 
IActionResult
∏∏ '
>
∏∏' (
CreatePromoOffer
∏∏) 9
(
∏∏9 :
[
∏∏: ;
FromBody
∏∏; C
]
∏∏C D%
CreatePromoOfferRequest
∏∏E \
request
∏∏] d
)
∏∏d e
{
ππ 	
var
∫∫ 
offer
∫∫ 
=
∫∫ 
new
∫∫ 

PromoOffer
∫∫ &
{
ªª 
Title
ºº 
=
ºº 
request
ºº 
.
ºº  
Title
ºº  %
,
ºº% &
Description
ΩΩ 
=
ΩΩ 
request
ΩΩ %
.
ΩΩ% &
Description
ΩΩ& 1
,
ΩΩ1 2
Price
ææ 
=
ææ 
request
ææ 
.
ææ  
Price
ææ  %
,
ææ% &
Data
øø 
=
øø 
request
øø 
.
øø 
Data
øø #
,
øø# $
Validity
¿¿ 
=
¿¿ 
request
¿¿ "
.
¿¿" #
Validity
¿¿# +
,
¿¿+ ,
Badge
¡¡ 
=
¡¡ 
request
¡¡ 
.
¡¡  
Badge
¡¡  %
,
¡¡% &
Color
¬¬ 
=
¬¬ 
request
¬¬ 
.
¬¬  
Color
¬¬  %
??
¬¬& (
$str
¬¬) D
,
¬¬D E
IsActive
√√ 
=
√√ 
true
√√ 
,
√√  
	CreatedAt
ƒƒ 
=
ƒƒ 
DateTime
ƒƒ $
.
ƒƒ$ %
UtcNow
ƒƒ% +
}
≈≈ 
;
≈≈ 
_context
∆∆ 
.
∆∆ 
PromoOffers
∆∆  
.
∆∆  !
Add
∆∆! $
(
∆∆$ %
offer
∆∆% *
)
∆∆* +
;
∆∆+ ,
await
«« 
_context
«« 
.
«« 
SaveChangesAsync
«« +
(
««+ ,
)
««, -
;
««- .
return
»» 
Ok
»» 
(
»» 
new
»» 
{
»» 
message
»» #
=
»»$ %
$str
»»& H
,
»»H I
promoOfferID
»»J V
=
»»W X
offer
»»Y ^
.
»»^ _
PromoOfferID
»»_ k
}
»»l m
)
»»m n
;
»»n o
}
…… 	
[
ÀÀ 	
HttpPut
ÀÀ	 
(
ÀÀ 
$str
ÀÀ $
)
ÀÀ$ %
]
ÀÀ% &
public
ÃÃ 
async
ÃÃ 
Task
ÃÃ 
<
ÃÃ 
IActionResult
ÃÃ '
>
ÃÃ' (
UpdatePromoOffer
ÃÃ) 9
(
ÃÃ9 :
int
ÃÃ: =
id
ÃÃ> @
,
ÃÃ@ A
[
ÃÃB C
FromBody
ÃÃC K
]
ÃÃK L%
UpdatePromoOfferRequest
ÃÃM d
request
ÃÃe l
)
ÃÃl m
{
ÕÕ 	
var
ŒŒ 
offer
ŒŒ 
=
ŒŒ 
await
ŒŒ 
_context
ŒŒ &
.
ŒŒ& '
PromoOffers
ŒŒ' 2
.
ŒŒ2 3
	FindAsync
ŒŒ3 <
(
ŒŒ< =
id
ŒŒ= ?
)
ŒŒ? @
;
ŒŒ@ A
if
œœ 
(
œœ 
offer
œœ 
==
œœ 
null
œœ 
)
œœ 
return
œœ %
NotFound
œœ& .
(
œœ. /
new
œœ/ 2
{
œœ3 4
message
œœ5 <
=
œœ= >
$str
œœ? V
}
œœW X
)
œœX Y
;
œœY Z
offer
—— 
.
—— 
Title
—— 
=
—— 
request
—— !
.
——! "
Title
——" '
;
——' (
offer
““ 
.
““ 
Description
““ 
=
““ 
request
““  '
.
““' (
Description
““( 3
;
““3 4
offer
”” 
.
”” 
Price
”” 
=
”” 
request
”” !
.
””! "
Price
””" '
;
””' (
offer
‘‘ 
.
‘‘ 
Data
‘‘ 
=
‘‘ 
request
‘‘  
.
‘‘  !
Data
‘‘! %
;
‘‘% &
offer
’’ 
.
’’ 
Validity
’’ 
=
’’ 
request
’’ $
.
’’$ %
Validity
’’% -
;
’’- .
offer
÷÷ 
.
÷÷ 
Badge
÷÷ 
=
÷÷ 
request
÷÷ !
.
÷÷! "
Badge
÷÷" '
;
÷÷' (
offer
◊◊ 
.
◊◊ 
Color
◊◊ 
=
◊◊ 
request
◊◊ !
.
◊◊! "
Color
◊◊" '
??
◊◊( *
offer
◊◊+ 0
.
◊◊0 1
Color
◊◊1 6
;
◊◊6 7
offer
ÿÿ 
.
ÿÿ 
IsActive
ÿÿ 
=
ÿÿ 
request
ÿÿ $
.
ÿÿ$ %
IsActive
ÿÿ% -
;
ÿÿ- .
await
⁄⁄ 
_context
⁄⁄ 
.
⁄⁄ 
SaveChangesAsync
⁄⁄ +
(
⁄⁄+ ,
)
⁄⁄, -
;
⁄⁄- .
return
€€ 
Ok
€€ 
(
€€ 
new
€€ 
{
€€ 
message
€€ #
=
€€$ %
$str
€€& H
}
€€I J
)
€€J K
;
€€K L
}
‹‹ 	
[
ﬁﬁ 	

HttpDelete
ﬁﬁ	 
(
ﬁﬁ 
$str
ﬁﬁ '
)
ﬁﬁ' (
]
ﬁﬁ( )
public
ﬂﬂ 
async
ﬂﬂ 
Task
ﬂﬂ 
<
ﬂﬂ 
IActionResult
ﬂﬂ '
>
ﬂﬂ' (
DeletePromoOffer
ﬂﬂ) 9
(
ﬂﬂ9 :
int
ﬂﬂ: =
id
ﬂﬂ> @
)
ﬂﬂ@ A
{
‡‡ 	
var
·· 
offer
·· 
=
·· 
await
·· 
_context
·· &
.
··& '
PromoOffers
··' 2
.
··2 3
	FindAsync
··3 <
(
··< =
id
··= ?
)
··? @
;
··@ A
if
‚‚ 
(
‚‚ 
offer
‚‚ 
==
‚‚ 
null
‚‚ 
)
‚‚ 
return
‚‚ %
NotFound
‚‚& .
(
‚‚. /
new
‚‚/ 2
{
‚‚3 4
message
‚‚5 <
=
‚‚= >
$str
‚‚? V
}
‚‚W X
)
‚‚X Y
;
‚‚Y Z
_context
‰‰ 
.
‰‰ 
PromoOffers
‰‰  
.
‰‰  !
Remove
‰‰! '
(
‰‰' (
offer
‰‰( -
)
‰‰- .
;
‰‰. /
await
ÂÂ 
_context
ÂÂ 
.
ÂÂ 
SaveChangesAsync
ÂÂ +
(
ÂÂ+ ,
)
ÂÂ, -
;
ÂÂ- .
return
ÊÊ 
Ok
ÊÊ 
(
ÊÊ 
new
ÊÊ 
{
ÊÊ 
message
ÊÊ #
=
ÊÊ$ %
$str
ÊÊ& H
}
ÊÊI J
)
ÊÊJ K
;
ÊÊK L
}
ÁÁ 	
[
ÈÈ 	
HttpPost
ÈÈ	 
(
ÈÈ 
$str
ÈÈ &
)
ÈÈ& '
]
ÈÈ' (
public
ÍÍ 
async
ÍÍ 
Task
ÍÍ 
<
ÍÍ 
IActionResult
ÍÍ '
>
ÍÍ' (
AdminTopUpPrepaid
ÍÍ) :
(
ÍÍ: ;
int
ÍÍ; >
id
ÍÍ? A
,
ÍÍA B
[
ÍÍC D
FromBody
ÍÍD L
]
ÍÍL M
AdminTopUpRequest
ÍÍN _
request
ÍÍ` g
)
ÍÍg h
{
ÎÎ 	
var
ÏÏ 
prepaid
ÏÏ 
=
ÏÏ 
await
ÏÏ 
_context
ÏÏ  (
.
ÏÏ( )
PrepaidLoads
ÏÏ) 5
.
ÌÌ 
Include
ÌÌ 
(
ÌÌ 
p
ÌÌ 
=>
ÌÌ 
p
ÌÌ 
.
ÌÌ  
ServiceAccount
ÌÌ  .
)
ÌÌ. /
.
ÓÓ !
FirstOrDefaultAsync
ÓÓ $
(
ÓÓ$ %
p
ÓÓ% &
=>
ÓÓ' )
p
ÓÓ* +
.
ÓÓ+ ,
PrepaidLoadID
ÓÓ, 9
==
ÓÓ: <
id
ÓÓ= ?
)
ÓÓ? @
;
ÓÓ@ A
if
 
(
 
prepaid
 
==
 
null
 
)
  
return
! '
NotFound
( 0
(
0 1
new
1 4
{
5 6
message
7 >
=
? @
$str
A \
}
] ^
)
^ _
;
_ `
if
ÒÒ 
(
ÒÒ 
request
ÒÒ 
.
ÒÒ 
Amount
ÒÒ 
<=
ÒÒ !
$num
ÒÒ" #
)
ÒÒ# $
return
ÒÒ% +

BadRequest
ÒÒ, 6
(
ÒÒ6 7
new
ÒÒ7 :
{
ÒÒ; <
message
ÒÒ= D
=
ÒÒE F
$str
ÒÒG f
}
ÒÒg h
)
ÒÒh i
;
ÒÒi j
prepaid
ÛÛ 
.
ÛÛ 

LoadAmount
ÛÛ 
+=
ÛÛ !
request
ÛÛ" )
.
ÛÛ) *
Amount
ÛÛ* 0
;
ÛÛ0 1
prepaid
ÙÙ 
.
ÙÙ 
RemainingBalance
ÙÙ $
=
ÙÙ% &
(
ÙÙ' (
prepaid
ÙÙ( /
.
ÙÙ/ 0
RemainingBalance
ÙÙ0 @
??
ÙÙA C
$num
ÙÙD E
)
ÙÙE F
+
ÙÙG H
request
ÙÙI P
.
ÙÙP Q
Amount
ÙÙQ W
;
ÙÙW X
prepaid
ıı 
.
ıı 
LastReloadBalance
ıı %
=
ıı& '
DateTime
ıı( 0
.
ıı0 1
UtcNow
ıı1 7
;
ıı7 8
await
˜˜ 
_context
˜˜ 
.
˜˜ 
SaveChangesAsync
˜˜ +
(
˜˜+ ,
)
˜˜, -
;
˜˜- .
return
˘˘ 
Ok
˘˘ 
(
˘˘ 
new
˘˘ 
{
˙˙ 
message
˚˚ 
=
˚˚ 
$str
˚˚ -
,
˚˚- .

loadAmount
¸¸ 
=
¸¸ 
prepaid
¸¸ $
.
¸¸$ %

LoadAmount
¸¸% /
,
¸¸/ 0
remainingBalance
˝˝  
=
˝˝! "
prepaid
˝˝# *
.
˝˝* +
RemainingBalance
˝˝+ ;
,
˝˝; <

lastReload
˛˛ 
=
˛˛ 
prepaid
˛˛ $
.
˛˛$ %
LastReloadBalance
˛˛% 6
}
ˇˇ 
)
ˇˇ 
;
ˇˇ 
}
ÄÄ 	
[
ÇÇ 	
HttpPut
ÇÇ	 
(
ÇÇ 
$str
ÇÇ &
)
ÇÇ& '
]
ÇÇ' (
public
ÉÉ 
async
ÉÉ 
Task
ÉÉ 
<
ÉÉ 
IActionResult
ÉÉ '
>
ÉÉ' (!
UpdatePrepaidStatus
ÉÉ) <
(
ÉÉ< =
int
ÉÉ= @
id
ÉÉA C
,
ÉÉC D
[
ÉÉE F
FromBody
ÉÉF N
]
ÉÉN O(
UpdatePrepaidStatusRequest
ÉÉP j
request
ÉÉk r
)
ÉÉr s
{
ÑÑ 	
var
ÖÖ 
prepaid
ÖÖ 
=
ÖÖ 
await
ÖÖ 
_context
ÖÖ  (
.
ÖÖ( )
PrepaidLoads
ÖÖ) 5
.
ÜÜ 
Include
ÜÜ 
(
ÜÜ 
p
ÜÜ 
=>
ÜÜ 
p
ÜÜ 
.
ÜÜ  
ServiceAccount
ÜÜ  .
)
ÜÜ. /
.
áá !
FirstOrDefaultAsync
áá $
(
áá$ %
p
áá% &
=>
áá' )
p
áá* +
.
áá+ ,
PrepaidLoadID
áá, 9
==
áá: <
id
áá= ?
)
áá? @
;
áá@ A
if
ââ 
(
ââ 
prepaid
ââ 
==
ââ 
null
ââ 
)
ââ  
return
ââ! '
NotFound
ââ( 0
(
ââ0 1
new
ââ1 4
{
ââ5 6
message
ââ7 >
=
ââ? @
$str
ââA \
}
ââ] ^
)
ââ^ _
;
ââ_ `
prepaid
ãã 
.
ãã 
ServiceAccount
ãã "
.
ãã" #
Status
ãã# )
=
ãã* +
request
ãã, 3
.
ãã3 4
Status
ãã4 :
;
ãã: ;
await
åå 
_context
åå 
.
åå 
SaveChangesAsync
åå +
(
åå+ ,
)
åå, -
;
åå- .
return
éé 
Ok
éé 
(
éé 
new
éé 
{
éé 
message
éé #
=
éé$ %
$str
éé& F
,
ééF G
status
ééH N
=
ééO P
request
ééQ X
.
ééX Y
Status
ééY _
}
éé` a
)
ééa b
;
ééb c
}
èè 	
[
ëë 	

HttpDelete
ëë	 
(
ëë 
$str
ëë "
)
ëë" #
]
ëë# $
public
íí 
async
íí 
Task
íí 
<
íí 
IActionResult
íí '
>
íí' ("
DeletePrepaidService
íí) =
(
íí= >
int
íí> A
id
ííB D
)
ííD E
{
ìì 	
var
îî 
prepaid
îî 
=
îî 
await
îî 
_context
îî  (
.
îî( )
PrepaidLoads
îî) 5
.
ïï 
Include
ïï 
(
ïï 
p
ïï 
=>
ïï 
p
ïï 
.
ïï  
ServiceAccount
ïï  .
)
ïï. /
.
ññ 
ThenInclude
ññ  
(
ññ  !
sa
ññ! #
=>
ññ$ &
sa
ññ' )
.
ññ) *
Device
ññ* 0
)
ññ0 1
.
óó !
FirstOrDefaultAsync
óó $
(
óó$ %
p
óó% &
=>
óó' )
p
óó* +
.
óó+ ,
PrepaidLoadID
óó, 9
==
óó: <
id
óó= ?
)
óó? @
;
óó@ A
if
ôô 
(
ôô 
prepaid
ôô 
==
ôô 
null
ôô 
)
ôô  
return
ôô! '
NotFound
ôô( 0
(
ôô0 1
new
ôô1 4
{
ôô5 6
message
ôô7 >
=
ôô? @
$str
ôôA \
}
ôô] ^
)
ôô^ _
;
ôô_ `
_context
õõ 
.
õõ 
PrepaidLoads
õõ !
.
õõ! "
Remove
õõ" (
(
õõ( )
prepaid
õõ) 0
)
õõ0 1
;
õõ1 2
await
úú 
_context
úú 
.
úú 
SaveChangesAsync
úú +
(
úú+ ,
)
úú, -
;
úú- .
return
ûû 
Ok
ûû 
(
ûû 
new
ûû 
{
ûû 
message
ûû #
=
ûû$ %
$str
ûû& L
}
ûûM N
)
ûûN O
;
ûûO P
}
üü 	
[
¢¢ 	
HttpGet
¢¢	 
(
¢¢ 
$str
¢¢ 
)
¢¢ 
]
¢¢ 
public
££ 
async
££ 
Task
££ 
<
££ 
IActionResult
££ '
>
££' (
GetAllPromos
££) 5
(
££5 6
)
££6 7
{
§§ 	
var
•• 
promos
•• 
=
•• 
await
•• 
_context
•• '
.
••' (
PrepaidPromos
••( 5
.
¶¶ 
Include
¶¶ 
(
¶¶ 
p
¶¶ 
=>
¶¶ 
p
¶¶ 
.
¶¶  
User
¶¶  $
)
¶¶$ %
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
ßß  
PrepaidLoad
ßß  +
)
ßß+ ,
.
®® 
OrderByDescending
®® "
(
®®" #
p
®®# $
=>
®®% '
p
®®( )
.
®®) *
ActivatedAt
®®* 5
)
®®5 6
.
©© 
Select
©© 
(
©© 
p
©© 
=>
©© 
new
©©  
{
™™ 
p
´´ 
.
´´ 
PrepaidPromoID
´´ $
,
´´$ %
p
¨¨ 
.
¨¨ 
PrepaidLoadID
¨¨ #
,
¨¨# $
p
≠≠ 
.
≠≠ 
UserID
≠≠ 
,
≠≠ 
Customer
ÆÆ 
=
ÆÆ 
p
ÆÆ  
.
ÆÆ  !
User
ÆÆ! %
.
ÆÆ% &
	FirstName
ÆÆ& /
+
ÆÆ0 1
$str
ÆÆ2 5
+
ÆÆ6 7
p
ÆÆ8 9
.
ÆÆ9 :
User
ÆÆ: >
.
ÆÆ> ?
LastName
ÆÆ? G
,
ÆÆG H
Email
ØØ 
=
ØØ 
p
ØØ 
.
ØØ 
User
ØØ "
.
ØØ" #
Email
ØØ# (
,
ØØ( )
p
∞∞ 
.
∞∞ 

PromoTitle
∞∞  
,
∞∞  !
p
±± 
.
±± 
TotalDataMB
±± !
,
±±! "
p
≤≤ 
.
≤≤ 
RemainingDataMB
≤≤ %
,
≤≤% &

UsedDataMB
≥≥ 
=
≥≥  
p
≥≥! "
.
≥≥" #
TotalDataMB
≥≥# .
-
≥≥/ 0
p
≥≥1 2
.
≥≥2 3
RemainingDataMB
≥≥3 B
,
≥≥B C
p
¥¥ 
.
¥¥ 
ValidityDays
¥¥ "
,
¥¥" #
p
µµ 
.
µµ 
ActivatedAt
µµ !
,
µµ! "
p
∂∂ 
.
∂∂ 
	ExpiresAt
∂∂ 
,
∂∂  
p
∑∑ 
.
∑∑ 
Status
∑∑ 
}
∏∏ 
)
∏∏ 
.
ππ 
ToListAsync
ππ 
(
ππ 
)
ππ 
;
ππ 
return
ªª 
Ok
ªª 
(
ªª 
promos
ªª 
)
ªª 
;
ªª 
}
ºº 	
[
ææ 	
HttpPut
ææ	 
(
ææ 
$str
ææ %
)
ææ% &
]
ææ& '
public
øø 
async
øø 
Task
øø 
<
øø 
IActionResult
øø '
>
øø' (
UpdatePromoStatus
øø) :
(
øø: ;
int
øø; >
id
øø? A
,
øøA B
[
øøC D
FromBody
øøD L
]
øøL M&
UpdatePromoStatusRequest
øøN f
request
øøg n
)
øøn o
{
¿¿ 	
var
¡¡ 
promo
¡¡ 
=
¡¡ 
await
¡¡ 
_context
¡¡ &
.
¡¡& '
PrepaidPromos
¡¡' 4
.
¡¡4 5
	FindAsync
¡¡5 >
(
¡¡> ?
id
¡¡? A
)
¡¡A B
;
¡¡B C
if
¬¬ 
(
¬¬ 
promo
¬¬ 
==
¬¬ 
null
¬¬ 
)
¬¬ 
return
¬¬ %
NotFound
¬¬& .
(
¬¬. /
new
¬¬/ 2
{
¬¬3 4
message
¬¬5 <
=
¬¬= >
$str
¬¬? P
}
¬¬Q R
)
¬¬R S
;
¬¬S T
promo
ƒƒ 
.
ƒƒ 
Status
ƒƒ 
=
ƒƒ 
request
ƒƒ "
.
ƒƒ" #
Status
ƒƒ# )
;
ƒƒ) *
await
≈≈ 
_context
≈≈ 
.
≈≈ 
SaveChangesAsync
≈≈ +
(
≈≈+ ,
)
≈≈, -
;
≈≈- .
return
«« 
Ok
«« 
(
«« 
new
«« 
{
«« 
message
«« #
=
««$ %
$str
««& <
,
««< =
status
««> D
=
««E F
request
««G N
.
««N O
Status
««O U
}
««V W
)
««W X
;
««X Y
}
»» 	
[
   	

HttpDelete
  	 
(
   
$str
   !
)
  ! "
]
  " #
public
ÀÀ 
async
ÀÀ 
Task
ÀÀ 
<
ÀÀ 
IActionResult
ÀÀ '
>
ÀÀ' (
DeletePromo
ÀÀ) 4
(
ÀÀ4 5
int
ÀÀ5 8
id
ÀÀ9 ;
)
ÀÀ; <
{
ÃÃ 	
var
ÕÕ 
promo
ÕÕ 
=
ÕÕ 
await
ÕÕ 
_context
ÕÕ &
.
ÕÕ& '
PrepaidPromos
ÕÕ' 4
.
ÕÕ4 5
	FindAsync
ÕÕ5 >
(
ÕÕ> ?
id
ÕÕ? A
)
ÕÕA B
;
ÕÕB C
if
ŒŒ 
(
ŒŒ 
promo
ŒŒ 
==
ŒŒ 
null
ŒŒ 
)
ŒŒ 
return
ŒŒ %
NotFound
ŒŒ& .
(
ŒŒ. /
new
ŒŒ/ 2
{
ŒŒ3 4
message
ŒŒ5 <
=
ŒŒ= >
$str
ŒŒ? P
}
ŒŒQ R
)
ŒŒR S
;
ŒŒS T
_context
–– 
.
–– 
PrepaidPromos
–– "
.
––" #
Remove
––# )
(
––) *
promo
––* /
)
––/ 0
;
––0 1
await
—— 
_context
—— 
.
—— 
SaveChangesAsync
—— +
(
——+ ,
)
——, -
;
——- .
return
”” 
Ok
”” 
(
”” 
new
”” 
{
”” 
message
”” #
=
””$ %
$str
””& B
}
””C D
)
””D E
;
””E F
}
‘‘ 	
[
◊◊ 	
HttpGet
◊◊	 
(
◊◊ 
$str
◊◊  
)
◊◊  !
]
◊◊! "
public
ÿÿ 
async
ÿÿ 
Task
ÿÿ 
<
ÿÿ 
IActionResult
ÿÿ '
>
ÿÿ' (
GetNotifications
ÿÿ) 9
(
ÿÿ9 :
)
ÿÿ: ;
{
ŸŸ 	
var
⁄⁄ 
userId
⁄⁄ 
=
⁄⁄ 
User
⁄⁄ 
.
⁄⁄ 
	FindFirst
⁄⁄ '
(
⁄⁄' (
System
⁄⁄( .
.
⁄⁄. /
Security
⁄⁄/ 7
.
⁄⁄7 8
Claims
⁄⁄8 >
.
⁄⁄> ?

ClaimTypes
⁄⁄? I
.
⁄⁄I J
NameIdentifier
⁄⁄J X
)
⁄⁄X Y
?
⁄⁄Y Z
.
⁄⁄Z [
Value
⁄⁄[ `
;
⁄⁄` a
if
€€ 
(
€€ 
userId
€€ 
==
€€ 
null
€€ 
)
€€ 
return
€€  &
Unauthorized
€€' 3
(
€€3 4
)
€€4 5
;
€€5 6
var
›› 
notifications
›› 
=
›› 
await
››  %
_context
››& .
.
››. /
Notifications
››/ <
.
ﬁﬁ 
Where
ﬁﬁ 
(
ﬁﬁ 
n
ﬁﬁ 
=>
ﬁﬁ 
n
ﬁﬁ 
.
ﬁﬁ 
UserID
ﬁﬁ $
==
ﬁﬁ% '
userId
ﬁﬁ( .
)
ﬁﬁ. /
.
ﬂﬂ 
OrderByDescending
ﬂﬂ "
(
ﬂﬂ" #
n
ﬂﬂ# $
=>
ﬂﬂ% '
n
ﬂﬂ( )
.
ﬂﬂ) *
SentAt
ﬂﬂ* 0
)
ﬂﬂ0 1
.
‡‡ 
ToListAsync
‡‡ 
(
‡‡ 
)
‡‡ 
;
‡‡ 
return
·· 
Ok
·· 
(
·· 
notifications
·· #
)
··# $
;
··$ %
}
‚‚ 	
[
‰‰ 	
HttpPost
‰‰	 
(
‰‰ 
$str
‰‰ !
)
‰‰! "
]
‰‰" #
public
ÂÂ 
async
ÂÂ 
Task
ÂÂ 
<
ÂÂ 
IActionResult
ÂÂ '
>
ÂÂ' ( 
CreateNotification
ÂÂ) ;
(
ÂÂ; <
[
ÂÂ< =
FromBody
ÂÂ= E
]
ÂÂE F'
CreateNotificationRequest
ÂÂG `
request
ÂÂa h
)
ÂÂh i
{
ÊÊ 	
var
ÁÁ 
userId
ÁÁ 
=
ÁÁ 
User
ÁÁ 
.
ÁÁ 
	FindFirst
ÁÁ '
(
ÁÁ' (
System
ÁÁ( .
.
ÁÁ. /
Security
ÁÁ/ 7
.
ÁÁ7 8
Claims
ÁÁ8 >
.
ÁÁ> ?

ClaimTypes
ÁÁ? I
.
ÁÁI J
NameIdentifier
ÁÁJ X
)
ÁÁX Y
?
ÁÁY Z
.
ÁÁZ [
Value
ÁÁ[ `
;
ÁÁ` a
if
ËË 
(
ËË 
userId
ËË 
==
ËË 
null
ËË 
)
ËË 
return
ËË  &
Unauthorized
ËË' 3
(
ËË3 4
)
ËË4 5
;
ËË5 6
var
ÍÍ 
notification
ÍÍ 
=
ÍÍ 
new
ÍÍ "
Notification
ÍÍ# /
{
ÎÎ 
UserID
ÏÏ 
=
ÏÏ 
userId
ÏÏ 
,
ÏÏ  
Message
ÌÌ 
=
ÌÌ 
request
ÌÌ !
.
ÌÌ! "
Message
ÌÌ" )
,
ÌÌ) *
Type
ÓÓ 
=
ÓÓ 
request
ÓÓ 
.
ÓÓ 
Type
ÓÓ #
??
ÓÓ$ &
$str
ÓÓ' -
,
ÓÓ- .
Status
ÔÔ 
=
ÔÔ 
$str
ÔÔ !
,
ÔÔ! "
SentAt
 
=
 
DateTime
 !
.
! "
UtcNow
" (
}
ÒÒ 
;
ÒÒ 
_context
ÛÛ 
.
ÛÛ 
Notifications
ÛÛ "
.
ÛÛ" #
Add
ÛÛ# &
(
ÛÛ& '
notification
ÛÛ' 3
)
ÛÛ3 4
;
ÛÛ4 5
await
ÙÙ 
_context
ÙÙ 
.
ÙÙ 
SaveChangesAsync
ÙÙ +
(
ÙÙ+ ,
)
ÙÙ, -
;
ÙÙ- .
return
ıı 
Ok
ıı 
(
ıı 
new
ıı 
{
ıı 
message
ıı #
=
ıı$ %
$str
ıı& <
,
ıı< =
notificationID
ıı> L
=
ııM N
notification
ııO [
.
ıı[ \
NotificationID
ıı\ j
}
ıık l
)
ııl m
;
ıım n
}
ˆˆ 	
[
¯¯ 	
HttpPost
¯¯	 
(
¯¯ 
$str
¯¯ /
)
¯¯/ 0
]
¯¯0 1
public
˘˘ 
async
˘˘ 
Task
˘˘ 
<
˘˘ 
IActionResult
˘˘ '
>
˘˘' (&
MarkAllNotificationsRead
˘˘) A
(
˘˘A B
)
˘˘B C
{
˙˙ 	
var
˚˚ 
userId
˚˚ 
=
˚˚ 
User
˚˚ 
.
˚˚ 
	FindFirst
˚˚ '
(
˚˚' (
System
˚˚( .
.
˚˚. /
Security
˚˚/ 7
.
˚˚7 8
Claims
˚˚8 >
.
˚˚> ?

ClaimTypes
˚˚? I
.
˚˚I J
NameIdentifier
˚˚J X
)
˚˚X Y
?
˚˚Y Z
.
˚˚Z [
Value
˚˚[ `
;
˚˚` a
if
¸¸ 
(
¸¸ 
userId
¸¸ 
==
¸¸ 
null
¸¸ 
)
¸¸ 
return
¸¸  &
Unauthorized
¸¸' 3
(
¸¸3 4
)
¸¸4 5
;
¸¸5 6
var
˛˛ 
notifications
˛˛ 
=
˛˛ 
await
˛˛  %
_context
˛˛& .
.
˛˛. /
Notifications
˛˛/ <
.
ˇˇ 
Where
ˇˇ 
(
ˇˇ 
n
ˇˇ 
=>
ˇˇ 
n
ˇˇ 
.
ˇˇ 
UserID
ˇˇ $
==
ˇˇ% '
userId
ˇˇ( .
&&
ˇˇ/ 1
n
ˇˇ2 3
.
ˇˇ3 4
Status
ˇˇ4 :
==
ˇˇ; =
$str
ˇˇ> F
)
ˇˇF G
.
ÄÄ 
ToListAsync
ÄÄ 
(
ÄÄ 
)
ÄÄ 
;
ÄÄ 
foreach
ÇÇ 
(
ÇÇ 
var
ÇÇ 
notification
ÇÇ %
in
ÇÇ& (
notifications
ÇÇ) 6
)
ÇÇ6 7
{
ÉÉ 
notification
ÑÑ 
.
ÑÑ 
Status
ÑÑ #
=
ÑÑ$ %
$str
ÑÑ& ,
;
ÑÑ, -
}
ÖÖ 
await
áá 
_context
áá 
.
áá 
SaveChangesAsync
áá +
(
áá+ ,
)
áá, -
;
áá- .
return
àà 
Ok
àà 
(
àà 
new
àà 
{
àà 
message
àà #
=
àà$ %
$str
àà& H
}
ààI J
)
ààJ K
;
ààK L
}
ââ 	
[
ãã 	

HttpDelete
ãã	 
(
ãã 
$str
ãã (
)
ãã( )
]
ãã) *
public
åå 
async
åå 
Task
åå 
<
åå 
IActionResult
åå '
>
åå' ( 
DeleteNotification
åå) ;
(
åå; <
int
åå< ?
id
åå@ B
)
ååB C
{
çç 	
var
éé 
notification
éé 
=
éé 
await
éé $
_context
éé% -
.
éé- .
Notifications
éé. ;
.
éé; <
	FindAsync
éé< E
(
ééE F
id
ééF H
)
ééH I
;
ééI J
if
èè 
(
èè 
notification
èè 
==
èè 
null
èè  $
)
èè$ %
return
èè& ,
NotFound
èè- 5
(
èè5 6
)
èè6 7
;
èè7 8
_context
ëë 
.
ëë 
Notifications
ëë "
.
ëë" #
Remove
ëë# )
(
ëë) *
notification
ëë* 6
)
ëë6 7
;
ëë7 8
await
íí 
_context
íí 
.
íí 
SaveChangesAsync
íí +
(
íí+ ,
)
íí, -
;
íí- .
return
ìì 
Ok
ìì 
(
ìì 
new
ìì 
{
ìì 
message
ìì #
=
ìì$ %
$str
ìì& <
}
ìì= >
)
ìì> ?
;
ìì? @
}
îî 	
[
óó 	
HttpGet
óó	 
(
óó 
$str
óó 
)
óó 
]
óó 
public
òò 
async
òò 
Task
òò 
<
òò 
IActionResult
òò '
>
òò' (
GetSettings
òò) 4
(
òò4 5
)
òò5 6
{
ôô 	
var
öö 
settings
öö 
=
öö 
await
öö  
_context
öö! )
.
öö) *
SystemSettings
öö* 8
.
öö8 9!
FirstOrDefaultAsync
öö9 L
(
ööL M
)
ööM N
;
ööN O
if
õõ 
(
õõ 
settings
õõ 
==
õõ 
null
õõ  
)
õõ  !
{
úú 
settings
ùù 
=
ùù 
new
ùù 
SystemSettings
ùù -
(
ùù- .
)
ùù. /
;
ùù/ 0
_context
ûû 
.
ûû 
SystemSettings
ûû '
.
ûû' (
Add
ûû( +
(
ûû+ ,
settings
ûû, 4
)
ûû4 5
;
ûû5 6
await
üü 
_context
üü 
.
üü 
SaveChangesAsync
üü /
(
üü/ 0
)
üü0 1
;
üü1 2
}
†† 
return
°° 
Ok
°° 
(
°° 
settings
°° 
)
°° 
;
°°  
}
¢¢ 	
[
§§ 	
HttpPut
§§	 
(
§§ 
$str
§§ 
)
§§ 
]
§§ 
public
•• 
async
•• 
Task
•• 
<
•• 
IActionResult
•• '
>
••' (
UpdateSettings
••) 7
(
••7 8
[
••8 9
FromBody
••9 A
]
••A B)
UpdateSystemSettingsRequest
••C ^
request
••_ f
)
••f g
{
¶¶ 	
var
ßß 
settings
ßß 
=
ßß 
await
ßß  
_context
ßß! )
.
ßß) *
SystemSettings
ßß* 8
.
ßß8 9!
FirstOrDefaultAsync
ßß9 L
(
ßßL M
)
ßßM N
;
ßßN O
if
®® 
(
®® 
settings
®® 
==
®® 
null
®®  
)
®®  !
{
©© 
settings
™™ 
=
™™ 
new
™™ 
SystemSettings
™™ -
(
™™- .
)
™™. /
;
™™/ 0
_context
´´ 
.
´´ 
SystemSettings
´´ '
.
´´' (
Add
´´( +
(
´´+ ,
settings
´´, 4
)
´´4 5
;
´´5 6
}
¨¨ 
settings
ÆÆ 
.
ÆÆ 
SiteName
ÆÆ 
=
ÆÆ 
request
ÆÆ  '
.
ÆÆ' (
SiteName
ÆÆ( 0
??
ÆÆ1 3
settings
ÆÆ4 <
.
ÆÆ< =
SiteName
ÆÆ= E
;
ÆÆE F
settings
ØØ 
.
ØØ 
	SiteEmail
ØØ 
=
ØØ  
request
ØØ! (
.
ØØ( )
	SiteEmail
ØØ) 2
??
ØØ3 5
settings
ØØ6 >
.
ØØ> ?
	SiteEmail
ØØ? H
;
ØØH I
settings
∞∞ 
.
∞∞ 
MaintenanceMode
∞∞ $
=
∞∞% &
request
∞∞' .
.
∞∞. /
MaintenanceMode
∞∞/ >
??
∞∞? A
settings
∞∞B J
.
∞∞J K
MaintenanceMode
∞∞K Z
;
∞∞Z [
settings
±± 
.
±± 
MaxLoginAttempts
±± %
=
±±& '
request
±±( /
.
±±/ 0
MaxLoginAttempts
±±0 @
??
±±A C
settings
±±D L
.
±±L M
MaxLoginAttempts
±±M ]
;
±±] ^
settings
≤≤ 
.
≤≤ 
SessionTimeout
≤≤ #
=
≤≤$ %
request
≤≤& -
.
≤≤- .
SessionTimeout
≤≤. <
??
≤≤= ?
settings
≤≤@ H
.
≤≤H I
SessionTimeout
≤≤I W
;
≤≤W X
settings
≥≥ 
.
≥≥ 
EnableTwoFactor
≥≥ $
=
≥≥% &
request
≥≥' .
.
≥≥. /
EnableTwoFactor
≥≥/ >
??
≥≥? A
settings
≥≥B J
.
≥≥J K
EnableTwoFactor
≥≥K Z
;
≥≥Z [
settings
¥¥ 
.
¥¥ 
EnableAuditLogs
¥¥ $
=
¥¥% &
request
¥¥' .
.
¥¥. /
EnableAuditLogs
¥¥/ >
??
¥¥? A
settings
¥¥B J
.
¥¥J K
EnableAuditLogs
¥¥K Z
;
¥¥Z [
settings
µµ 
.
µµ 
NotificationEmail
µµ &
=
µµ' (
request
µµ) 0
.
µµ0 1
NotificationEmail
µµ1 B
??
µµC E
settings
µµF N
.
µµN O
NotificationEmail
µµO `
;
µµ` a
settings
∂∂ 
.
∂∂ 
EmailOnNewTickets
∂∂ &
=
∂∂' (
request
∂∂) 0
.
∂∂0 1
EmailOnNewTickets
∂∂1 B
??
∂∂C E
settings
∂∂F N
.
∂∂N O
EmailOnNewTickets
∂∂O `
;
∂∂` a
settings
∑∑ 
.
∑∑ $
EmailOnPaymentReceived
∑∑ +
=
∑∑, -
request
∑∑. 5
.
∑∑5 6$
EmailOnPaymentReceived
∑∑6 L
??
∑∑M O
settings
∑∑P X
.
∑∑X Y$
EmailOnPaymentReceived
∑∑Y o
;
∑∑o p
settings
∏∏ 
.
∏∏ !
EmailOnSystemErrors
∏∏ (
=
∏∏) *
request
∏∏+ 2
.
∏∏2 3!
EmailOnSystemErrors
∏∏3 F
??
∏∏G I
settings
∏∏J R
.
∏∏R S!
EmailOnSystemErrors
∏∏S f
;
∏∏f g
settings
ππ 
.
ππ #
EmailOnSecurityAlerts
ππ *
=
ππ+ ,
request
ππ- 4
.
ππ4 5#
EmailOnSecurityAlerts
ππ5 J
??
ππK M
settings
ππN V
.
ππV W#
EmailOnSecurityAlerts
ππW l
;
ππl m
settings
∫∫ 
.
∫∫ 
	UpdatedAt
∫∫ 
=
∫∫  
DateTime
∫∫! )
.
∫∫) *
UtcNow
∫∫* 0
;
∫∫0 1
await
ºº 
_context
ºº 
.
ºº 
SaveChangesAsync
ºº +
(
ºº+ ,
)
ºº, -
;
ºº- .
return
ΩΩ 
Ok
ΩΩ 
(
ΩΩ 
new
ΩΩ 
{
ΩΩ 
message
ΩΩ #
=
ΩΩ$ %
$str
ΩΩ& E
,
ΩΩE F
settings
ΩΩG O
}
ΩΩP Q
)
ΩΩQ R
;
ΩΩR S
}
ææ 	
[
¿¿ 	
	Authorize
¿¿	 
(
¿¿ 
Roles
¿¿ 
=
¿¿ 
$str
¿¿ '
)
¿¿' (
]
¿¿( )
[
¡¡ 	
HttpGet
¡¡	 
(
¡¡ 
$str
¡¡ #
)
¡¡# $
]
¡¡$ %
public
¬¬ 
async
¬¬ 
Task
¬¬ 
<
¬¬ 
IActionResult
¬¬ '
>
¬¬' ( 
GetSuperAdminCount
¬¬) ;
(
¬¬; <
)
¬¬< =
{
√√ 	
var
ƒƒ 
superAdminRoleId
ƒƒ  
=
ƒƒ! "
await
ƒƒ# (
_context
ƒƒ) 1
.
ƒƒ1 2
Roles
ƒƒ2 7
.
≈≈ 
Where
≈≈ 
(
≈≈ 
r
≈≈ 
=>
≈≈ 
r
≈≈ 
.
≈≈ 
Name
≈≈ "
==
≈≈# %
$str
≈≈& 2
)
≈≈2 3
.
∆∆ 
Select
∆∆ 
(
∆∆ 
r
∆∆ 
=>
∆∆ 
r
∆∆ 
.
∆∆ 
Id
∆∆ !
)
∆∆! "
.
«« !
FirstOrDefaultAsync
«« $
(
««$ %
)
««% &
;
««& '
var
…… 
count
…… 
=
…… 
$num
…… 
;
…… 
if
   
(
   
!
   
string
   
.
   
IsNullOrEmpty
   %
(
  % &
superAdminRoleId
  & 6
)
  6 7
)
  7 8
{
ÀÀ 
count
ÃÃ 
=
ÃÃ 
await
ÃÃ 
_context
ÃÃ &
.
ÃÃ& '
	UserRoles
ÃÃ' 0
.
ÕÕ 

CountAsync
ÕÕ 
(
ÕÕ  
ur
ÕÕ  "
=>
ÕÕ# %
ur
ÕÕ& (
.
ÕÕ( )
RoleId
ÕÕ) /
==
ÕÕ0 2
superAdminRoleId
ÕÕ3 C
)
ÕÕC D
;
ÕÕD E
}
ŒŒ 
var
–– 
	canCreate
–– 
=
–– 
Math
––  
.
––  !
Max
––! $
(
––$ %
$num
––% &
,
––& '
$num
––( )
-
––* +
count
––, 1
)
––1 2
;
––2 3
return
—— 
Ok
—— 
(
—— 
new
—— 
{
—— 
count
—— !
,
——! "
	canCreate
——# ,
}
——- .
)
——. /
;
——/ 0
}
““ 	
[
‘‘ 	
	Authorize
‘‘	 
(
‘‘ 
Roles
‘‘ 
=
‘‘ 
$str
‘‘ '
)
‘‘' (
]
‘‘( )
[
’’ 	
HttpGet
’’	 
(
’’ 
$str
’’ "
)
’’" #
]
’’# $
public
÷÷ 
async
÷÷ 
Task
÷÷ 
<
÷÷ 
IActionResult
÷÷ '
>
÷÷' (
GetSuspendedUsers
÷÷) :
(
÷÷: ;
)
÷÷; <
{
◊◊ 	
var
ÿÿ 
suspendedUsers
ÿÿ 
=
ÿÿ  
await
ÿÿ! &
_context
ÿÿ' /
.
ÿÿ/ 0
LoginAttempts
ÿÿ0 =
.
ŸŸ 
Where
ŸŸ 
(
ŸŸ 
la
ŸŸ 
=>
ŸŸ 
la
ŸŸ 
.
ŸŸ  
LockedUntil
ŸŸ  +
.
ŸŸ+ ,
HasValue
ŸŸ, 4
&&
ŸŸ5 7
la
ŸŸ8 :
.
ŸŸ: ;
LockedUntil
ŸŸ; F
>
ŸŸG H
DateTime
ŸŸI Q
.
ŸŸQ R
UtcNow
ŸŸR X
)
ŸŸX Y
.
⁄⁄ 
Include
⁄⁄ 
(
⁄⁄ 
la
⁄⁄ 
=>
⁄⁄ 
la
⁄⁄ !
.
⁄⁄! "
User
⁄⁄" &
)
⁄⁄& '
.
€€ 
OrderByDescending
€€ "
(
€€" #
la
€€# %
=>
€€& (
la
€€) +
.
€€+ ,
LockedUntil
€€, 7
)
€€7 8
.
‹‹ 
Select
‹‹ 
(
‹‹ 
la
‹‹ 
=>
‹‹ 
new
‹‹ !
{
›› 
la
ﬁﬁ 
.
ﬁﬁ 
LoginAttemptID
ﬁﬁ %
,
ﬁﬁ% &
la
ﬂﬂ 
.
ﬂﬂ 
UserID
ﬂﬂ 
,
ﬂﬂ 
UserName
‡‡ 
=
‡‡ 
la
‡‡ !
.
‡‡! "
User
‡‡" &
.
‡‡& '
	FirstName
‡‡' 0
+
‡‡1 2
$str
‡‡3 6
+
‡‡7 8
la
‡‡9 ;
.
‡‡; <
User
‡‡< @
.
‡‡@ A
LastName
‡‡A I
,
‡‡I J
Email
·· 
=
·· 
la
·· 
.
·· 
User
·· #
.
··# $
Email
··$ )
,
··) *
FailedAttempts
‚‚ "
=
‚‚# $
la
‚‚% '
.
‚‚' (
FailedAttempts
‚‚( 6
,
‚‚6 7

LockReason
„„ 
=
„„  
la
„„! #
.
„„# $

LockReason
„„$ .
,
„„. /
LockedUntil
‰‰ 
=
‰‰  !
la
‰‰" $
.
‰‰$ %
LockedUntil
‰‰% 0
,
‰‰0 1
RemainingMinutes
ÂÂ $
=
ÂÂ% &
(
ÂÂ' (
int
ÂÂ( +
)
ÂÂ+ ,
Math
ÂÂ, 0
.
ÂÂ0 1
Ceiling
ÂÂ1 8
(
ÂÂ8 9
(
ÂÂ9 :
la
ÂÂ: <
.
ÂÂ< =
LockedUntil
ÂÂ= H
.
ÂÂH I
Value
ÂÂI N
-
ÂÂO P
DateTime
ÂÂQ Y
.
ÂÂY Z
UtcNow
ÂÂZ `
)
ÂÂ` a
.
ÂÂa b
TotalMinutes
ÂÂb n
)
ÂÂn o
}
ÊÊ 
)
ÊÊ 
.
ÁÁ 
ToListAsync
ÁÁ 
(
ÁÁ 
)
ÁÁ 
;
ÁÁ 
return
ÈÈ 
Ok
ÈÈ 
(
ÈÈ 
suspendedUsers
ÈÈ $
)
ÈÈ$ %
;
ÈÈ% &
}
ÍÍ 	
[
ÏÏ 	
	Authorize
ÏÏ	 
(
ÏÏ 
Roles
ÏÏ 
=
ÏÏ 
$str
ÏÏ '
)
ÏÏ' (
]
ÏÏ( )
[
ÌÌ 	
HttpPost
ÌÌ	 
(
ÌÌ 
$str
ÌÌ (
)
ÌÌ( )
]
ÌÌ) *
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
ÓÓ' (

UnlockUser
ÓÓ) 3
(
ÓÓ3 4
string
ÓÓ4 :
userId
ÓÓ; A
)
ÓÓA B
{
ÔÔ 	
var
 
attempt
 
=
 
await
 
_context
  (
.
( )
LoginAttempts
) 6
.
6 7!
FirstOrDefaultAsync
7 J
(
J K
la
K M
=>
N P
la
Q S
.
S T
UserID
T Z
==
[ ]
userId
^ d
)
d e
;
e f
if
ÒÒ 
(
ÒÒ 
attempt
ÒÒ 
==
ÒÒ 
null
ÒÒ 
)
ÒÒ  
return
ÚÚ 
NotFound
ÚÚ 
(
ÚÚ  
new
ÚÚ  #
{
ÚÚ$ %
message
ÚÚ& -
=
ÚÚ. /
$str
ÚÚ0 @
}
ÚÚA B
)
ÚÚB C
;
ÚÚC D
attempt
ÙÙ 
.
ÙÙ 
FailedAttempts
ÙÙ "
=
ÙÙ# $
$num
ÙÙ% &
;
ÙÙ& '
attempt
ıı 
.
ıı 
LockedUntil
ıı 
=
ıı  !
null
ıı" &
;
ıı& '
attempt
ˆˆ 
.
ˆˆ 

LockReason
ˆˆ 
=
ˆˆ  
null
ˆˆ! %
;
ˆˆ% &
await
˜˜ 
_context
˜˜ 
.
˜˜ 
SaveChangesAsync
˜˜ +
(
˜˜+ ,
)
˜˜, -
;
˜˜- .
return
˘˘ 
Ok
˘˘ 
(
˘˘ 
new
˘˘ 
{
˘˘ 
message
˘˘ #
=
˘˘$ %
$str
˘˘& B
}
˘˘C D
)
˘˘D E
;
˘˘E F
}
˙˙ 	
[
¸¸ 	
	Authorize
¸¸	 
(
¸¸ 
Roles
¸¸ 
=
¸¸ 
$str
¸¸ '
)
¸¸' (
]
¸¸( )
[
˝˝ 	
HttpPost
˝˝	 
(
˝˝ 
$str
˝˝ %
)
˝˝% &
]
˝˝& '
public
˛˛ 
async
˛˛ 
Task
˛˛ 
<
˛˛ 
IActionResult
˛˛ '
>
˛˛' (
CreateSuperAdmin
˛˛) 9
(
˛˛9 :
[
˛˛: ;
FromBody
˛˛; C
]
˛˛C D%
CreateSuperAdminRequest
˛˛E \
request
˛˛] d
)
˛˛d e
{
ˇˇ 	
if
ÄÄ 
(
ÄÄ 
string
ÄÄ 
.
ÄÄ  
IsNullOrWhiteSpace
ÄÄ )
(
ÄÄ) *
request
ÄÄ* 1
.
ÄÄ1 2
Email
ÄÄ2 7
)
ÄÄ7 8
||
ÄÄ9 ;
string
ÄÄ< B
.
ÄÄB C 
IsNullOrWhiteSpace
ÄÄC U
(
ÄÄU V
request
ÄÄV ]
.
ÄÄ] ^
Password
ÄÄ^ f
)
ÄÄf g
)
ÄÄg h
return
ÅÅ 

BadRequest
ÅÅ !
(
ÅÅ! "
new
ÅÅ" %
{
ÅÅ& '
message
ÅÅ( /
=
ÅÅ0 1
$str
ÅÅ2 S
}
ÅÅT U
)
ÅÅU V
;
ÅÅV W
if
ÉÉ 
(
ÉÉ 
request
ÉÉ 
.
ÉÉ 
Password
ÉÉ  
.
ÉÉ  !
Length
ÉÉ! '
<
ÉÉ( )
$num
ÉÉ* +
)
ÉÉ+ ,
return
ÑÑ 

BadRequest
ÑÑ !
(
ÑÑ! "
new
ÑÑ" %
{
ÑÑ& '
message
ÑÑ( /
=
ÑÑ0 1
$str
ÑÑ2 Z
}
ÑÑ[ \
)
ÑÑ\ ]
;
ÑÑ] ^
var
ÜÜ 
existingUser
ÜÜ 
=
ÜÜ 
await
ÜÜ $
_context
ÜÜ% -
.
ÜÜ- .
Users
ÜÜ. 3
.
ÜÜ3 4!
FirstOrDefaultAsync
ÜÜ4 G
(
ÜÜG H
u
ÜÜH I
=>
ÜÜJ L
u
ÜÜM N
.
ÜÜN O
Email
ÜÜO T
==
ÜÜU W
request
ÜÜX _
.
ÜÜ_ `
Email
ÜÜ` e
)
ÜÜe f
;
ÜÜf g
if
áá 
(
áá 
existingUser
áá 
!=
áá 
null
áá  $
)
áá$ %
return
àà 

BadRequest
àà !
(
àà! "
new
àà" %
{
àà& '
message
àà( /
=
àà0 1
$str
àà2 H
}
ààI J
)
ààJ K
;
ààK L
var
ää 
newUser
ää 
=
ää 
new
ää 
ApplicationUser
ää -
{
ãã 
UserName
åå 
=
åå 
request
åå "
.
åå" #
Email
åå# (
,
åå( )
Email
çç 
=
çç 
request
çç 
.
çç  
Email
çç  %
,
çç% &
	FirstName
éé 
=
éé 
request
éé #
.
éé# $
	FirstName
éé$ -
??
éé. 0
string
éé1 7
.
éé7 8
Empty
éé8 =
,
éé= >
LastName
èè 
=
èè 
request
èè "
.
èè" #
LastName
èè# +
??
èè, .
string
èè/ 5
.
èè5 6
Empty
èè6 ;
,
èè; <
Role
êê 
=
êê 
$str
êê #
,
êê# $
EmailConfirmed
ëë 
=
ëë  
true
ëë! %
,
ëë% &
Status
íí 
=
íí 
$str
íí !
}
ìì 
;
ìì 
var
ïï 
userManager
ïï 
=
ïï 
HttpContext
ïï )
.
ïï) *
RequestServices
ïï* 9
.
ïï9 :

GetService
ïï: D
(
ïïD E
typeof
ïïE K
(
ïïK L
	Microsoft
ïïL U
.
ïïU V

AspNetCore
ïïV `
.
ïï` a
Identity
ïïa i
.
ïïi j
UserManager
ïïj u
<
ïïu v
ApplicationUserïïv Ö
>ïïÖ Ü
)ïïÜ á
)ïïá à
asïïâ ã
	Microsoftïïå ï
.ïïï ñ

AspNetCoreïïñ †
.ïï† °
Identityïï° ©
.ïï© ™
UserManagerïï™ µ
<ïïµ ∂
ApplicationUserïï∂ ≈
>ïï≈ ∆
;ïï∆ «
if
ññ 
(
ññ 
userManager
ññ 
==
ññ 
null
ññ #
)
ññ# $
return
ññ% +

BadRequest
ññ, 6
(
ññ6 7
new
ññ7 :
{
ññ; <
message
ññ= D
=
ññE F
$str
ññG c
}
ññd e
)
ññe f
;
ññf g
var
òò 
result
òò 
=
òò 
await
òò 
userManager
òò *
.
òò* +
CreateAsync
òò+ 6
(
òò6 7
newUser
òò7 >
,
òò> ?
request
òò@ G
.
òòG H
Password
òòH P
)
òòP Q
;
òòQ R
if
ôô 
(
ôô 
!
ôô 
result
ôô 
.
ôô 
	Succeeded
ôô !
)
ôô! "
return
öö 

BadRequest
öö !
(
öö! "
new
öö" %
{
öö& '
message
öö( /
=
öö0 1
string
öö2 8
.
öö8 9
Join
öö9 =
(
öö= >
$str
öö> B
,
ööB C
result
ööD J
.
ööJ K
Errors
ööK Q
.
ööQ R
Select
ööR X
(
ööX Y
e
ööY Z
=>
öö[ ]
e
öö^ _
.
öö_ `
Description
öö` k
)
öök l
)
ööl m
}
öön o
)
ööo p
;
ööp q
await
úú 
userManager
úú 
.
úú 
AddToRoleAsync
úú ,
(
úú, -
newUser
úú- 4
,
úú4 5
$str
úú6 B
)
úúB C
;
úúC D
return
ûû 
Ok
ûû 
(
ûû 
new
ûû 
{
ûû 
message
ûû #
=
ûû$ %
$str
ûû& G
,
ûûG H
userId
ûûI O
=
ûûP Q
newUser
ûûR Y
.
ûûY Z
Id
ûûZ \
}
ûû] ^
)
ûû^ _
;
ûû_ `
}
üü 	
}
†† 
public
££ 

class
££ #
UpdateCustomerRequest
££ &
{
§§ 
public
•• 
string
•• 
	FirstName
•• 
{
••  !
get
••" %
;
••% &
set
••' *
;
••* +
}
••, -
=
••. /
string
••0 6
.
••6 7
Empty
••7 <
;
••< =
public
¶¶ 
string
¶¶ 
LastName
¶¶ 
{
¶¶  
get
¶¶! $
;
¶¶$ %
set
¶¶& )
;
¶¶) *
}
¶¶+ ,
=
¶¶- .
string
¶¶/ 5
.
¶¶5 6
Empty
¶¶6 ;
;
¶¶; <
public
ßß 
string
ßß 
Email
ßß 
{
ßß 
get
ßß !
;
ßß! "
set
ßß# &
;
ßß& '
}
ßß( )
=
ßß* +
string
ßß, 2
.
ßß2 3
Empty
ßß3 8
;
ßß8 9
public
®® 
string
®® 
Status
®® 
{
®® 
get
®® "
;
®®" #
set
®®$ '
;
®®' (
}
®®) *
=
®®+ ,
string
®®- 3
.
®®3 4
Empty
®®4 9
;
®®9 :
}
©© 
public
´´ 

class
´´  
CreateStaffRequest
´´ #
{
¨¨ 
public
≠≠ 
string
≠≠ 
Email
≠≠ 
{
≠≠ 
get
≠≠ !
;
≠≠! "
set
≠≠# &
;
≠≠& '
}
≠≠( )
=
≠≠* +
string
≠≠, 2
.
≠≠2 3
Empty
≠≠3 8
;
≠≠8 9
public
ÆÆ 
string
ÆÆ 
	FirstName
ÆÆ 
{
ÆÆ  !
get
ÆÆ" %
;
ÆÆ% &
set
ÆÆ' *
;
ÆÆ* +
}
ÆÆ, -
=
ÆÆ. /
string
ÆÆ0 6
.
ÆÆ6 7
Empty
ÆÆ7 <
;
ÆÆ< =
public
ØØ 
string
ØØ 
LastName
ØØ 
{
ØØ  
get
ØØ! $
;
ØØ$ %
set
ØØ& )
;
ØØ) *
}
ØØ+ ,
=
ØØ- .
string
ØØ/ 5
.
ØØ5 6
Empty
ØØ6 ;
;
ØØ; <
public
∞∞ 
string
∞∞ 
Password
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
±± 
Role
±± 
{
±± 
get
±±  
;
±±  !
set
±±" %
;
±±% &
}
±±' (
=
±±) *
$str
±±+ 2
;
±±2 3
}
≤≤ 
public
¥¥ 

class
¥¥  
UpdateStaffRequest
¥¥ #
{
µµ 
public
∂∂ 
string
∂∂ 
	FirstName
∂∂ 
{
∂∂  !
get
∂∂" %
;
∂∂% &
set
∂∂' *
;
∂∂* +
}
∂∂, -
=
∂∂. /
string
∂∂0 6
.
∂∂6 7
Empty
∂∂7 <
;
∂∂< =
public
∑∑ 
string
∑∑ 
LastName
∑∑ 
{
∑∑  
get
∑∑! $
;
∑∑$ %
set
∑∑& )
;
∑∑) *
}
∑∑+ ,
=
∑∑- .
string
∑∑/ 5
.
∑∑5 6
Empty
∑∑6 ;
;
∑∑; <
public
∏∏ 
string
∏∏ 
Status
∏∏ 
{
∏∏ 
get
∏∏ "
;
∏∏" #
set
∏∏$ '
;
∏∏' (
}
∏∏) *
=
∏∏+ ,
string
∏∏- 3
.
∏∏3 4
Empty
∏∏4 9
;
∏∏9 :
public
ππ 
string
ππ 
Role
ππ 
{
ππ 
get
ππ  
;
ππ  !
set
ππ" %
;
ππ% &
}
ππ' (
=
ππ) *
string
ππ+ 1
.
ππ1 2
Empty
ππ2 7
;
ππ7 8
public
∫∫ 
string
∫∫ 
?
∫∫ 
Password
∫∫ 
{
∫∫  !
get
∫∫" %
;
∫∫% &
set
∫∫' *
;
∫∫* +
}
∫∫, -
}
ªª 
public
ΩΩ 

class
ΩΩ 
UpdatePlanRequest
ΩΩ "
{
ææ 
public
øø 
string
øø 
PlanName
øø 
{
øø  
get
øø! $
;
øø$ %
set
øø& )
;
øø) *
}
øø+ ,
=
øø- .
string
øø/ 5
.
øø5 6
Empty
øø6 ;
;
øø; <
public
¿¿ 
decimal
¿¿ 
?
¿¿ 
	SpeedMbps
¿¿ !
{
¿¿" #
get
¿¿$ '
;
¿¿' (
set
¿¿) ,
;
¿¿, -
}
¿¿. /
public
¡¡ 
decimal
¡¡ 
?
¡¡ 
Price
¡¡ 
{
¡¡ 
get
¡¡  #
;
¡¡# $
set
¡¡% (
;
¡¡( )
}
¡¡* +
}
¬¬ 
public
ƒƒ 

class
ƒƒ !
UpdateTicketRequest
ƒƒ $
{
≈≈ 
public
∆∆ 
string
∆∆ 
Status
∆∆ 
{
∆∆ 
get
∆∆ "
;
∆∆" #
set
∆∆$ '
;
∆∆' (
}
∆∆) *
=
∆∆+ ,
string
∆∆- 3
.
∆∆3 4
Empty
∆∆4 9
;
∆∆9 :
public
«« 
string
«« 
?
«« 
AssignedStaffID
«« &
{
««' (
get
««) ,
;
««, -
set
««. 1
;
««1 2
}
««3 4
}
»» 
public
   

class
    
ReplyTicketRequest
   #
{
ÀÀ 
public
ÃÃ 
string
ÃÃ 
Message
ÃÃ 
{
ÃÃ 
get
ÃÃ  #
;
ÃÃ# $
set
ÃÃ% (
;
ÃÃ( )
}
ÃÃ* +
=
ÃÃ, -
string
ÃÃ. 4
.
ÃÃ4 5
Empty
ÃÃ5 :
;
ÃÃ: ;
}
ÕÕ 
public
œœ 

class
œœ '
UpdateSubscriptionRequest
œœ *
{
–– 
public
—— 
string
—— 
Status
—— 
{
—— 
get
—— "
;
——" #
set
——$ '
;
——' (
}
——) *
=
——+ ,
string
——- 3
.
——3 4
Empty
——4 9
;
——9 :
public
““ 
int
““ 
?
““ 
PlanID
““ 
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
““' (
public
”” 
string
”” 
?
”” 
EndDate
”” 
{
””  
get
””! $
;
””$ %
set
””& )
;
””) *
}
””+ ,
}
‘‘ 
public
÷÷ 

class
÷÷ 
CreateFAQRequest
÷÷ !
{
◊◊ 
public
ÿÿ 
string
ÿÿ 
Question
ÿÿ 
{
ÿÿ  
get
ÿÿ! $
;
ÿÿ$ %
set
ÿÿ& )
;
ÿÿ) *
}
ÿÿ+ ,
=
ÿÿ- .
string
ÿÿ/ 5
.
ÿÿ5 6
Empty
ÿÿ6 ;
;
ÿÿ; <
public
ŸŸ 
string
ŸŸ 
Answer
ŸŸ 
{
ŸŸ 
get
ŸŸ "
;
ŸŸ" #
set
ŸŸ$ '
;
ŸŸ' (
}
ŸŸ) *
=
ŸŸ+ ,
string
ŸŸ- 3
.
ŸŸ3 4
Empty
ŸŸ4 9
;
ŸŸ9 :
public
⁄⁄ 
string
⁄⁄ 
Category
⁄⁄ 
{
⁄⁄  
get
⁄⁄! $
;
⁄⁄$ %
set
⁄⁄& )
;
⁄⁄) *
}
⁄⁄+ ,
=
⁄⁄- .
string
⁄⁄/ 5
.
⁄⁄5 6
Empty
⁄⁄6 ;
;
⁄⁄; <
public
€€ 
string
€€ 
Status
€€ 
{
€€ 
get
€€ "
;
€€" #
set
€€$ '
;
€€' (
}
€€) *
=
€€+ ,
$str
€€- 4
;
€€4 5
}
‹‹ 
public
ﬁﬁ 

class
ﬁﬁ 
UpdateFAQRequest
ﬁﬁ !
{
ﬂﬂ 
public
‡‡ 
string
‡‡ 
Question
‡‡ 
{
‡‡  
get
‡‡! $
;
‡‡$ %
set
‡‡& )
;
‡‡) *
}
‡‡+ ,
=
‡‡- .
string
‡‡/ 5
.
‡‡5 6
Empty
‡‡6 ;
;
‡‡; <
public
·· 
string
·· 
Answer
·· 
{
·· 
get
·· "
;
··" #
set
··$ '
;
··' (
}
··) *
=
··+ ,
string
··- 3
.
··3 4
Empty
··4 9
;
··9 :
public
‚‚ 
string
‚‚ 
Category
‚‚ 
{
‚‚  
get
‚‚! $
;
‚‚$ %
set
‚‚& )
;
‚‚) *
}
‚‚+ ,
=
‚‚- .
string
‚‚/ 5
.
‚‚5 6
Empty
‚‚6 ;
;
‚‚; <
public
„„ 
string
„„ 
Status
„„ 
{
„„ 
get
„„ "
;
„„" #
set
„„$ '
;
„„' (
}
„„) *
=
„„+ ,
string
„„- 3
.
„„3 4
Empty
„„4 9
;
„„9 :
}
‰‰ 
public
ÊÊ 

class
ÊÊ 
AdminTopUpRequest
ÊÊ "
{
ÁÁ 
public
ËË 
decimal
ËË 
Amount
ËË 
{
ËË 
get
ËË  #
;
ËË# $
set
ËË% (
;
ËË( )
}
ËË* +
}
ÈÈ 
public
ÎÎ 

class
ÎÎ (
UpdatePrepaidStatusRequest
ÎÎ +
{
ÏÏ 
public
ÌÌ 
string
ÌÌ 
Status
ÌÌ 
{
ÌÌ 
get
ÌÌ "
;
ÌÌ" #
set
ÌÌ$ '
;
ÌÌ' (
}
ÌÌ) *
=
ÌÌ+ ,
string
ÌÌ- 3
.
ÌÌ3 4
Empty
ÌÌ4 9
;
ÌÌ9 :
}
ÓÓ 
public
 

class
 &
UpdatePromoStatusRequest
 )
{
ÒÒ 
public
ÚÚ 
string
ÚÚ 
Status
ÚÚ 
{
ÚÚ 
get
ÚÚ "
;
ÚÚ" #
set
ÚÚ$ '
;
ÚÚ' (
}
ÚÚ) *
=
ÚÚ+ ,
string
ÚÚ- 3
.
ÚÚ3 4
Empty
ÚÚ4 9
;
ÚÚ9 :
}
ÛÛ 
public
ıı 

class
ıı %
CreatePromoOfferRequest
ıı (
{
ˆˆ 
public
˜˜ 
string
˜˜ 
Title
˜˜ 
{
˜˜ 
get
˜˜ !
;
˜˜! "
set
˜˜# &
;
˜˜& '
}
˜˜( )
=
˜˜* +
string
˜˜, 2
.
˜˜2 3
Empty
˜˜3 8
;
˜˜8 9
public
¯¯ 
string
¯¯ 
Description
¯¯ !
{
¯¯" #
get
¯¯$ '
;
¯¯' (
set
¯¯) ,
;
¯¯, -
}
¯¯. /
=
¯¯0 1
string
¯¯2 8
.
¯¯8 9
Empty
¯¯9 >
;
¯¯> ?
public
˘˘ 
decimal
˘˘ 
Price
˘˘ 
{
˘˘ 
get
˘˘ "
;
˘˘" #
set
˘˘$ '
;
˘˘' (
}
˘˘) *
public
˙˙ 
string
˙˙ 
Data
˙˙ 
{
˙˙ 
get
˙˙  
;
˙˙  !
set
˙˙" %
;
˙˙% &
}
˙˙' (
=
˙˙) *
string
˙˙+ 1
.
˙˙1 2
Empty
˙˙2 7
;
˙˙7 8
public
˚˚ 
string
˚˚ 
Validity
˚˚ 
{
˚˚  
get
˚˚! $
;
˚˚$ %
set
˚˚& )
;
˚˚) *
}
˚˚+ ,
=
˚˚- .
string
˚˚/ 5
.
˚˚5 6
Empty
˚˚6 ;
;
˚˚; <
public
¸¸ 
string
¸¸ 
?
¸¸ 
Badge
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
˝˝ 
?
˝˝ 
Color
˝˝ 
{
˝˝ 
get
˝˝ "
;
˝˝" #
set
˝˝$ '
;
˝˝' (
}
˝˝) *
}
˛˛ 
public
ÄÄ 

class
ÄÄ &
CreateActivityLogRequest
ÄÄ )
{
ÅÅ 
public
ÇÇ 
string
ÇÇ 
Action
ÇÇ 
{
ÇÇ 
get
ÇÇ "
;
ÇÇ" #
set
ÇÇ$ '
;
ÇÇ' (
}
ÇÇ) *
=
ÇÇ+ ,
string
ÇÇ- 3
.
ÇÇ3 4
Empty
ÇÇ4 9
;
ÇÇ9 :
public
ÉÉ 
string
ÉÉ 
Description
ÉÉ !
{
ÉÉ" #
get
ÉÉ$ '
;
ÉÉ' (
set
ÉÉ) ,
;
ÉÉ, -
}
ÉÉ. /
=
ÉÉ0 1
string
ÉÉ2 8
.
ÉÉ8 9
Empty
ÉÉ9 >
;
ÉÉ> ?
public
ÑÑ 
string
ÑÑ 
Type
ÑÑ 
{
ÑÑ 
get
ÑÑ  
;
ÑÑ  !
set
ÑÑ" %
;
ÑÑ% &
}
ÑÑ' (
=
ÑÑ) *
string
ÑÑ+ 1
.
ÑÑ1 2
Empty
ÑÑ2 7
;
ÑÑ7 8
}
ÖÖ 
public
áá 

class
áá %
UpdatePromoOfferRequest
áá (
{
àà 
public
ââ 
string
ââ 
Title
ââ 
{
ââ 
get
ââ !
;
ââ! "
set
ââ# &
;
ââ& '
}
ââ( )
=
ââ* +
string
ââ, 2
.
ââ2 3
Empty
ââ3 8
;
ââ8 9
public
ää 
string
ää 
Description
ää !
{
ää" #
get
ää$ '
;
ää' (
set
ää) ,
;
ää, -
}
ää. /
=
ää0 1
string
ää2 8
.
ää8 9
Empty
ää9 >
;
ää> ?
public
ãã 
decimal
ãã 
Price
ãã 
{
ãã 
get
ãã "
;
ãã" #
set
ãã$ '
;
ãã' (
}
ãã) *
public
åå 
string
åå 
Data
åå 
{
åå 
get
åå  
;
åå  !
set
åå" %
;
åå% &
}
åå' (
=
åå) *
string
åå+ 1
.
åå1 2
Empty
åå2 7
;
åå7 8
public
çç 
string
çç 
Validity
çç 
{
çç  
get
çç! $
;
çç$ %
set
çç& )
;
çç) *
}
çç+ ,
=
çç- .
string
çç/ 5
.
çç5 6
Empty
çç6 ;
;
çç; <
public
éé 
string
éé 
?
éé 
Badge
éé 
{
éé 
get
éé "
;
éé" #
set
éé$ '
;
éé' (
}
éé) *
public
èè 
string
èè 
?
èè 
Color
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
êê 
bool
êê 
IsActive
êê 
{
êê 
get
êê "
;
êê" #
set
êê$ '
;
êê' (
}
êê) *
=
êê+ ,
true
êê- 1
;
êê1 2
}
ëë 
public
ìì 

class
ìì 
UpdateRoleRequest
ìì "
{
îî 
public
ïï 
string
ïï 
[
ïï 
]
ïï 
?
ïï 
Permissions
ïï $
{
ïï% &
get
ïï' *
;
ïï* +
set
ïï, /
;
ïï/ 0
}
ïï1 2
}
ññ 
public
òò 

class
òò '
CreateNotificationRequest
òò *
{
ôô 
public
öö 
string
öö 
Message
öö 
{
öö 
get
öö  #
;
öö# $
set
öö% (
;
öö( )
}
öö* +
=
öö, -
string
öö. 4
.
öö4 5
Empty
öö5 :
;
öö: ;
public
õõ 
string
õõ 
?
õõ 
Type
õõ 
{
õõ 
get
õõ !
;
õõ! "
set
õõ# &
;
õõ& '
}
õõ( )
=
õõ* +
$str
õõ, 2
;
õõ2 3
}
úú 
public
ûû 

class
ûû )
UpdateSystemSettingsRequest
ûû ,
{
üü 
public
†† 
string
†† 
?
†† 
SiteName
†† 
{
††  !
get
††" %
;
††% &
set
††' *
;
††* +
}
††, -
public
°° 
string
°° 
?
°° 
	SiteEmail
°°  
{
°°! "
get
°°# &
;
°°& '
set
°°( +
;
°°+ ,
}
°°- .
public
¢¢ 
bool
¢¢ 
?
¢¢ 
MaintenanceMode
¢¢ $
{
¢¢% &
get
¢¢' *
;
¢¢* +
set
¢¢, /
;
¢¢/ 0
}
¢¢1 2
public
££ 
int
££ 
?
££ 
MaxLoginAttempts
££ $
{
££% &
get
££' *
;
££* +
set
££, /
;
££/ 0
}
££1 2
public
§§ 
int
§§ 
?
§§ 
SessionTimeout
§§ "
{
§§# $
get
§§% (
;
§§( )
set
§§* -
;
§§- .
}
§§/ 0
public
•• 
bool
•• 
?
•• 
EnableTwoFactor
•• $
{
••% &
get
••' *
;
••* +
set
••, /
;
••/ 0
}
••1 2
public
¶¶ 
bool
¶¶ 
?
¶¶ 
EnableAuditLogs
¶¶ $
{
¶¶% &
get
¶¶' *
;
¶¶* +
set
¶¶, /
;
¶¶/ 0
}
¶¶1 2
public
ßß 
string
ßß 
?
ßß 
NotificationEmail
ßß (
{
ßß) *
get
ßß+ .
;
ßß. /
set
ßß0 3
;
ßß3 4
}
ßß5 6
public
®® 
bool
®® 
?
®® 
EmailOnNewTickets
®® &
{
®®' (
get
®®) ,
;
®®, -
set
®®. 1
;
®®1 2
}
®®3 4
public
©© 
bool
©© 
?
©© $
EmailOnPaymentReceived
©© +
{
©©, -
get
©©. 1
;
©©1 2
set
©©3 6
;
©©6 7
}
©©8 9
public
™™ 
bool
™™ 
?
™™ !
EmailOnSystemErrors
™™ (
{
™™) *
get
™™+ .
;
™™. /
set
™™0 3
;
™™3 4
}
™™5 6
public
´´ 
bool
´´ 
?
´´ #
EmailOnSecurityAlerts
´´ *
{
´´+ ,
get
´´- 0
;
´´0 1
set
´´2 5
;
´´5 6
}
´´7 8
}
¨¨ 
public
ÆÆ 

class
ÆÆ %
CreateSuperAdminRequest
ÆÆ (
{
ØØ 
public
∞∞ 
string
∞∞ 
Email
∞∞ 
{
∞∞ 
get
∞∞ !
;
∞∞! "
set
∞∞# &
;
∞∞& '
}
∞∞( )
=
∞∞* +
string
∞∞, 2
.
∞∞2 3
Empty
∞∞3 8
;
∞∞8 9
public
±± 
string
±± 
	FirstName
±± 
{
±±  !
get
±±" %
;
±±% &
set
±±' *
;
±±* +
}
±±, -
=
±±. /
string
±±0 6
.
±±6 7
Empty
±±7 <
;
±±< =
public
≤≤ 
string
≤≤ 
LastName
≤≤ 
{
≤≤  
get
≤≤! $
;
≤≤$ %
set
≤≤& )
;
≤≤) *
}
≤≤+ ,
=
≤≤- .
string
≤≤/ 5
.
≤≤5 6
Empty
≤≤6 ;
;
≤≤; <
public
≥≥ 
string
≥≥ 
Password
≥≥ 
{
≥≥  
get
≥≥! $
;
≥≥$ %
set
≥≥& )
;
≥≥) *
}
≥≥+ ,
=
≥≥- .
string
≥≥/ 5
.
≥≥5 6
Empty
≥≥6 ;
;
≥≥; <
}
¥¥ 
}µµ í(
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