let arr = [1, 2, 4, 3, 10, 9, 11, 8, 13, 5, 12]

for (index, item) in arr.enumerated() {
    //print(i)
    let currElem = item
    let nextElem = arr[index + 1]
    
    var len: Int = 0
    
    if (nextElem > currElem) {
        len = nextElem - currElem
        if (len > 1) {
            for i in stride(from: currElem + 1, to: nextElem, by: 1) {
                print("between \(currElem) and \(nextElem): \(i)")
            }
        }
    } else if (currElem > nextElem) {
        len = currElem - nextElem
        if (len > 1) {
            
            for i in stride(from: currElem - 1, to: nextElem, by: -1) {
                print("between \(currElem) and \(nextElem): \(i)")
            }
        }
    }
    
   if (index + 1 + 1 == arr.count) {
        let nextElem = arr[index + 1]
        let currElem = item

        if (currElem > nextElem) {
            len = currElem - nextElem
                if (len > 1) {
                        for i in stride(from: currElem + 1, to: nextElem, by: -1) {
                            print("between \(currElem) and \(nextElem): \(i)")
                        }
                }
            
        } else if nextElem > currElem {
            len = nextElem - currElem
            if len > 1 {
                for i in stride(from: currElem + 1, to: nextElem, by: 1) {
                    print("between \(currElem) and \(nextElem): \(i)")
                }
            }
        }
    //print("breaking, curr elem = \(currElem) next elem = \(nextElem)")
    break
    }

}
