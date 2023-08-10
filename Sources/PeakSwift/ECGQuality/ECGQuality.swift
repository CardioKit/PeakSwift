//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation

protocol ECGQuality {
    
    func evaluateECGQuality(signal: [Double], samplingFrequency: Double, rPeaks: [Int]) -> ECGQualityRating
    
    func evaluateECGQuality(signal: [Double], samplingFrequency: Double) -> ECGQualityRating

}


extension ECGQuality {
    
    func evaluateECGQuality(signal: [Double], samplingFrequency: Double) -> ECGQualityRating {
        
        let qrsDetector = QRSDetector()
        let ecg = Electrocardiogram(ecg: signal, samplingRate: samplingFrequency)
        let rPeaks = qrsDetector.detectPeaks(electrocardiogram: ecg, algorithm: .neurokit)
        #warning("Change interface to Int")
        let rPeaksInt = rPeaks.rPeaks.map { Int($0) }
                                    
        return evaluateECGQuality(signal: signal, samplingFrequency: samplingFrequency, rPeaks: rPeaksInt)
    }
}
