//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

enum Welch {
    
    func estimatePowerSpectralDensity(signal: [Double], samplingFrequency: Double, nperseg: Int, noverlap: Int?, nFfft: Int, windowSize: Int) {
        
        let noverlap = noverlap ??  nperseg / 2
        
        let nstep = nperseg - noverlap
        
        let windowSequency = Windows.createWindow(windowSize: windowSize, windowSequency: .hann)
        let scale = calculateScalingFactor(samplingFequency: samplingFrequency, windowSequency: windowSequency)
        
        
    }
    
    private func calculateScalingFactor(samplingFequency: Double, windowSequency: [Double]) -> Double {
        let squaredWindow = MathUtils.square(windowSequency)
        let windowSum = MathUtils.sum(squaredWindow)
        return 1.0 / (samplingFequency * windowSum)
    }
}
