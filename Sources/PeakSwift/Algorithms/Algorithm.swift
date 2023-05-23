//
//  File.swift
//  
//
//  Created by x on 23.05.23.
//

import Foundation

protocol Algorithm {
    
    func processSignal(electrocardiogram: Electrocardiogram) -> ElectrocardiogramResult
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double]
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [Int]
    
}

extension Algorithm {
    
    func processSignal(electrocardiogram: Electrocardiogram) -> ElectrocardiogramResult {
        let cleanedSignal = self.preprocessSignal(ecgSignal: electrocardiogram.ecg, samplingFrequency: electrocardiogram.samplingRate)
        let rPeaks = self.detectPeaks(ecgSignal: cleanedSignal, samplingFrequency: electrocardiogram.samplingRate)
        return .init(rPeaks: rPeaks, electrocardiogram: electrocardiogram)
    }
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        // Empty default implementation
        return ecgSignal
    }
}
