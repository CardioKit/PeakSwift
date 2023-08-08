//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation


class Zhao2018: ECGQuality {
    
    let mode: Zhao2018
    
    init(mode: Zhao2018) {
        self.mode = mode
    }
    
    func evaluateECGQuality(signal: [Double], samplingFrequency: Double, rPeaks: [Double]) {
        let (kurtosis, pSQI, baSQI) = calculateScores(ecgSignal: signal, samplingFrequency: samplingFrequency)
    }
    
    private func calculateScores(ecgSignal: [Double], samplingFrequency: Double) -> (kurtosis: Double, pSQI: Double, baSQI: Double) {
        let kurtosis = calculateKurtosis(ecgSignal: ecgSignal)
        let pSQI = calculatePSQI(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        let baSQI = calculateBaSQI(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
        
        return (kurtosis: kurtosis, pSQI: pSQI, baSQI: baSQI)
    }
    
    private func calculateKurtosis(ecgSignal: [Double]) -> Double {
        return 0
    }
    
    private func calculatePSQI(ecgSignal: [Double], samplingFrequency: Double) -> Double {
        return 0
    }
    
    private func calculateBaSQI(ecgSignal: [Double], samplingFrequency: Double) -> Double {
        return 0
    }
    
    
}
