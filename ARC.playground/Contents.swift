import Foundation

/*
 Garbage Collection
 - Swift에는 Garbage Collection x
 - GB 부작용 두 가지: GC가 코드 상에서 언제 실행 될 지 모른다 / 퍼포먼스를 제법 까먹는다

 Reference Count 메모리 관리 방식
 - Retain 과 Release 의 개념 이용
 - 코드에서 메모리를 참조 하려 할 때 RC를 증가(retain)시키고 참조가 끝나면 RC를 감소(release) 시키는 방식
 - RC가 0이 되면 메모리가 해제(free)된다
 - 컴파일러에서 retain 과 release 코드를 자동으로 추가해서 메모리 관리 자동화 가능
 - Ex
     void SomeFunction() {
         SomeClass *obj = [[SomeClass alloc] init];
         [obj retain]; // ARC

         anotherFunction(obj);

         [obj release]; // ARC
     }

     void anotherFunction(SomeClass *obj) {
         [obj retain]; // ARC
              . . . .
         [obj release]; // ARC
     }
 - ARC 처리 방법 3개: strong, weak, unowned
     - Strong: 값 지정 시점에 retain, 참조 종료 시점에 release. 기본 설정. 특정 클래스가 소유하고 관리하는 프로퍼티는 strong이 적당
     - weak: 자신이 참조는 하지만 weak 메모리를 해제시킬 수 있는 권한은 다른 클래스에 있음. 따라서 값 지정 시 retain 발생 x -> release 발생 x -> 언제 어떻게 메모리가 해제될 지 알 수 x. 단, 메모리가 해제될 경우 자동으로 레퍼런스가 nil로 초기화해줌. nil이 될 수 있기 때문에 반드시 optional 타입이여야함.
     - Unowned: weak와 비슷하지만 메모리가 해제되어도 레퍼런스 초기화 x. Non-optionals 타입으로 사용하기 좋음.
 */
