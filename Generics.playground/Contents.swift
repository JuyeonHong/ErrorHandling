import Foundation
// ref: https://www.raywenderlich.com/3535703-swift-generics-tutorial-getting-started

func addInts(x: Int, y: Int) -> Int {
    return x + y
}

let intSum = addInts(x: 33, y: 92) // 125

func addDoubles(x: Double, y: Double) -> Double {
    return x + y
}

let doubleSum = addDoubles(x: 32.1, y: 69.6) // 101.7

/// - - - - - - - - - - - - - - ↓ Cleaning Up the Add Functions ↓ - - - - - - - - - - - - - -

protocol Summable {
    static func + (lhs: Self, rhs: Self) -> Self
}
extension Int: Summable { }
extension Double: Summable { }

func add<T: Summable>(x: T, y: T) -> T {
    return x + y
}

let addIntSum = add(x: 1, y: 2) // 3
let addDoubleSum = add(x: 2.4, y: 9.2) // 11.6

extension String: Summable { }
let addString = add(x: "Generics", y: " are Awesome!!") // Generics are Awesome!!

/// The function signatures of addInts and addDoubles are different, but the function bodies are identical.
/// Generics can be used to reduce these two functions to one and remove the redundant code.

/// some of the most common structures you use, such as arrays, dictionaries, optionals and results are generic types!

/// - - - - - - - - - - - - - -  * Results  * - - - - - - - - - - - - - - 


enum MagicError: Error {
    case spellFailure
}

func cast(_ spell: String) -> Result<String, MagicError> {
    switch spell {
    case "flowers":
        return .success("💐")
    case "stars":
        return .success("✨")
    default:
        return .failure(.spellFailure)
    }
}

let result1 = cast("flowers") // success("💐")
let result2 = cast("what else") // spellFailure


///  - - - - - - - - - - - - - - * write a Generic Data Structure * - - - - - - - - - - - - - -

struct Queue<Element> {
    private var elements: [Element] = []
    
    mutating func enqueue(newElement: Element) {
        elements.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements.remove(at: 0)
    }
    
}

var q = Queue<Int>() // []
q.enqueue(newElement: 4) // [4]
q.enqueue(newElement: 3) // [4, 3]

q.dequeue() // 4
q.dequeue() // 3
q.dequeue() // nil

struct Stack<Element> {
    private var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        guard !items.isEmpty else { return nil }
        return items.removeLast()
    }
}

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)
stack.push(4) // [1, 2, 3, 4]

stack.pop() // [1, 2, 3]

/// - - - - - - - - - - - - - -  * Extending a Generic Type * - - - - - - - - - - - - - -


extension Queue {
    func peek() -> Element? {
        // peek returns the first element without dequeuing it.
        return elements.first
    }
}

q.enqueue(newElement: 5) // [5]
q.enqueue(newElement: 3) // [5, 3]
q.peek() // 5

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

stack.topItem // 3


////  - - - - - - - - - - - - - -  * write a Generic Function * - - - - - - - - - - - - - -


func pairs<Key, Value>(from dictionary: [Key: Value]) -> [(Key, Value)] {
    return Array(dictionary)
}

let somePairs = pairs(from: ["minimum": 199, "maximum": 299])
// it returns array of (String, Int) tuples => [("minimum", 199), ("maximum", 299)]
let morePairs = pairs(from: [1: "Swift", 2: "Generics", 3: "Rules"])
// it returns array of (Int, String) tuples => [(1, "Swift"), (3, "Rules"), (2, "Generics")]


/// - - - - - - - - - - - - - -  * Constraining a Generic Type * - - - - - - - - - - - - - -

/// a function to sort an array and find the middle value.
func mid<T: Comparable>(array: [T]) -> T? {
    guard !array.isEmpty else { return nil }
    let midIndex = (array.count - 1) / 2
    return array.sorted()[midIndex]
}

mid(array: [3, 5, 1, 2, 4]) // 3


/// - - - - - - - - - - - - - -  * Subclassing a Generic Type * - - - - - - - - - - - - - -


class Box<T> {
    // Just a plain old box.
}

class Gift<T>: Box<T> {
    // By default, a gift box is wrapped with plain white paper
    func wrap() {
        print("Wrap with plain white paper.")
    }
}

class Rose {
    // Flower of choice fr fairytale dramas
}

class ValentinesBox: Gift<Rose> {
    // A rose for your valentine
    override func wrap() {
        print("Wrap with ♥♥♥ paper.")
    }
}

class Shoe {
    // Just regular shoe
}

class GlassSlipper: Shoe {
    // A single shoe, destined for a princess
}

class ShoeBox: Box<Shoe> {
    // A box that can contain shoes
}

let box = Box<Rose>() // A regular box that can contain a rose
let gift = Gift<Rose>() // A gift box that can contain a rose
let shoeBox = ShoeBox()
let valentines = ValentinesBox()
gift.wrap() // Wrap with plain white paper.
valentines.wrap() // Wrap with ♥♥♥ paper.


/// - - - - - - - - - - - - - -  * Enumberations With Associated Values * - - - - - - - - - - - - - -


enum Reward<T> {
    case treasureChest(T)
    case medal
    
    var message: String {
        switch self {
        case .treasureChest(let treasure):
            return "You got a chest filled with \(treasure)"
        case .medal:
            return "Stand proud, you earned a medal !"
        }
    }
}

let message = Reward.treasureChest("💰").message // You got a chest filled with 💰
