//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 06.07.23.
//

import Foundation

import XCTest
@testable import PeakSwift


final class MovingWindowAverageUtilsTests: XCTestCase {
    
    func testMovingWindowAverageOddWindow() {
        let inputVector:[Double] = [1,2,3,4,5,6]
        
        let actualMovingAverage = MovingWindowAverage.movingWindowAverage(signal: inputVector, windowSize: 3)
        let expectedMovingAverage:[Double] =  [1,2,3,4,5,5]
        
        let actualMovingAverageFloor = VectorUtils.floorVector(actualMovingAverage)
        
        XCTAssertEqual(actualMovingAverageFloor, expectedMovingAverage)
    }
    
    func testMovingWindowAverageEvenWindow() {
        let inputVector:[Double] = [1,2,3,4,5,6]
        
        let actualMovingAverage = MovingWindowAverage.movingWindowAverage(signal: inputVector, windowSize: 4)
        let expectedMovingAverage:[Double] =  [1,1,2,3,4,5]
        let actualMovingAverageFloor = VectorUtils.floorVector(actualMovingAverage)
        
        XCTAssertEqual(actualMovingAverageFloor, expectedMovingAverage)
    }
}
