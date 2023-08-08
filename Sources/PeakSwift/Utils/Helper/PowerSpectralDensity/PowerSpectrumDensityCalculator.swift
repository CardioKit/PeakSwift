//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.08.23.
//

import Foundation


enum PowerSpectrumDensityCalculator {
    
    static func estimatePowerSpectralDensity(signal: [Double], samplingRate: Double) -> PowerSpectralDensity {
        
        let windowLength: Double = 1024.0
        let signalSize = signal.count
        
        // number of elements per segment to apply the fft
        var nperseg = Int(windowLength * samplingRate)
        
        if nperseg > signalSize / 2 {
            nperseg = Int(signalSize / 2)
        }
        
        // size of the fft operation (if larger > nperseg => zeropadd)
        let nfft = TransposedPowerOfTwo(value: nperseg)
        
        // Constant detrend
        let mean = MathUtils.mean(signal)
        let detrendSignal = MathUtils.subtractScalar(signal, mean)
        
        return Welch.estimatePowerSpectralDensity(signal: detrendSignal, samplingFrequency: samplingRate, nperseg: nperseg, noverlap: nil, nfft: nfft)
    }
}
