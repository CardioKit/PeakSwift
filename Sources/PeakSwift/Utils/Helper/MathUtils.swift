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
    
    static func mean(array: [Int]) -> Double {
        // I don't think that makes sense, since we could just calculate the mean
        let convertedArray = array.map {
            number in
                Double(number)
        }

        return vDSP.mean(convertedArray)
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
