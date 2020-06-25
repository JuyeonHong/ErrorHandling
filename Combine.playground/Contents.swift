import Foundation
import Combine

/*
 ref: https://medium.com/harrythegreat/swift-combine-%EC%9E%85%EB%AC%B8%EA%B0%80%EC%9D%B4%EB%93%9C2-publisher-subscribe-operator-723ed5d17e70
 https://zeddios.tistory.com/965?category=842493
 https://www.vadimbulavin.com/understanding-schedulers-in-swift-combine-framework/
 */

/*
 - Publisher
 - 타입이 시간에 따라 일련의 값을 전송할 수 있음을 선언
 - 하나 이상의 Subscriber 인스턴스에게 element를 제공
 - receive(subscriber:) 메소드를 구현해 subscriber를 accept함
 
 protocol Publisher {
     associatedtype Output
     associatedtype Failure: Error

     func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
 }

 - Subscriber
 - Publisher로부터 input을 받을 수 있는 타입을 선언하는 프로토콜
 
 public protocol Subscriber: CustomCombineIdentifierConvertible {
     associatedtype Input // Publisher의 Output 타입과 동일
     associatedtype Failure: Error

    func receive(subscription: Subscription)
    // 구독 요청을 승인하고 Subscription instance를 반환함
    // subscriber는 구독을 이용해 publisher에게 데이터를 요청하고 구독을 취소할 수 있음
 
     func receive(_ input: Self.Input) -> Subscribers.Demand
     func receive(completion: Subscribers.Completion<Self.Failure>)
 }
 */

class CustomSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("모든 데이터의 발행이 완료되었습니다.")
    }
    
    func receive(subscription: Subscription) {
        print("데이터의 구독을 시작합니다.")
        // 구독할 데이터의 개수를 제한하지 않습니다.
        subscription.request(.unlimited)
        
        // 최대 구독 개수 2개
        // publisher에서 제공하는 데이터가 10개이기 때문에 completion은 호출되지 않음
        // subscription.request(.max(2))
    }
    
    // 데이터 구독 이후에 데이터 스트림을 변경할 때 사용
    func receive(_ input: String) -> Subscribers.Demand {
        print("데이터를 받았습니다", input)
        // none으로 리턴하면 현재 데이터 스트림을 유지
        return .none
        
        // 10개의 데이터를 모두 구독
        // return .unlimited
    }
}

let publisher = ["A","B","C","D","E","F","G"].publisher

let subscriber = CustomSubscriber()

publisher.subscribe(subscriber)

let fomatter = NumberFormatter()
fomatter.numberStyle = .ordinal

(1...10).publisher.map {
    fomatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
}.sink {
    print($0)
}

// ====================================================================
/*
Cancellable: 데이터 발행 중 cancel() 메서드가 호출되었을 때 모든 파이프라인이 멈추고 끝나게 됨.
             사용자가 데이터 로딩을 기다리던 도중 뒤로가거나 취소를 눌렀을 때 처럼 스트림을 중단해야할 때 사용될 수 있음.
*/

let externalProvider = PassthroughSubject<String, Never>()

let anyCancellable = externalProvider.sink { stream in
    print("전달받은 데이터: ", stream)
}

externalProvider.send("Hello")
externalProvider.send("Hi")
anyCancellable.cancel()
// cancel() 메서드가 호출된 이후에 더 이상 데이터가 발행되지 않습니다.
externalProvider.send("annyeong")

// ======= Combine으로 네트워크 요청하기 =======
enum HTTPError: LocalizedError {
    case statusCode
    case post
}

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

let cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())
    .replaceError(with: []) // 에러가 발생할 경우 에러를 전달하지 않습니다.
    .eraseToAnyPublisher() // 지금까지의 데이터 스트림이 어떠했던 최종적인 형태의 Publisher를 리턴합니다.
    .sink(receiveValue: { posts in
//        print("전달받은 데이터는 총 \(posts.count)개 입니다.")
    })

let cancellable2 = URLSession.shared.dataTaskPublisher(for: url)
    .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                return Data()
        }
        return data
}

// ============================================================================================

/* Combine
- 시간에 따라 값을 처리하기 위한 선언적(declarative) Swift API
- 많은 종류의 비동기 이벤트를 나타낼 수 있음
- publishers가 시간이 지남에 따라 변경될 수 있는 값을 expose하고
   subscribers가 publisher로 부터 해당 값을 받도록 선언
- 장점: 이벤트 처리 코드를 중앙 집중화하고, 중첩된 closure 및 콜백을 제거해 코드 유지보수를 쉽게 함
*/

/* Publisher의 값을 subscribe하는 방법
 - publisher의 subscribe(:) 메소드 사용
 - sink 메소드 사용
 - assign(to:on:) 메소드 사용
 */

