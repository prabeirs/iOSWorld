func absoluteDiagonalDiffMatrix(numArr: [[Int]]) -> Int {
    var forwardDiagonal = [Int]()
    var backwardDiagonal = [Int]()
    var n = 1
    
    outerLoop: for (index, item) in numArr.enumerated() {
        
        innerLoop: for (index2, item2) in item.enumerated() {
            
            //print("\(index) \(index2) \(item2)")
            
            if index2 == index {
                forwardDiagonal.append(item2)
                backwardDiagonal.append(item[item.count - n])
                n += 1
                break innerLoop
            }
        }
    }
    //print(backwardDiagonal)
    //print(forwardDiagonal)
    let x = abs(forwardDiagonal.reduce(0, +) - backwardDiagonal.reduce(0, +))
    //print(x)
    
    return x
}
print(absoluteDiagonalDiffMatrix(numArr: [[1,2,3], [4,5,6], [9,8,9]]))
