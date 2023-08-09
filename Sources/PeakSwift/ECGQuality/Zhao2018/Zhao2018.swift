//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation


class Zhao2018: ECGQuality {
    
    let mode: Zhao2018Mode
    
    init(mode: Zhao2018Mode) {
        self.mode = mode
    }
    
    func evaluateECGQuality(signal: [Double], samplingFrequency: Double, rPeaks: [Int]) -> ECGQualityRating {
        let (kurtosis, pSQI, baSQI) = calculateScores(ecgSignal: signal, samplingFrequency: samplingFrequency)
        return self.mode.evaluateECGQuality(samplingFrequency: samplingFrequency, rPeaks: rPeaks, pSQI: pSQI, kSQI: kurtosis, baSQI: baSQI)
    }
    
    private func calculateScores(ecgSignal: [Double], samplingFrequency: Double) -> (kurtosis: Double, pSQI: Double, baSQI: Double) {
        let kurtosis = calculateKurtosis(ecgSignal: ecgSignal)
        let pSQI = calculatePSQI(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        let baSQI = calculateBaSQI(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        
        return (kurtosis: kurtosis, pSQI: pSQI, baSQI: baSQI)
    }
    
    private func calculateKurtosis(ecgSignal: [Double]) -> Double {
        return Kurtosis.kurtosis(ecgSignal)
    }
    
    private func calculatePSQI(ecgSignal: [Double], samplingFrequency: Double) -> Double {
        let bandFrequencyNumerator = BandFrequency(minFrequency: 5, maxFrequency: 15)
        let bandFrequencyDenominator = BandFrequency(minFrequency: 5, maxFrequency: 40)
        let bandFrequencies = [bandFrequencyNumerator, bandFrequencyDenominator]
        
        let powerOfSignal = SignalPower.calculatePowerOfSignalForBandFrequencies(signal: ecgSignal, samplingFrequency: samplingFrequency, bandFrequencies: bandFrequencies)
        
        let powerOfSignalNumerator = powerOfSignal[0].power
        let powerOfSignalDenominator = powerOfSignal[1].power
        
        return powerOfSignalNumerator / powerOfSignalDenominator
    }
    
    private func calculateBaSQI(ecgSignal: [Double], samplingFrequency: Double) -> Double {
        let bandFrequencyNumerator = BandFrequency(minFrequency: 0, maxFrequency: 1)
        let bandFrequencyDenominator = BandFrequency(minFrequency: 0, maxFrequency: 40)
        let bandFrequencies = [bandFrequencyNumerator, bandFrequencyDenominator]
        
        let powerOfSignal = SignalPower.calculatePowerOfSignalForBandFrequencies(signal: ecgSignal, samplingFrequency: samplingFrequency, bandFrequencies: bandFrequencies)
        
        let powerOfSignalNumerator = powerOfSignal[0].power
        let powerOfSignalDenominator = powerOfSignal[1].power
        
        return 1 - (powerOfSignalNumerator / powerOfSignalDenominator)
    }
    
    
}
