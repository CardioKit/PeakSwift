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
        
        let actualHammingWindow =  Windows.createWindow(windowSize: hammingWindowSize, windowSequency: .hamming)
        let expectedHammingWindow = [0.08, 1, 0.08]
        
        AssertEqualWithThreshold(actualHammingWindow, expectedHammingWindow, threshold: Constants.doubleAccuracy)
    }
    
    func testHammingEvenWindow() {
        
        let hammingWindowSize = 4
        
        let actualHammingWindow =  Windows.createWindow(windowSize: hammingWindowSize, windowSequency: .hamming)
        let expectedHammingWindow = [0.08, 0.77, 0.77, 0.08]
        
        AssertEqualWithThreshold(actualHammingWindow, expectedHammingWindow, threshold: Constants.doubleAccuracy)
    }
    
    
    func testHammingLargeWindow() {
        
        let hammingWindowSize = 10
        
        let actualHammingWindow = Windows.createWindow(windowSize: hammingWindowSize, windowSequency: .hamming)
        let expectedHammingWindow = [0.08, 0.1876195561652700, 0.4601218382732120, 0.77, 0.9722586055615180, 0.9722586055615180, 0.77, 0.4601218382732120, 0.1876195561652700, 0.08]
        
        AssertEqualWithThreshold(actualHammingWindow, expectedHammingWindow, threshold: Constants.doubleAccuracy)
    }
    
  
    func testHannEvenWindow() {
        
        let hannWindowSize = 6
        
        let actualHannWindow = Windows.createWindow(windowSize: hannWindowSize, windowSequency: .hann)
        let expectedHannWindow = [0.0, 0.34549150281252633, 0.9045084971874737, 0.9045084971874737, 0.34549150281252633, 0.0]
        
        AssertEqualWithThreshold(actualHannWindow, expectedHannWindow, threshold: Constants.doubleAccuracy)
    }
    
    
    func testHannOddWindow() {
        
        let hannWindowSize = 7
        
        let actualHannWindow = Windows.createWindow(windowSize: hannWindowSize, windowSequency: .hann)
        let expectedHannWindow = [0.0, 0.2499999999999999, 0.75, 1.0, 0.7500000000000002, 0.2500000000000003, 0.0]

        
        AssertEqualWithThreshold(actualHannWindow, expectedHannWindow, threshold: Constants.doubleAccuracy)
    }
    
    
    func testHannEvenWindowSymmteric() {
        
        let hannWindowSize = 4
        
        let actualHannWindow = Windows.createWindow(windowSize: hannWindowSize, windowSequency: .hann, symmetric: false)
        let expectedHannWindow = [0.0, 0.5, 1, 0.5]

        
        AssertEqualWithThreshold(actualHannWindow, expectedHannWindow, threshold: Constants.doubleAccuracy)
    }
    
    func testHannOddWindowSymmteric() {
        
        let hannWindowSize = 7
        
        let actualHannWindow = Windows.createWindow(windowSize: hannWindowSize, windowSequency: .hann, symmetric: false)
        let expectedHannWindow = [0.0,0.18825509907063326,0.6112604669781572,0.9504844339512095,0.9504844339512095,0.6112604669781572,0.18825509907063326]
        
        AssertEqualWithThreshold(actualHannWindow, expectedHannWindow, threshold: Constants.doubleAccuracy)
    }


}
