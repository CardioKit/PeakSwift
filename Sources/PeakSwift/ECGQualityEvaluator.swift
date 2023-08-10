//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 10.08.23.
//

import Foundation

public class ECGQualityEvaluator {
    
    private let ecgQualityFactory = ECGQualityFactory()
    
    public func evaluateECGQuality(electrocardiogram: Electrocardiogram, algorithm: ECGQualityAlgorithms) -> ECGQualityRating {
        let algorithm = ecgQualityFactory.createECGQualityAlgorithm(algorithm: algorithm)
        return algorithm.evaluateECGQuality(signal: electrocardiogram.ecg, samplingFrequency: electrocardiogram.samplingRate)
    }
}
