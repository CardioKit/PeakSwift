//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 06.07.23.
//

import XCTest
@testable import PeakSwift

final class PeakUtilsTests: XCTestCase {
    
    func testFindAllPeaks() {
        let inputSignal: [Double] = [1, 1, 1, 5, 5, 5, 1, 4, 4, 4, 4, 3, 4, 3]
        
        let actualPeaks = PeakUtils.findFlatLocalMaxima(signal: inputSignal)
        let expectedPeaks = [4, 8, 12]
        
        XCTAssertEqual(actualPeaks, expectedPeaks)
    }
    
    func testFindPeakProminences() {
        
        let inputSignal: [Double] = [1,-8,1,5,-5,3,-9]
        let peaks = [3,5]
        
        let actualProminence = PeakUtils.findAllPeakProminences(signal: inputSignal, peaks: peaks)
        let expectedProminence: [Double] = [13, 8]
        
        XCTAssertEqual(actualProminence, expectedProminence)
    }
    
    func testFindAllPeaksAndTheirProminences() {
        
        let inputSignal: [Double] = [1,-8,1,5,-5,3,-9]
        
        let actualPeaksAndProminence = PeakUtils.findAllPeaksAndProminences(signal: inputSignal)
        
        let expectedPeaks = [3,5]
        let expectedProminence: [Double] = [13, 8]
        
        XCTAssertEqual(actualPeaksAndProminence.peakPosition, expectedPeaks)
        XCTAssertEqual(actualPeaksAndProminence.peakProminences, expectedProminence)
    }
    
    func testProminenceFiltered() {
        
        let inputSignal: [Double] = [1,0, 5,1, 0, 3, 0,0, 4,0,1,0,0, 0]
        let actualPeaksAndProminence = PeakUtils.findAllPeaksAndProminences(signal: inputSignal, minProminence: 1.5)
        
        let expectedPeaks = [2, 5, 8]
        let expectedProminence: [Double] = [5, 3, 4]
        
        XCTAssertEqual(actualPeaksAndProminence.peakPosition, expectedPeaks)
        XCTAssertEqual(actualPeaksAndProminence.peakProminences, expectedProminence)
    }
}
