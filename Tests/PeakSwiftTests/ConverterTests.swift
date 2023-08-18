//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 14.07.23.
//

import Foundation


import XCTest
@testable import PeakSwift


final class ConverterTests: XCTestCase {
    
    func testJSONConverter() throws {
        
        let qrsComplex = [QRSComplex(rPeak: 1, qWave: 2, sWave: 3)]
        let electrocardiogram = Electrocardiogram(ecg: [1,2,3], samplingRate: 1000)
        let resultToConvert = QRSResult(qrsComlexes: qrsComplex, electrocardiogram: electrocardiogram, cleanedElectrocardiogram: electrocardiogram, algorithm: .neurokit)
        
        let converter = JSONConverter<QRSResult>()
        let jsonSerialized = try converter.serialize(toConvert: resultToConvert)
        let actualDeserializedResults = try converter.deserialize(toConvert: jsonSerialized)
        
        XCTAssertEqual(resultToConvert.rPeaks, actualDeserializedResults.rPeaks)
        XCTAssertEqual(resultToConvert.electrocardiogram.ecg, actualDeserializedResults.electrocardiogram.ecg)
        XCTAssertEqual(resultToConvert.cleanedElectrocardiogram.ecg, actualDeserializedResults.cleanedElectrocardiogram.ecg)
        XCTAssertEqual(resultToConvert.electrocardiogram.samplingRate, actualDeserializedResults.electrocardiogram.samplingRate)
        XCTAssertEqual(resultToConvert.cleanedElectrocardiogram.samplingRate, actualDeserializedResults.cleanedElectrocardiogram.samplingRate)
        XCTAssertEqual(resultToConvert.algorithm, actualDeserializedResults.algorithm)
    }
    
}
