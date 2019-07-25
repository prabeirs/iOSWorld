//
//  main.swift
//  Knots&Crosses
//
//  Created by P sena on 23/07/19.
//  Copyright © 2019 Pablio sena. All rights reserved.
//  Apply only for vertical and horizonlal streaks.

import Foundation

//Constraints
//
//1 <= t <= 1000
//1 <= m,n <= 100
//2 <= k <= 10 ; k <= m and k <= n

var counter = 0 // Just an index for the while iteration
var t = 0 // The first line contains and integer t denoting the number of test cases.
var m = 0, n = 0, k = 0 // The second line consists of three space separated integers m, n and k.
var itemRows = [String]() // Sub collector of matrix row items
var matrices = [String : [String]]() // Collector of matrices
var col2RowItems = [String : [String]]() // create a collection of collection where the inner collection is an array of each column item. A matrix same as matrices variable but transposed out of it.
var error = false
var nextMatrixSzRowEnd = 0 // NOrmally the matrix entries should be read from index 2 till index + m where m is the first item i.e; m of the second row. After item at index + m is read then the next row gives us a new m. So next matix entries should be read from index till index + m (=nextMatrixSzRowEnd).
var numTimesMatrixRead = 0 // number of times the m n k rows supplied. It has to go till t

// The direction of streaks to be found in matrices
enum Direction {
    case hor
    case ver
    case dia
}

// This function read the row which looks like m n k from stdin and then re set the nextMatrixSzRowEnd variable which says till which index now the matrix's entries should be read on.
func readMatrixSzStreak(from: String) -> Int {
    
    let matrixSzStreak = from.split(separator: " ")
    
    if matrixSzStreak.count != 3 {
        print("ERROR: The matrix size and streaks entry line should contain space separated three numbers only. Aborting!")
        return 0
    }
    
    //print("INFO: Present m = \(m) n = \(n) k = \(k) t = \(t)")
    //print("INFO: nextMatrixSzRowEnd = \(nextMatrixSzRowEnd)")
    
    for (index, item) in matrixSzStreak.enumerated() {
        
        guard let itemNum = Int(item) else {
            print("ERROR: the items of this row should be numeric only. Aborting!")
            return 0
        }
        
        if index == 0 {
            
            m = itemNum
            nextMatrixSzRowEnd = counter + m
            
        } else if index == 1 {
            
            n = itemNum
            
        } else if index == 2 {
            
            k = itemNum
            
            if k < 2 {
                print("ERROR: value of streak item length(m) cannot be less then 2. Aborting!")
                return 0
            }
            if k > n {
                print("ERROR: value of streak item length(m) cannot be greater then column numbers (n). Aborting!")
                return 0
            }
            if k > m {
                print("ERROR: value of streak item length(m) cannot be greater then row numbers (m). Aborting!")
                return 0
            }
            
        }
        
    }
    
    //print("INFO: New m = \(m) n = \(n) k = \(k) t = \(t)")
    //print("INFO: nextMatrixSzRowEnd = \(nextMatrixSzRowEnd)")
    
    return 1
}

func assertMatrixItems(inRow: String) ->Int {
    
    let matrixRow = inRow.split(separator: " ")
    
    if matrixRow.count != n {
        print("ERROR: The matrix row entry line should contain space separated \(n) items only. Aborting!")
        return 0
    }
    
    for (_, item) in matrixRow.enumerated() {
        if item != "x" && item != "o" {
            print("ERROR: The matrix row items should be either x or o only. Aborting!")
            return 0
        }
    }
    return 1
}

func consecutiveRowsFrom_X_Y_per_row(x: Int, y: Int) -> Int {
    var runningLastIndex = y
    var rows = [String]()
    for number in 1...x {
        if runningLastIndex > x {
            break
        }
        var strNum: String = ""
        for number2 in number...runningLastIndex {
            strNum += String(number2) + " "
        }
        
        rows.append(strNum)
        
        runningLastIndex += 1
    }
    
    return rows.count
}

