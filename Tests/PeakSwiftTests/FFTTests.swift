//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 22.07.23.
//

import Foundation


import XCTest
@testable import PeakSwift


final class FFTTests: XCTestCase {
    
    func testFFT() {
        
        let sin50Hz = SinusComponent(amplitude: 0.7, frequency: 50)
        let sin120Hz = SinusComponent(amplitude: 1, frequency: 120)
        let signalGenerator = SignalGenerator(signalComponents: [sin50Hz, sin120Hz])
        let signal = signalGenerator.synthesizeSignal(samplingFrequency: 1000, signalLength: 2048)
        
        let resultFFT = FFT.applyFFT(signal: signal)
        let frequencyDomain = FFT.computeFrequencyComponets(fftOutput: resultFFT, signalLength: signal.count)
        
        // Expect frequency peaks in this range in the frequency domain
        let max50Hz = frequencyDomain[0...150].argmax()!
        let max120Hz = frequencyDomain[150...].argmax()!
        
        let expectedMax50Hz = 102
        let expectedMax120Hz = 246

        XCTAssertEqual(max50Hz, expectedMax50Hz)
        XCTAssertEqual(max120Hz, expectedMax120Hz)
        
    }
    
    
    func testFFTEasy() {
        
        let signal: [Double] = [1,0,0,0]
        let resultFFT = FFT.applyFFT(signal: signal)
        
        let expectedFFTRealPart: [Double] = [1,1,1,1]
        let expectedFFTImagPart: [Double] = [0,0,0,0]
        
        XCTAssertEqual(resultFFT.realPart, expectedFFTRealPart)
        XCTAssertEqual(resultFFT.imagPart, expectedFFTImagPart)
        
    }
    
    func testFFTEasy2() {
        
        let signal: [Double] = [1,0,0,0,0,0,0,0]
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFTRealPart: [Double] = [1,1,1,1,1,1,1,1]
        let expectedFFTImagPart: [Double] = [Double](repeating: 0.0, count: expectedFFTRealPart.count)
        
        XCTAssertEqual(resultFFT.realPart, expectedFFTRealPart)
        XCTAssertEqual(resultFFT.imagPart, expectedFFTImagPart)
        
    }
    
    func testFFTEasy3() {
        
        let signal: [Double] = [1,1,0,0,0,0,0,0]
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFTRealPart: [Double] = [2, 1.7071, 1, 0.2929, 0, 0.2929, 1, 1.7071]
        let expectedFFTImagPart: [Double] = [0, -0.7071, -1, -0.7071, 0, 0.7071, 1, 0.7071]
        
        // MatLab rounds at 4 positions after comma
        AssertEqualWithThreshold(resultFFT.realPart, expectedFFTRealPart, threshold: 0.0001)
        AssertEqualWithThreshold(resultFFT.imagPart, expectedFFTImagPart, threshold: 0.0001)
    }
    
    func testFFTNoPowOf2() {
        
        let signal: [Double] = [1,1]
        let resultFFT = FFT.applyFFT(signal: signal, transformLength: 8)
        let expectedFFT: [Double] = [2, 1.7071, 1, 0.2929, 0, 0.2929, 1, 1.7071]
        
        
        // MatLab rounds at 4 positions after comma
        AssertEqualWithThreshold(resultFFT.realPart, expectedFFT, threshold: 0.0001)
        
    }
    
    func testGenerateFrequenciesEvenWindow() {
        
        let windowSize = 10
        let samplingFrequency = 3.0
        
        let actualFrequencyRange = FFT.generateSampleFrequencies(windowSize: windowSize, samplingFrequency: samplingFrequency)
        let expectedFrequencyRange = [0.0,0.03333333333333333,0.06666666666666667,0.1,0.13333333333333333,0.16666666666666666]
        
        AssertEqualWithThreshold(actualFrequencyRange, expectedFrequencyRange)
    }
    
    func testGenerateFrequenciesOddWindow() {
        
        let windowSize = 9
        let samplingFrequency = 4.0
        
        let actualFrequencyRange = FFT.generateSampleFrequencies(windowSize: windowSize, samplingFrequency: samplingFrequency)
        let expectedFrequencyRange = [0.0,0.027777777777777776,0.05555555555555555,0.08333333333333333,0.1111111111111111]

        
        AssertEqualWithThreshold(actualFrequencyRange, expectedFrequencyRange)
    }
}
