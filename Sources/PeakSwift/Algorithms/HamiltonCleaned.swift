//
//  File.swift
//  
//
//  Created by x on 28.06.23.
//

import Foundation

class HamiltonCleaned: Algorithm {
    
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        Butterworth().butterworth(signal: ecgSignal, order: 1, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: samplingFrequency)
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        Hamilton().detectPeaks(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
    }
    
    
}
