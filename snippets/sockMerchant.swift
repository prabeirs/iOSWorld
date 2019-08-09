func sockMerchant(n: Int, ar: [Int]) -> Int {
    var arDict = [Int : Int]()
    var totalNumPairs = 0

    if n != ar.count {
        return 0
    }

    for (_, item) in ar.enumerated() {
        if arDict[item] == nil {
            arDict[item] = 1
        } else {
            arDict[item]! = arDict[item]! + 1
        }
    }

    for (_, value) in arDict {
        //print("\(key) -> \(value)")
        totalNumPairs += value/2
    }

    return(totalNumPairs)
}
print(sockMerchant(n: 11, ar: [10, 20, 20, 10, 10, 30, 50, 10, 20, 20, 20]))
