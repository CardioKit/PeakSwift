//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 16.07.23.
//

import Foundation

class QRSTracker {
    
    var qrs: [Int] = []
    var isEmpty: Bool {
        return qrs.isEmpty
    }
    var last: Int? {
        return qrs.last
    }
    
    let sampleIntervalCalculator: SampleIntervalCalculator
    
    init(samplingFrequency: Double) {
        self.sampleIntervalCalculator = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
    }
    
    func append(_ x: Int) {
        self.qrs.append(x)
    }
    
    func isInRangeRelativeToLastQRS(sample: Int, startMs: Double = 0, endMs: Double = 0) -> Bool {
        guard let lastQRS = last else {
            return false
        }
        
        let msSampleStart = self.sampleIntervalCalculator.getSampleInterval(ms: startMs)
        let msSampleEnd = self.sampleIntervalCalculator.getSampleInterval(ms: endMs)
        
        return lastQRS + msSampleStart < sample && sample < lastQRS + msSampleEnd
    }
    
    func isAtRelativeToLastQRS(sample: Int, ms: Double = 0) -> Bool {
        guard let lastQRS = last else {
            return false
        }
        
        let msSample = self.sampleIntervalCalculator.getSampleInterval(ms: ms)
        
        return sample == lastQRS + msSample
    }
    
    func isBeforeRelativeToLastQRS(sample: Int, ms: Double = 0) -> Bool {
        guard let lastQRS = last else {
            return false
        }
        
        let msSample = self.sampleIntervalCalculator.getSampleInterval(ms: ms)
        
        return sample < lastQRS + msSample
    }
    
    func isAfterRelativeToLastQRS(sample: Int, ms: Double = 0) -> Bool {
        guard let lastQRS = last else {
            return false
        }
        
        let msSample = self.sampleIntervalCalculator.getSampleInterval(ms: ms)
        
        return sample > lastQRS + msSample
    }
    
    
}
