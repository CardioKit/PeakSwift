//
//  File.swift
//  
//
//  Created by Carmen on 08.03.23.
//

import Foundation

/// DOI: 10.1109/JTEHM.2018.2878000
class Nabian2018 {
    
    func detectRPeaks(ecgSignal: [Double], samplingRate: Double) -> [Int] {
        // Preprocessing
        // TODO: apply bandpass filter instead
        let filteredSignal = Lowpass.applyLowPassFilter(ecgSignal, cutoffFrequency: 0.2, sampleRate: samplingRate)
        let derivativeSignal = Derivative.applyDerivativeFilter(filteredSignal)
        

        var rPeaks: Set<Int> = Set()
        
        let windowSize = Int(0.4 * samplingRate)
        
        for i in stride(from: 1 + windowSize, to: ecgSignal.count - windowSize, by: windowSize) {
            let ecgWindow = derivativeSignal[(i - windowSize)..<(i + windowSize)]
            
            let rPeak = ecgWindow.argmax()!
            let min = ecgWindow.argmin()!
            
            // if global max is not followed by global min in 100ms, it's not an r peak
            if min > rPeak && min < rPeak + Int(0.1 * samplingRate) {
                // R Peak must be before the global min
                rPeaks.insert(rPeak)
            }
            
        }

        return Array(rPeaks).sorted()
    }
}

extension ArraySlice where Element: Comparable {
    func argmax() -> Index? {
        return indices.max(by: {self[$0] < self[$1] })
    }
}


extension ArraySlice where Element: Comparable {
    func argmin() -> Index? {
        return indices.min(by: {self[$0] < self[$1] })
    }
}
