import Foundation

//From: https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeed: Int)
    case outOfStock
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeed: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
    
    let favoriteSnacks = [
        "Alice": "Chips",
        "Bob": "Licorice",
        "Eve": "Pretzels"
    ]
    
    func buyFavoriteSnacks(person: String, vendingMachine: VendingMachine) throws {
        let snackName = favoriteSnacks[person] ?? "Candy Bar"
        try vendingMachine.vend(itemNamed: snackName)
    }
    
    func nourish(with item: String) throws {
        do {
            try vendingMachine.vend(itemNamed: item)
        } catch is VendingMachineError {
            print("Invalid selection, out of stock, or not enough money")
        }
    }
    
    func someThrowingFuc() throws -> Int {
        print("wrong wrong wrong")
        return 1
    }
}

struct PurchaseSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try vendingMachine.buyFavoriteSnacks(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection")
} catch VendingMachineError.outOfStock {
    print("Out Of Stock")
} catch VendingMachineError.insufficientFunds(coinsNeed: let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins")
} catch {
    print("Unexpected error: \(error).")
}

do {
    try vendingMachine.nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}

let x = try? vendingMachine.someThrowingFuc() // try? -> 에러 발생 시 nil 반환, 리턴값 전달 시 옵셔널
let y: Int?
do {
    y = try vendingMachine.someThrowingFuc()
} catch {
    y = nil
}

print("x is \(x) y is \(y)")

