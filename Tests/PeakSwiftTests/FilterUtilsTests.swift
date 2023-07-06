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
        
        let actualResult = LinearFilter.applyLinearFilterBidirection(signal: inputVector, b: b, a: a)
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
}
