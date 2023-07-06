//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 06.07.23.
//

import Foundation

enum Constants {
    
    // The hypothesis is that different architectures lead to slightly different results due to big- and little-endian double representation.
    // Use this accuracy parameter, if comparisions of doubles leads to significant deviations
    static let doubleAccuracy: Double = 0.000000000000001

}
