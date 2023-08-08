//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.08.23.
//

import Foundation
import Accelerate

enum IntegralUtils {
    
    static func applyTrapezoidal(_ numbers: [Double], stepSize: Double) -> Double {
        var trapez = [Double](repeating: 0.0, count: numbers.count)
        vDSP.integrate(numbers, using: .trapezoidal, stepSize: stepSize, result: &trapez)        
        return trapez.last ?? 0
    }
}
