//
//  File.swift
//  
//
//  Created by x on 04.06.23.
//

import Foundation
import Accelerate
import Surge

enum MathUtils {
    
    static func maxInRange(_ array: [Double], from: Int, to: Int) -> Double{
        let arraySlice = array[from..<to]
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
    
    static private func sliceForDiff<C: Collection>(_ input: C, order: Int = 1) -> (C.SubSequence, C.SubSequence) where C.Index == Int {
        // Ensure that order is not out of bounds
        let orderInRange = Swift.max(0, min(order, input.count-1))
        
        let vectorSlice1 = input[orderInRange...input.count-1]
        let vectorSlice2 = input[0...(input.count-1-orderInRange)]
        
        return (vectorSlice1, vectorSlice2)
        
    }
    
    static func diff<C: Collection>(_ input: C, order: Int = 1) -> [C.Element] where C.Element: AdditiveArithmetic & Comparable & BinaryInteger, C.Index == Int {
        let (vectorSlice1, vectorSlice2) = sliceForDiff(input, order: order)
        return MathUtils.subtractVectors(vectorSlice1, vectorSlice2)
    }
    
    static func diff(_ input: [Double], order: Int = 1) -> [Double] {
        let (vectorSlice1, vectorSlice2) = sliceForDiff(input, order: order)
        return MathUtils.subtractVectors(vectorSlice1, vectorSlice2)
    }
    
    static func subtractVectors<C: Collection>(_ v1: C, _ v2: C) -> [C.Element] where C.Element: AdditiveArithmetic & Comparable & BinaryInteger {
        return zip(v1,v2).map {
            (x,y) in x - y
        }
    }
    
    static func subtractVectors(_ v1: [Double], _ v2: [Double]) -> [Double] {
        return MathUtils.subtractVectors(v1[...], v2[...])
    }
    
    static func subtractVectors(_ v1: ArraySlice<Double>, _ v2: ArraySlice<Double>) -> [Double] {
        return vDSP.subtract(v1, v2)
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
    
    static func subtractScalar(_ array: [Double], _ scalar: Double) -> [Double] {
        // vDSP doesn't have a anolog for substarct
        return vDSP.add(-scalar, array)
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
    
    static func isEven(_ number: Int) -> Bool {
        return number % 2 == 0
    }
    
    static func sum(_ vector: [Double]) -> Double {
        return vDSP.sum(vector)
    }
    
    
    static func addVectors(_ v1: [Double], _ v2: [Double]) -> [Double] {
        return vDSP.add(v1, v2)
    }
    
    static func sqrt(_ vector: [Double]) -> [Double] {
        return vForce.sqrt(vector)
    }
    
    static func linespace(start: Double, end: Double, numberElements: Int) -> [Double] {
        let stepInterval = (end-start) / Double(numberElements - 1)
        return  Array(stride(from: start, through: end, by: stepInterval))
    }
    
    /// Calculates power of base 2 by an exponent
    ///
    /// Swift doesn't have a good in-build function to power Integer
    /// For sake not loosing precision provide a special function for powering with base 2
    /// - Parameter exponent: must be positive or zero!
    /// - Returns: 2^(exponent)
    static func powerBase2(exponent: Int) -> Int {
        
        guard exponent >= 0 else {
            fatalError("powerBase2 supports only positive exponents (including zero)")
        }
        
        return 2 << (exponent - 1)

    }
    
    static func mean(ofMatrix matrixValues: [[Double]]) -> [Double] {
        // Avoid to divide by zero
        let outputSize = Swift.max(matrixValues.count, 1)
        let sumOfAllRows: Vector = sumOfRows(ofMatrix: matrixValues)
        let mean = sumOfAllRows / Double(outputSize)
        
        return mean.scalars
    }
    
    private static func sumOfRows(ofMatrix matrixValues: [[Double]]) -> Vector<Double> {
        let matrix = Matrix(matrixValues)
        let outputSize = matrix.rows
        let identityVector = Vector([Double](repeating: 1, count: outputSize))
        return identityVector * matrix
    }
    
    static func sumOfRows(ofMatrix matrixValues: [[Double]]) -> [Double] {
        sumOfRows(ofMatrix: matrixValues).scalars
    }

    
    static func pow(bases: [Double], exponent: Double) -> [Double] {
        let exponents = [Double](repeating: exponent, count: bases.count)
        return vForce.pow(bases: bases, exponents: exponents)

    }
    
    static func argMaxAndMaximum(_ vector: [Double]) -> (maxValue: Double, argMax: Int) {
        var maxValue: Double = 0.0
        var argMax: vDSP_Length = 0
        vDSP_maxviD(vector, 1, &maxValue, &argMax, vDSP_Length(vector.count))
        return (maxValue: maxValue, argMax: Int(argMax))
    }
}
