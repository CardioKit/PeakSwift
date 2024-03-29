//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation
import Accelerate

class TwoAverage : Algorithm {
    
    func preprocessSignal(ecgSignal: [Double], samplingFrequency: Double) -> [Double] {
        Butterworth().butterworth(signal: ecgSignal, order: .two, lowCutFrequency: 8, highCutFrequency: 20, sampleRate: samplingFrequency)
    }
    
    func detectPeaks(ecgSignal: [Double], samplingFrequency: Double) -> [UInt] {
        
        let window1 = Int(0.12 * samplingFrequency)
        let window2 = Int(0.6 * samplingFrequency)
        
        let absoluteEcgSignal = MathUtils.absolute(ecgSignal)
        
        let movingAverageQRS = MovingWindowAverage.movingWindowAverageCumulative(signal: absoluteEcgSignal, windowSize: window1)
        let movingAverageBeat = MovingWindowAverage.movingWindowAverageCumulative(signal: absoluteEcgSignal, windowSize: window2)
        
        let blockHeight = MathUtils.max(ecgSignal)
        
        let blockSize = Int(0.08 * samplingFrequency)
        let minRRInterval =  Int(0.3 * samplingFrequency)
        
        var rPeaks: [Int] = []
        
        var start = 0
        var end = 0
        
        let calcBlockSize = {
            (index: Int) -> Double in
            movingAverageQRS[index] > movingAverageBeat[index] ? blockHeight : 0
        }
        
        var blocks: [Double] = [ calcBlockSize(0) ]
        
        
        for i in 1...(ecgSignal.count - 1) {
            
            let currentBlock = calcBlockSize(i)
            blocks.append(currentBlock)
            
            if blocks[i - 1] == 0, blocks[i] == blockHeight {
                start = i
            } else if blocks[i-1] == blockHeight, blocks[i] == 0 {
                end = i - 1
                
                if end - start > blockSize {
                    let detection: Int = ecgSignal[start...end].argmax() ?? 0 + start
                    if let lastRPeak = rPeaks.last {
                        if detection - lastRPeak > minRRInterval {
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
                                                            
    
}
