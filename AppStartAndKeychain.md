## UUID(Universally Unique IDentifier)  
- 범용 고유 식별자  
- 기기 고유번호로 사용  


## User-Agent  
- 어떤 디바이스, OS, 버전이 서버(웹페이지)에  접근하는지 알기 위해 사용
-  ```Mozilla/5.0 (iPhone; CPU iPhone OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C75```  
&nbsp; => iPhone, 9.2 버전에서 접근했다는 것을 알 수 있음
- navigator.userAgent ( 브라우저의 정류와 버전 등 웹브라우저 전반에 대한 정보를 제공하는 객체)  
	+ navigator.appName: 브라우저의 간단한 이름
	+ navigator.appVersion: 버전 또는 버전과 관련된 정보
	+ navigator.userAgent: 브라우저가 User-Agent HTTP 헤더에 넣어 전송하는 문자열. appName과 appVersion의 모든 정보를 포함해야함.
	+ navigator.platForm: 브라우저가 실행되는 하드웨어 플랫폼


## keychain  
- 앱은 자기 자신의 키체인만 접근 가능 (OS X에서는 Master PW로 접근 가능)
- 앱, 서버, 웹 사이트 등의 계정 이름과 암호를 저장하는 데 사용되는 암호화된 저장소
- 사용자가 앱을 사용할 때 FTP 서버, APP Share 서버, DB 서버 등을 사용하게 되는데 이를 사용하기 위해선 사용자 인증 과정이 필요하다. 앱 사용 때마다 인증 과정을 거치는데, 이런 수고를 덜어줌
- 키체인은 provisioning profile로 사용경로를 구분함
- 앱을 삭제해도 단말기를 초기화하지 않는 이상 키체인 안에 저장한 데이터는 지워지지 않음
- 보안이 필요한 데이터(Password, Private Key 등)은 암호화되어 저장되고, 보안이 필요하지 않은 데이터(Certificate 등)은 암호화하지 않고 저장
- 민감한 정보를 저장할 때 해당 데이터를 keychain item으로 패키징함. 패키징된 item 안에는 저장하려는 데이터 뿐만 아니라 해당 데이터의 속성(attributes) 또한 같이 저장된다. 이 속성을 통해 접근 가능성을 제어하고 해당 item이 검색에 노출되도록 공개적으로 보여주는 속성. 추후 같은 그룹이거나 해당 데이터를 저장한 앱이라면 item에 접근할 때 속성 검색을 통해 해당 데이터를 찾고 접근할 수 있음.
- 서로 다른 앱끼리 Keychain item을 공유해하는 경우에는 Keychain Groups를 사용해 keychain item을 공유할 수 있음
- projectFile > Signing & Capabilities > KeyChain Sharing