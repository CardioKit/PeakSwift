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
        
        AssertEqualWithThreshold(actualResult.rPeaks, expectedResult.rPeaks)
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
    
    func testLowPassFilter() {
        
        let inputVector: [Double] = [1,1,1,1]
        
        let sin50Hz = SinusComponent(amplitude: 0.1, frequency: 50)
        let sin120Hz = SinusComponent(amplitude: 0.05, frequency: 120)
        let sin10Hz = SinusComponent(amplitude: 0.05, frequency: 10)
        let signalGenerator = SignalGenerator(signalComponents: [sin50Hz, sin120Hz, sin10Hz])
        let signal = signalGenerator.synthesizeSignal(samplingFrequency: 1000, signalLength: 2048)
        
        let cutoffFrequeny = 0.3//50.0/(1000.0/2.0)
        
        let filteredResult = Butterworth().butterworthLowPassForwardBackward(signal: signal, order: .one, normalizedHighCutFrequency: cutoffFrequeny, sampleRate: 1000)
        
        XCTAssertTrue(true)
    }
    
    func testLowPassFilter2() {
        let inputVector: [Double] = [1,0,0,0]
        let anotherVector : [Double] = [1,1,1,1]
        
        let cutoffFrequeny = 0.3//50.0/(1000.0/2.0)
        
        let filteredResult = Butterworth().butterworthLowPassForwardBackward(signal: inputVector, order: .one, normalizedHighCutFrequency: cutoffFrequeny, sampleRate: 1000)
        let filteredResult2 = Butterworth().butterworthLowPass(signal: inputVector, order: .one, normalizedHighCutFrequency: cutoffFrequeny, sampleRate: 1000)
        
        //let anotherVector = Array([0.029261017141500444, 0.18754654363414547,   0.46002873455844617, 0.47125250271381103].reversed())

       // let filteredRes3 = Butterworth().butterworthLowPass(signal: inputVector, order: .one, highCutFrequency: cutoffFrequeny, sampleRate: 1000)
        XCTAssertTrue(true)
    }
    
    func testLowPassFilter3() {
        
        let anotherVector = Array([0.029261017141500444, 0.18754654363414547,   0.46002873455844617, 0.47125250271381103].reversed())

        let filteredRes3 = Butterworth().butterworthLowPass(signal: anotherVector, order: .one, normalizedHighCutFrequency: 0.3, sampleRate: 1000).reversed()
        
        XCTAssertTrue(true)
        
    }
}
