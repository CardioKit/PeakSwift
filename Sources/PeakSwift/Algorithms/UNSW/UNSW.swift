//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation

class UNSW: Algorithm {
    
    #warning("Needs some sort of guard fs<50 then throw exception")
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        return UNSWCleaner.cleanSignal(ecgSignal: ecgSignal, samplingFrequency: samplingFrequency)
    }
    
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let qrsFeatures = UNSWQRSFeatureGenerator.doFeatureGeneration(lowPassFiltered: ecgSignal, samplingRate: samplingFrequency)
        let (filteredQRSFeatures, heartRateFrequency) = UNSWQRSFeatureFilter.applyQRSFeatureFilter(feature: qrsFeatures, samplingRate: samplingFrequency)
        let qrsDetector = UNSWQRSDetection(filteredFeatures: filteredQRSFeatures, samplingRate: samplingFrequency, heartRateFrequency: heartRateFrequency)
        let peaks = qrsDetector.detectQRS(sensitivity: 1.0)
        let peaksWithMissedPeaks = qrsDetector.backtrackMissingPeaks(rPeaks: peaks)
        let allPeaksWithoutFalseBeats = qrsDetector.backtrackErroneouslyPeaks(rPeaks: peaksWithMissedPeaks)
        
        return allPeaksWithoutFalseBeats.rPeaks.map { UInt($0) }
    }
    
    
    
}
