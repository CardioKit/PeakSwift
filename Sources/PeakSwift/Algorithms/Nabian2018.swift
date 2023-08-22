//
//  File.swift
//  
//
//  Created by Carmen on 08.03.23.
//

import Foundation
import Accelerate

/// DOI: 10.1109/JTEHM.2018.2878000
class Nabian2018: Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        // Preprocessing
        return ecgSignal
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        var rPeaks: [Int] = []
        let windowSize = Int(0.4 * samplingFrequency)
        print(windowSize)
        for i in stride(from: (1 + windowSize), to: (ecgSignal.count - windowSize), by:1) {
            let ecgWindow = Array(ecgSignal[i - windowSize ..< i + windowSize])
            var maxValue = Double()
            var rPeak = vDSP_Length()
            vDSP_maxviD(ecgWindow, 1, &maxValue, &rPeak, vDSP_Length(ecgWindow.count))
            if i == (i - windowSize - 1 + Int(rPeak)){
                rPeaks.append(i)
            }
        }
        return rPeaks.map { r in
            UInt(r)
        }
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
