//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

enum UNSWQRSFeatureGenerator {
    
    static func doFeatureGeneration(lowPassFiltered: [Double], samplingRate: Double) -> [Double] {
        let differentiatedSignal = self.applyDifferentiator(signal: lowPassFiltered, samplingRate: samplingRate)
        
        let windowRelativeRange = 0.1
        let windowSize = MathUtils.roundToInteger(samplingRate * windowRelativeRange)
        
        let topEnvelop = Sortfilt1.applySortFilt1(signal: differentiatedSignal, windowSize: windowSize, filtType: .max)
        let bottomEnvelop = Sortfilt1.applySortFilt1(signal: differentiatedSignal, windowSize: windowSize, percentage: .min)
        let envelopAmplitude = MathUtils.subtractVectors(topEnvelop, bottomEnvelop)
       
        let envelopOnlyPositive = envelopAmplitude.map { $0 > 0 ? $0 : 0}
        
        return MathUtils.absolute(MathUtils.mulVectors(differentiatedSignal, envelopOnlyPositive))
        
        
    }
    
    static private func applyDifferentiator(signal: [Double], samplingRate: Double) -> [Double] {
        let initCoeffs: [Double] =  [1.0, 0.0, -1.0]
        let scalingCoeff = 2.0 * (1.0 / samplingRate)
        
        let diffCoeffs = MathUtils.divideScalar(initCoeffs, scalingCoeff)
        
        return LinearFilter.applyLinearFilter(signal: signal, b: diffCoeffs, a: 1)
        
    }
    
}
