//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 08.08.23.
//

import Foundation

protocol ECGQuality {
    
    func evaluateECGQuality(signal: [Double], samplingFrequency: Double, rPeaks: [Int]) -> ECGQualityRating
}
