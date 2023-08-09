//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation

protocol Zhao2018Mode {
    
    func evaluateECGQuality(samplingFrequency: Double, rPeaks: [Int], pSQI: Double, kSQI: Double, baSQI: Double) -> ECGQualityRating 
}
