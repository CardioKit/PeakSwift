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
        return vDSP.maximum(arraySlice)
    }
    
    static func mean(array: [Double]) -> Double {
        return vDSP.mean(array)
    }
    

    static func max(array: [Double]) -> Double {
        return vDSP.maximum(array)
    }

    static func mean(array: [Int]) -> Double {
        let sum = array.reduce(0, +)
        return Double(sum) / Double(array.count)
    }
    
    static func diff(_ input: [Double]) -> [Double] {
        
        let vectorSlice1 = input[1...input.count-1]
        let vectorSlice2 = input[0...(input.count-2)]
        return vDSP.subtract(vectorSlice1, vectorSlice2)
    }
    
    static func absolute(array: [Double]) -> [Double] {
        return vDSP.absolute(array)
    }
}
