//This problem is about get the corresponding integer for an entry in a list of strings like
//"A", "B", ...,"Z",
//"AA", "AB",...,"AZ",
//"BA", "BB",..."BZ",
//...
//...
//...
//Normally all these items are contiguous i just show in this visual pattern only. So the min input character to the
//function
//(to be implemented) is a single character and max it could be 3 characters in our case for a non-generalized aspect.
//To solve it in possible ways and time it to see execution time differences seeking the best approach.
//Drawing an analogy we see in MS Excel when we fill a long column with English alphabets and then repeated we find such a number pattern.
// This function returns the number value of at most a three letter string (limited to three letters max)
// This is one of the ways , method 1
func alphaNumberOf(str: String) -> Int? {
    var alphaArr = [String]()
    alphaArr.insert("A", at: 0)
    alphaArr.insert("B", at: 1)
    alphaArr.insert("C", at: 2)
    alphaArr.insert("D", at: 3)
    alphaArr.insert("E", at: 4)
    alphaArr.insert("F", at: 5)
    alphaArr.insert("G", at: 6)
    alphaArr.insert("H", at: 7)
    alphaArr.insert("I", at: 8)
    alphaArr.insert("J", at: 9)
    alphaArr.insert("K", at: 10)
    alphaArr.insert("L", at: 11)
    alphaArr.insert("M", at: 12)
    alphaArr.insert("N", at: 13)
    alphaArr.insert("O", at: 14)
    alphaArr.insert("P", at: 15)
    alphaArr.insert("Q", at: 16)
    alphaArr.insert("R", at: 17)
    alphaArr.insert("S", at: 18)
    alphaArr.insert("T", at: 19)
    alphaArr.insert("U", at: 20)
    alphaArr.insert("V", at: 21)
    alphaArr.insert("W", at: 22)
    alphaArr.insert("X", at: 23)
    alphaArr.insert("Y", at: 24)
    alphaArr.insert("Z", at: 25)
    
    var alpha2NumDict = [String : Int]()
    let baseFor2D = alphaArr.count
    if str.count == 1 {
        guard let x = alphaArr.firstIndex(of: str) else { return nil }
        //print("num for \(str) is \(x)")
        return x + 1
    }
    else if str.count == 2 {
        // This code is exclusively for string input such as "AB", "AA", "CZ" etc.
        for i in 0...25 {
            for j in 0...25 {
                //print("\(alphaArr[i])    \(alphaArr[j])   \(i + 1 + j + 1 + baseFor2D)")
                alpha2NumDict["\(alphaArr[i])\(alphaArr[j])"] = i + 1 + j + 1 + baseFor2D
            }
        }
    }
    else if str.count == 3 {
        // This code is exclusively for string input such as "AAB", "AAA", "ACZ" etc.
        for i in 0...25 {
            for j in 0...25 {
                for k in 0...25 {
                    //print("\(alphaArr[i]) \(alphaArr[j]) \(alphaArr[k]) \(i + 1 + j + 1 + k + 1 + 2 * baseFor2D)")
                    alpha2NumDict["\(alphaArr[i])\(alphaArr[j])\(alphaArr[k])"] = i + 1 + j + 1 + k + 1 + 2 * baseFor2D
                }
            }
        }
    } else {
        return nil
    }
    
    let x = alpha2NumDict[str] ?? nil
    
    return x
}
let inputStr = "AAB"
let timeInterval1_0 = NSDate().timeIntervalSince1970
if let ret = alphaNumberOf(str: inputStr) { // Note we need the letters separated by NO space
    print("Number value method 1 for \(inputStr) = \(ret)")
} else {
    print("Number value not found method 1")
}
let timeInterval1_1 = NSDate().timeIntervalSince1970
print("time spent 1 = \(timeInterval1_1 - timeInterval1_0)")
// This is another of the ways , method 2
func alphaNumberOf2(str: String) -> Int? {
    var alphaArr = [Character]()
    alphaArr.insert("A", at: 0)
    alphaArr.insert("B", at: 1)
    alphaArr.insert("C", at: 2)
    alphaArr.insert("D", at: 3)
    alphaArr.insert("E", at: 4)
    alphaArr.insert("F", at: 5)
    alphaArr.insert("G", at: 6)
    alphaArr.insert("H", at: 7)
    alphaArr.insert("I", at: 8)
    alphaArr.insert("J", at: 9)
    alphaArr.insert("K", at: 10)
    alphaArr.insert("L", at: 11)
    alphaArr.insert("M", at: 12)
    alphaArr.insert("N", at: 13)
    alphaArr.insert("O", at: 14)
    alphaArr.insert("P", at: 15)
    alphaArr.insert("Q", at: 16)
    alphaArr.insert("R", at: 17)
    alphaArr.insert("S", at: 18)
    alphaArr.insert("T", at: 19)
    alphaArr.insert("U", at: 20)
    alphaArr.insert("V", at: 21)
    alphaArr.insert("W", at: 22)
    alphaArr.insert("X", at: 23)
    alphaArr.insert("Y", at: 24)
    alphaArr.insert("Z", at: 25)
    
    let baseNum = alphaArr.count
    if str.count == 1 {
        let strChar = Character(str)
        guard let x = alphaArr.firstIndex(of: strChar) else { return nil }
        //print("num for \(str) is \(x)")
        return x + 1
    }
//    } else if str.count == 2 {
//        var tok = [Character]()
//        for token in str {
//            tok.append(token)
//        }
//        let tokChar0 = tok[0]
//        let tokChar1 = tok[1]
//        guard let x = alphaArr.firstIndex(of: tokChar1) else { return nil }
//        guard let y = alphaArr.firstIndex(of: tokChar0) else { return nil }
//        let strIndex =  baseNum + y + 1 + x + 1
//        return strIndex
//    } else if str.count == 3 {
//        var tok = [Character]()
//        for token in str {
//            tok.append(token)
//        }
//        //print(tok)
//        let tokChar0 = tok[0]
//        let tokChar1 = tok[1]
//        let tokChar2 = tok[2]
//        guard let x = alphaArr.firstIndex(of: tokChar0) else { return nil }
//        guard let y = alphaArr.firstIndex(of: tokChar1) else { return nil }
//        guard let z = alphaArr.firstIndex(of: tokChar2) else { return nil }
//        let strIndex = (2 * baseNum) + z + 1 + y + 1 + x + 1
//        return strIndex
//    }
    else {
        let strCount = str.count
        //var tok = [Character]()
        var indexSummation = 0
//        for token in str {
//            tok.append(token)
//        }
        for char in str {
            guard let x = alphaArr.firstIndex(of: char) else {
                return nil
            }
            indexSummation += x + 1
        }
        let nFormula = (strCount - 1) * baseNum + indexSummation
        return nFormula
    }
}
let timeInterval2_0 = NSDate().timeIntervalSince1970
if let y = alphaNumberOf2(str: inputStr) { // Note we need the letters separated by NO space
    print("Number value method 2 for \(inputStr) = \(y)")
} else {
    print("Number value not found method 2")
}
let timeInterval2_1 = NSDate().timeIntervalSince1970
print("time spent 2 = \(timeInterval2_1 - timeInterval2_0)")

