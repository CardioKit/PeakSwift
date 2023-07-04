//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation
import Accelerate


class MovingWindowAverage {
    
    static func movingWindowAverageCumulative(signal: [Double], windowSize: Int) -> [Double] {
        
        var runningSum = signal
            .reduce(into: []) { $0.append(($0.last ?? 0) + $1) }
        
        let startWindow = runningSum[windowSize...]
        let endWindow = runningSum[...(runningSum.count-windowSize-1)]
        
        let diff = vDSP.subtract(startWindow, endWindow)
        
        runningSum.replaceSubrange(windowSize..., with: diff)
        
        for i in 1..<windowSize {
            runningSum[i - 1] = runningSum[i - 1] / Double(i)
        }
        
        runningSum.replaceSubrange((windowSize-1)..., with: vDSP.divide(runningSum[(windowSize-1)...], Double(windowSize)))
        
        return runningSum
    }
    
    // TODO: check egde cases such as empty signal
    static func movingWindowAverage(signal: [Double], windowSize: Int) -> [Double] {
        
        let paddingStartSize = Int(windowSize/2)
        let paddingEndSize = windowSize % 2 == 0 ? Int(windowSize/2) - 1 : paddingStartSize
        
        let paddingFront = repeatElement(signal[0], count: paddingStartSize)
        let paddingEnd = repeatElement(signal[elementFromEnd: -1], count: paddingEndSize)
        
        let signalWithPadding = paddingFront + signal + paddingEnd
        
        let windowSum = vDSP.slidingWindowSum(signalWithPadding, usingWindowLength: windowSize)
        let windowAverage = vDSP.divide(windowSum, Double(windowSize))
        return windowAverage
    }
}
