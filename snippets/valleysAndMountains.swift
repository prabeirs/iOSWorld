func countingValleys(n: Int, s: String) -> Int {
    var numberOfValleys = 0
    var numberOfMountains = 0
    var isSeaLevel: Bool = true
    var upSteps = 0
    var downSteps = 0
    var previousSeaLevelStep: String = ""

    if n != s.count {
        fatalError("The number of steps taken (n: first line input) is mismatch with path string denotion. Aborting!")
    }

    for (_, char) in s.enumerated() {

        switch char {
        case "U":
            upSteps += 1
            if upSteps == downSteps {
                isSeaLevel = true
                downSteps = 0
                upSteps = 0
            } else {
                if isSeaLevel == true {
                    previousSeaLevelStep = String(char)
                }
                isSeaLevel = false
            }

        case "D":
            downSteps += 1
            if downSteps == upSteps {
                isSeaLevel = true
                downSteps = 0
                upSteps = 0

            } else {
                if isSeaLevel == true {
                    previousSeaLevelStep = String(char)
                }
                isSeaLevel = false
            }

        default:
            fatalError("Unexpected step denotion found. Aborting!")
        }

        if isSeaLevel == true {
            if previousSeaLevelStep == "D" && char == "U" {
                numberOfValleys += 1
            } else if previousSeaLevelStep == "U" && char == "D" {
                numberOfMountains += 1
            }
        }
    }

    return numberOfValleys
    //return numberOfMountains

}
print(countingValleys(n: 18, s: "DDUUUUDDDDDDUDUUUU"))
