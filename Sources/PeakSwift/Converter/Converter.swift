//
//  File.swift
//  
//
//  Created by x on 27.05.23.
//

import Foundation

public protocol Converter {
    
    associatedtype T: Decodable
    
    func deserialize(toConvert: String) throws -> T
}
