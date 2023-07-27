//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 23.07.23.
//

import Foundation

import XCTest
@testable import PeakSwift


final class UNSWTests: XCTestCase {
    
    let testDataSetLoader: TestDataSetLoader = TestDataSetLoader()
    
    func testUNSW() throws {
        let qrsDetector = QRSDetector()
        
        let expectedResult = try testDataSetLoader.getTestData(testDataSet: .TestUnsw)
        let actualResult = qrsDetector.detectPeaks(electrocardiogram: expectedResult.electrocardiogram, algorithm: .unsw)
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks, threshold: 5)
    }
    
    func testStandardSortFilt1OddWindow() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
    
        let expectedFilteredResult: [Double] = [1,1,2,3,4,5]
        let actualFilteredResult = Sortfilt1.applySortFilt1(signal: inputVector, windowSize: 3, percentage: 20)
        
        XCTAssertEqual(expectedFilteredResult, actualFilteredResult)
    }
    
    func testStandardSortFilt1EvenWindow() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
    
        let expectedFilteredResult: [Double] = [1,2,3,4,4,5]
        let actualFilteredResult = Sortfilt1.applySortFilt1(signal: inputVector, windowSize: 4, percentage: 20)
        
        XCTAssertEqual(expectedFilteredResult, actualFilteredResult)
    }
    
    func testMaxFilter() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
        let minMaxFilter = MinMaxMedianFilter()
        
        let actualFilteredSignal = minMaxFilter.applyFilter(signal: inputVector, windowSize: 4, filterType: .max)
        let expectedFilteredSignal: [Double] = [3, 4, 5, 6, 6, 6]

        XCTAssertEqual(actualFilteredSignal, expectedFilteredSignal)
    }
    
    func testMinFilter() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
        let minMaxFilter = MinMaxMedianFilter()
        
        let actualFilteredSignal = minMaxFilter.applyFilter(signal: inputVector, windowSize: 4, filterType: .min)
        let expectedFilteredSignal: [Double] = [1, 1, 2, 3, 4, 5]

        XCTAssertEqual(actualFilteredSignal, expectedFilteredSignal)
    }
    
    func testMedianFilter() {
        
        let inputVector: [Double] = [1,2,3,4,5,6]
        let minMaxFilter = MinMaxMedianFilter()
        
        let actualFilteredSignal = minMaxFilter.applyFilter(signal: inputVector, windowSize: 4, filterType: .median)
        let expectedFilteredSignal: [Double] = [2, 3, 4, 5, 5, 6]

        XCTAssertEqual(actualFilteredSignal, expectedFilteredSignal)
    }
    
    func testUNSWFFT() {
        
        let signal: [Double] = [1, 0, 0, 0, 0, 0, 0, 0]
        let samplingRate = 1.0
        let transformExpontent = 3
        
        let fftSetup = UNSWFFT(transformExpontent: transformExpontent, samplingRate: samplingRate)
        let actualFFTRes = fftSetup.applyFFTOnTwoSecondWindow(signal: signal)
        let exepectedFFTRes =  [0, 0.0190, 0.0352, 0.0459, 0.0497, 0.0459, 0.0352, 0.0190]

        AssertEqualWithThreshold(actualFFTRes, exepectedFFTRes, threshold: 0.0001)
        
    }
    
    func testUNSWFFTMoreComplicatedVector() {
        
        let signal: [Double] = [1, 0, 1, 1, 3, 1, -4, 1]
        let samplingRate = 1.0
        let transformExpontent = 3
        
        let fftSetup = UNSWFFT(transformExpontent: transformExpontent, samplingRate: samplingRate)
        let actualFFTRes = fftSetup.applyFFTOnTwoSecondWindow(signal: signal)
        let exepectedFFTRes = [0, 0.0570903506165349,   0.105489212877019, 0.137828298739074,    0.149184275534743, 0.137828298739074,    0.105489212877019,    0.0570903506165349]

        AssertEqualWithThreshold(actualFFTRes, exepectedFFTRes, threshold: Constants.doubleAccuracy)
    }
    
}
