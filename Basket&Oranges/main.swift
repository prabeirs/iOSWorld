//
//  main.swift
//  Baskets&Oranges
//
//  Created by P sena on 17/07/19.
//  Copyright © 2019 Pablio sena. All rights reserved.
//

import Foundation

//print("Hello, World!")
//Problem statement
//You have n number of baskets. Each basket has some oranges in it. Harry needs m baskets with an equal number of oranges. You have to give it to him at the earliest. You need to add oranges to bags since it takes less time than removing oranges from bags. Determine the minimum number of oranges required to get m bags containing an equal number of oranges.

//Input
//The first line contains an integer n, the number of bags (1 <= n <= 100)
//The second line contains an integer m, the required number of bags (1<=m<=n)
//It is followed by n lines. The ith line contains the number of oranges in with bag
//
//Output
//The output should contain the number of oranges which need to be added
//Sample test case
// INput
//5
//2
//6
//8
//9
//11
//4
// Output
// 1
var counter = 0 // Just an index for the while iteration.
var numLines = 0 // The first entry which is the number of lines (i.e; number of oranges in each basket) expected after second entry.
var lineNum = 0 // The number of lines entered after the second line.
var m = 0 // Required number bags with equal number of oranges in all of them each.
var items = [Int]() // Collection where each item is the number of oranges in each of the m bags (above).
var error = 0 // an error flag only for early abort.
outerLoop: while true {
    let line = readLine(strippingNewline: true)
    if let unwrapLine = line {
        if unwrapLine.trimmingCharacters(in: .whitespaces).isEmpty {
            print("Empty line, skipping. lines read is \(counter)")
            continue
        } else {
            if counter == 0 {
                guard let unwrapNumLines = Int(unwrapLine) else {
                    print("ERROR: First entry should contain a numeric value. Aborting!")
                    error = 1
                    break outerLoop
                }
                
                numLines = unwrapNumLines
                counter += 1
                
            } else if counter == 1 {
                guard let unwrapRequiredBagsNum = Int(unwrapLine) else {
                    print("ERROR: Second entry should contain a numeric value. Aborting!")
                    error = 1
                    break outerLoop
                }
                
                m = unwrapRequiredBagsNum
                counter += 1
                
            } else {
                guard let unwrapNumItemsInBag = Int(unwrapLine) else {
                    print("ERROR: All post second entries should contain a numeric value. Aborting!")
                    error = 1
                    break outerLoop
                }
                
                counter += 1
                lineNum += 1
                items.append(unwrapNumItemsInBag)
                
            }
        }
    } else {
        print("ERROR: You haven't entered any line!")
        error = 2
    }
    
    if lineNum == numLines {
        break outerLoop
    }
    
}
//print("Original items sorted : \(items.sorted())")

if error > 0 {
    exit(1)
}

let itemsSorted = items.sorted()
var mItems = [String : Int]() // To gather the final result, where the key will be a string comprised of the m number items. The m items here are (numeric) counts of oranges in every basket, where there are total m baskets. Each item is comma separated and combined along with some unique identifier and the value is the total difference of these m sorted items when taken two items at a time consecutive to each other from left onwards till last end item. The some unique identifier is "pos=XXX" where it signifies the start position of the m items within the list of n items. m <= n in general.

for (i, _) in itemsSorted.enumerated() {
    
    // Calculate the value of the item at the m -1 ' th position from position i
    let indexOfMPrev = i + m - 1
    if indexOfMPrev >= itemsSorted.count {
        break
    }
    //print(">>> indexM \(indexOfMPrev)")
    let itemPrevM = itemsSorted[indexOfMPrev]
    //print(">>> itemM \(itemPrevM)")
    
    // Now inclusive of the i positioned item till the above item inclusive it is collection of m items which is one part of the answer.
    
    // From position i onwards till m -2 position calculate the abs difference of i' th positioned item with the j' th positioned item , where i < j <= m - 2
    let k = indexOfMPrev - 1
    //print(">>> indexM-1 \(k)")
    
    var totalDiff = 0 // Accumulate the total differences of every item with the m - 1 ' th positioned item starting from i' th position till the m - 2 ' th position.
    var subMItems = [Int]() // gather all the m number of items in various diffrent positions across the original sorted items (i.e; the logical input).
    for j in i...k {
        let diff = itemPrevM - itemsSorted[j]
        totalDiff += diff
        subMItems.append(itemsSorted[j])
        //print(">>> j = \(j) item = \(itemsSorted[j])")
    }
    subMItems.append(itemPrevM) // append the m - 1'th item at last with which it's previous items were taken difference with. It was not in this calculation list just to avoid taking difference with itself.
    
    // Print just an iterated view of these items along with the sum total of difference of every m - 2 items with the m - 1' th item. This visual thing helps to proceed farther next step.
    //print(subMItems)
    //print(totalDiff)
    //print("+++++++++++++++++++")
    
    var strItem = ""
    let strFirstItemRangeM = String(i)
    for itemM in subMItems {
        let strX = String(itemM)
        strItem += strX + ","
    }
    
    strItem += "pos=\(strFirstItemRangeM)"
    
    mItems[strItem] = totalDiff
    
}

// Dict sorted by values. NOTE: Ignore this. This chunk is not required at the moment wrt expected o/p but for a view only purpose while dev it is helpful.
//let keysMItems = Array(mItems.keys)
//var sortedKeysMItems = keysMItems.sorted {
//    let obj1 = mItems[$0]! // object associated with key1
//    let obj2 = mItems[$1]! // object associated with key2
//
//    // If we reached uptill here from all through above then indeed the objects are numbers only anc hence can do a possible binary comparision ">".
//    return obj1 > obj2
//}
//print(mItems) // Get to see the near final better view.

let valuesMItems = Array(mItems.values)
let sortedValuesMItems = valuesMItems.sorted()
print(sortedValuesMItems[0]) // The final only single number output expected per question / answer sample.

