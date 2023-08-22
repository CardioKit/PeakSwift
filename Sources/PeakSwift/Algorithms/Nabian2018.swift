//
//  File.swift
//  
//
//  Created by Carmen on 08.03.23.
//

import Foundation

/// DOI: 10.1109/JTEHM.2018.2878000
class Nabian2018: Algorithm {
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        var rPeaks: [Int] = []
        let windowSize = Int(0.4 * samplingFrequency)
        
        for i in stride(from: (1 + windowSize), to: (ecgSignal.count - windowSize), by:1) {
            
            let ecgWindow = Array(ecgSignal[i - windowSize ..< i + windowSize])
            let (_, rPeak) = MathUtils.argMaxAndMaximum(ecgWindow)
            
            if i == (i - windowSize - 1 + Int(rPeak)) {
                rPeaks.append(i)
            }
            
        }
        
        return rPeaks.map { r in
            UInt(r)
        }
    }
}