/*
 + Just
 - 각 subscriber에게 output을 한 번만(just once) 출력한 다음 완료하는 publisher.
 - Publisher 프로토콜을 채택한 struct
 
 + sink
 - subscriber를 만들어주는 메소드
 */
let publisherr = Just(5)
let subscriberr = publisherr.sink {
    print($0)
    print("===================")
}

// 10개의 데이터를 공급할 publisher
// sink(Subscriber)가 연결되기 전까지는 데이터를 발행하지 않음
let provider = (1...10).publisher
provider.sink(receiveCompletion: { _ in
    // 데이터가 발행될 때마다 receiveValue가 호출되고 데이터 스트림이 끝나면 receiveCompletion이 호출됨
    print("데이터 전달이 끝났습니다.")
    print("===================")
}, receiveValue: { data in
    print(data)
})

class MySubscriber: Subscriber {
    typealias Input = String
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
//        print("구독을 시작합니다.")
        subscription.request(.unlimited)
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
//        print("publisher가 subscriber에게 \(input) 생성을 알립니다.")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
//        print("구독을 종료합니다.")
    }
}

let myPublisher = ["juyeon", "Terror Jr", "Alan Walker", "Martin Garrix", "Don Diablo"].publisher
let mySubscriber = MySubscriber()
myPublisher.print().subscribe(mySubscriber)

// ============================================================================================

/* PassthroughSubject
 - downstream subscribers에게 element를 broadcast하는 subject
 - CurrentValueSubject와 달리, 가장 최근에 publish된 element의 초기값 또는 버퍼가 없음
 - 상태값을 가지지 않는 subject
 - subscribers가 없거나 현재 demand가 0이면 value를 삭제함
 - send(:) 메소드를 통해 값을 스트림에 주입할 수 있는 Publisher
 */

let passThroughSubject = PassthroughSubject<String, Error>()
let passSubscriber = passThroughSubject.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        print("데이터 전달이 끝났습니다.")
    case .failure:
        print("데이터 전달이 실패했습니다.")
    }
}, receiveValue: {
    print($0)
})
passThroughSubject.send("hello")
passThroughSubject.send("Hi Hi")
passThroughSubject.send(completion: .finished)
passThroughSubject.send("value is not printed")

/* CurrentValueSubject
- 상태값을 가지는 subject
- 주로 UI의 상태 값에 따라 데이터를 발행할 때 사용하기 유용함
*/
let currentStatus = CurrentValueSubject<Bool, Error>(true)

// sink와 동시에 초기값이 발행됩니다.
currentStatus.sink(receiveCompletion: { completion in
    switch completion {
    case .failure:
        print("error가 발생하였습니다.")
    case .finished:
        print("데이터의 발행이 끝났습니다.")
        print("===================")
    }
}, receiveValue: { value in
    print("CurrentValueSubject Test - ", value)
})

print("초기값은 \(currentStatus.value) 입니다.")
currentStatus.send(false)
currentStatus.send(true)

// ============================================================================================

/* Scheduler
 - closure의 실행 시기와 방법(current run loop, dispatchQueue or operation queue)을 정의하는 프로토콜
 - scheduler를 이용해서 코드를 가능한 빨리 실행시킬 수 있고, 나중에 실행시킬 수 있음.
 - scheduler를 지정하지 않더라도 Combine은 기본 scheduler를 제공함
 - scheduler는 element가 생성된 스레드와 동일한 스레드를 사용함.
 */

let schedulerTest = PassthroughSubject<Int, Never>()
let token = schedulerTest.sink(receiveValue: { value in
//    print("SchedulerTest - isMainThread: ", Thread.isMainThread) // true
})

schedulerTest.send(1) // 메인 스레드에서 왔기 때문에 SchedulerTest - isMainThread:  true

DispatchQueue.global().async {
    schedulerTest.send(4) // 백그라운드 스레드에서 왔기 때문에 SchedulerTest - isMainThread:  false
}

/* Scheduler Switching
         upstream           downstream
 source <--------- operator ---------> consuner/further operats
 
 
 - Combine에서 제공하는 Scheduler Type: DispatchQueue, OperationQueue, RunLoop, ImmediateScheduler
 
 + receive(on:)
 - publisher로부터 element를 수신할 scheduler를 지정
 - downstream의 실행 컨텍스트를 변경하는 역할
 
 + subscribe(on:)
 - upstream에 영향
 */

Just(1)
    .map { _ in print("receive(:on) Test - ", Thread.isMainThread) } // true
    .receive(on: DispatchQueue.global())
    .map { print("receive(:on) Test - ", Thread.isMainThread) } // false
    .sink { print("receive(:on) Test - ", Thread.isMainThread) } // false

Just(1)
    .subscribe(on: DispatchQueue.global())
    .map{ _ in print(Thread.isMainThread)}
    .sink{ print(Thread.isMainThread) }
