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
}
