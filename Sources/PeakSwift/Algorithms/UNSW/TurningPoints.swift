//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 26.07.23.
//

import Foundation

enum TurningPoints {
    
    
    static func calculateTurningPoints(feature: [Double], threshold: Double) -> [Int] {
        // Note. Original implementation is using here an internal turning point function, which is filtering all peaks by for 2 nearest though of a peak => peak.height - through.height > threshold
        // Seems to be an analog function as to calculate prominences and then filter by minimal prominence
        // Therefore, the already implemented function (findAllPeaksAndProminences(...)) is chosen, since it yields the same results
        // If bugs occur consider to reimplement the original implementation
        let peaks = PeakUtils.findAllPeaksAndProminences(signal: feature, minProminence: threshold).peakPosition
        return peaks
    }
}
