//
//  File.swift
//  
//
//  Created by Carmen on 08.03.23.
//

import Foundation

/// DOI: 10.1109/JTEHM.2018.2878000
class Nabian2018: Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        // Preprocessing
        // TODO: apply bandpass filter instead
        let filteredSignal = Lowpass.applyLowPassFilter(ecgSignal, cutoffFrequency: 0.2, sampleRate: samplingFrequency)
        let derivativeSignal = Derivative.applyDerivativeFilter(filteredSignal)
        return derivativeSignal
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        var rPeaks: Set<UInt> = Set()
        
        let windowSize = Int(0.4 * samplingFrequency)
        
        for i in stride(from: 1 + windowSize, to: ecgSignal.count - windowSize, by: windowSize) {
            let ecgWindow = ecgSignal[(i - windowSize)..<(i + windowSize)]
            
            let rPeak = ecgWindow.argmax()!
            let min = ecgWindow.argmin()!
            
            // if global max is not followed by global min in 100ms, it's not an r peak
            if min > rPeak && min < rPeak + Int(0.1 * samplingFrequency) {
                // R Peak must be before the global min
                rPeaks.insert(UInt(rPeak))
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
