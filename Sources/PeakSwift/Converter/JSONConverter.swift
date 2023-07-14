//
//  File.swift
//  
//
//  Created by x on 27.05.23.
//

import Foundation

public class JSONConverter<T: Codable>: Converter {
    
    
    public init(){
        
    }
    
    public func deserialize(toConvert: String) throws -> T {
        
        guard let jsonData = toConvert.data(using: .utf8) else {
            throw ConverterError.JSONConvertionError
        }
        
        do {
            let qrsResult: T = try JSONDecoder().decode(T.self, from: jsonData)
            return qrsResult
        } catch {
            throw ConverterError.JSONConvertionError
        }
    }
    
    public func serialize(toConvert: T) throws -> String {
        
        do {
            let jsonData = try JSONEncoder().encode(toConvert)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            
            if let result = jsonString {
                return result
            } else {
                throw ConverterError.JSONConvertionError
            }
            
        } catch {
            throw ConverterError.JSONConvertionError
        }
    }
    
    
}
