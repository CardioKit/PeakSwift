//
//  File.swift
//  
//
//  Created by x on 26.05.23.
//

import Foundation
import PeakSwift

class TestDataSetLoader {
    
    let fileReader: FileReader = FileReader()
    
    func getTestData(testDataSet: QRSDetectionTestDataSet) throws -> QRSExpectedTestResult {
        return try getTestData(fileName: testDataSet.rawValue)
    }
    
    func getTestData(testDataSet: ECGQualityTestDataSet) throws -> SignalQualityExpectedResult {
        return try getTestData(fileName: testDataSet.fileName)
    }
    
    private func getTestData<Result: Codable>(fileName: String) throws -> Result {
        let converter = JSONConverter<Result>()
        let fileContent = try fileReader.readFile(fileName: fileName, fileExtension: .json)
        let result = try converter.deserialize(toConvert: fileContent)
        return result
    }
}
