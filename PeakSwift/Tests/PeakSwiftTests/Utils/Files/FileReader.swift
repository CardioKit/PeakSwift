//
//  File.swift
//  
//
//  Created by x on 25.05.23.
//

import Foundation


public class FileReader {
    
    func readFile(fileName: String, fileExtension: FileExtension) throws -> String {
        let fileUrl = Bundle.module.url(forResource: fileName, withExtension: fileExtension.rawValue)
        
        if let fileUrl = fileUrl {
            let content = try String(contentsOf: fileUrl, encoding: .utf8)
            return content
        } else {
            throw FileError.fileNotFound(fileName)
        }
    }
}
