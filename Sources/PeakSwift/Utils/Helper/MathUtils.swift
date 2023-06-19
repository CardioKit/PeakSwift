//
//  File.swift
//  
//
//  Created by x on 04.06.23.
//

import Foundation
import Accelerate

class MathUtils {
    
    static func maxInRange(array: [Double], from: Int, to: Int) -> Double{
        let arraySlice = array[from...to-1]
        let arrayInRange = Array(arraySlice)
        return vDSP.maximum(arrayInRange)
    }
    
    static func mean(array: [Double]) -> Double {
        return vDSP.mean(array)
    }
    
    static func max(array: [Double]) -> Double {
        return vDSP.maximum(array)
    }
}
