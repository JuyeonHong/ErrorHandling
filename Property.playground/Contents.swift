import Foundation

class DoublingClass {
    var a = 0
    var b = 0
    var data: Int {
        get {
            return a + b
        }
        set(value) {
            self.a = value / 2
            self.b = value / 2
        }
    }
    
    init() { }
}

var doubling = DoublingClass()
doubling.a
doubling.b
doubling.data = 10
doubling.a
doubling.b
doubling.a = 6
doubling.b = 10
doubling.data

class NewDoubling {
    var a = 0
    var b = 0
    var data: Int {
        get {
           return a + b
        } set {
            self.a = newValue / 2
            self.b = newValue / 2
        }
    }
    init() { }
}
var new = NewDoubling()
new.a
new.b
new.data = 8
new.a
new.b

class New {
    var a = 0
    var b = 0
    var data: Int {
        return a + b
    }
    init() { }
}

var n = New()
n.a  = 1
n.b = 3
n.data

class ObservingClass {
    var a: Int = 0 {
        willSet(value) {
            print("a: \(a) will change to \(value)")
        }
        didSet {
            print("a: \(a) did change to \(self.a)")
        }
    }
}

var ob = ObservingClass()
ob.a = 10

class HTTPResponseClass {
    static var success: Int {
        return 200
    }
    static var notFound: Int {
        return 404
    }
}

class DataImporter {
    var fileName = "data.txt"
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
}

let manager = DataManager()
manager.data.append("some data")
manager.data.append("some more data")
print(manager.importer.fileName)

class Ppoint {
    var tempX: Int = 1
    var x: Int {
        get {
            return tempX
        } set {
            tempX = newValue * 2
        }
    }
}

var p = Ppoint()
p.tempX
p.x = 12
p.tempX

struct Point {
    var x = 0.0, y = 0.0 // stored property
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center // get
print(initialSquareCenter)
square.center = Point(x: 15.0, y: 15.0) // set
print("sqare.origin is now at \(square.origin.x), \(square.origin.y)")

struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth // Read-Only Computed Property
    }
}

var cuboid = Cuboid(width: 2.0, height: 3.0, depth: 4.0)
cuboid.volume

class StepCounter {
    var totalSteps: Int = 0 {
        willSet { // 값이 저장되기 직전에 호출
            print("total step will change to \(newValue)")
        }
        didSet { // 새로운 값이 저장된 직후에 호출
            if totalSteps > oldValue {
                print("\(totalSteps - oldValue) walk is added")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360

struct SomeStruct {
    static var storedProperty = "some value"
    static var computedProperty: Int {
        return 1
    }
}

SomeStruct.storedProperty
SomeStruct.computedProperty

enum SomeEnum {
    static var storedTypeProperty = "some value"
    static var computedTypeProperty: Int {
        return 6
    }
}

SomeEnum.computedTypeProperty
SomeEnum.storedTypeProperty

class SomeClass {
    static var storedTypeProperty = "some value"
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

class ChildSomeClass: SomeClass {
    override class var overrideableComputedTypeProperty: Int { // class가 붙은 연산타입프로퍼티는 재정의가능
        return 2222
    }
}

