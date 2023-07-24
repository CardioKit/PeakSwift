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
        
        let actualCompleVector = complexVector.conj()
        
        XCTAssertEqual(actualCompleVector.realPart, expectedRealPart)
        XCTAssertEqual(actualCompleVector.imagPart, expectedImagPart)

    }
}
