//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation
import Accelerate


#warning("TODO: Use vDSP")
enum Baseline {
    
    static func detrend(signal: [Double]) -> [Double] {
        let trend = calculateLinearTread(signal: signal)
        
        #warning("TODO: Use MathUtils instead")
        return vDSP.subtract(signal, trend)
    }
    
    static func calculateLinearTread(signal: [Double]) -> [Double] {
        let slope = calculateSlope(signal)
        let offset = calculateOffset(signal, slope: slope)
        
        return (1...signal.count).map { x in
            slope * Double(x) + offset
        }
    }
    
    static private func calculateSlope(_ vector: [Double]) -> Double {
        let n = Double(vector.count)
        let sumY = vector.reduce(0, +)
        let sumX = (n/2.0) * (n + 1)
        let mulXY = vector.enumerated().reduce(0) { (prev, nextItem) in
            let (index, value) = nextItem
            return prev + Double(index+1)*value
        }
                                               
        
        
        let sumXSquaredSeries = (n / 6) * (2 * n + 1) * (n + 1)
        
        let sumXSquared = pow(sumX, 2)
        
        let numerator = n * mulXY - sumX * sumY
        let denumerator = n * sumXSquaredSeries - sumXSquared
        
        return numerator / denumerator
    }
    
    static private func calculateOffset(_ vector: [Double], slope: Double) -> Double {
        let n = Double(vector.count)
        
        let sumY = vector.reduce(0, +)
        let sumX = (n/2.0) * (n + 1)

        return (sumY - slope * sumX) / n
    }
}
