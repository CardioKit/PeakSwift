//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

enum UNSWFilter {
    
    
    /// Wrapper function that ensures that if bCoeff are too small that the linear filter is not applied but a default result returned
    /// - Parameters:
    ///   - bCoeff: bCoeff list of the b/a filter
    ///   - aCoeff: aCoeff of the b/a filter
    ///   - signal: signal to filter
    /// - Returns: filtered signal
    static func applyLinearFilterForwardBackward(bCoeff: [Double], aCoeff: Double, signal: [Double]) -> [Double] {
        
        // Assumes aCoeff.count == 1, otherwise add condition 3*max(bCoeff-1, aCoeff-1)
        if signal.count <= 3 * (bCoeff.count - 1) {
            return [Double](repeating: 0.0, count: signal.count)
        } else {
            return LinearFilter.applyLinearFilterForwardBackwards(signal: signal, b: bCoeff, a: aCoeff)
        }
    }
}
