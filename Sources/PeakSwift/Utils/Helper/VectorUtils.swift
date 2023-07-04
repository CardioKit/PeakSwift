//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 03.07.23.
//

import Foundation
import Accelerate

class VectorUtils {
    
    static func floorVector(_ vector: [Double]) -> [Double] {
        return vector.map {
            floor($0)
        }
    }
}
