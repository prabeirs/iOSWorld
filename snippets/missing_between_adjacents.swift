let arr = [1, 2, 4, 3, 10, 9, 11]

for (index, item) in arr.enumerated() {
    //print(i)
    let currElem = item
    let nextElem = arr[index + 1]
    
    var len: Int = 0
    
    if (nextElem > currElem) {
        len = nextElem - currElem
        if (len > 1) {
            for i in currElem + 1..<nextElem {
                print("between \(currElem) and \(nextElem) \(i)")
            }
        }
    } else if (currElem > nextElem) {
        len = currElem - nextElem
        if (len > 1) {
            for i in currElem - 1..<nextElem + 1 {
                print("between \(currElem) and \(nextElem) \(i)")
            }
        }
    }
    
   if (index + 1 + 1 == arr.count) {
        let nextElem = arr[index + 1]
        let currElem = item

        if (currElem > nextElem) {
                if (nextElem > currElem) {
                    len = nextElem - currElem
                    if (len > 1) {
                        for i in currElem + 1...nextElem - 1 {
                            print("between \(currElem) and \(nextElem) \(i)")
                        }
                    }
                } else if (currElem > nextElem) {
                    len = currElem - nextElem
                    if (len > 1) {
                        for i in currElem - 1...nextElem + 1 {
                            print("between \(currElem) and \(nextElem) \(i)")
                        }
                    }
                }
        }
    //print("breaking, curr elem = \(currElem) next elem = \(nextElem)")
    break
    }
    
}
