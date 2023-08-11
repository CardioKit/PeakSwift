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

    func testZhao2018SimpleUnacceptable() throws {
        
        let qualityEvaluator = ECGQualityEvaluator()
        let testData = try testDataSetLoader.getTestData(testDataSet: .TestZhao2018(approach: .simple, expectedQuality: .unacceptable))
        
        let actualECGQuality = qualityEvaluator.evaluateECGQuality(electrocardiogram: testData.electrocardiogram, algorithm: .zhao2018(.simple))
        let expectedECGQuality = testData.quality
        
        XCTAssertEqual(actualECGQuality, expectedECGQuality)
        
    }
    
    func testZhao2018SimpleExcellent() throws {
        
        let qualityEvaluator = ECGQualityEvaluator()
        let testData = try testDataSetLoader.getTestData(testDataSet: .TestZhao2018(approach: .simple, expectedQuality: .excellent))
        
        let actualECGQuality = qualityEvaluator.evaluateECGQuality(electrocardiogram: testData.electrocardiogram, algorithm: .zhao2018(.simple))
        let expectedECGQuality = testData.quality
        
        XCTAssertEqual(actualECGQuality, expectedECGQuality)
        
    }

    func testZhao2018FuzzyExcellent() throws {
        
        let qualityEvaluator = ECGQualityEvaluator()
        let testData = try testDataSetLoader.getTestData(testDataSet: .TestZhao2018(approach: .fuzzy, expectedQuality: .excellent))
        
        let actualECGQuality = qualityEvaluator.evaluateECGQuality(electrocardiogram: testData.electrocardiogram, algorithm: .zhao2018(.fuzzy))
        let expectedECGQuality = testData.quality
        
        XCTAssertEqual(actualECGQuality, expectedECGQuality)
    }
    
    func testZhao2018FuzzyBarelyAcceptable() throws {
        
        let qualityEvaluator = ECGQualityEvaluator()
        let testData = try testDataSetLoader.getTestData(testDataSet: .TestZhao2018(approach: .fuzzy, expectedQuality: .barelyAcceptable))
        
        let actualECGQuality = qualityEvaluator.evaluateECGQuality(electrocardiogram: testData.electrocardiogram, algorithm: .zhao2018(.fuzzy))

        let expectedECGQuality = testData.quality
        
        XCTAssertEqual(actualECGQuality, expectedECGQuality)
    }
    
    func testZhao2018FuzzyUnacceptable() throws {
        
        let qualityEvaluator = ECGQualityEvaluator()
        let testData = try testDataSetLoader.getTestData(testDataSet: .TestZhao2018(approach: .fuzzy, expectedQuality: .unacceptable))
        
        let actualECGQuality = qualityEvaluator.evaluateECGQuality(electrocardiogram: testData.electrocardiogram, algorithm: .zhao2018(.fuzzy))
        let expectedECGQuality = testData.quality
        
        XCTAssertEqual(actualECGQuality, expectedECGQuality)
    }
    
}
