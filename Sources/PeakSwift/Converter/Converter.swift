//
//  File.swift
//  
//
//  Created by x on 27.05.23.
//

import Foundation

public protocol Converter {
    
    associatedtype T: Codable
    
    func deserialize(toConvert: String) throws -> T
    
    func serialize(toConvert: T) throws -> String
}
