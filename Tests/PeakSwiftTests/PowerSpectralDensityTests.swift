//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

import XCTest
@testable import PeakSwift

final class PowerSpectralDensityTests: XCTestCase {
    
    
    func testWelch() {
        
        let inputSignal: [Double] = [1, 2, 3, 4, 5, 6]
        let nperseg = 4
        let nfft = 8
        let samplingRate = 1.0
        
        let actualPSD = Welch.estimatePowerSpectralDensity(signal: inputSignal, samplingFrequency: samplingRate, nperseg: nperseg, noverlap: nil, nfft: TransposedPowerOfTwo(value: inputSignal.count))
        
        let expectedPSDFrequencies = [0.0, 0.125, 0.25, 0.375, 0.5]
        let expectedPSDPower = [45.33333333333333,66.72217408045681,24.0,2.6111592528765124,0.0]
        
        
        AssertEqualWithThreshold(actualPSD.frequencies, expectedPSDFrequencies)
        AssertEqualWithThreshold(actualPSD.power, expectedPSDPower, threshold: Constants.doubleAccuracy)
    }
    
    func testWelchGeneratedSignal() {
        
        let sin50Hz = SinusComponent(amplitude: 0.7, frequency: 50)
        let sin120Hz = SinusComponent(amplitude: 1, frequency: 120)
        let samplingFrequency = 300.0
        let signalLength = 2048
        let nperseg = signalLength / 2
        let signalGenerator = SignalGenerator(signalComponents: [sin50Hz, sin120Hz])

        let signal = signalGenerator.synthesizeSignal(samplingFrequency: samplingFrequency, signalLength: signalLength)
        
        let actualPSD = Welch.estimatePowerSpectralDensity(signal: signal, samplingFrequency: samplingFrequency, nperseg: nperseg, noverlap: nil, nfft: TransposedPowerOfTwo(value: signalLength))
        
        // There should be only 2 prominent peaks at frequencies 50Hz and 120Hz
        let actualPeaks = PeakUtils.findAllPeaksAndProminences(signal: actualPSD.power, minProminence: 0.1).peakPosition
        // Generated with neurokit
        let expectedPeaks = [341, 819]
        
        XCTAssertEqual(actualPeaks, expectedPeaks)
        
    }
    
    func testWelchGeneratedSignalNoPow2() {
        
        let sin50Hz = SinusComponent(amplitude: 0.7, frequency: 50)
        let sin120Hz = SinusComponent(amplitude: 1, frequency: 120)
        let samplingFrequency = 300.0
        let signalLength = 700
        let nperseg = signalLength / 2
        let signalGenerator = SignalGenerator(signalComponents: [sin50Hz, sin120Hz])

        let signal = signalGenerator.synthesizeSignal(samplingFrequency: samplingFrequency, signalLength: signalLength)
        
        let actualPSD = Welch.estimatePowerSpectralDensity(signal: signal, samplingFrequency: samplingFrequency, nperseg: nperseg, noverlap: nil, nfft: TransposedPowerOfTwo(value: signalLength))
        
        // There should be only 2 prominent peaks at frequencies 50Hz and 120Hz
        let actualPeaks = PeakUtils.findAllPeaksAndProminences(signal: actualPSD.power, minProminence: 0.1).peakPosition
        // Generated with neurokit
        let expectedPeaks = [171, 410]
        
        XCTAssertEqual(actualPeaks, expectedPeaks)
        
    }
    
    
    func testPowerOfSignal() {
        
        let sin50Hz = SinusComponent(amplitude: 0.7, frequency: 50)
        let sin120Hz = SinusComponent(amplitude: 1, frequency: 120)
        let samplingFrequency = 300.0
        let signalLength = 2048
        let signalGenerator = SignalGenerator(signalComponents: [sin50Hz, sin120Hz])
        
        let signal = signalGenerator.synthesizeSignal(samplingFrequency: samplingFrequency, signalLength: signalLength)
        
        let bandFrequency40Hz60Hz = BandFrequency(minFrequency: 40, maxFrequency: 60)
        let bandFrequency110Hz130Hz = BandFrequency(minFrequency: 110, maxFrequency: 130)
        let bandFrequencies = [bandFrequency40Hz60Hz, bandFrequency110Hz130Hz]
        
        let actualPowerOfSignal = SignalPower.calculatePowerOfSignal(signal: signal, samplingFrequency: samplingFrequency, bandFrequencies: bandFrequencies)
        
        let expectedPowerOfSignal40Hz60Hz = 0.245
        let expectedPowerOfSignal110Hz130Hz = 0.5
        
        // 40-60 Hz range
        XCTAssertEqualWithAccuracy(actualPowerOfSignal[0].power, expectedPowerOfSignal40Hz60Hz, accuracy: 0.0001)
        // 110-130 Hz range
        XCTAssertEqualWithAccuracy(actualPowerOfSignal[1].power, expectedPowerOfSignal110Hz130Hz, accuracy: 0.0001)
    
    }
    
}
