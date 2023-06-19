//
//  File.swift
//  
//
//  Created by x on 18.06.23.
//

import Foundation
import Accelerate


class MovingWindowAverage {
    
    static func findPeaksMovingWindowAverage(signal: [Double], windowSize: UInt) -> [Double] {
//        var movingSum = [Double](repeating: .nan,
//                              count: signal.count)
//        let vDSPWindowSize = vDSP_Length(windowSize)
//        let movingSumCount = vDSP_Length(signal.count) - windowSize + 1
//        let stride = vDSP_Stride(1)
//
//        vDSP_vrsumD(signal, stride, &movingSum, 0.0, stride, vDSP_Length(signal.count))
//
//
//        vDSP_vswsumD(signal, stride,
//                     &movingSum, stride,
//                     movingSumCount,
//                     vDSPWindowSize)
//        return vDSP.divide(movingSum, Double(windowSize))
        
        var cumulativeSum: [Double] = []
           var sum: Double = 0.0

           for (index, value) in signal.enumerated() {
               sum += value
               if index >= windowSize {
                   sum -= signal[index - Int(windowSize)]
               }
               cumulativeSum.append(sum / Double(min(index + 1, Int(windowSize))))
           }

           return cumulativeSum
    }
}
