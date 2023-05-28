//
//  File.swift
//  
//
//  Created by x on 27.05.23.
//

import Foundation

public class JSONConverter: Converter {
    
    public init(){
        
    }
    
    public func deserialize(toConvert: String) throws -> QRSResult {
        
        guard let jsonData = toConvert.data(using: .utf8) else {
            throw ConverterError.JSONConvertionError
        }
        
        do {
            let qrsResult: QRSResult = try JSONDecoder().decode(QRSResult.self, from: jsonData)
            return qrsResult
        } catch {
            throw ConverterError.JSONConvertionError
        }
    }
    
    
}
