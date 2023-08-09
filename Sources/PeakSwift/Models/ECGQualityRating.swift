//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 09.08.23.
//

import Foundation

public enum ECGQualityRating {
    
    case unacceptable
    case barelyAcceptable
    case excellent
    
}

extension ECGQualityRating: Codable {
    
}
