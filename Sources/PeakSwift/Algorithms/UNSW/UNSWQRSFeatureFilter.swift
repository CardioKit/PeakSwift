//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

enum UNSWQRSFeatureFilter {
    
    
    static func applyQRSFeatureFilter(signal: [Double], samplingRate: Double) {
        
        let hammingFiltered = self.applyHammingFilter(signal: signal, samplingRate: samplingRate)
        
        
      
    }
    
    static func applyHammingFilter(signal: [Double], samplingRate: Double) -> [Double] {
        let hammingWindowHeuristic = self.calculateHammingWindowHeuristic(samplingRate: samplingRate)
        let (bCoeff, aCoeff) = self.calcHammingFilterCoeff(hammingWindowHeuristic: hammingWindowHeuristic)
        
        return UNSWFilter.applyLinearFilterForwardBackward(bCoeff: bCoeff, aCoeff: aCoeff, signal: signal)
        
        
    }
    
    private static func calculateHammingWindowHeuristic(samplingRate: Double) -> Int {
        let cutoffFrequency = 6.0
        
        let k = ((samplingRate/2)*0.0037) / cutoffFrequency
        let hammingWindowHeuristic = MathUtils.roundToInteger(k * samplingRate)
        
        return hammingWindowHeuristic
    }
    
    private static func calcHammingFilterCoeff(hammingWindowHeuristic: Int) -> (bCoeffs: [Double], aCoeff: Double) {
        let bCoeffs = Hamming.createHammingWindow(windowSize: hammingWindowHeuristic)
        
        let bCoeffsDenominator = bCoeffs.map{abs($0)}.reduce(0.0, +)
        let bCoeffsTransformed = bCoeffs.map { b in b / bCoeffsDenominator }
        let aCoeff = 1.0
        
        return (bCoeffs: bCoeffsTransformed, aCoeff: aCoeff)
        
    }
}
