//
//  File.swift
//  
//
//  Created by Nikita Charushnikov on 04.08.23.
//

import Foundation

class TransposedPowerOfTwo: PowerOfTwo {
    
    var value: Int
    
    init(value: Int) {
        let exponent = (0...).first { index in
            value <= MathUtils.powerBase2(exponent: index)
        } ?? 0
        self.value = MathUtils.powerBase2(exponent: exponent)
    }
}
