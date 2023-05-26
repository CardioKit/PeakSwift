//
//  File.swift
//  
//
//  Created by x on 23.05.23.
//

import Foundation

protocol Algorithm {
    
    func processSignal(electrocardiogram: Electrocardiogram) -> QRSResult
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double]
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt]
    
}

extension Algorithm {
    
    func processSignal(electrocardiogram: Electrocardiogram) -> QRSResult {
        let cleanedSignal = self.preprocessSignal(ecgSignal: electrocardiogram.ecg, samplingFrequency: electrocardiogram.samplingRate)
        let rPeaks = self.detectPeaks(ecgSignal: cleanedSignal, samplingFrequency: electrocardiogram.samplingRate)
        let qrsComplexes = rPeaks.map { (rPeak) -> QRSComplex in
                .init(rPeak: rPeak, qWave: nil, sWave: nil)
        }
        return .init(qrsComlexes: qrsComplexes, electrocardiogram: electrocardiogram)
    }
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        // Empty default implementation
        return ecgSignal
    }
}
