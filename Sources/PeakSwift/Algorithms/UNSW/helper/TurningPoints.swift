//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 26.07.23.
//

import Foundation

enum TurningPoints {
    
    
    /// This functions returns all peaks in the signal that have a prominence > threshold
    /// - Parameters:
    ///   - feature: SIgnal or vector to find the peaks
    ///   - threshold: Threshold to filter the prominence of the peaks
    /// - Returns: Indices of postions of filtered peaks in the signal
    static func calculateTurningPoints(feature: [Double], threshold: Double) -> [Int] {
        // Note. Original implementation is using here an internal turning point function, which is filtering all peaks by for 2 nearest though of a peak => peak.height - through.height > threshold
        // Seems to be an analog function as to calculate prominences and then filter by minimal prominence
        // Therefore, the already implemented function (findAllPeaksAndProminences(...)) is chosen, since it yields the same results
        // If bugs occur consider to reimplement the original implementation
        let peaks = PeakUtils.findAllPeaksAndProminences(signal: feature, minProminence: threshold).peakPosition
        return peaks
    }
}
