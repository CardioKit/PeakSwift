//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 09.08.23.
//

import Foundation

import XCTest
@testable import PeakSwift


final class ECGQualityTests: XCTestCase {
    
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()

    func testZhao2018Simple() throws {
        
        let zhao2018Setup = Zhao2018(mode:  Simple())
        let testData = try testDataSetLoader.getTestData(testDataSet: .TestZhao2018(approach: .simple))
        
        let actualECGQuality = zhao2018Setup.evaluateECGQuality(signal: testData.electrocardiogram.ecg, samplingFrequency: testData.electrocardiogram.samplingRate)
        let expectedECGQuality = testData.quality
        
        XCTAssertEqual(actualECGQuality, expectedECGQuality)
        
    }
}