func transpose(matrix: [String]) -> [String] {
    
    //print("Matrix is : \(matrix)")
    var matrixTranspose: [String : [String]?] = [:]
    var retMatrix = [String]() // the thing to return, an array of Strings where an elem look as "x x o"
    
    for (_, item) in matrix.enumerated() {
        let elems = item.split(separator: " ")
        for (index2, elem) in elems.enumerated() {
            let elemStr = String(elem)
            //print("Elem str \(elemStr) index2 = \(index2)")
            
            if let val = matrixTranspose[String(index2)] {
                if let _ = val {
                    matrixTranspose[String(index2)]??.append(elemStr)
                } else {
                    print("value is nil")
                }
            } else {
                //print("Key is not present in dict. so creating it.")
                matrixTranspose[String(index2)] = [elemStr]
            }
        }
    }
    
    let sortedKeys = matrixTranspose.keys.sorted()
    for key in sortedKeys {
        if let val = matrixTranspose[key] {
            if let x = val {
                //print(">> key = \(key) value = \(x)")
                let rowStr = x.joined(separator: " ")
                //print(">> key = \(key) value = \(rowStr)")
                retMatrix.append(rowStr)
            } else {
                print("value is nil")
            }
        } else {
            //print("key is not defined in dict")
        }
        
    }
    
    //print("Matrix transpose : \(retMatrix)")
    
    return retMatrix
}

func showMatrixDirectionStreaks(inside: [String : [String]], direction: Direction) {
    
    for (key, value) in inside {
        var totalXStreaks = 0
        var totalOStreaks = 0
        
        let retMatrix = transpose(matrix: value)
        col2RowItems[key] = retMatrix
        //print("key = \(key)")
        
        let keyX = key.split(separator: " ")
        let m = Int(keyX[0])!
        let n = Int(keyX[1])!
        let streakLen = Int(keyX[2])!
        var numRowStreaksPossible = 0
        var numColStreaksPossible = 0
        
        switch direction {
            case .ver:
                numRowStreaksPossible = consecutiveRowsFrom_X_Y_per_row(x: m, y: streakLen)
            case .hor:
                numColStreaksPossible = consecutiveRowsFrom_X_Y_per_row(x: n, y: streakLen)
            case .dia:
                break
        }
        
        //let inputMatrixSz = "\(m) \(n) \(streakLen)"
        
        //print("Rows possible from input \(inputMatrixSz) is \(numRowStreaksPossible) & Cols possible is \(numColStreaksPossible)")
        var items = [[Substring]]() // collect each row as an array inside this array
        for (_, item) in value.enumerated() {
            let itemTokens = item.split(separator: " ")
            items.append(itemTokens)
        }
        
        for item in items { // parse each row array from this matrix
            
            //print("Parsing matrix row \(item)")
            
            var prevElem: Substring = ""
            var xCollect = [Substring]()
            var oCollect = [Substring]()
            
            for col in 1...n {
                let index = col - 1
                let elem = item[index]
                
                if elem == "x" {
                    
                    if prevElem == elem {
                        xCollect.append(elem)
                    } else if prevElem.isEmpty {
                        xCollect.append(elem)
                    } else {
                        if xCollect.isEmpty {
                            xCollect.append(elem)
                        } else if xCollect.count < streakLen {
                            xCollect.removeAll()
                            
                            if oCollect.count < streakLen {
                                oCollect.removeAll()
                            }
                        }
                    }
                    
                } else if elem == "o" {
                    
                    if prevElem == elem {
                        oCollect.append(elem)
                    } else if prevElem.isEmpty {
                        oCollect.append(elem)
                    } else {
                        if oCollect.isEmpty {
                            oCollect.append(elem)
                        } else if oCollect.count < streakLen {
                            oCollect.removeAll()
                            
                            if xCollect.count < streakLen {
                                xCollect.removeAll()
                            }
                        }
                    }
                }
                
                prevElem = elem
            }
            
            // Find horizontal (n columns) possible streaks from the rows of matrix.
            if direction == .hor {
                //print("x Collector : \(xCollect)")
                let numItemXCollect = xCollect.count
                if numItemXCollect >= numColStreaksPossible {
                    let rowStreaks = consecutiveRowsFrom_X_Y_per_row(x: xCollect.count, y: streakLen)
                    //print("X row streaks = \(rowStreaks)")
                    totalXStreaks += rowStreaks
                } else {
                    //print("X row streaks = 0")
                }
                //print("o Collector : \(oCollect)")
                let numItemOCollect = oCollect.count
                if numItemOCollect >= numColStreaksPossible {
                    let rowStreaks = consecutiveRowsFrom_X_Y_per_row(x: oCollect.count, y: streakLen)
                    //print("O row streaks = \(rowStreaks)")
                    totalOStreaks += rowStreaks
                } else {
                    //print("O row streaks = 0")
                }
            }
                // Find vertical (m rows) possible streaks from the columns of original matrix i.e; from the transposed matrix
            else if direction == .ver {
                //print("x Collector : \(xCollect)")
                let numItemXCollect = xCollect.count
                if numItemXCollect >= numRowStreaksPossible {
                    let rowStreaks = consecutiveRowsFrom_X_Y_per_row(x: xCollect.count, y: streakLen)
                    //print("X row streaks = \(rowStreaks)")
                    totalXStreaks += rowStreaks
                } else {
                    //print("X row streaks = 0")
                }
                //print("o Collector : \(oCollect)")
                let numItemOCollect = oCollect.count
                if numItemOCollect >= numRowStreaksPossible {
                    let rowStreaks = consecutiveRowsFrom_X_Y_per_row(x: oCollect.count, y: streakLen)
                    //print("O row streaks = \(rowStreaks)")
                    totalOStreaks += rowStreaks
                } else {
                    //print("O row streaks = 0")
                }
            } else if direction == .dia {
                // Not imeplemented yet
            }
            
        } // parsing matrix end loop
        
        print("\(totalXStreaks) \(totalOStreaks)")
        
    }
    
    // Lets print the transposed matrix which shall be used to find streaks vertically
    //print("Transposed matrices : \(col2RowItems)")
}

