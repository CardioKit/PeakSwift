//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation
import Accelerate

class TwoAverage : Algorithm {
    
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let window1 = UInt(0.12 * samplingFrequency)
        let window2 = UInt(0.6 * samplingFrequency)
        
        let movingAverageQRS = MovingWindowAverage.findPeaksMovingWindowAverage(signal: absolute(array: ecgSignal), windowSize: window1)
        let movingAverageBeat = MovingWindowAverage.findPeaksMovingWindowAverage(signal: absolute(array: ecgSignal), windowSize: window2)
        
        let blockHeight = MathUtils.max(array: ecgSignal)
        let blocks: [Double] = zip(movingAverageQRS, movingAverageBeat).map {
            (mwaQRS, mwaBeat) in
            mwaQRS > mwaBeat ? blockHeight : 0
        }
        
        var rPeaks: [Int] = []
        
        var start = 0
        var end = 0
        
        for i in 1...(blocks.count - 1) {
            if blocks[i - 1] == 0, blocks[i] == blockHeight {
                start = i
            } else if blocks[i-1] == blockHeight, blocks[i] == 0 {
                end = i - 1
                
                if end - start > Int(0.08 * samplingFrequency) {
                    let detection: Int = ecgSignal[start...end].argmax() ?? 0 + start
                    if let lastRPeak = rPeaks.last {
                        if detection - lastRPeak > Int(0.3 * samplingFrequency) {
                            rPeaks.append(detection)
                        }
                    } else {
                        rPeaks.append(detection)
                    }
                }
            }
        }
        
        return rPeaks.map { UInt($0) }
    }
    
                                                                    
    // copied utility function from another branch, please remove when merging
    func absolute(array: [Double]) -> [Double] {
        return vDSP.absolute(array)
    }
    
    
}
