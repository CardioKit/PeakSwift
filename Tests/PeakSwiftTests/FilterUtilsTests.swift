//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 06.07.23.
//

import XCTest
@testable import PeakSwift


final class FilterTests: XCTestCase {
    
    func testButterworthOrder1() {
        let butterworth = Butterworth()
        let actualResult = butterworth.butterworth(signal: [1,2,3], order: .one, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: 1000)
        let expectedResult = [0.0245216092494657603, 0.0967629688502650159, 0.214027722567251055]
        
        AssertEqualWithThreshold(actualResult, expectedResult, threshold: Constants.doubleAccuracy)
    }
    
    func testButterworthOrder3() {
        let butterworth = Butterworth()
        let actualResult = butterworth.butterworth(signal: [1,2,3], order: .three, lowCutFrequency: 8, highCutFrequency: 16, sampleRate: 1000)
        let expectedResult = [1.51064223408530664e-05, 0.000119107750097953853, 0.000482703965553904588]
        
        AssertEqualWithThreshold(actualResult, expectedResult, threshold: Constants.doubleAccuracy)
    }
    
    func testLinearBiderectionalFilter() {
        let inputVector: [Double] = [1, 1, 1, 5, 5, 5, 1, 4, 4, 4, 4, 3, 4, 3]
        let b: [Double] = [3 , 4]
        let a = 2.0
        
        let actualResult = LinearFilter.applyLinearFilterForwardBackwards(signal: inputVector, b: b, a: a)
        let expectedResult = [12.25, 12.25, 24.25, 49.25, 61.25, 49.25, 33.25, 40,  49, 49, 46, 42.75, 43, 36.75]
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testLinearFilter() {
        let inputVector: [Double] = [1, 1, 1, 5, 5, 5, 1, 4, 4, 4, 4, 3, 4, 3]
        let b: [Double] = [3, 4]
        let a = 2.0
        
        let actualResult = LinearFilter.applyLinearFilter(signal: inputVector, b: b, a: a)
        let expectedResult = [ 1.5,  3.5,  3.5,  9.5, 17.5, 17.5, 11.5,  8,  14,  14,  14,  12.5, 12,  12.5]
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testOddExtension() {
        let inputVector: [Double] = [0, 1, 4, 9, 16]
        let extensionSize = 2
        
        let actualOddExtension = LinearFilter.oddExtention(signal: inputVector, n: extensionSize)
        let expectedOddExtension: [Double] = [-4, -1,  0,  1,  4,  9, 16, 23, 28]
        
        XCTAssertEqual(actualOddExtension, expectedOddExtension)
    }
    
    func testPowerline() {
        let inputVector: [Double] = [1,3,1,3,4,5,1,3,1,3,4,5]
        let samplingFrequency: Double = 5
        
        let actualPowerlineFilter  = Powerline.filter(signal: inputVector, samplingFrequency: samplingFrequency)
        let expectedPowerlineFilter = [1, 2, 2, 2.75, 4, 3.75, 2.5, 2, 2, 2.75, 4, 5]
        
        XCTAssertEqual(actualPowerlineFilter, expectedPowerlineFilter)
    }
    
    func testBaseline() {
        let inputSignal: [Double] = [1,2,3,5,6]
        
        
        let actualDetrend = Baseline.detrend(signal: inputSignal)
        
        // Generated with Matlab.detrend(...)
        let expectedDetrend: [Double] = [0.2, -0.1, -0.4, 0.3, 0]
        
        
        AssertEqualWithThreshold(actualDetrend, expectedDetrend, threshold: Constants.doubleAccuracy)
    }
    
    func testBaselineRepetiveInput() {
        let inputSignal: [Double] = [1,2,3,1,2,3]
        
        
        let actualDetrend = Baseline.detrend(signal: inputSignal)
        
        // Generated with Matlab.detrend(...)
        let expectedDetrend: [Double] = [-0.428571428571429, 0.342857142857143, 1.11428571428571, -1.11428571428571, -0.342857142857143, 0.428571428571429]
        
        AssertEqualWithThreshold(actualDetrend, expectedDetrend, threshold: Constants.doubleAccuracy)
    }
    
}
