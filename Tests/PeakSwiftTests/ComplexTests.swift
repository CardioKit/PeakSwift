//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 24.07.23.
//

import Foundation


import XCTest
@testable import PeakSwift


final class ComplexTests: XCTestCase {
    
    
    func testConj() {
        let complexVector = ComplexVector(realPart: [1,2,3], imagPart: [1,2,3])
        
        let expectedRealPart: [Double] = [1,2,3]
        let expectedImagPart: [Double] = [-1,-2,-3]
        
        let actualComplexVector = complexVector.conj()
        
        XCTAssertEqual(actualComplexVector.realPart, expectedRealPart)
        XCTAssertEqual(actualComplexVector.imagPart, expectedImagPart)

    }
    
    func testMultiply() {
        let lhs = ComplexVector(realPart: [3, 2], imagPart: [2, 3])
        let rhs = ComplexVector(realPart: [-1, 4], imagPart: [-4, -1])
        
        let actualProduct = lhs.multiply(rhs: rhs)
        
        let expectedRealPart: [Double] = [5, 11]
        let expectedImagPart: [Double] = [-14, 10]
        
        XCTAssertEqual(actualProduct.realPart, expectedRealPart)
        XCTAssertEqual(actualProduct.imagPart, expectedImagPart)
        
        
    }
    
    func testSquare() {
        let number = ComplexVector(realPart: [2, -3], imagPart: [1, 4])
        
        let actualSquare = number.square()
        
        let expectedRealPart: [Double] = [3, -7]
        let expectedImagPart: [Double] = [4, -24]
        
        XCTAssertEqual(actualSquare.realPart, expectedRealPart)
        XCTAssertEqual(actualSquare.imagPart, expectedImagPart)
        
        
    }
}
