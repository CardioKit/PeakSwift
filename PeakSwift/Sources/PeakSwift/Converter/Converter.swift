//
//  File.swift
//  
//
//  Created by x on 27.05.23.
//

import Foundation

public protocol Converter {
    
    func deserialize(toConvert: String) throws -> QRSResult
}
