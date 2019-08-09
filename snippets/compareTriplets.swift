func compareTriplets(a: [Int], b: [Int]) -> [Int] {
    if a.count != b.count {
        fatalError("The input arrays do not contain the same number of elements.")
    }

    var comparisionPoints = [0, 0]

    for i in 0...a.count - 1 {
        if a[i] > b[i] {
            comparisionPoints[0] += 1
        } else if b[i] > a[i] {
            comparisionPoints[1] += 1
        }
    }

    return comparisionPoints
}
print(compareTriplets(a: [5, 6, 7], b: [3, 6, 10]))
