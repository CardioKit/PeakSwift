//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

import XCTest
@testable import PeakSwift


final class StatisticsTests: XCTestCase {
    
    func testKurtosis() {
        
        let input: [Double] = [1,2,3,4]
        
        let actualKurtosis = Kurtosis.kurtosis(input)
        let expectedKurtosis = 1.64
        
        XCTAssertEqual(expectedKurtosis, actualKurtosis)
    }
    
    func testKurtosis2() {
        
        let input: [Double] = [1,0,0,0,5,7,9]
        
        let actualKurtosis = Kurtosis.kurtosis(input)
        let expectedKurtosis = 1.5995823234072026
        
        XCTAssertEqualWithAccuracy(expectedKurtosis, actualKurtosis, accuracy: Constants.doubleAccuracy)
    }
}
