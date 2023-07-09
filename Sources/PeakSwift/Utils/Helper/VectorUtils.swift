//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 03.07.23.
//

import Foundation

class VectorUtils {
    
    static func floorVector(_ vector: [Double]) -> [Double] {
        return vector.map {
            floor($0)
        }
    }
        
    static func setToZeroInRange(_ array: inout [Double], start: Int = 0, end: Int) {
        array.replaceSubrange(start...end, with: repeatElement(0, count: end-start))
    }
        
    static func setToZeroTilEnd(_ array: inout [Double], start: Int = 0) {
            setToZeroInRange(&array, start: start, end: array.count)
    }
}
