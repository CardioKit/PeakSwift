//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.08.23.
//

import Foundation


enum SignalPower {
    
    static func calculatePowerOfSignalForBandFrequencies(signal: [Double], samplingFrequency: Double, bandFrequencies: [BandFrequency]) -> [BandFrequencyPower] {
        
        let (minFrequency, maxFrequency) = self.findMinMaxBandFrequency(bandFrequencies: bandFrequencies)
        
        let psd = PowerSpectrumDensityCalculator.estimatePowerSpectralDensity(signal: signal, samplingRate: samplingFrequency)
        
        let filteredPSD = psd.filter(minFrequency: minFrequency, maxFrequency: maxFrequency)
        
        let bandFrequenciesPower = bandFrequencies.map { bandFrequency in
            calculatePowerOfSignalForBandFrequency(powerSprectrumDensity: filteredPSD, bandFrequency: bandFrequency)
        }
        
        return bandFrequenciesPower
        
    }
    
    private static func findMinMaxBandFrequency(bandFrequencies: [BandFrequency]) -> (minFrequency: Double, maxFrequency: Double) {
        let min = bandFrequencies.min { b1, b2 in
            b1.minFrequency < b2.minFrequency
        }?.minFrequency ?? 0
        
        let boundedMin = min > 0 ? min : 0.001
        
        let max = bandFrequencies.max { b1, b2 in
            b1.maxFrequency < b2.maxFrequency
        }?.maxFrequency ?? 0
        
        return (minFrequency: boundedMin, maxFrequency: max)
    }
    
    
    private static func calculatePowerOfSignalForBandFrequency(powerSprectrumDensity: PowerSpectralDensity, bandFrequency: BandFrequency) -> BandFrequencyPower {
        let psdInBandFrequency = powerSprectrumDensity.filter(minFrequency: bandFrequency.minFrequency, maxFrequency: bandFrequency.maxFrequency)
        
        let power = psdInBandFrequency.power
        let frequencyStep = psdInBandFrequency.frequencyStepSize
        
        let integralOfPower = IntegralUtils.applyTrapezoidal(power, stepSize: frequencyStep)
        return BandFrequencyPower(bandFrequency: bandFrequency, power: integralOfPower)
    }
}
