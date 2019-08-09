func getMaxElementIndexes(a: [Int], rotate: [Int]) -> [Int] {
    var indices = [Int]()
    let maxArrayIndex = a.count - 1
    //print("max index of array = \(maxArrayIndex)")

    for (_, rotationItem) in rotate.enumerated() {
        //print("rotating for rotation number = \(rotationItem) with index \(index)")

        if rotationItem == 0 {
            let maxVal = a.max() ?? 0
            let posMax = a.firstIndex(of: maxVal)!
            indices.append(posMax)
            //print(indices)
        } else {
            var tempArr = [Int]()
            var runningRotatedArray = [Int]()
            runningRotatedArray = a

            for _ in 0...rotationItem - 1 {

                for j in 0...a.count - 1 {
                    //print("j = \(j)")
                    if j == maxArrayIndex {
                        //tempArr[j] = a[0]
                        //tempArr.append(a[0])
                        tempArr.insert(runningRotatedArray[0], at: j)
                    } else {
                        //tempArr[j] = a[j+1]
                        //tempArr.append(a[j+1])
                        tempArr.insert(runningRotatedArray[j+1], at: j)
                    }
                }
                
                runningRotatedArray = tempArr
                
            }
            
            let maxVal = runningRotatedArray.max() ?? 0
            let posMax = runningRotatedArray.firstIndex(of: maxVal)!
            indices.append(posMax)
        }
    }
    return indices
}
print(getMaxElementIndexes(a: [1, 2, 4, 3], rotate: [2, 2]))
