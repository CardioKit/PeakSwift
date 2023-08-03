//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation


import XCTest
@testable import PeakSwift


final class WindowsTests: XCTestCase {
    
    func testHammingOddWindow() {
        
        let hammingWindowSize = 3
        
        let actualHammingWindow = Hamming.createHammingWindow(windowSize: hammingWindowSize)
        let expectedHammingWindow = [0.08, 1, 0.08]
        
        AssertEqualWithThreshold(actualHammingWindow, expectedHammingWindow, threshold: Constants.doubleAccuracy)
    }
    
    func testHammingEvenWindow() {
        
        let hammingWindowSize = 4
        
        let actualHammingWindow = Hamming.createHammingWindow(windowSize: hammingWindowSize)
        let expectedHammingWindow = [0.08, 0.77, 0.77, 0.08]
        
        AssertEqualWithThreshold(actualHammingWindow, expectedHammingWindow, threshold: Constants.doubleAccuracy)
    }
    
    
    func testHammingLargeWindow() {
        
        let hammingWindowSize = 10
        
        let actualHammingWindow = Hamming.createHammingWindow(windowSize: hammingWindowSize)
        let expectedHammingWindow = [0.08, 0.1876195561652700, 0.4601218382732120, 0.77, 0.9722586055615180, 0.9722586055615180, 0.77, 0.4601218382732120, 0.1876195561652700, 0.08]
        
        AssertEqualWithThreshold(actualHammingWindow, expectedHammingWindow, threshold: Constants.doubleAccuracy)
    }
    
  
    func testHannEvenWindow() {
        
        let hannWindowSize = 6
        
        let actualHannWindow = Hann.createHannWindow(windowSize: hannWindowSize)
        let expectedHannWindow = [0.0, 0.34549150281252633, 0.9045084971874737, 0.9045084971874737, 0.34549150281252633, 0.0]
        
        AssertEqualWithThreshold(actualHannWindow, expectedHannWindow, threshold: Constants.doubleAccuracy)
    }
    
    
    func testHannOddWindow() {
        
        let hannWindowSize = 7
        
        let actualHannWindow = Hann.createHannWindow(windowSize: hannWindowSize)
        let expectedHannWindow = [0.0, 0.2499999999999999, 0.75, 1.0, 0.7500000000000002, 0.2500000000000003, 0.0]

        
        AssertEqualWithThreshold(actualHannWindow, expectedHannWindow, threshold: Constants.doubleAccuracy)
    }
}
