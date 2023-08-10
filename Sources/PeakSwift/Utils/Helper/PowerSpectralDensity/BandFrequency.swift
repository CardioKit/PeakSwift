//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 05.08.23.
//

import Foundation

struct BandFrequency {
    
    let minFrequency: Double
    let maxFrequency: Double
    
    init(minFrequency: Double, maxFrequency: Double) {
        self.minFrequency = min(minFrequency,maxFrequency)
        self.maxFrequency = max(minFrequency,maxFrequency)
    }
}
