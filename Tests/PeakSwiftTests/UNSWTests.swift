//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation

import XCTest
@testable import PeakSwift


final class UNSWTests: XCTestCase {
    
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()
    
    func testUNSW() throws {
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestUnsw)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .unsw)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
    }
    
    func testStandardSortFilt1OddWindow() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
    
        let expectedFilteredResult: [Double] = [1,1,2,3,4,5]
        let actualFilteredResult = Sortfilt1.applyStandardSortFilt1(signal: inputVector, windowSize: 3, percentage: 20)
        
        XCTAssertEqual(expectedFilteredResult, actualFilteredResult)
    }
    
    func testStandardSortFilt1EvenWindow() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
    
        let expectedFilteredResult: [Double] = [1,2,3,4,4,5]
        let actualFilteredResult = Sortfilt1.applyStandardSortFilt1(signal: inputVector, windowSize: 4, percentage: 20)
        
        XCTAssertEqual(expectedFilteredResult, actualFilteredResult)
    }
    
    func testMaxFilter() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
        let minMaxFilter = MinMaxFilter()
        
        let actualFilteredSignal = minMaxFilter.applyMaxFilter(signal: inputVector, windowSize: 4)
        let expectedFilteredSignal: [Double] = [3, 4, 5, 6, 6, 6]

        XCTAssertEqual(actualFilteredSignal, expectedFilteredSignal)
    }
    
    func testMinFilter() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
        let minMaxFilter = MinMaxFilter()
        
        let actualFilteredSignal = minMaxFilter.applyMinFilter(signal: inputVector, windowSize: 4)
        let expectedFilteredSignal: [Double] = [1, 1, 2, 3, 4, 5]

        XCTAssertEqual(actualFilteredSignal, expectedFilteredSignal)
    }
}
