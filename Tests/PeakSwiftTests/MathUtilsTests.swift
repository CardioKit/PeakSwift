//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 06.07.23.
//

import XCTest
@testable import PeakSwift


final class MathUtilsTests: XCTestCase {
    
    func testDiff() {
        let inputVector: [Double] = [1.0, 2, 4, 7, 0]
        
        let actualResult = MathUtils.diff(inputVector)
        let exptectedResult: [Double] = [ 1,  2,  3, -7]
        
        XCTAssertEqual(actualResult, exptectedResult)
    }
    
    func testGradient() {
        let inputVector = [5, 9 , 9.5, 10, 30, 5, 3]
        
        let actualGradient = MathUtils.gradient(inputVector)
        let expectedGradient =  [4, 2.25 ,  0.5,   10.25,  -2.5,  -13.5,   -2 ]
        
        XCTAssertEqual(actualGradient, expectedGradient)
    }
    
    func testPowerBase2WithZeroExponent() {
        
        let inputExponent = 0
        
        let actualPowerBase2 = MathUtils.powerBase2(exponent: inputExponent)
        let expectedPowerBase2 = 1
        
        XCTAssertEqual(actualPowerBase2, expectedPowerBase2)
    }
    
    func testPowerBase2() {
        let inputExponent = 4
        
        let actualPowerBase2 = MathUtils.powerBase2(exponent: inputExponent)
        let expectedPowerBase2 = 16
        
        XCTAssertEqual(actualPowerBase2, expectedPowerBase2)
        
        
        func testIntegrationTrapetzoidal() {
            
            let inputVector: [Double] = [1, 2, 3, 4, 5]
            let stepSize = 5.0
            
            let actualIntegral = IntegralUtils.applyTrapezoidal(inputVector, stepSize: stepSize)
            let expectedIntegral = 60.0
            
            
            XCTAssertEqual(actualIntegral, expectedIntegral)
        }
    }
}
