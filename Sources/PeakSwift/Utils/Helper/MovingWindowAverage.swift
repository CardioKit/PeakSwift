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
    
    
    /// Calculates moving window average with a basic approach but includes a padding at start and end of the signal
    ///
    /// Inspired by interface of scipy.ndimage.uniform_filter1d(...)
    /// Source: https://docs.scipy.org/doc/scipy/reference/generated/scipy.ndimage.uniform_filter1d.html
    ///
    /// - Parameters:
    ///     - signal: signal to calculate the average
    ///     - windowSize: the size of the window to calculate the average
    ///
    /// - Returns:
    ///     - [Double]: The moving average of the signal
    ///
    /// - Example:
    ///    windowSize = 3 and signal = [1,2,3,4,5,6] 
    ///    [1,2,3,4,5,6] # index 0, Reflect 1 : [1,1,2] -> average: 4/3 = 1 // Note the first 1 is added via padding
    ///    [1,2,3,4,5,6] # index 1, [1,2,3] -> average: 6/3 = 2
    ///    [1,2,3,4,5,6] # index 2, [2,3,4] -> average: 9/3 = 3
    ///    [1,2,3,4,5,6] # index 3, [3,4,5] -> average: 12/3 = 4
    ///    [1,2,3,4,5,6] # index 4, [4,5,6] -> average: 15/3 = 5
    ///    [1,2,3,4,5,6] # index 5, Reflect 6 : [5,6,6] -> average: 17/3 = 5
    ///
    static func movingWindowAverageSimple(signal: [Double], windowSize: Int) -> [Double] {
        
        if signal.isEmpty {
            return signal
        }
        
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
