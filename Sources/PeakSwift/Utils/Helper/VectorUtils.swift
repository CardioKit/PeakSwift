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
        array.replaceSubrange(start..<end, with: repeatElement(0, count: end-start))
    }
        
    static func setToZeroTilEnd(_ array: inout [Double], start: Int = 0) {
            setToZeroInRange(&array, start: start, end: array.count)
    }
    
    /// Adds padding to the vector
    /// Based on https://numpy.org/doc/stable/reference/generated/numpy.pad.html
    /// - Parameters:
    ///   - array: array to add padding
    ///   - startPaddingSize: number of values to pad at the start of the array
    ///   - endPaddingSize: number of values to pad at the end of the array
    ///   - paddingMethod: approach how to generate padding at the start/end of the array (Supported: edge). The edge method uses the first and last value at the edge to padd the signal accordingly
    /// - Returns: signal with padding
    static func addPadding(_ array: [Double], startPaddingSize: Int, endPaddingSize: Int, paddingMethod: Padding) -> [Double] {
        switch paddingMethod {
            case .edge:
            
                guard let startValue = array.first, let endValue = array.last else {
                    // no padding added to an empty array
                    return array
                }
            
                let startPadding = [Double](repeating: startValue, count: startPaddingSize)
                let endPadding = [Double](repeating: endValue, count: endPaddingSize)
            
                return startPadding + array + endPadding

        }
    }
}
