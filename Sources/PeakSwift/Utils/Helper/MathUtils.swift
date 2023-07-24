//
//  File.swift
//  
//
//  Created by x on 04.06.23.
//

import Foundation
import Accelerate

enum MathUtils {
    
    static func maxInRange(_ array: [Double], from: Int, to: Int) -> Double{
        let arraySlice = array[from...to-1]
        return vDSP.maximum(arraySlice)
    }
    
    static func mean(_ array: [Double]) -> Double {
        return vDSP.mean(array)
    }
    

    static func max(_ array: [Double]) -> Double {
        return vDSP.maximum(array)
    }

    static func mean(_ array: [Int]) -> Double {
        let sum = array.reduce(0, +)
        return Double(sum) / Double(array.count)
    }
    
    static func diff(_ input: [Double]) -> [Double] {
        
        let vectorSlice1 = input[1...input.count-1]
        let vectorSlice2 = input[0...(input.count-2)]
        return vDSP.subtract(vectorSlice1, vectorSlice2)
    }
    
    static func absolute(_ array: [Double]) -> [Double] {
        return vDSP.absolute(array)
    }
    
    /// Calculates the gradient of a 1 dimensional array
    ///
    /// Inspired by numpy.gradient(...), but restricted to 1 dimension and requires the data to be evenly spaced
    /// Source: https://numpy.org/doc/stable/reference/generated/numpy.gradient.html
    /// - Parameters:
    ///    - array: Input vector
    /// - Returns: Gradient of the vector
    ///
    /// - Example:
    ///    Input:  array: [1, 2, 4, 7, 11, 16] (below named y)
    ///
    ///    out[0] = (y[1]-y[0])/1 = (2-1)/1  = 1
    ///    out[1] = (y[2]-y[0])/2 = (4-1)/2  = 1.5
    ///    out[2] = (y[3]-y[1])/2 = (7-2)/2  = 2.5
    ///    out[3] = (y[4]-y[2])/2 = (11-4)/2 = 3.5
    ///    out[4] = (y[5]-y[3])/2 = (16-7)/2 = 4.5
    ///    out[5] = (y[5]-y[4])/1 = (16-11)/1 = 5
    ///
    ///    Output: out=[ 1. ,  1.5,  2.5,  3.5,  4.5,  5. ]
    static func gradient(_ array: [Double]) -> [Double] {
        
        #warning("Add error handling")
        // TODO: Add error handling if array<2
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
    
    static func divideScalar(_ array: [Double], _ scalar: Double) -> [Double] {
        return vDSP.divide(array, scalar)
    }
    
    static func subtractVectors(_ v1: ArraySlice<Double>, _ v2: ArraySlice<Double>) -> [Double] {
        return vDSP.subtract(v1, v2)
    }
    
    #warning("Make proper random access collection interface collection")
    static func subtractVectors(_ v1: [Double], _ v2: [Double]) -> [Double] {
        return vDSP.subtract(v1, v2)
    }
    
    static func subtractVectors<C: RandomAccessCollection>(_ v1: C, _ v2: C) -> [Int] where C.Element == Int {
        return zip(v1,v2).map {
            (x,y) in x - y
        }
    }
    
    #warning("Make proper random access collection interface collection")
    static func mulVectors(_ v1: [Double], _ v2: [Double]) -> [Double] {
        return vDSP.multiply(v1, v2)
    }
    
    static func mulScalar(_ vector: [Int], _ scalar: Int) -> [Int] {
        return vector.map {
            $0 * scalar
        }
    }
    static func square(_ array: [Double]) -> [Double] {
        return vDSP.square(array)
    }
    
    static func floorDevision(_ x: Double, _ y: Double) -> Double {
        return floor(x / y)
    }
    
    // Swift doesn't have a good in-build function to power Integer
    // For sake not loosing precision provide a special function for powering with base 2
    static func powerBase2(exponent: Int) -> Int {
        return 2 << (exponent - 1)
    }
    
    static func isEven(_ number: Int) -> Bool {
        return number % 2 == 0
    }
    
}
