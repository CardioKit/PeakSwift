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
}
