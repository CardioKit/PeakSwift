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
    
    // TODO improve performance
    static func gradient(array: [Double]) -> [Double] {
        
        let startGradient = array[1] - array[0]
        let endGradient = array[elementFromEnd: -1] - array[elementFromEnd: -2]
        
        let gradient = array.enumerated().filter {
            (index, value) in
            index > 1
        }.map {
            (index, value) in
            (array[index] - array[index-2]) / 2
        }
        return [startGradient] + gradient + [endGradient]
    }
    
    static func roundToInteger(_ num: Double) -> Int {
        return Int(round(num))
    }
    
    static func mulScalar(_ array: [Double], _ scalar: Double) -> [Double] {
        return vDSP.multiply(scalar, array)
    }
    
//    static func substractVectors<C: Slice<Double>(_ v1: C, _ v2: C) where C.Element == Double {
//        let test :[Double] = vDSP.subtract(v1, v2)
//    }
    
    static func substractVectors(_ v1: ArraySlice<Double>, _ v2: ArraySlice<Double>) -> [Double] {
        return vDSP.subtract(v1, v2)
    }
    
    // TODO: consider to optimize
    static func substractVectors<C: RandomAccessCollection>(_ v1: C, _ v2: C) -> [Int] where C.Element == Int {
        return zip(v1,v2).map {
            (x,y) in x - y
        }
    }
    
    // TODO: Consider to optimize
    static func mulScalar(_ vector: [Int], _ scalar: Int) -> [Int] {
        return vector.map {
            $0 * scalar
        }
    }
}
