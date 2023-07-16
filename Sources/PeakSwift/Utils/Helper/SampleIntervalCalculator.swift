//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 16.07.23.
//

import Foundation

struct SampleIntervalCalculator {
    
    
    let samplingFrequency: Double
    
    func getSampleInterval(ms: Double) -> Int {
        return Int(ms/1000 * samplingFrequency)
    }
}
