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
        
        let samplingFrequency = 1000.0
        let samplingPeriod = 1.0 / samplingFrequency
        let signalLength = 64
        let timeVector = (0..<signalLength).map { Double($0) * samplingPeriod }
        
        let signal = timeVector.map { t in
            0.7*sin(2*Double.pi*50*t) +
            sin(2*Double.pi*120*t)
        }
        
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFT: [Double] = []
        
        XCTAssertEqual(resultFFT, expectedFFT)
        
    }
    
    
    func testFFTEasy() {
        
        let signal: [Double] = [1,0,0,0]
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFT: [Double] = []
        
        XCTAssertEqual(resultFFT, expectedFFT)
        
    }
    
    func testFFTEasy2() {
        
        let signal: [Double] = [1,0,0,0,0,0,0,0]
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFT: [Double] = []
        
        XCTAssertEqual(resultFFT, expectedFFT)
        
    }
    
    func testFFTEasy3() {
        
        let signal: [Double] = [1,1,0,0,0,0,0,0]
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFT: [Double] = []
        
        XCTAssertEqual(resultFFT, expectedFFT)
        
    }
    
    func testFFTNoPowOf2() {
        
        let signal: [Double] = [1,1,0,0,0,0,0,]
        let resultFFT = FFT.applyFFT(signal: signal)
        let expectedFFT: [Double] = []
        
        XCTAssertEqual(resultFFT, expectedFFT)
        
    }
}
