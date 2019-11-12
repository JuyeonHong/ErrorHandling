import Foundation

enum RideCategory: String, CustomStringConvertible {
    case family
    case kids
    case thrill
    case scary
    case relaxing
    case water
    
    var description: String {
        return rawValue
    }
}

typealias Minutes = Double

struct Ride: CustomStringConvertible {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes
    
    var description: String {
        return "Ride –\"\(name)\", wait: \(waitTime) mins, " +
        "categories: \(categories)\n"
    }
    
    func sortNamesImp(of rides: [Ride]) -> [String] {
        var sortedRides = rides
        var key: Ride
        
        for i in (0..<sortedRides.count) {
            key = sortedRides[i]

            for j in stride(from: i, to: -1, by: -1) {
                if key.name.localizedCompare(sortedRides[i].name) == .orderedAscending {
                    sortedRides.remove(at: j + 1)
                    sortedRides.insert(key, at: j)
                }
            }
        }
        
        var sortedNames =  [String]()
        for ride in sortedRides {
            sortedNames.append(ride.name)
        }
        
        return sortedNames
    }
}

let apples = ["green", "red", "green", "red", "green", "green"]
let greenApples = apples.filter { $0 == "green" }
//print(greenApples)

let parkRides = [
  Ride(name: "Raging Rapids", categories: [.family, .thrill, .water], waitTime: 45.0),
  Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
  Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
  Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
  Ride(name: "Thunder Coaster", categories: [.family, .thrill], waitTime: 60.0),
  Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
  Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
  Ride(name: "Mountain Railroad", categories: [.family, .relaxing], waitTime: 0.0)
]

let shortWaitTimeRides = parkRides.filter { $0.waitTime < 15.0 }
//print(shortWaitTimeRides)

func waitTimeIsShort(_ ride: Ride) -> Bool {
    return ride.waitTime < 15.0
}

let shortWaitRides = parkRides.filter(waitTimeIsShort)
//print("rides with a short wait time: \n\(shortWaitTimeRides)")

let oranges = apples.map { _ in "orange" }
print(oranges)

let rideNames = parkRides.map { $0.name }
//print(rideNames)
//print(rideNames.sorted(by: <))

func sortedNamesFP(_ rides: [Ride]) -> [String] {
    let rideNames = parkRides.map { $0.name}
    return rideNames.sorted(by: <)
}

let sortedNames2 = sortedNamesFP(parkRides)

let number = [0, 1, 2, 3, 4]

let doubledNumbers = number.map{ $0 * 2}
print(doubledNumbers)

let juice = oranges.reduce("") { juice, orange in juice + "juicy" }
print("fresh orange juice is served - \(juice)")

let totalWaitTime = parkRides.reduce(0.0) { (total, ride) in
    total + ride.waitTime
}
print("total wait time for all rides = \(totalWaitTime) minutes")

// for
let numbers = [1,2,3,4,5,6,7,8,9,10]
var sum = 0
for number in numbers {
    sum += number
}
print(sum)

// reduce(x) x: 초기값
let reduceSum = numbers.reduce(0) {
    return $0 + $1
}
print("reduce sum is \(reduceSum)")

// returns a function of type: ([Ride]) -> [Ride]
func filter(for category: RideCategory) -> ([Ride]) -> [Ride] {
    return { rides in
        rides.filter { $0.categories.contains(category)}
    }
}

let kidRideFilter = filter(for: .kids)
print("some good rides for kids are \n\(kidRideFilter(parkRides))")

////
func ridesWithWaitTimeUnder(_ waitTime: Minutes, from rides: [Ride]) -> [Ride] {
    return rides.filter { $0.waitTime < waitTime}
}

let shortWaitRidess = ridesWithWaitTimeUnder(15, from: parkRides)

func testShortWaitRides(_ testFilter:(Minutes, [Ride]) -> [Ride]) {
    let limit = Minutes(15)
    let result = testFilter(limit, parkRides)
    print("rides with wait less than 15 minutes:\n\(result)")
    let names = result.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse", "Mountain Railroad"]
    assert(names == expected)
    print("test rides with wait time under 15 = PASS")
}

testShortWaitRides(ridesWithWaitTimeUnder(_:from:))

testShortWaitRides({ waitTime, rides in
    return rides.filter { $0.waitTime < waitTime}
})


// Recursion - a function calls itself as part of its function body
extension Ride: Comparable {
    public static func < (lhs: Ride, rhs: Ride) -> Bool {
        return lhs.waitTime < rhs.waitTime
    }
    
    public static func == (lhs: Ride, rhs: Ride) -> Bool {
        return lhs.name == rhs.name
    }
}

// 프로토콜 확장에 구속조건 추가
extension Array where Element: Comparable {
    func quickSorted() -> [Element] {
        if self.count > 1 {
            let (pivot, remaining) = (self[0], dropFirst())
            let lhs = remaining.filter { $0 <= pivot }
            let rhs = remaining.filter { $0 > pivot }
            return lhs.quickSorted() + [pivot] + rhs.quickSorted()
        }
        return self
    }
}

let quickSortedRides = parkRides.quickSorted()
print(quickSortedRides)

func testSortedByWaitRides(_ rides: [Ride]) {
    let expected = rides.sorted(by: { $0.waitTime < $1.waitTime })
    assert(rides == expected, "unexpected order")
    print("Test sorted by wait time = PASS")
}

testSortedByWaitRides(quickSortedRides)

let sortedRideOfInterest = parkRides.filter { $0.waitTime < 20 && $0.categories.contains(.family)}.sorted(by: <)
print(sortedRideOfInterest)

func testSortedRidesOfInterst(_ ride: [Ride]) {
    let names = ride.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse", "Grand Carousel", "Mountain Railroad"]
    assert(names == expected)
    print("test rides of interest = PASS")
}
testSortedRidesOfInterst(sortedRideOfInterest)

struct Sample: CustomStringConvertible {
    let name: String
    let memo: String
    
    var description: String {
        return "name: \(name) memo: \(memo)"
    }
}

let sample = Sample(name: "ham", memo: "burder")
print(sample.description)

/*
 flatMap
 - nil이 아닌 결과들을 가지는 배열 리턴 (=>
 1차원 배열에서 nil을 제고하고 옵셔널 바인딩을 하고 싶을 때 compactMap 사용
 2차원 배열을 1차원 배열로 flatten하게 만들 때 flatMap 사용)
 - 주어진 sequence내 요소들을 하나의 배열로 리턴
 - 주어진 optional이 nil인지 아닌지 판단 후 unwrapping해서 closure 파라미터로 전달
 */

let optionalArray: [Int?] = [1, 2, 3, 4, nil]
let compactMappedArray = optionalArray.compactMap { $0 } // [1, 2, 3, 4]

let nestedArray = [[1, 2, 3, 4], [4, 5, 6], [7, 8, 9]]
let flatMappedNestedArray = nestedArray.flatMap { $0 } // [1, 2, 3, 4, 4, 5, 6, 7, 8, 9]

let optionalInt: String? = "3"
let flatMappedOptionalString = optionalInt.flatMap { Int($0) } // Optional(3)
let mappedOptionalString = optionalInt.map { Int($0) } // Optional(Optional(3))

let possibleNumbers = ["1", "2", "three", "///4///", "5"]
let mapped: [Int?] = possibleNumbers.map { str in Int(str)}
let conmpactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }
print(conmpactMapped)
