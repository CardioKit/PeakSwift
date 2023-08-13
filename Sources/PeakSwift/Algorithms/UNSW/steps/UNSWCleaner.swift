//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation

enum UNSWCleaner {
    
    static let startFrequency: Double = 400
    static let endFrequency: Double = 600
    
    static let windowSizeRange: Double = 0.5
    
    static func cleanSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let signalWithoutLinearTrend = Baseline.detrend(signal: ecgSignal)
        let windowSize = MathUtils.roundToInteger(windowSizeRange * samplingFrequency)
        let baseline = Sortfilt1.applySortFilt1(signal: signalWithoutLinearTrend, windowSize: windowSize, filtType: .median)
        
        let medianData = MathUtils.subtractVectors(signalWithoutLinearTrend, baseline)
        
        // UNSW uses hardcoded b/a coeff for filtering the signal in this samplingFrequency range
        if startFrequency <= samplingFrequency && samplingFrequency <= endFrequency {
            
            
            let highPassFilteredSignal = UNSWFilter.applyLinearFilterForwardBackward(bCoeff: HighPassFilterCoeff.bCoeff,
                                                                      aCoeff: HighPassFilterCoeff.aCoeff,
                                                                      signal: medianData)
            
            let lowPassFilteredSignal = Butterworth().butterworthLowPassForwardBackward(signal: highPassFilteredSignal, order: .eight, highCutFrequency: 20, sampleRate: samplingFrequency)
            return lowPassFilteredSignal
            
        } else {
            let highPassFilteredSignal = Butterworth().butterworthForwardBackward(signal: medianData, order: .seven, lowCutFrequency: 0.7, sampleRate: samplingFrequency)
            let lowPassFilteredSignal = Butterworth().butterworthLowPassForwardBackward(signal: highPassFilteredSignal, order: .seven, highCutFrequency: 20, sampleRate: samplingFrequency)
            return lowPassFilteredSignal
            
        }
    }
}
