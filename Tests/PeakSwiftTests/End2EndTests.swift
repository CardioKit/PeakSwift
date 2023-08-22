//
//  File.swift
//
//
//  Created by Nikita Charushnikov on 22.08.23.
//

import Foundation

import XCTest
@testable import PeakSwift


// This test is an optional test meant for manually plugging in real data sets
// This test are skipped if no dataset is found
final class End2EndTests: XCTestCase {
    
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()
    
    func runTestForDataSet(testDataSet: QRSDetectionRealTestDataSet, algorithm: Algorithms) throws {
        let qrsDetector = QRSDetector()
        
        do {
            //let expectedResults = try testDataSetLoader.getTestData(testDataSet: testDataSet)
            let expectedResults = [try testDataSetLoader.getTestData(testDataSet: testDataSet)[1]]
            
            for (index, expectedResult) in expectedResults.enumerated() {
                let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: algorithm)
                
                let message = { (c1: [UInt], c2: [UInt], threshold: UInt) -> String in
                    "At ECG number \(index) \(c1) is not equal to \(c2) with threshold \(threshold)"
                }
                
                AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: 0, message: message)
            }
            
        } catch {
            // No dataset found skipping test
            throw XCTSkip("Skipping test: No dataset found")
        }
    }
    
    func testTwoAverage() throws {
        try runTestForDataSet(testDataSet: .TestPoolTwoAverage, algorithm: .twoAverage)
    }
    
    func testPanTompkins() throws {
        try runTestForDataSet(testDataSet: .TestPoolPanTompkins, algorithm: .panTompkins)
    }
    
    func testKalidas() throws {
        try runTestForDataSet(testDataSet: .TestPoolKalidas, algorithm: .kalidas)
    }
    
    func testChristov() throws {
        try runTestForDataSet(testDataSet: .TestPoolChristov, algorithm: .christov)
    }
    
}
