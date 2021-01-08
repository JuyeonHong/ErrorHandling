## 컴파일러 구조와 LVVM
프론트엔드 - 미들엔드 - 백엔드
3단계는 하나의 프로그램으로 일괄 처리 -> (언어 종류 * 아키텍터 종류)만큼  복수의 컴파일러 필요
-> 다양한 언어 * 다양한 아키텍처에 대응이 가능한 구조가  LLVM
-> LLVM을 사용 시, Clang으로 컴파일만 하면 모든 아키텍처에 대한 빌드가 가능해진다는 장점

프론트엔드: 여러 프로그래밍 언어를 중간 표현 코드로 번역
LLVM: 프론트엔드가 번역한 중간 표현 코드를 각각의 아키텍처에 맞게 최적화해서 실행 가능한 형태로 바꿈
원래는 GCC를 프론트엔드로하고 LLVM울 미들엔드-백엔드로 사용했었는데, LLVM의 자체 프론트엔드 Clang 등장 이후로 전 컴파일 과정을 LLVM 툴체인으로 진행
LLVM Core: 미들엔드와 백엔드를 담당하는 라이브러리
프론트엔드: 사람이 작성한 소스 코드를 LLVM Core가 인식할 수 있는 중간코드(LLVM IR - Intermediate Representation)로 컴파일
LLVM IR: LLVM Bitcode, LLVM Assembly, C++ Object Code)로 분리
LLVM Assembly는 사람이 비교적 읽기 쉬움 but LLVM bitcode는 메모리 주소값의 주소 나열로 구성되고 최적화가 이루어진 형태의 코드
LLVM Assembly와 bitcode는 미들엔드에서 최적화가 한 번 더 진행된 후 백엔드에서 실제 기계어로 바뀌어 실행


## Clang(클랭)
libclang과 그 프론트엔드로 구성된 C, C++, Objective-C용 컴파일러
소스코드를 LLVM-IR로 컴파일 하는 역할
빌드 자동화 스크립트는 GCC와 동일하게 makefile 사용

## Apple Clang
기존의 Objc 컴파일러는 GCC 사용. But 확장이 힘들고 메모리 관리 문제 -> Apple Clang 개발

## Swift-Clang
swift에 대응하는 프론트엔드 컴파일러
애플이 기존의 LLVM을 포크해서 만든 Swift-LLVM과 결합되어 돌아감
기본 구조는 Clang과 유사하지만 Swift 소스와 LLVM-IR 사이에 SIL(Swift Intermediate Language)라는 중간 코드가 하나 더 있음 (Swift -> Swift AST -> SIL -> LLVM IR)
즉, 프론트엔드에서 Swift 코느는 SIL로 컴파일되고 LLVM-IR로 컴파일해서 총 2번 최적화 작업이 이루어짐


## 출처
https://namu.wiki/w/LLVM
https://jacking.tistory.com/1339
