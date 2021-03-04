# URL Schemes
- 각 앱은 url scheme을 **info.plist**에 담아두고, 설치 시점에 **info.plist**에 있는 url scheme가 운영체제에 등록된다
- 앱이 미실행 상태일 경우  
	1. 사용자 인터페이스 로드
	2. 앱 초기화(application:didFinishLaunchingWithOptions:launchOptions; True 리턴)
	3. URL 열기(application:penURL:sourceApplication:annotation:)
	4. 앱 활성화 (applicationWillEnterForeground)
- 앱이 비활성 상태인 경우  
	1. 앱이 깨어나게 함(applicationDidBecomeActive:)
	2. URL 열기(application:penURL:sourceApplication:annotation:)
	4. 앱 활성화 (applicationWillEnterForeground)

## 다른 앱 실행시키기
- 다른 앱의 존재여부 감지하려면 해당 앱에서 제공하는 custom url scheme을 알고 있어야 함. 스키마 이름을 알면 **openURL** 메서드를 사용해서 쉽게 구현할 수 있다. 해당 반환값이 true이면 설치되어 있는 것임. 

## 앱 URL Scheme 등록 방법
1. target>Info>URL Types 추가
2. identifier, URL Schemes 입력
3. 다른 앱과의 스키마 중복 방지를 위해, bundle identifier같은 것을 지정해두면 좋음 (com.hongjuyeon.myapp)  
4. info.plist>LSApplicationQueriesScehems 키 추가, 하위 항목에 url scheme 입력

## 정보 얻기  
-  **openURL**이 실행되면 **didFinishLaunchingWithOptions**와 **openURL** 메서드를 처리함. 호출되는 앱의 실행 상태에 따라 호출 함수가 다르다.
- 앱이 실행중인 경우: **openURL**만 호출
- 앱이 실행되지 않은 경우, **didFinishLaunchingWithOptions**와 **openURL** 호출  

## Built-in URL Scheme  
- **https://** URL : 사파리 앱을 통한 웹사이트 표시
- **mailto** 이메일 주소 : 메일 앱을 통해 새로운 메일 작성 화면 표시 
- **tel** 전화번호 : 전화 연결
- **sms** 전화번호 : 메시지 앱을 통한 메시지 작성 화면 표시
- **facetime** FaceTime ID : 페이스타임 연결
- **http://maps.apple.com/?q=** 검색어 : 지도 앱을 통한 지역표시
- **http://maps.apple.com/?ll=** 위도, 경도 : 지도 앱을 통한 지역표시

- 웹사이트, 지도 이외의 url scheme은 시뮬레이터에서 지원하지 않으므로 디바이스에서 확인해야함.

## Custom URL Scheme  
- 앱에서 직접 URL Scheme을 처리하기 위해서 필요.
- **프로토콜://Scheme Host/Scheme Path?Query String** 보통 이런 구조로 정의
	* Scheme Host, Scheme Path: 앱 내에서 데이터가 전달할 위치를 지정하는데 주로 사용
	* Query String : key=value&key2=value2&key3=value3 같은 형식
- Swift에서 제공하는 URL의 host, path, query를 이용하면 URL Scheme의 특정 요소 추출 가능.

## 출처
- http://blog.naver.com/horajjan/220740354692
- http://blog.naver.com/PostView.nhn?blogId=horajjan&logNo=220893876471
