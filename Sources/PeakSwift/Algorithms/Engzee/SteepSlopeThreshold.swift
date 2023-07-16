//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 16.07.23.
//

import Foundation

class SteepSlopeThreshold {
    
    var M = 0.0
    let MM = FixSizedQueue<Double>(size: 5)
    let MSlope: [Double]
    let signal: [Double]
    var newM5: Double?
    
    let sampleIntervalCalculator: SampleIntervalCalculator
    
    init(signal: [Double], samplingFrequency: Double) {
        self.sampleIntervalCalculator = SampleIntervalCalculator(samplingFrequency: samplingFrequency)
        let ms1000 = self.sampleIntervalCalculator.getSampleInterval(ms: 1000)
        self.MSlope = MathUtils.linespace(start: 1.0, end: 0.6, numberElements: ms1000)
        self.signal = signal
    }
    
    func initialize(sample: Int) {
        M = 0.6 * MathUtils.maxInRange(signal, from: 0, to: sample+1)
        MM.append(M)
    }
    
    func trackBefore200ms(sample: Int, lastQRS: Int) {
        newM5 = 0.6 * MathUtils.maxInRange(signal, from: lastQRS, to: sample)
        
        if newM5! > 1.5 * MM.values[elementFromEnd: -1] {
            newM5 = 1.1 * MM.values[elementFromEnd: -1]
        }
    }
    
    func trackAt200ms(sample: Int) {
        
        guard let newM5 = newM5 else {
            return
        }
        
        MM.append(newM5)
        M = MathUtils.mean(MM.values)
    }
    
    func trackBetween200msAnd1200ms(sample: Int, lastQRS: Int) {
        let ms200 = self.sampleIntervalCalculator.getSampleInterval(ms: 200)
        self.M = MathUtils.mean(MM.values) * MSlope[sample - (lastQRS + ms200)]
    }
    
    func trackAfter1200ms() {
        M = 0.6 * MathUtils.mean(MM.values)
    }
    
}
