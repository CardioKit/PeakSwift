//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

import XCTest
@testable import PeakSwift

final class PowerSpectralDensity: XCTestCase {
    
    
    func testWelch() {
        
        let inputSignal: [Double] = [1, 2, 3, 4, 5, 6]
        let nperseg = 4
        let nfft = 8
        let samplingRate = 1.0
        
        let actualPSD = Welch.estimatePowerSpectralDensity(signal: inputSignal, samplingFrequency: samplingRate, nperseg: nperseg, noverlap: nil, nfft: nfft)
        
        let expectedPSDFrequencies = [0.0, 0.125, 0.25, 0.375, 0.5]
        let expectedPSDPower = [45.33333333333333,66.72217408045681,24.0,2.6111592528765124,0.0]
        
        
        AssertEqualWithThreshold(actualPSD.frequencies, expectedPSDFrequencies)
        AssertEqualWithThreshold(actualPSD.power, expectedPSDPower)
    }
}
