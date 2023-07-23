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
        let signalGenerator = GenerateSignal(signalComponents: [sin50Hz, sin120Hz])
        let signal = signalGenerator.generateSignal(samplingFrequency: 1000, signalLength: 2048)
        
        let resultFFT = FFT.applyFFT(signal: signal)
        #warning("TODO add a test")
        let frequencyDomian = FFT.computeFrequencyComponets(fftOutput: resultFFT, signalLength: signal.count)
        //let expectedFFT: [Double] = []

        //XCTAssertEqual(resultFFT.realPart, expectedFFT)
        
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
