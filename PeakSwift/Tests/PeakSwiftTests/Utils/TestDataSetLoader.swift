//
//  File.swift
//  
//
//  Created by x on 26.05.23.
//

import Foundation

class TestDataSetLoader {
    
    let fileReader: FileReader = FileReader()
    
    func getTestData(testDataSet: TestDataSet) throws -> String {
        let fileContent = try fileReader.readFile(fileName: testDataSet.rawValue, fileExtension: .xml)
        return fileContent
    }
}