// main ####
func main() {
    var prevMatrixSz: String = ""
    outerLoop: while true {
        let line = readLine(strippingNewline: true)
        if let unwrapLine = line {
            if unwrapLine.trimmingCharacters(in: .whitespaces).isEmpty {
                print("Empty line, skipping. lines read is \(counter)")
                continue
            } else {
                
                if counter != 0 && counter >= nextMatrixSzRowEnd && numTimesMatrixRead == t {
                    itemRows.append(unwrapLine)
                    let uniqueMatrixKey = "\(prevMatrixSz) \(numTimesMatrixRead)"
                    matrices[uniqueMatrixKey] = itemRows
                    break outerLoop
                }
                
                if counter == 0 {
                    guard let unwrapNumLines = Int(unwrapLine) else {
                        print("ERROR: First entry should contain a numeric value. Aborting!")
                        error = true
                        break outerLoop
                    }
                    
                    t = unwrapNumLines
                    counter += 1
                    
                } else if counter == 1 {
                    
                    let retVal = readMatrixSzStreak(from: unwrapLine)
                    
                    if retVal == 0 {
                        error = true
                        break outerLoop
                    } else {
                        counter += 1
                        numTimesMatrixRead += 1
                        prevMatrixSz = unwrapLine
                    }
                    
                    //print("INFO: counter = \(counter) numTimesMatrixRead = \(numTimesMatrixRead)")
                    
                } else if counter <= nextMatrixSzRowEnd {
                    let retVal = assertMatrixItems(inRow: unwrapLine)
                    if retVal == 0 {
                        error = true
                        break outerLoop
                    } else {
                        itemRows.append(unwrapLine)
                        counter += 1
                    }
                    
                } else {
                    
                    let retVal = readMatrixSzStreak(from: unwrapLine)
                    
                    if retVal == 0 {
                        error = true
                        break outerLoop
                    } else {
                        let uniqueMatrixKey = "\(prevMatrixSz) \(numTimesMatrixRead)"
                        matrices[uniqueMatrixKey] = itemRows
                        itemRows.removeAll()
                        counter += 1
                        numTimesMatrixRead += 1
                        prevMatrixSz = unwrapLine
                    }
                    
                    //print("INFO: counter = \(counter) numTimesMatrixRead = \(numTimesMatrixRead)")
                    
                }
            }
            
        }
        
    }
    if error {
        exit(1)
    }
    print("Output:")
    //print(matrices)
    showMatrixDirectionStreaks(inside: matrices, direction: .hor) // hor -> n (columns)
    //print("Transposed matrix streaks :-")
    showMatrixDirectionStreaks(inside: col2RowItems, direction: .ver) // ver -> m (rows)
}
main()
