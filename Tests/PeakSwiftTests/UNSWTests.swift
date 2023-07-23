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
    
    func testMinMaxFilter() {
        let minMaxFilter = MinMaxFilter()
        
        minMaxFilter.applyFilter()
    }
}
