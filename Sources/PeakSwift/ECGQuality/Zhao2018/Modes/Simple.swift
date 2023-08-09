//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation

class Simple: Zhao2018Mode {
    
    func evaluateECGQuality(rPeaks: [Int], pSQI: Double, kSQI: Double, baSQI: Double) -> Double {
        
        
        return 0
    }
    
    private func getECGRate(rPeaks: [Int]) -> Double {
        if rPeaks.count > 1 {
            let minRRInterval = MathUtils.diff(rPeaks).min() ?? 0
            return 60000.0 / (1000.0 / Double(minRRInterval))
        } else {
            return 1
        }
    }
}
