//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 01.07.23.
//

import Foundation

class PanTompkins: Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        let cleanedSignal = Butterworth().butterworth(signal: ecgSignal, order: .one, lowCutFrequency: 5, highCutFrequency: 15, sampleRate: samplingFrequency)
        return cleanedSignal
    }
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        let diff = MathUtils.diff(ecgSignal)
        let squared = MathUtils.square(diff)
        
        let windowSize = Int(0.12 * samplingFrequency)
        var movingWindowAvereage = MovingWindowAverage.movingWindowAverageCumulative(signal: squared, windowSize: windowSize)
        
        let zeroPadding = Int(0.2 * samplingFrequency)
        VectorUtils.setToZeroInRange(array: &movingWindowAvereage, end: zeroPadding)
        
        let movingWindowAveragePeaks = PeakUtils.findPeaks(signal: movingWindowAvereage, samplingRate: samplingFrequency)
        
        return movingWindowAveragePeaks.map { UInt($0) }
    }
    
    
}
