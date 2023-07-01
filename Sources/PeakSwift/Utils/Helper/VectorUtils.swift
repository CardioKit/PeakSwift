//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.07.23.
//

import Foundation


class VectorUtils {
    
    
    static func setToZeroInRange(array: inout [Double], start: Int = 0, end: Int) {
        array.replaceSubrange(start...end, with: repeatElement(0, count: end-start))
    }
    
    static func setToZeroInRange(array: inout [Double], start: Int = 0) {
        setToZeroInRange(array: &array, start: start, end: array.count)
    }
}
