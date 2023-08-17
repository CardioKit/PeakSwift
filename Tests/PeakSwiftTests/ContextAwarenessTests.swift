//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 17.08.23.
//

import Foundation
import XCTest
@testable import PeakSwift


final class ContextAwarenessTests: XCTestCase {
    
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()
    
    func simpleECG() throws -> Electrocardiogram {
        return try testDataSetLoader.getTestData(testDataSet: .TestNeuroKit).electrocardiogram
    }
    
    func AssertContainsExpectedAlgorithms(actualAlgorithm: Algorithms) {
        // At the current implementation, these algorithms will most likely be picked 
        let expectedAlgorithm: [Algorithms] = [.kalidas, .panTompkins, .neurokit, .twoAverage]
        XCTAssertTrue(expectedAlgorithm.contains { $0 == actualAlgorithm } )
    }
    
    func testSelectionHighQuality() throws {
        
        let qrsDetector = QRSDetector()
        let defaultConfiguration = Configuration.createDefaultConfiguration().setClassification(.highQuality)
        let ecg = try simpleECG()
        
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: ecg, configuration: defaultConfiguration)
        
        AssertContainsExpectedAlgorithms(actualAlgorithm: actualResult.algorithm)
    }
    
    func testSelectionLowQuality() throws {
        
        let qrsDetector = QRSDetector()
        let defaultConfiguration = Configuration.createDefaultConfiguration().setClassification(.lowQuality)
        let ecg = try simpleECG()
        
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: ecg, configuration: defaultConfiguration)
        
        AssertContainsExpectedAlgorithms(actualAlgorithm: actualResult.algorithm)
    }
    
    func testSelectionSinusRhytm() throws {
        
        let qrsDetector = QRSDetector()
        let defaultConfiguration = Configuration.createDefaultConfiguration().setClassification(.sinusRhythm)
        let ecg = try simpleECG()
        
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: ecg, configuration: defaultConfiguration)
        
        AssertContainsExpectedAlgorithms(actualAlgorithm: actualResult.algorithm)
    }
    
    func testSelectionAtrialFibrillation() throws {
        
        let qrsDetector = QRSDetector()
        let defaultConfiguration = Configuration.createDefaultConfiguration().setClassification(.atrialFibrillation)
        let ecg = try simpleECG()
        
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: ecg, configuration: defaultConfiguration)
        
        AssertContainsExpectedAlgorithms(actualAlgorithm: actualResult.algorithm)
    }
}
