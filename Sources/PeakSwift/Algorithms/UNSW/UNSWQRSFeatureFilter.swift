//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation

enum UNSWQRSFeatureFilter {
    
    
    static func applyQRSFeatureFilter(feature: [Double], samplingRate: Double) -> ([Double], Double) {
        
        let diffPower = self.applyHammingFilter(signal: feature, samplingRate: samplingRate, cutoffFrequency: 6)
        
        let fftSetup = UNSWFFT(transformExpontent: 14, samplingRate: samplingRate)
        let fft = fftSetup.applyFFTOnTwoSecondWindow(signal: diffPower)
        let heartRateFrequency = fftSetup.getHeartRateFrequency(fft: fft)
        
        let heartRateMin = 1.5
        let heartRateMax = 4.0
        let cutfoffFrequency = [heartRateMin, heartRateFrequency, heartRateMax].map { $0 * 2.0 }.median()
        
        let diffPowerSmoothed = self.applyHammingFilter(signal: feature, samplingRate: samplingRate, cutoffFrequency: cutfoffFrequency)
        
        return (diffPowerSmoothed, heartRateFrequency)
    }
    
    static func applyHammingFilter(signal: [Double], samplingRate: Double, cutoffFrequency: Double) -> [Double] {
        let hammingWindowHeuristic = self.calculateHammingWindowHeuristic(samplingRate: samplingRate, cutoffFrequency: cutoffFrequency)
        let (bCoeff, aCoeff) = self.calcHammingFilterCoeff(hammingWindowHeuristic: hammingWindowHeuristic)
        
        let hammingFiltered = UNSWFilter.applyLinearFilterForwardBackward(bCoeff: bCoeff, aCoeff: aCoeff, signal: signal)
        
        let hammingFilteredAbs =  MathUtils.absolute(hammingFiltered)
        
        return MathUtils.sqrt(hammingFilteredAbs)
        
        
    }
    
    private static func calculateHammingWindowHeuristic(samplingRate: Double, cutoffFrequency: Double) -> Int {
        
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
