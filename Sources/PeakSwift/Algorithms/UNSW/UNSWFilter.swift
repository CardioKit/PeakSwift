//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

enum UNSWFilter {
    
    static func applyLinearFilter(bCoeff: [Double], aCoeff: Double, signal: [Double]) -> [Double] {
        
        // Assumes aCoeff.count == 1, otherwise add condition 3*max(bCoeff-1, aCoeff-1)
        if signal.count <= 3 * (bCoeff.count - 1) {
            return [Double](repeating: 0.0, count: signal.count)
        } else {
            return LinearFilter.applyLinearFilterForwardBackwards(signal: signal, b: bCoeff, a: aCoeff)
        }
    }
}
