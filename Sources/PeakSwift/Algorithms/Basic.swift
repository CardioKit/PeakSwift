//
//  File.swift
//  
//
//  Created by Maximilian Kapsecker on 11.01.23.
//

import Foundation

class Basic: Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        // First, apply a low-pass filter to the ECG signal to remove high-frequency noise
          let filteredSignal = Lowpass.applyLowPassFilter(ecgSignal, cutoffFrequency: 0.2, sampleRate: samplingFrequency)
        // Next, apply a derivative filter to the filtered signal to highlight the R peaks
          let derivativeSignal = Derivative.applyDerivativeFilter(filteredSignal)
          return derivativeSignal
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
      // Finally, apply a threshold to the derivative signal to identify the R peaks
        return Threshold.applyThreshold(ecgSignal, threshold: 0.6)
    }
}
