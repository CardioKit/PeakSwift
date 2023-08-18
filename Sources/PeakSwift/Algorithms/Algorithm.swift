//
//  File.swift
//  
//
//  Created by x on 23.05.23.
//

import Foundation

protocol Algorithm {
    
    func processSignal(electrocardiogram: Electrocardiogram) -> ProcessedSignal
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double]
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt]
    
}

extension Algorithm {
    
    func processSignal(electrocardiogram: Electrocardiogram) -> ProcessedSignal {
        let cleanedSignal = self.preprocessSignal(ecgSignal: electrocardiogram.ecg, samplingFrequency: electrocardiogram.samplingRate)
        let rPeaks = self.detectPeaks(ecgSignal: cleanedSignal, samplingFrequency: electrocardiogram.samplingRate)
        let qrsComplexes = rPeaks.map { (rPeak) -> QRSComplex in
                .init(rPeak: rPeak, qWave: nil, sWave: nil)
        }
        
        let cleanedECG = Electrocardiogram(ecg: cleanedSignal, samplingRate: electrocardiogram.samplingRate)
        return .init(qrsComplexes: qrsComplexes, electrocardiogram: electrocardiogram, cleanedElectrocardiogram: cleanedECG)
    }
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        // Empty default implementation
        return ecgSignal
    }
}
