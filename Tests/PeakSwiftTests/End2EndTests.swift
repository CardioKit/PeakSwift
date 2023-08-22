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
    
    func runTestForDataSet(testDataSet: QRSDetectionRealTestDataSet) throws {
        let qrsDetector = QRSDetector()
        
        do {
            let expectedResults = try testDataSetLoader.getTestData(testDataSet: .TestPoolTwoAverage)
            
            for expectedResult in expectedResults {
                let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .twoAverage)
                
                AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: 1)
            }
            
        } catch {
            // No dataset found skipping test
            throw XCTSkip("Skipping test: No dataset found")
        }
    }
    
    func testTwoAverage() throws {
        try runTestForDataSet(testDataSet: .TestPoolTwoAverage)
    }
    
}
