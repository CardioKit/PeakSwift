//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation


enum Baseline {
    
    
    
    /// Calculates linear trend of the signal and removes from the source signal
    /// - Parameter signal: signal to remove linear trend
    /// - Returns: signal without linear trend
    static func detrend(signal: [Double]) -> [Double] {
        let trend = calculateLinearTread(signal: signal)
        
        return MathUtils.subtractVectors(signal, trend)
    }
    
    /// Calculates the linear trend of a signal
    /// - Parameter signal: signal to calculate the trend
    /// - Returns: Detrended signal
    static func calculateLinearTread(signal: [Double]) -> [Double] {
        
        let (sumX, sumY) = calculateSharedCoeff(signal)
        let slope = calculateSlope(signal, sumX: sumX, sumY: sumY)
        let offset = calculateOffset(signal, slope: slope, sumX: sumX, sumY: sumY)
        
        return (1...signal.count).map { x in
            slope * Double(x) + offset
        }
    }
    
    static private func calculateSlope(_ vector: [Double],  sumX: Double, sumY: Double) -> Double {
        let n = Double(vector.count)

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
    
    static private func calculateOffset(_ vector: [Double], slope: Double, sumX: Double, sumY: Double) -> Double {
        let n = Double(vector.count)

        return (sumY - slope * sumX) / n
    }
    
    static private func calculateSharedCoeff(_ vector: [Double]) -> (sumX: Double, sumY: Double) {
        let n = Double(vector.count)
        
        let sumX = (n/2.0) * (n + 1)
        let sumY = MathUtils.sum(vector)
        
        return (sumX: sumX, sumY: sumY)
    }
}
