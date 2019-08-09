func doubleSize(a: [Int], b: Int) -> Int {
    var currentB = b

    for item in a {
        if item == currentB {
            currentB = 2 * currentB
        } else {
            currentB = 1 * currentB
        }
    }

    return currentB

}
print(doubleSize(a: [2, 4, 5, 6, 8], b: 2))
