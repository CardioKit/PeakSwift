//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 06.07.23.
//

import Foundation

struct Peaks {
    let peaks: [Peak]
    
    var peakPosition: [Int] {
        peaks.map {
            peakAndProminence in
            peakAndProminence.peak
        }
    }
    
    var peakProminences: [Double] {
        peaks.map {
            peakAndProminence in
            peakAndProminence.prominence
        }
    }
    
    var mostProminentPeak: Peak? {
        peaks.max {
            (peak1, peak2) in
            peak1.prominence < peak2.prominence
        }
    }
}

struct Peak {
    
    let peak: Int
    let prominence: Double
}
