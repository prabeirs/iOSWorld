//
//  main.swift
//  LogFiles
//
//  Created by P sena on 17/07/19.
//  Copyright © 2019 Pablio sena. All rights reserved.
//

import Foundation

//print("Hello, World!")
var counter = 0 // Just an index for the while iteration.
var numLines = 0 // The first entry which is the number of lines expected after first entry.
var lineNum = 0 // The number of lines entered after/except  the first one.
var logFiles = [String]() // The log file names matching prefix log & suffix .log.

outerLoop: while true {
    let line = readLine(strippingNewline: true)
    if let unwrapLine = line {
        if unwrapLine.trimmingCharacters(in: .whitespaces).isEmpty {
            print("Empty line, skipping. lines read is \(counter)")
            continue
        } else {
            if counter == 0 {
                guard let unwarpNumLines = Int(unwrapLine) else {
                    print("ERROR: First entry should contain a numeric value. Aborting!")
                    break outerLoop
                }
                
                numLines = unwarpNumLines
                counter += 1
                
            } else {
                counter += 1
                lineNum += 1
                //print("Line \(lineNum) entered is :- \(unwrapLine)")
                // Mind that as per loose constraints in question we do not consider filenames with whitespaces in front even though the actual name of file matches.
                if unwrapLine.hasPrefix("log") || unwrapLine.hasSuffix(".log") {
                    logFiles.append(unwrapLine)
                }
            }
        }
    } else {
        print("ERROR: You haven't entered any line!")
    }
    if lineNum == numLines {
        break outerLoop
    }
}
print(logFiles.count)
